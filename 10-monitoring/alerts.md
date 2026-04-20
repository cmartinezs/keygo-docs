[← Índice](./README.md)

---

# Alerts

Reglas de alertas para Prometheus y Grafana.

## Contenido

- [Alertas Principales](#alertas-principales)
- [Service Alerts](#service-alerts)
- [Performance Alerts](#performance-alerts)
- [Infrastructure Alerts](#infrastructure-alerts)
- [Business Alerts](#business-alerts)
- [Notification Channels](#notification-channels)

---

## Alertas Principales

| Alerta | Severidad | Condición | Acción |
|--------|-----------|----------|--------|
| **HighErrorRate** | Critical | error_rate > 1% | Page oncall |
| **HighLatency** | Warning | p99 > 5s | Investigate |
| **LowAvailability** | Critical | availability < 99.9% | Page oncall |
| **HighMemory** | Warning | heap > 80% | Monitor |

 [↑ Volver al inicio](#alerts)

---

## Service Alerts

### API Availability

```yaml
groups:
  - name: keygo-availability
    rules:
      - alert: APIDown
        expr: up{job="keygo-server"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "API is down"
          description: "KeyGo API has been down for 1 minute"

      - alert: APIFlaky
        expr: up{job="keygo-server"} < 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "API is flaky"
          description: "KeyGo API availability is below 100%"
```

### HTTP Errors

```yaml
      - alert: HighErrorRate
        expr: |
          rate(http_requests_total{status=~"5.."}[5m])
          /
          rate(http_requests_total[5m]) > 0.01
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "High error rate"
          description: "Error rate is {{ $value | humanizePercentage }}"

      - alert: High4xxRate
        expr: |
          rate(http_requests_total{status=~"4.."}[5m])
          /
          rate(http_requests_total[5m]) > 0.20
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High 4xx rate"
          description: "4xx rate is {{ $value | humanizePercentage }}"
```

 [↑ Volver al inicio](#alerts)

---

## Performance Alerts

### Latency

```yaml
groups:
  - name: keygo-latency
    rules:
      - alert: HighLatencyP95
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 5
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High p95 latency"
          description: "p95 latency is {{ $value }}s"

      - alert: HighLatencyP99
        expr: histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m])) > 10
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Critical p99 latency"
          description: "p99 latency is {{ $value }}s"

      - alert: SlowEndpoint
        expr: |
          histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m])) by (endpoint)
          > 10
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Slow endpoint detected"
          description: "Endpoint {{ $labels.endpoint }} has p99 latency > 10s"
```

### Throughput

```yaml
      - alert: HighRequestRate
        expr: rate(http_requests_total[5m]) > 1000
        for: 5m
        labels:
          severity: info
        annotations:
          summary: "High request rate"
          description: "Request rate is {{ $value }} req/s"
```

 [↑ Volver al inicio](#alerts)

---

## Infrastructure Alerts

### Database

```yaml
groups:
  - name: keygo-database
    rules:
      - alert: DBConnectionPoolExhausted
        expr: |
          hikaricp_connections_active / hikaricp_connections_max > 0.9
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Database connection pool exhausted"
          description: "Connection pool usage is {{ $value | humanizePercentage }}"

      - alert: DBSlowQuery
        expr: pg_stat_statements_mean_exec_time > 5000
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Slow database query"
          description: "Query execution time is {{ $value }}ms"
```

### JVM

```yaml
groups:
  - name: keygo-jvm
    rules:
      - alert: HighHeapUsage
        expr: |
          jvm_memory_used_bytes{area="heap"}
          /
          jvm_memory_max_bytes{area="heap"} > 0.8
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High heap usage"
          description: "Heap usage is {{ $value | humanizePercentage }}"

      - alert: HighGCPause
        expr: |
          rate(jvm_gc_seconds_sum[5m])
          /
          rate(jvm_gc_seconds_count[5m]) > 0.5
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High GC pause time"
          description: "GC pause time is {{ $value }}s"
```

### Disk

```yaml
      - alert: DiskSpaceLow
        expr: |
          (node_filesystem_avail_bytes{mountpoint="/"}
          /
          node_filesystem_size_bytes{mountpoint="/"}) < 0.15
        for: 10m
        labels:
          severity: critical
        annotations:
          summary: "Disk space low"
          description: "Only {{ $value | humanizePercentage }} disk space available"
```

 [↑ Volver al inicio](#alerts)

---

## Business Alerts

### Authentication

```yaml
groups:
  - name: keygo-business
    rules:
      - alert: HighLoginFailures
        expr: |
          rate(keygo_auth_failures_total[5m])
          /
          rate(keygo_auth_requests_total[5m]) > 0.3
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High login failure rate"
          description: "Login failure rate is {{ $value | humanizePercentage }}"

      - alert: SuspiciousLoginPattern
        expr: |
          sum by (ip) (rate(keygo_auth_failures_total[5m])) > 10
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "Suspicious login pattern"
          description: "IP {{ $labels.ip }} has > 10 failed logins in 5 minutes"

      - alert: TokenRateLimitExceeded
        expr: rate(keygo_rate_limit_exceeded_total[5m]) > 100
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High rate of rate limit exceeded"
          description: "{{ $value }} requests exceeded rate limit"
```

### Usage

```yaml
      - alert: TenantQuotaApproaching
        expr: |
          keygo_tenant_usage_percent > 80
        for: 1h
        labels:
          severity: info
        annotations:
          summary: "Tenant approaching quota"
          description: "Tenant {{ $labels.tenant }} is at {{ $value | humanizePercentage }} of quota"
```

 [↑ Volver al inicio](#alerts)

---

## Notification Channels

### Slack

```yaml
# alertmanager.yml
route:
  group_by: ['alertname', 'severity']
  routes:
    - match:
        severity: critical
      receiver: 'pagerduty'
    - match:
        severity: warning
      receiver: 'slack-warnings'

receivers:
  - name: 'slack-warnings'
    slack_configs:
      - channel: '#keygo-alerts'
        send_resolved: true

  - name: 'slack-info'
    slack_configs:
      - channel: '#keygo-info'
        send_resolved: true

  - name: 'pagerduty'
    pagerduty_configs:
      - service_key: 'PAGERDUTY_KEY'
        severity: '{{ range .Labels }}{{ . }}{{ end }}'
```

### PagerDuty

| Severidad | Urgency | Auto-escalate |
|-----------|----------|---------------|
| Critical | high | 15 min |
| Warning | low | No |
| Info | low | No |

### Escalation

```
Alert Fired
    │
    ├──► 0 min → Slack #keygo-alerts
    │
    ├──► 5 min → If no ack → Page oncall (PagerDuty)
    │
    └──► 15 min → If no ack → Escalate to lead
```

 [↑ Volver al inicio](#alerts)

---

[← Índice](./README.md)