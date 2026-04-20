[← HOME](../README.md)

---

# Operations

Fase de operación en producción: runbooks, incident response y SLAs, con énfasis en multi-tenancy y aislamiento.

## Contenido

- [Resumen](#resumen)
- [Runbook](./runbook.md) — Guía operativa: deployment, monitoreo, escalamiento
- [Incident Response](./incident-response.md) — Manejo de incidentes por severidad, escalamiento
- [SLAs](./slas.md) — Acuerdos de nivel de servicio por tenant y feature
- [Support](./support.md) — Sistema de tickets de soporte

---

## Resumen

| Artefacto | Descripción |
|-----------|-------------|
| [runbook.md](./runbook.md) | Guía de operaciones: deployment en K8s, monitoreo, escalamiento, multi-tenancy |
| [incident-response.md](./incident-response.md) | Niveles de severidad, procedimiento de response, escalamiento, post-incident |
| [slas.md](./slas.md) | SLAs por tenant, métricas, uptime targets |
| [support.md](./support.md) | Tickets, escalamiento, SLA de respuesta |

---

## Cómo Navegar

1. **Setup**: Lee [runbook.md](./runbook.md) para deployment y operación regular
2. **Incidentes**: Consulta [incident-response.md](./incident-response.md) para qué hacer cuando falla
3. **SLAs**: Revisa [slas.md](./slas.md) para entender compromisos con clientes
4. **Soporte**: Usa [support.md](./support.md) para manejo de tickets

---

## Multi-Tenancy en Operaciones

En un sistema multi-tenant como Keygo, las operaciones deben considerar que diferentes tenants pueden estar en diferentes estados:

### Aislamiento de Incidentes

Un incidente en un tenant **NO debe afectar a otros tenants**:

**❌ MAL**: "El sistema está down"
**✅ BIEN**: "El tenant ACME está experimentando 5xx; otros tenants están OK"

Ver [incident-response.md](./incident-response.md) para procedimiento de aislamiento.

### SLAs Diferenciados

Diferentes tenants pueden tener diferentes SLAs:

```
Tenant: ACME (Enterprise)
- SLA de disponibilidad: 99.99%
- SLA de respuesta: 15 min (SEV1)

Tenant: StartupXYZ (Standard)
- SLA de disponibilidad: 99.5%
- SLA de respuesta: 1 hora (SEV1)

Tenant: Community (Free)
- SLA de disponibilidad: 95%
- SLA de respuesta: 4 horas (SEV1)
```

Ver [slas.md](./slas.md) para detalles.

---

[← HOME](../README.md) | [Siguiente >](./runbook.md)