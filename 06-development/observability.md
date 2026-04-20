[← Índice](./README.md) | [Siguiente >](./bootstrap-filter-routes.md)

---

# Observability Strategy

Documentar cómo observar, monitorear y troubleshoot KeyGo en producción a través de logs, métricas y distributed tracing.

**Stack:** Spring Boot Actuator + Prometheus + Grafana + Jaeger/Zipkin + ELK

## Contenido

- [Los Tres Pilares](#los-tres-pilares)
- [Logging Strategy](#logging-strategy)
- [Metrics Strategy](#metrics-strategy)
- [Distributed Tracing](#distributed-tracing)
- [Health Checks](#health-checks)
- [Dashboards & Alerts](#dashboards--alerts)
- [Troubleshooting](#troubleshooting)
- [Anti-Patterns](#anti-patterns)
- [Checklist](#checklist)

---

## Los Tres Pilares

```
Logs          Métricas         Traces
│             │                │
├─ ¿Qué pasó? ├─ ¿Cuánto? ¿Qué? ├─ ¿Por qué?
├─ Eventos    ├─ Series tiempo │  ├─ Request path
├─ Error msgs │  ├─ Latencia   │  ├─ Dependencies
└─ Context    └─ Errors/sec    └─ Timing breakdown
```

### Cuándo Usar Cada Pilar

| Pregunta | Pilar | Herramienta | Ejemplo |
|----------|-------|-------------|---------|
| ¿Qué error ocurrió en el login? | Logs | Kibana/ELK | Error 401: Invalid JWT signature |
| ¿Cuántas requests/seg? ¿Tasa de error? | Métricas | Prometheus/Grafana | 1000 req/s, 2% error rate |
| ¿Por qué el login tardó 2 segundos? | Traces | Jaeger | Auth service (15ms) → DB (80ms) → Email (100ms) |

[↑ Volver al inicio](#observability-strategy)

---

## Logging Strategy

### Niveles de Logging

```
TRACE  → Debug verbose (nunca en production)
DEBUG  → Development details (dev, staging)
INFO   → Important events (login, deploy, config changes)
WARN   → Recoverable issues (retry, fallback)
ERROR  → Failures, exceptions (alert)
FATAL  → System down (emergency restart needed)
```

### Configuration: application-prod.yml

```yaml
logging:
  level:
    root: INFO
    io.cmartinezs.keygo: INFO
    io.cmartinezs.keygo.domain: DEBUG           # ← Domain logic visible
    org.springframework: WARN
    org.springframework.security: INFO
    org.springframework.web.servlet.mvc.method.annotation.RequestResponseBodyMethodProcessor: WARN
  
  file:
    name: /var/log/keygo/app.log
    max-size: 100MB
    max-history: 30                             # Keep 30 days
  
  pattern:
    console: "%d{ISO8601} [%thread] %-5level %logger{36} - %msg%n"
    file: "%d{ISO8601} [%thread] %-5level %logger{36} - %X{traceId} - %msg%n"  # Correlation ID
```

### Structured Logging with MDC (Mapped Diagnostic Context)

MDC inyecta valores contextuales en todos los logs de un request — permite rastrear operaciones cross-service.

```java
@Component
public class CorrelationIdFilter extends OncePerRequestFilter {
  
  @Override
  protected void doFilterInternal(
      HttpServletRequest request,
      HttpServletResponse response,
      FilterChain chain) throws ServletException, IOException {
    
    String traceId = request.getHeader("X-Trace-ID");
    if (traceId == null) {
      traceId = UUID.randomUUID().toString();
    }
    
    MDC.put("traceId", traceId);
    response.addHeader("X-Trace-ID", traceId);
    
    try {
      chain.doFilter(request, response);
    } finally {
      MDC.clear();
    }
  }
}
```

**Resultado:** Todos los logs del request incluyen `traceId`:

```
2026-04-20 10:30:45 [http-nio-8080-exec-1] INFO  CreateUserUseCase - 550e8400 - User created: john@example.com
2026-04-20 10:30:46 [http-nio-8080-exec-1] INFO  EmailService - 550e8400 - Sending welcome email to john@example.com
2026-04-20 10:30:47 [http-nio-8080-exec-1] INFO  AuditLog - 550e8400 - AUDIT: user.created by admin-user
```

**Búsqueda rápida:**
```bash
grep "550e8400" /var/log/keygo/app.log  # ← Todo lo relacionado con ese request
```

### Logging Domain Events

```java
@Component
public class CreateUserUseCase {
  
  private static final Logger log = LoggerFactory.getLogger(CreateUserUseCase.class);
  
  public User execute(CreateUserRequest request, TenantContext context) {
    log.info("Creating user: email={}", request.getEmail());
    
    User user = User.builder()
        .email(request.getEmail())
        .username(request.getUsername())
        .tenantId(context.getTenantId())
        .build();
    
    User saved = userRepository.save(user);
    
    log.info("User created successfully: userId={}, email={}", 
        saved.getId(), saved.getEmail());
    
    // Aquí se emite domain event (ver 03-design/domain-events.md)
    user.recordThat(new UserCreatedEvent(saved.getId(), saved.getEmail()));
    
    return saved;
  }
}
```

### Error Logging en Controllers

```java
@PostMapping("/users")
public ResponseEntity<?> createUser(@Valid @RequestBody CreateUserRequest request) {
  try {
    User user = createUserUseCase.execute(request, tenantContext);
    return ResponseEntity.status(201).body(CreateUserResponse.of(user));
  } catch (DomainException e) {
    log.warn("Business rule violation: code={}, message={}", 
        e.getCode(), e.getMessage());
    return ErrorResponse.of(e);
  } catch (Exception e) {
    log.error("Unexpected error creating user", e);  // ← Includes stack trace
    return ErrorResponse.internalError("USER_CREATION_FAILED");
  }
}
```

### Log Aggregation: ELK Stack

```
Filebeat → Logstash → Elasticsearch → Kibana
```

**filebeat.yml:**
```yaml
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/keygo/app.log
  
  processors:
    - add_kubernetes_metadata:
        in_cluster: true

output.logstash:
  hosts: ["logstash:5000"]
```

**Logstash pipeline (parse logs):**
```
filter {
  grok {
    match => { "message" => 
      "%{TIMESTAMP_ISO8601:timestamp} \[%{DATA:thread}\] %{LOGLEVEL:level} %{DATA:logger} - %{DATA:traceId} - %{GREEDYDATA:msg}" 
    }
  }
  
  if [level] == "ERROR" {
    mutate { add_tag => [ "alert" ] }
  }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    index => "keygo-%{+YYYY.MM.dd}"
  }
}
```

**Kibana:** Query logs por traceId, nivel, logger, tenant_id, etc.

[↑ Volver al inicio](#observability-strategy)

---

## Metrics Strategy

### Prometheus Endpoint

```
GET /actuator/prometheus
```

Expone métricas en formato Prometheus:

```
# HELP http_requests_total Total HTTP requests
# TYPE http_requests_total counter
http_requests_total{method="POST",path="/api/v1/tenants/*/users",status="201"} 1023
http_requests_total{method="POST",path="/api/v1/tenants/*/users",status="400"} 15
http_requests_total{method="POST",path="/api/v1/tenants/*/users",status="403"} 5

# HELP http_request_duration_seconds Request latency
# TYPE http_request_duration_seconds histogram
http_request_duration_seconds_bucket{path="/api/v1/tenants/*/users",le="0.5"} 950
http_request_duration_seconds_bucket{path="/api/v1/tenants/*/users",le="1.0"} 1018
http_request_duration_seconds_bucket{path="/api/v1/tenants/*/users",le="5.0"} 1023

# HELP jvm_memory_used_bytes JVM memory used
# TYPE jvm_memory_used_bytes gauge
jvm_memory_used_bytes{area="heap"} 1536000000
jvm_memory_used_bytes{area="nonheap"} 51200000
```

### Custom Metrics: Use Case Performance

Medir latencia y tasa de éxito de cada use case con AOP:

```java
@Component
@Aspect
public class UseCaseMetrics {
  
  private final MeterRegistry meterRegistry;
  
  public UseCaseMetrics(MeterRegistry meterRegistry) {
    this.meterRegistry = meterRegistry;
  }
  
  @Around("@annotation(io.cmartinezs.keygo.api.common.Metrics)")
  public Object measureUseCase(ProceedingJoinPoint joinPoint) throws Throwable {
    String useCaseName = joinPoint.getSignature().getName();
    long startTime = System.nanoTime();
    
    try {
      Object result = joinPoint.proceed();
      meterRegistry.counter("usecase.success", "name", useCaseName).increment();
      return result;
    } catch (Exception e) {
      meterRegistry.counter("usecase.failure", "name", useCaseName).increment();
      throw e;
    } finally {
      long duration = System.nanoTime() - startTime;
      meterRegistry.timer("usecase.duration", "name", useCaseName)
          .record(duration, TimeUnit.NANOSECONDS);
    }
  }
}
```

**Uso:**
```java
@Component
public class CreateUserUseCase {
  
  @Metrics
  public User execute(CreateUserRequest request, TenantContext context) {
    // ... implementation
  }
}
```

**Prometheus output:**
```
usecase_success_total{name="CreateUserUseCase"} 1023
usecase_failure_total{name="CreateUserUseCase"} 5
usecase_duration_seconds_bucket{name="CreateUserUseCase",le="1.0"} 1018
```

### Key Metrics to Monitor

| Métrica | Tipo | Umbral de Alerta | Acción |
|---------|------|------------------|--------|
| `http_requests_total{status="5xx"}` | Counter | > 1/sec | Page oncall |
| `http_request_duration_seconds{quantile="0.99"}` | Histogram | > 5s | Investigate slow query |
| `jvm_memory_used_bytes{area="heap"}` | Gauge | > 80% | Monitor GC, risk of OOM |
| `db_connection_pool_size_active` | Gauge | > 90% | Investigate slow queries |
| `authentication_failures_total` | Counter | Spike | Check for brute force |
| `api_rate_limit_exceeded_total` | Counter | Spike | Review tenant quotas |

[↑ Volver al inicio](#observability-strategy)

---

## Distributed Tracing

### Configuración: Spring Cloud Sleuth + Micrometer

```yaml
# application-prod.yml
management:
  tracing:
    sampling:
      probability: 0.1  # Sample 10% (balance overhead vs coverage)
  otlp:
    tracing:
      endpoint: http://jaeger-collector:4317
```

Spring auto-instrumenta HTTP calls, DB queries, y message brokers.

### Explicit Spans para Operaciones Complejas

```java
@Component
public class UserProvisioningService {
  
  private final Tracer tracer;
  
  public void provisionUser(User user, Tenant tenant) {
    Span span = tracer.nextSpan().name("provision_user").start();
    
    try (Tracer.SpanInScope ws = tracer.withSpan(span)) {
      span.event("fetch_directory_info");
      DirectoryUser dirUser = directoryClient.fetch(user.getExternalId());
      
      span.event("assign_roles");
      assignRoles(user, dirUser.getGroups());
      
      span.event("send_notification");
      notificationService.sendWelcomeEmail(user);
      
      span.tag("user.id", user.getId().toString());
      span.tag("directory", "okta");
    } finally {
      span.finish();
    }
  }
}
```

### Trace Visualization (Jaeger)

```
User Request (total: 250ms)
├─ Authentication (15ms)
├─ Database Query (80ms)
│  └─ Flyway Migration Check (5ms)
├─ Domain Logic (50ms)
├─ Email Service (100ms)
└─ Audit Log (5ms)
```

[↑ Volver al inicio](#observability-strategy)

---

## Health Checks

### Liveness & Readiness Endpoints

```yaml
# Configuración automática en Spring Boot 3.x
management:
  health:
    livenessState:
      enabled: true
    readinessState:
      enabled: true
```

### Custom Health Indicator

```java
@Component
public class CustomHealthIndicator extends AbstractHealthIndicator {
  
  private final UserRepository userRepository;
  
  @Override
  protected void doHealthCheck(Health.Builder builder) {
    try {
      // Quick DB ping
      long count = userRepository.count();
      builder.up()
          .withDetail("user_count", count);
    } catch (Exception e) {
      builder.down()
          .withDetail("error", e.getMessage());
    }
  }
}
```

### Endpoints

```bash
# ¿Está vivo el proceso?
curl http://localhost:8080/actuator/health/liveness
# → 200 OK

# ¿Está listo para recibir tráfico?
curl http://localhost:8080/actuator/health/readiness
# → 200 OK (o 503 Service Unavailable)

# Detalles completos
curl http://localhost:8080/actuator/health
```

**Response:**
```json
{
  "status": "UP",
  "components": {
    "db": {
      "status": "UP",
      "details": { "database": "PostgreSQL" }
    },
    "flyway": {
      "status": "UP",
      "details": { "flywayVersion": "9.22.3" }
    },
    "customHealth": {
      "status": "UP",
      "details": { "user_count": 1523 }
    }
  }
}
```

[↑ Volver al inicio](#observability-strategy)

---

## Dashboards & Alerts

### Grafana Panels

#### 1. Request Rate & Errors

```
Metrics:
  - rate(http_requests_total[5m])              # Requests/sec
  - rate(http_requests_total{status="5xx"}[5m])  # Errors/sec

Alerts:
  - error_rate > 0.01  # > 1% errors
```

#### 2. Latency Percentiles

```
Metrics:
  - histogram_quantile(0.50, http_request_duration_seconds)  # p50
  - histogram_quantile(0.95, http_request_duration_seconds)  # p95
  - histogram_quantile(0.99, http_request_duration_seconds)  # p99
```

#### 3. Database Performance

```
Metrics:
  - db_connection_pool_size_active
  - rate(sql_execution_seconds_count[5m])
  - histogram_quantile(0.95, sql_execution_seconds)
```

#### 4. JVM Health

```
Metrics:
  - jvm_memory_used_bytes / jvm_memory_max_bytes  # Heap %
  - rate(jvm_gc_seconds_count[5m])                # GC frequency
  - jvm_gc_seconds{quantile="0.95"}               # p95 pause time
```

### Prometheus Alert Rules

```yaml
# prometheus-rules.yml
groups:
  - name: keygo
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status="5xx"}[5m]) > 0.01
        for: 1m
        annotations:
          summary: "High error rate ({{ $value | humanizePercentage }})"
          runbook: "https://internal.keygo.io/runbooks/high-error-rate"
      
      - alert: HighLatency
        expr: histogram_quantile(0.99, http_request_duration_seconds) > 5
        for: 5m
        annotations:
          summary: "p99 latency > 5s"
      
      - alert: DiskSpaceLow
        expr: node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes < 0.15
        for: 10m
        annotations:
          summary: "Only {{ humanize $value }}% disk available"
```

### PagerDuty Integration

```yaml
# alertmanager.yml
route:
  receiver: 'pagerduty'
  group_by: ['alertname', 'cluster']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 12h

receivers:
  - name: 'pagerduty'
    pagerduty_configs:
      - service_key: 'INTEGRATION_KEY'
        description: '{{ .GroupLabels.alertname }}'
```

[↑ Volver al inicio](#observability-strategy)

---

## Troubleshooting

### High Memory Usage

1. **Verificar actividad de GC:**
   ```bash
   curl http://localhost:8080/actuator/metrics/jvm.gc.pause | jq '.'
   ```

2. **Identificar memory leak:**
   - Heap dump: `jmap -dump:live,format=b,file=dump.hprof <PID>`
   - Analizar: Eclipse MAT o jhat

3. **Restart si es necesario:**
   ```bash
   kubectl rollout restart deployment/keygo-server -n production
   ```

### High Latency

1. **Verificar queries lentas:**
   ```sql
   -- Slowest queries
   SELECT query, calls, mean_exec_time
   FROM pg_stat_statements
   ORDER BY mean_exec_time DESC
   LIMIT 10;
   ```

2. **Verificar connection pool:**
   ```bash
   curl http://localhost:8080/actuator/prometheus | grep db_connection
   ```

3. **Verificar GC pauses:**
   ```bash
   curl http://localhost:8080/actuator/metrics/jvm.gc.pause | jq '.measurements[] | select(.statistic=="MAX")'
   ```

### Error Rate Spike

1. **Ver cambios recientes:**
   ```bash
   git log --oneline -20
   ```

2. **Revisar logs para patrones:**
   ```bash
   grep "ERROR" /var/log/keygo/app.log | tail -100
   ```

3. **Verificar fallos de autenticación:**
   ```bash
   grep "INVALID_CREDENTIALS\|PERMISSION_DENIED" /var/log/keygo/app.log | wc -l
   ```

[↑ Volver al inicio](#observability-strategy)

---

## Anti-Patterns

### ❌ Logging Sensitive Data

```java
// MAL: Nunca registres passwords, tokens, keys
log.info("User password: {}", user.getPassword());
log.info("JWT token: {}", jwtToken);
log.info("API key: {}", apiKey);
```

### ✅ Log Only Safe Data

```java
// BIEN: Solo IDs y información de contexto
log.info("User authenticated: userId={}", user.getId());
log.info("JWT token issued for userId={}", extractSubject(jwtToken));
```

---

### ❌ Sampling Only Errors

```yaml
# MAL: Pierdes trazas de success → imposible correlacionar
sample_errors_only: true
```

### ✅ Balanced Sampling

```yaml
# BIEN: Sample ~10% incluyendo success y errors
sampling:
  probability: 0.1
```

---

### ❌ High-Cardinality Metrics

```java
// MAL: Explosion de dimensiones (1M+ valores únicos)
meterRegistry.counter("http_request", 
    "user_id", user.getId(),  
    "method", method).increment();
```

### ✅ Use Labels Wisely

```java
// BIEN: Baja cardinalidad (50 dimensiones max)
meterRegistry.counter("http_request", 
    "method", method,
    "path", normalizePath(path),
    "status", status).increment();
```

[↑ Volver al inicio](#observability-strategy)

---

## Checklist

- [ ] **Logging:** Structured logs con correlation IDs en MDC
- [ ] **Metrics:** `/actuator/prometheus` expone métricas custom
- [ ] **Tracing:** Distributed traces exportados a Jaeger
- [ ] **Health:** Liveness & readiness checks configurados
- [ ] **Alerts:** Prometheus rules para error rate, latency, disk
- [ ] **Dashboards:** Grafana panels para métricas clave
- [ ] **No PII:** Logs no contienen passwords, tokens, emails
- [ ] **Sampling:** Tracing sampling balanceado (10-50%)
- [ ] **Retention:** Logs rotados, métricas retenidas 15+ días

---

## Referencias

- [Spring Boot Actuator](https://spring.io/guides/gs/actuator-service/)
- [Prometheus Java Client](https://github.com/prometheus/client_java)
- [Spring Cloud Sleuth + Micrometer](https://spring.io/projects/spring-cloud-sleuth)
- [Jaeger Tracing](https://www.jaegertracing.io/)
- [ELK Stack Documentation](https://www.elastic.co/guide/en/elastic-stack/current/index.html)
- [Architecture](./architecture.md) — Stack tecnológico y patrones
- [Debugging Guide](./debugging-guide.md) — Troubleshooting práctico

---

[← Índice](./README.md) | [Siguiente >](./bootstrap-filter-routes.md)
