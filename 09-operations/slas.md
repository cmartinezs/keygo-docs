[← Índice](./README.md)

---

# SLAs

Acuerdos de nivel de servicio y métricas de disponibilidad.

> **Nota:** Los SLAs están definidos en el modelo de datos como entidades configurables por plan de suscripción. Este documento referencia dicha fuente y proporciona ejemplos base del MVP.

## Contenido

- [Modelo de Datos](#modelo-de-datos)
- [Ejemplos de Planes MVP](#ejemplos-de-planes-mvp)
- [Métricas Disponibles](#métricas-disponibles)
- [Monitoreo](#monitoreo)
- [Reportes](#reportes)

---

## Modelo de Datos

Los SLAs se almacenan en la base de datos y pueden evolucionar sin cambios en código:

| Entidad | Descripción |
|--------|-------------|
| `SubscriptionPlan` | Plan de suscripción con sus SLAs |
| `SlaConfiguration` | Configuración de SLA por plan |
| `SlaVersion` | Historial de versiones de SLAs |

**Referencia:** Ver `04-data-model/` para el modelo completo de suscripciones.

###RF15 — Gestión de Suscripciones

> **Desde:** `02-requirements/priority-matrix.md`

RF15 establece que la gestión de suscripciones es **Must**, lo cual incluye los planes y sus SLAs asociados.

↑ [Volver al inicio](#slas)

---

## Ejemplos de Planes MVP

> **Nota:** Estos son ejemplos base. Los SLAs reales se definen en la base de datos y pueden cambiar por configuración.

### Plan: Free (MVP)

| SLA | Valor | Notas |
|-----|-------|-------|
| **Disponibilidad** | 99.5% | 3.6 horas downtime/mes |
| **p95 Latencia** | < 500ms | |
| **p99 Latencia** | < 2s | |
| **Soporte** | Comunidad | Email/foro |
| **Incidentes** | Best effort | |

### Plan: Pro (MVP)

| SLA | Valor | Notas |
|-----|-------|-------|
| **Disponibilidad** | 99.9% | 43 minutos downtime/mes |
| **p95 Latencia** | < 200ms | |
| **p99 Latencia** | < 1s | |
| **Soporte** | Email | response 4h |
| **Incidentes** | Prioritario | |

### Plan: Enterprise (MVP)

| SLA | Valor | Notas |
|-----|-------|-------|
| **Disponibilidad** | 99.99% | 4 minutos downtime/mes |
| **p95 Latencia** | < 100ms | |
| **p99 Latencia** | < 500ms | |
| **Soporte** | 24/7 | response 15min |
| **Incidentes** | Dedicated | account manager |

### Tiempos de Resolución (todos los planes)

| Severidad | SLA |
|-----------|-----|
| SEV1 | 15 min |
| SEV2 | 1 hora |
| SEV3 | 4 horas |
| SEV4 | 24 horas |

 [↑ Volver al inicio](#slas)

---

## Versiones de SLAs

Los SLAs pueden cambiar con el tiempo. Cada cambio genera una versión:

```sql
-- Ver historial de SLAs de un plan
SELECT * FROM sla_version
WHERE plan_id = 'free_plan'
ORDER BY valid_from DESC;
```

**Referencia del modelo:** `04-data-model/` → entidades `SubscriptionPlan`, `SlaConfiguration`, `SlaVersion`.

↑ Volver al inicio](#slas)

---

## Métricas

### Disponibilidad

```
Availability = (Total Minutes - Downtime Minutes) / Total Minutes * 100
```

**Medición:**
- Endpoint: `/api/v1/platform/health`
- Frecuencia: cada 60 segundos
- Fuente: Prometheus: `up{job="keygo-server"}`

### Latencia

| Percentil | Query |
|-----------|-------|
| p50 | `histogram_quantile(0.50, http_request_duration_seconds)` |
| p95 | `histogram_quantile(0.95, http_request_duration_seconds)` |
| p99 | `histogram_quantile(0.99, http_request_duration_seconds)` |

### Error Rate

```
Error Rate = 5xx Requests / Total Requests * 100
```

**Alertas:**
- Warning: > 0.1%
- Critical: > 1%

 [↑ Volver al inicio](#slas)

---

## Monitoreo

### Dashboards

| Dashboard | Propósito |
|-----------|----------|
| **Service Health** | Disponibilidad, uptime |
| **API Performance** | Latencia, throughput |
| **Database** | Connections, query time |
| **JVM** | Heap, GC, threads |

### Alertas

| Alerta |条件 | Severidad |
|--------|-----|----------|
| HighErrorRate | error_rate > 1% | critical |
| HighLatency | p99 > 5s | warning |
| LowAvailability | availability < 99.9% | critical |
| HighMemory | heap > 80% | warning |

### Notificaciones

- **SEV1-2:** PagerDuty → Phone
- **SEV3-4:** Slack → #keygo-alerts

 [↑ Volver al inicio](#slas)

---

## Reportes

### Monthly Report

Generado el día 1 de cada mes:

```markdown
# Monthly Report - [Mes]

## Disponibilidad
- Uptime: 99.9%
- Incidents: 0

## Performance
- p95 Latencia: 150ms
- p99 Latencia: 300ms
- Error Rate: 0.05%

## Usage
- Total Requests: 1M
- Peak RPS: 500

## Incidents
| ID | Severity | Resolution |
|----|---------|-----------|
```

###可用性 Calculation

```prometheus
# Query para Prometheus
100 - (sum(rate(http_requests_total{status="5xx"}[5m])) / (sum(rate(http_requests_total[5m])) * 100
```

 [↑ Volver al inicio](#slas)

---

[← Índice](./README.md)