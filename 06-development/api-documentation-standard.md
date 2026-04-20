# Development: API Documentation Standards

**Fase:** 06-development | **Audiencia:** Backend developers, API consumers | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [OpenAPI Specification](#openapi-specification)
2. [Endpoint Documentation](#endpoint-documentation)
3. [Request/Response Examples](#requestresponse-examples)
4. [Error Documentation](#error-documentation)

---

## OpenAPI Specification

### Use OpenAPI 3.0

All endpoints must be documented in OpenAPI 3.0 format. This enables:
- Auto-generated API documentation (Swagger UI)
- Client code generation
- API mocking
- Contract testing

### Schema Definition

```yaml
openapi: 3.0.0
info:
  title: KeyGo API
  version: 1.1.0
  description: Multi-tenant identity and access management platform

servers:
  - url: https://api.keygo.io/v1
    description: Production
  - url: https://staging-api.keygo.io/v1
    description: Staging

paths:
  /tenants:
    post:
      summary: Create a new tenant
      tags: [Tenants]
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateTenantRequest'
      responses:
        '201':
          description: Tenant created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TenantResponse'
        '400':
          $ref: '#/components/responses/BadRequest'
        '409':
          $ref: '#/components/responses/Conflict'

components:
  schemas:
    CreateTenantRequest:
      type: object
      required:
        - slug
        - name
      properties:
        slug:
          type: string
          pattern: '^[a-z0-9-]{3,50}$'
          example: acme-corp
          description: Unique URL-safe identifier for tenant
        name:
          type: string
          minLength: 1
          maxLength: 100
          example: ACME Corporation
          description: Display name of tenant
```

---

## Endpoint Documentation

### Structure

Every endpoint must include:

1. **Summary** (one-liner)
2. **Description** (multi-line if needed)
3. **Tags** (categorization)
4. **Parameters** (query, path, header)
5. **Request body** (if applicable)
6. **Responses** (all possible status codes)
7. **Examples** (curl, JavaScript, etc.)

### Example

```yaml
/tenants/{tenantId}/users:
  get:
    summary: List users in a tenant
    description: |
      Retrieve paginated list of users in the specified tenant.
      Supports filtering by role and status.
      
      **Permissions Required:** TENANT_ADMIN or PLATFORM_ADMIN
    
    tags: [Users]
    
    parameters:
      - name: tenantId
        in: path
        required: true
        schema:
          type: string
          format: uuid
        example: 550e8400-e29b-41d4-a716-446655440000
      
      - name: page
        in: query
        required: false
        schema:
          type: integer
          default: 0
          minimum: 0
        description: Page number (0-indexed)
      
      - name: pageSize
        in: query
        required: false
        schema:
          type: integer
          default: 20
          minimum: 1
          maximum: 100
        description: Results per page
      
      - name: role
        in: query
        required: false
        schema:
          type: string
          enum: [ADMIN, MEMBER, VIEWER]
        description: Filter by role
    
    responses:
      '200':
        description: Users list retrieved
        content:
          application/json:
            schema:
              type: object
              properties:
                data:
                  type: array
                  items:
                    $ref: '#/components/schemas/UserResponse'
                pagination:
                  $ref: '#/components/schemas/Pagination'
      
      '401':
        $ref: '#/components/responses/Unauthorized'
      
      '403':
        $ref: '#/components/responses/Forbidden'
```

---

## Request/Response Examples

### Include Working Examples

For every endpoint, provide at least one complete curl example:

```bash
# Example 1: Create tenant
curl -X POST https://api.keygo.io/v1/tenants \
  -H "Authorization: Bearer eyJ..." \
  -H "Content-Type: application/json" \
  -d '{
    "slug": "acme-corp",
    "name": "ACME Corporation"
  }'

# Response (201):
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "slug": "acme-corp",
  "name": "ACME Corporation",
  "status": "ACTIVE",
  "createdAt": "2026-04-20T14:30:00Z"
}

# Example 2: Error response (409)
{
  "code": "DUPLICATE_RESOURCE",
  "message": "Tenant with slug 'acme-corp' already exists",
  "details": {
    "field": "slug",
    "value": "acme-corp"
  }
}
```

### Document Pagination

```yaml
Pagination:
  type: object
  properties:
    page:
      type: integer
      example: 0
    pageSize:
      type: integer
      example: 20
    totalElements:
      type: integer
      example: 50
    totalPages:
      type: integer
      example: 3
    hasMore:
      type: boolean
      example: true
```

---

## Error Documentation

### Standard Error Response Format

```yaml
ErrorResponse:
  type: object
  required:
    - code
    - message
  properties:
    code:
      type: string
      enum:
        - INVALID_INPUT
        - UNAUTHORIZED
        - FORBIDDEN
        - NOT_FOUND
        - DUPLICATE_RESOURCE
        - RATE_LIMITED
        - INTERNAL_ERROR
      example: INVALID_INPUT
    
    message:
      type: string
      description: Human-readable error message
      example: Validation failed for request body
    
    details:
      type: object
      description: Additional context (optional)
      additionalProperties: true
      example:
        field: slug
        constraint: pattern mismatch
        value: INVALID-SLUG!
```

### Document All Status Codes

```yaml
responses:
  '200':
    description: Success
  
  '201':
    description: Resource created
  
  '204':
    description: Success (no content)
  
  '400':
    description: Bad request (validation error)
    content:
      application/json:
        schema:
          $ref: '#/components/schemas/ErrorResponse'
  
  '401':
    description: Unauthorized (missing or invalid token)
  
  '403':
    description: Forbidden (user lacks permission)
  
  '404':
    description: Resource not found
  
  '409':
    description: Conflict (duplicate resource)
  
  '429':
    description: Rate limited (too many requests)
  
  '500':
    description: Internal server error
```

---

## Versioning in Documentation

### Include Version Constraints

```yaml
paths:
  /api/v1/users:
    post:
      deprecated: false
      x-since: 1.0.0
      x-until: null  # Still supported
  
  /api/v1/users-legacy:
    post:
      deprecated: true
      x-since: 1.0.0
      x-until: 2.0.0
      x-deprecation-date: 2026-10-01
      description: |
        ⚠️ **DEPRECATED** as of v1.2.0
        Use `/api/v2/users` instead.
        Sunset date: 2026-10-01
```

---

## Véase También

- **api-endpoints-comprehensive.md** — All endpoint specs
- **api-versioning-strategy.md** — Versioning strategy
- **validation-strategy.md** — Validation error details

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Backend/DevOps | **Licencia:** Keygo Docs
