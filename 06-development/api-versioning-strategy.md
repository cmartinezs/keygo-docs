[← Índice](./README.md) | [< Anterior](./authorization-patterns.md) | [Siguiente >](./database-schema.md)

---

# API Versioning Strategy

Estrategia de versionado de APIs, gestión de cambios breaking, deprecación y sunset de versiones en KeyGo.

## Contenido

- [Decisión: URI Path Versioning](#decisión-uri-path-versioning)
- [Semantic Versioning de API](#semantic-versioning-de-api)
- [Tipos de Cambios](#tipos-de-cambios)
- [Lifecycle: v1 → v2](#lifecycle-v1--v2)
- [Implementación: Estructura de Carpetas](#implementación-estructura-de-carpetas)
- [Migration Guide](#migration-guide)
- [Deprecation Headers](#deprecation-headers)
- [Checklist para Cambios](#checklist-para-cambios)

---

## Decisión: URI Path Versioning

**Estrategia elegida:** Versión en la URL (`/api/v1`, `/api/v2`)

```
/api/v1/tenants/{slug}     ← stable, backward-compatible
/api/v2/tenants/{slug}     ← new, breaking changes allowed
```

### Ventajas

✅ **Explícito:** Cliente elige versión en URL  
✅ **Cacheable:** CDN/proxies pueden cachear por versión  
✅ **Sin negociación:** No requiere headers complejos  
✅ **OpenAPI clara:** Documentación separada por versión  
✅ **Soporte dual simple:** v1 y v2 en paralelo sin conflicto  

### Desventajas

❌ **Duplicación de código:** Endpoints en v1 y v2  
❌ **Mantenimiento:** v1 + v2 ambas soportadas durante transición  
❌ **Proliferación:** Riesgo de v1, v2, v3, v4 todas vivas  

### Alternativas Rechazadas

❌ **Content-Type versioning** (`application/vnd.keygo.v2+json`)  
→ Demasiado complejo, negotiate en cada request, no cacheble

❌ **Header versioning** (`X-API-Version: 2`)  
→ No cacheble, menos explícito, difícil de documentar

❌ **Implicit versioning** (siempre v1)  
→ Imposible evolucionar sin romper clientes

[↑ Volver al inicio](#api-versioning-strategy)

---

## Semantic Versioning de API

```
/api/v{MAJOR}.{MINOR}
```

**Regla simple:**
- **v1.0 → v1.1** (minor): Cambios backward-compatible (nuevo endpoint, nuevo campo opcional)
- **v1.0 → v2.0** (major): Breaking changes (remover endpoint, cambiar estructura)

**Dentro de v1:** Solo **agregar**, nunca **quitar**.

### Ejemplos

**v1.0:**
```
GET /api/v1/tenants/{slug}
POST /api/v1/tenants
PUT /api/v1/tenants/{slug}
```

**v1.1 (backward-compatible, add field):**
```
GET /api/v1/tenants/{slug}
  Response: { id, name, createdAt, lastActivityAt }  ← NUEVO campo
```

**v1.2 (backward-compatible, add endpoint):**
```
GET /api/v1/tenants/{slug}/notifications/subscribe  ← NUEVO endpoint
```

**v2.0 (breaking, new structure):**
```
GET /api/v2/tenants/{id}  ← id (UUID), no slug
  Response: { id, name, createdAt, metadata: {...} }  ← Estructura diferente
```

[↑ Volver al inicio](#api-versioning-strategy)

---

## Tipos de Cambios

### Backward-Compatible (No requiere v2)

Agregar en **v1.x**, es seguro para clientes existentes:

#### ✅ Nuevo endpoint

```
POST /api/v1/tenants/{slug}/notifications/subscribe  ← v1.1
```

Cliente old sigue trabajando sin notar.

#### ✅ Nuevo field opcional en response

```json
// v1.0 response
{ "id": "...", "name": "..." }

// v1.1 response (backward-compatible)
{ "id": "...", "name": "...", "createdAt": "2026-04-10T..." }
```

Cliente old ignora `createdAt`, no rompe.

#### ✅ Nuevo query parameter (opcional)

```
GET /api/v1/tenants?include=stats  ← v1.1, parámetro opcional
```

Client old no envía `include=stats`, sigue funcionando.

#### ✅ Nuevo HTTP header response

```
HTTP/1.1 200 OK
X-RateLimit-Remaining: 99  ← v1.1, nuevo header
```

Cliente old ignora header, no afecta.

---

### Breaking Changes (Requiere v2)

Cambios que rompen clientes existentes = **nueva versión major**:

#### ❌ Remover endpoint

```
v1.0: POST /api/v1/tenants/{slug}/foo
v2.0: (removido)
```

Clientes que usan `/foo` obtienen 404.

#### ❌ Cambiar nombre de field

```
v1.0 response: { firstName: "John" }
v2.0 response: { givenName: "John" }
```

Cliente v1 busca `firstName`, no lo encuentra.

#### ❌ Cambiar tipo de field

```
v1.0: createdAt = "2026-04-10T10:00:00Z" (ISO string)
v2.0: createdAt = 1680000000 (unix epoch)
```

Cliente espera string, recibe integer.

#### ❌ Remover campo requerido

```
v1.0: email (required)
v2.0: email (removed)
```

Cliente espera email siempre presente.

#### ❌ Cambiar estructura de error

```
v1.0: { error: { code: "INVALID_INPUT", message: "..." } }
v2.0: { code: "INVALID_INPUT", detail: "..." }
```

Parser de cliente rompe.

[↑ Volver al inicio](#api-versioning-strategy)

---

## Lifecycle: v1 → v2

### Fase 1: Desarrollo (Mes 1-2)

- Diseñar v2 en documentación (RFC, ADR)
- Implementar v2 endpoints en paralelo con v1
- Tests para ambas versiones
- v1 sigue siendo default (no cambiar)

**Timeline:** Sprint 1-2

### Fase 2: Beta Release (Mes 2-3)

```
Email a clientes:
"🎉 v2 disponible en /api/v2 (beta). Plan de deprecación de v1:

- Ahora: v2 disponible, v1 stable
- Mes 6: v1 deprecated (legacy support warning)
- Mes 9: v1 removida"
```

**Docs actualizado:**
```markdown
## v2.0 — Current (Recommended)

Recomendado para nuevas integraciones. [API Reference v2]

---

## v1.0 — Legacy (deprecated, sunset 2026-10-10)

Soportado hasta 2026-10-10. Migrar a v2.
[Migration Guide v1 → v2]
```

### Fase 3: Soporte Dual (Mes 2-6)

- v1 + v2 ambos soportados en producción
- v1 documentado como "legacy"
- Clientes migran a su ritmo
- Monitorear adopción de v2

### Fase 4: Deprecation (Mes 6-9)

Agregar headers de deprecación a todas las respuestas v1:

```http
HTTP/1.1 200 OK
Deprecation: true
Sunset: Sun, 10 Oct 2026 00:00:00 GMT
Link: </api/v2/tenants>; rel="successor-version"

{ "data": {...}, "success": {...} }
```

Cliente ve warning en logs/console.

### Fase 5: Sunset (Mes 9)

- v1 removida completamente
- v2 es la única versión
- Clientes que no migraron obtienen 410 Gone

```http
GET /api/v1/tenants

HTTP/1.1 410 Gone

{
  "error": {
    "code": "API_VERSION_SUNSET",
    "detail": "API v1 is no longer supported. Migrate to v2."
  },
  "meta": {
    "successorVersion": "v2",
    "migrationGuide": "https://docs.keygo.local/api/migration/v1-to-v2"
  }
}
```

[↑ Volver al inicio](#api-versioning-strategy)

---

## Implementación: Estructura de Carpetas

```
keygo-api/src/main/java/io/cmartinezs/keygo/api/
├── v1/                          ← Legacy
│   ├── controller/
│   │   ├── TenantControllerV1.java
│   │   ├── UserControllerV1.java
│   │   └── ...
│   ├── request/
│   │   ├── CreateTenantRequestV1.java
│   │   └── ...
│   └── response/
│       ├── TenantDataV1.java
│       └── ...
│
├── v2/                          ← Current
│   ├── controller/
│   │   ├── TenantControllerV2.java    ← Nuevo diseño
│   │   ├── UserControllerV2.java
│   │   └── ...
│   ├── request/
│   │   ├── CreateTenantRequestV2.java  ← Estructura diferente
│   │   └── ...
│   └── response/
│       ├── TenantDataV2.java           ← Nuevos campos
│       └── ...
│
└── shared/                      ← Compartido entre versiones
    ├── ResponseCode.java         
    ├── ErrorData.java            
    ├── BaseResponse.java         
    ├── mapper/
    │   ├── TenantMapperV1.java
    │   ├── TenantMapperV2.java
    │   └── ...
    └── security/
        ├── JwtValidator.java
        └── ...
```

### Controllers

```java
// v1 — Legacy
@RestController
@RequestMapping("/api/v1/tenants")
@Tag(name = "Tenants (v1 Legacy)")
public class TenantControllerV1 {

  @GetMapping("/{slug}")
  public ResponseEntity<BaseResponse<TenantDataV1>> getTenant(
      @PathVariable String slug) { ... }
}

// v2 — Current
@RestController
@RequestMapping("/api/v2/tenants")
@Tag(name = "Tenants (v2 Current)")
public class TenantControllerV2 {

  @GetMapping("/{id}")
  public ResponseEntity<BaseResponse<TenantDataV2>> getTenant(
      @PathVariable UUID id) { ... }
}
```

### Request/Response DTOs

```java
// v1
public record CreateTenantRequestV1(
    String name,
    String country
) {}

public record TenantDataV1(
    String slug,
    String name,
    String status,
    long createdAt  // epoch millis
) {}

// v2
public record CreateTenantRequestV2(
    String name,
    String country,
    Optional<String> description  ← NUEVO campo
) {}

public record TenantDataV2(
    UUID id,
    String slug,
    String name,
    String status,
    Instant createdAt,  ← ISO 8601 string
    TenantMetadataV2 metadata  ← NUEVA estructura
) {}

public record TenantMetadataV2(
    String region,
    String tier,
    Optional<String> customDomain
) {}
```

[↑ Volver al inicio](#api-versioning-strategy)

---

## Migration Guide

**Cambios clave v1 → v2:**

| Aspecto | v1 | v2 |
|---|---|---|
| **Tenant ID** | `slug` (string) | `id` (UUID) + `slug` |
| **Response envelope** | `{ data, success }` | `{ data, meta }` |
| **Error structure** | `{ error: { code, message } }` | `{ error: { code, detail, traceId } }` |
| **Pagination** | `page, size, totalElements` | `offset, limit, total` (cursor-friendly) |
| **Timestamps** | epoch millis | ISO 8601 string |

### Ejemplo: GET /tenants

**v1:**
```bash
curl -X GET "http://localhost:8080/api/v1/tenants?page=0&size=20"

Response:
{
  "data": {
    "content": [
      { "slug": "tenant-1", "name": "Acme Corp", "status": "ACTIVE" },
      { "slug": "tenant-2", "name": "Widgets Inc", "status": "ACTIVE" }
    ],
    "page": 0,
    "size": 20,
    "totalElements": 100
  },
  "success": { "code": "TENANT_LIST_RETRIEVED" }
}
```

**v2:**
```bash
curl -X GET "http://localhost:8080/api/v2/tenants?offset=0&limit=20"

Response:
{
  "data": {
    "items": [
      { "id": "uuid-1", "slug": "tenant-1", "name": "Acme Corp", "status": "ACTIVE" },
      { "id": "uuid-2", "slug": "tenant-2", "name": "Widgets Inc", "status": "ACTIVE" }
    ],
    "pagination": {
      "offset": 0,
      "limit": 20,
      "total": 100
    }
  },
  "meta": {
    "version": "2.0",
    "timestamp": "2026-04-10T10:00:00Z"
  }
}
```

**Cliente Java (usando v1):**
```java
// v1
RestTemplate rest = new RestTemplate();
String url = "http://localhost:8080/api/v1/tenants?page=0&size=20";
ResponseEntity<V1Response> response = rest.getForEntity(url, V1Response.class);

List<TenantV1> tenants = response.getBody().getData().getContent();
```

**Cliente Java (usando v2):**
```java
// v2
String url = "http://localhost:8080/api/v2/tenants?offset=0&limit=20";
ResponseEntity<V2Response> response = rest.getForEntity(url, V2Response.class);

List<TenantV2> tenants = response.getBody().getData().getItems();
```

[↑ Volver al inicio](#api-versioning-strategy)

---

## Deprecation Headers

### RFC 8574 (Deprecation Header)

Agregar a **todas las respuestas v1**:

```http
HTTP/1.1 200 OK
Deprecation: true
Sunset: Sun, 10 Oct 2026 00:00:00 GMT
Link: </api/v2/tenants>; rel="successor-version"
```

### Implementación en Spring

```java
@Component
public class DeprecationHeaderFilter extends OncePerRequestFilter {

  @Override
  protected void doFilterInternal(
      HttpServletRequest request,
      HttpServletResponse response,
      FilterChain filterChain) throws ServletException, IOException {
    
    if (request.getRequestURI().contains("/api/v1/")) {
      response.setHeader("Deprecation", "true");
      response.setHeader("Sunset", "Sun, 10 Oct 2026 00:00:00 GMT");
      response.setHeader("Link", "</api/v2>; rel=\"successor-version\"");
    }
    
    filterChain.doFilter(request, response);
  }
}
```

**Cliente JavaScript recibe warning:**
```
Warning: 299 - "Deprecation: API version v1 sunset on 2026-10-10"
```

[↑ Volver al inicio](#api-versioning-strategy)

---

## Checklist para Cambios

### Antes de hacer cambios en API:

- [ ] **¿Qué tipo de cambio?**
  - [ ] Agregar endpoint → v1.x (backward-compatible)
  - [ ] Agregar campo opcional → v1.x (backward-compatible)
  - [ ] Remover endpoint → v2.0 (breaking)
  - [ ] Cambiar estructura → v2.0 (breaking)

- [ ] **¿Quién lo usa?** (búsqueda en logs, telemetría)
  - [ ] Pocos clientes → rápido sunset
  - [ ] Muchos clientes → soporte dual más largo

- [ ] **¿Documentación actualizada?**
  - [ ] `api-reference.md` con nuevo endpoint/parámetro
  - [ ] OpenAPI spec (`/v3/api-docs`)
  - [ ] Migration guide si es breaking (v1 → v2)

- [ ] **¿Tests para ambas versiones?**
  - [ ] v1 endpoint tests
  - [ ] v2 endpoint tests
  - [ ] Compatibilidad entre versiones

- [ ] **¿Backward-compatible fallback?** (si es posible)
  - [ ] ¿Se puede agregar en v1 sin romper?
  - [ ] ¿O requiere v2?

- [ ] **¿Deprecation timeline?** (si es breaking)
  - [ ] Mes de anuncio
  - [ ] Mes de soporte dual
  - [ ] Mes de deprecation warnings
  - [ ] Mes de sunset

---

## Anti-Patterns

### ❌ Cambiar v1 sin warning

```java
// MAL: Breaking change sin aviso
// v1 Response: { data: { id, name } }
// Ahora: { id, name }  ← Clientes rompen sin warning
```

### ✅ Agregar deprecation headers + anuncio

```java
if (request.getRequestURI().contains("/api/v1/")) {
  response.setHeader("Deprecation", "true");
  response.setHeader("Sunset", "Sun, 10 Oct 2026 00:00:00 GMT");
}
```

---

### ❌ Mantener versiones antiguas indefinidamente

```
// MAL: v1, v2, v3, v4 todas en producción
→ Pesadilla de mantenimiento, seguridad
```

### ✅ Sunset policy clara

```
v1: Sunset en octubre 2026 (removal)
v2: Sunset en octubre 2027 (removal)
v3: Current, sin sunset aún
```

---

## References

| Recurso | Link |
|---------|------|
| **RFC 8574** (Deprecation) | https://tools.ietf.org/html/rfc8574 |
| **RFC 7231** (HTTP Semantics) | https://tools.ietf.org/html/rfc7231 |
| **REST API Versioning** | https://restfulapi.net/versioning/ |
| **Spring Boot Docs** | https://spring.io/projects/spring-boot |
| **OpenAPI Docs** | `/v3/api-docs` (ambas versiones) |

---

[← Índice](./README.md) | [< Anterior](./authorization-patterns.md) | [Siguiente >](./database-schema.md)
