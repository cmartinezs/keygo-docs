# Development: Debugging Guide

**Fase:** 06-development | **Audiencia:** Backend/Frontend developers | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Debugging Setup](#debugging-setup)
2. [Common HTTP Error Codes](#common-http-error-codes)
3. [JWT Debugging](#jwt-debugging)
4. [Database Inspection](#database-inspection)
5. [Performance Analysis](#performance-analysis)

---

## Debugging Setup

### Backend: Enable DEBUG Profile

Create or modify `application-debug.yml`:

```yaml
spring:
  jpa:
    show-sql: true
    properties:
      hibernate:
        format_sql: true
        generate_statistics: true
  
logging:
  level:
    root: INFO
    com.keygo: DEBUG
    org.springframework.web: DEBUG
    org.springframework.security: DEBUG
    org.springframework.data.jpa: DEBUG
    org.hibernate.SQL: DEBUG
    org.hibernate.type.descriptor.sql.BasicBinder: TRACE
```

Run with debug profile:

```bash
mvn spring-boot:run -Dspring.profiles.active=debug
```

### IDE Debugging

**IntelliJ IDEA:**
- Right-click test class or main → Debug
- Set breakpoints (Ctrl+F8)
- Inspect variables at runtime

**VS Code:**
- Install "Extension Pack for Java"
- Press F5 → Create debug config
- Set breakpoints and step through

---

## Common HTTP Error Codes

### 401 Unauthorized

**Causes:**
- Missing `Authorization` header
- Token expired
- Token invalid (signature/format)
- Token signed with wrong key

**Diagnosis:**

```bash
# Decode token (header + payload, no signature validation)
TOKEN="eyJ..."
echo $TOKEN | jq -R 'split(".") | .[0] | @base64d | fromjson'  # Header
echo $TOKEN | jq -R 'split(".") | .[1] | @base64d | fromjson'  # Payload (includes exp)

# Check expiration
echo $TOKEN | jq -R 'split(".") | .[1] | @base64d | fromjson | .exp'
date +%s  # If exp < current timestamp, token is expired

# Verify token was sent
curl -v -H "Authorization: Bearer $TOKEN" http://localhost:8080/api/v1/account/profile
```

**Fix:**
- Obtain new token via OAuth2 `/oauth2/token` endpoint
- Use refresh token to regenerate access token

---

### 403 Access Denied

**Causes:**
- Token valid, but roles insufficient for endpoint
- Tenant mismatch (request tenant ≠ token tenant)
- Scope/permission missing

**Diagnosis:**

```bash
# Check token roles
echo $TOKEN | jq -R 'split(".") | .[1] | @base64d | fromjson | .roles'

# Check tenant in token
echo $TOKEN | jq -R 'split(".") | .[1] | @base64d | fromjson | .tenant_slug'

# Check endpoint permission requirement
# Look for @PreAuthorize, @RolesAllowed, or custom authorization checks
grep -r "@PreAuthorize" src/main --include="*.java" | grep "Controller"
```

**Fix:**
- Assign correct role to user
- Ensure token was issued for correct tenant
- Check authorization annotations on endpoint

---

### 400 Bad Request / INVALID_INPUT

**Causes:**
- Malformed JSON body
- Bean validation failure (@NotNull, @NotBlank, etc.)
- Field type mismatch
- Schema validation error

**Diagnosis:**

```bash
# See detailed validation errors
curl -X POST http://localhost:8080/api/v1/tenants \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"slug": "", "name": null}' | jq .

# Response includes fieldErrors:
# {
#   "code": "INVALID_INPUT",
#   "message": "Validation failed",
#   "details": [
#     {"field": "slug", "message": "must not be blank"},
#     {"field": "name", "message": "must not be null"}
#   ]
# }
```

**Fix:**
- Validate request body against API documentation
- Ensure all required fields are present and valid
- Check field types (string vs number, etc.)

---

### 409 Conflict / DUPLICATE_RESOURCE

**Cause:** Unique constraint violation (email, slug, etc.)

**Diagnosis:**

```bash
# Check if resource already exists
curl http://localhost:8080/api/v1/tenants/my-slug \
  -H "Authorization: Bearer $TOKEN"

# If 200, resource already exists
# If 404, resource doesn't exist (issue elsewhere)
```

**Fix:**
- Use unique identifier (different slug/email)
- Or implement idempotent endpoint (retry-safe)

---

### 500 Internal Server Error

**Causes:**
- Unhandled exception
- Database unavailable
- Flyway migration failed
- Out of memory or resource exhaustion

**Diagnosis:**

```bash
# 1. Check application logs (most recent 50 lines)
tail -50 logs/application.log | grep -E "ERROR|Exception|Caused by"

# 2. Database connectivity
psql -U postgres -h localhost -d keygo -c "SELECT 1;"

# 3. Check migration history
psql -U postgres -h localhost -d keygo -c \
  "SELECT version, success, type FROM flyway_schema_history ORDER BY installed_rank DESC LIMIT 5;"
# If success=false, last migration failed

# 4. Run app with DEBUG to see full stacktrace
mvn spring-boot:run -Dspring.profiles.active=debug 2>&1 | grep -A 20 "Exception"
```

**Fix:**
- Read full stacktrace from logs
- Verify database is running and accessible
- Check migrations applied successfully
- Restart application after fixing

---

## JWT Debugging

### Generate Test Token

```bash
# Use OAuth2 token endpoint
curl -X POST http://localhost:8080/oauth2/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password&username=admin@keygo.com&password=securepass&client_id=test-client&client_secret=test-secret"

# Response:
# {
#   "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
#   "token_type": "Bearer",
#   "expires_in": 3600,
#   "refresh_token": "..."
# }
```

### Decode and Inspect

```bash
export TOKEN="<access_token_from_response>"

# Header (contains alg, typ, kid)
echo $TOKEN | jq -R 'split(".") | .[0] | @base64d | fromjson'

# Payload (contains sub, roles, tenant_slug, exp, iat, etc.)
echo $TOKEN | jq -R 'split(".") | .[1] | @base64d | fromjson'

# Signature (opaque base64)
echo $TOKEN | jq -R 'split(".") | .[2]'

# Check if expired
echo $TOKEN | jq -R 'split(".") | .[1] | @base64d | fromjson | .exp' | xargs -I {} date -d @{} -u
```

### Verify Signature

```bash
# Get JWKS (public keys for verification)
curl http://localhost:8080/.well-known/jwks.json | jq .

# JWKS contains kid (key ID) and public key components (n, e)
# When you receive a JWT, verify its signature by:
# 1. Extract kid from JWT header
# 2. Find corresponding key in JWKS
# 3. Use public key to verify signature
```

### Token Refresh

```bash
# If token expired, use refresh_token
curl -X POST http://localhost:8080/oauth2/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=refresh_token&refresh_token=<refresh_token>&client_id=test-client&client_secret=test-secret"

# New access_token returned (refresh_token may also be rotated)
```

---

## Database Inspection

### Connect to Database

```bash
psql -U postgres -h localhost -d keygo
```

### Common Queries

```sql
-- List all tables
\dt

-- Table structure
\d table_name

-- Count records
SELECT COUNT(*) FROM users;

-- View first 10 records
SELECT * FROM users LIMIT 10;

-- Find user by email
SELECT id, email, first_name, last_name FROM users WHERE email = 'john@example.com';

-- List active tenants
SELECT id, slug, name, status FROM tenants WHERE status = 'ACTIVE';

-- View recent audit log entries
SELECT created_at, actor, event_type, resource_id FROM audit_logs ORDER BY created_at DESC LIMIT 20;

-- Check migration history
SELECT version, description, success, installed_on FROM flyway_schema_history ORDER BY installed_rank DESC;
```

### Inspect Constraints and Indexes

```sql
-- List indexes on a table
\d table_name

-- List foreign key constraints
SELECT * FROM information_schema.key_column_usage WHERE table_name = 'table_name';

-- Find duplicate values (detect constraint violations)
SELECT email, COUNT(*) FROM users GROUP BY email HAVING COUNT(*) > 1;
```

---

## Performance Analysis

### Enable Hibernate Statistics

```yaml
spring:
  jpa:
    properties:
      hibernate:
        generate_statistics: true
        session:
          events:
            log: true

logging:
  level:
    org.hibernate.stat.Statistics: DEBUG
```

Look for in logs:
- `N+1 queries` — Indicates lazy loading problem
- `SLOWQUERY` — Queries taking > threshold

### Java Flight Recorder

```bash
# Start app with JFR enabled
mvn spring-boot:run -Dspring.profiles.active=debug \
  -XX:+UnlockDiagnosticVMOptions \
  -XX:+DebugNonSafepoints \
  -XX:StartFlightRecording=filename=recording.jfr,duration=60s

# Analyze recording in JDK Mission Control
jmc recording.jfr
```

### Monitor HTTP Requests

```bash
# Enable Spring Web Debug logging
curl -X GET http://localhost:8080/api/v1/account/profile \
  -H "Authorization: Bearer $TOKEN" -v

# -v shows:
# - Request/response headers
# - Method and URL
# - Status code
# - Response body
```

---

## Debugging Checklist

- [ ] **Logs**: Check application logs for errors (`tail -50 logs/application.log | grep ERROR`)
- [ ] **Database**: Database running? (`psql -c "SELECT 1;"`)
- [ ] **Migrations**: All migrations successful? (`SELECT success FROM flyway_schema_history;`)
- [ ] **Token**: Token valid and not expired? (Decode JWT)
- [ ] **Authorization**: User has required roles? (Check @PreAuthorize)
- [ ] **Validation**: Request body matches schema? (Check fieldErrors in response)
- [ ] **Debug Profile**: Run with debug logging enabled (`-Dspring.profiles.active=debug`)
- [ ] **IDE Debugger**: Set breakpoints and inspect variables

---

## Véase También

- **observability.md** — Logs, metrics, traces for production
- **frontend-auth-implementation.md** — Token handling on frontend
- **validation-strategy.md** — Validation architecture

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Backend/DevOps | **Licencia:** Keygo Docs
