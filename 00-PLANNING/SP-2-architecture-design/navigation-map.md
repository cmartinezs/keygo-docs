# Navigation Map - Cómo Se Conectan Las Secciones

**Estado**: SP-2 - Mapa de navegación  
**Fecha**: 2026-04-19

---

## Rutas de Navegación por Rol

### Para Product Manager

```
START: INDEX.md → "Product Manager" section

1. Read Product Vision
   └── 01-product/vision.md
   
2. Understand Requirements
   └── 01-product/requirements.md
   
3. Review Glossary
   └── 01-product/glossary.md
   
4. See Features Visually
   └── 01-product/diagrams/
   
5. Track Decisions
   └── 04-decisions/adr/  (architecture decision records)
   
6. See Roadmap/Dependencies
   └── 01-product/dependency-map.md
```

**Direct links**:
- Roadmap tracking → 04-decisions/decisions-log.md
- Feature requests → 02-functional/[feature]/01-architecture.md
- Tech constraints → 03-architecture/

---

### Para Backend Developer (Nuevo)

```
START: INDEX.md → "Backend Developer" section

1. Setup Local Environment
   └── 07-operations/development-setup/01-prerequisites.md
   └── 07-operations/development-setup/02-backend-setup.md
   └── 07-operations/development-setup/06-troubleshooting.md
   
2. Understand Architecture
   └── 03-architecture/system-design/01-system-overview.md
   
3. Learn Key Concepts
   └── 01-product/glossary.md
   └── 03-architecture/patterns/
   
4. Pick a Feature to Work On
   └── 02-functional/[feature]/01-architecture.md  (agnóstic)
   └── 02-functional/[feature]/02-backend-implementation.md  (your part)
   
5. Understand API Contracts
   └── 08-reference/api/01-api-conventions.md
   └── 08-reference/api/02-endpoint-catalog.md
   
6. Write Tests
   └── 06-quality/testing/02-integration-testing.md
   
7. Deploy to Production
   └── 07-operations/deployment/02-backend-deployment.md
   
8. If Something Breaks
   └── 07-operations/production-runbooks/01-backend-runbook.md
```

**Key links to bookmark**:
- API conventions → 08-reference/api/01-api-conventions.md
- Architecture patterns → 03-architecture/patterns/
- Test strategy → 06-quality/testing/01-test-strategy.md

---

### Para Frontend Developer (Nuevo)

```
START: INDEX.md → "Frontend Developer" section

1. Setup Local Environment
   └── 07-operations/development-setup/01-prerequisites.md
   └── 07-operations/development-setup/03-frontend-setup.md
   └── 07-operations/development-setup/06-troubleshooting.md
   
2. Understand Architecture
   └── 03-architecture/system-design/01-system-overview.md
   
3. Learn Key Concepts
   └── 01-product/glossary.md
   └── 03-architecture/patterns/
   
4. Pick a Feature to Work On
   └── 02-functional/[feature]/01-architecture.md  (agnóstic)
   └── 02-functional/[feature]/03-frontend-implementation.md  (your part)
   
5. Understand Backend API You'll Use
   └── 08-reference/api/02-endpoint-catalog.md
   └── 08-reference/api/01-api-conventions.md
   └── 02-functional/[feature]/02-backend-implementation.md  (what backend built)
   
6. Handle Errors Properly
   └── 08-reference/api/03-error-codes.md
   └── 08-reference/api/04-error-handling-guide.md
   
7. Write Tests
   └── 06-quality/testing/02-integration-testing.md
   
8. Deploy to Production
   └── 07-operations/deployment/03-frontend-deployment.md
   
9. If Something Breaks
   └── 07-operations/production-runbooks/02-frontend-runbook.md
```

**Key links to bookmark**:
- Endpoint catalog → 08-reference/api/02-endpoint-catalog.md
- Error handling → 08-reference/api/04-error-handling-guide.md
- Test strategy → 06-quality/testing/01-test-strategy.md

---

### Para DevOps / SRE

```
START: INDEX.md → "DevOps/SRE" section

1. Understand System
   └── 03-architecture/system-design/01-system-overview.md
   
2. Setup Infrastructure
   └── 07-operations/infrastructure/01-docker-setup.md
   └── 07-operations/infrastructure/02-environment-variables.md
   
3. Configure CI/CD
   └── 07-operations/deployment/01-deployment-strategy.md
   └── 07-operations/deployment/02-backend-deployment.md
   └── 07-operations/deployment/03-frontend-deployment.md
   
4. Configure Security
   └── 07-operations/security-operations/01-oauth2-configuration.md
   └── 07-operations/security-operations/02-secret-rotation.md
   └── 06-quality/security/02-hardening-guide.md
   
5. Setup Monitoring
   └── 07-operations/monitoring-and-alerts/01-monitoring-setup.md
   └── 03-architecture/observability/
   
6. Create Runbooks
   └── 07-operations/production-runbooks/
   
7. Handle Incidents
   └── 07-operations/production-runbooks/03-incident-response.md
   └── 07-operations/security-operations/03-security-incident-response.md
```

**Key links to bookmark**:
- Deployment strategy → 07-operations/deployment/
- Security configuration → 07-operations/security-operations/
- Incident response → 07-operations/production-runbooks/

---

### Para Tech Lead / Architect

```
START: INDEX.md → "Technical Leader" section

1. System Design
   └── 03-architecture/system-design/
   
2. Design Patterns
   └── 03-architecture/patterns/
   
3. Key Decisions
   └── 04-decisions/adr/
   └── 04-decisions/rfcs/
   
4. Feature Designs
   └── 02-functional/[feature]/01-architecture.md
   
5. Quality Standards
   └── 06-quality/
   
6. Data Model
   └── 03-architecture/data-and-persistence/01-data-model.md
   └── 08-reference/data-models/
   
7. Security Architecture
   └── 03-architecture/security/
   └── 06-quality/security/
```

---

## Rutas de Navegación por Tarea

### "I'm new, where do I start?"

```
1. Read README.md (raíz)
2. Follow INDEX.md role-based guide
3. Read 07-operations/development-setup/
4. Read your feature's 01-architecture.md
5. Read your feature's implementation guide (02 or 03)
6. Run tests, understand test strategy
7. Ask in dev-slack with specific questions
```

---

### "How do I implement feature X?"

```
1. Go to 02-functional/[feature-name]/
2. Read 01-architecture.md (agnóstico)
3. Read 02-backend-impl.md OR 03-frontend-impl.md (tu parte)
4. Check 04-integration-guide.md if you need to understand both sides
5. If it involves security/auth: also read 03-architecture/security/
6. Check tests: 06-quality/testing/
7. If REST API involved: 08-reference/api/01-api-conventions.md
```

---

### "There's a bug in production, help!"

```
For Backend Issues:
1. Read 07-operations/production-runbooks/01-backend-runbook.md
2. Check specific incident (auth, billing, etc)
3. If you need to understand feature: go to 02-functional/[feature]/02-backend-impl.md

For Frontend Issues:
1. Read 07-operations/production-runbooks/02-frontend-runbook.md
2. Check specific incident
3. If you need to understand feature: go to 02-functional/[feature]/03-frontend-impl.md

For Security Issues:
1. Read 07-operations/security-operations/03-security-incident-response.md
2. Read 06-quality/security/
3. Follow escalation procedures
```

---

### "I need to understand multi-tenant architecture"

```
1. Start with 01-product/glossary.md → "Multi-tenant" entry
2. Read 03-architecture/system-design/02-multi-tenant-architecture.md
3. Read 03-architecture/data-and-persistence/03-multi-tenant-data-isolation.md
4. Read relevant ADR: 04-decisions/adr/adr-003-multi-tenant-model.md
5. Check RFC if still active: 04-decisions/rfcs/restructure-multitenant/
6. Check implementation in a feature: 02-functional/[any-feature]/02-backend-impl.md
```

---

### "I want to propose a new feature"

```
1. Read 01-product/requirements.md (understand what already exists)
2. Check 02-functional/ (what's implemented)
3. Read 03-architecture/ (technical constraints)
4. Check 04-decisions/rfcs/README.md (how to propose RFCs)
5. Check 04-decisions/adr/README.md (if it involves architectural decisions)
6. Write RFC in 04-decisions/rfcs/[new-feature]/
7. Reference 01-product/diagrams/ if adding a flow
```

---

### "I need to update a decision or architecture"

```
1. Locate the ADR or RFC in 04-decisions/
2. Check status (Proposed, Accepted, Deprecated)
3. If Accepted, you're proposing to update/deprecate it
4. Create new ADR with new decision
5. Mark old one as "Superseded by ADR-XXX"
6. Update any documentation that referenced old decision
7. Search for cross-references: `grep -r "adr-XXX"` or `grep -r "RFC-name"`
```

---

## Sección a Sección Navigation

```
01-PRODUCT
  ├── Link to: 02-functional/[features] (how is this requirement implemented?)
  ├── Link to: 03-architecture/ (technical constraints)
  └── Link to: 04-decisions/ (decisions about product direction)

02-FUNCTIONAL
  ├── Link from: 01-product/ (which requirements does this implement?)
  ├── Link to: 03-architecture/ (architectural patterns used)
  ├── Link to: 04-decisions/ (decisions about this feature)
  └── Link to: 08-reference/api/ (API contracts)

03-ARCHITECTURE
  ├── Link from: 02-functional/[features] (which patterns are used?)
  ├── Link from: 04-decisions/ (why these patterns?)
  └── Link to: 06-quality/ (quality standards for patterns)

04-DECISIONS
  ├── Link from: 03-architecture/ (which decisions drive architecture?)
  ├── Link from: 02-functional/ (decisions about features)
  └── Link to: Related documents (if decision references something)

06-QUALITY
  ├── Link from: 02-functional/ (how to test this feature?)
  ├── Link from: 03-architecture/ (quality standards)
  └── Link to: 07-operations/ (how to deploy safely?)

07-OPERATIONS
  ├── Link from: 06-quality/ (quality gates before deployment)
  ├── Link to: 03-architecture/ (understanding system for operations)
  └── Link to: 08-reference/ (API, data models)

08-REFERENCE
  ├── Link from: All sections (for detailed references)
  └── Link to: 01-product/glossary.md (terminology)
```

---

## Index.md (Homepage) Structure

```markdown
# Keygo Documentation

## Quick Navigation by Role
- [Product Manager](#product-manager)
- [Backend Developer](#backend-developer)
- [Frontend Developer](#frontend-developer)
- [DevOps/SRE](#devopssre)
- [Technical Leader](#technical-leader)

## Quick Links (Frequently Visited)
- [Glossary](01-product/glossary.md) - Terms & definitions
- [API Endpoints](08-reference/api/02-endpoint-catalog.md) - All endpoints
- [Architecture Overview](03-architecture/system-design/01-system-overview.md) - How it works
- [Getting Started](07-operations/development-setup/) - Local setup

## By Topic
- [Authentication](02-functional/authentication/) - Login, OAuth2, JWT
- [Billing](02-functional/billing/) - Payments, contractor model
- [Multi-Tenant](03-architecture/system-design/02-multi-tenant-architecture.md) - Isolation, scopes
- [Security](06-quality/security/) - Hardening, guidelines
- [Deployment](07-operations/deployment/) - CI/CD, production

## Recent Decisions
- [See decisions-log.md](04-decisions/decisions-log.md)

## Contributing
See [CLAUDE.md](CLAUDE.md) for contribution guidelines.
```

---

## Móvil / Offline Considerations

**Links should work**:
- ✅ Relative paths (offline access)
- ✅ No external dependencies
- ✅ Plain markdown (can be read in any editor)

**Avoid**:
- ❌ Embedded YouTube videos (no offline)
- ❌ Links to internal wikis/Confluence (might be down)
- ❌ Special markdown extensions (not all renderers support)

---

## Próximo Paso

👉 Ver `index-structure.md` para diseño detallado del índice central  
👉 Completar SP-2 para proceder a SP-3 (consolidación)
