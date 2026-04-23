# Master Plan: TEMPLATE- Generation

**Objetivo**: Generar todos los TEMPLATE-* para `ddd-hexagonal-ai-template/01-templates/`  
**Fecha de inicio**: 2026-04-22  
**Total**: 42 archivos en 12 lotes (A–L)

---

## Naming Convention

`TEMPLATE-NNN-{nombre}.md` — donde NNN es número secuencial 3 dígitos

**Estructura obligatoria de cada archivo**:
```
[← Índice](./README.md) | [< Anterior] | [Siguiente >]

---

# {DOCUMENT NAME}

{1-2 sentence purpose}

## Contents
{Section index}

---

## Section 1
{Content}
[↑ Back to top](#document-name)

---

## Section 2
...

## Paso a Paso

1. Step 1
2. Step 2

## Ejemplo

### Ejemplo Proyecto Alpha (SaaS de tareas)
{...}

### Ejemplo Proyecto Beta (Marketplace B2B)
{...}

---

## Completion Checklist

### Deliverables
- [ ] Item

### Sign-Off
- [ ] Prepared by: [Name, Date]
- [ ] Reviewed by: [Stakeholders, Date]
- [ ] Approved by: [Product Manager, Date]

---

## Phase Discipline Rules
{Reglas específicas de la fase}

---

## Tips
{3-5 tips}

---

[← Índice](./README.md) | [< Anterior] | [Siguiente >]
```

---

## LOTE A — Fase 1: Discovery (`01-discovery/`)

| # | Archivo | Status | Completable | Mapping 1:1 from Keygo |
|---|---|---|---|---|
| 001 | `TEMPLATE-001-context-motivation.md` | :white_check_mark: | Human & AI | ✅ context-motivation.md + system-vision.md |
| 002 | `TEMPLATE-002-actors-and-personas.md` | :white_check_mark: | AI + human | ✅ actors.md |
| 003 | `TEMPLATE-003-scope-and-boundaries.md` | :white_check_mark: | Human | ✅ system-scope.md + needs-expectations.md |
| 004 | `TEMPLATE-004-transition-and-phases.md` | :white_check_mark: | Human | ✅ next-steps.md |
| 005 | `TEMPLATE-005-discovery-closure-and-validation.md` | :white_check_mark: | Human | ✅ final-reflection.md |
| 006 | `TEMPLATE-006-decision-rationale.md` | :white_check_mark: | Human | ✅ final-analysis.md |

---

## LOTE B — Fase 2: Requirements (`02-requirements/`)

| # | Archivo | Status | Completable |
|---|---|---|---|
| 004 | `TEMPLATE-004-functional-requirements.md` | :white_check_mark: | AI + human |
| 005 | `TEMPLATE-005-non-functional-requirements.md` | :white_check_mark: | Human & AI |
| 006 | `TEMPLATE-006-scope-matrix.md` | :white_check_mark: | Human |
| 007 | `TEMPLATE-007-traceability-matrix.md` | :white_check_mark: | AI |

---

## LOTE C — Fase 3: Design (`03-design/`)

| # | Archivo | Status | Completable |
|---|---|---|---|
| 008 | `TEMPLATE-008-system-flows.md` | :white_check_mark: | AI + human |
| 009 | `TEMPLATE-009-ui-ux-design.md` | :white_check_mark: | Human + AI |
| 010 | `TEMPLATE-010-process-decisions.md` | :white_check_mark: | Human |

---

## LOTE D — Fase 4: Data Model (`04-data-model/`)

| # | Archivo | Status | Completable |
|---|---|---|---|
| 011 | `TEMPLATE-011-entities-and-relationships.md` | :white_check_mark: | Human |
| 012 | `TEMPLATE-012-erd-diagram.md` | :white_check_mark: | Human |
| 013 | `TEMPLATE-013-data-flows.md` | :white_check_mark: | AI + human |

---

## LOTE E — Fase 5: Planning (`05-planning/`)

| # | Archivo | Status | Completable |
|---|---|---|---|
| 014 | `TEMPLATE-014-roadmap.md` | :white_check_mark: | Human |
| 015 | `TEMPLATE-015-epics.md` | :white_check_mark: | Human |
| 016 | `TEMPLATE-016-versioning-strategy.md` | :white_check_mark: | Human |

---

## LOTE F — Fase 6: Development (`06-development/`)

| # | Archivo | Status | Completable |
|---|---|---|---|
| 017 | `TEMPLATE-017-architecture.md` | :white_check_mark: | Human & AI |
| 018 | `TEMPLATE-018-api-design.md` | :white_check_mark: | Human & AI |
| 019 | `TEMPLATE-019-coding-standards.md` | :white_check_mark: | Human |
| 020 | `TEMPLATE-020-adr.md` | :white_check_mark: | Human & AI |

---

## LOTE G — Bounded Contexts (`03-design/bounded-contexts/`)

Directorio nuevo. Cada archivo: Propósito BC → Agregados → Entidades → VOs → Servicios → Puertos → Eventos → Relaciones BC.

| # | Archivo | BC | Status |
|---|---|---|---|
| 021 | `TEMPLATE-021-bc-identity.md` | Identity (Core) | :white_check_mark: |
| 022 | `TEMPLATE-022-bc-access-control.md` | Access Control (Core) | :white_check_mark: |
| 023 | `TEMPLATE-023-bc-organization.md` | Organization (Supporting) | :white_check_mark: |
| 024 | `TEMPLATE-024-bc-client-applications.md` | Client Applications (Supporting) | :white_check_mark: |
| 025 | `TEMPLATE-025-bc-billing.md` | Billing (Supporting) | :white_check_mark: |
| 026 | `TEMPLATE-026-bc-audit.md` | Audit (Supporting) | :white_check_mark: |
| 027 | `TEMPLATE-027-bc-platform.md` | Platform (Supporting) | :white_check_mark: |

---

## LOTE H — Fase 7: Testing (`07-testing/`)

| # | Archivo | Status | Completable |
|---|---|---|---|
| 028 | `TEMPLATE-028-test-strategy.md` | :white_check_mark: | Human |
| 029 | `TEMPLATE-029-test-plan.md` | :white_check_mark: | Human |
| 030 | `TEMPLATE-030-security-testing.md` | :white_check_mark: | Human |

---

## LOTE I — Fase 8: Deployment (`08-deployment/`)

| # | Archivo | Status | Completable |
|---|---|---|---|
| 031 | `TEMPLATE-031-ci-cd-pipeline.md` | :white_check_mark: | Human |
| 032 | `TEMPLATE-032-environments.md` | :white_check_mark: | Human |
| 033 | `TEMPLATE-033-release-process.md` | :white_check_mark: | Human |

---

## LOTE J — Fase 9: Operations (`09-operations/`)

| # | Archivo | Status | Completable |
|---|---|---|---|
| 034 | `TEMPLATE-034-runbooks.md` | :white_check_mark: | Human |
| 035 | `TEMPLATE-035-incident-response.md` | :white_check_mark: | Human |
| 036 | `TEMPLATE-036-sla.md` | :white_check_mark: | Human |

---

## LOTE K — Fase 10: Monitoring (`10-monitoring/`)

| # | Archivo | Status | Completable |
|---|---|---|---|
| 037 | `TEMPLATE-037-metrics.md` | :white_check_mark: | Human |
| 038 | `TEMPLATE-038-alerts.md` | :white_check_mark: | Human |
| 039 | `TEMPLATE-039-dashboards.md` | :white_check_mark: | Human |

---

## LOTE L — Fase 11: Feedback (`11-feedback/`)

| # | Archivo | Status | Completable |
|---|---|---|---|
| 040 | `TEMPLATE-040-user-feedback.md` | :white_check_mark: | Human |
| 041 | `TEMPLATE-041-retrospectives.md` | :white_check_mark: | Human |
| 042 | `TEMPLATE-042-lessons-learned.md` | :white_check_mark: | Human |

---

## Progress Summary

| Lote | Fase | Archivos | Completados | Status |
|------|------|----------|-------------|--------|
| A | Discovery | 6 | 6/6 | ✅ **100% Complete: Full 1:1 Mapping from Keygo** |
| B | Requirements | 4 | 0/4 |
| C | Design | 3 | 3/3 |
| D | Data Model | 3 | 3/3 |
| E | Planning | 3 | 3/3 |
| F | Development | 4 | 4/4 |
| G | Bounded Contexts | 7 | 7/7 |
| H | Testing | 3 | 3/3 |
| I | Deployment | 3 | 3/3 |
| J | Operations | 3 | 3/3 |
| K | Monitoring | 3 | 3/3 |
| L | Feedback | 3 | 3/3 |
| **TOTAL** | | **42** | **42/42** |

---

---

## LOTE A: COMPLETADO ✅

**Fecha de completitud**: 2026-04-22  
**Mapeo**: 9 archivos Keygo → 6 templates agnósticos  
**Método**: Mapeo 1:1 con generalización + ejemplos completables (100%-0% flexible)

### Archivos Creados

1. ✅ `TEMPLATE-001-context-motivation.md` — Visión, misión, objetivos estratégicos, principios críticos
2. ✅ `TEMPLATE-002-actors-and-personas.md` — Actores, personas, fronteras de acceso, jerarquía
3. ✅ `TEMPLATE-003-scope-and-boundaries.md` — Alcance, riesgos, criterios de aceptación, trazabilidad
4. ✅ `TEMPLATE-004-transition-and-phases.md` — Fases post-Discovery, secuenciación, handoff
5. ✅ `TEMPLATE-005-discovery-closure-and-validation.md` — Validación, sign-off, readiness
6. ✅ `TEMPLATE-006-decision-rationale.md` — Rationale de decisiones clave, trade-offs

### Mapeo 1:1 Completado

| Keygo Real | Template | Mapeo |
|---|---|---|
| context-motivation.md | TEMPLATE-001 | ✅ |
| system-vision.md | TEMPLATE-001 | ✅ (integrado) |
| actors.md | TEMPLATE-002 | ✅ |
| system-scope.md | TEMPLATE-003 | ✅ |
| needs-expectations.md | TEMPLATE-003 | ✅ |
| next-steps.md | TEMPLATE-004 | ✅ |
| final-reflection.md | TEMPLATE-005 | ✅ |
| final-analysis.md | TEMPLATE-006 | ✅ |
| README.md | — | Referencia |

---

## Insights from Keygo Discovery Documentation

### TEMPLATE-001 Enhancements
**From `keygo/01-discovery/`**:

**Add Strategic Objectives Section**:
- Include 7+ strategic objectives with KPIs
- Each objective should have: goal statement, strategic importance, measurable KPI
- Example from Keygo: "Centralizar la gestión de identidad y acceso" → KPI: "≥90% de aplicaciones autenticando vía Keygo a los 12 meses"
- Map each objective to specific value drivers

**Add Key Capabilities Overview**:
- Bridge between Vision/Mission and detailed Requirements
- High-level description of what the system will be able to do
- 6-8 capabilities (not implementation details)
- Example: "Autenticación de usuarios y aplicaciones", "Aislamiento entre organizaciones", "Control de acceso basado en roles"

**Add Strategic Principles/Critical Points**:
- Foundational design principles that guide all decisions
- Must be non-negotiable from the start
- Example from Keygo: "Aislamiento multi-tenant como restricción de seguridad P0", "Estándares abiertos como base de integración"
- 5-7 critical points

---

### TEMPLATE-002 Enhancements
**From `keygo/01-discovery/actors.md`**:

**Add Explicitly Excluded Actors Section**:
- List actors that are NOT in scope for MVP
- Document the rationale for exclusion (to be revisited later)
- Example from Keygo: "Sistemas externos de directorio corporativo" (LDAP, AD sync)
- Prevents scope creep and sets clear expectations

**Add Actor Hierarchy Visual**:
- Tree structure showing dependencies and relationships
- Example from Keygo:
  ```
  Administrador de la plataforma
  ├── Administrador de organización
  │   ├── Usuario final
  │   └── Aplicación cliente
  └── Equipo operativo de Keygo
  ```

**Add Access Boundaries per Actor**:
- Explicit table of what each actor CAN and CANNOT do
- Critical for security and multi-tenant systems
- Example: Actor X can see/modify [these resources] but cannot [cross tenant, see other orgs, etc.]
- Maps to scope boundaries and prevents misunderstandings

---

### TEMPLATE-003 Enhancements
**From `keygo/01-discovery/system-scope.md` and `needs-expectations.md`**:

**Add Functional Capabilities Traceability Matrix**:
- Maps each capability to its contribution toward strategic objectives
- Example table: Rows=Capabilities, Columns=Objectives, Cells=🟢 (primary), 🟡 (secondary)
- Ensures every capability has clear strategic value
- Prevents feature creep

**Add MVP vs Future Phases Distinction**:
- Explicit table/section separating what's in MVP from what's deferred
- Use clear grouping: "MVP" vs "Phase 2" vs "Phase 3+" vs "Future Consideration"
- Example: Core auth in MVP, SSO integrations in Phase 2, Advanced analytics in Phase 3
- Prevents ambitious scope creep

**Add Operational Limits Table**:
- Quantified constraints for the system (if applicable)
- Example from Keygo: Users per org, Apps per org, Audit retention, SLA %
- Helps with capacity planning and sets expectations
- Placeholders acceptable if exact numbers TBD

**Add Acceptance Criteria**:
- High-level criteria showing how you'll know each requirement is met
- Not test cases, but acceptance signals
- Example: "Admin can complete user lifecycle without ops team intervention"
- Bridges Requirements and Testing phases

**Add Risks & Mitigations Matrix**:
- Identify 6-8 key risks that could prevent success
- For each: probability, impact, mitigation strategy, responsible owner
- Example from Keygo: Low adoption risk, access-crossing security risk, performance degradation
- Moves risks from unknown unknowns to managed knowns

---

## Legenda

- :hourglass: = Pending
- :construction: = In progress
- :white_check_mark: = Completed
- :x: = Cancelled