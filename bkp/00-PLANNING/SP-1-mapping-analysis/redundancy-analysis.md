# 🔄 REDUNDANCY ANALYSIS - Duplicaciones Identificadas

**Estado**: SP-1 - Análisis de redundancia  
**Fecha**: 2026-04-19

---

## RESUMEN EJECUTIVO

**Total de redundancias detectadas**: ~8 áreas críticas  
**Impacto**: Alta - Documentación divergente causa confusión y mantenimiento duplicado  
**Recomendación**: Consolidar antes de unificar

---

## REDUNDANCIAS POR SECCIÓN

### 🔴 CRÍTICA: Authentication Documentation (2 versiones)

**Localización**:
- `00-BACKEND/02-functional/authentication-flow.md` (64KB - exhaustiva)
- `01-FRONTEND/02-functional/04-auth-flow-platform-and-tenant.md` (grande)

**Problema**: 
- Ambas documentan el mismo flow (platform + tenant auth)
- Backend: detalle técnico de implementación OAuth2/OIDC
- Frontend: perspectiva de UI, mismo flow pero sin detalles BE

**Contenido Superpuesto**:
- ✓ Ambas explican roles (contractor, manager, admin)
- ✓ Ambas cubren tenant vs platform flow
- ✓ Ambas documentan error cases
- ✗ Sin referencia cruzada

**Recomendación**:
```
CONSOLIDADO: 02-functional/authentication-flow.md
├── Sección 1: Architecture (agnostic, aplica a ambos)
├── Sección 2: Backend Implementation (OAuth2, OIDC, JWT specifics)
├── Sección 3: Frontend Implementation (UI patterns, session management)
└── Sección 4: Troubleshooting (ambos)

Frontend solo referencia este documento con un:
"Ver 02-functional/authentication-flow.md -> sección 3"
```

---

### 🔴 ALTA: Product Requirements & Glossary

**Localización**:
- `00-BACKEND/01-product/requirements.md` (specs funcionales)
- `00-BACKEND/01-product/glossary.md` (terminología)
- `01-FRONTEND/01-product/02-role-model.md` (roles, permisos)

**Problema**:
- Algunos términos definidos en glossary backend, otros en role-model frontend
- Requisitos de UI en ambos sin sincronización
- Roles documentados en 3 lugares distintos

**Contenido Superpuesto**:
- ✓ Ambas definen "Contractor", "Manager", "Admin"
- ✓ Ambas documentan "Tenant", "Platform"
- ✗ Definiciones ligeramente diferentes en tone/detalle
- ✗ Sin cross-references

**Recomendación**:
```
CONSOLIDADO: 01-product/glossary.md
├── Términos agnósticos (Tenant, Platform, Contractor, etc.)
└── Referencias a contexto técnico en 03-architecture

01-product/requirements.md:
├── Requisitos de negocio (agnostic)
└── Requisitos técnicos → link a 03-architecture

01-FRONTEND/role-model.md:
└── DELETE - incorporar en glossary backend como "Role Model" section
```

---

### 🟠 ALTA: Authorization & Access Control

**Localización**:
- `00-BACKEND/03-architecture/authorization-patterns.md` (patterns)
- `00-BACKEND/04-decisions/rfcs/rbac-multi-scope-alignment/` (5 files - detailed RFC)
- `01-FRONTEND/04-decisions/adr-002-forbidden-resource-handling.md` (frontend specific)

**Problema**:
- Patterns documento describe el concepto
- RFC tiene detalles de implementación en backend
- Frontend tiene su interpretación de forbidden resource

**Contenido Superpuesto**:
- ✓ Ambas cubren scopes (platform, tenant, personal)
- ✓ Ambas definen permission checks
- ✗ Diferentes niveles de detalle
- ✗ Sin cross-references

**Recomendación**:
```
CONSOLIDADO: 03-architecture/authorization-patterns.md
├── Pattern agnóstico (scopes, permission model)
├── Backend implementation (link RFC en 04-decisions/)
└── Frontend implementation (link a adr-002)

04-decisions/rbcs-multi-scope-alignment/ → keep as RFC, add cross-reference to patterns

adr-002 → merge forbidden-resource-handling specifics into patterns section, 
          keep only frontend-specific guard logic
```

---

### 🟠 ALTA: Billing & Contractor Model

**Localización**:
- `00-BACKEND/04-decisions/rfcs/billing-contractor-refactor/` (9 files - detailed)
- `01-FRONTEND/02-functional/05-billing-flow-contractor-model.md` (flow diagram)

**Problema**:
- Backend RFC muy detallado (dominio, JPA entities, use cases, controllers)
- Frontend solo documenta el flow visualmente

**Contenido Superpuesto**:
- ✓ Ambas cubren contractor billing flow
- ✓ Ambas definen estados de billing
- ✗ Backend no tiene perspectiva de UI
- ✗ Frontend no tiene detalles de implementación

**Recomendación**:
```
MANTENER SEPARADAS pero CON REFERENCIAS:

02-functional/billing-flow-contractor-model.md (Frontend):
└── "Para implementación backend, ver 04-decisions/billing-contractor-refactor/"

04-decisions/billing-contractor-refactor/ (Backend):
└── "Para UI flow, ver 01-FRONTEND/02-functional/billing-flow-contractor-model.md"
```

---

### 🟡 MEDIA: API Endpoint Documentation

**Localización**:
- `00-BACKEND/08-reference/endpoint-catalog.md` (complete endpoint reference)
- `01-FRONTEND/08-reference/01-endpoint-status-matrix.md` (endpoint status tracking)

**Problema**:
- endpoint-catalog: todos los endpoints disponibles
- endpoint-status-matrix: status de implementación (live, WIP, planned)

**Contenido Superpuesto**:
- ✓ Ambas listan los mismos endpoints
- ✓ Ambas tienen información de status
- ? ¿endpoint-catalog incluye status o solo spec?

**Recomendación**:
```
CONSOLIDADO: 08-reference/endpoint-catalog.md
├── Spec de cada endpoint (method, path, request/response)
├── Status (implemented, WIP, planned)
├── Backend support level
└── Frontend implementation status

ELIMINAR: 01-FRONTEND/endpoint-status-matrix.md
└── Merge data into unified endpoint-catalog
```

---

### 🟡 MEDIA: Operations & Deployment

**Localización**:
- `00-BACKEND/07-operations/deployment-pipeline.md` (CI/CD)
- `00-BACKEND/07-operations/production-runbook.md` (operations)
- `01-FRONTEND/07-operations/01-local-setup.md` (dev environment)

**Problema**:
- Backend tiene producción + pipelines
- Frontend solo tiene local dev setup
- NO hay frontend deployment/operations docs

**Contenido Superpuesto**:
- ✗ No hay redundancia, hay **GAPS**
- Frontend missing: deployment, production runbook, troubleshooting

**Recomendación**:
```
CREAR: 01-FRONTEND/07-operations/
├── 02-deployment-pipeline.md (referencia a backend con especifics frontend)
├── 03-production-runbook.md (frontend-specific incidents)
└── README.md (index)

ACTUALIZAR: 00-BACKEND/07-operations/
└── Agregar sección "Frontend Considerations" en cada doc
```

---

### 🟡 MEDIA: Security & Testing

**Localización**:
- `00-BACKEND/06-quality/security-guidelines.md` (general)
- `00-BACKEND/06-quality/test-integration.md` (integration tests)
- `01-FRONTEND/06-quality/01-security-login-test-plan.md` (login test plan)
- `01-FRONTEND/06-quality/02-security-login-runbook.md` (test runbook)

**Problema**:
- Backend: guidelines generales, no específicas de authentication
- Frontend: security tests específicas de login flow

**Contenido Superpuesto**:
- ✗ No hay redundancia
- ✓ Son complementarias (general + specific)

**Recomendación**:
```
CONSOLIDADO: 06-quality/security-guidelines.md
├── Sección: General Security Practices
├── Sección: Authentication Security
│   └── Referenciar frontend login test plan
├── Sección: Data Protection
└── Sección: Compliance

REUBICATE: 01-FRONTEND/quality/
├── security-login-test-plan.md → 06-quality/authentication-test-plan.md
└── security-login-runbook.md → 06-quality/authentication-test-runbook.md
```

---

### 🟢 BAJA: Architecture & Design Patterns

**Localización**:
- `00-BACKEND/03-architecture/patterns/patterns.md` (catalog)
- `01-FRONTEND/03-architecture/` (no patterns specific)

**Problema**:
- Frontend references backend patterns implicitly
- No hay pattern duplication

**Contenido Superpuesto**:
- ✗ Minimal redundancy
- Backend patterns aplican a ambos layers

**Recomendación**:
```
MANTENER: 03-architecture/patterns.md
└── Agregar cross-reference desde 01-FRONTEND/03-architecture/README.md
```

---

## TABLA CONSOLIDADA DE REDUNDANCIAS

| Sección | BE Location | FE Location | Severidad | Acción |
|---------|------------|-------------|-----------|--------|
| Authentication | 02-functional/auth-flow | 02-functional/04-auth-flow | 🔴 CRÍTICA | Merge + single source |
| Requirements/Glossary | 01-product/ | 01-product/role-model | 🔴 ALTA | Consolidate glossary |
| Authorization | 03-architecture/ + 04-decisions/ | 04-decisions/adr-002 | 🔴 ALTA | Cross-reference |
| Billing Contractor | 04-decisions/rfcs/ | 02-functional/billing-flow | 🟠 MEDIA | Link both |
| Endpoints | 08-reference/catalog | 08-reference/status-matrix | 🟠 MEDIA | Merge catalogs |
| Operations | 07-operations/ | 07-operations/local-setup | 🟡 MEDIA | Create FE ops docs |
| Security/Testing | 06-quality/ | 06-quality/login-tests | 🟡 MEDIA | Consolidate sections |
| Design Patterns | 03-architecture/patterns | (referenced) | 🟢 BAJA | Cross-reference |

---

## COSTO DE CONSOLIDACIÓN

| Acción | Archivos | Complejidad | Tiempo Estimado |
|--------|----------|-------------|-----------------|
| Merge authentication | 2 | Alta | 2-3 horas |
| Consolidate glossary | 3 | Media | 1-2 horas |
| Align authorization | 8 | Alta | 2-3 horas |
| Merge endpoint catalog | 2 | Media | 1-2 horas |
| Create FE operations | 3 new | Media | 1-2 horas |
| Consolidate security | 4 | Baja | 1 hora |
| **TOTAL** |  |  | **9-13 horas** |

---

## PRÓXIMO PASO

👉 Ver `gaps-analysis.md` para identificar qué falta  
👉 Ver `structure-proposal.md` para arquitectura unificada
