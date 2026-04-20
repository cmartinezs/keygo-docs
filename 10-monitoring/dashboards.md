[← Índice](./README.md)

---

# Dashboards

Paneles de Grafana para monitoreo del sistema.

## Contenido

- [Dashboards Principales](#dashboards-principales)
- [Service Health](#service-health)
- [API Performance](#api-performance)
- [Database](#database)
- [JVM](#jvm)
- [Business Metrics](#business-metrics)

---

## Dashboards Principales

| Dashboard | Propósito | URL |
|----------|-----------|-----|
| **Service Health** | Disponibilidad, uptime | Grafana |
| **API Performance** | Latencia, throughput | Grafana |
| **Database** | Connections, queries | Grafana |
| **JVM** | Heap, GC, threads | Grafana |
| **Business** | Users, tenants, auth | Grafana |

 [↑ Volver al inicio](#dashboards)

---

## Service Health

### Panels

```yaml
- title: "API Availability"
  type: stat
  query: up{job="keygo-server"}
  thresholds:
    - value: 1, color: green
    - value: 0, color: red

- title: "Uptime"
  type: graph
  query: time() - keygo_server_start_time_seconds

- title: "HTTP Status Codes"
  type: graph
  query: rate(http_requests_total[5m]) by (status)

- title: "Error Rate"
  type: gauge
  query: rate(http_requests_total{status=~"5.."}[5m]) / rate(http_requests_total[5m]) * 100
  thresholds:
    - value: 1, color: yellow
    - value: 5, color: red
```

### Alerts

- Error rate > 1% → Slack #keygo-alerts
- Error rate > 5% → PagerDuty

 [↑ Volver al inicio](#dashboards)

---

## API Performance

### Panels

```yaml
- title: "Request Rate (RPS)"
  type: graph
  query: rate(http_requests_total[5m])

- title: "Latency p50"
  type: graph
  query: histogram_quantile(0.50, rate(http_request_duration_seconds_bucket[5m]))

- title: "Latency p95"
  type: graph
  query: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))

- title: "Latency p99"
  type: graph
  query: histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))

- title: "Slowest Endpoints"
  type: table
  query: topk(10, histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m])) by (endpoint))
```

### Latency by Plan

| Plan | p95 | p99 |
|------|-----|-----|
| Free | < 500ms | < 2s |
| Pro | < 200ms | < 1s |
| Enterprise | < 100ms | < 500ms |

 [↑ Volver al inicio](#dashboards)

---

## Database

### Panels

```yaml
- title: "Active Connections"
  type: graph
  query: pg_stat_activity_count{state="active"}

- title: "Connection Pool"
  type: gauge
  query: hikaricp_connections_active / hikaricp_connections_max * 100

- title: "Slow Queries"
  type: table
  query: |
    topk(10,
      pg_stat_statements.mean_exec_time
    )

- title: "Query Rate"
  type: graph
  query: rate(pg_stat_statements.calls[5m])

- title: "Database Size"
  type: stat
  query: pg_database_size_bytes
```

### Thresholds

| Métrica | Warning | Critical |
|---------|--------|----------|
| Connections | > 70% | > 90% |
| Query time | > 1s | > 5s |
| DB size growth | > 10%/day | > 50%/day |

 [↑ Volver al inicio](#dashboards)

---

## JVM

### Panels

```yaml
- title: "Heap Memory Used"
  type: graph
  query: jvm_memory_used_bytes{area="heap"}

- title: "Heap Memory Usage %"
  type: gauge
  query: jvm_memory_used_bytes{area="heap"} / jvm_memory_max_bytes{area="heap"} * 100

- title: "GC Rate"
  type: graph
  query: rate(jvm_gc_seconds_count[5m])

- title: "GC Pause Time"
  type: graph
  query: rate(jvm_gc_seconds_sum[5m]) / rate(jvm_gc_seconds_count[5m])

- title: "Thread Count"
  type: graph
  query: jvm_threads_threads

- title: "Open File Descriptors"
  type: gauge
  query: process_open_fds
```

### Thresholds

| Métrica | Warning | Critical |
|---------|--------|----------|
| Heap usage | > 70% | > 85% |
| GC pause | > 500ms | > 2s |
| Threads | > 500 | > 1000 |

 [↑ Volver al inicio](#dashboards)

---

## Business Metrics

### Panels

```yaml
- title: "Active Users (DAU)"
  type: stat
  query: sum(rate(keygo_user_logins_total[24h]))

- title: "Active Tenants"
  type: stat
  query: keygo_tenants_total{status="active"}

- title: "Auth Requests"
  type: graph
  query: rate(keygo_auth_requests_total[5m])

- title: "Failed Logins"
  type: graph
  query: rate(keygo_auth_failures_total[5m])

- title: "Token Issuance"
  type: graph
  query: rate(keygo_tokens_issued_total[5m])

- title: "API Usage by Tenant"
  type: table
  query: topk(10, sum(rate(http_requests_total[5m])) by (tenant))
```

### Business SLAs

Referencia: `09-operations/slas.md`

 [↑ Volver al inicio](#dashboards)

---

## Grafana Configuration

```yaml
# grafana/provisioning/dashboards/dashboards.yml
apiVersion: 1

providers:
  - name: 'KeyGo Dashboards'
    folder: 'KeyGo'
    type: file
    options:
      path: /var/lib/grafana/dashboards
```

### Variables

```yaml
- name: environment
  type: query
  query: label_values(up, environment)

- name: tenant
  type: query
  query: label_values(http_requests_total{environment="$environment"}, tenant)
```

 [↑ Volver al inicio](#dashboards)

---

[← Índice](./README.md)