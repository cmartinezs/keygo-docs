# 📚 DOCS INVENTORY - Mapeo Completo

**Estado**: SP-1 - Análisis de contenido completado  
**Última actualización**: 2026-04-19  
**Total archivos**: 519 .md files

---

## ESTRUCTURA DE DIRECTORIOS

### Backend (440 archivos)
```
00-BACKEND/
├── 01-product/          14 archivos   [Product specs, requirements, glossary]
├── 02-functional/       26 archivos   [Feature guides, endpoint docs]
├── 03-architecture/     13 archivos   [Patterns, design, auth strategies]
├── 04-decisions/        70 archivos   [RFCs (9 iniciativas), 5 ADRs]
├── 05-delivery/         33 archivos   [Roadmap, release management]
├── 06-quality/           6 archivos   [Testing, security, code style]
├── 07-operations/        6 archivos   [Deployment, runbooks, Docker]
├── 08-reference/        19 archivos   [API catalog, data models, ejemplos]
├── 09-ai/              139 archivos   [Agent logs, task tracking, lessons]
└── 99-archive/          79 archivos   [Deprecated, historical, research]
```

### Frontend (41 archivos)
```
01-FRONTEND/
├── 01-product/          3 archivos    [Vision, scope, role model]
├── 02-functional/      17 archivos    [Auth flows, billing, feedback]
├── 03-architecture/     5 archivos    [System overview, project structure]
├── 04-decisions/        4 archivos    [ADRs: error handling, forbidden resources]
├── 05-delivery/         2 archivos    [Live backlog]
├── 06-quality/          4 archivos    [Security tests, accessibility]
├── 07-operations/       2 archivos    [Local setup]
├── 08-reference/        2 archivos    [Endpoint status matrix]
└── 09-ai/               1 archivo     [README only]
```

---

## DISTRIBUCIÓN POR TIPO DE CONTENIDO

| Tipo | Count | Ubicación | Descripción |
|------|-------|-----------|-------------|
| **Product** | 50 | 01-product, 05-delivery | Vision, requirements, roadmap, delivery stages |
| **Functional** | 43 | 02-functional | Feature guides, how-to, API documentation |
| **Technical** | 92 | 03-architecture, 04-decisions | Patterns, designs, RFCs, ADRs |
| **Quality/Ops** | 18 | 06-quality, 07-operations | Testing, security, deployment, runbooks |
| **Reference** | 21 | 08-reference | API catalogs, data models, examples |
| **AI Context** | 140 | 09-ai | Agent logs, task tracking (NO es para usuarios) |
| **Archive** | 79 | 99-archive | Deprecated, historical plans |
| **TOTAL** | 519 |  |  |

---

## ARCHIVOS CLAVE POR SECCIÓN

### 01-PRODUCT (Requisitos, Visión)
**Backend**:
- `requirements.md` - Specs funcionales y no-funcionales
- `glossary.md` - Terminología canónica
- `pain-points.md` - Restricciones identificadas
- `bounded-contexts.md` - Separación de dominios
- `diagrams/*` - Flows de auth, billing, account, tenant

**Frontend**:
- `01-vision-and-scope.md` - Visión del producto
- `02-role-model.md` - Modelo de roles

**📌 INSIGHT**: Hay redundancia en las definiciones de requirements y glossary entre back y front.

---

### 02-FUNCTIONAL (Guías de Features)
**Backend**:
- `authentication-flow.md` (64KB) - Documentación exhaustiva de auth
- `admin/admin-console-guide.md` - Admin UI guide
- `frontend/*` - Guías de setup, endpoints (account, tenant, billing, admin)

**Frontend**:
- `04-auth-flow-platform-and-tenant.md` - Auth flows (plataforma + tenant)
- `05-billing-flow-contractor-model.md` - Billing flow contractor

**📌 INSIGHT**: **MÁXIMA REDUNDANCIA** - authentication-flow.md en backend vs frontend auth flows. Necesita consolidación urgente.

---

### 03-ARCHITECTURE (Patrones, Decisiones Técnicas)
**Backend**:
- `authorization-patterns.md` - Authorization implementation
- `oauth2-oidc-multidomain-contract.md` - OAuth2/OIDC contract
- `database-schema.md` - DB schema documentation
- `provisioning-strategy.md` - User provisioning
- `patterns/` - Catalog de patrones, validation strategy

**Frontend**:
- `03-auth-and-session.md` - Auth & session management
- `04-api-integration.md` - API integration patterns

**📌 INSIGHT**: Backend tiene más detalle de arquitectura. Frontend podría referenciarse al backend.

---

### 04-DECISIONS (RFCs, ADRs)
**Backend** (70 archivos):
- **5 ADRs**: OAuth2 errors, hexagonal architecture, multi-tenant model, JWT auth, documentation structure
- **9 RFCs** covering: account UI, billing refactor, database schema, RBAC, multi-tenant, critical actions, geoIP
- **Status**: Muy activo, 28 archivos históricos en archive sobre reorganización

**Frontend** (4 archivos):
- 2 ADRs: error handling (OAuth2), forbidden resource handling

**📌 INSIGHT**: Backend tiene mucho más RFC. Frontend podría referenciar decisiones técnicas comunes.

---

### 05-DELIVERY (Roadmap, Release Management)
**Backend** (33 archivos):
- `roadmap.md` - Product roadmap
- `release-management.md` - Release process
- `stages/` - Design, discovery, implementation, verification, release
- `sprints/`, `releases/` - Sprint y release tracking

**Frontend** (2 archivos):
- `01-backlog-live.md` - Live feature backlog

**📌 INSIGHT**: Backend tiene roadmap unificado. Frontend tiene backlog separado. Necesita sincronización.

---

### 06-QUALITY (Testing, Security, Code Style)
**Backend** (6 archivos):
- `test-integration.md`, `test-strategy.md` - Testing docs
- `security-guidelines.md` - Security best practices
- `code-style.md`, `debug-guide.md`

**Frontend** (4 archivos):
- `01-security-login-test-plan.md`, `02-security-login-runbook.md`
- `03-accessibility-chile.md` - Accessibility compliance

**📌 INSIGHT**: Frontend tiene security tests específicas (login). Backend tiene security guidelines generales. Necesita merge.

---

### 07-OPERATIONS (Deployment, Runbooks)
**Backend** (6 archivos):
- `deployment-pipeline.md` - CI/CD documentation
- `production-runbook.md` - Production operations
- `docker.md`, `environment-setup.md`, `signing-and-jwks.md`

**Frontend** (2 archivos):
- `01-local-setup.md` - Frontend dev environment

**📌 INSIGHT**: Backend tiene runbook de production. Frontend solo local setup. Necesita operations guide frontend.

---

### 08-REFERENCE (APIs, Data Models, Ejemplos)
**Backend** (19 archivos):
- `endpoint-catalog.md` - Complete endpoint reference (shared?)
- `error-catalog.md` - Error codes
- `data-model.md`, `data-type-dictionary.md`, `entity-relationships.md`
- `migrations.md`, `hosted-login-handoff.md`, `keygo-supabase.md`

**Frontend** (2 archivos):
- `01-endpoint-status-matrix.md` - API endpoint status tracking

**📌 INSIGHT**: Backend tiene endpoint-catalog, frontend tiene endpoint-status-matrix. ¿Redundante? Necesita análisis.

---

### 09-AI (Agent Context - NO PARA USUARIOS)
**Backend** (139 archivos):
- `agents.md` - Agent configuration
- `agents-change-log.md`, `workflow.md`, `ai-context.md`
- `inconsistencies/` - 8 archivos tracking issues (INC-001 a INC-H06)
- `lessons-learned/` - 8 archivos con learnings (api, dominio, persistencia, tests, herramientas, seguridad, spring)
- `registered/` (98+ task files), `completed/`, `pending-ui/`, `planned/`, etc.

**Frontend** (1 archivo):
- README only

**📌 INSIGHT**: 09-AI es para **agentes IA**, NO es documentación de usuario. Debe moverse a `.claude/` o similar.

---

### 99-ARCHIVE (Deprecated, Historical)
- **deprecated/** (23) - Legacy API, data models, design
- **historical-plans/** (28) - Documentation reorganization (2026) + sprints
- **ai/** (5) - Historical AI context
- **email-templates/** (12) - Email delivery templates
- **research/** (6) - Billing, admin dashboard research
- **incidents/** (2) - Incident reports

**📌 INSIGHT**: Hay oportunidad de limpiar archivos muy antiguos (2026-04 documentation-reorg).

---

## RESUMEN DE HALLAZGOS

| Hallazgo | Severidad | Descripción |
|----------|-----------|-------------|
| **Parallelismo Back/Front** | Media | Estructura idéntica en 01-09, pero contenido divergente |
| **Auth Redundancia** | **ALTA** | authentication-flow.md (BE) vs auth flows (FE) necesita merge |
| **09-AI es agent context** | Media | 139 archivos que NO son para usuarios finales |
| **Roadmap dividido** | Media | Backend tiene roadmap, frontend tiene backlog separado |
| **RFCs asimétricas** | Media | Backend 70 RFCs, frontend 4 ADRs |
| **Endpoint documentation** | Media | endpoint-catalog vs endpoint-status-matrix (¿redundante?) |
| **Ops/Quality gaps** | Baja | Frontend missing deployment/operations runbooks |

---

## PRÓXIMO PASO

👉 Ver `redundancy-analysis.md` para mapeo detallado de duplicaciones  
👉 Ver `gaps-analysis.md` para identificar qué falta  
👉 Ver `structure-proposal.md` para arquitectura recomendada
