[← Índice](./README.md)

---

# Incident Response

Guía para manejo de incidentes y recuperación.

## Contenido

- [Niveles de Severidad](#niveles-de-severidad)
- [Procedimiento](#procedimiento)
- [Escalamiento](#escalamiento)
- [Post-Incident](#post-incident)

---

## Niveles de Severidad

| Nivel | Descripción | Ejemplo | SLA |
|-------|------------|--------|-----|
| **SEV1** | Sistema down, sin trabajo | API no responde | 15 min |
| **SEV2** | Funcionalidad crítica afectada | Login no funciona | 1 hora |
| **SEV3** | Funcionamiento degradado | Alta latencia | 4 horas |
| **SEV4** | Issue menor | Bug cosmético | 24 horas |

 [↑ Volver al inicio](#incident-response)

---

## Procedimiento

### 1. Detección

- **Alertas:** Prometheus + PagerDuty
- **Reportes:** Usuarios reportan en Slack

### 2. Confirmación

```bash
# Verificar estado
curl -f https://api.keygo.io/actuator/health
kubectl get pods -n production
kubectl logs -l app=keygo-server -n production --tail=50
```

### 3. Containment

```bash
# Si es código: rollback
helm rollout undo keygo-server -n production

# Si es tráfico: rate limit
# Si es DB: failover
```

### 4. Resolución

```bash
# Aplicar fix
git checkout main
git pull
./mvnw clean package -DskipTests
helm upgrade keygo-server ./helm -n production

# Verificar
curl -f https://api.keygo.io/actuator/health
```

### 5. Comunicación

```bash
# Notificar en Slack
# Canal: #keygo-incidents
```

 [↑ Volver al inicio](#incident-response)

---

## Escalamiento

### Cadena de Escalamiento

1. **On-call Engineer** → Detecta y contiene (15 min)
2. **Tech Lead** → Escalado automático si no hay progreso (30 min)
3. **CTO** → Escalado si afecta múltiples tenants o es financiero (1 hora)
4. **CEO** → Enterprise tenant down por > 2 horas

### Contactos de Emergencia

```yaml
on-call: pagerduty.com/escalation
slack: #keygo-incidents
email: ops@keygo.io
phone: +1-XXX-XXX-XXXX
```

 [↑ Volver al inicio](#incident-response)

---

## Multi-Tenant Incident Response

En Keygo, los incidentes afectan a **tenants específicos**, no a todo el sistema. El procedimiento de response debe aislarse:

### Diagnosticar Scope del Incidente

**Primero: ¿Afecta solo a un tenant o a múltiples?**

```bash
# Verificar qué tenants están afectados
kubectl logs -n production -l app=keygo-server --tail=200 | grep ERROR | cut -d: -f2 | sort | uniq -c

# Si solo 1 tenant:
ERROR: tenant_slug=acme, identity_id=...
ERROR: tenant_slug=acme, identity_id=...

# Si múltiples:
ERROR: tenant_slug=acme, ...
ERROR: tenant_slug=startup_xyz, ...
ERROR: tenant_slug=community, ...
```

### Single-Tenant vs Multi-Tenant Incident

| Tipo | Severidad | Respuesta |
|------|-----------|----------|
| **Single-Tenant** (solo ACME) | SEV2 (para ACME) | 1. Contactar ACME immediatamente 2. Investigar porqué ACME está afectado 3. Aislamiento (rolling back código vs. data del tenant) |
| **Multi-Tenant** (3+ tenants) | SEV1 (para plataforma) | 1. Declarar incident general 2. Activar war room 3. Contactar todos los clientes 4. Rollback inmediato |

### Aislamiento: Rollback por Tenant vs Sistema

```bash
# Opción 1: Problema es de código → rollback del deployment (afecta todos)
helm rollout undo keygo-server -n production
# ⚠️ Esto rollback para TODOS los tenants

# Opción 2: Problema es de datos de 1 tenant → restaurar datos del tenant
# (no requiere rollback del código)
kubectl exec -it psql-pod -n production -- psql -U keygo -d keygo_prod \
  -c "ROLLBACK TRANSACTION WHERE tenant_slug = 'acme';"
```

### Comunicación por Tenant (SLA Diferente)

```bash
# En Slack, por tenant:

# Enterprise (ACME) - SLA 15 min
@ACME_CONTACTS: SEV1 - API authentication failure affecting your account (started 14:32 UTC)
Status: Investigating | ETA: 14:47 UTC | Ticket: INC-12345

# Standard (StartupXYZ) - SLA 1 hour
@STARTUP_CONTACTS: SEV2 - Elevated latency (p95 3.2s) in your APIs
Status: Investigating | ETA: 15:32 UTC | Ticket: INC-12346

# Community - SLA 4 hours
#keygo-community: SEV3 - Optional: Dashboard displays old data
Status: Known issue | Fix in next release
```

 [↑ Volver al inicio](#incident-response)

---

## Post-Incident

### Runbook

1. **Dokumentar**: Qué pasó, por qué, cuánto duró
2. **Root cause analysis**: Por qué pasó en primer lugar?
3. **Timeline**: Eventos por minuto
4. **Action items**: Qué cambios previenen esto?
5. **Owner**: Quién implementa los cambios?

### Plantilla

```markdown
# Incident Report: INC-12345

**Date**: 2025-04-20 14:32 UTC - 14:47 UTC
**Duration**: 15 minutes
**Severity**: SEV1
**Affected**: tenant_slug=acme (1 tenant)
**Status**: RESOLVED

## Timeline

| Time | Event |
|------|-------|
| 14:32 | Alert: Identity endpoint 503 (all requests) |
| 14:33 | On-call investigates; DB connection pool exhausted |
| 14:35 | Checked recent deployment; no code changes |
| 14:40 | Found: JWT signing key rotation started query locks |
| 14:42 | Killed long-running query |
| 14:45 | API recovered |
| 14:47 | All health checks passing |

## Root Cause

JWT key rotation query acquired exclusive lock on `identities` table.
Concurrent login requests waited for lock, exhausting connection pool.

## Resolution

Set lock timeout on key rotation to 30 seconds.
If timeout, queue rotation as background job.

## Action Items

- [ ] Add connection pool monitoring alert (trigger at 80%)
- [ ] Implement timeout on DDL operations
- [ ] Load test key rotation with 100 concurrent logins
- [ ] Document operational procedures for key rotation

**Owner**: @engineer-name | **Due**: 2025-04-27
```

 [↑ Volver al inicio](#incident-response)

## Escalamiento

### Cadenas de Contacto

```
SEV1 → DevOps Lead (15 min) → Engineering Manager (30 min) → CTO (1 hora)
SEV2 → DevOps Lead (1 hora) → Engineering Manager (4 horas)
SEV3 → DevOps Lead (4 horas)
SEV4 → Backlog
```

### Herramientas

| Herramienta | Propósito |
|------------|----------|
| PagerDuty | On-call rotation, paging |
| Slack #keygo-incidents | Comunicación |
| Jira | Seguimiento |

 [↑ Volver al inicio](#incident-response)

---

## Post-Incident

### Post-Mortem

Dentro de 48 horas post-incidente:

1. **Timeline:** Qué pasó y cuándo
2. **Root Cause:** Por qué ocurrió
3. **Impact:** Qué tanto afectó
4. **Action Items:** Cómo prevenir recurrencia
5. **Lessons Learned:** Qué aprendimos

### Template

```markdown
# Post-Mortem: [Título]

## Resumen
[Descripción breve]

## Timeline
- 10:00 Alerta recibida
- 10:15确认问题
- 10:30 Rollback iniciado
- 10:45 Sistema恢复
- 11:00 Resolución completada

## Root Cause
[Descripción técnica]

## Impacto
- Usuarios afectados: X
- Downtime: Y minutos

## Action Items
- [ ] Implementar circuit breaker
- [ ] Agregar más alertas
- [ ] Documentar procedimiento

## Lessons Learned
[Qué salió bien/mal]
```

### Archivar

```bash
# Guardar en docs/incidents/
cp postmortem-YYYYMMDD.md docs/incidents/
```

 [↑ Volver al inicio](#incident-response)

---

[← Índice](./README.md)