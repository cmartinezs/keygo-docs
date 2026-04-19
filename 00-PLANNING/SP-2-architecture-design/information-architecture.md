# Information Architecture - Jerarquía Final

**Estado**: SP-2 - Diseño de Arquitectura  
**Fecha**: 2026-04-19

---

## Principios de Diseño

### 1. **Organización por Dominio, no por Tech Stack**
- ❌ Antes: `00-BACKEND/`, `01-FRONTEND/` (paralelo)
- ✅ Después: `01-product/`, `02-functional/`, `03-architecture/` (unificado)

**Razonamiento**: Los usuarios (developers) piensan en features, no en capas.

### 2. **Agnóstico Primero, Tech-Specific Después**
- Arquitectura general sin detalles de implementación
- Secciones separadas para backend vs frontend solo cuando sea necesario
- Cross-references entre implementaciones

**Razonamiento**: Reduce redundancia, facilita cambios de tech stack.

### 3. **Navegación Clara por Rol**
- Product Manager → 01-product, 04-decisions
- Backend Developer → 03-architecture, 02-functional (backend impl)
- Frontend Developer → 02-functional (frontend impl), 06-quality
- DevOps → 07-operations, 06-quality/security

**Razonamiento**: Cada rol encuentra rápidamente lo que necesita.

### 4. **Un Índice Central, Índices Locales**
- `INDEX.md` en raíz (navegación global)
- `README.md` en cada sección (navegación local + entry point)

**Razonamiento**: Evita overwhelm, permite deep-dive.

---

## Jerarquía Final de Directorios

### Nivel 1: Raíz (Meta)
```
keygo-docs/
├── INDEX.md                    [NUEVA - Homepage de navegación]
├── README.md                   [Entrada rápida]
├── CLAUDE.md                   [Meta: contexto para Claude]
├── agents.md                   [Meta: instrucciones para agentes]
├── macro-plan.md               [Meta: plan general]
└── [Carpetas de contenido]
```

### Nivel 2: Contenido (Top-level)
```
00-PLANNING/          [Documentos de trabajo, no para usuarios]
00-BACKEND/           [Documentación raw backend - SERÁ REMOVIDA al unificar]
01-FRONTEND/          [Documentación raw frontend - SERÁ REMOVIDA al unificar]
01-product/           [Documentación unificada - Target]
02-functional/
03-architecture/
04-decisions/
06-quality/
07-operations/
08-reference/
OVERRIDES/
99-archive/
```

**Nota**: Después de SP-3 consolidation, `00-BACKEND/` y `01-FRONTEND/` estarán vacíos (su contenido migrado a secciones 01-08)

### Nivel 3: Secciones (Detailed Structure)

#### **01-PRODUCT** (Visión, requisitos, glossario)
```
01-product/
├── README.md                      [Entry point + mini-index]
├── vision.md                      [Qué estamos construyendo]
├── glossary.md                    [SINGLE SOURCE OF TRUTH - términos]
├── requirements.md                [Requisitos funcionales + no-funcionales]
├── constraints-limitations.md      [Restricciones, pain points]
├── dependency-map.md              [Dependencias entre features]
├── stakeholders-and-roles.md      [NUEVA - Actores, stakeholders]
└── diagrams/
    ├── README.md
    ├── use-cases.md               [Actor-action diagrams]
    ├── authentication-flow.md      [Flujo de autenticación]
    ├── billing-flow-contractor.md  [Modelo contractor]
    ├── account-flow.md            [Gestión de cuenta]
    └── tenant-management-flow.md   [Ciclo vida tenant]
```

**Niveles de lectura**:
- Ejecutivo: vision.md + diagrams
- Product: vision + requirements + diagrams
- Developer: requirements + glossary + diagrams

---

#### **02-FUNCTIONAL** (Guías de features)
```
02-functional/
├── README.md                      [Index de features]
├── 00-quickstart.md               [NUEVA - Getting started para contributors]
├── authentication/
│   ├── README.md                 [Architecture agnóstica]
│   ├── 01-authentication-architecture.md
│   ├── 02-backend-implementation.md
│   ├── 03-frontend-implementation.md
│   └── 04-integration-guide.md    [Cómo trabajan juntos]
├── billing/
│   ├── README.md
│   ├── 01-contractor-model.md
│   ├── 02-backend-implementation.md
│   ├── 03-frontend-ui-flows.md
│   └── 04-payment-integration.md  [Stripe, PayPal, etc.]
├── account-management/
│   ├── README.md
│   ├── 01-account-model.md
│   ├── 02-backend-implementation.md
│   └── 03-frontend-implementation.md
├── tenant-management/
│   ├── README.md
│   ├── 01-tenant-lifecycle.md
│   ├── 02-backend-implementation.md
│   └── 03-frontend-implementation.md
├── admin-console/
│   ├── README.md
│   ├── 01-admin-model.md
│   ├── 02-backend-implementation.md
│   └── 03-frontend-implementation.md
├── email-notifications/
│   ├── README.md
│   ├── 01-notification-model.md
│   ├── 02-email-templates.md
│   └── 03-testing-emails.md
└── [Otras features as needed]
```

**Naming pattern**: Feature → subcarpeta → 01-architecture, 02-backend, 03-frontend

---

#### **03-ARCHITECTURE** (Patrones, decisiones técnicas)
```
03-architecture/
├── README.md                      [Design philosophy + orientation]
├── system-design/
│   ├── README.md
│   ├── 01-system-overview.md      [High-level architecture]
│   ├── 02-multi-tenant-architecture.md
│   ├── 03-monorepo-structure.md
│   └── 04-security-bootstrap.md
├── patterns/
│   ├── README.md
│   ├── design-patterns.md
│   ├── api-design-patterns.md
│   ├── validation-strategy.md
│   ├── error-handling.md
│   └── authorization-patterns.md
├── data-and-persistence/
│   ├── README.md
│   ├── 01-data-model.md
│   ├── 02-database-strategy.md
│   ├── 03-multi-tenant-data-isolation.md
│   └── 04-migration-strategy.md
├── security/
│   ├── README.md
│   ├── 01-authentication-architecture.md
│   ├── 02-authorization-architecture.md
│   ├── 03-session-management.md
│   ├── 04-secret-management.md
│   └── 05-security-guidelines.md
├── observability/
│   ├── README.md
│   ├── 01-observability-strategy.md
│   ├── 02-performance-targets.md
│   └── 03-alerting-strategy.md
└── provisioning/
    ├── README.md
    └── 01-user-provisioning.md
```

**Navegación**: README en cada nivel orienta al siguiente nivel

---

#### **04-DECISIONS** (RFCs, ADRs)
```
04-decisions/
├── README.md                      [ADR template + how to propose]
├── adr/
│   ├── README.md                 [Index of ADRs]
│   ├── adr-001-oauth2-errors.md
│   ├── adr-002-hexagonal-monorepo.md
│   ├── adr-003-multi-tenant-model.md
│   ├── adr-004-bearer-jwt-auth.md
│   ├── adr-005-documentation-structure.md
│   └── adr-006-unification-of-docs.md  [NUEVA - Esta iniciativa]
├── rfcs/
│   ├── README.md                 [Index + status of RFCs]
│   ├── billing-refactor/
│   ├── account-ui-proposal/
│   ├── rbac-multi-scope/
│   └── [organized by topic]
├── decisions-log.md               [NUEVA - Chronological log with status]
└── [archived-decisions/]          [Superseded, not deleted]
```

---

#### **06-QUALITY** (Testing, security, standards)
```
06-quality/
├── README.md
├── testing/
│   ├── README.md
│   ├── 01-test-strategy.md
│   ├── 02-integration-testing.md
│   ├── 03-authentication-test-plan.md
│   ├── 04-load-testing.md
│   └── 05-testing-environments.md
├── security/
│   ├── README.md
│   ├── 01-security-guidelines.md
│   ├── 02-hardening-guide.md
│   ├── 03-dependency-management.md
│   ├── 04-secret-management.md
│   └── 05-code-review-checklist.md
├── code-standards/
│   ├── README.md
│   ├── 01-code-style-backend.md
│   ├── 02-code-style-frontend.md
│   └── 03-naming-conventions.md
├── accessibility/
│   ├── README.md
│   ├── 01-wcag-compliance.md
│   └── 02-regional-requirements.md
└── monitoring/
    ├── README.md
    └── 01-debugging-guide.md
```

---

#### **07-OPERATIONS** (Deployment, runbooks)
```
07-operations/
├── README.md
├── development-setup/
│   ├── README.md
│   ├── 01-prerequisites.md
│   ├── 02-backend-setup.md
│   ├── 03-frontend-setup.md
│   ├── 04-database-seeding.md
│   ├── 05-ide-configuration.md
│   └── 06-troubleshooting.md
├── infrastructure/
│   ├── README.md
│   ├── 01-docker-setup.md
│   ├── 02-environment-variables.md
│   └── 03-key-signing-jwks.md
├── deployment/
│   ├── README.md
│   ├── 01-deployment-strategy.md
│   ├── 02-backend-deployment.md
│   ├── 03-frontend-deployment.md  [NUEVA]
│   ├── 04-database-migrations.md
│   └── 05-rollback-procedures.md
├── production-runbooks/
│   ├── README.md
│   ├── 01-backend-runbook.md
│   ├── 02-frontend-runbook.md     [NUEVA]
│   ├── 03-incident-response.md
│   ├── 04-auth-incidents.md
│   ├── 05-billing-incidents.md
│   └── 06-database-operations.md
├── security-operations/
│   ├── README.md
│   ├── 01-oauth2-configuration.md [NUEVA]
│   ├── 02-secret-rotation.md
│   └── 03-security-incident-response.md
└── monitoring-and-alerts/
    ├── README.md
    └── 01-monitoring-setup.md
```

---

#### **08-REFERENCE** (APIs, data models, ejemplos)
```
08-reference/
├── README.md
├── api/
│   ├── README.md
│   ├── 01-api-conventions.md
│   ├── 02-endpoint-catalog.md
│   ├── 03-error-codes.md
│   ├── 04-error-handling-guide.md [NUEVA]
│   └── 05-authentication-api.md
├── data-models/
│   ├── README.md
│   ├── 01-data-model-overview.md
│   ├── 02-entity-relationships.md
│   ├── 03-data-type-dictionary.md
│   ├── 04-database-schema.md
│   └── 05-migration-history.md
├── integration-examples/
│   ├── README.md
│   ├── 01-hosted-login.md
│   ├── 02-supabase-integration.md
│   └── 03-common-workflows.md
└── glossary-reference.md           [Link a 01-product/glossary.md]
```

---

#### **OVERRIDES/** (Opcional: Tech-specific)
```
OVERRIDES/
├── README.md
├── backend-specifics/
│   ├── spring-framework-patterns.md
│   ├── maven-build.md
│   └── java-conventions.md
└── frontend-specifics/
    ├── react-patterns.md
    ├── npm-build.md
    └── javascript-conventions.md
```

**Nota**: Estos podrían vivir en repos backend/frontend como override, no en keygo-docs

---

#### **99-ARCHIVE/** (Deprecated, historical)
```
99-archive/
├── README.md
├── deprecated/
├── historical-plans/
├── research/
└── CLEANUP-LOG.md
```

---

## Convenciones de Nombres de Archivos

Ver `naming-conventions.md` para detalles completos.

**Quick reference**:
- `README.md` - Índice/entry point de cada carpeta
- `01-name.md` - Primer documento (ordenado numéricamente)
- `02-name.md` - Segundo documento
- Descriptivo, en lowercase con guiones
- Ejemplo: `01-authentication-architecture.md`, no `AuthenticationArchitecture.md`

---

## Profundidad de Jerarquía

**Máximo 3 niveles de profundidad** para evitar overwhelm:

```
Good:
01-product/
├── diagrams/
│   ├── use-cases.md

Bad (demasiado profundo):
01-product/
├── diagrams/
│   ├── technical/
│   │   ├── flows/
│   │   │   ├── auth/
│   │   │   │   ├── oauth2.md
```

---

## Próximo Paso

👉 Ver `naming-conventions.md` para estándares de nomenclatura  
👉 Ver `navigation-map.md` para cómo se conectan las secciones  
👉 Ver `index-structure.md` para diseño de índices
