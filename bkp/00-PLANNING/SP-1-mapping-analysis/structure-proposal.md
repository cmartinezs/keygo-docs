# 🏗️ STRUCTURE PROPOSAL - Arquitectura Unificada

**Estado**: SP-1 - Propuesta arquitectónica  
**Fecha**: 2026-04-19

---

## VISIÓN GENERAL

Transformar la estructura **paralela back/front** en una estructura **unificada por dominio**, eliminando redundancia y facilitando el mantenimiento.

### Antes (Actual)
```
00-BACKEND/          01-FRONTEND/
├── 01-product/      ├── 01-product/
├── 02-functional/   ├── 02-functional/
├── 03-architecture/ ├── 03-architecture/
├── 04-decisions/    ├── 04-decisions/
├── 06-quality/      ├── 06-quality/
├── 07-operations/   ├── 07-operations/
├── 08-reference/    └── 08-reference/
└── 09-ai/

Problema: Cada repo repite estructura, pero contenido diverge
```

### Después (Propuesto)
```
keygo-docs/          (unified, submódulo en back y front)
├── 01-product/
├── 02-functional/
├── 03-architecture/
├── 04-decisions/
├── 06-quality/
├── 07-operations/
├── 08-reference/
└── OVERRIDES/       (optional tech-specific overrides)
    ├── backend-specifics/
    └── frontend-specifics/

Los repos back/front usan esto como submódulo + agrega sus overrides
```

---

## ESTRUCTURA PROPUESTA EN DETALLE

### 📦 01-PRODUCT (Visión & Requisitos - Agnóstico)

**Objetivo**: Definir QUÉ estamos construyendo, no CÓMO

```
01-product/
├── README.md                           (entry point)
├── vision.md                          (product vision statement)
├── glossary.md                        (SINGLE SOURCE OF TRUTH - unified)
├── requirements.md                    (functional & non-functional requirements)
├── constraints-and-limitations.md     (new - pain points, constraints)
├── dependency-map.md                  (feature dependencies, roadmap links)
├── diagrams/
│   ├── README.md
│   ├── use-cases.md                   (actor-action diagrams)
│   ├── authentication-flow.md         (platform + tenant auth)
│   ├── billing-flow-contractor.md     (contractor billing model)
│   ├── account-flow.md                (account management)
│   └── tenant-management-flow.md      (tenant lifecycle)
└── (ARCHIVE) old-versions/            (historical proposals, rationale)
```

**Key Changes**:
- ✅ **Unified glossary**: único source of truth para términos
- ✅ **Agnóstico**: diagrams sin implementación detalles
- ✅ **Requirements claros**: separados de requisitos técnicos

**Archivos a Mover**:
- FROM 01-FRONTEND/01-product/02-role-model.md → Merge into glossary.md
- FROM 01-FRONTEND/01-product/01-vision-and-scope.md → Merge into vision.md
- FROM 00-BACKEND/01-product/pain-points.md → Rename to constraints-and-limitations.md

---

### 📚 02-FUNCTIONAL (Feature Guides & How-Tos - Tech-Specific)

**Objetivo**: Cómo usar/implementar cada feature

```
02-functional/
├── README.md                          (entry point, index)
├── 00-quickstart.md                   (new - "how to contribute" guide)
├── authentication/
│   ├── README.md
│   ├── 01-authentication-architecture.md    (agnóstico)
│   ├── 02-authentication-backend-impl.md    (backend specifics)
│   ├── 03-authentication-frontend-impl.md   (frontend specifics)
│   └── 04-authentication-integration.md     (how they work together)
├── billing/
│   ├── README.md
│   ├── 01-billing-model.md                  (contractor model - agnóstico)
│   ├── 02-billing-backend-impl.md           (backend specifics)
│   ├── 03-billing-frontend-impl.md          (frontend UI flows)
│   └── 04-payment-integration.md            (Stripe, etc.)
├── account-management/
│   ├── README.md
│   ├── 01-account-model.md
│   ├── 02-account-backend.md
│   └── 03-account-frontend.md
├── tenant-management/
│   ├── README.md
│   ├── 01-tenant-model.md
│   ├── 02-tenant-backend.md
│   └── 03-tenant-frontend.md
├── admin-console/
│   ├── README.md
│   ├── 01-admin-model.md
│   ├── 02-admin-backend.md
│   └── 03-admin-frontend.md
├── email-notifications/
│   ├── README.md
│   ├── 01-notification-model.md
│   ├── 02-email-templates.md
│   └── 03-testing-emails.md
└── (STYLE) styling-and-conventions.md (shared UI/UX patterns)
```

**Key Changes**:
- ✅ **Organized by feature** (not tech stack)
- ✅ **Cross-referenced sections**: backend ↔ frontend implementation
- ✅ **Agnóstico + Tech-specific**: architecture first, then implementations
- ✅ **New**: payment integration as separate doc

**Archivos a Mover**:
- FROM 00-BACKEND/02-functional/authentication-flow.md → SPLIT into auth/
- FROM 01-FRONTEND/02-functional/04-auth-flow.md → Merge into auth/
- FROM 01-FRONTEND/02-functional/05-billing-flow.md → Merge into billing/
- FROM 01-FRONTEND/02-functional/02-authentication.md → Merge into auth/03
- FROM 01-FRONTEND/02-functional/03-api-conventions.md → Move to 08-reference

---

### 🏛️ 03-ARCHITECTURE (Technical Patterns & Design)

**Objetivo**: Cómo está diseñado el sistema

```
03-architecture/
├── README.md                          (entry point, design philosophy)
├── system-design/
│   ├── README.md
│   ├── 01-system-overview.md          (high-level architecture)
│   ├── 02-multi-tenant-architecture.md (data isolation, request context)
│   ├── 03-monorepo-structure.md       (adr-002)
│   └── 04-security-bootstrap.md
├── patterns/
│   ├── README.md
│   ├── design-patterns.md             (catalog of patterns)
│   ├── validation-strategy.md         (data validation approach)
│   ├── error-handling.md              (uniform error handling)
│   ├── authorization-patterns.md      (scopes, permission model)
│   └── api-design-patterns.md         (REST conventions)
├── data-and-persistence/
│   ├── README.md
│   ├── 01-data-model.md               (ER diagrams, schema design)
│   ├── 02-database-strategy.md        (SQL, indexes, performance)
│   ├── 03-multi-tenant-data-isolation.md
│   └── 04-migration-strategy.md       (versioning, safety)
├── security/
│   ├── README.md
│   ├── 01-authentication-architecture.md (OAuth2/OIDC contract)
│   ├── 02-authorization-architecture.md (multi-scope RBAC)
│   ├── 03-session-management.md
│   ├── 04-secret-management.md        (keys, credentials)
│   └── 05-security-guidelines.md      (general best practices)
├── observability/
│   ├── README.md
│   ├── 01-observability-strategy.md   (monitoring, logging, tracing)
│   ├── 02-performance-targets.md      (SLOs, optimization)
│   └── 03-alerting-strategy.md
└── provisioning/
    ├── README.md
    └── 01-user-provisioning.md        (identity lifecycle)
```

**Key Changes**:
- ✅ **Organized by concern** (system design, patterns, data, security, observability, provisioning)
- ✅ **Consolidated multi-tenant docs**: single authoritative source
- ✅ **Error handling included**: patterns section
- ✅ **Performance targets**: observability section, not separate

**Archivos a Mover**:
- FROM 00-BACKEND/03-architecture/ → Reorganize per structure
- FROM 01-FRONTEND/03-architecture/ → Reference backend docs
- FROM 04-decisions/rfcs/restructure-multitenant/ → Summarize in multi-tenant-architecture.md
- FROM 04-decisions/rfcs/rbac-multi-scope-alignment/ → Summarize in authorization-patterns.md

---

### 📋 04-DECISIONS (RFCs, ADRs, Design Decisions)

**Objetivo**: Registrar decisiones arquitectónicas con contexto

```
04-decisions/
├── README.md                          (entry point, ADR format guide)
├── adr/
│   ├── README.md
│   ├── adr-001-oauth2-error-classification.md
│   ├── adr-002-hexagonal-modular-monorepo.md
│   ├── adr-003-multi-tenant-identity-model.md
│   ├── adr-004-bearer-jwt-auth.md
│   ├── adr-005-documentation-structure.md
│   └── adr-006-unification-of-documentation.md      (NEW - this initiative)
├── rfcs/
│   ├── README.md (index of active RFCs)
│   ├── billing-refactor/           (9 files - keep organized)
│   ├── account-ui-proposal/        (6 files)
│   ├── rbac-multi-scope/           (5 files)
│   ├── geoip-sessions/             (5 files)
│   ├── critical-action-reason/     (5 files)
│   └── (others as needed)
├── decisions-log.md                (NEW - chronological log with status)
└── archived-decisions/             (RFCs closed, superseded)
```

**Key Changes**:
- ✅ **Lightweight index**: decisions-log.md tracks status
- ✅ **ADR for documentation unification**: make it official
- ✅ **Keep RFCs organized**: by topic, not scattered
- ✅ **Archive superseded decisions**: don't delete, just archive

**Archivos a Mover**:
- Keep existing 04-decisions structure
- Add decisions-log.md for tracking
- Create adr-006 for unification initiative

---

### ✅ 06-QUALITY (Testing, Security, Code Standards)

**Objetivo**: Cómo asegurar calidad

```
06-quality/
├── README.md                          (entry point, quality philosophy)
├── testing/
│   ├── README.md
│   ├── 01-test-strategy.md            (unit, integration, e2e)
│   ├── 02-integration-testing.md      (database, API)
│   ├── 03-authentication-test-plan.md (security test plan)
│   ├── 04-load-testing.md             (capacity planning)
│   └── 05-testing-environments.md
├── security/
│   ├── README.md
│   ├── 01-security-guidelines.md      (general best practices)
│   ├── 02-hardening-guide.md          (OWASP, checklist)
│   ├── 03-dependency-management.md    (vulnerability scanning)
│   ├── 04-secret-management.md        (keys, credentials)
│   └── 05-code-review-checklist.md    (security review points)
├── code-standards/
│   ├── README.md
│   ├── 01-code-style-backend.md       (Java conventions)
│   ├── 02-code-style-frontend.md      (JavaScript/React conventions)
│   └── 03-naming-conventions.md       (databases, APIs, code)
├── accessibility/
│   ├── README.md
│   ├── 01-wcag-compliance.md          (general A11y standards)
│   └── 02-regional-requirements.md    (Chile-specific, others)
└── monitoring/
    ├── README.md
    └── 01-debugging-guide.md          (how to debug, common issues)
```

**Key Changes**:
- ✅ **Consolidated security**: general + hardening
- ✅ **Accessibility elevated**: separate section
- ✅ **Testing organized**: strategy, implementations, environments
- ✅ **Debugging in quality**: not operations

**Archivos a Mover**:
- FROM 06-quality/ → Reorganize per structure
- FROM 01-FRONTEND/06-quality/03-accessibility-chile.md → Merge into accessibility/

---

### 🚀 07-OPERATIONS (Deployment, Runbooks, Infrastructure)

**Objetivo**: Cómo correr el sistema en producción

```
07-operations/
├── README.md                          (entry point, operations philosophy)
├── development-setup/
│   ├── README.md
│   ├── 01-development-setup.md        (prerequisites, local env)
│   ├── 02-database-seeding.md         (test data setup)
│   ├── 03-ide-configuration.md        (IntelliJ, VSCode setup)
│   └── 04-common-issues.md            (troubleshooting)
├── infrastructure/
│   ├── README.md
│   ├── 01-docker-setup.md
│   ├── 02-environment-variables.md
│   └── 03-key-signing-and-jwks.md
├── deployment/
│   ├── README.md
│   ├── 01-deployment-strategy.md      (CI/CD overview)
│   ├── 02-backend-deployment.md       (Java/Maven specifics)
│   ├── 02-frontend-deployment.md      (Node/React specifics) [NEW]
│   ├── 03-database-migrations.md      (schema versioning, safety)
│   └── 04-rollback-procedures.md
├── production-runbooks/
│   ├── README.md
│   ├── 01-production-runbook-backend.md
│   ├── 02-production-runbook-frontend.md [NEW]
│   ├── 03-incident-response.md        (general process)
│   ├── 04-authentication-incidents.md (auth-specific)
│   ├── 05-billing-incidents.md
│   └── 06-database-operations.md      (backup, restore)
├── security-operations/
│   ├── README.md
│   ├── 01-oauth2-configuration.md     [NEW]
│   ├── 02-secret-rotation.md
│   └── 03-security-incident-response.md
└── monitoring-and-alerts/
    ├── README.md
    └── 01-monitoring-setup.md         (dashboards, alerting)
```

**Key Changes**:
- ✅ **Frontend deployment added**: was missing
- ✅ **Production runbooks expanded**: backend + frontend
- ✅ **Development setup improved**: clearer organization
- ✅ **Security operations**: separate from general ops
- ✅ **Database operations**: migration + backup/restore

**Archivos a Mover**:
- FROM 07-operations/ → Reorganize per structure
- FROM 01-FRONTEND/07-operations/ → Merge into backend runbooks

---

### 📖 08-REFERENCE (APIs, Data Models, Examples)

**Objetivo**: Catálogos y referencias técnicas

```
08-reference/
├── README.md                          (entry point, reference guide)
├── api/
│   ├── README.md
│   ├── 01-api-conventions.md          [MOVE from 02-functional/]
│   ├── 02-endpoint-catalog.md         (complete endpoint reference)
│   ├── 03-error-catalog.md            (unified error codes)
│   ├── 04-error-handling-guide.md     [NEW - how to handle errors]
│   └── 05-authentication-api.md       (auth endpoints specific)
├── data-models/
│   ├── README.md
│   ├── 01-data-model-overview.md
│   ├── 02-entity-relationships.md     (ER diagrams)
│   ├── 03-data-type-dictionary.md
│   ├── 04-database-schema.md          (current schema, indexes)
│   └── 05-migration-history.md
├── integration-examples/
│   ├── README.md
│   ├── 01-hosted-login-handoff.md
│   ├── 02-supabase-integration.md
│   └── 03-common-workflows.md
└── glossary-and-terminology.md         [REFERENCE to 01-product/glossary.md]
```

**Key Changes**:
- ✅ **API conventions moved here**: from 02-functional
- ✅ **Error handling guide added**: NEW
- ✅ **Data models organized**: schema, types, relationships
- ✅ **Reference to product glossary**: not duplicated

**Archivos a Mover**:
- FROM 01-FRONTEND/02-functional/03-api-conventions.md → 08-reference/api/
- FROM 00-BACKEND/08-reference/ → Reorganize per structure

---

### 🤖 09-AI (Agent Context & Logs - TOOLS, NOT USER DOCS)

**Objective**: AI agent configuration, logs, learnings (NOT for end users)

**Recomendación**: Mover a `.claude/` o similar

```
.claude/agents/
├── agents.md                    (agent configuration)
├── agents-changelog.md          (agent history)
├── workflow.md                  (agent workflow)
├── inconsistencies/             (tracked issues)
├── lessons-learned/             (patterns, anti-patterns)
└── task-registry/               (task management)
```

**Por qué**:
- 09-AI no es documentación de usuario
- Pertenece a herramientas de desarrollo
- 140+ archivos de logs/context obscurecen docs reales

---

### 📦 OVERRIDES (Optional - Backend/Frontend Specific)

**Objetivo**: Documentación específica de tech stack sin duplicación

```
OVERRIDES/
├── backend-specifics/
│   ├── README.md
│   ├── spring-framework-patterns.md
│   ├── maven-build.md
│   ├── java-conventions.md
│   └── database-migration-flyway.md
└── frontend-specifics/
    ├── README.md
    ├── react-patterns.md
    ├── npm-build.md
    ├── javascript-conventions.md
    └── webpack-configuration.md
```

**Alternativa**: Estos podrían vivir en repos back/front, no en keygo-docs

---

### 📥 99-ARCHIVE (Historical, Deprecated)

```
99-archive/
├── deprecated/                  (old API docs, old data models)
├── historical-plans/            (documentation reorg 2026, etc.)
├── research/                    (billing research, admin dashboard research)
├── email-templates/             (keep for reference if moved from 02-functional)
└── CLEANUP-LOG.md               (what was archived and why)
```

**Nota**: Limpiar archivos que sean obsoletos (pre-2026 docs)

---

## NAVEGACIÓN Y DISCOVERABILITY

### INDEX.md (Nuevo - Homepage)
```
# Keygo Documentation

**One source of truth for Keygo backend and frontend teams**

## Start Here
- [Product Vision](01-product/vision.md) - What we're building
- [Quick Start](02-functional/00-quickstart.md) - Getting started
- [Architecture Overview](03-architecture/system-design/01-system-overview.md) - How it works

## By Role
- **Product Manager**: 01-product/, 04-decisions/adr/
- **Backend Developer**: 03-architecture/, 02-functional/(backend-impl), 07-operations/
- **Frontend Developer**: 02-functional/(frontend-impl), 06-quality/, 07-operations/
- **DevOps/SRE**: 07-operations/, 06-quality/security/
- **New Team Member**: 07-operations/development-setup/, 02-functional/00-quickstart.md

## By Topic
- [Authentication](02-functional/authentication/) - How users log in
- [Billing](02-functional/billing/) - Payment processing
- [Multi-Tenant Architecture](03-architecture/system-design/02-multi-tenant-architecture.md) - Data isolation
- [API Reference](08-reference/api/) - Endpoints, errors, conventions
- [Security](06-quality/security/) - Best practices, hardening
- [Deployment](07-operations/deployment/) - CI/CD, production

## Recent Decisions
[See decisions-log.md](04-decisions/decisions-log.md)

## Contributing
See [CLAUDE.md](CLAUDE.md) for contribution guidelines.
```

### README en cada sección (Navegación local)
Cada sección (01, 02, 03, etc.) tiene su README que actúa como índice

---

## MIGRACIÓN STRATEGY

### Fase 1: Preparación (1 sesión)
1. Crear estructura nueva en keygo-docs
2. Mover archivos sin modificar contenido
3. Crear todos los README.md de navegación

### Fase 2: Consolidación (SP-3, múltiples sesiones)
1. Por cada sección (SP-3.1 a SP-3.5):
   - Merge contenido duplicado
   - Reescribir para consistencia
   - Agregar referencias cruzadas

### Fase 3: Relleno de Gaps (SP-3, paralelo)
1. Crear nuevos documentos identificados en gaps-analysis.md
2. Priorizar críticos primero

### Fase 4: Validación & Publicación (SP-5, 1 sesión)
1. Verificar todos los links
2. Actualizar back/front repos para usar submódulo
3. Crear CHANGELOG.md

---

## BENEFICIOS DE ESTA ESTRUCTURA

| Beneficio | Antes | Después |
|-----------|-------|---------|
| **Single Source of Truth** | Duplicado (back/front) | ✅ Unificado |
| **Onboarding Time** | 2-3 días (buscar en 2 repos) | ✅ 1 día (estructura clara) |
| **Maintenance Burden** | 2x (actualizar 2 lugares) | ✅ 1x |
| **Cross-Team Alignment** | Difícil (docs divergen) | ✅ Fácil (un recurso) |
| **Architecture Clarity** | Fragmentada | ✅ Coherente |
| **Discoverability** | Baja (estructura paralela) | ✅ Alta (organized by feature) |

---

## CRONOGRAMA ESTIMADO

- **SP-1 (Mapeo)**: ✅ Completado (este doc)
- **SP-2 (Arquitectura)**: ~1 sesión (diseño final aprobado)
- **SP-3 (Consolidación)**: ~5-7 sesiones (mover, reescribir por sección)
- **SP-4 (Índices)**: ~1 sesión (create index.md, READMEs)
- **SP-5 (Validación)**: ~1 sesión (verificación, cleanup)

**Total**: ~8-12 sesiones (~40-60 horas)

---

## PRÓXIMO PASO

✅ SP-1 completado  
👉 Presentar structure-proposal.md para aprobación  
👉 Iniciar **SP-2: Diseño de Arquitectura Documental**
