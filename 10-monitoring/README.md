[← HOME](../README.md)

---

# Monitoring

Fase de observabilidad: métricas, alertas y dashboards, con énfasis en monitoreo por Bounded Context y detección de anomalías multi-tenant.

## Contenido

- [Resumen](#resumen)
- [Metrics](./metrics.md) — Catálogo: HTTP, JVM, BD, aplicación, negocio, custom
- [Alerts](./alerts.md) — Reglas de alerta por severidad y contexto
- [Dashboards](./dashboards.md) — Paneles de Grafana: general, por contexto, por tenant

---

## Resumen

| Artefacto | Descripción |
|-----------|-------------|
| [metrics.md](./metrics.md) | HTTP, JVM, Database, Application, Business metrics |
| [alerts.md](./alerts.md) | Reglas de alerta, escalamiento, SLA breach detection |
| [dashboards.md](./dashboards.md) | Grafana panels: Platform, Identity, Access Control, Billing, Audit |

---

## Cómo Navegar

1. **Métricas**: Lee [metrics.md](./metrics.md) para entender qué se expone
2. **Alertas**: Consulta [alerts.md](./alerts.md) para rules en Prometheus
3. **Dashboards**: Usa [dashboards.md](./dashboards.md) para visualizar en Grafana

---

## Monitoreo por Bounded Context

Cada contexto tiene su propio set de métricas y alertas:

### Identity Context
```promql
# Autenticación (tasa de éxito/fallo)
rate(identity_authentication_attempts_total[5m])
identity_authentication_failure_rate

# Sesiones activas por tenant
sum by (tenant) (identity_active_sessions)

# Password reset requests (spike detection)
rate(identity_password_reset_requests[5m])
```

### Access Control Context
```promql
# Role assignments (audit)
rate(access_control_role_assignments_total[5m])

# Permission denials
rate(access_control_permission_denied[5m]) by (tenant, resource)

# Memberships (users por app)
sum by (application, tenant) (access_control_memberships)
```

### Billing Context
```promql
# Charge completion rate
rate(billing_charges_completed_total[5m]) / rate(billing_charges_initiated_total[5m])

# Revenue impact (if charges fail)
rate(billing_charges_failed_total[5m]) * 100

# Tenant subscriptions
sum by (tenant, plan) (billing_subscriptions_active)
```

### Audit Context
```promql
# Audit log write latency
histogram_quantile(0.95, rate(audit_log_write_duration_seconds_bucket[5m]))

# Audit throughput
rate(audit_logs_written_total[5m])
```

### Platform Context
```promql
# Tenant registrations
rate(platform_tenant_registrations_total[1d])

# Active tenants
count(platform_active_tenants)

# Platform admin actions
rate(platform_admin_actions_total[5m])
```

---

## Multi-Tenant Alerting

Diferentes tenants pueden tener diferentes umbrales:

```yaml
# Enterprise (ACME)
- alert: ACMEHighLatency
  expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket{tenant="acme"}[5m])) > 1
  for: 5m
  severity: SEV2
  
# Standard (StartupXYZ)
- alert: StartupHighLatency
  expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket{tenant="startup_xyz"}[5m])) > 2
  for: 10m
  severity: SEV3
  
# Community (Free)
- alert: CommunityHighLatency
  expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket{tenant="community"}[5m])) > 3
  for: 15m
  severity: SEV4
```

---

[← HOME](../README.md) | [Siguiente >](./metrics.md)