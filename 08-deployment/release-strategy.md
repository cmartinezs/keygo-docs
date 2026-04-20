# Deployment: Release Strategy & Notes

**Fase:** 08-deployment | **Audiencia:** Release managers, product leads | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Versioning Scheme](#versioning-scheme)
2. [Release Lifecycle](#release-lifecycle)
3. [Release Notes Template](#release-notes-template)
4. [Deprecation Policy](#deprecation-policy)
5. [Hotfix Process](#hotfix-process)

---

## Versioning Scheme

KeyGo usa **Semantic Versioning (SemVer): MAJOR.MINOR.PATCH**

```
1.0.0  ← Version format
│ │ └─ PATCH: bug fixes, security patches (1.0.0 → 1.0.1)
│ └──── MINOR: new features, backward compatible (1.0.0 → 1.1.0)
└────── MAJOR: breaking changes (1.0.0 → 2.0.0, rare)
```

### Release Types

| Version | Cadence | Example | Notes |
|---------|---------|---------|-------|
| **PATCH** | As needed | 1.0.1 | Hotfix for security, critical bug |
| **MINOR** | 2-4 weeks | 1.1.0 | New features, API additions, deprecations |
| **MAJOR** | Quarterly | 2.0.0 | Breaking changes, major refactor |

---

## Release Lifecycle

### Phase 1: Development (Ongoing)

```
develop branch:
  - PRs merged daily
  - Automated tests run on each push
  - Pre-release version: 1.1.0-rc1, 1.1.0-rc2, etc.
```

### Phase 2: Release Candidate (1 week)

```
release/1.1.0 branch:
  - Cut from develop
  - Final testing: smoke tests, E2E, security scan
  - Release candidate published: ghcr.io/keygo:1.1.0-rc1
  
  If issues:
    - Fix in release branch
    - Tag 1.1.0-rc2, test again
    - Merge back to develop
```

### Phase 3: Release

```
main branch:
  - Merge release branch
  - Tag v1.1.0
  - Build + sign image
  - Publish release notes
  - Deploy to staging for final verification
  - Manual approval
  - Deploy to production (blue-green)
```

### Phase 4: Post-Release

```
Support branch (if needed):
  - If 1.1.0 has critical bugs
  - Cut support/1.1.x
  - Patches: 1.1.1, 1.1.2, etc.
  - Backport critical fixes from develop
```

---

## Release Notes Template

### File: `RELEASE_NOTES_1.1.0.md`

```markdown
# KeyGo Server 1.1.0 — Released 2026-04-20

## Overview
Short description of release theme/focus.

## What's New

### Features
- **Multi-region deployment support**: Organizations can now deploy tenants in multiple regions with geo-replication
- **Enhanced audit logging**: All admin actions now captured with IP, User-Agent, timestamp
- **OIDC discovery caching**: /well-known/openid-configuration cached for 1h (reduces load)

### Improvements
- API response time reduced by 20% (database query optimization)
- Error messages now include correlation ID for better troubleshooting
- Admin console now shows real-time metrics (metrics endpoint improved)

### Security
- Fixed: XSS vulnerability in user profile page (CVE-2026-1234)
- Fixed: JWT validation bypass in refresh token rotation (T-035 implemented)
- Improved: Password policy enforcement (min 12 chars, 4 character classes)

### Bug Fixes
- Fixed: Tenant users unable to login after timezone change
- Fixed: Refresh token not rotated on mobile app after 30 days
- Fixed: Admin bulk user import failing on duplicate email

## Upgrade Notes

### For Operators
- **Database migrations**: Automatic (Flyway V34-V36)
- **Breaking changes**: None
- **New environment variables**: `KEYGO_AUDIT_LOG_RETENTION_DAYS=90` (optional)
- **Estimated downtime**: < 5 minutes (blue-green deployment)

### For Users
- No login required
- New features available immediately
- Performance improvements automatic

## Migration Guide

### From 1.0.x → 1.1.0
```bash
# 1. Backup database
pg_dump -U keygo_admin keygo > keygo_1.0.x.sql

# 2. Trigger deployment
kubectl set image deployment/keygo-server \
  keygo=ghcr.io/keygo/keygo-server:1.1.0

# 3. Monitor
kubectl logs -l app=keygo | grep "Flyway migration"

# If rollback needed
kubectl set image deployment/keygo-server \
  keygo=ghcr.io/keygo/keygo-server:1.0.5
```

## Deprecations & Removals

### Deprecated
- `GET /api/v1/platform/users` → Use `GET /api/v1/platform/account/profile` instead (removal in v2.0)
- OAuth2 scope `offline_access` → Use refresh token endpoint (removal in v2.0)

### Removed
- Removed support for JDK 17 (now requires JDK 21+)
- Removed deprecated endpoint `/api/v1/platform/oauth2/token-info` (use `/api/v1/platform/account/sessions` instead)

## Known Issues
- Multi-region replication has ~100ms latency (expected; see operations/incident-response for workaround)
- Admin audit log export exceeds 1GB on large tenants (recommend filtering by date range)

## Contributors
- @alice-dev
- @bob-ops
- @carol-security

## Links
- [GitHub Release](https://github.com/keygo/keygo-server/releases/tag/v1.1.0)
- [Full Changelog](https://github.com/keygo/keygo-server/compare/v1.0.5...v1.1.0)
- [Docker Image](https://ghcr.io/keygo/keygo-server:1.1.0)
- [OpenAPI Docs](https://api.example.com/v3/api-docs)
```

---

## Deprecation Policy

### Announcement Timeline

```
v1.0.0: Feature Deprecated
  "This endpoint will be removed in v2.0 (Q4 2026)"

v1.1.0: Deprecation Warning
  "Sunset scheduled for Q4 2026; use alternative: ..."
  
v1.2.0: Final Deprecation Warning
  "Removal in v2.0 (3 months); migrate now"
  
v2.0.0: Removal
  404 Not Found
```

### Grace Period: Minimum 6 Months

- Announcement published in release notes
- Deprecation header sent in API response: `Deprecation: true`, `Sunset: date`
- Documentation updated with alternative
- Support team notified

---

## Hotfix Process

### When Needed

```
Critical bug or security vulnerability found in 1.0.5 (production)

Timeline:
  T+0: Issue reported
  T+5 min: Triage & reproduce
  T+30 min: Fix ready (hotfix branch)
  T+45 min: Reviewed, tested
  T+60 min: Released as 1.0.6
  T+90 min: Deployed to production
```

### Hotfix Branch

```bash
# Create hotfix branch
git checkout -b hotfix/1.0.6 main

# Fix the issue
# Commit

# Tag
git tag -a v1.0.6 -m "Hotfix: security XSS in profile page"

# Merge back to develop
git checkout develop
git merge hotfix/1.0.6

# Clean up
git branch -d hotfix/1.0.6
```

---

## Véase Also

- **pipeline-strategy.md** — How releases are built and deployed
- **production-runbook.md** — Upgrade procedure from operations perspective
- **environment-setup.md** — Testing each release in staging

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Release Eng | **Licencia:** Keygo Docs
