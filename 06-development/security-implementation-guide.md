# Development: Security Implementation Guidelines

**Fase:** 06-development | **Audiencia:** Backend developers, security review | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [OWASP Defense Strategy](#owasp-defense-strategy)
2. [Secrets Management](#secrets-management)
3. [Data Protection](#data-protection)
4. [Rate Limiting](#rate-limiting)
5. [Audit & Logging](#audit--logging)

---

## OWASP Defense Strategy

### 1. Broken Authentication

**Attack:** Attacker gains access to user account

**Defenses:**
- ✅ OAuth2 PKCE flow (password never sent to frontend)
- ✅ JWT tokens with short expiry (1 hour)
- ✅ Refresh token rotation (new token on each refresh)
- ✅ Rate limiting on login (max 5 attempts per 10 min)
- ✅ Account lockout after 3 failed attempts (30 min cooldown)

**Implementation:**
```java
@PostMapping("/oauth2/token")
public ResponseEntity<?> token(
    @RequestParam(name = "code") String code,
    HttpServletRequest request) {
  
  String clientIp = getClientIp(request);
  
  // Rate limiting
  if (!rateLimiter.allowRequest("login:" + clientIp)) {
    return ResponseEntity.status(429)
        .body(new ErrorResponse("RATE_LIMITED", "Too many attempts"));
  }
  
  // Exchange code for tokens with refresh rotation
  TokenResponse tokens = tokenService.exchangeAuthCode(code);
  
  return ResponseEntity.ok(tokens);
}
```

---

### 2. Broken Access Control

**Attack:** User accesses data they don't own (cross-tenant, cross-user)

**Defenses:**
- ✅ Tenant isolation at database level (multi-tenant schema)
- ✅ Row-level security in queries
- ✅ @PreAuthorize annotations on every endpoint
- ✅ TenantContext injected into all queries

**Implementation:**
```java
@Component
@PreAuthorize("hasRole('TENANT_USER')")
public class UserService {
  
  @Transactional(readOnly = true)
  public User findById(UserId id) {
    // TenantContext injected automatically
    TenantContext tenant = tenantContextProvider.get();
    
    return repository.findById(id)
        .filter(u -> u.tenantId().equals(tenant.id()))
        .orElseThrow(() -> new UserNotFoundException());
  }
}
```

---

### 3. Sensitive Data Exposure

**Attack:** Attacker reads PII in transit or at rest

**Defenses:**
- ✅ HTTPS only (TLS 1.3+)
- ✅ Fields encrypted at rest (passwords: bcrypt, PII: AES-256)
- ✅ API responses filter sensitive fields by role
- ✅ No sensitive data in logs (MDC masking)

**Implementation:**
```java
@RestController
@RequestMapping("/api/v1/users")
public class UserController {
  
  @GetMapping("/{id}")
  public UserResponse getUser(@PathVariable UserId id) {
    User user = userService.getUser(id);
    
    // Filter response based on requester role
    if (isAdmin()) {
      return new UserResponse(user); // Full details
    } else if (isSelf(id)) {
      return new UserResponse(user); // Own details
    } else {
      return new PublicUserResponse(user); // Minimal (name, avatar only)
    }
  }
}

public class PublicUserResponse {
  private String id;
  private String name;
  private String avatarUrl;
  // email, phone NOT included
}
```

---

### 4. Broken Access Control (continued)

**Defense:** Validate every action against policy

```java
@Component
public class AccessControlValidator {
  
  /**
   * Validates user can perform action on resource.
   * Throws exception if denied.
   */
  public void validate(User user, Action action, Resource resource) {
    // 1. Check user's roles
    Set<Role> roles = roleService.getUserRoles(user.id());
    
    // 2. Check policy for action + resource type
    Policy policy = policyStore.getPolicy(resource.type());
    
    // 3. Validate
    if (!policy.allows(roles, action)) {
      throw new AccessDeniedException(
          String.format("User %s cannot %s %s",
              user.id(), action, resource.id())
      );
    }
  }
}
```

---

### 5. Injection Attacks

**Attack:** Attacker injects malicious SQL, NoSQL, command

**Defenses:**
- ✅ Parameterized queries (JPA @Query with :param)
- ✅ Input validation (Bean Validation, custom validators)
- ✅ No string concatenation in queries
- ✅ Prepared statements everywhere

**Implementation:**
```java
// ❌ VULNERABLE: String concatenation
String query = "SELECT * FROM users WHERE email = '" + email + "'";

// ✅ SAFE: Parameterized query
@Query("SELECT u FROM User u WHERE u.email = :email")
Optional<User> findByEmail(@Param("email") String email);

// ✅ SAFE: Input validation before use
public User findByEmail(Email email) {  // Email is a Value Object with validation
  return repository.findByEmail(email.value());
}
```

---

## Secrets Management

### Environment Variables (Development)

```bash
# .env (NEVER committed)
KEYGO_DB_PASSWORD=dev_password_only
KEYGO_JWT_SIGNING_KEY=dev_key_only
KEYGO_STRIPE_SECRET=dev_test_key_only
```

### AWS Secrets Manager (Production)

```java
@Component
public class SecretProvider {
  
  @Value("${aws.secrets.region}")
  private String region;
  
  private final AWSSecretsManager client;
  
  public String getSecret(String secretName) {
    GetSecretValueRequest request = new GetSecretValueRequest()
        .withSecretId(secretName);
    
    GetSecretValueResult result = client.getSecretValue(request);
    
    return result.getSecretString();
  }
}
```

### Rotation Policy

- **JWT Signing Keys**: Rotate quarterly
- **Database Passwords**: Rotate monthly
- **API Keys**: Rotate every 90 days
- **Emergency Rotation**: On suspected compromise

---

## Data Protection

### Password Hashing

```java
// ✅ Use bcrypt (never plaintext)
public class PasswordHasher {
  private final PasswordEncoder encoder = new BCryptPasswordEncoder(12);
  
  public String hash(String plainPassword) {
    return encoder.encode(plainPassword);
  }
  
  public boolean matches(String plainPassword, String hashedPassword) {
    return encoder.matches(plainPassword, hashedPassword);
  }
}

// Store only hash:
// INSERT INTO users (email, password_hash) VALUES (?, bcrypt('pass123'))
```

### PII Encryption

```java
@Entity
@Table(name = "users")
public class UserEntity {
  
  @Id
  private UUID id;
  
  @Encrypted  // AES-256 at rest
  private String phone;
  
  @Encrypted
  private String ssn;
  
  // email, name NOT encrypted (needed for queries)
}
```

---

## Rate Limiting

### By Endpoint

```yaml
rate-limits:
  /oauth2/token: 5/10m        # 5 requests per 10 min
  /api/v1/account/forgot-password: 3/1h  # 3 per hour
  /api/v1/tenants: 100/1h     # 100 per hour
  default: 1000/1h            # Default fallback
```

### Implementation

```java
@Component
public class RateLimiterFilter extends OncePerRequestFilter {
  
  @Override
  protected void doFilterInternal(HttpServletRequest request,
      HttpServletResponse response, FilterChain chain) throws IOException, ServletException {
    
    String endpoint = request.getRequestURI();
    String clientId = getClientId(request);  // IP or user ID
    
    RateLimiter limiter = registry.getOrCreateLimiter(endpoint, clientId);
    
    if (!limiter.tryConsume()) {
      response.setStatus(429);  // Too Many Requests
      response.getWriter().write("{\"error\": \"RATE_LIMITED\"}");
      return;
    }
    
    chain.doFilter(request, response);
  }
}
```

---

## Audit & Logging

### What to Log

```java
// ✅ LOG THESE (security events)
- Authentication attempts (success/failure, IP, timestamp)
- Authorization failures (user, action, resource, reason)
- Privilege escalation (user assigned ADMIN role, by whom, when)
- Data modifications (what, who, when, tenant)
- Deletions (what, who, when, soft vs hard delete)
- Admin actions (tenant suspension, user lockout, config changes)

// ❌ NEVER LOG (PII exposure)
- Passwords
- API keys / secrets
- Full credit cards
- SSN
- Unmasked emails (except in audit trails with PII tag)
```

### Implementation

```java
@Component
public class AuditLogger {
  
  public void logAuthAttempt(String username, boolean success, String ip) {
    logger.info("AUTH_ATTEMPT username={} success={} ip={}",
        username, success, ip);  // No password logged
  }
  
  public void logRoleAssignment(UserId userId, Role role, UserId actorId) {
    logger.info("PRIVILEGE_ESCALATION user_id={} role={} actor_id={}",
        userId, role, actorId);
  }
  
  public void logPiiAccess(UserId viewer, UserId subject, String field) {
    logger.info("[PII_ACCESS] viewer={} subject={} field={}",
        viewer, subject, field);  // Marked as PII
  }
}
```

---

## Véase También

- **observability.md** — Logging strategy with MDC
- **validation-strategy.md** — Input validation architecture
- **bootstrap-filter-routes.md** — Which routes are public vs protected

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Security/Backend | **Licencia:** Keygo Docs
