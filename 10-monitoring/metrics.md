[← Índice](./README.md)

---

# Métricas

Catálogo de métricas disponibles en Prometheus.

## Contenido

- [HTTP](#http)
- [JVM](#jvm)
- [Database](#database)
- [Application](#application)
- [Business](#business)
- [Custom](#custom)

---

## HTTP

| Métrica | Tipo | Descripción |
|--------|------|-------------|
| `http_requests_total` | Counter | Total de requests |
| `http_requests_created` | Counter | Requests creados |
| `http_request_duration_seconds` | Histogram | Duración de request |
| `http_request_duration_seconds_bucket` | Histogram | Buckets de duración |
| `http_request_duration_seconds_sum` | Histogram | Suma de duración |
| `http_request_duration_seconds_count` | Histogram | Conteo |

**Labels:**
- `method` — GET, POST, PUT, DELETE, PATCH
- `endpoint` — /api/v1/...
- `status` — 200, 201, 400, 401, 403, 404, 500
- `tenant` — tenant slug
- `error` — tipo de error

**Queries comunes:**

```promql
# Request rate
rate(http_requests_total[5m])

# Error rate
rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m])

# Latency p95
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

# Requests por tenant
sum by (tenant) (rate(http_requests_total[5m]))
```

 [↑ Volver al inicio](#metrics)

---

## JVM

| Métrica | Tipo | Descripción |
|--------|------|-------------|
| `jvm_memory_used_bytes` | Gauge | Memoria usada |
| `jvm_memory_max_bytes` | Gauge | Memoria máxima |
| `jvm_memory_committed_bytes` | Gauge | Memoria comprometida |
| `jvm_gc_seconds_count` | Counter | Conteo de GC |
| `jvm_gc_seconds_sum` | Counter | Tiempo total de GC |
| `jvm_threads_threads` | Gauge | Número de threads |
| `jvm_classes_loaded` | Gauge | Classes cargadas |
| `jvm_classes_unloaded` | Counter | Classes descargadas |

**Labels:**
- `area` — heap, nonheap

**Queries:**

```promql
# Heap usage %
jvm_memory_used_bytes{area="heap"} / jvm_memory_max_bytes{area="heap"} * 100

# GC rate
rate(jvm_gc_seconds_count[5m])

# GC pause time
rate(jvm_gc_seconds_sum[5m]) / rate(jvm_gc_seconds_count[5m])
```

 [↑ Volver al inicio](#metrics)

---

## Database

| Métrica | Tipo | Descripción |
|--------|------|-------------|
| `hikaricp_connections_active` | Gauge | Conexiones activas |
| `hikaricp_connections_idle` | Gauge | Conexiones idle |
| `hikaricp_connections_max` | Gauge | Conexiones max |
| `hikaricp_connections_pending` | Gauge | Conexiones pendientes |
| `hikaricp_connections_acquire_seconds` | Histogram | Tiempo de adquisición |
| `hikaricp_connections_creation_seconds` | Histogram | Tiempo de creación |
| `hikaricp_connections_timeout_total` | Counter | Timeouts |

**Labels:**
- `pool` — nombre del pool

**Queries:**

```promql
# Connection pool usage
hikaricp_connections_active / hikaricp_connections_max * 100

# Wait time
histogram_quantile(0.95, rate(hikaricp_connections_acquire_seconds_bucket[5m]))
```

 [↑ Volver al inicio](#metrics)

---

## Application

| Métrica | Tipo | Descripción |
|--------|------|-------------|
| `process_cpu_seconds_total` | Counter | CPU usado |
| `process_open_fds` | Gauge | File descriptors abiertos |
| `process_max_fds` | Gauge | FD máximos |
| `process_start_time_seconds` | Gauge | Inicio del proceso |
| `process_uptime_seconds` | Gauge | Uptime |

**Queries:**

```promql
# Uptime
time() - process_start_time_seconds

# CPU usage
rate(process_cpu_seconds_total[1m]) * 100
```

 [↑ Volver al inicio](#metrics)

---

## Business

| Métrica | Tipo | Descripción |
|--------|------|-------------|
| `keygo_user_logins_total` | Counter | Logins de usuarios |
| `keygo_auth_failures_total` | Counter | Auth failures |
| `keygo_tokens_issued_total` | Counter | Tokens emitidos |
| `keygo_tokens_revoked_total` | Counter | Tokens revocados |
| `keygo_tenants_total` | Gauge | Total de tenants |
| `keygo_users_total` | Gauge | Total de usuarios |
| `keygo_apps_total` | Gauge | Total de aplicaciones |
| `keygo_rate_limit_exceeded_total` | Counter | Rate limit excedido |

**Queries:**

```promql
# DAU (últimas 24h)
sum(rate(keygo_user_logins_total[24h]))

# Login failure rate
rate(keygo_auth_failures_total[5m]) / rate(keygo_user_logins_total[5m])

# Auth requests rate
rate(keygo_user_logins_total[5m])
```

 [↑ Volver al inicio](#metrics)

---

## Custom (Business & Context-Specific)

### Identity Context

```
identity_authentication_attempts_total{method, status, tenant}
identity_active_sessions{tenant}
identity_password_reset_requests_total{tenant}
identity_session_duration_seconds{tenant}
identity_credential_rotations_total{tenant}
```

### Access Control Context

```
access_control_role_assignments_total{tenant, role}
access_control_permission_denied_total{tenant, resource}
access_control_access_evaluations_total{tenant, result}
access_control_memberships_active{tenant, application}
```

### Organization Context

```
organization_registrations_total{}
organization_active_tenants{}
organization_churn_rate{}
```

### Billing Context

```
billing_charges_initiated_total{tenant, plan}
billing_charges_completed_total{tenant, plan}
billing_charges_failed_total{tenant, plan, error}
billing_revenue{tenant, plan, currency}  # Gauge: revenue recognized
billing_subscription_value{tenant, plan}
```

### Audit Context

```
audit_logs_written_total{context, action}
audit_log_write_latency_seconds{percentile}
audit_events_processed_total{event_type, status}
```

### Platform Context

```
platform_tenant_registrations_total{}
platform_admin_actions_total{action}
platform_api_calls_total{endpoint, method, status}
```

[↑ Volver al inicio](#metrics)

Métricas custom definidas en el código:

### Use Cases

```java
@Metrics
public class CreateUserUseCase {
  // Métricas generadas:
  // - usecase_create_user_success_total
  // - usecase_create_user_failure_total
  // - usecase_create_user_duration_seconds
}
```

**Naming:**
```
usecase_{name}_success_total
usecase_{name}_failure_total
usecase_{name}_duration_seconds
```

### Services

```java
@Service
public class AuthService {
  // - auth_login_success_total
  // - auth_login_failure_total
  // - auth_token_issue_duration_seconds
}
```

 [↑ Volver al inicio](#metrics)

---

## Export

### Prometheus

```
GET /actuator/prometheus
```

### OpenMetrics

```
GET /actuator/prometheus
Accept: application/openmetrics-text
```

### Pushgateway (para jobsbatch)

```bash
# Push métrica
curl -X POST http://pushgateway:9091/metrics/job/batch_job \
  -d @metrics.txt
```

### Remote Write

```yaml
# Configuración
remote_write:
  - url: http://prometheus:9090/api/v1/write
    write_relabel_configs:
      - source_labels: [__name__]
        regex: keygo_.*
        action: keep
```

 [↑ Volver al inicio](#metrics)

---

[← Índice](./README.md)