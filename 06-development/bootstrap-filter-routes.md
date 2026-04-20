# Backend: Bootstrap Filter y Rutas Públicas

**Fase:** 06-development | **Audiencia:** Equipo backend, especialistas en seguridad | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Introducción](#introducción)
2. [Concepto y Propósito](#concepto-y-propósito)
3. [Configuración Base](#configuración-base)
4. [Rutas Públicas por Prefijo](#rutas-públicas-por-prefijo)
5. [Rutas Públicas por Sufijo](#rutas-públicas-por-sufijo)
6. [Matriz de Decisión](#matriz-de-decisión)
7. [Lógica de Implementación](#lógica-de-implementación)
8. [Testing y Verificación](#testing-y-verificación)
9. [Troubleshooting](#troubleshooting)

---

## Introducción

El **Bootstrap Filter** es un filtro Spring Security que determina qué rutas son públicas (sin requerir JWT) y cuáles son protegidas (requieren Bearer token válido). Es la primera línea de defensa antes de que las anotaciones `@PreAuthorize` hagan autorización granular.

**Principios:**

- **Explícito sobre implícito:** Todas las rutas públicas están configuradas; nada es "accidentalmente público"
- **Flexible:** Usa prefijos y sufijos para minimizar configuración repetida
- **Agnóstico de tenant:** El filtro permite tanto `/api/v1/platform/...` como `/api/v1/tenants/{slug}/...`
- **Separación:** Autenticación aquí (¿tiene token?); autorización en `@PreAuthorize` (¿tiene permisos?)

**Bounded Contexts:**

- **Identity Context:** OAuth2 endpoints (`/oauth2/authorize`, `/oauth2/token`), recuperación de sesión (`/account/profile`)
- **Access Control Context:** Validación de permisos en `@PreAuthorize`; el filtro solo permite que la request llegue
- **Organization Context:** Tenant-scoped endpoints con `/tenants/{slug}/...`

---

## Concepto y Propósito

### ¿Por Qué Existe el Bootstrap Filter?

Sin él, cada endpoint estaría protegido por defecto. Pero ciertos endpoints deben ser públicos para que la autenticación pueda ocurrir:

- `/oauth2/authorize`: Usuario no autenticado aún; debe ser público
- `/oauth2/token`: App de tercero intercambia código por token; puede tener credenciales pero no JWT
- `/account/forgot-password`: Usuario olvidó contraseña; no tiene token válido
- `/.well-known/openid-configuration`: Frontend descubre endpoints OIDC; debe ser público

El filtro separa estas excepciones de la regla general: **"Todo está protegido excepto..."**

### Flujo Conceptual

```
Request llega
     ↓
¿Path coincide con ruta pública (prefijo o sufijo)?
     ├─ SÍ → Permite sin JWT (Bootstrap Filter retorna)
     ├─ NO → Requiere Bearer token válido
     │       └─ ¿Token existe y es válido?
     │          ├─ SÍ → Autentica; continúa a @PreAuthorize
     │          └─ NO → 401 Unauthorized
     ↓
@PreAuthorize evalúa roles/permisos (Authorization)
     ├─ SÍ → Endpoint se ejecuta
     └─ NO → 403 Forbidden
```

---

## Configuración Base

### application.yml

```yaml
keygo:
  bootstrap:
    enabled: true                                   # Activar/desactivar el filtro
    api-path-prefix: "/api/"                       # Prefijo base de todas las APIs
    bypass-roles: ${KEYGO_BOOTSTRAP_BYPASS_ROLES:ADMIN,KEYGO_ADMIN,KEYGO_USER}
```

### Environment Variables (Overrides)

```bash
# Desactivar completamente
export KEYGO_BOOTSTRAP_ENABLED=false

# Ajustar roles reconocidos
export KEYGO_BOOTSTRAP_BYPASS_ROLES=ADMIN,ADMIN_TENANT,KEYGO_ADMIN,KEYGO_TENANT_ADMIN
```

### Spring Security Configuration (Conceptual)

```java
// BootstrapSecurityFilter.java (pseudocódigo)
@Component
public class BootstrapSecurityFilter extends OncePerRequestFilter {
  
  @Override
  protected void doFilterInternal(HttpServletRequest request, 
                                  HttpServletResponse response,
                                  FilterChain filterChain) throws IOException, ServletException {
    
    String path = request.getServletPath();  // e.g. "/api/v1/platform/oauth2/token"
    
    // Verificar si es ruta pública (prefijo o sufijo)
    if (isPublicRoute(path)) {
      // Sin Bearer token: permitir
      filterChain.doFilter(request, response);
      return;
    }
    
    // Si no es pública: requerir Bearer token
    String auth = request.getHeader("Authorization");
    if (auth == null || !auth.startsWith("Bearer ")) {
      response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
      return;
    }
    
    // Validar token (JWKS, expiration, etc.)
    // ... (delegado a JWT filter)
    
    filterChain.doFilter(request, response);
  }
  
  private boolean isPublicRoute(String path) {
    // Lógica de prefijos y sufijos (ver secciones siguientes)
    return matchesPrefixRule(path) || matchesSuffixRule(path);
  }
}
```

---

## Rutas Públicas por Prefijo

Estas rutas son públicas porque su **comienzo** coincide con un prefijo configurado.

### Tabla de Referencia

| Propiedad Config | Prefijo | Uso | Contexto |
|------------------|---------|-----|----------|
| `actuator-path-prefix` | `/actuator/` | Health checks, métricas | Operaciones |
| `swagger-ui-path-prefix` | `/swagger-ui` | Documentación interactiva | Desarrollo |
| `api-docs-path-prefix` | `/v3/api-docs` | OpenAPI JSON | Desarrollo |
| `well-known-path-prefix` | `/.well-known` | OIDC discovery, JWKS | Identity Context |
| `platform-login-path-prefix` | `/api/v1/platform/account/login` | Login directo (username/password) | Identity Context |
| `platform-token-path-prefix` | `/api/v1/platform/oauth2/token` | Code exchange, refresh token | Identity Context |
| `platform-revoke-path-prefix` | `/api/v1/platform/oauth2/revoke` | Revoke token (RFC 7009) | Identity Context |
| `platform-authorize-path-prefix` | `/api/v1/platform/oauth2/authorize` | Inicio OAuth2 flow | Identity Context |
| `platform-direct-login-path-prefix` | `/api/v1/platform/account/direct-login` | API/CLI login (no OAuth2) | Identity Context |
| `platform-forgot-password-path-prefix` | `/api/v1/platform/account/forgot-password` | Self-service password reset | Identity Context |
| `platform-check-email-path-prefix` | `/api/v1/platform/account/check-email` | Pre-check email antes de signup | Identity Context |
| `platform-recover-password-path-prefix` | `/api/v1/platform/account/recover-password` | Recover password flow | Identity Context |
| `platform-reset-password-path-prefix` | `/api/v1/platform/account/reset-password` | Reset password con token | Identity Context |
| `service-info-path-prefix` | `/service/info` | Service metadata, versioning | Operaciones |

### Ejemplos de Matching

```
Configuración: platform-token-path-prefix = "/api/v1/platform/oauth2/token"

Request: POST /api/v1/platform/oauth2/token
Result: ✅ MATCH → público

Request: POST /api/v1/platform/oauth2/token/revoke
Result: ❌ NO MATCH → requiere Bearer

Request: POST /api/v1/tenants/my-tenant/oauth2/token
Result: ❌ NO MATCH → requiere Bearer
         (tenant-scoped tokens usan sufijo /oauth2/token, no prefijo)
```

### Notas de Implementación

- Usa `request.getServletPath()`, **no** `getRequestURI()` (evita query params)
- Matching es **con prefijo exacto**, no substring
- Order: Prefijos se evalúan primero (más específico)

---

## Rutas Públicas por Sufijo

Estas rutas son públicas porque su **final** coincide con un sufijo configurado. Útil para patrones como `/api/v1/tenants/{slug}/oauth2/token` (tenant-scoped).

### Tabla de Referencia

| Propiedad Config | Sufijo | Uso | Contexto |
|------------------|--------|-----|----------|
| `userinfo-path-suffix` | `/userinfo` | OIDC userinfo endpoint | Identity Context |
| `revocation-path-suffix` | `/oauth2/revoke` | RFC 7009 token revocation | Identity Context |
| `register-path-suffix` | `/register` | Self-registration | Identity Context |
| `verify-email-path-suffix` | `/verify-email` | Email verification | Identity Context |
| `resend-verification-path-suffix` | `/resend-verification` | Resend verification code | Identity Context |
| `account-profile-path-suffix` | `/account/profile` | Self-service profile (GET/PATCH) | Identity Context |
| `account-change-password-path-suffix` | `/account/change-password` | Change own password | Identity Context |
| `account-sessions-path-suffix` | `/account/sessions` | List own sessions | Identity Context |
| `account-notification-preferences-path-suffix` | `/account/notification-preferences` | Notification prefs | Identity Context |
| `account-access-path-suffix` | `/account/access` | API access token generation | Identity Context |
| `account-reset-password-path-suffix` | `/account/reset-password` | Reset password con token | Identity Context |
| `account-forgot-password-path-suffix` | `/account/forgot-password` | Forgot password | Identity Context |
| `account-recover-password-path-suffix` | `/account/recover-password` | Recover password | Identity Context |
| `authorize-path-suffix` | `/oauth2/authorize` | OAuth2 authorize (any scope) | Identity Context |
| `login-path-suffix` | `/account/login` | Login (any scope) | Identity Context |
| `token-path-suffix` | `/oauth2/token` | Token endpoint (any scope) | Identity Context |
| `billing-catalog-path-suffix` | `/billing/catalog` | Public pricing catalog | Organization Context |
| `billing-contracts-path-suffix` | `/billing/contracts` | Onboarding contract signing | Organization Context |

### Ejemplos de Matching

```
Configuración: token-path-suffix = "/oauth2/token"

Request: POST /api/v1/platform/oauth2/token
Result: ✅ MATCH → público

Request: POST /api/v1/tenants/my-tenant/oauth2/token
Result: ✅ MATCH → público (sufijo coincide)

Request: POST /api/v1/tenants/my-tenant/oauth2/token?client_id=...
Result: ✅ MATCH → público (query params ignorados)

Request: GET /api/v1/platform/oauth2/token-info
Result: ❌ NO MATCH (sufijo es /token, no /token-info)
```

### ¿Cuándo Usar Sufijo vs Prefijo?

| Situación | Patrón | Tipo |
|-----------|--------|------|
| Endpoint solo en `/platform/...` | `/api/v1/platform/SPECIFIC` | Prefijo |
| Endpoint en `/platform/...` **y** `/tenants/{slug}/...` | `.../SPECIFIC` | Sufijo |
| Multi-tenant, mismo endpoint path | Idéntico en ambos contextos | Sufijo |

---

## Matriz de Decisión

### Cómo Decidir si una Ruta Debe Ser Pública

| Pregunta | Respuesta | Conclusión |
|----------|-----------|-----------|
| ¿Necesita que el usuario esté autenticado? | Sí | Protegida (requiere Bearer) |
| ¿Es parte de la autenticación misma? | Sí | Pública (login, token, oauth2/authorize) |
| ¿Es información de descubrimiento (OIDC/.well-known)? | Sí | Pública |
| ¿Es self-service sin login (forgot-password)? | Sí | Pública |
| ¿Es catálogo sin sesión (billing/catalog)? | Sí | Pública |
| ¿Es endpoint administrativo? | Sí | Protegida (requiere Bearer + @PreAuthorize) |

**Regla de oro:** Si el endpoint es parte del **flujo de autenticación** o **información pública**, es candidato a ser público. Si requiere una **decisión de negocio validada en backend**, es protegido.

---

## Lógica de Implementación

### Pseudocódigo: Lógica de Matching

```java
public class BootstrapFilterConfig {
  
  private Map<String, String> prefixRules;  // property → actual prefix
  private Map<String, String> suffixRules;  // property → actual suffix
  
  public boolean isPublicRoute(String path) {
    // 1. Verificar prefijos (más específico)
    for (String prefix : prefixRules.values()) {
      if (path.startsWith(prefix)) {
        return true;
      }
    }
    
    // 2. Verificar sufijos
    for (String suffix : suffixRules.values()) {
      if (path.endsWith(suffix)) {
        return true;
      }
    }
    
    return false;
  }
  
  // Helper: lógica por segmento para rutas complejas
  public boolean matchesTenantScoped(String path, String suffixPattern) {
    // /api/v1/tenants/{slug}/oauth2/token
    // suffixPattern: /oauth2/token
    String pattern = "/api/v1/tenants/[^/]+(" + suffixPattern + ")$";
    return path.matches(pattern);
  }
}
```

### Integración con Spring Security

```java
@Configuration
public class SecurityConfig {
  
  @Bean
  public SecurityFilterChain filterChain(HttpSecurity http, 
                                         BootstrapFilterConfig config) throws Exception {
    http
      .authorizeHttpRequests(authz -> authz
        .requestMatchers(new PublicRoutesMatcher(config)).permitAll()
        .anyRequest().authenticated()
      )
      .addFilterBefore(new BootstrapSecurityFilter(config), UsernamePasswordAuthenticationFilter.class)
      .build();
    
    return http.build();
  }
}
```

### Anti-Patterns

❌ **Hardcodear rutas en Spring Security**
```java
// MAL
.requestMatchers("/api/v1/platform/oauth2/token").permitAll()
.requestMatchers("/api/v1/tenants/*/oauth2/token").permitAll()
// Repetitivo, difícil de mantener
```

✅ **Usar configuración centralizada**
```java
// BIEN
.requestMatchers(new PublicRoutesMatcher(bootstrapConfig)).permitAll()
// Una fuente de verdad: application.yml
```

---

## Testing y Verificación

### Scripts de Verificación

```bash
# Test: Health endpoint (público)
curl -i http://localhost:8080/actuator/health

# Test: Discover OIDC (público)
curl -i http://localhost:8080/.well-known/openid-configuration

# Test: Login (público)
curl -i -X POST http://localhost:8080/api/v1/platform/account/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"xxx"}'

# Test: Get users sin token (protegido, debe fallar 401)
curl -i http://localhost:8080/api/v1/platform/users

# Test: Get users con token válido (debe fallar 403 si sin permisos, o 200 si ok)
TOKEN="eyJhbGciOiJSUzI1NiJ9..."
curl -i -H "Authorization: Bearer $TOKEN" \
  http://localhost:8080/api/v1/platform/users
```

### Casos de Test Automáticos

```java
@SpringBootTest(webEnvironment = WebEnvironment.RANDOM_PORT)
class BootstrapFilterSecurityTest {
  
  @Test
  void publicRoute_actorHealth_isAccessible() {
    client.get("/actuator/health")
      .expectStatus().isOk();
  }
  
  @Test
  void publicRoute_oauth2Token_isAccessible() {
    client.post("/api/v1/platform/oauth2/token")
      .withBody(tokenRequest)
      .expectStatus().isBadRequest();  // May fail on validation, pero sin 401
  }
  
  @Test
  void protectedRoute_withoutToken_returns401() {
    client.get("/api/v1/platform/users")
      .expectStatus().isUnauthorized();
  }
  
  @Test
  void protectedRoute_withValidToken_returnsContent() {
    String token = issueValidToken();
    
    client.get("/api/v1/platform/users")
      .withHeader("Authorization", "Bearer " + token)
      .expectStatus().isOk();  // Or 403 if no permissions
  }
  
  @Test
  void tenantScopedPublicRoute_isAccessible() {
    // /api/v1/tenants/my-org/oauth2/token debe ser público (sufijo)
    client.post("/api/v1/tenants/my-org/oauth2/token")
      .withBody(tokenRequest)
      .expectStatus().isBadRequest();  // Validation error, not 401
  }
}
```

---

## Troubleshooting

### Problema: Ruta que debería ser pública devuelve 401

**Síntomas:**
- `/api/v1/platform/oauth2/token` → 401 Unauthorized sin Bearer
- `/api/v1/tenants/acme/oauth2/token` → 401 Unauthorized sin Bearer

**Causa probable:**
- Ruta no configurada en prefijos/sufijos
- O configuración no cargada (env var no seteada)

**Solución:**
```bash
# Verificar que la ruta está configurada
grep "oauth2-token-path" application.yml

# Verificar env vars
echo $KEYGO_BOOTSTRAP_ENABLED
echo $KEYGO_BOOTSTRAP_PATH_RULES

# Logs: buscar rutas pública loading
grep "Loading public routes" logs/*.log
```

### Problema: Ruta protegida es accesible sin token

**Síntomas:**
- `GET /api/v1/platform/users` → 200 OK sin Bearer
- Debería ser 401 Unauthorized

**Causa probable:**
- Filtro deshabilitado accidentalmente
- Ruta matcheó un sufijo incorrecto

**Solución:**
```bash
# Verificar filtro habilitado
grep "bootstrap.enabled" application.yml  # Must be true

# Revisar reglas de sufijo
grep "path-suffix" application.yml | head -20
# Asegúrate que /users no esté en ningún sufijo público

# Habilitar DEBUG logging
export LOGGING_LEVEL_COM_KEYGO=DEBUG
```

### Problema: Tenant-scoped endpoint no es público

**Síntomas:**
- `POST /api/v1/tenants/my-org/oauth2/token` → 401 Unauthorized
- Platform-scoped `/api/v1/platform/oauth2/token` → 200 OK

**Causa probable:**
- Configurada como prefijo (solo `/api/v1/platform/...`) en lugar de sufijo (ambos contextos)

**Solución:**
```yaml
# MAL (solo platform-scoped)
keygo:
  bootstrap:
    platform-token-path-prefix: "/api/v1/platform/oauth2/token"

# BIEN (ambos contextos, usa sufijo)
keygo:
  bootstrap:
    token-path-suffix: "/oauth2/token"
```

### Problema: Todos los endpoints devuelven 401

**Síntomas:**
- Incluso `GET /actuator/health` → 401 Unauthorized

**Causa probable:**
- Filtro configurado pero JWKS no carga
- JWT validation falla antes de llegar a rutas públicas

**Solución:**
```bash
# Verificar JWKS endpoint
curl -i http://localhost:8080/.well-known/openid-configuration
# Debe devolver 200 con issuer + jwks_uri

# Verificar JWKS cargable
JWKS_URI=$(curl -s http://localhost:8080/.well-known/openid-configuration | jq -r '.jwks_uri')
curl -i $JWKS_URI  # Must be 200

# Logs: buscar JWT errors
grep "JwtException\|JWKS" logs/*.log
```

---

## Véase También

- **architecture.md** — Mapeo de bounded contexts a módulos; filtro es parte de "Security Layer"
- **oauth2-oidc-contract.md** — Detalle del OAuth2 flow; endpoints públicos aquí son punto de entrada
- **authorization-patterns.md** — Después del bootstrap filter, `@PreAuthorize` hace autorización granular
- **api-endpoints-comprehensive.md** — Documentación de cada endpoint (public vs protected)

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Equipo Backend | **Licencia:** Keygo Docs
