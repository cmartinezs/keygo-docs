# Index Structure - Diseño de Índices Centrales

**Estado**: SP-2 - Índices y entry points  
**Fecha**: 2026-04-19

---

## INDEX.md (Raíz - Homepage)

**Ubicación**: `keygo-docs/INDEX.md`

**Propósito**: Punto de entrada único, navegación por rol, quick links

**Estructura**:

```markdown
# Keygo Documentation

One source of truth for Keygo backend and frontend teams.

---

## 🚀 Start Here

**[↓ Jump to your role](#quick-start-by-role)** | 
**[Browse by topic](#by-topic)** | 
**[See recent decisions](#recent-decisions)**

---

## Quick Start by Role

### Product Manager
- **[Product Vision](01-product/vision.md)** - What we're building
- **[Requirements](01-product/requirements.md)** - Functional + non-functional specs
- **[Glossary](01-product/glossary.md)** - Canonical terminology
- **[Dependencies](01-product/dependency-map.md)** - Feature dependencies
- **[Diagrams](01-product/diagrams/)** - Use cases, flows
- **[Decisions](04-decisions/adr/)** - Architecture decisions
- **[Timeline](04-decisions/decisions-log.md)** - Decision history

**[→ Full Product Manager Guide](DOCS_FOR_PRODUCT_MANAGERS.md)**

### Backend Developer
- **[Environment Setup](07-operations/development-setup/02-backend-setup.md)** - Get up and running
- **[System Overview](03-architecture/system-design/01-system-overview.md)** - Architecture at 10,000ft
- **[Glossary](01-product/glossary.md)** - Learn the terminology
- **[Architecture Patterns](03-architecture/patterns/)** - Design patterns we use
- **[API Conventions](08-reference/api/01-api-conventions.md)** - How to design APIs
- **[Test Strategy](06-quality/testing/01-test-strategy.md)** - How to test
- **[Deployment Guide](07-operations/deployment/02-backend-deployment.md)** - How to ship
- **[Troubleshooting](07-operations/production-runbooks/01-backend-runbook.md)** - When things break

**[→ Full Backend Developer Guide](DOCS_FOR_BACKEND_DEVS.md)**

### Frontend Developer
- **[Environment Setup](07-operations/development-setup/03-frontend-setup.md)** - Get up and running
- **[System Overview](03-architecture/system-design/01-system-overview.md)** - Architecture at 10,000ft
- **[Glossary](01-product/glossary.md)** - Learn the terminology
- **[Design Patterns](03-architecture/patterns/)** - Design patterns we use
- **[API Reference](08-reference/api/02-endpoint-catalog.md)** - Endpoints you'll use
- **[Error Handling](08-reference/api/04-error-handling-guide.md)** - How to handle errors
- **[Test Strategy](06-quality/testing/01-test-strategy.md)** - How to test
- **[Deployment Guide](07-operations/deployment/03-frontend-deployment.md)** - How to ship
- **[Troubleshooting](07-operations/production-runbooks/02-frontend-runbook.md)** - When things break

**[→ Full Frontend Developer Guide](DOCS_FOR_FRONTEND_DEVS.md)**

### DevOps / SRE
- **[System Overview](03-architecture/system-design/01-system-overview.md)** - What you're running
- **[Infrastructure Setup](07-operations/infrastructure/)** - Docker, environment variables
- **[Deployment Strategy](07-operations/deployment/01-deployment-strategy.md)** - CI/CD overview
- **[Security Setup](07-operations/security-operations/)** - OAuth2, secrets, hardening
- **[Monitoring](07-operations/monitoring-and-alerts/)** - Observability setup
- **[Incident Response](07-operations/production-runbooks/03-incident-response.md)** - When things break
- **[Architecture](03-architecture/)** - Understanding system design

**[→ Full DevOps/SRE Guide](DOCS_FOR_DEVOPS.md)**

### Technical Leader
- **[System Architecture](03-architecture/system-design/)** - Design philosophy
- **[Design Patterns](03-architecture/patterns/)** - Patterns we use
- **[Decisions Log](04-decisions/decisions-log.md)** - What we decided and why
- **[ADRs](04-decisions/adr/)** - Architecture Decision Records
- **[RFCs](04-decisions/rfcs/)** - Active proposals
- **[Feature Designs](02-functional/)** - How features are designed
- **[Quality Standards](06-quality/)** - Testing, security, code standards

**[→ Full Technical Leader Guide](DOCS_FOR_TECHNICAL_LEADERS.md)**

---

## By Topic

### Core Concepts
- **[Glossary](01-product/glossary.md)** - Terminology reference
- **[System Overview](03-architecture/system-design/01-system-overview.md)** - How it all fits together

### Features
- **[Authentication](02-functional/authentication/)** - Login, OAuth2, JWT
- **[Billing](02-functional/billing/)** - Payment processing, contractor model
- **[Account Management](02-functional/account-management/)** - User accounts
- **[Tenant Management](02-functional/tenant-management/)** - Multi-tenancy
- **[Admin Console](02-functional/admin-console/)** - Administration
- **[Email Notifications](02-functional/email-notifications/)** - Email templates, delivery

### Architecture
- **[Multi-Tenant Architecture](03-architecture/system-design/02-multi-tenant-architecture.md)** - Data isolation
- **[Authentication Architecture](03-architecture/security/01-authentication-architecture.md)** - OAuth2, OIDC
- **[Authorization Architecture](03-architecture/security/02-authorization-architecture.md)** - Scopes, permissions
- **[Data Model](03-architecture/data-and-persistence/01-data-model.md)** - Entities, relationships
- **[Design Patterns](03-architecture/patterns/)** - Patterns we use

### APIs & Integration
- **[API Conventions](08-reference/api/01-api-conventions.md)** - How we design APIs
- **[Endpoint Catalog](08-reference/api/02-endpoint-catalog.md)** - All endpoints
- **[Error Handling](08-reference/api/04-error-handling-guide.md)** - Error responses
- **[Integration Examples](08-reference/integration-examples/)** - Code examples

### Quality & Operations
- **[Test Strategy](06-quality/testing/01-test-strategy.md)** - How to test
- **[Security Hardening](06-quality/security/02-hardening-guide.md)** - Security best practices
- **[Deployment](07-operations/deployment/)** - How to ship to production
- **[Incident Response](07-operations/production-runbooks/)** - When things break
- **[Local Setup](07-operations/development-setup/)** - Getting started locally

---

## Recent Decisions

**Latest ADRs & RFCs**:
- [See decisions-log.md](04-decisions/decisions-log.md) for chronological history
- [Browse all ADRs](04-decisions/adr/) for architecture decisions
- [Browse all RFCs](04-decisions/rfcs/) for active proposals

---

## FAQ (Frequently Asked Questions)

### "I'm new, where do I start?"
1. Read [System Overview](03-architecture/system-design/01-system-overview.md)
2. Read [Glossary](01-product/glossary.md)
3. Follow your role's [Quick Start](#quick-start-by-role)
4. Setup your local environment
5. Read your feature's architecture document
6. Ask questions in dev Slack!

### "How do I implement feature X?"
Go to [02-functional/feature-x/](02-functional/) and follow:
1. `01-architecture.md` (agnóstico - ¿qué hace?)
2. `02-backend-implementation.md` or `03-frontend-implementation.md` (tu parte)
3. `04-integration-guide.md` if you need to understand both sides

### "There's a bug in production, help!"
1. Go to [07-operations/production-runbooks/](07-operations/production-runbooks/)
2. Pick your incident type
3. Follow the runbook
4. If still stuck, check [Architecture](03-architecture/) for background

### "I want to propose a change"
See [04-decisions/adr/README.md](04-decisions/adr/) for how to propose an Architecture Decision
or [04-decisions/rfcs/README.md](04-decisions/rfcs/) for proposals

### "How do I understand the data model?"
1. Start with [Glossary](01-product/glossary.md) for entity definitions
2. Read [Data Model Overview](03-architecture/data-and-persistence/01-data-model.md)
3. Check [Entity Relationships](08-reference/data-models/02-entity-relationships.md)
4. See [Database Schema](08-reference/data-models/04-database-schema.md) for actual structure

### "Where's the API documentation?"
See [08-reference/api/02-endpoint-catalog.md](08-reference/api/02-endpoint-catalog.md)
- Organized by feature/domain
- Includes request/response specs
- Links to implementation docs

### "How do I write tests?"
Read [06-quality/testing/01-test-strategy.md](06-quality/testing/01-test-strategy.md)
- Unit testing approach
- Integration testing with database
- E2E testing approach
- Test data setup

### "How do I deploy?"
Your role:
- **Backend**: [07-operations/deployment/02-backend-deployment.md](07-operations/deployment/02-backend-deployment.md)
- **Frontend**: [07-operations/deployment/03-frontend-deployment.md](07-operations/deployment/03-frontend-deployment.md)
- **DevOps**: [07-operations/deployment/01-deployment-strategy.md](07-operations/deployment/01-deployment-strategy.md)

---

## Documentation Standards

This documentation follows:
- **[Naming Conventions](00-PLANNING/SP-2-architecture-design/naming-conventions.md)** - How we name files
- **[Navigation Map](00-PLANNING/SP-2-architecture-design/navigation-map.md)** - How to find things
- **[Information Architecture](00-PLANNING/SP-2-architecture-design/information-architecture.md)** - Structure

---

## Contributing

See [CLAUDE.md](CLAUDE.md) for:
- How to update documentation
- What to avoid when editing
- How to propose new sections

---

## Section READMEs

Each major section has its own README:
- **[01-product/](01-product/README.md)** - Product vision, requirements, glossary
- **[02-functional/](02-functional/README.md)** - Feature guides and how-to docs
- **[03-architecture/](03-architecture/README.md)** - Architecture and design patterns
- **[04-decisions/](04-decisions/README.md)** - ADRs, RFCs, decisions
- **[06-quality/](06-quality/README.md)** - Testing, security, standards
- **[07-operations/](07-operations/README.md)** - Setup, deployment, runbooks
- **[08-reference/](08-reference/README.md)** - APIs, data models, examples
- **[99-archive/](99-archive/README.md)** - Historical, deprecated content

---

Last updated: 2026-04-19
```

---

## Role-Specific Entry Points

### DOCS_FOR_PRODUCT_MANAGERS.md

```markdown
# Documentation for Product Managers

[Curated list of documents in the order a PM would read them]

1. Start with vision and requirements
2. Understand glossary
3. See product diagrams
4. Track decisions
5. Monitor roadmap/dependencies
```

### DOCS_FOR_BACKEND_DEVS.md

Similar structure, organized for backend developer workflow.

### DOCS_FOR_FRONTEND_DEVS.md

Similar structure, organized for frontend developer workflow.

### DOCS_FOR_DEVOPS.md

Similar structure, organized for DevOps workflow.

### DOCS_FOR_TECHNICAL_LEADERS.md

Similar structure, organized for technical leadership/architecture.

---

## Cada Sección Tiene Un README.md

### Estructura de README en cada sección

```markdown
# [Sección Name]

**Purpose**: One-line description

**This section contains**:
- subsection-1/ - Description
- subsection-2/ - Description
- document-1.md - Description
- document-2.md - Description

**Read in this order** (for first-timers):
1. [Start here](01-intro.md)
2. [Then this](02-concepts.md)
3. [Finally this](03-implementation.md)

**Quick links**:
- [Related section A](../XX-section-a/)
- [Related section B](../XX-section-b/)

**Next steps**:
- [← Previous section](../XX-previous/)
- [→ Next section](../XX-next/)
```

---

## Landing Page Design

**Visual hierarchy**:

```
┌─────────────────────────────────────────┐
│  Keygo Documentation                     │
│  One source of truth for Keygo           │
└─────────────────────────────────────────┘
         ↓
┌─ Quick Navigation by Role ──────────────┐
│  [Product] [Backend] [Frontend] [DevOps]│
│  [Tech Lead] [New Team Member]           │
└──────────────────────────────────────────┘
         ↓
┌─ By Topic ──────────────────────────────┐
│  [Authentication] [Billing] [API]        │
│  [Architecture] [Testing] [Deployment]   │
└──────────────────────────────────────────┘
         ↓
┌─ Recent Decisions ──────────────────────┐
│  Latest ADRs and RFCs                    │
└──────────────────────────────────────────┘
```

---

## Próximo Paso

✅ SP-2: Arquitectura de documentación completada

**Entregables**:
- ✅ information-architecture.md - Jerarquía final
- ✅ naming-conventions.md - Estándares
- ✅ navigation-map.md - Rutas de navegación
- ✅ index-structure.md - Índices (este)

👉 **SP-3: Consolidación** - Comenzar a mover y consolidar archivos según la arquitectura
