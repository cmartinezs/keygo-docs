[← Índice](./README.md) | [< Anterior](./uat.md)

---

# Security Testing

Prácticas de seguridad, protección OWASP y guidelines de compliance.

## Contenido

- [OWASP Top 10](#owasp-top-10)
- [Broken Authentication](#1-broken-authentication)
- [Broken Access Control](#2-broken-access-control)
- [Injection](#3-injection)
- [Cryptographic Failures](#4-cryptographic-failures)
- [Secrets Management](#secrets-management)
- [API Security](#api-security)
- [Compliance](#compliance)
- [PII - Datos Personales](#pii---datos-personales)
- [Anti-Patterns](#anti-patterns)

---

## OWASP Top 10

| # | Vulnerabilidad | Defensas en KeyGo |
|---|---------------|-------------------|
| 1 | Broken Authentication | OAuth2 PKCE, JWT expiry, rate limiting |
| 2 | Broken Access Control | RBAC, tenant isolation |
| 3 | Injection | Parameterized queries, JPA |
| 4 | Insecure Design | Threat modeling, security reviews |
| 5 | Cryptographic Failures | AES-256, bcrypt, TLS 1.2+ |
| 6 | Vulnerable Components | Dependabot, Snyk |
| 7 | Auth Failures | Session timeout, token binding |
| 8 | Integrity Failures | Cosign, checksums |
| 9 | Logging Failures | Audit logs, SIEM |
| 10 | SSRF | URL whitelist |

[↑ Volver al inicio](#security-testing)

---

## 1. Broken Authentication

**Risk:** Atacante accede a cuenta de usuario

**Defensas:**
- OAuth2 PKCE flow
- JWT tokens con expiry corto (1 hora)
- Refresh token rotation
- Rate limiting en login (max 5 intentos/10 min)
- Account lockout (3 failed attempts)

```java
@Component
public class LoginRateLimiter {
  @PostMapping("/oauth/token")
  public ResponseEntity<?> token(@RequestParam String code) {
    String clientIp = getClientIp();
    RateLimiter limiter = registry.rateLimiter("login_" + clientIp);

    if (!limiter.acquirePermission()) {
      return ResponseEntity.status(429)
          .body(ErrorResponse.of("RATE_LIMITED", "Too many login attempts"));
    }
  }
}
```

[↑ Volver al inicio](#security-testing)

---

## 2. Broken Access Control

**Risk:** Usuario accede a recurso que no le pertenece

**Defensas:**
- Role-based access control (RBAC)
- Tenant isolation (users can't access other tenants)
- Row-level security

```java
@PreAuthorize("hasRole('ADMIN_TENANT')")
public User findById(UUID id, TenantContext context) {
  return repository.findById(id)
      .filter(user -> user.getTenantId().equals(context.getTenantId()))
      .orElseThrow(() -> new UserNotFoundException());
}
```

[↑ Volver al inicio](#security-testing)

---

## 3. Injection

**Risk:** Atacante inyecta código malicioso

**Defensas:**
- Parameterized queries (JPA)
- Input validation (whitelist)

```java
// ✅ GOOD: JPA
Optional<User> user = userRepository.findByEmail(email, tenantId);

// ✅ GOOD: Parameterized
@Query("SELECT u FROM User u WHERE u.email = :email")
TypedQuery<User> query = entityManager.createQuery(hql, User.class);
query.setParameter("email", email);
```

[↑ Volver al inicio](#security-testing)

---

## 4. Cryptographic Failures

**Risk:** Cifrado débil o datos sensibles sin cifrar

**Defensas:**
- Encrypt at rest (AES-256)
- Encrypt in transit (TLS 1.2+)
- Strong hashing (bcrypt, argon2)

```java
// Password hashing
public String hashPassword(String plaintext) {
  return encoder.encode(plaintext);  // BCrypt
}

// At-rest encryption
@Entity
public class OAuthClient {
  @Convert(converter = EncryptedStringConverter.class)
  private String clientSecret;
}
```

[↑ Volver al inicio](#security-testing)

---

## Secrets Management

### Environment Variables

```java
// ✅ GOOD
private final String databasePassword = env.getProperty("DB_PASSWORD");

// ❌ BAD
private static final String DATABASE_PASSWORD = "super-secret-123";
```

### GitHub Secrets

```yaml
# .github/workflows/deploy.yml
env:
  DB_PASSWORD: ${{ secrets.DB_PASSWORD }}
  JWT_KEY: ${{ secrets.JWT_SIGNING_KEY }}
```

### Vault Integration

```yaml
spring:
  cloud:
    vault:
      host: vault.internal.keygo.io
      port: 8200
      authentication: TOKEN
```

[↑ Volver al inicio](#security-testing)

---

## API Security

### Authentication Headers

```
Authorization: Bearer eyJhbGciOiJSUzI1NiJ9...
X-Trace-ID: 550e8400-e29b-41d4-a716-446655440000
```

### CORS Configuration

```java
registry.addMapping("/api/**")
    .allowedOrigins("https://app.keygo.io", "https://console.keygo.io")
    .allowedMethods("GET", "POST", "PUT", "DELETE")
    .allowCredentials(true);
```

### Input Validation

```java
@Data
public class CreateUserRequest {
  @NotBlank
  @Email
  private String email;

  @NotBlank
  @Length(min = 3, max = 50)
  @Pattern(regexp = "^[a-zA-Z0-9_-]+$")
  private String username;
}
```

[↑ Volver al inicio](#security-testing)

---

## Compliance

### Checklist: Security Review

Before deploying to production:

- [ ] **Authentication:** OAuth2 PKCE implemented
- [ ] **Authorization:** RBAC configured, tenant isolation verified
- [ ] **Data Encryption:** Secrets in Vault, passwords hashed (bcrypt)
- [ ] **HTTPS:** TLS 1.2+, valid certificate
- [ ] **Input Validation:** All inputs validated
- [ ] **Logging:** Audit logs for sensitive operations
- [ ] **Secrets:** No secrets in code
- [ ] **Dependencies:** Snyk scan passed
- [ ] **CORS:** Configured for specific origins

### Security Headers

```java
response.addHeader("X-Frame-Options", "DENY");
response.addHeader("X-Content-Type-Options", "nosniff");
response.addHeader("Strict-Transport-Security", "max-age=31536000");
response.addHeader("Content-Security-Policy", "default-src 'self'");
```

[↑ Volver al inicio](#security-testing)

---

## PII - Datos Personales

### Regla: PII nunca en URLs

```java
// ❌ MAL — email en URL queda en logs
GET /api/v1/users/check?email=user@example.com

// ✅ BIEN — email en body
POST /api/v1/platform/account/check-email
{ "email": "user@example.com" }
```

### Checklist PII

- [ ] Ningún campo PII aparece en path o query string
- [ ] Emails en response están enmascarados
- [ ] Logs no imprimen valores PII

[↑ Volver al inicio](#security-testing)

---

## Anti-Patterns

### ❌ Storing plaintext passwords

```java
// MAL
user.setPassword(plaintext);
```

### ✅ Hash passwords

```java
// BIEN
String hashed = passwordEncoder.encode(plaintext);
user.setPassword(hashed);
```

[↑ Volver al inicio](#security-testing)

---

[← Índice](./README.md) | [< Anterior](./uat.md)