# KeyGo Docs

Documentación unificada de Keygo — fuente canónica compartida para backend y frontend.

Este repositorio es un **submódulo** de los repos de backend y frontend.

> [!IMPORTANT]
> **Scope reconciliation — 2026-09-07.** KeyGo's target responsibility is now explicitly `INIT-KEYGO-001 / CAP-IAM-001 — Identity, Tenancy & Access Management`. The existing Billing context remains documented because it is part of the current/legacy implementation, but subscription/entitlement target ownership moves to `INIT-SUB-001 / CAP-SUB-001` and payment-execution target ownership moves to `INIT-PAY-001 / CAP-PAY-001`. See [Scope Reconciliation](./01-discovery/scope-reconciliation-2026-09-07.md) and [Capability Extraction Boundaries](./03-design/capability-extraction-boundaries.md). This does **not** imply that code/data migration is complete.

---

## 🎉 SDLC Framework Complete

**All 13 documentation phases have existing coverage and DDD/Multi-Tenancy material.**

✅ Discovery → Requirements → Design → Data Model → Planning → Development → Testing → Deployment → Operations → Monitoring → Feedback

**Current documentary assets include**:
- 7 historically/currently modeled bounded contexts, with `Billing` now explicitly classified as an embedded context under extraction/reconciliation rather than target KeyGo ownership;
- DDD principles (aggregates, value objects, events, ACL) across architecture, development, and testing;
- multi-tenant isolation patterns from design through operations;
- context-specific monitoring and incident response procedures;
- user feedback loops and requirements traceability.

> Documentation coverage or implemented breadth is not an Initiative Lifecycle gate. `INIT-KEYGO-001` remains lifecycle-reconciliation work under ADÜMÜN governance.

---

## Cómo navegar

La documentación sigue el ciclo de vida del producto (SDLC):

| Carpeta | Fase | Contenido |
|---------|------|-----------|
| `01-discovery/` | Discovery | Contexto, visión, alcance, actores, necesidades y scope reconciliation |
| `02-requirements/` | Requirements | RF, RNF, scope boundaries, trazabilidad |
| `03-design/` | Design & Process + UI | Flujos de sistema, bounded contexts, capability extraction, wireframes, design system |
| `04-data-model/` | Data Model | Entidades, ERD, flujos de datos; incluye estado legacy de Billing durante migración |
| `05-planning/` | Planning | Roadmap, epics, versioning |
| `06-development/` | Development | Arquitectura, APIs, coding standards, ADRs |
| `07-testing/` | Testing | Estrategia de testing, planes, seguridad |
| `08-deployment/` | Deployment | CI/CD, ambientes, release process |
| `09-operations/` | Operations | Runbooks, incident response, SLA |
| `10-monitoring/` | Monitoring | Métricas, alertas, dashboards |
| `11-feedback/` | Feedback | Retrospectivas, user feedback, process improvements |

---

## Para empezar

- [¿Qué es Keygo?](./01-discovery/README.md) — Contexto, visión y actores del sistema
- [Scope Reconciliation 2026-09-07](./01-discovery/scope-reconciliation-2026-09-07.md) — Target IAM boundary and extracted commercial capabilities
- [Capability Extraction Boundaries](./03-design/capability-extraction-boundaries.md) — Entity/API/UI ownership and staged migration model
- [Plan de trabajo](./macro-plan.md) — Estado detallado de cada fase
- [Framework SDLC](./00-documental-planning/sdlc-framework.md) — Cómo está organizada esta documentación
- [Domain-Driven Design in Keygo](./06-development/architecture.md) — Bounded contexts, aggregates, anti-corruption layers

---

## Estado

Documentary coverage exists across all 13 SDLC phases. The current strategic scope has been reconciled but the implementation still contains commercial Billing concerns that must be inventoried and migrated through a separately governed process. See [macro-plan.md](./macro-plan.md) for historical/current phase detail and the reconciliation documents above for current target authority.
