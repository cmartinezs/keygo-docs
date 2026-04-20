[← Índice](./README.md) | [< Anterior](./api-reference.md) | [Siguiente >](./bootstrap-filter-routes.md)

---

# API Endpoints — Comprehensive Reference

Complete specification of all 9 KeyGo endpoint groups consolidatedfor developer reference.

**Use this document alongside** [API Reference](./api-reference.md) **for response structure conventions.**

## Contenido

- [1. Discovery & Registration (Public)](#1-discovery--registration-public)
- [2. Authentication & OAuth2](#2-authentication--oauth2)
- [3. Account (Self-Service)](#3-account-self-service)
- [4. Tenant Users](#4-tenant-users)
- [5. Tenant Apps](#5-tenant-apps)
- [6. Billing & Plans](#6-billing--plans)
- [7. Platform Admin](#7-platform-admin)
- [8. Error Reference](#8-error-reference)
- [9. Postman/cURL Examples](#9-postmancurl-examples)

---

## 1. Discovery & Registration (Public)

**All endpoints in this section are [PUBLIC] — no authentication required.**

### GET /tenants/public

List active tenants available for self-registration.

```
GET /api/v1/tenants/public?page=0&size=50&name_like=acme
```

**Query Parameters:**
- `page` (int, optional, default: 0) — Page number
- `size` (int, optional, default: 20, max: 100) — Items per page
- `name_like` (string, optional) — Filter by tenant name substring

**Response 200 OK:**
```json
{
  "data": {
    "content": [
      {
        "id": "550e8400-1234-5678-abcd-ef1234567890",
        "slug": "acme",
        "name": "ACME Corp"
      }
    ],
    "page": 0,
    "size": 50,
    "totalElements": 1,
    "totalPages": 1,
    "last": true
  }
}
```

**Error Responses:**
- `400 BAD_REQUEST` — Invalid pagination parameters

---

### GET /tenants/{tenantSlug}/apps/public

List apps of a tenant that allow self-registration.

Only returns apps with:
- `type = PUBLIC`
- `status = ACTIVE`
- `registration_policy` ∈ `{OPEN_AUTO_ACTIVE, OPEN_AUTO_PENDING}`

```
GET /api/v1/tenants/acme/apps/public?page=0&size=20
```

**Response 200 OK:**
```json
{
  "data": {
    "content": [
      {
        "id": "app-uuid",
        "client_id": "acme-web",
        "name": "Acme Web Portal",
        "status": "ACTIVE",
        "type": "PUBLIC",
        "registration_policy": "OPEN_AUTO_ACTIVE"
      }
    ],
    "page": 0,
    "size": 20,
    "totalElements": 1,
    "totalPages": 1,
    "last": true
  }
}
```

---

### POST /tenants/{tenantSlug}/account/register

Self-register new user in tenant and optionally join app.

```
POST /api/v1/tenants/acme/account/register
Content-Type: application/json

{
  "email": "newuser@example.com",
  "password": "SecurePass123!",
  "firstName": "John",
  "lastName": "Doe",
  "appId": "app-uuid-or-null"
}
```

**Response 201 CREATED:**
```json
{
  "data": {
    "userId": "user-uuid",
    "email": "newuser@example.com",
    "status": "PENDING",
    "createdAt": "2026-04-20T04:00:00Z"
  }
}
```

**Error Responses:**
- `400 INVALID_INPUT` — Password doesn't meet policy (min 8 chars, uppercase, digit, special)
- `409 DUPLICATE_EMAIL` — Email already registered

---

## 2. Authentication & OAuth2

### POST /platform/account/login [PUBLIC]

Platform-level login (KeyGo console admins).

```
POST /api/v1/platform/account/login
Content-Type: application/json

{
  "email": "admin@keygo.io",
  "password": "SecurePass123!"
}
```

**Response 200 OK:**
```json
{
  "access_token": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "refresh_token_value"
}
```

**Details:**
- Access token valid 1 hour (`expires_in` seconds)
- Refresh token stored in HttpOnly, Secure, SameSite=Strict cookie
- JWT signed with tenant-specific key (see [OAuth2/OIDC Contract](./oauth2-oidc-contract.md))

**Error Responses:**
- `401 UNAUTHORIZED` — Invalid email/password
- `429 TOO_MANY_REQUESTS` — Brute force protection (contact support)

---

### POST /tenants/{tenantSlug}/oauth2/authorize [PUBLIC]

Start PKCE Authorization Code flow.

```
GET /api/v1/tenants/acme/oauth2/authorize?
  client_id=my-app&
  redirect_uri=https://app.example.com/callback&
  response_type=code&
  scope=openid%20profile%20email&
  state=random-state&
  code_challenge=code-challenge-s256&
  code_challenge_method=S256
```

Redirects user to login form. On success, redirects to `redirect_uri` with `code` and `state`.

See [OAuth2/OIDC Contract](./oauth2-oidc-contract.md) § PKCE Authorization Code Flow for full details.

---

### POST /tenants/{tenantSlug}/oauth2/token [PUBLIC]

Exchange authorization code for access token (PKCE).

```
POST /api/v1/tenants/acme/oauth2/token
Content-Type: application/x-www-form-urlencoded

grant_type=authorization_code&
code=AUTH_CODE_FROM_AUTHORIZE&
code_verifier=CODE_VERIFIER&
client_id=my-app&
redirect_uri=https://app.example.com/callback
```

**Response 200 OK:**
```json
{
  "access_token": "eyJ...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "refresh_token": "refresh_token_value",
  "id_token": "eyJ..." 
}
```

**Error Responses:**
- `400 INVALID_GRANT` — Invalid code or code_verifier
- `400 INVALID_CLIENT` — Unknown client_id

---

### POST /tenants/{tenantSlug}/oauth2/token (Refresh)

Refresh access token using refresh token.

```
POST /api/v1/tenants/acme/oauth2/token
Content-Type: application/x-www-form-urlencoded

grant_type=refresh_token&
refresh_token=REFRESH_TOKEN_FROM_COOKIE&
client_id=my-app
```

**Response 200 OK:** New access token (+ rotated refresh token via cookie)

**Error Responses:**
- `400 INVALID_GRANT` — Refresh token invalid, expired, or compromised (see T-035 Replay Detection in [OAuth2/OIDC Contract](./oauth2-oidc-contract.md))
- `401 UNAUTHORIZED` — Entire session chain revoked due to replay attack

---

### POST /platform/oauth2/revoke

Revoke refresh tokens (logout). User token is still valid until `exp`, but refresh will fail.

```
POST /api/v1/platform/oauth2/revoke
Authorization: Bearer {access_token}
Content-Type: application/x-www-form-urlencoded

token=refresh_token_value&
token_type_hint=refresh_token
```

**Response 200 OK** (always, per RFC 7009 — even if already revoked)

See [OAuth2/OIDC Contract](./oauth2-oidc-contract.md) § Logout for complete flow.

---

## 3. Account (Self-Service)

**All endpoints require** `Authorization: Bearer {access_token}`

### GET /account/profile

Get authenticated user's profile.

```
GET /api/v1/account/profile
Authorization: Bearer {access_token}
```

**Response 200 OK:**
```json
{
  "data": {
    "userId": "user-uuid",
    "email": "john@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "phoneNumber": "+56912345678",
    "locale": "es-CL",
    "zoneinfo": "America/Santiago"
  }
}
```

---

### PATCH /account/profile

Update own profile (partial update).

```
PATCH /api/v1/account/profile
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "firstName": "Carlos",
  "phoneNumber": "+56911111111",
  "locale": "es"
}
```

**Response 200 OK:** Updated profile object

---

### POST /account/change-password

Change password when current password is known.

```
POST /api/v1/account/change-password
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "currentPassword": "OldPass1!",
  "newPassword": "NewPass1!"
}
```

**Response 200 OK:** { "message": "Password changed" }

**Error Responses:**
- `401 INVALID_CREDENTIALS` — Current password incorrect
- `400 INVALID_INPUT` — New password doesn't meet policy

---

### POST /account/forgot-password [PUBLIC]

Request password recovery email. **Always responds 200** (anti-enumeration).

```
POST /api/v1/account/forgot-password
Content-Type: application/json

{
  "email": "user@example.com"
}
```

**Response 200 OK** (whether email exists or not)

Email contains: `/recover-password?token=RECOVERY_TOKEN`

---

### POST /account/recover-password [PUBLIC]

Set new password using recovery token from email.

```
POST /api/v1/account/recover-password
Content-Type: application/json

{
  "token": "recovery-token-from-email",
  "newPassword": "NewPass1!"
}
```

**Response 200 OK:** Password changed

**Error Responses:**
- `400 INVALID_INPUT` — Token invalid, expired, or already used

---

### GET /account/sessions

List active sessions for current user.

```
GET /api/v1/account/sessions
Authorization: Bearer {access_token}
```

**Response 200 OK:**
```json
{
  "data": [
    {
      "sessionId": "session-uuid",
      "userAgent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64)...",
      "ipAddress": "192.168.1.100",
      "createdAt": "2026-04-20T00:00:00Z",
      "lastActivityAt": "2026-04-20T04:00:00Z",
      "isCurrent": true
    }
  ]
}
```

---

### DELETE /account/sessions/{sessionId}

Revoke a specific session (logouts that device).

```
DELETE /api/v1/account/sessions/session-uuid
Authorization: Bearer {access_token}
```

**Response 204 NO CONTENT**

---

## 4. Tenant Users

**Requires** `Authorization: Bearer {token}` **with** `ADMIN_ORG` **role.**

### GET /tenants/{tenantSlug}/users

List users in tenant.

```
GET /api/v1/tenants/acme/users?page=0&size=20&status=ACTIVE&email_like=john
Authorization: Bearer {access_token}
```

**Query Parameters:**
- `page`, `size` — Pagination
- `status` (optional) — Filter: ACTIVE, PENDING, SUSPENDED, DELETED
- `email_like` (optional) — Substring filter on email

**Response 200 OK:**
```json
{
  "data": {
    "content": [
      {
        "userId": "user-uuid",
        "email": "john@example.com",
        "firstName": "John",
        "status": "ACTIVE",
        "createdAt": "2026-04-01T00:00:00Z"
      }
    ],
    "page": 0,
    "size": 20,
    "totalElements": 150,
    "totalPages": 8,
    "last": false
  }
}
```

---

### POST /tenants/{tenantSlug}/users

Create user in tenant.

```
POST /api/v1/tenants/acme/users
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "email": "newuser@example.com",
  "firstName": "New",
  "lastName": "User"
}
```

**Response 201 CREATED:** User created with status PENDING (email verification sent)

**Error Responses:**
- `409 DUPLICATE_EMAIL` — Email already registered in this tenant

---

### GET /tenants/{tenantSlug}/users/{userId}

Get user details.

```
GET /api/v1/tenants/acme/users/user-uuid
Authorization: Bearer {access_token}
```

**Response 200 OK:** User details

---

### PUT /tenants/{tenantSlug}/users/{userId}/suspend

Suspend user (revokes all active tokens/sessions).

```
PUT /api/v1/tenants/acme/users/user-uuid/suspend
Authorization: Bearer {access_token}
```

**Response 200 OK:** User status changed to SUSPENDED

---

### PUT /tenants/{tenantSlug}/users/{userId}/activate

Reactivate suspended user.

```
PUT /api/v1/tenants/acme/users/user-uuid/activate
Authorization: Bearer {access_token}
```

**Response 200 OK:** User status changed to ACTIVE

---

## 5. Tenant Apps

**Requires** `Authorization: Bearer {token}` **with** `ADMIN_ORG` **role.**

### GET /tenants/{tenantSlug}/apps

List apps in tenant.

```
GET /api/v1/tenants/acme/apps?page=0&size=20&status=ACTIVE
Authorization: Bearer {access_token}
```

**Response 200 OK:**
```json
{
  "data": {
    "content": [
      {
        "id": "app-uuid",
        "clientId": "my-app-client-id",
        "name": "My Web App",
        "status": "DRAFT",
        "type": "PUBLIC",
        "redirectUris": ["https://app.example.com/callback"],
        "createdAt": "2026-04-01T00:00:00Z"
      }
    ],
    "page": 0,
    "size": 20,
    "totalElements": 5,
    "totalPages": 1,
    "last": true
  }
}
```

---

### POST /tenants/{tenantSlug}/apps

Register new app (client application).

```
POST /api/v1/tenants/acme/apps
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "name": "My Web App",
  "redirectUris": [
    "https://app.example.com/callback",
    "https://app.example.com/callback2"
  ],
  "type": "PUBLIC"
}
```

**Response 201 CREATED:**
```json
{
  "data": {
    "id": "app-uuid",
    "clientId": "my-app-unique-id",
    "clientSecret": "secret-value",
    "name": "My Web App",
    "status": "DRAFT",
    "type": "PUBLIC",
    "redirectUris": ["https://app.example.com/callback"],
    "createdAt": "2026-04-20T04:00:00Z"
  }
}
```

**⚠️ IMPORTANT:** `clientSecret` returned only on creation. Save securely immediately (cannot be retrieved later).

---

### GET /tenants/{tenantSlug}/apps/{appId}

Get app details.

```
GET /api/v1/tenants/acme/apps/app-uuid
Authorization: Bearer {access_token}
```

**Response 200 OK:** App details (without clientSecret)

---

### PUT /tenants/{tenantSlug}/apps/{appId}/activate

Activate app (status: DRAFT → ACTIVE).

```
PUT /api/v1/tenants/acme/apps/app-uuid/activate
Authorization: Bearer {access_token}
```

**Response 200 OK:** App status changed to ACTIVE

---

### DELETE /tenants/{tenantSlug}/apps/{appId}

Delete app and revoke all issued tokens.

```
DELETE /api/v1/tenants/acme/apps/app-uuid
Authorization: Bearer {access_token}
```

**Response 204 NO CONTENT**

**Side effects:**
- All access tokens issued to this app become invalid
- All refresh tokens for this app are revoked

---

## 6. Billing & Plans

### GET /billing/catalog [PUBLIC]

List available plan templates (no auth required).

```
GET /api/v1/billing/catalog
```

**Response 200 OK:**
```json
{
  "data": [
    {
      "planCode": "STARTER",
      "name": "Starter Plan",
      "description": "For small teams",
      "billingOptions": [
        {
          "billingPeriod": "MONTHLY",
          "basePrice": 9.99,
          "currency": "USD",
          "isDefault": true
        }
      ]
    }
  ]
}
```

---

### POST /tenants/{tenantSlug}/apps/{appId}/billing/plans

Create plan version for app (based on catalog or custom).

**Requires** `ADMIN_ORG` **role.**

```
POST /api/v1/tenants/acme/apps/app-uuid/billing/plans
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "code": "STARTER",
  "name": "Starter Plan",
  "version": "v1.0",
  "currency": "USD",
  "trialDays": 14,
  "effectiveFrom": "2026-04-01",
  "billingOptions": [
    {
      "billingPeriod": "MONTHLY",
      "basePrice": 9.99,
      "isDefault": true
    }
  ],
  "entitlements": [
    {
      "metricCode": "MAX_USERS",
      "limitValue": 10.0000,
      "enforcementMode": "HARD"
    }
  ]
}
```

**Response 201 CREATED:** Plan version created

---

### GET /tenants/{tenantSlug}/apps/{appId}/billing/invoices

List invoices for app.

```
GET /api/v1/tenants/acme/apps/app-uuid/billing/invoices?page=0&size=20&status=PENDING
Authorization: Bearer {access_token}
```

**Query Parameters:**
- `status` (optional) — PENDING, PAID, FAILED, CANCELLED

**Response 200 OK:** Paged invoice list

---

## 7. Platform Admin

**Requires** `Authorization: Bearer {token}` **with** `keygo_admin` **role.**

### GET /tenants

List all tenants (platform-wide).

```
GET /api/v1/tenants?page=0&size=20&status=ACTIVE&name_like=acme
Authorization: Bearer {access_token}
```

**Response 200 OK:**
```json
{
  "data": {
    "content": [
      {
        "tenantId": "tenant-uuid",
        "slug": "acme",
        "name": "ACME Corp",
        "status": "ACTIVE",
        "createdAt": "2026-01-01T00:00:00Z"
      }
    ],
    "page": 0,
    "size": 20,
    "totalElements": 50,
    "totalPages": 3,
    "last": false
  }
}
```

---

### POST /tenants

Create new tenant (platform-wide).

```
POST /api/v1/tenants
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "slug": "acme",
  "name": "ACME Corp"
}
```

**Response 201 CREATED:** Tenant created in state ACTIVE

**Error Responses:**
- `409 DUPLICATE_SLUG` — Slug already exists

---

### PUT /tenants/{tenantSlug}/suspend

Suspend tenant (all users/apps lose access).

```
PUT /api/v1/tenants/acme/suspend
Authorization: Bearer {access_token}
```

**Response 200 OK:** Tenant status changed to SUSPENDED

---

### PUT /tenants/{tenantSlug}/activate

Reactivate suspended tenant.

```
PUT /api/v1/tenants/acme/activate
Authorization: Bearer {access_token}
```

**Response 200 OK:** Tenant status changed to ACTIVE

---

### GET /platform/users

List all platform users (KeyGo admins).

```
GET /api/v1/platform/users?page=0&size=20
Authorization: Bearer {access_token}
```

**Response 200 OK:** Paged user list

---

## 8. Error Reference

All error responses follow this format:

```json
{
  "code": "ERROR_CODE",
  "message": "Human-readable description",
  "details": {
    "field": "email",
    "constraint": "Must be unique"
  }
}
```

### Common Error Codes

| Code | HTTP | Meaning |
|------|------|---------|
| `INVALID_INPUT` | 400 | Request validation failed (check `details.constraint`) |
| `UNAUTHORIZED` | 401 | Missing, invalid, or expired token |
| `FORBIDDEN` | 403 | Insufficient permissions (wrong role or tenant scope) |
| `NOT_FOUND` | 404 | Resource not found |
| `DUPLICATE_EMAIL` | 409 | Email already registered |
| `DUPLICATE_SLUG` | 409 | Tenant slug already exists |
| `CONFLICT` | 409 | State conflict (e.g., cannot activate already-active user) |
| `INTERNAL_ERROR` | 500 | Unexpected server error |
| `SERVICE_UNAVAILABLE` | 503 | Server temporarily unavailable (retry-able) |

### Retry Strategy

- **4xx errors:** Do NOT retry; fix request
- **5xx errors:** Retry with exponential backoff (1s, 2s, 4s, 8s, 16s)
- **Network timeout:** Retry with exponential backoff

See [Frontend API Integration](./frontend-api-integration.md) for axios + TanStack Query implementation.

---

## 9. Postman/cURL Examples

### cURL: Platform Login

```bash
curl -X POST http://localhost:8080/api/v1/platform/account/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@keygo.io",
    "password": "SecurePass123!"
  }'
```

### cURL: List Tenant Users

```bash
curl -X GET "http://localhost:8080/api/v1/tenants/acme/users?page=0&size=20" \
  -H "Authorization: Bearer $ACCESS_TOKEN"
```

### cURL: Create App

```bash
curl -X POST http://localhost:8080/api/v1/tenants/acme/apps \
  -H "Authorization: Bearer $ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My App",
    "redirectUris": ["https://app.example.com/callback"],
    "type": "PUBLIC"
  }'
```

### Environment Variables

```bash
# Set before running cURL commands
export API_URL="http://localhost:8080"
export ACCESS_TOKEN="eyJ..."
export TENANT_SLUG="acme"
```

---

## References

- [API Reference](./api-reference.md) — Response structure conventions
- [OAuth2/OIDC Contract](./oauth2-oidc-contract.md) — Auth flow details
- [Authorization Patterns](./authorization-patterns.md) — Role & scope validation
- [Frontend API Integration](./frontend-api-integration.md) — TanStack Query + axios config
- [Bootstrap Filter Routes](./bootstrap-filter-routes.md) — Public routes configuration

---

[← Índice](./README.md) | [< Anterior](./api-reference.md) | [Siguiente >](./bootstrap-filter-routes.md)
