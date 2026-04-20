[← Índice](./README.md) | [< Anterior](./architecture.md) | [Siguiente >](./coding-standards.md)

---

# API Reference

Contratos de API REST de Keygo: convenciones, estructura de respuesta y catálogo de endpoints.

## Contenido

- [Convenciones](#convenciones)
- [Estructura de Respuesta](#estructura-de-respuesta)
- [Autenticación](#autenticación)
- [Errores](#errores)
- [Paginación](#paginación)
- [Endpoints: Platform](#endpoints-platform)
- [Endpoints: Tenants](#endpoints-tenants)
- [Endpoints: Usuarios](#endpoints-usuarios)
- [Endpoints: Sesiones](#endpoints-sesiones)
- [Endpoints: Aplicaciones](#endpoints-aplicaciones)
- [Endpoints: Roles y Membresías](#endpoints-roles-y-membresías)
- [Endpoints: Auditoría](#endpoints-auditoría)
- [Endpoints: Planes de Aplicación](#endpoints-planes-de-aplicación)

---

## Convenciones

| Aspecto | Convención |
|---------|-----------|
| URL Base | `/api/v1` |
| Formato | JSON |
| Encoding | UTF-8 |
| Content-Type | `application/json` |
| Identificadores | UUID en path y respuesta |
| Tenant scope | `/api/v1/tenants/{slug}/...` |

### Verbos HTTP

| Verbo | Semántica |
|-------|-----------|
| `GET` | Lectura, sin efectos secundarios |
| `POST` | Crear recurso |
| `PATCH` | Actualización parcial |
| `DELETE` | Eliminación / desactivación |

[↑ Volver al inicio](#api-reference)

---

## Estructura de Respuesta

### Éxito — recurso único

```json
{
  "data": {
    "id": "550e8400-1234-5678-abcd-ef1234567890",
    "email": "user@example.com",
    "status": "ACTIVE"
  },
  "success": {
    "code": "USER_CREATED",
    "message": "User created successfully"
  }
}
```

### Éxito — lista paginada

```json
{
  "data": [
    { "id": "...", "email": "user1@example.com" },
    { "id": "...", "email": "user2@example.com" }
  ],
  "success": { "code": "OK" },
  "pagination": {
    "page": 0,
    "size": 20,
    "totalElements": 150,
    "totalPages": 8
  }
}
```

### Error

```json
{
  "data": null,
  "success": null,
  "error": {
    "code": "USER_ALREADY_EXISTS",
    "message": "A user with this email already exists",
    "origin": "CLIENT_REQUEST",
    "layer": "DOMAIN"
  }
}
```

[↑ Volver al inicio](#api-reference)

---

## Autenticación

### Bearer Token

```
Authorization: Bearer eyJhbGciOiJSUzI1NiJ9...
```

### Claims en token de sesión

```json
{
  "sub": "user-uuid",
  "email": "user@example.com",
  "tenant_slug": "my-company",
  "roles": ["ADMIN_ORG"],
  "app_id": "app-uuid",
  "app_roles": ["EDITOR"],
  "entitlements": { "max_projects": 10, "storage_gb": 5 },
  "aud": "keygo-console",
  "iss": "https://keygo.io/api/v1/tenants/my-company",
  "exp": 1714000000
}
```

### Niveles de acceso

| Nivel | Roles | Alcance |
|-------|-------|---------|
| Platform | `KEYGO_ADMIN`, `KEYGO_ACCOUNT_ADMIN`, `KEYGO_USER` | Toda la plataforma |
| Tenant | `ADMIN_ORG`, `USER`, `VIEWER` | Una organización |
| App | definidos por la organización | Una aplicación |

[↑ Volver al inicio](#api-reference)

---

## Errores

### Códigos de Error

| Código | HTTP | Descripción |
|--------|------|-------------|
| `INVALID_REQUEST` | 400 | Request malformado o parámetros inválidos |
| `UNAUTHORIZED` | 401 | Sin credenciales o token inválido |
| `FORBIDDEN` | 403 | Credenciales válidas pero sin permiso |
| `NOT_FOUND` | 404 | Recurso no encontrado |
| `CONFLICT` | 409 | Recurso ya existe (email, slug, etc.) |
| `TENANT_SUSPENDED` | 403 | Tenant inactivo o suspendido |
| `RATE_LIMITED` | 429 | Demasiadas solicitudes |
| `INTERNAL_ERROR` | 500 | Error interno del servidor |

### Origen y capa

| `origin` | Descripción |
|----------|-------------|
| `CLIENT_REQUEST` | Error producido por datos del cliente |
| `SERVER` | Error interno del servidor |
| `DOMAIN` | Regla de negocio violada |

[↑ Volver al inicio](#api-reference)

---

## Paginación

### Query Params

| Parámetro | Default | Máximo |
|----------|---------|--------|
| `page` | 0 | — |
| `size` | 20 | 100 |
| `sortBy` | `createdAt` | — |
| `sortOrder` | `DESC` | `ASC` / `DESC` |

### Ejemplo

```
GET /api/v1/tenants/acme/users?page=0&size=20&sortBy=email&sortOrder=ASC
```

[↑ Volver al inicio](#api-reference)

---

## Endpoints: Platform

Operaciones globales de la plataforma, no acotadas a un tenant.

| Método | Path | Descripción | Auth |
|--------|------|-------------|------|
| `GET` | `/api/v1/platform/service-info` | Info del servicio (versión, estado) | Pública |
| `GET` | `/api/v1/platform/tenants` | Listar todos los tenants | `KEYGO_ADMIN` |
| `GET` | `/api/v1/platform/accounts` | Listar cuentas de plataforma | `KEYGO_ADMIN` |

### GET /api/v1/platform/service-info

```json
{
  "data": {
    "name": "keygo-server",
    "version": "1.0.0",
    "environment": "production",
    "status": "UP"
  }
}
```

[↑ Volver al inicio](#api-reference)

---

## Endpoints: Tenants

| Método | Path | Descripción | Auth |
|--------|------|-------------|------|
| `POST` | `/api/v1/tenants` | Crear organización | `KEYGO_ADMIN` |
| `GET` | `/api/v1/tenants/{slug}` | Obtener organización | `ADMIN_ORG` |
| `PATCH` | `/api/v1/tenants/{slug}` | Actualizar organización | `ADMIN_ORG` |
| `DELETE` | `/api/v1/tenants/{slug}` | Desactivar organización | `KEYGO_ADMIN` |

### POST /api/v1/tenants

**Request:**
```json
{
  "slug": "acme-corp",
  "name": "ACME Corporation",
  "adminEmail": "admin@acme.com"
}
```

**Response 201:**
```json
{
  "data": {
    "id": "uuid",
    "slug": "acme-corp",
    "name": "ACME Corporation",
    "status": "ACTIVE"
  }
}
```

[↑ Volver al inicio](#api-reference)

---

## Endpoints: Usuarios

| Método | Path | Descripción | Auth |
|--------|------|-------------|------|
| `POST` | `/api/v1/tenants/{slug}/users` | Crear usuario | `ADMIN_ORG` |
| `GET` | `/api/v1/tenants/{slug}/users` | Listar usuarios | `ADMIN_ORG` |
| `GET` | `/api/v1/tenants/{slug}/users/{userId}` | Obtener usuario | `ADMIN_ORG` / propio |
| `PATCH` | `/api/v1/tenants/{slug}/users/{userId}` | Actualizar usuario | `ADMIN_ORG` / propio |
| `DELETE` | `/api/v1/tenants/{slug}/users/{userId}` | Desactivar usuario | `ADMIN_ORG` |
| `POST` | `/api/v1/tenants/{slug}/users/{userId}/password` | Cambiar contraseña | `ADMIN_ORG` / propio |
| `POST` | `/api/v1/tenants/{slug}/users/password-recovery` | Iniciar recuperación | Pública |

### POST /api/v1/tenants/{slug}/users

**Request:**
```json
{
  "email": "john@acme.com",
  "username": "jsmith",
  "firstName": "John",
  "lastName": "Smith"
}
```

**Response 201:**
```json
{
  "data": {
    "id": "uuid",
    "email": "john@acme.com",
    "username": "jsmith",
    "status": "ACTIVE"
  }
}
```

[↑ Volver al inicio](#api-reference)

---

## Endpoints: Sesiones

| Método | Path | Descripción | Auth |
|--------|------|-------------|------|
| `POST` | `/api/v1/tenants/{slug}/oauth2/token` | Emitir token (login) | Pública |
| `POST` | `/api/v1/tenants/{slug}/oauth2/revoke` | Revocar token (logout) | Token válido |
| `POST` | `/api/v1/tenants/{slug}/oauth2/refresh` | Renovar token | Refresh token |
| `GET` | `/api/v1/tenants/{slug}/.well-known/jwks.json` | Claves públicas JWKS | Pública |

### POST /api/v1/tenants/{slug}/oauth2/token

**Request:**
```
Content-Type: application/x-www-form-urlencoded

grant_type=password
&username=john@acme.com
&password=MySecret!
&client_id=my-app
```

**Response 200:**
```json
{
  "data": {
    "access_token": "eyJ...",
    "token_type": "Bearer",
    "expires_in": 3600,
    "refresh_token": "eyJ..."
  }
}
```

[↑ Volver al inicio](#api-reference)

---

## Endpoints: Aplicaciones

| Método | Path | Descripción | Auth |
|--------|------|-------------|------|
| `POST` | `/api/v1/tenants/{slug}/apps` | Registrar aplicación | `ADMIN_ORG` |
| `GET` | `/api/v1/tenants/{slug}/apps` | Listar aplicaciones | `ADMIN_ORG` |
| `GET` | `/api/v1/tenants/{slug}/apps/{appId}` | Obtener aplicación | `ADMIN_ORG` |
| `PATCH` | `/api/v1/tenants/{slug}/apps/{appId}` | Actualizar aplicación | `ADMIN_ORG` |
| `DELETE` | `/api/v1/tenants/{slug}/apps/{appId}` | Desactivar aplicación | `ADMIN_ORG` |

### POST /api/v1/tenants/{slug}/apps

**Request:**
```json
{
  "name": "My SaaS App",
  "slug": "my-saas",
  "redirectUris": ["https://myapp.com/callback"],
  "scopes": ["openid", "profile", "email"]
}
```

**Response 201:**
```json
{
  "data": {
    "id": "uuid",
    "slug": "my-saas",
    "clientId": "my-saas-client-id",
    "clientSecret": "generated-secret",
    "status": "ACTIVE"
  }
}
```

[↑ Volver al inicio](#api-reference)

---

## Endpoints: Roles y Membresías

| Método | Path | Descripción | Auth |
|--------|------|-------------|------|
| `POST` | `/api/v1/tenants/{slug}/apps/{appId}/roles` | Crear rol | `ADMIN_ORG` |
| `GET` | `/api/v1/tenants/{slug}/apps/{appId}/roles` | Listar roles | `ADMIN_ORG` |
| `PATCH` | `/api/v1/tenants/{slug}/apps/{appId}/roles/{roleId}` | Actualizar rol | `ADMIN_ORG` |
| `DELETE` | `/api/v1/tenants/{slug}/apps/{appId}/roles/{roleId}` | Eliminar rol | `ADMIN_ORG` |
| `POST` | `/api/v1/tenants/{slug}/users/{userId}/memberships` | Asignar usuario a app+rol | `ADMIN_ORG` |
| `GET` | `/api/v1/tenants/{slug}/users/{userId}/memberships` | Listar membresías del usuario | `ADMIN_ORG` |
| `DELETE` | `/api/v1/tenants/{slug}/users/{userId}/memberships/{id}` | Remover membresía | `ADMIN_ORG` |

### POST /api/v1/tenants/{slug}/users/{userId}/memberships

**Request:**
```json
{
  "appId": "uuid",
  "roleId": "uuid"
}
```

**Response 201:**
```json
{
  "data": {
    "id": "uuid",
    "userId": "uuid",
    "appId": "uuid",
    "roleId": "uuid",
    "status": "ACTIVE"
  }
}
```

[↑ Volver al inicio](#api-reference)

---

## Endpoints: Auditoría

| Método | Path | Descripción | Auth |
|--------|------|-------------|------|
| `GET` | `/api/v1/tenants/{slug}/audit-logs` | Listar eventos de auditoría | `ADMIN_ORG` |
| `GET` | `/api/v1/tenants/{slug}/audit-logs/{eventId}` | Obtener evento | `ADMIN_ORG` |

### Query params de auditoría

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `from` | ISO 8601 | Fecha inicio |
| `to` | ISO 8601 | Fecha fin |
| `actorId` | UUID | Filtrar por actor |
| `eventType` | string | Tipo de evento |
| `page`, `size` | int | Paginación estándar |

[↑ Volver al inicio](#api-reference)

---

## Endpoints: Planes de Aplicación

Permiten a una aplicación cliente ofrecer planes comerciales a sus usuarios finales (RF22, RF23, RF24).

| Método | Path | Descripción | Auth |
|--------|------|-------------|------|
| `POST` | `/api/v1/tenants/{slug}/apps/{appId}/plans` | Crear plan | `ADMIN_ORG` |
| `GET` | `/api/v1/tenants/{slug}/apps/{appId}/plans` | Listar planes (catálogo) | `ADMIN_ORG` / `USER` |
| `GET` | `/api/v1/tenants/{slug}/apps/{appId}/plans/{planId}` | Obtener plan | `ADMIN_ORG` / `USER` |
| `PATCH` | `/api/v1/tenants/{slug}/apps/{appId}/plans/{planId}` | Actualizar plan | `ADMIN_ORG` |
| `POST` | `/api/v1/tenants/{slug}/apps/{appId}/subscriptions` | Suscribir usuario a plan | `USER` |
| `GET` | `/api/v1/tenants/{slug}/apps/{appId}/subscriptions/{subId}` | Obtener suscripción | `ADMIN_ORG` / propio |
| `DELETE` | `/api/v1/tenants/{slug}/apps/{appId}/subscriptions/{subId}` | Cancelar suscripción | `ADMIN_ORG` / propio |

### POST /api/v1/tenants/{slug}/apps/{appId}/plans

**Request:**
```json
{
  "name": "Pro",
  "billingCadence": "MONTHLY",
  "entitlements": {
    "max_projects": 50,
    "storage_gb": 100,
    "api_calls_per_day": 10000
  }
}
```

### POST /api/v1/tenants/{slug}/apps/{appId}/subscriptions

**Request:**
```json
{
  "planId": "uuid",
  "userId": "uuid",
  "billingCadence": "MONTHLY"
}
```

Los derechos del plan (`entitlements`) quedan embebidos en el token de sesión tras la suscripción activa.

[↑ Volver al inicio](#api-reference)

---

[← Índice](./README.md) | [< Anterior](./architecture.md) | [Siguiente >](./coding-standards.md)
