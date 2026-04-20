# Testing: Security Testing Plan

**Fase:** 07-testing | **Audiencia:** QA, security engineers, compliance | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Testing Strategy](#testing-strategy)
2. [OWASP Top 10](#owasp-top-10)
3. [Compliance: SOC2, GDPR](#compliance-soc2-gdpr)
4. [PII & Data Protection](#pii--data-protection)
5. [Automated Security Scanning](#automated-security-scanning)
6. [Penetration Testing](#penetration-testing)

---

## Testing Strategy

### Manual + Automated

| Aspecto | Approach | Frequency | Tool |
|---------|----------|-----------|------|
| **SAST** | Automated | Every commit | SonarQube |
| **DAST** | Automated | Staging deploy | OWASP ZAP |
| **Dependency scan** | Automated | Weekly | Snyk |
| **Container scan** | Automated | Every image build | Trivy |
| **Penetration test** | Manual | Quarterly | External firm |
| **Code review** | Manual | Every PR | GitHub |

---

## OWASP Top 10

### A1: Injection (SQL, LDAP, Command)

**Test:**
```
Input: username' OR '1'='1
Expected: Rejected or escaped safely
Tool: SQLMap, OWASP ZAP

Implementation:
  ✓ Parameterized queries (JPA, Flyway)
  ✓ No string concatenation in SQL
  ✓ Input validation layer
```

### A2: Broken Authentication

**Test:**
```
1. JWT token manipulation (change exp, roles)
   → Signature invalid → 401
2. Refresh token reuse (T-035 replay detection)
   → Detected → session revoked
3. Brute force login (100 attempts/hour)
   → Rate limited → 429 Too Many Requests

Implementation:
  ✓ RS256 signature verification
  ✓ Refresh token rotation
  ✓ Rate limiting on /login endpoint
```

### A3: Sensitive Data Exposure

**Test:**
```
1. Password hashing
   → bcrypt, Argon2 (never plaintext)
2. API responses contain PII
   → Filtered based on roles
3. HTTPS enforced
   → Cert valid, no MITM, HSTS header

Implementation:
  ✓ HTTPS everywhere (TLS 1.3)
  ✓ Passwords hashed (bcrypt, cost 12+)
  ✓ API responses use DTO projections
```

### A4: Broken Access Control

**Test:**
```
1. Tenant isolation
   → User from tenant-A cannot read tenant-B data
   → Test: GET /api/v1/tenants/tenant-b/users with tenant-a token → 403
2. Role-based access
   → USER role cannot delete users
   → Test: DELETE /api/v1/users/123 with USER token → 403
3. Direct object references
   → User cannot modify another user's profile
   → Test: PATCH /api/v1/users/other-id/profile → 403

Implementation:
  ✓ @PreAuthorize("@tenantAuthEvaluator.isTenantMember()")
  ✓ Role-based access control
  ✓ Object-level authorization
```

### A5: Security Misconfiguration

**Test:**
```
1. Default credentials removed
   → No postgres user with password "postgres"
2. Error messages don't leak info
   → 404 for invalid endpoint (not "Table users not found")
3. Security headers present
   → X-Content-Type-Options: nosniff
   → X-Frame-Options: DENY
   → Content-Security-Policy header

Implementation:
  ✓ application-prod.yml disables actuators
  ✓ GlobalExceptionHandler masks errors
  ✓ Security headers in filter
```

### A6: Broken Cryptography

**Test:**
```
1. Weak crypto algorithms
   → All JWTs use RS256 (asymmetric, strong)
   → No MD5, SHA1 for passwords
2. Random number generation
   → Use SecureRandom for tokens
   → Check: java.util.Random (weak) should not be used

Implementation:
  ✓ Nimbus JOSE library for JWT
  ✓ Bcrypt for passwords
  ✓ SecureRandom for tokens
```

### A7: XSS (Cross-Site Scripting)

**Test:**
```
1. Stored XSS
   Input: <script>alert('XSS')</script> in user profile name
   → Should be escaped in response
   → Test: View profile → no alert should fire

2. Reflected XSS
   URL: /search?q=<img src=x onerror=alert('XSS')>
   → Should be escaped in HTML

Implementation:
  ✓ Frontend: DOMPurify on user input
  ✓ Backend: HTML encoding in response
  ✓ CSP headers to prevent inline scripts
```

### A8: CSRF (Cross-Site Request Forgery)

**Test:**
```
1. CSRF token required for state-changing requests
   POST /api/v1/users/delete → 403 without CSRF token
2. SameSite cookie attribute
   → Set-Cookie: sessionId=...; SameSite=Strict

Implementation:
  ✓ Spring Security CSRF protection
  ✓ X-CSRF-Token header validation
  ✓ SameSite=Strict on session cookies
```

### A9: Using Components with Known Vulnerabilities

**Test:**
```
Tool: Snyk, Dependabot
Run: snyk test --file=pom.xml
Expected: 0 high/critical vulnerabilities

Implementation:
  ✓ Weekly dependency scans
  ✓ Auto-update patches
  ✓ Monthly major upgrades
```

### A10: Insufficient Logging & Monitoring

**Test:**
```
1. All auth events logged
   → Login attempts, password changes, role changes
2. Sensitive data not logged
   → Passwords, tokens, API keys should NOT appear in logs
3. Alerts configured
   → High error rate → page
   → Repeated failed logins → page

Implementation:
  ✓ Observability.md defines logging strategy
  ✓ MDC for correlation IDs
  ✓ Prometheus metrics + Grafana alerts
```

---

## Compliance: SOC2, GDPR

### SOC2 Type II Readiness

| Control | Requirement | Implementation |
|---------|-------------|-----------------|
| **Access control** | Role-based, least privilege | @PreAuthorize patterns, RBAC |
| **Change management** | Approval required for prod changes | GitHub PR reviews, manual CD approval |
| **Logging & monitoring** | All access logged, retained 90+ days | ELK stack, mdc, audit log table |
| **Incident response** | Plan and drill quarterly | incident-response-guide.md, runbooks |
| **Risk assessment** | Quarterly threat modeling | OWASP Top 10 coverage above |

### GDPR Compliance

| Article | Requirement | Implementation |
|---------|-------------|-----------------|
| **5 (Data minimization)** | Collect only necessary data | Only email + name + password hash |
| **6 (Lawful basis)** | Consent for processing | Terms of Service, privacy policy |
| **12-22 (Data rights)** | Export, delete, rectify | Admin console can delete users |
| **32 (Security)** | Encryption at rest & transit | TLS, DB encryption, bcrypt |
| **33-34 (Breach notif)** | Report within 72h if risk | incident-response-guide.md |

---

## PII & Data Protection

### Sensitive Fields

```java
@Entity
class User {
  @Sensitive  // Marked for encryption
  String email;
  
  @Sensitive
  String firstName, lastName;
  
  @Sensitive
  String phone;  // Optional, encrypted
  
  String passwordHash;  // Never returned in API
  String refreshTokenHash;  // Never returned in API
}
```

### API Response Filtering

```java
// UserDto (API response)
record UserDto(
  String id,
  String email,          // Only if requester is self or admin
  String firstName,      // Only if requester is self or admin
  String role
  // phone, passwordHash NOT included
) {}

// Controller
@GetMapping("/users/{id}")
public UserDto getUser(@PathVariable String id) {
  User user = userRepo.findById(id);
  if (!canView(user)) {
    throw new ForbiddenException();
  }
  return mapper.toDto(user);  // Filters sensitive fields
}
```

### Data Retention Policy

```
User data:
  - Active account: retained while active
  - Deleted account: soft delete (flag is_deleted=true)
  - After 2 years: hard delete (legal hold period)

Logs:
  - Application logs: 30 days
  - Audit logs: 90 days
  - Backups: 7 daily + 4 weekly + 12 monthly

Retention configuration:
  - GDPR: min 2 years for deleted accounts
  - SOC2: min 90 days for audit logs
```

---

## Automated Security Scanning

### GitHub Actions Workflow

```yaml
name: Security Scan

on:
  push:
    branches: [develop, main]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: SAST with SonarQube
        run: ./mvnw sonar:sonar
      
      - name: Dependency check with Snyk
        run: snyk test --file=pom.xml
      
      - name: Container scan with Trivy
        run: trivy image keygo/keygo-server:latest
      
      - name: DAST with OWASP ZAP
        if: github.ref == 'refs/heads/develop'
        run: zaproxy -cmd -quickurl https://staging.example.com
```

---

## Penetration Testing

### Quarterly Schedule

```
Q1: Infrastructure & network (firewall, S3, DB)
Q2: APIs & authentication (OAuth2, JWT, PKCE)
Q3: Frontend & XSS (DOM, CSP, cookies)
Q4: Authorization & multi-tenancy (ABAC, tenant isolation)

Each test:
  - 1 week engagement
  - Report + remediation plan
  - Fix prioritized by severity (critical < 30 days)
```

---

## Véase También

- **api-endpoints-comprehensive.md** — API contracts to test
- **authorization-patterns.md** — RBAC & tenancy model
- **observability.md** — Logging strategy for audit trail

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Security/QA | **Licencia:** Keygo Docs
