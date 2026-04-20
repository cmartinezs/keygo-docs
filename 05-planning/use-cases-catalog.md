# Use Cases Catalog — KeyGo Server

> **Descripción:** Catálogo completo de casos de uso por Bounded Context, con mapeo a Agregados, Entidades, Eventos de Dominio y Requerimientos Funcionales. Fuente única de verdad para la implementación de flujos y requisitos de testing.

**Fecha:** 2026-04-20  
**Versión:** 1.0  
**Status:** ✅ Documentado en Discovery/Requirements

---

## Índice

1. [UC-A: Authentication & OAuth2/OIDC](#uc-a-authentication--oauth2oidc) (12 casos de uso)
2. [UC-T: Tenant Management](#uc-t-tenant-management) (22+ casos de uso)
3. [UC-B: Billing & Subscriptions](#uc-b-billing--subscriptions) (12+ casos de uso)
4. [UC-AC: Account & Self-Service](#uc-ac-account--self-service) (6 casos de uso)
5. [Matriz de Traceabilidad](#matriz-de-traceabilidad) — UC ↔ RF ↔ Agregado ↔ Eventos

---

## UC-A: Authentication & OAuth2/OIDC

**Contexto:** Gestión de tokens JWT, sesiones, verificación de email, reset de contraseña.  
**Agregados Raíz:** `RefreshToken`, `Session`, `PasswordRecoveryRequest`, `EmailVerification`  
**Actors:** Usuario (no auth), Usuario (auth), Admin KeyGo

### UC-A1: Authorize with Code + PKCE

**Referencia:** RF-A1  
**Agregado Raíz:** `AuthorizationCode`  
**Precondiciones:**
- Cliente registrado en ClientApp
- `redirect_uri` en lista permitida
- `code_challenge` válido (43-128 chars, base64url)

**Flujo Principal:**
1. Cliente inicia `GET /api/v1/tenants/{slug}/oauth2/authorize?client_id=X&redirect_uri=Y&scope=Z&code_challenge=...&code_challenge_method=S256`
2. Sistema valida parámetros (client_id, redirect_uri registrada, scope)
3. Sistema genera `AuthorizationCode` (TTL 10 min, asociada a challenge)
4. Sistema retorna `code` al cliente (via redirect o JSON)

**Postcondiciones:**
- ✅ `AuthorizationCode` creada en BD con estado `ACTIVE`
- ✅ Cliente tiene `code` para siguiente paso (UC-A2)
- ✅ Evento: `AuthorizationCodeGenerated(code_id, client_id, redirect_uri, scope, code_challenge)`

**Variantes:**
- **V1a:** Client no registrado → rechazar 400
- **V1b:** Redirect URI mismatch → rechazar 400
- **V1c:** Scope inválido → rechazar 400

**Propuestas Relacionadas:** T-059 (HTTP 302 redirect clásico vs JSON)

---

### UC-A2: Exchange Authorization Code → Tokens

**Referencia:** RF-A2  
**Agregado Raíz:** `RefreshToken`, `Session`  
**Precondiciones:**
- `AuthorizationCode` válida, no expirada, asociada a este client
- `code_verifier` matched PKCE challenge
- `client_id` + `client_secret` correcto
- Usuario no suspendido

**Flujo Principal:**
1. Cliente POST `POST /api/v1/tenants/{slug}/oauth2/token` con `grant_type=authorization_code, code=X, code_verifier=Y, client_id=Z, client_secret=S`
2. Sistema valida code (existe, no expirada, tipo correcto)
3. Sistema valida `code_verifier` contra PKCE challenge: `BASE64URL(SHA256(verifier)) == challenge`
4. Sistema valida `client_id` + `client_secret` (lookups ClientApp, verifica credentials)
5. Sistema valida scope (scope_request ⊆ scope_allowed_for_app)
6. Sistema genera:
   - `AccessToken` (JWT, exp=1h, claims=sub,iss,aud,scope,tenant_id)
   - `IdToken` (JWT, OIDC standard claims: sub, name, email, picture, updated_at)
   - `RefreshToken` (hash SHA-256, TTL 30 días, status=ACTIVE)
7. Sistema crea `Session` (ua, ip, created_at)
8. Sistema marca `AuthorizationCode` como consumida (status=USED, consumed_at)
9. Sistema retorna tokens al cliente

**Postcondiciones:**
- ✅ `RefreshToken` creada con hash SHA-256, status=ACTIVE
- ✅ `Session` creada con UA y IP del usuario
- ✅ `AuthorizationCode` marcada USED
- ✅ Cliente recibe `{ access_token, token_type=Bearer, expires_in=3600, id_token, refresh_token }`
- ✅ Evento: `TokensIssued(user_id, client_id, session_id, scope, ip, ua)`

**Variantes:**
- **V2a:** Code no existe → rechazar 400 INVALID_GRANT
- **V2b:** Code expirada → rechazar 400 INVALID_GRANT + cleanup
- **V2c:** Code_verifier inválido → rechazar 400 INVALID_GRANT
- **V2d:** Client credentials inválido → rechazar 401 UNAUTHORIZED
- **V2e:** Scope más amplio que app permite → rechazar 400 INVALID_SCOPE

**Propuestas Relacionadas:** T-051 (matriz @PreAuthorize)

---

### UC-A3: Refresh Token Rotation

**Referencia:** RF-A3  
**Agregado Raíz:** `RefreshToken`  
**Precondiciones:**
- `RefreshToken` existe, no expirado (TTL 30 días)
- Hash SHA-256 válido
- Status ≠ REVOKED
- Status ≠ USED (indicaría replay attack)
- `client_id` + `client_secret` correcto

**Flujo Principal:**
1. Cliente POST `POST /api/v1/tenants/{slug}/oauth2/token` con `grant_type=refresh_token, refresh_token=T, client_id=Z, client_secret=S`
2. Sistema lookups RefreshToken por hash(T)
3. Sistema valida hash matches
4. Sistema valida status ≠ REVOKED
5. **Detección de Replay Attack (T-035):**
   - SI status=USED → cadena fue comprometida (alguien ya refresh)
   - Sistema revoca cadena entera (todos RF con mismo token_series marcados REVOKED)
   - Sistema retorna 401 INVALID_GRANT (suspicious activity)
   - Evento: `ReplayAttackDetected(token_series_id, client_id)` → alertar admin
   - Usuario debe hacer login de nuevo
6. SI status=ACTIVE:
   - Sistema genera nuevo AccessToken (exp=1h)
   - Sistema genera nuevo RefreshToken (TTL 30 días)
   - Sistema marca anterior RefreshToken status=USED (no revocado aún)
   - Sistema retorna nuevo par

**Postcondiciones:**
- ✅ Nuevo `RefreshToken` creada, status=ACTIVE
- ✅ Anterior `RefreshToken` status=USED
- ✅ Cliente recibe nuevo `{ access_token, refresh_token (NUEVO), expires_in=3600, token_type=Bearer }`
- ✅ Evento: `RefreshTokenRotated(old_token_id, new_token_id, user_id, client_id)`

**Variantes:**
- **V3a:** Token no existe → rechazar 400 INVALID_GRANT
- **V3b:** Token expirado → rechazar 400 INVALID_GRANT
- **V3c:** Token revocado → rechazar 400 INVALID_GRANT
- **V3d:** Status=USED (replay) → rechazar 401 + revocar cadena + alerta
- **V3e:** Client credentials inválido → rechazar 401

**Propuestas Relacionadas:** T-035 (replay detection), T-036 (TTL configurable)

---

### UC-A4: Revoke Token (Logout)

**Referencia:** RF-A4  
**Agregado Raíz:** `RefreshToken`  
**Precondiciones:**
- `RefreshToken` válida
- Usuario es propietario del token O es ADMIN_TENANT
- `access_token` válido (Bearer header)

**Flujo Principal:**
1. Cliente POST `POST /api/v1/tenants/{slug}/oauth2/revoke` (Bearer + form-data `token=T`)
2. Sistema valida Bearer token (access_token válido)
3. Sistema lookups RefreshToken por hash(T)
4. Sistema valida propietario (user_id de RF == user_id del Bearer) O admin
5. Sistema marca RefreshToken status=REVOKED
6. Sistema retorna 200 OK (idempotente)

**Postcondiciones:**
- ✅ `RefreshToken` status=REVOKED
- ✅ Futuros refresh intentos rechazados (401 INVALID_GRANT)
- ✅ Access token sigue válido hasta expiración (stateless design)
- ✅ Evento: `TokenRevoked(token_id, user_id, client_id, reason=USER_INITIATED | ADMIN | SECURITY)`

**Variantes:**
- **V4a:** Token no existe → 200 OK (idempotente)
- **V4b:** Token ya revocado → 200 OK (idempotente)
- **V4c:** Access token inválido → 401 UNAUTHORIZED
- **V4d:** Usuario no es propietario (no admin) → 403 FORBIDDEN

**Notas:**
- Logout no revoca access_token inmediatamente (stateless)
- Access token válido hasta expiración (~1h)
- Si necesita logout inmediato, cliente elimina localStorage
- Si aplicación requiere revocación inmediata: usar JTI blacklist (T-038, futuro)

---

### UC-A5: Get UserInfo (OIDC §5.3)

**Referencia:** RF-A5  
**Agregado Raíz:** `User` (value object claims)  
**Precondiciones:**
- `access_token` válido y no expirado
- Usuario no suspendido

**Flujo Principal:**
1. Cliente GET `GET /api/v1/tenants/{slug}/userinfo` (Bearer)
2. Sistema valida access_token (firma JWT válida, exp > ahora)
3. Sistema extrae `sub` (user_id), `tenant_id` del token
4. Sistema lookups User en BD
5. Sistema valida usuario no suspendido
6. **[Futuro T-043]** Filtra claims por scope solicitado:
   - `scope=profile` → sub, name, picture, updated_at
   - `scope=email` → sub, email, email_verified
   - `scope=phone` → sub, phone_number, phone_number_verified
   - `scope=address` → sub, address (si existe)
7. Sistema retorna OIDC standard claims (por ahora: todos)

**Postcondiciones:**
- ✅ Cliente recibe:
  ```json
  {
    "sub": "user-uuid",
    "name": "John Doe",
    "email": "john@example.com",
    "email_verified": true,
    "picture": "https://...",
    "phone_number": "+1234567890",
    "birthdate": "1990-01-15",
    "locale": "es-MX",
    "updated_at": 1713607890
  }
  ```
- ✅ Evento: `UserInfoRequested(user_id, client_id, scope_requested)`

**Variantes:**
- **V5a:** Access token no válido → 401 UNAUTHORIZED
- **V5b:** Access token expirado → 401 UNAUTHORIZED
- **V5c:** Usuario suspendido → 403 FORBIDDEN
- **V5d:** Usuario no encontrado → 404 NOT_FOUND

**Propuestas Relacionadas:** T-043 (scope filtering)

---

### UC-A6: Validate User Credentials (Admin)

**Referencia:** RF-A10  
**Agregado Raíz:** `User`  
**Precondiciones:**
- Endpoint público (sin auth requerida)
- Email + password proporcionados

**Flujo Principal:**
1. Admin/sistema POST `POST /api/v1/tenants/{slug}/users/validate-credentials` (body: { email, password })
2. Sistema lookups User por email (timing-safe, no revela si existe)
3. SI usuario no existe: retorna 200 { valid: false, reason: "INVALID_CREDENTIALS" } (delay artificial para timing-safety)
4. SI usuario existe:
   - Valida password con BCrypt (hash != password_hash)
   - Valida usuario no suspendido
   - SI password no matches → retorna 200 { valid: false, reason: "INVALID_CREDENTIALS" }
   - SI usuario status=RESET_PASSWORD_REQUIRED → retorna 200 { valid: false, reason: "RESET_PASSWORD_REQUIRED" }
   - SI todo ok → retorna 200 { valid: true }

**Postcondiciones:**
- ✅ Respuesta 200 siempre (no revela si email existe)
- ✅ Evento: `CredentialsValidationAttempted(email_hash, success=true|false, reason)`

**Variantes:**
- **V6a:** Usuario no existe → 200 { valid: false } (con delay)
- **V6b:** Password inválido → 200 { valid: false }
- **V6c:** Usuario suspendido → 200 { valid: false, reason: "ACCOUNT_SUSPENDED" }
- **V6d:** Status RESET_PASSWORD_REQUIRED → 200 { valid: false, reason: "RESET_PASSWORD_REQUIRED" }

**Notas:**
- Anti-enumeración: siempre retorna 200, no diferencia "no existe" vs "password bad"
- Timing-safe comparison para password
- Endpoint público pero débilmente acoplado a admin (sin auth, pero info sensible)

---

### UC-A7: Register User

**Referencia:** RF-A8 (Email Verification), custom requirements  
**Agregado Raíz:** `User`, `EmailVerification`  
**Precondiciones:**
- Email no existe en el sistema
- Password cumple complejidad mínima

**Flujo Principal:**
1. Usuario POST `POST /api/v1/tenants/{slug}/apps/{clientId}/register` (body: { email, password, name })
2. Sistema valida email no existe
3. Sistema valida password (min 8 chars, ≥1 mayúscula, ≥1 número, ≥1 special)
4. Sistema crea Usuario:
   - Hash password con BCrypt
   - status=UNVERIFIED
   - email_verified=false
5. Sistema genera `EmailVerificationCode` (6 dígitos, TTL 30 min)
6. Sistema envía email con código (via EmailNotificationPort)
7. Sistema retorna 201 { user_id, email, message: "Verification code sent" }

**Postcondiciones:**
- ✅ `User` creada con status=UNVERIFIED
- ✅ `EmailVerification` creada (código 6 dígitos, TTL 30 min)
- ✅ Email enviado a usuario
- ✅ Usuario no puede hacer login aún (UC-A2 rechaza si status≠ACTIVE)
- ✅ Evento: `UserRegistered(user_id, email, tenant_id)`

**Variantes:**
- **V7a:** Email ya existe → 409 CONFLICT
- **V7b:** Password débil → 400 BAD_REQUEST
- **V7c:** Email delivery falla → retorna 201 pero con warning "Email could not be sent"

---

### UC-A8: Verify Email

**Referencia:** RF-A8  
**Agregado Raíz:** `User`, `EmailVerification`  
**Precondiciones:**
- Usuario status=UNVERIFIED
- `EmailVerificationCode` válido y no expirado
- Email coincide

**Flujo Principal:**
1. Usuario POST `POST /api/v1/tenants/{slug}/apps/{clientId}/verify-email` (body: { email, code })
2. Sistema lookups EmailVerification por email + código
3. Sistema valida código no expirado
4. SI válido:
   - Sistema cambia User status=UNVERIFIED → ACTIVE
   - Sistema marca EmailVerification consumed=true
   - Sistema retorna 200 { message: "Email verified" }
5. SI inválido:
   - Sistema retorna 400 INVALID_CODE

**Postcondiciones:**
- ✅ `User` status=ACTIVE
- ✅ Usuario puede hacer login (UC-A2 ahora acepta)
- ✅ Evento: `EmailVerified(user_id, email, tenant_id)`

**Variantes:**
- **V8a:** Código inválido → 400 INVALID_CODE
- **V8b:** Código expirado → 400 CODE_EXPIRED
- **V8c:** Email mismatch → 400 INVALID_EMAIL
- **V8d:** Usuario ya verificado → 200 OK (idempotente)

---

### UC-A9: Forgot Password

**Referencia:** RF-A9 (Forgot phase)  
**Agregado Raíz:** `PasswordRecoveryRequest`  
**Precondiciones:**
- Endpoint público
- Email proporcionado

**Flujo Principal:**
1. Usuario POST `POST /api/v1/tenants/{slug}/account/forgot-password` (body: { email })
2. Sistema lookups User por email (timing-safe, sin revelar si existe)
3. SI usuario no existe: retorna 200 { message: "If email exists, recovery link sent" } (sin delay aparente)
4. SI usuario existe:
   - Sistema genera `PasswordRecoveryToken` (32-char random, TTL 30 min)
   - Sistema almacena token + requestId (UUID) + generated_at
   - Sistema envía email con recovery link: `https://app/recover?requestId=<UUID>&token=<32char>`
   - Sistema retorna 200 { message: "Recovery link sent" }

**Postcondiciones:**
- ✅ `PasswordRecoveryRequest` creada con token, requestId, TTL 30 min
- ✅ Email enviado (usuario puede hacer click en link)
- ✅ Evento: `PasswordRecoveryRequested(user_id_hash, email_hash, token_id)`

**Variantes:**
- **V9a:** Email no existe → 200 OK (anti-enumeration)
- **V9b:** Email delivery falla → 200 OK (se intenta retry)

**Notas:**
- Anti-enumeración: siempre retorna 200
- Token es 32-char, suficiente entropía
- TTL 30 min (ventana pequeña para seguridad)

---

### UC-A10: Recover Password (Second Step)

**Referencia:** RF-A9 (Recover phase)  
**Agregado Raíz:** `PasswordRecoveryRequest`  
**Precondiciones:**
- `PasswordRecoveryToken` válido y no expirado
- `requestId` coincide

**Flujo Principal:**
1. Frontend valida token + requestId (simple validation, no hit backend)
2. Usuario POST `POST /api/v1/tenants/{slug}/account/recover-password` (body: { requestId, newPassword })
3. Sistema lookups PasswordRecoveryRequest por requestId + token
4. Sistema valida token no expirado
5. Sistema valida newPassword (complejidad mínima)
6. Sistema crea `PasswordResetCode` (6 dígitos, TTL 24 horas, asociada a requestId)
7. Sistema envía email con reset code (no contiene password, solo código)
8. Sistema retorna 200 { message: "Reset code sent to email", resetCodeId=<UUID> }

**Postcondiciones:**
- ✅ `PasswordResetCode` creada (6 dígitos, TTL 24h)
- ✅ `resetCodeId` (UUID) retornado para paso 3
- ✅ Email enviado con código
- ✅ Evento: `PasswordResetCodeGenerated(user_id_hash, requestId)`

**Variantes:**
- **V10a:** Token inválido → 400 INVALID_TOKEN
- **V10b:** Token expirado → 400 TOKEN_EXPIRED
- **V10c:** RequestId mismatch → 400 INVALID_REQUEST
- **V10d:** Password débil → 400 BAD_REQUEST

**Notas:**
- Este paso NO cambia la contraseña aún
- Solo genera código de confirmación (2-factor-like)
- Código más largo (24h) pero requiere email access

---

### UC-A11: Reset Password (Third Step)

**Referencia:** RF-A9 (Reset phase)  
**Agregado Raíz:** `User`, `PasswordResetCode`  
**Precondiciones:**
- `PasswordResetCode` válido y no expirado
- `resetCodeId` coincide
- Usuario status=RESET_PASSWORD_REQUIRED (o ACTIVE, si self-service)

**Flujo Principal:**
1. Usuario POST `POST /api/v1/tenants/{slug}/account/reset-password` (body: { resetCodeId, resetCode, newPassword })
2. Sistema lookups PasswordResetCode por resetCodeId
3. Sistema valida código 6-dígitos matches
4. Sistema valida código no expirado
5. SI válido:
   - Sistema lookups User por user_id (asociado a reset code)
   - Sistema valida newPassword ≠ oldPassword (no reusar)
   - Sistema hash newPassword (BCrypt)
   - Sistema cambia User password_hash
   - SI User status=RESET_PASSWORD_REQUIRED → cambia a ACTIVE
   - Sistema marca PasswordResetCode consumed=true
   - Sistema retorna 200 { message: "Password reset successful" }
6. SI inválido:
   - Sistema retorna 400 INVALID_CODE

**Postcondiciones:**
- ✅ `User` password_hash actualizado
- ✅ `User` status → ACTIVE (si era RESET_PASSWORD_REQUIRED)
- ✅ Usuario puede hacer login con nueva contraseña
- ✅ Evento: `PasswordReset(user_id, reason=USER_SELF_SERVICE | ADMIN_REQUIRED, ip, ua)`

**Variantes:**
- **V11a:** Código inválido → 400 INVALID_CODE
- **V11b:** Código expirado → 400 CODE_EXPIRED
- **V11c:** ResetCodeId no existe → 400 INVALID_REQUEST
- **V11d:** Nueva password igual a anterior → 400 PASSWORD_REUSED

---

### UC-A12: Change Password (Self-Service)

**Referencia:** Custom requirement (no in requirements.md aún)  
**Agregado Raíz:** `User`  
**Precondiciones:**
- Usuario autenticado (Bearer token)
- Usuario status=ACTIVE
- Contraseña actual correcta

**Flujo Principal:**
1. Usuario POST `POST /api/v1/tenants/{slug}/account/change-password` (Bearer + body: { currentPassword, newPassword })
2. Sistema valida Bearer token (access_token válido)
3. Sistema lookups User por user_id del token
4. Sistema valida currentPassword matches (BCrypt)
5. Sistema valida newPassword ≠ currentPassword
6. Sistema valida newPassword cumple complejidad
7. SI válido:
   - Sistema hash newPassword (BCrypt)
   - Sistema update User password_hash
   - Sistema retorna 200 { message: "Password changed" }
   - Sesión sigue válida (no force logout)
8. SI inválido:
   - Sistema retorna 400 BAD_REQUEST

**Postcondiciones:**
- ✅ `User` password_hash actualizado
- ✅ Access token sigue válido (no revocado)
- ✅ Refresh tokens siguen válidos
- ✅ Evento: `PasswordChanged(user_id, changed_at, ip, ua)`

**Variantes:**
- **V12a:** Current password inválido → 401 UNAUTHORIZED
- **V12b:** New password igual a anterior → 400 PASSWORD_REUSED
- **V12c:** New password débil → 400 BAD_REQUEST

---

## UC-T: Tenant Management

**Contexto:** CRUD de Tenants, Usuarios, Aplicaciones, Roles, Memberships (RBAC jerárquico).  
**Agregados Raíz:** `Tenant`, `User`, `ClientApp`, `Role`, `Membership`  
**Actors:** Admin KeyGo, Admin Tenant, Usuario

### UC-T1: Create Tenant

**Referencia:** RF-B1 (Tenant CRUD)  
**Agregado Raíz:** `Tenant`  
**Precondiciones:**
- Actor es ADMIN_KEYGO
- `tenantSlug` único en plataforma
- Tenant name no vacío

**Flujo Principal:**
1. Admin POST `POST /api/v1/tenants` (Bearer ADMIN_KEYGO + body: { name, slug, description?, billingEmail })
2. Sistema valida Actor es ADMIN_KEYGO (via Bearer token role)
3. Sistema valida slug no existe (unique constraint)
4. Sistema crea `Tenant`:
   - slug (lowercase, alphanumeric + hyphen)
   - name
   - status=ACTIVE
   - created_at, created_by
5. Sistema crea `SigningKey` para tenant (RSA par público/privado, T1 constraint)
6. Sistema retorna 201 { tenant_id, slug, name, status }

**Postcondiciones:**
- ✅ `Tenant` creada
- ✅ `SigningKey` creada para tenant
- ✅ Tenant aislado (queries futuros filtran por tenant_id, T-Constraint F1)
- ✅ Evento: `TenantCreated(tenant_id, slug, created_by)`

**Variantes:**
- **V1a:** Actor no es ADMIN_KEYGO → 403 FORBIDDEN
- **V1b:** Slug ya existe → 409 CONFLICT
- **V1c:** Slug inválido (caracteres especiales) → 400 BAD_REQUEST

---

### UC-T2: List Tenants (Admin)

**Referencia:** RF-B1  
**Agregado Raíz:** `Tenant` (read-only)  
**Precondiciones:**
- Actor es ADMIN_KEYGO

**Flujo Principal:**
1. Admin GET `GET /api/v1/tenants?page=1&size=20&sort=name,asc` (Bearer ADMIN_KEYGO)
2. Sistema valida Actor es ADMIN_KEYGO
3. Sistema queries `Tenant` tabla (sin filtro tenant_id, es admin global)
4. Sistema aplica paginación + sorting
5. Sistema retorna 200 { content: [...], totalElements, totalPages, currentPage }

**Postcondiciones:**
- ✅ Lista de tenants retornada

**Variantes:**
- **V2a:** Page inválida → 400 BAD_REQUEST
- **V2b:** Sort field inválido → 400 BAD_REQUEST

---

### UC-T3: Get Tenant Details

**Referencia:** RF-B1  
**Agregado Raíz:** `Tenant` (read-only)  
**Precondiciones:**
- Actor es ADMIN_KEYGO O ADMIN_TENANT de este tenant

**Flujo Principal:**
1. Admin GET `GET /api/v1/tenants/{slug}` (Bearer)
2. Sistema extrae tenant_id del URL
3. Sistema valida Actor es ADMIN_KEYGO O (ADMIN_TENANT Y tenant_id matches)
4. Sistema queries `Tenant` por slug
5. Sistema retorna 200 { tenant_id, slug, name, status, created_at, updated_at }

**Postcondiciones:**
- ✅ Detalles del tenant retornados

**Variantes:**
- **V3a:** Tenant no existe → 404 NOT_FOUND
- **V3b:** Actor no autorizado → 403 FORBIDDEN

---

### UC-T4: Update Tenant

**Referencia:** Custom requirement  
**Agregado Raíz:** `Tenant`  
**Precondiciones:**
- Actor es ADMIN_KEYGO O ADMIN_TENANT de este tenant
- Tenant no suspendido

**Flujo Principal:**
1. Admin PATCH `PATCH /api/v1/tenants/{slug}` (Bearer + body: { name?, description? })
2. Sistema valida autorización
3. Sistema updates Tenant (name, description, updated_at)
4. Sistema retorna 200 { tenant_id, slug, name, description, updated_at }

**Postcondiciones:**
- ✅ `Tenant` actualizado
- ✅ Evento: `TenantUpdated(tenant_id, changes, updated_by)`

---

### UC-T5: Suspend Tenant

**Referencia:** Custom requirement (admin lock-out scenario)  
**Agregado Raíz:** `Tenant`  
**Precondiciones:**
- Actor es ADMIN_KEYGO
- Tenant status=ACTIVE

**Flujo Principal:**
1. Admin POST `POST /api/v1/tenants/{slug}/suspend` (Bearer ADMIN_KEYGO + body: { reason })
2. Sistema valida Actor es ADMIN_KEYGO
3. Sistema changes Tenant status=ACTIVE → SUSPENDED
4. Sistema retorna 200 { tenant_id, slug, status, suspended_at, reason }

**Postcondiciones:**
- ✅ `Tenant` status=SUSPENDED
- ✅ Queries subsecuentes para este tenant rechazadas (401 FORBIDDEN)
- ✅ Evento: `TenantSuspended(tenant_id, reason, suspended_by)`

**Notas:**
- Operación destructiva pero reversible (UC-T6)
- Suspender revoca todos tokens activos del tenant (vía filtro en TokenVerifier)

---

### UC-T6: Reactivate Tenant

**Referencia:** Custom requirement  
**Agregado Raíz:** `Tenant`  
**Precondiciones:**
- Actor es ADMIN_KEYGO
- Tenant status=SUSPENDED

**Flujo Principal:**
1. Admin POST `POST /api/v1/tenants/{slug}/reactivate` (Bearer ADMIN_KEYGO)
2. Sistema changes Tenant status=SUSPENDED → ACTIVE
3. Sistema retorna 200 { tenant_id, slug, status, reactivated_at }

**Postcondiciones:**
- ✅ `Tenant` status=ACTIVE
- ✅ Queries nuevas aceptadas (subject to other authz checks)
- ✅ Evento: `TenantReactivated(tenant_id, reactivated_by)`

---

### UC-T7: Create User in Tenant

**Referencia:** RF-B2 (User CRUD)  
**Agregado Raíz:** `User`  
**Precondiciones:**
- Actor es ADMIN_TENANT de este tenant
- Email único en este tenant
- Password cumple complejidad

**Flujo Principal:**
1. Admin Tenant POST `POST /api/v1/tenants/{slug}/users` (Bearer ADMIN_TENANT + body: { email, password, name, roles? })
2. Sistema valida Actor es ADMIN_TENANT de este tenant
3. Sistema valida email único en tenant
4. Sistema crea Usuario:
   - Hash password (BCrypt)
   - status=ACTIVE (admin-created = verified immediately)
   - email_verified=true
   - Asocia roles si proporcionados (UC-T18 Membership)
5. Sistema retorna 201 { user_id, email, name, status, created_at }

**Postcondiciones:**
- ✅ `User` creada en tenant
- ✅ Roles asignadas (si proporcionadas)
- ✅ Usuario puede hacer login inmediatamente
- ✅ Evento: `UserCreated(user_id, email, created_by, initial_roles)`

**Variantes:**
- **V7a:** Actor no es ADMIN_TENANT → 403 FORBIDDEN
- **V7b:** Email ya existe → 409 CONFLICT
- **V7c:** Password débil → 400 BAD_REQUEST
- **V7d:** Roles inválidas → 400 BAD_REQUEST

---

### UC-T8: List Users in Tenant

**Referencia:** RF-B2  
**Agregado Raíz:** `User` (read-only)  
**Precondiciones:**
- Actor es ADMIN_TENANT de este tenant O usuario autenticado

**Flujo Principal:**
1. Admin Tenant GET `GET /api/v1/tenants/{slug}/users?page=1&size=20` (Bearer)
2. Sistema valida Actor es ADMIN_TENANT OR regular user (retorna solo self)
3. SI ADMIN_TENANT: retorna todos usuarios del tenant
4. SI regular user: retorna solo self
5. Sistema retorna 200 { content: [...], totalElements, totalPages }

**Postcondiciones:**
- ✅ Lista de usuarios retornada (filtrada por autorización)

---

### UC-T9: Get User Details

**Referencia:** RF-B2  
**Agregado Raíz:** `User` (read-only)  
**Precondiciones:**
- Actor es ADMIN_TENANT de este tenant OR es el usuario mismo

**Flujo Principal:**
1. GET `GET /api/v1/tenants/{slug}/users/{userId}` (Bearer)
2. Sistema valida Actor es ADMIN_TENANT OR userId matches Bearer
3. Sistema queries User + Memberships (roles)
4. Sistema retorna 200 { user_id, email, name, status, roles: [...], created_at }

**Postcondiciones:**
- ✅ Detalles del usuario retornados

---

### UC-T10: Update User

**Referencia:** RF-B2  
**Agregado Raíz:** `User`  
**Precondiciones:**
- Actor es ADMIN_TENANT (puede editar otros) OR es el usuario mismo (solo self fields)

**Flujo Principal:**
1. PATCH `PATCH /api/v1/tenants/{slug}/users/{userId}` (Bearer + body: { name?, email?, status? })
2. IF ADMIN_TENANT: puede cambiar todos los campos + status
3. IF regular user: puede cambiar solo name, no puede cambiar status
4. Sistema updates User
5. Sistema retorna 200 { user_id, email, name, status, updated_at }

**Postcondiciones:**
- ✅ `User` actualizado
- ✅ Evento: `UserUpdated(user_id, changes, updated_by)`

---

### UC-T11: Suspend User

**Referencia:** Custom requirement  
**Agregado Raíz:** `User`  
**Precondiciones:**
- Actor es ADMIN_TENANT de este tenant
- User status=ACTIVE

**Flujo Principal:**
1. POST `POST /api/v1/tenants/{slug}/users/{userId}/suspend` (Bearer ADMIN_TENANT + body: { reason })
2. Sistema changes User status=ACTIVE → SUSPENDED
3. Sistema retorna 200

**Postcondiciones:**
- ✅ `User` status=SUSPENDED
- ✅ Queries subsecuentes para este usuario rechazadas
- ✅ Evento: `UserSuspended(user_id, reason, suspended_by)`

---

### UC-T12: Force Password Reset

**Referencia:** Custom requirement (admin force-reset)  
**Agregado Raíz:** `User`  
**Precondiciones:**
- Actor es ADMIN_TENANT de este tenant
- User existe

**Flujo Principal:**
1. POST `POST /api/v1/tenants/{slug}/users/{userId}/force-reset-password` (Bearer ADMIN_TENANT)
2. Sistema changes User status → RESET_PASSWORD_REQUIRED
3. Sistema revoca todos RefreshTokens del usuario (marcar REVOKED)
4. Sistema envía email: "Admin requires password reset, please use forgot-password flow"
5. Sistema retorna 200

**Postcondiciones:**
- ✅ `User` status=RESET_PASSWORD_REQUIRED
- ✅ Usuario no puede hacer login con contraseña actual (UC-A2 rechaza)
- ✅ Todos RefreshTokens revocados
- ✅ Usuario debe hacer forgot-password → recover → reset (UC-A9, A10, A11)
- ✅ Evento: `PasswordResetForced(user_id, forced_by)`

---

### UC-T13: Create Client Application

**Referencia:** RF-B3 (App CRUD)  
**Agregado Raíz:** `ClientApp`  
**Precondiciones:**
- Actor es ADMIN_TENANT de este tenant
- `clientId` único en tenant
- `redirectUris` válidas (HTTPS o localhost)

**Flujo Principal:**
1. POST `POST /api/v1/tenants/{slug}/apps` (Bearer ADMIN_TENANT + body: { name, description?, redirectUris: [...], scopes: [...], isConfidential? })
2. Sistema valida redirectUris (https or localhost, valid URIs)
3. Sistema generates:
   - `clientId` (random, 32-char alphanumeric)
   - `clientSecret` (random, 64-char alphanumeric, solo si isConfidential=true)
4. Sistema crea ClientApp
5. Sistema retorna 201 { clientId, clientSecret? (solo una vez), name, redirectUris, scopes }

**Postcondiciones:**
- ✅ `ClientApp` creada
- ✅ clientSecret retornado UNA SOLA VEZ (no re-retrievable)
- ✅ Evento: `ClientAppCreated(client_id, created_by)`

**Variantes:**
- **V13a:** ClientId ya existe → 409 CONFLICT (autogenerate)
- **V13b:** RedirectUri inválida → 400 BAD_REQUEST
- **V13c:** Actor no autorizado → 403 FORBIDDEN

---

### UC-T14: List Client Applications

**Referencia:** RF-B3  
**Agregado Raíz:** `ClientApp` (read-only)  
**Precondiciones:**
- Actor es ADMIN_TENANT de este tenant

**Flujo Principal:**
1. GET `GET /api/v1/tenants/{slug}/apps` (Bearer ADMIN_TENANT)
2. Sistema queries ClientApp lista de tenant
3. Sistema retorna 200 { content: [...] } (NO incluye clientSecret)

**Postcondiciones:**
- ✅ Lista de apps retornada

---

### UC-T15: Update Client Application

**Referencia:** RF-B3  
**Agregado Raíz:** `ClientApp`  
**Precondiciones:**
- Actor es ADMIN_TENANT de este tenant
- ClientApp existe

**Flujo Principal:**
1. PATCH `PATCH /api/v1/tenants/{slug}/apps/{clientId}` (Bearer ADMIN_TENANT + body: { name?, description?, redirectUris?, scopes? })
2. Sistema valida autorización
3. Sistema updates ClientApp
4. Sistema retorna 200 (NO incluye clientSecret)

**Postcondiciones:**
- ✅ `ClientApp` actualizado
- ✅ Evento: `ClientAppUpdated(client_id, changes, updated_by)`

---

### UC-T16: Create Role

**Referencia:** RF-B4 (Role CRUD)  
**Agregado Raíz:** `Role`  
**Precondiciones:**
- Actor es ADMIN_TENANT de este tenant
- `roleCode` único en tenant
- Role name no vacío

**Flujo Principal:**
1. POST `POST /api/v1/tenants/{slug}/roles` (Bearer ADMIN_TENANT + body: { code, name, description?, permissions: [...], parentRoleId? })
2. Sistema valida code único en tenant
3. SI parentRoleId proporcionado: valida rol existe + no circular
4. Sistema crea Role:
   - code (uppercase, alphanumeric + underscore)
   - name
   - permissions array (capability strings: "users:read", "users:write", etc.)
   - parent_role_id (si jerárquico)
5. Sistema retorna 201 { role_id, code, name, permissions, parent_role_id? }

**Postcondiciones:**
- ✅ `Role` creada
- ✅ Jerarquía establecida (si parent)
- ✅ Evento: `RoleCreated(role_id, code, created_by)`

**Variantes:**
- **V16a:** Code ya existe → 409 CONFLICT
- **V16b:** ParentRoleId no existe → 400 BAD_REQUEST
- **V16c:** Circular hierarchy detectada → 400 BAD_REQUEST

---

### UC-T17: Assign Parent Role (Hierarchy)

**Referencia:** Custom requirement (role inheritance)  
**Agregado Raíz:** `Role`  
**Precondiciones:**
- Actor es ADMIN_TENANT de este tenant
- Role existe
- ParentRole existe
- No circular

**Flujo Principal:**
1. POST `POST /api/v1/tenants/{slug}/roles/{roleId}/parent` (Bearer ADMIN_TENANT + body: { parentRoleId })
2. Sistema valida no circular (DFS check)
3. Sistema updates Role parent_role_id
4. Sistema retorna 200 { role_id, parent_role_id, inherited_permissions: [...] }

**Postcondiciones:**
- ✅ `Role` parent_role_id establecido
- ✅ Inherited permissions calculadas (parent permissions ∪ own permissions)
- ✅ Evento: `RoleParentAssigned(role_id, parent_role_id, updated_by)`

---

### UC-T18: Create Membership (Assign Role to User)

**Referencia:** RF-B5 (Membership CRUD)  
**Agregado Raíz:** `Membership`  
**Precondiciones:**
- Actor es ADMIN_TENANT de este tenant
- User existe en tenant
- Role existe en tenant
- Membership no existe (unique: user_id + role_id)

**Flujo Principal:**
1. POST `POST /api/v1/tenants/{slug}/memberships` (Bearer ADMIN_TENANT + body: { userId, roleId, expiresAt? })
2. Sistema valida User + Role exist
3. Sistema valida Membership no existe (idempotent check)
4. Sistema crea Membership:
   - user_id
   - role_id
   - expires_at (optional, para memberships temporales)
   - created_at
5. Sistema retorna 201 { membership_id, user_id, role_id, expires_at? }

**Postcondiciones:**
- ✅ `Membership` creada
- ✅ User ahora tiene permisos del Role (incorporados en próximo token)
- ✅ Evento: `MembershipAssigned(user_id, role_id, expires_at?, assigned_by)`

**Variantes:**
- **V18a:** User no existe → 404 NOT_FOUND
- **V18b:** Role no existe → 404 NOT_FOUND
- **V18c:** Membership ya existe → 409 CONFLICT (idempotent)

---

### UC-T19: List Memberships for User

**Referencia:** RF-B5  
**Agregado Raíz:** `Membership` (read-only)  
**Precondiciones:**
- Actor es ADMIN_TENANT de este tenant OR es el usuario mismo

**Flujo Principal:**
1. GET `GET /api/v1/tenants/{slug}/users/{userId}/memberships` (Bearer)
2. Sistema valida autorización
3. Sistema queries Memberships de usuario (solo non-expired)
4. Sistema retorna 200 { content: [...] }

**Postcondiciones:**
- ✅ Lista de memberships retornada

---

### UC-T20: Revoke Membership

**Referencia:** RF-B5  
**Agregado Raíz:** `Membership`  
**Precondiciones:**
- Actor es ADMIN_TENANT de este tenant
- Membership existe

**Flujo Principal:**
1. DELETE `DELETE /api/v1/tenants/{slug}/memberships/{membershipId}` (Bearer ADMIN_TENANT)
2. Sistema valida autorización
3. Sistema deletes Membership
4. Sistema retorna 204 NO_CONTENT

**Postcondiciones:**
- ✅ `Membership` eliminada
- ✅ User pierde permisos del Role (en próximo refresh token)
- ✅ Evento: `MembershipRevoked(user_id, role_id, revoked_by)`

---

### UC-T21: View Tenant Stats

**Referencia:** Custom requirement (analytics)  
**Agregado Raíz:** `Tenant` (read-only aggregation)  
**Precondiciones:**
- Actor es ADMIN_TENANT de este tenant O ADMIN_KEYGO

**Flujo Principal:**
1. GET `GET /api/v1/tenants/{slug}/stats` (Bearer)
2. SI ADMIN_KEYGO: retorna stats globales
3. SI ADMIN_TENANT: retorna stats del tenant
4. Sistema queries:
   - Total users
   - Total active sessions
   - Total apps
   - Total roles
   - Failed login attempts (last 7 days)
5. Sistema retorna 200 { users_total, sessions_active, apps_total, roles_total, failed_logins_7d }

**Postcondiciones:**
- ✅ Stats retornadas (aggregation, potencialmente cacheada T-074)

---

### UC-T22: View Tenant Dashboard

**Referencia:** Custom requirement (admin view)  
**Agregado Raíz:** `Tenant` (read-only aggregation)  
**Precondiciones:**
- Actor es ADMIN_TENANT de este tenant

**Flujo Principal:**
1. GET `GET /api/v1/admin/tenants/{slug}/dashboard` (Bearer ADMIN_TENANT)
2. Sistema queries:
   - Tenant metadata
   - User count + growth (last 30 days)
   - Session metrics (active, total, avg duration)
   - App activity (logins per app, last 7 days)
   - Token issuance (access + refresh, last 7 days)
   - Failed attempts (last 7 days, grouped by reason)
3. Sistema retorna 200 { tenant: {...}, users: {...}, sessions: {...}, apps: {...}, tokens: {...}, failures: {...} }

**Postcondiciones:**
- ✅ Dashboard data retornada (cacheada, TTL 60s, T-074)
- ✅ Evento: `DashboardViewed(tenant_id, viewer_id)`

---

## UC-B: Billing & Subscriptions

**Contexto:** Planes, contratos, suscripciones, facturas, pagos, renovación automática.  
**Agregados Raíz:** `AppPlan`, `Contract`, `Invoice`, `PaymentTransaction`  
**Actors:** Usuario, Admin Tenant, Payment Gateway, Scheduled Jobs

### UC-B1: List Plans (Public Catalog)

**Referencia:** RF-B6 (Plans CRUD)  
**Agregado Raíz:** `AppPlan` (read-only)  
**Precondiciones:**
- Endpoint público

**Flujo Principal:**
1. GET `GET /api/v1/tenants/{slug}/billing/plans?subscriberType=TENANT|APP` (sin auth required)
2. Sistema queries AppPlan lista de tenant (status=ACTIVE solo)
3. SI subscriberType=TENANT: retorna planes aplicables a tenant (future feature)
4. SI subscriberType=APP: retorna planes aplicables a app
5. Sistema retorna 200 { content: [...] } (cacheada, TTL 5m, T-099)

**Postcondiciones:**
- ✅ Catálogo de planes retornado

---

### UC-B2: Get Plan Details

**Referencia:** RF-B6  
**Agregado Raíz:** `AppPlan` (read-only)  
**Precondiciones:**
- Endpoint público

**Flujo Principal:**
1. GET `GET /api/v1/tenants/{slug}/billing/plans/{planCode}` (sin auth)
2. Sistema queries AppPlan por code
3. Sistema retorna 200 { plan_id, code, name, description, billingOptions: [...], features: [...], price_usd, ... }

**Postcondiciones:**
- ✅ Plan details retornados

---

### UC-B3: Create Plan (Admin)

**Referencia:** RF-B6  
**Agregado Raíz:** `AppPlan`  
**Precondiciones:**
- Actor es ADMIN_TENANT de este tenant
- Plan code único en tenant
- ≥1 billingOption con isDefault=true (T-095)

**Flujo Principal:**
1. POST `POST /api/v1/tenants/{slug}/billing/plans` (Bearer ADMIN_TENANT + body: { code, name, description, billingOptions: [{interval, price, isDefault}, ...], features: [...] })
2. Sistema valida plan code único
3. Sistema valida ≥1 billingOption con isDefault=true
4. Sistema valida cada billingOption (interval válido, price ≥ 0)
5. Sistema crea AppPlan:
   - code (uppercase, alphanumeric)
   - name
   - version=1 (versioning, immutable upgrade path, T-097)
   - status=ACTIVE
   - billingOptions (embedded or related table)
6. Sistema retorna 201 { plan_id, code, name, version, billingOptions, ... }

**Postcondiciones:**
- ✅ `AppPlan` creada con version=1
- ✅ Evento: `PlanCreated(plan_id, plan_code, created_by, version)`

**Variantes:**
- **V3a:** Code ya existe → 409 CONFLICT
- **V3b:** No default billingOption → 400 BAD_REQUEST (T-095)
- **V3c:** BillingOption price inválido → 400 BAD_REQUEST

---

### UC-B4: Update Plan Billing Options (No Version)

**Referencia:** Custom requirement (T-097)  
**Agregado Raíz:** `AppPlan`  
**Precondiciones:**
- Actor es ADMIN_TENANT de este tenant
- Plan existe
- No hay contratos activos (o están en grace period)

**Flujo Principal:**
1. PUT `PUT /api/v1/tenants/{slug}/billing/plans/{planCode}/billing-options` (Bearer ADMIN_TENANT + body: { billingOptions: [...] })
2. Sistema valida queries activos contratos
3. SI contratos activos: retorna 409 CONFLICT "Cannot modify plan with active contracts"
4. SI sin contratos:
   - Sistema updates billingOptions in-place (sin crear version nueva, T-097)
   - Sistema retorna 200 { plan_id, code, billingOptions (updated), version (same) }

**Postcondiciones:**
- ✅ `AppPlan` billingOptions actualizado
- ✅ Version NO cambiada (no incremented)
- ✅ Evento: `PlanBillingOptionsUpdated(plan_id, updated_by)`

**Notas:**
- T-097: Permite actualización de precios/intervalos sin versionado
- Diferentes de upgrade de plan (que SÍ versiona)

---

### UC-B5: Create Contract

**Referencia:** RF-B7 (Contract CRUD)  
**Agregado Raíz:** `Contract`  
**Precondiciones:**
- Actor es Usuario autenticado O ADMIN_TENANT
- Plan existe
- Usuario/App no tiene contrato activo para este plan (o puede multi-subscribe)

**Flujo Principal:**
1. POST `POST /api/v1/tenants/{slug}/billing/contracts` (Bearer + body: { planCode, startDate?, billingCycle? })
2. Sistema valida Plan existe
3. SI billingCycle no provided: usa default de Plan.billingOption (isDefault=true)
4. Sistema crea Contract:
   - plan_id
   - user_id (del Bearer)
   - status=PENDING
   - start_date (default: today)
   - billing_cycle (MONTHLY | ANNUALLY)
5. Sistema retorna 201 { contract_id, plan_code, status, start_date, ... }

**Postcondiciones:**
- ✅ `Contract` creada con status=PENDING
- ✅ No facturas creadas aún (requiere UC-B6 Activate)
- ✅ Evento: `ContractCreated(contract_id, plan_id, user_id, created_by)`

---

### UC-B6: Activate Subscription

**Referencia:** RF-B7  
**Agregado Raíz:** `Contract`, `Invoice`  
**Precondiciones:**
- Contract status=PENDING
- Plan activo

**Flujo Principal:**
1. POST `POST /api/v1/tenants/{slug}/billing/contracts/{contractId}/activate` (Bearer + body: { paymentMethodId?, billingEmail })
2. Sistema queries Contract
3. Sistema valida Contract status=PENDING
4. Sistema generates Invoice (UC-B7):
   - amount = Plan.billingOption.price
   - due_date = today + 15 days (standard)
   - status=PENDING
5. Sistema changes Contract status=PENDING → ACTIVE
6. Sistema retorna 200 { contract_id, status=ACTIVE, invoice_id }
7. Sistema envía email: "Invoice #X, amount $Y, due date Z"

**Postcondiciones:**
- ✅ `Contract` status=ACTIVE
- ✅ `Invoice` creada (UC-B7)
- ✅ Usuario debe pagar invoice (UC-B8)
- ✅ Evento: `SubscriptionActivated(contract_id, invoice_id, activated_by)`

---

### UC-B7: Generate Invoice

**Referencia:** RF-B8  
**Agregado Raíz:** `Invoice`  
**Precondiciones:**
- Contract ACTIVE
- Triggered por activation (UC-B6) O cron job (UC-B9 renewal)

**Flujo Principal:**
1. Sistema generapara Invoice:
   - contract_id
   - invoice_number (auto-increment o UUID)
   - amount (Plan.billingOption.price)
   - currency=USD
   - due_date = today + payment_terms (15 days default)
   - status=PENDING
   - period_start, period_end
   - tax (0 for now, future)
2. Sistema retorna Invoice created

**Postcondiciones:**
- ✅ `Invoice` creada
- ✅ Evento: `InvoiceGenerated(invoice_id, contract_id, amount, due_date)`

**Note:** Puede ser iniciado por UC-B6 o cron @Scheduled job (UC-B9)

---

### UC-B8: Process Payment

**Referencia:** RF-B9 (Payment Gateway integration)  
**Agregado Raíz:** `Invoice`, `PaymentTransaction`  
**Precondiciones:**
- Invoice status=PENDING
- Payment gateway reachable (Stripe/MercadoPago, T-084)
- Webhook from gateway o user-initiated

**Flujo Principal:**
1. **User-initiated:** POST `POST /api/v1/tenants/{slug}/billing/invoices/{invoiceId}/pay` (Bearer + body: { paymentMethodId, amount })
2. **Gateway webhook:** POST `/webhooks/payment-status` (signature validation)
3. Sistema sends charge request a gateway (T-084 integration)
4. Sistema crea PaymentTransaction (pending status)
5. Sistema waits gateway response:
   - **Success:** PaymentTransaction status=SUCCESS, Invoice status=PAID
   - **Failure:** PaymentTransaction status=FAILED, Invoice status=PENDING
   - **Retry:** Sistema schedules retry (T-090 dunning, reintentos D+1/D+3/D+7)
6. SI PAID: Sistema updates Contract (si en grace period)
7. Sistema envía email: "Payment received" o "Payment failed, retry..."

**Postcondiciones:**
- ✅ `PaymentTransaction` creada
- ✅ `Invoice` status → PAID (if success)
- ✅ Evento: `PaymentProcessed(invoice_id, transaction_id, status, amount)`

**Variantes:**
- **V8a:** Payment success → Invoice status=PAID, Contract active
- **V8b:** Payment failure → Invoice status=PENDING, dunning engine initiates (T-090)
- **V8c:** Partial payment → Invoice status=PARTIAL, manual follow-up

---

### UC-B9: Renew Subscription (Automated)

**Referencia:** RF-B10 (Auto-renewal)  
**Agregado Raíz:** `Contract`, `Invoice`  
**Precondiciones:**
- Contract status=ACTIVE
- Triggered por @Scheduled job (T-085, daily or hourly)

**Flujo Principal:**
1. **Cron job @Scheduled:** Queries Contracts where renewal_date ≤ today
2. Para cada Contract:
   - Sistema generates Invoice (UC-B7) para próximo período
   - Sistema attempts automatic payment (gateway charge)
   - SI success: Invoice status=PAID, Contract continue ACTIVE
   - SI failure: Invoice status=PENDING, Dunning engine (T-090)
3. Sistema retorna renewal results (success/failure count)

**Postcondiciones:**
- ✅ `Invoice` creada para próximo período
- ✅ `Contract` continues ACTIVE (si pago exitoso)
- ✅ Evento: `SubscriptionRenewed(contract_id, new_invoice_id, status)`

**Note:** T-085 provides @Scheduled implementation

---

### UC-B10: Dunning: Retry Failed Payments

**Referencia:** RF-B11 (Dunning engine, T-090)  
**Agregado Raíz:** `Invoice`, `PaymentTransaction`  
**Precondiciones:**
- Invoice status=PENDING (payment failed)
- Triggered por @Scheduled job (T-090, daily)

**Flujo Principal:**
1. **Cron job:** Queries Invoices donde status=PENDING Y last_attempt ≤ D+1/D+3/D+7
2. Para cada Invoice:
   - Retry attempt N (D+1 first, D+3 second, D+7 third)
   - Ejecuta charge request (gateway)
   - Actualiza PaymentTransaction
   - SI success en D+N: Invoice status=PAID, Contract reactive
   - SI failure en D+7: Invoice status=FAILED, Contract status=SUSPENDED, envía email "Subscription suspended"
3. Sistema retorna retry results

**Postcondiciones:**
- ✅ `PaymentTransaction` logged (retry attempt N)
- ✅ `Invoice` status → PAID (if retried successfully) OR FAILED (if all retries exhausted)
- ✅ `Contract` status → SUSPENDED (if all retries failed)
- ✅ Evento: `DunningAttempt(invoice_id, attempt_n, status)`

**Note:** T-090 provides dunning logic + retry schedule

---

### UC-B11: Cancel Subscription

**Referencia:** Custom requirement  
**Agregado Raíz:** `Contract`  
**Precondiciones:**
- Actor es Usuario propietario OR ADMIN_TENANT
- Contract status=ACTIVE

**Flujo Principal:**
1. POST `POST /api/v1/tenants/{slug}/billing/contracts/{contractId}/cancel` (Bearer + body: { reason?, effectiveDate? })
2. Sistema valida autorización (owner or admin)
3. Sistema changes Contract status=ACTIVE → CANCELED
4. Sistema cancels future invoices (si existen)
5. Sistema retorna 200 { contract_id, status=CANCELED, canceled_at }

**Postcondiciones:**
- ✅ `Contract` status=CANCELED
- ✅ No más invoices generadas
- ✅ Evento: `SubscriptionCanceled(contract_id, reason, canceled_by)`

---

### UC-B12: View Invoices

**Referencia:** RF-B12  
**Agregado Raíz:** `Invoice` (read-only)  
**Precondiciones:**
- Actor es Usuario autenticado O ADMIN_TENANT

**Flujo Principal:**
1. GET `GET /api/v1/tenants/{slug}/billing/invoices?page=1&size=20` (Bearer)
2. SI Usuario: retorna sus propios invoices
3. SI ADMIN_TENANT: retorna todos invoices del tenant
4. Sistema retorna 200 { content: [...], totalElements }

**Postcondiciones:**
- ✅ Lista de invoices retornada

---

### UC-B13: Get Invoice Details

**Referencia:** RF-B12  
**Agregado Raíz:** `Invoice` (read-only)  
**Precondiciones:**
- Actor es Usuario propietario OR ADMIN_TENANT
- Invoice existe

**Flujo Principal:**
1. GET `GET /api/v1/tenants/{slug}/billing/invoices/{invoiceId}` (Bearer, T-083)
2. Sistema valida autorización
3. Sistema retorna 200 { invoice_id, invoice_number, amount, currency, due_date, status, line_items: [...], ... }

**Postcondiciones:**
- ✅ Invoice details retornados

---

## UC-AC: Account & Self-Service

**Contexto:** Perfil de usuario, sesiones, permisos.  
**Agregados Raíz:** `User`, `Session`, `Membership`  
**Actors:** Usuario autenticado

### UC-AC1: View Profile

**Referencia:** Custom requirement (self-service)  
**Agregado Raíz:** `User` (read-only)  
**Precondiciones:**
- Usuario autenticado

**Flujo Principal:**
1. GET `GET /api/v1/tenants/{slug}/account/profile` (Bearer)
2. Sistema extrae user_id del token
3. Sistema queries User + OIDC claims
4. Sistema retorna 200 { user_id, email, name, picture, phone_number, locale, updated_at, email_verified, ... }

**Postcondiciones:**
- ✅ Perfil retornado

---

### UC-AC2: Edit Profile

**Referencia:** Custom requirement  
**Agregado Raíz:** `User`  
**Precondiciones:**
- Usuario autenticado
- Pueden editarse: name, picture, phone_number, locale (no email, requiere UC-A9)

**Flujo Principal:**
1. PATCH `PATCH /api/v1/tenants/{slug}/account/profile` (Bearer + body: { name?, picture?, phone_number?, locale? })
2. Sistema valida input (no SQL injection, proper formats)
3. Sistema updates User
4. Sistema retorna 200 { user_id, email, name (updated), ... }

**Postcondiciones:**
- ✅ `User` actualizado
- ✅ Cambios reflejados en próximo token (claims actualizados)
- ✅ Evento: `ProfileUpdated(user_id, changes, updated_by=SELF)`

---

### UC-AC3: List Sessions

**Referencia:** Custom requirement (device management)  
**Agregado Raíz:** `Session` (read-only)  
**Precondiciones:**
- Usuario autenticado

**Flujo Principal:**
1. GET `GET /api/v1/tenants/{slug}/account/sessions` (Bearer)
2. Sistema queries todas Session del usuario
3. Sistema retorna 200 { content: [{ session_id, ua, ip, created_at, last_activity, is_current }, ...] }

**Postcondiciones:**
- ✅ Lista de sesiones retornada (current marked)

---

### UC-AC4: Revoke Session

**Referencia:** Custom requirement (sign out device)  
**Agregado Raíz:** `Session`  
**Precondiciones:**
- Usuario autenticado
- Session exists

**Flujo Principal:**
1. POST `POST /api/v1/tenants/{slug}/account/sessions/{sessionId}/revoke` (Bearer)
2. Sistema valida autorización (owner or self)
3. Sistema marks Session terminated_at=now
4. Sistema revoca todos RefreshTokens de esa Session (T-109 cleanup job)
5. Sistema retorna 200

**Postcondiciones:**
- ✅ `Session` terminated
- ✅ Device signed out (no más access/refresh from that session)
- ✅ Evento: `SessionRevoked(session_id, user_id, revoked_by=SELF)`

---

### UC-AC5: View Access & Roles

**Referencia:** Custom requirement  
**Agregado Raíz:** `Membership`, `Role` (read-only)  
**Precondiciones:**
- Usuario autenticado

**Flujo Principal:**
1. GET `GET /api/v1/tenants/{slug}/account/access` (Bearer)
2. Sistema queries Memberships del usuario (non-expired)
3. Para cada Membership, resuelve Role + permissions
4. Sistema retorna 200 { roles: [{ role_id, code, name, permissions: [...] }, ...], effective_permissions: [...] }

**Postcondiciones:**
- ✅ Roles y permisos retornados

---

### UC-AC6: Configure Notifications

**Referencia:** Custom requirement (future)  
**Agregado Raíz:** `UserNotificationPreferences`  
**Precondiciones:**
- Usuario autenticado

**Flujo Principal:**
1. GET `GET /api/v1/tenants/{slug}/account/notifications` (Bearer)
2. Sistema retorna preferencias actuales (email alerts: yes/no, sms: yes/no, digest: daily/weekly)
3. PATCH para actualizar

**Postcondiciones:**
- ✅ Preferencias de notificaciones retornadas/actualizadas

---

## Matriz de Traceabilidad

### UC ↔ RF (Requerimientos Funcionales)

| UC | Referencia RF | Agregado Raíz | Eventos Principales |
|---|---|---|---|
| UC-A1 | RF-A1 | AuthorizationCode | AuthorizationCodeGenerated |
| UC-A2 | RF-A2 | RefreshToken, Session | TokensIssued |
| UC-A3 | RF-A3 | RefreshToken | RefreshTokenRotated, ReplayAttackDetected |
| UC-A4 | RF-A4 | RefreshToken | TokenRevoked |
| UC-A5 | RF-A5 | User | UserInfoRequested |
| UC-A6 | RF-A10 | User | CredentialsValidationAttempted |
| UC-A7 | RF-A8 | User, EmailVerification | UserRegistered |
| UC-A8 | RF-A8 | User, EmailVerification | EmailVerified |
| UC-A9 | RF-A9 | PasswordRecoveryRequest | PasswordRecoveryRequested |
| UC-A10 | RF-A9 | PasswordRecoveryRequest | PasswordResetCodeGenerated |
| UC-A11 | RF-A9 | User, PasswordResetCode | PasswordReset |
| UC-A12 | Custom | User | PasswordChanged |
| UC-T1 | RF-B1 | Tenant | TenantCreated |
| UC-T2 | RF-B1 | Tenant | — (read-only) |
| UC-T3 | RF-B1 | Tenant | — (read-only) |
| UC-T4 | Custom | Tenant | TenantUpdated |
| UC-T5 | Custom | Tenant | TenantSuspended |
| UC-T6 | Custom | Tenant | TenantReactivated |
| UC-T7 | RF-B2 | User | UserCreated |
| UC-T13 | RF-B3 | ClientApp | ClientAppCreated |
| UC-T16 | RF-B4 | Role | RoleCreated |
| UC-T18 | RF-B5 | Membership | MembershipAssigned |
| UC-B1 | RF-B6 | AppPlan | — (read-only) |
| UC-B3 | RF-B6 | AppPlan | PlanCreated |
| UC-B5 | RF-B7 | Contract | ContractCreated |
| UC-B6 | RF-B7 | Contract, Invoice | SubscriptionActivated |
| UC-B7 | RF-B8 | Invoice | InvoiceGenerated |
| UC-B8 | RF-B9 | Invoice, PaymentTransaction | PaymentProcessed |
| UC-B9 | RF-B10 | Contract, Invoice | SubscriptionRenewed |
| UC-B12 | RF-B12 | Invoice | — (read-only) |

### Agregados → Bounded Contexts

| Agregado | Bounded Context | UC Owners |
|---|---|---|
| AuthorizationCode | AUTH | UC-A1, UC-A2 |
| RefreshToken | AUTH | UC-A2, UC-A3, UC-A4 |
| Session | AUTH | UC-A2, UC-AC3, UC-AC4 |
| EmailVerification | AUTH | UC-A7, UC-A8 |
| PasswordRecoveryRequest | AUTH | UC-A9, UC-A10, UC-A11 |
| User | AUTH + TENANTS + ACCOUNT | UC-A5, UC-A6, UC-A7, UC-A8, UC-A12, UC-T7, UC-AC1, UC-AC2 |
| Tenant | TENANTS | UC-T1, UC-T2, UC-T3, UC-T4, UC-T5, UC-T6 |
| ClientApp | TENANTS | UC-T13, UC-T14, UC-T15 |
| Role | TENANTS | UC-T16, UC-T17 |
| Membership | TENANTS | UC-T18, UC-T19, UC-T20, UC-AC5 |
| AppPlan | BILLING | UC-B1, UC-B2, UC-B3, UC-B4 |
| Contract | BILLING | UC-B5, UC-B6, UC-B9, UC-B10, UC-B11 |
| Invoice | BILLING | UC-B6, UC-B7, UC-B8, UC-B9, UC-B10, UC-B12, UC-B13 |
| PaymentTransaction | BILLING | UC-B8 |

---

## Notas de Implementación

### Patrones DDD Aplicados

- **Value Objects:** Token claims, Password hash, PKCE challenge, Email address
- **Entities:** User, Tenant, Role, Membership, Contract, Invoice (tienen identidad persistente)
- **Aggregates:** RefreshToken (root), Session (root), Tenant (root), Contract (root), Invoice (root)
- **Repositories:** RefreshTokenRepository, SessionRepository, UserRepository, TenantRepository, ContractRepository
- **Domain Events:** Publicados por cada cambio de estado relevante (UC postcondiciones)
- **Anti-Corruption Layer:** PaymentGatewayAdapter (traduce respuestas Stripe/MercadoPago a domain objects)

### Testing Strategy

- **UC-A1 through UC-A12:** Unit tests (no Spring), domain event assertions
- **UC-T1 through UC-T22:** Integration tests (TestContainers JPA, tenant isolation)
- **UC-B1 through UC-B13:** Billing context tests + payment gateway mocking (T-013)

### Links a Documentación Relacionada

- `02-requirements/README.md` — Requerimientos funcionales completos
- `06-development/architecture.md` — Mapeo UC → Módulos, patterns
- `07-testing/test-plans.md` — Escenarios Gherkin por UC
- `11-feedback/retrospectives.md` — DDD maturity scores (8-9/10 para UC-A, UC-T, UC-B)

---

**Última actualización:** 2026-04-20  
**Próximo:** Capability Matrix (UC-B: Coverage análisis)  
**Co-authored by:** Copilot + Domain-Driven Design Framework
