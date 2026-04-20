[← Índice](./README.md) | [Siguiente >](./authorization-patterns.md)

---

# OAuth2/OIDC Multi-Level Contract

Especificación técnica de los flujos de autenticación y autorización en KeyGo, incluyendo PKCE, multi-level OAuth2 (Platform + Tenant), refresh token rotation y logout.

## Contenido

- [Arquitectura de Dos Niveles](#arquitectura-de-dos-niveles)
- [Flujo 1: PKCE Authorization Code (Hosted Login)](#flujo-1-pkce-authorization-code-hosted-login)
- [Flujo 2: Direct Login (API/CLI)](#flujo-2-direct-login-apicli)
- [Flujo 3: Refresh Token Rotation](#flujo-3-refresh-token-rotation)
- [Flujo 4: Logout y Revocación](#flujo-4-logout-y-revocación)
- [JWKS Public Key Discovery](#jwks-public-key-discovery)
- [Validaciones Comunes](#validaciones-comunes)

---

## Arquitectura de Dos Niveles

KeyGo implementa **dos flujos OAuth2 independientes**, separados por bounded context:

### Nivel 1: Platform Auth (Global) — Identity Bounded Context

**Endpoint:** `/api/v1/platform/oauth2/...`  
**Issuer:** `https://keygo.local/api/v1/platform`  
**Audience:** `keygo-platform`, `keygo-console`

**Casos de uso:**
- Admin de plataforma accede a dashboards globales, estadísticas, gestión de tenants
- Super-admin maneja múltiples tenants desde una perspectiva de plataforma

**JWT Claims:**
```json
{
  "sub": "user-uuid",
  "email": "admin@keygo.local",
  "roles": ["keygo_admin"],
  "aud": "keygo-platform",
  "iss": "https://keygo.local/api/v1/platform",
  "exp": 1680000000,
  "iat": 1679996400
}
```

### Nivel 2: Tenant Auth (Organizacional) — Organization Bounded Context

**Endpoint:** `/api/v1/tenants/{tenantSlug}/oauth2/...`  
**Issuer:** `https://keygo.local/api/v1/tenants/{tenantSlug}`  
**Audience:** `keygo-console`, aplicaciones cliente del tenant

**Casos de uso:**
- Usuario accede a consola del tenant (gestionar usuarios, apps, roles, etc.)
- Usuario inicia login en aplicación cliente registrada en el tenant (authorization code flow)

**JWT Claims:**
```json
{
  "sub": "user-uuid",
  "email": "user@example.com",
  "tenant_slug": "my-company",
  "tenant_id": "t-uuid",
  "roles": ["ADMIN_ORG", "USER"],
  "aud": "keygo-console",
  "iss": "https://keygo.local/api/v1/tenants/my-company",
  "exp": 1680000000,
  "iat": 1679996400
}
```

[↑ Volver al inicio](#oauth2oidc-multi-level-contract)

---

## Flujo 1: PKCE Authorization Code (Hosted Login)

**Escenario:** Aplicación cliente redirige usuario a KeyGo para login seguro (PKCE-protected).

### 1. Cliente Inicia (`GET /oauth2/authorize`)

```http
GET /api/v1/tenants/{tenantSlug}/oauth2/authorize
  ?client_id=app-uuid
  &redirect_uri=https://myapp.local/callback
  &scope=openid profile email
  &code_challenge=E9Mrozoa2owUBdtTvme4Z3IHoWAcvjjvj_VN7CcISGQ
  &code_challenge_method=S256
  &state=abc123xyz
  &nonce=xyz789abc
```

**Cliente genera PKCE:**
- `code_verifier` — 43-128 caracteres aleatorios (Base64url)
- `code_challenge = base64url(sha256(code_verifier))`
- Envía `code_challenge` (guarda `code_verifier` localmente, secreto)

**Validaciones en KeyGo:**
- ¿Tenant existe? → 404 RESOURCE_NOT_FOUND
- ¿App existe en tenant? → 404 RESOURCE_NOT_FOUND
- ¿`redirect_uri` registrado en app? → 400 INVALID_INPUT
- ¿`code_challenge_method = S256`? → 400 (solo S256 soportado)
- ¿Scopes válidos? → 400 INVALID_SCOPE

**Response:**
```json
{
  "data": {
    "authorization_session_id": "sess-uuid",
    "login_url": "https://keygo.local/api/v1/tenants/my-company/account/login",
    "state": "abc123xyz"
  },
  "success": { "code": "AUTHORIZATION_INITIATED" }
}
```

### 2. Usuario Ingresa Credenciales (`POST /account/login`)

```http
POST /api/v1/tenants/{tenantSlug}/account/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "authorization_session_id": "sess-uuid"
}
```

**Validaciones en KeyGo:**
- ¿Usuario existe en tenant?
- ¿Contraseña correcta? (BCrypt verification)
- ¿Cuenta activa (no SUSPENDED)?
- ¿Email verificado? (según política del tenant)

**Response (Éxito):**
```json
{
  "data": {
    "authorization_code": "auth-code-uuid",
    "redirect_uri": "https://myapp.local/callback?code=auth-code-uuid&state=abc123xyz",
    "state": "abc123xyz"
  },
  "success": { "code": "AUTHORIZATION_CODE_ISSUED" }
}
```

**Flow en Cliente:**
1. Captura `authorization_code` y `state` de respuesta
2. Valida que `state` coincida con el enviado en paso 1
3. Redirige navegador: `Location: {redirect_uri}`
4. SPA recibe code en URL, lo guarda en sesión local

### 3. Backend Canjea por Tokens (`POST /oauth2/token`)

```http
POST /api/v1/tenants/{tenantSlug}/oauth2/token
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code
&client_id=app-uuid
&code=auth-code-uuid
&code_verifier=E9Mrozoa2owUBdtTvme4Z3IHoWAcvjjvj_VN7CcISGQ
&redirect_uri=https://myapp.local/callback
```

**PKCE Validation:**
1. Extrae `code` → obtiene `code_challenge` guardado
2. Calcula: `sha256(code_verifier)` → compara con `code_challenge` guardado
3. Si no coinciden → 401 INVALID_AUTHORIZATION_CODE (replay attack)

**Response (Éxito):**
```json
{
  "data": {
    "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
    "token_type": "Bearer",
    "expires_in": 3600,
    "refresh_token": "refresh-uuid-hashed",
    "id_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
    "scope": "openid profile email"
  },
  "success": { "code": "TOKEN_ISSUED" }
}
```

**Access Token (JWT) contiene:**
```json
{
  "sub": "user-uuid",
  "email": "user@example.com",
  "tenant_slug": "my-company",
  "tenant_id": "t-uuid",
  "roles": ["USER", "EDITOR"],
  "aud": "keygo-console",
  "iss": "https://keygo.local/api/v1/tenants/my-company",
  "exp": 1680000000,
  "iat": 1679996400,
  "jti": "token-jti-uuid"
}
```

**Refresh Token:**
- Valor: UUID generado aleatoriamente
- Almacenado en DB: SHA256(refresh_token) (nunca en plaintext)
- TTL: 30 días
- Estado: `ACTIVE` (inicial)

**ID Token (OIDC):**
- Contiene: `sub`, `email`, `email_verified`, `phone_number`, `address`, `locale`, etc.
- Opcionalmente firmado con tenant signing key

[↑ Volver al inicio](#oauth2oidc-multi-level-contract)

---

## Flujo 2: Direct Login (API/CLI)

**Escenario:** CLI tool, backend service, o cliente confiable necesita token sin user interaction (password grant).

### Request

```http
POST /api/v1/tenants/{tenantSlug}/account/direct-login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "SecurePass123!"
}
```

### Response (Éxito)

```json
{
  "data": {
    "access_token": "eyJ...",
    "token_type": "Bearer",
    "expires_in": 3600,
    "refresh_token": "refresh-uuid-hashed"
  },
  "success": { "code": "DIRECT_LOGIN_SUCCESSFUL" }
}
```

**Diferencias con Flujo 1:**
- ❌ No se retorna `code` ni `authorization_session_id`
- ❌ No se retorna `id_token`
- ✅ Solo `access_token` + `refresh_token` (no OIDC)

**Casos de uso:**
- CLI autenticada con credenciales del usuario
- Script backend que necesita actuar en nombre del usuario
- Migración de sistemas legacy que usan password grant

[↑ Volver al inicio](#oauth2oidc-multi-level-contract)

---

## Flujo 3: Refresh Token Rotation

**Escenario:** Access token expirado, cliente usa refresh token para obtener nuevo sin re-autenticación.

### Request

```http
POST /api/v1/tenants/{tenantSlug}/oauth2/token
Content-Type: application/x-www-form-urlencoded

grant_type=refresh_token
&refresh_token=refresh-uuid
&client_id=app-uuid
```

### Validaciones en KeyGo

1. ¿Refresh token existe en DB? (búsqueda por SHA256 hash)
2. ¿No expirado? (TTL 30 días)
3. ¿Estado = `ACTIVE` o `USED`?
4. **⚠️ Replay Attack Detection (T-035):** Si `status = USED` → **revoke entire chain**
   - ¿Quién intentó reutilizar? Potencial compromiso
   - Marcar todos los tokens de esa sesión como REVOKED
   - Requerir re-autenticación

### Response (Éxito)

```json
{
  "data": {
    "access_token": "eyJ... (NUEVO)",
    "token_type": "Bearer",
    "expires_in": 3600,
    "refresh_token": "refresh-uuid-hashed (NUEVO)",
    "scope": "openid profile email"
  },
  "success": { "code": "TOKEN_REFRESHED" }
}
```

### Cambios de Estado en DB

```sql
-- Paso 1: Marcar refresh token viejo como USED
UPDATE refresh_tokens 
SET status = 'USED', updated_at = NOW() 
WHERE id = old_refresh_token_id;

-- Paso 2: Insertar nuevo refresh token
INSERT INTO refresh_tokens (id, session_id, token_hash, status, created_at, expires_at)
VALUES (new_id, session_id, SHA256(new_token), 'ACTIVE', NOW(), NOW() + INTERVAL '30 days');

-- Paso 3: Usar nuevo token para generar access_token
-- JWT con nuevo jti + exp
```

### Validaciones en Cliente

```javascript
// Cliente recibe NUEVO refresh_token
localStorage.setItem('refreshToken', newRefreshToken);

// Reintenta request original con nuevo access_token
fetch('/api/v1/tenants/my-company/users', {
  headers: { 'Authorization': `Bearer ${newAccessToken}` }
});
```

[↑ Volver al inicio](#oauth2oidc-multi-level-contract)

---

## Flujo 4: Logout y Revocación

### POST /account/logout

```http
POST /api/v1/tenants/{tenantSlug}/account/logout
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "revoke_tokens": true  // optional
}
```

### Acciones en KeyGo

1. **Extraer JWT del header:** obtener `sub` (user), `jti` (token id), `session_id`
2. **Actualizar sesión:** marcar `status = TERMINATED`, `terminated_at = NOW()`
3. **Revocar refresh tokens:** Si `revoke_tokens = true`
   ```sql
   UPDATE refresh_tokens 
   SET status = 'REVOKED' 
   WHERE session_id = ? AND status != 'REVOKED';
   ```
4. **Limpiar cache:** invalidar cualquier cache de user/roles para esta sesión

### Response

```json
{
  "data": { "message": "Logout successful" },
  "success": { "code": "LOGOUT_SUCCESSFUL" }
}
```

### Validaciones en Cliente

```javascript
// Limpiar tokens locales
localStorage.removeItem('accessToken');
localStorage.removeItem('refreshToken');
sessionStorage.clear();

// Redirigir a login
window.location.href = '/login';
```

---

## JWKS Public Key Discovery

### Endpoint

```http
GET /api/v1/tenants/{tenantSlug}/.well-known/jwks.json
```

**Propósito:** Cliente obtiene claves públicas para validar firmas de tokens (sin conectar a KeyGo cada vez).

### Response

```json
{
  "keys": [
    {
      "kty": "RSA",
      "use": "sig",
      "kid": "2024-04-10",
      "n": "0vx7agoebGcQSuuPiLJXZptN...",
      "e": "AQAB",
      "alg": "RS256"
    },
    {
      "kty": "RSA",
      "use": "sig",
      "kid": "2024-03-10",
      "n": "xjlCRBqkXzL7Pp...",
      "e": "AQAB",
      "alg": "RS256",
      "exp": 1680000000  // opcional: fecha de expiración
    }
  ]
}
```

**Caching:**
- Cliente cachea JWKS por TTL 1 hora
- Si validación falla con cached key → refrescar JWKS
- Soporte para key rotation: cliente debe soportar múltiples claves activas

[↑ Volver al inicio](#oauth2oidc-multi-level-contract)

---

## Validaciones Comunes

### Errores por Validación Fallida

| Validación | Error | HTTP | Causa |
|---|---|---|---|
| Tenant no existe | RESOURCE_NOT_FOUND | 404 | Slug inválido o typo |
| App no existe | RESOURCE_NOT_FOUND | 404 | client_id desconocido |
| redirect_uri no registrado | INVALID_INPUT | 400 | Typo o app mal configurada |
| code_challenge_method ≠ S256 | INVALID_INPUT | 400 | Solo S256 soportado |
| code_verifier inválido | INVALID_AUTHORIZATION_CODE | 401 | PKCE mismatch = replay attempt |
| refresh_token status = USED | REPLAY_ATTACK_DETECTED | 401 | Cadena revocada, re-autenticar |
| refresh_token expirado | INVALID_REFRESH_TOKEN | 401 | TTL 30 días agotado |
| email/password incorrecto | AUTHENTICATION_FAILED | 401 | Credenciales inválidas |
| usuario SUSPENDED | AUTHENTICATION_FAILED | 401 | Cuenta deshabilitada |

### Rate Limiting (T-110)

```
POST /account/login → 5 intentos / 10 minutos (por IP + email)
POST /oauth2/token → 50 intentos / minuto (por client_id)
GET /oauth2/authorize → 100 intentos / minuto (por IP)
```

**Respuesta (429 Too Many Requests):**
```json
{
  "error": { "code": "RATE_LIMITED", "detail": "Try again in 60 seconds" },
  "meta": { "retryAfter": 60 }
}
```

---

## Integración con Bounded Contexts

| Contexto | Responsabilidad | Eventos Producidos |
|---|---|---|
| **Identity** | Autenticación, JWT issuance, password verification | `AutenticaciónExitosa`, `AutenticaciónFallida`, `RefreshTokenRotated` |
| **Access Control** | Roles en token, validación de scopes, @PreAuthorize | `RoleAssigned`, `AccessDenied` |
| **Organization** | Validación de tenant_slug, pertenencia de usuario | `TenantAccessed`, `UserVerified` |
| **Audit** | Log de toda autenticación, logout, suspicious activity | `AuthenticationAttempt`, `LogoutEvent`, `ReplayAttackDetected` |

---

## References

- **RFC 6749:** OAuth 2.0 Authorization Framework
- **RFC 7636:** PKCE (Proof Key for Public Clients)
- **OIDC Core 1.0:** OpenID Connect Core Specification
- **Replay Attack Prevention:** See `authorization-patterns.md`
- **Domain Events:** See `03-design/domain-events.md`

---

[← Índice](./README.md) | [Siguiente >](./authorization-patterns.md)
