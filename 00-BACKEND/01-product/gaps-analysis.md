# ⚠️ GAPS ANALYSIS - Lo que Falta

**Estado**: SP-1 - Análisis de gaps  
**Fecha**: 2026-04-19

---

## RESUMEN EJECUTIVO

**Total de gaps documentados**: 12 áreas faltantes críticas  
**Impacto**: Media-Alta - Documentación incompleta dificulta onboarding y troubleshooting  
**Recomendación**: Priorizar gaps críticos antes de unificar

---

## GAPS POR SECCIÓN

### 🔴 CRÍTICA: Frontend Deployment & Operations

**¿Qué falta?**
- Production deployment guide (frontend)
- Frontend production runbook
- Frontend environment configuration (staging, production)
- Frontend monitoring & observability setup
- Frontend CI/CD pipeline documentation

**Ubicación esperada**: `01-FRONTEND/07-operations/`

**Impacto**: Alta
- Developers no saben cómo desplegar frontend a producción
- No hay procedures para incidents en producción (frontend)
- Missing SLOs/monitoring guidance

**Por qué falta**:
- Frontend docs más joven, menos madura
- Posible que exista en repo frontend, no aquí

**Recomendación**:
```
CREAR:
├── 02-frontend-deployment.md (how to deploy, CI/CD specifics)
├── 03-frontend-production-runbook.md (incident response)
├── 04-frontend-environment-setup.md (staging, production config)
└── 05-frontend-monitoring.md (observability, alerts)
```

---

### 🔴 CRÍTICA: Database Schema & Migrations Documentation

**¿Qué falta?**
- Current database schema (ERD, actual state)
- Migration history with rationale
- Data model deep-dive (not just ER diagrams)
- Backup/restore procedures
- Database performance guidelines

**Ubicación actual**: 
- `08-reference/data-model.md` - existe pero muy superficial
- `08-reference/migrations.md` - existe pero incompleto
- `04-decisions/rfcs/ddl-full-refactor/` - RFC sobre refactor pero no spec final

**Impacto**: Alta
- No hay clarity sobre estado actual vs. target schema
- Missing procedures para database operations
- Performance issues sin guidelines

**Por qué falta**:
- Schema siempre en evolución (RFCs activos)
- No hay autoridad única de verdad sobre schema

**Recomendación**:
```
ACTUALIZAR: 08-reference/data-model.md
├── Sección 1: Entity Relationship Diagram (actual state)
├── Sección 2: Entity Definitions (cada tabla con propósito)
├── Sección 3: Key Relationships & Constraints
└── Sección 4: Indexes & Performance Guidelines

CREAR: 08-reference/migration-guide.md
├── Migration philosophy & approach
├── Current migrations (with timestamps & rationale)
├── Migration safety procedures
└── Rollback procedures

ACTUALIZAR: 04-decisions/ddl-full-refactor/
└── Link a data-model.md como "source of truth"
```

---

### 🔴 CRÍTICA: API Error Handling & Status Codes

**¿Qué falta?**
- Comprehensive error code catalog
- Error handling strategies (when to use 400 vs 422 vs 500)
- Backend error response formats
- Frontend error interpretation guide
- Common error scenarios & solutions

**Ubicación actual**:
- `04-decisions/adr-001-oauth2-error-classification.md` - solo OAuth2
- `08-reference/error-catalog.md` - existe pero incompleto

**Impacto**: Alta
- Frontend developers don't know how to handle backend errors
- Inconsistent error formats
- No clear distinction between client errors, auth errors, server errors

**Por qué falta**:
- Error handling evolved organically, not unified
- OAuth2 errors documented, but not general API errors

**Recomendación**:
```
CREAR: 08-reference/api-error-handling.md
├── Sección 1: Error Response Format (JSON structure)
├── Sección 2: HTTP Status Code Strategy
│   ├── 4xx Client Errors
│   ├── 401/403 Authentication/Authorization
│   └── 5xx Server Errors
├── Sección 3: Common Error Scenarios
└── Sección 4: Frontend Error Handling Guide

ACTUALIZAR: 08-reference/error-catalog.md
└── Move to API error handling, expand with examples
```

---

### 🟠 ALTA: API Request/Response Format Standards

**¿Qué falta?**
- Standard request/response envelope format
- Pagination strategy documentation
- Filtering & sorting conventions
- Date/time formatting standards
- Error response envelope format

**Ubicación actual**:
- `02-functional/frontend/03-api-conventions.md` - exists pero muy corto
- No hay equivalente en backend

**Impacto**: Media-Alta
- API inconsistent across endpoints
- Clients don't know pagination/filtering conventions
- Date handling issues

**Por qué falta**:
- API designed piecemeal, no upfront contract

**Recomendación**:
```
ACTUALIZAR: 02-functional/frontend/03-api-conventions.md
└── Move to 08-reference/api-conventions.md (neutral location)

CREAR: 08-reference/api-conventions.md
├── Request Format Standard (authentication headers, body format)
├── Response Format Standard (success envelope, error envelope)
├── Pagination (page/limit, offset/limit, cursor?)
├── Filtering & Sorting Conventions
├── Date/Time Handling (ISO8601, timezone)
└── Examples for Each Convention
```

---

### 🟠 ALTA: OAuth2/OIDC Configuration & Integration

**¿Qué falta?**
- OAuth2 provider configuration (Keycloak, Auth0, custom?)
- OIDC discovery endpoint details
- Client configuration (secret rotation, scopes)
- Multi-domain OAuth2 strategy (if applicable)
- Token lifecycle (expiry, refresh, revocation)

**Ubicación actual**:
- `03-architecture/oauth2-oidc-multidomain-contract.md` - architecture only
- `04-decisions/adr-004-bearer-jwt-for-admin-and-protected-routes.md` - JWT strategy only
- `04-decisions/adr-001-oauth2-error-classification.md` - error handling only

**Impacto**: Media
- Missing configuration details for new environments
- Token management unclear
- Provider switching would be difficult

**Por qué falta**:
- Implementation details in code, not documented

**Recomendación**:
```
CREAR: 07-operations/oauth2-configuration.md
├── OAuth2 Provider Setup (current provider details)
├── OIDC Configuration
├── Client Registration & Secret Management
├── Scope Definitions
├── Token Lifecycle & Refresh Strategy
└── Emergency Procedures (token revocation, provider outage)

ACTUALIZAR: 03-architecture/oauth2-oidc-multidomain-contract.md
└── Cross-reference operational guide
```

---

### 🟠 ALTA: Multi-Tenant Architecture Details

**¿Qué falta?**
- Data isolation strategy (database-level? application-level?)
- Tenant context propagation through request lifecycle
- Tenant-aware access control implementation
- Tenant quota/limits enforcement
- Tenant isolation verification procedures

**Ubicación actual**:
- `04-decisions/rfcs/restructure-multitenant/` (12 files - exhaustive RFC)
- `04-decisions/adr-003-multi-tenant-identity-and-membership-model.md` - model only
- Design docs but no operational guide

**Impacto**: Media
- New developers don't understand tenant isolation
- Missing procedures for tenant management
- Data isolation assumptions not documented

**Por qué falta**:
- RFC muy large, hard to navigate
- No operational runbook extracted

**Recomendación**:
```
CREAR: 03-architecture/multi-tenant-architecture.md
├── Sección 1: Data Isolation Strategy (from RFC)
├── Sección 2: Request Context & Propagation
├── Sección 3: Tenant Access Control
├── Sección 4: Tenant Lifecycle (onboarding, scaling, offboarding)
└── Sección 5: Verification & Testing

ACTUALIZAR: 04-decisions/restructure-multitenant/
└── Link to "see simplified guide in 03-architecture/"
```

---

### 🟠 ALTA: Development Setup & Onboarding

**¿Qué falta?**
- Complete development environment setup (both back & front)
- Database seeding / test data setup
- Local environment configuration
- IDE setup & debugging guide
- Running tests locally

**Ubicación actual**:
- `07-operations/environment-setup.md` - exists but outdated (2026-04-09)
- `01-FRONTEND/07-operations/local-setup.md` - FE only, minimal
- Archive has `deprecated/development/INTELLIJ_SETUP.md` - outdated

**Impacto**: Media-High
- New developers struggle with setup
- Outdated INTELLIJ guide in archive

**Por qué falta**:
- Docs not maintained alongside code changes
- Outdated guides not removed

**Recomendación**:
```
ACTUALIZAR: 07-operations/development-setup.md
├── Prerequisites (Java version, Node version, etc.)
├── Backend Setup (git clone, mvn/gradle, database)
├── Frontend Setup (git clone, npm install, config)
├── Local Database Setup (schema, seeding)
├── Running Tests
├── IDE Configuration (IntelliJ, VSCode)
├── Debugging Guide
└── Troubleshooting

DELETE: deprecated/development/ → archive as historical reference only
```

---

### 🟡 MEDIA: Billing & Payment Integration

**¿Qué falta?**
- Payment provider integration guide (Stripe, PayPal, etc.)
- Billing lifecycle (invoice generation, payment processing, refunds)
- Webhook handling for payment events
- Tax/compliance considerations
- Dunning/failed payment procedures

**Ubicación actual**:
- `04-decisions/rfcs/billing-contractor-refactor/` - domain model only
- `01-FRONTEND/02-functional/billing-flow-contractor-model.md` - UI flow only
- Archive has research: `99-archive/research/billing-plans-for-keygo.md`

**Impacto**: Media
- Payment integrations unclear
- Missing webhook documentation
- Compliance gaps

**Por qué falta**:
- Billing still evolving, not finalized
- Payment provider not documented

**Recomendación**:
```
CREAR: 02-functional/billing-integration-guide.md
├── Payment Provider Configuration
├── Webhook Handling
├── Invoice Generation & Delivery
├── Tax & Compliance
└── Troubleshooting Payment Issues

ACTUALIZAR: 04-decisions/billing-contractor-refactor/
└── Cross-reference implementation guide
```

---

### 🟡 MEDIA: Email Template & Notification System

**¿Qué falta?**
- Email template documentation (current templates)
- Notification system architecture
- Email delivery troubleshooting
- Template variables & examples
- Testing emails locally

**Ubicación actual**:
- `99-archive/email-templates/` (12 files - extensive but archived!)
- No active documentation in 02-functional or 07-operations

**Impacto**: Media
- Email templates are in archive, not accessible
- Missing notification system design
- Template maintenance unclear

**Por qué falta**:
- Email docs archived but not migrated to active docs

**Recomendación**:
```
CREAR: 02-functional/email-notifications.md
├── Email Template Overview (extracted from archive)
├── Available Templates (with variables)
├── Notification Triggers
├── Customization Guide
├── Testing Emails Locally
└── Troubleshooting

ACTUALIZAR: 99-archive/email-templates/
└── Keep as historical reference
```

---

### 🟡 MEDIA: Security Considerations & Hardening

**¿Qué falta?**
- Security checklist for code reviews
- OWASP Top 10 application to Keygo
- Secret management (API keys, credentials)
- Rate limiting strategy
- CORS & security headers configuration
- Dependency vulnerability management

**Ubicación actual**:
- `06-quality/security-guidelines.md` - generic
- No specific hardening guide

**Impacto**: Media
- Missing security controls might be overlooked
- No security review checklist
- Secrets management unclear

**Por qué falta**:
- Security guidelines too generic
- No actionable checklist

**Recomendación**:
```
CREAR: 06-quality/security-hardening-guide.md
├── OWASP Top 10 Mitigation
├── Code Review Security Checklist
├── Secret Management Procedures
├── Rate Limiting Configuration
├── Security Headers & CORS Policy
├── Dependency Vulnerability Management
└── Regular Security Updates Process
```

---

### 🟡 MEDIA: Performance & Optimization Guidelines

**¿Qué falta?**
- API response time targets (SLO)
- Database query optimization guidelines
- Caching strategy (Redis, CDN)
- Frontend bundle size targets
- Load testing procedures
- Performance monitoring & profiling

**Ubicación actual**:
- `03-architecture/observability.md` - monitoring setup
- No optimization guide

**Impacto**: Media
- No targets for performance
- Optimization ad-hoc, not strategic

**Por qué falta**:
- Performance not treated as a feature
- Observability docs but no actionable guidance

**Recomendación**:
```
CREAR: 03-architecture/performance-optimization.md
├── Performance Targets (API latency SLOs)
├── Database Query Optimization
├── Caching Strategy
├── Frontend Bundle Optimization
├── Load Testing & Capacity Planning
└── Performance Monitoring & Profiling

ACTUALIZAR: 03-architecture/observability.md
└── Link to performance guide for metrics to monitor
```

---

### 🟢 BAJA: Accessibility Standards & Compliance

**¿Qué falta?**
- Accessibility guidelines (WCAG, A11y)
- Keyboard navigation requirements
- Screen reader compatibility
- Color contrast requirements
- Accessibility testing procedures

**Ubicación actual**:
- `01-FRONTEND/06-quality/03-accessibility-chile.md` - Chile-specific only
- No general A11y standards

**Impacto**: Baja (pero importante)
- Missing general accessibility standards
- Only Chile-specific documented

**Por qué falta**:
- Accessibility often treated as afterthought
- Only Chile requirements documented

**Recomendación**:
```
CREAR: 06-quality/accessibility-standards.md
├── WCAG 2.1 Compliance Level (A, AA, AAA?)
├── Keyboard Navigation Requirements
├── Screen Reader Compatibility
├── Color & Contrast Requirements
├── Testing Procedures
└── Regional Requirements (including Chile)

ACTUALIZAR: 01-FRONTEND/03-accessibility-chile.md
└── Merge into general accessibility-standards.md
```

---

## TABLA CONSOLIDADA DE GAPS

| Área | Severidad | Status | Entregable | Tiempo Est. |
|------|-----------|--------|-----------|------------|
| Frontend Ops/Deployment | 🔴 CRÍTICA | Missing | 4 docs | 4-6h |
| Database Schema & Migrations | 🔴 CRÍTICA | Partial | 2 docs | 3-4h |
| API Error Handling | 🔴 CRÍTICA | Partial | 1 doc | 2-3h |
| API Request/Response Standards | 🟠 ALTA | Minimal | 1 doc | 2-3h |
| OAuth2 Configuration | 🟠 ALTA | Partial | 1 doc | 2-3h |
| Multi-Tenant Architecture | 🟠 ALTA | RFC exists | 1 doc | 2-3h |
| Development Onboarding | 🟠 ALTA | Outdated | 1 doc | 2-3h |
| Billing Integration | 🟡 MEDIA | Partial | 1 doc | 2-3h |
| Email/Notifications | 🟡 MEDIA | Archived | 1 doc | 1-2h |
| Security Hardening | 🟡 MEDIA | Missing | 1 doc | 2-3h |
| Performance Guidelines | 🟡 MEDIA | Missing | 1 doc | 2-3h |
| Accessibility Standards | 🟢 BAJA | Partial | 1 doc | 1-2h |

**TOTAL ESTIMATED**: ~25-45 horas adicionales para cerrar todos los gaps

---

## PRIORIZACIÓN RECOMENDADA

### Fase 1: Crítica (Bloquea onboarding & development)
1. Frontend Deployment & Operations (4 docs)
2. Database Schema & Migrations (2 docs)
3. API Error Handling (1 doc)

**Tiempo**: 8-13 horas

### Fase 2: Alta (Necesaria para quality & consistency)
4. API Request/Response Standards (1 doc)
5. OAuth2 Configuration (1 doc)
6. Multi-Tenant Architecture (1 doc)
7. Development Onboarding (1 doc)

**Tiempo**: 8-12 horas

### Fase 3: Media (Nice to have, importante para long-term)
8. Billing Integration (1 doc)
9. Email/Notifications (1 doc)
10. Security Hardening (1 doc)
11. Performance Guidelines (1 doc)

**Tiempo**: 7-11 horas

### Fase 4: Baja (Compliance, no technical gap)
12. Accessibility Standards (1 doc)

**Tiempo**: 1-2 horas

---

## PRÓXIMO PASO

👉 Ver `structure-proposal.md` para arquitectura recomendada que incorpore gaps
