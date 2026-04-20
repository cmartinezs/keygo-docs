# Planning: Product Roadmap & Versioning

**Fase:** 05-planning | **Audiencia:** Product, Leadership, Engineering | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Product Vision](#product-vision)
2. [Versioning Strategy](#versioning-strategy)
3. [Release Horizons](#release-horizons)
4. [Feature Prioritization Matrix](#feature-prioritization-matrix)

---

## Product Vision

**KeyGo** is a multi-tenant identity and access management platform for SaaS teams.

**Core Value Proposition:**
- Centralized user authentication across all your apps
- Role-based access control (RBAC) with multi-level tenant isolation
- OAuth2 / OIDC compliance for enterprise security
- Out-of-the-box compliance (SOC2, GDPR, CFDI support)

**Target Customers:**
- Early-stage SaaS companies (10-50 employees)
- Enterprise teams needing compliance-ready IAM
- Platforms with white-label requirements

**Competitive Advantages:**
1. **Easy Setup**: 15 minutes to first OAuth2 flow
2. **Multi-Tenancy**: Native tenant isolation at DB level
3. **Compliance**: SOC2, GDPR, audit logs included
4. **Developer-Friendly**: REST API, SDKs, clear documentation

---

## Versioning Strategy

### Semantic Versioning (SemVer)

```
MAJOR.MINOR.PATCH
  │      │      └─ Hotfixes, bug fixes (non-breaking)
  │      └─────────── Features, enhancements (backward-compatible)
  └─────────────────── Breaking changes (rare, planned quarters ahead)
```

### Release Types

| Type | Version | Frequency | Time to Prod | Example |
|------|---------|-----------|--------------|---------|
| **Hotfix** | v1.0.1 | As-needed | < 5 min | Critical bug fix |
| **Feature Release** | v1.1.0 | Every 2-4 weeks | 30-60 min | New API endpoint |
| **Major Release** | v2.0.0 | Quarterly | 2-4 hours | Breaking API change |

### Lifecycle Phases

```
DEVELOPMENT (v1.1.0-dev)
  ├─ Features actively added
  ├─ Breaking changes allowed
  └─ Not for production
         │
         ▼
BETA (v1.1.0-beta.1, beta.2, ...)
  ├─ Limited testing in production
  ├─ Stable API (no more breaking changes)
  └─ Performance & security validation
         │
         ▼
RELEASE (v1.1.0)
  ├─ Production-ready
  ├─ 6-month support window
  └─ Bug fixes only
         │
         ▼
DEPRECATED (v1.0.0)
  ├─ Still supported for 6 months
  ├─ No new features backported
  └─ Users encouraged to upgrade
         │
         ▼
SUNSET (v1.0.0)
  └─ Support ends, deprecated endpoint removed
```

### Deprecation Policy

**Minimum 6-month grace period** before removing deprecated endpoints:

```
Month 1: New endpoint released (v1.1.0)
         Old endpoint marked deprecated (response header: Deprecation: true)
         Client warning in docs

Month 2-6: Grace period
           Support team helps clients migrate

Month 7: Old endpoint removed (v2.0.0)
```

**Example Response Header:**
```
HTTP/1.1 200 OK
Deprecation: true
Sunset: Mon, 30 Sep 2026 23:59:59 GMT
Link: </api/v2/users>; rel="successor-version"
```

---

## Release Horizons

### Q2 2026 (Current)

**Focus:** Auth Security & Foundation

```
v1.1.0 (April)  — OAuth2 hardening, PKCE mandatory, token rotation
v1.2.0 (May)    — Admin console MVP, tenant management UI
v1.3.0 (June)   — RBAC enhancements, policy-based access
```

**Hitos:**
- HITO 1 (April 30): Backend auth complete, frontend scaffolding
- HITO 2 (May 15): Admin UI in beta
- HITO 3 (June 30): Q2 release ready for customer pilots

---

### Q3 2026 (Planned)

**Focus:** Billing & Multi-App Support

```
v1.4.0 (July)   — Billing integration (Stripe)
v1.5.0 (Aug)    — Multi-app tenant support
v1.6.0 (Sep)    — Reporting & analytics
```

---

### Q4 2026 (Roadmap)

**Focus:** Enterprise Features

```
v2.0.0 (Oct-Nov)   — Major release: SSO, SAML, multi-identity providers
v2.1.0 (Dec)       — Advanced RBAC (attribute-based access control)
```

---

## Feature Prioritization Matrix

### Impact vs Effort

```
         High Effort
              │
    ┌─────────┼─────────┐
    │         │         │
 H  │  (Avoid)│ Strategic│
 i  │         │(Do later)│
 g  │─────────┼─────────│
 h  │ (Quick  │ (Do now)│
 I  │  wins)  │         │
 m  │         │         │
 p  └─────────┼─────────┘
 a      Low          High
 c      Effort       Effort
 t
```

### Q2 2026 Priority

| Feature | Impact | Effort | Priority | Owner | Status |
|---------|--------|--------|----------|-------|--------|
| OAuth2 PKCE | High | High | P0 | Backend | ✅ In Progress |
| Admin UI | High | High | P0 | Frontend | ✅ In Progress |
| RBAC v1 | High | Medium | P1 | Backend | Planned |
| Email Verification | Medium | Low | P1 | Backend | Planned |
| Audit Logging | High | Medium | P2 | Backend | Planned |
| Rate Limiting | Medium | Low | P2 | Backend | Planned |
| API Documentation | Medium | Medium | P3 | DevOps | Planned |

---

## Go-to-Market Strategy

### Phase 1: Pilot (Q2)
- Close 2-3 beta customers
- Get compliance certifications (SOC2)
- Gather feedback

### Phase 2: Beta Release (Q3)
- Public beta program
- 50+ signups target
- Refine based on feedback

### Phase 3: GA (Q4)
- General Availability release
- Pricing announcement
- Sales & marketing push

---

## Véase También

- **hitos-y-propuestas.md** — Detailed breakdown of Q2 hitos and 37 proposals
- **capability-matrix.md** — 60+ capabilities, status, and horizons
- **use-cases-catalog.md** — 52 use cases mapped to features

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Product | **Licencia:** Keygo Docs
