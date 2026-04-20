# Development: SDLC Framework Summary & Bounded Context Mapping

**Fase:** 06-development | **Audiencia:** All team members | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [SDLC Framework Overview](#sdlc-framework-overview)
2. [Bounded Context Mapping](#bounded-context-mapping)
3. [DDD Lens Applied](#ddd-lens-applied)
4. [Execution Guide](#execution-guide)

---

## SDLC Framework Overview

### The Cycle

```
Discovery → Requirements → Design & Process → UI Design → Data Model
    ↓                                                          ↓
Feedback ←── Monitoring ←── Operations ←── Deployment ←── Development ←── Testing ←── Planning
    ↓
(iterate per feature or domain)
```

### 13 Phases

| Phase | Folder | Focus | Owner |
|-------|--------|-------|-------|
| **SP-0** | `00-PLANNING/` | Framework, metadocs, governance | Leadership |
| **SP-D1** | `01-discovery/` | Problem, context, vision, actors | Product |
| **SP-D2** | `02-requirements/` | What system must do (no tech) | Product/Backend |
| **SP-D3** | `03-design/` | Domain modeling (DDD), processes | Backend/Product |
| **SP-D4** | `03-design/ui/` | UI, portals, screens | Design/Frontend |
| **SP-D5** | `04-data-model/` | Entities, ERD, schemas | Backend |
| **SP-D6** | `05-planning/` | Roadmap, epics, versioning | Product |
| **SP-D7** | `06-development/` | Architecture, APIs, standards | Backend/Frontend |
| **SP-D8** | `07-testing/` | Test strategy, plans, criteria | QA/Backend |
| **SP-D9** | `08-deployment/` | CI/CD, pipelines, release | DevOps |
| **SP-D10** | `09-operations/` | Runbooks, incident response, SLAs | SRE/Ops |
| **SP-D11** | `10-monitoring/` | Metrics, alerts, dashboards | SRE/Backend |
| **SP-D12** | `11-feedback/` | Retrospectives, user feedback | Leadership/Product |

---

## Bounded Context Mapping

### Core Domains (Competitive Advantage)

```
┌─────────────────────────────────────────────┐
│         IDENTITY (Core)                     │
│  └─ User creation, authentication,          │
│  └─ OAuth2/OIDC, refresh token rotation     │
│  └─ Session management                      │
└─────────────────────────────────────────────┘
         │
         ├─► ACCESS CONTROL (Core)
         │   └─ Role-based access (RBAC)
         │   └─ Tenant-level permissions
         │   └─ Resource-level policies
         │
         └─► ORGANIZATION (Supporting)
             └─ Tenant management
             └─ User memberships
             └─ App registration

┌─────────────────────────────────────────────┐
│      BILLING (Supporting)                   │
│  └─ Plans, subscriptions, charges           │
│  └─ Usage tracking, metering                │
│  └─ Invoice generation                      │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│      AUDIT (Supporting)                     │
│  └─ Event logging (immutable)               │
│  └─ Compliance reporting                    │
│  └─ Historical analysis                     │
└─────────────────────────────────────────────┘
```

### Integration Patterns

| Source | Target | Pattern | Protocol |
|--------|--------|---------|----------|
| **Identity** | Access Control | Synchronous | REST |
| **Access Control** | Audit | Asynchronous | Event queue |
| **Billing** | Organization | Synchronous | REST |
| **Organization** | Audit | Asynchronous | Event queue |
| **Identity** | Audit | Asynchronous | Event queue |

---

## DDD Lens Applied

### Language & Terms

Each context has **ubiquitous language** terms developers and domain experts agree on:

```
IDENTITY Context:
  - User (entity)
  - Email (value object)
  - AuthenticationAttempt (event)
  - RefreshTokenRotated (event)
  - PasswordHasher (factory)
  - UserRepository (interface)

ACCESS CONTROL Context:
  - Permission (value object)
  - Policy (aggregate root)
  - RoleAssignment (entity)
  - PermissionDenied (event)
  - PolicyEvaluator (service)

ORGANIZATION Context:
  - Tenant (aggregate root)
  - Member (entity)
  - Membership (entity)
  - TenantCreated (event)
  - TenantSuspended (event)
```

### Aggregate Boundaries

```
IDENTITY Aggregate:
  └─ User (root)
     ├─ sessions[] (owned)
     └─ failed_attempts (transient)

ACCESS CONTROL Aggregate:
  └─ Policy (root)
     ├─ rules[] (owned)
     └─ exemptions[] (owned)

ORGANIZATION Aggregate:
  └─ Tenant (root)
     ├─ members[] (owned)
     └─ apps[] (owned reference)
```

---

## Execution Guide

### Day 1: Setup (Onboard Developers)

1. Clone `keygo-docs` repo
2. Read `00-PLANNING/sdlc-framework.md` (15 min)
3. Read `02-requirements/README.md` (15 min)
4. Read `03-design/strategic-design.md` (20 min)
5. Read relevant Bounded Context doc (20 min)

**Total:** ~1 hour onboarding

### Week 1: Architecture

1. Read `06-development/architecture.md`
2. Read `06-development/code-style-guide.md`
3. Review `06-development/api-endpoints-comprehensive.md`
4. Understand tenant isolation from `04-data-model/README.md`

### Development: Reference Docs As Needed

```bash
# Working on auth?
→ Read 06-development/oauth2-oidc-contract.md
→ Read 06-development/frontend-auth-implementation.md

# Need to add endpoint?
→ Read 06-development/api-versioning-strategy.md
→ Read 06-development/api-documentation-standard.md
→ Check 06-development/api-endpoints-comprehensive.md for pattern

# Debugging?
→ Read 06-development/debugging-guide.md

# Performance issues?
→ Read 06-development/database-performance-optimization.md

# Security concern?
→ Read 06-development/security-implementation-guide.md
```

### Testing & Deployment

```bash
# Before committing:
→ Read 07-testing/test-strategy.md
→ Check 07-testing/test-plans.md for your context

# Before deploying:
→ Read 08-deployment/pipeline-strategy.md
→ Read 09-operations/production-runbook.md

# Incident?
→ Read 10-monitoring/incident-response-guide.md
```

---

## Key Conventions

### Naming

- **Domain Classes**: Use domain language (`User`, not `UserData`)
- **Value Objects**: No suffix (`Email`, `Permission`, `TenantSlug`)
- **Use Cases**: `<Action><Entity>UseCase` (`GetServiceInfoUseCase`)
- **Exceptions**: `<Concept>Exception` (`TenantNotFoundException`)

### Package Structure

```
com.keygo.<context>/
  ├─ controller/    (REST endpoints)
  ├─ request/       (DTOs in)
  ├─ response/      (DTOs out)
  ├─ usecase/       (application layer)
  ├─ port/          (outbound interfaces)
  ├─ entity/        (JPA entities)
  ├─ repository/    (Spring Data interfaces)
  └─ persistence/   (Repository adapters)
```

### Validation Layers

```
HTTP Layer:     @NotBlank, @Size, @Email (bean validation)
Domain Layer:   Value Objects with invariant checks
Use Case Layer: Contextual validation (uniqueness, preconditions)
```

---

## Documentation Maturity

### Phases Completed

- ✅ Phase 1: CRITICAL (12 docs, ~150 KB) — Auth & foundations
- ✅ Phase 2: IMPORTANT (12 docs, ~50 KB) — Operations & UI flows
- 🟡 Phase 3: OPTIONAL (9 docs, ~65 KB, in progress) — Dev productivity

### Total Coverage

**32 documentation artifacts across 11 phases, ~265 KB**

All written with:
- DDD strategic lens (bounded contexts, ubiquitous language)
- Examples and anti-patterns
- Cross-references (no silos)
- Operational focus (not just theory)

---

## Véase También

- **00-PLANNING/sdlc-framework.md** — Full framework definition
- **03-design/strategic-design.md** — Subdomain classification
- **03-design/context-map.md** — Detailed context relationships
- **README.md** — Entry point for all docs

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Leadership/Arch | **Licencia:** Keygo Docs
