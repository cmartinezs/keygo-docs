[← Índice](./README.md) | [< Anterior](./oauth2-oidc-contract.md) | [Siguiente >](./api-versioning-strategy.md)

---

# Authorization Patterns

Patrones de autorización, control de acceso y evaluación de permisos en KeyGo, incluyendo RBAC multi-nivel, JWT claims y validación de tenant scope.

## Contenido

- [Principio Fundamental](#principio-fundamental)
- [JWT Claims Structure](#jwt-claims-structure)
- [Tres Niveles de RBAC](#tres-niveles-de-rbac)
- [Patrones @PreAuthorize](#patrones-preauthorize)
- [Validación de Tenant Scope](#validación-de-tenant-scope)
- [Matriz de Roles](#matriz-de-roles)
- [Anti-Patterns](#anti-patterns)

---

## Principio Fundamental

**Decisión arquitectónica (RFC: Restructure Multi-Tenant §06):**

> **Identidad es global, pertenencia es por tenant, acceso es por app.**

**En términos de autorización:**
- **Quién eres:** JWT contiene `sub` (user UUID global, inmutable)
- **A cuál tenant accedes:** JWT contiene `tenant_slug` (scope de sesión)
- **Qué roles tienes:** JWT contiene `roles` (roles dentro de ese tenant/app)

**Implicación:** Un usuario puede tener:
- Email global único (una sola identidad)
- Diferentes roles en cada tenant (ADMIN en tenant A, USER en tenant B)
- Diferentes roles en cada app dentro de un tenant (EDITOR en app1, VIEWER en app2)

[↑ Volver al inicio](#authorization-patterns)

---

## JWT Claims Structure

### Estructura Canónica

```json
{
  "sub": "a1b2c3d4-e5f6-7890-abcd-ef1234567890",
  "email": "user@example.com",
  "tenant_slug": "my-company",
  "tenant_id": "t-uuid",
  "roles": ["ADMIN_ORG", "USER"],
  "aud": "keygo-console",
  "iss": "https://keygo.local/api/v1/tenants/my-company",
  "exp": 1680000000,
  "iat": 1679996400,
  "jti": "token-jti-uuid"
}
```

### Descripción de Claims

| Claim | Tipo | Obligatorio | Descripción |
|-------|------|-----------|---|
| `sub` | UUID | ✅ | Identidad global del usuario (subject) |
| `email` | string | ✅ | Email verificado del usuario |
| `tenant_slug` | string | ⚠️ | Slug del tenant (null si platform-level) |
| `tenant_id` | UUID | ⚠️ | ID del tenant (null si platform-level) |
| `roles` | array | ✅ | Roles asignados en este tenant/app |
| `aud` | string | ✅ | Audiencia: `keygo-platform`, `keygo-console`, o app-específica |
| `iss` | string | ✅ | Emisor (contiene nivel: platform vs tenant) |
| `exp` | unix | ✅ | Expiración (epoch seconds) |
| `iat` | unix | ✅ | Emitido en (epoch seconds) |
| `jti` | UUID | ✅ | JWT ID único (para revocación individual) |

### Decodificación en Shell

```bash
# 1. Decodificar JWT (sin verificar firma)
echo $token | jq -R 'split(".") | .[1] | @base64d | fromjson'

# 2. Extraer tenant_slug
echo $token | jq -R 'split(".") | .[1] | @base64d | fromjson | .tenant_slug'

# 3. Extraer roles
echo $token | jq -R 'split(".") | .[1] | @base64d | fromjson | .roles'

# 4. Extraer exp y verificar expiración
echo $token | jq -R 'split(".") | .[1] | @base64d | fromjson | .exp' \
  | xargs -I {} date -d @{} -u
```

[↑ Volver al inicio](#authorization-patterns)

---

## Tres Niveles de RBAC

### Nivel 1: Platform Roles (Global)

**Contexto:** Administración de plataforma, acceso sin restricción de tenant.

**Roles bien-conocidos:**
- `keygo_admin` — Administrador global (acceso a todos los tenants, estadísticas globales)
- `keygo_account_admin` — Admin de cuenta de plataforma (gestión de usuarios de plataforma)
- `keygo_user` — Usuario regular de plataforma (acceso limitado a propias configuraciones)

**Token (Platform-Level):**
```json
{
  "sub": "platform-admin-uuid",
  "email": "admin@keygo.local",
  "roles": ["keygo_admin"],
  "aud": "keygo-platform",
  "iss": "https://keygo.local/api/v1/platform",
  "exp": 1680000000
}
```

**Nota:** Sin `tenant_slug` (null) = acceso a todo

**Endpoints:**
```java
@PreAuthorize("hasRole('keygo_admin')")
@GetMapping("/api/v1/platform/dashboard")
public ResponseEntity<BaseResponse<DashboardData>> getPlatformDashboard() {
  // Acceso a dashboard global, estadísticas de todos los tenants, etc.
  return ResponseEntity.ok(...);
}
```

### Nivel 2: Tenant Roles (Organizacional)

**Contexto:** Roles definidos por el tenant, aplicados dentro de un tenant específico.

**Características:**
- Cada tenant puede definir sus propios roles (ej: `DEVELOPER`, `MANAGER`, `VIEWER`)
- Nombres de rol: uppercase, único dentro del tenant
- Asignables a usuarios de ese tenant
- Opcionalmente: jerarquía de roles (rol padre)

**Token (Tenant-Level):**
```json
{
  "sub": "user-uuid",
  "email": "user@example.com",
  "tenant_slug": "my-company",
  "tenant_id": "t-uuid",
  "roles": ["ADMIN_ORG", "USER"],
  "aud": "keygo-console",
  "iss": "https://keygo.local/api/v1/tenants/my-company",
  "exp": 1680000000
}
```

**Validación:** Además de rol, verificar que `tenant_slug` en JWT = `tenant_slug` en URL

**Endpoints:**
```java
@RestController
@RequestMapping("/api/v1/tenants/{tenantSlug}/users")
public class TenantUserController {

  @PreAuthorize("hasAnyRole('ADMIN_ORG', 'keygo_admin') and " +
      "@tenantAuthorizationEvaluator.hasTenantAccess(authentication, #tenantSlug)")
  @GetMapping
  public ResponseEntity<BaseResponse<PagedData<UserData>>> listUsers(
      @PathVariable String tenantSlug) {
    // Acceso limitado a usuarios de ese tenant
    return ResponseEntity.ok(...);
  }
}
```

**Validación en TenantAuthorizationEvaluator:**
```java
public boolean hasTenantAccess(Authentication auth, String requestedTenant) {
  // Paso 1: ¿keygo_admin? → acceso a cualquier tenant
  if (hasRole(auth, "keygo_admin")) {
    return true;  // Platform admin accede a cualquier tenant
  }
  
  // Paso 2: Extraer tenant del token
  String tokenTenant = extractTenantSlug(auth);
  
  // Paso 3: ¿Coinciden?
  if (!requestedTenant.equals(tokenTenant)) {
    return false;  // Cross-tenant access denied
  }
  
  // Paso 4: ¿Usuario tiene rol suficiente en este tenant?
  return hasRole(auth, "ADMIN_ORG") || hasRole(auth, "MANAGER");
}
```

### Nivel 3: App Roles (Funcional)

**Contexto:** Roles definidos por cada aplicación cliente, dentro de un tenant.

**Características:**
- Cada app cliente define sus propios roles (ej: `EDITOR`, `VIEWER`, `ADMIN_APP`)
- Independientes de roles platform/tenant
- Usuario puede tener diferentes roles en diferentes apps
- Validación realizada por la app cliente (no por KeyGo)

**Token (App-Level, emitido para aplicación específica):**
```json
{
  "sub": "user-uuid",
  "email": "user@example.com",
  "tenant_slug": "my-company",
  "tenant_id": "t-uuid",
  "app_id": "myapp-uuid",
  "roles": ["EDITOR", "ADMIN_APP"],
  "aud": "myapp",
  "iss": "https://keygo.local/api/v1/tenants/my-company",
  "exp": 1680000000
}
```

**Validación en App Cliente (no en KeyGo):**
```java
// En backend de myapp (cliente OAuth2 de KeyGo)
@PreAuthorize("hasRole('EDITOR')")
@GetMapping("/documents")
public ResponseEntity<PagedData<DocumentData>> listDocuments() {
  // Solo usuarios con rol EDITOR en myapp
  return ResponseEntity.ok(...);
}
```

[↑ Volver al inicio](#authorization-patterns)

---

## Patrones @PreAuthorize

### Patrón A: Platform Admin (Acceso Global)

```java
@RestController
@RequestMapping("/api/v1/platform")
public class PlatformAdminController {

  @PreAuthorize("hasRole('keygo_admin')")
  @GetMapping("/dashboard")
  public ResponseEntity<BaseResponse<PlatformDashboardData>> getDashboard() {
    // Solo keygo_admin puede acceder
    // Sin restricción de tenant
  }

  @PreAuthorize("hasRole('keygo_admin')")
  @GetMapping("/tenants")
  public ResponseEntity<BaseResponse<PagedData<TenantData>>> listAllTenants() {
    // Listar todos los tenants de la plataforma
  }
}
```

### Patrón B: Tenant Admin (Tenant-Scoped)

```java
@RestController
@RequestMapping("/api/v1/tenants/{tenantSlug}/users")
public class TenantUserController {

  // Requiere: (ADMIN_ORG rol en ese tenant) O (keygo_admin global)
  @PreAuthorize("@tenantAuthorizationEvaluator.hasTenantAccess(authentication, #tenantSlug)")
  @PostMapping
  public ResponseEntity<BaseResponse<UserData>> createUser(
      @PathVariable String tenantSlug,
      @Valid @RequestBody CreateUserRequest request) {
    // Crear usuario en tenant específico
    // Validación: JWT tenant_slug == URL tenant_slug O keygo_admin
  }

  @PreAuthorize("@tenantAuthorizationEvaluator.hasTenantAccess(authentication, #tenantSlug)")
  @GetMapping
  public ResponseEntity<BaseResponse<PagedData<UserData>>> listUsers(
      @PathVariable String tenantSlug) {
    // Listar usuarios de ese tenant
  }
}
```

### Patrón C: Tenant + Specific Role

```java
@RestController
@RequestMapping("/api/v1/tenants/{tenantSlug}/roles")
public class TenantRoleController {

  // Requiere: ADMIN_ORG en ese tenant (no suficiente USER)
  @PreAuthorize(
    "@tenantAuthorizationEvaluator.hasTenantAccess(authentication, #tenantSlug) and " +
    "hasAnyRole('ADMIN_ORG', 'keygo_admin')"
  )
  @PostMapping
  public ResponseEntity<BaseResponse<RoleData>> createRole(
      @PathVariable String tenantSlug,
      @Valid @RequestBody CreateRoleRequest request) {
    // Solo admins pueden crear roles
  }
}
```

### Patrón D: Hierarchical Role Evaluation

```java
@RestController
@RequestMapping("/api/v1/tenants/{tenantSlug}/contracts")
public class TenantContractController {

  // Requiere: ADMIN_ORG, MANAGER, o keygo_admin
  @PreAuthorize(
    "@tenantAuthorizationEvaluator.hasTenantAccess(authentication, #tenantSlug) and " +
    "hasAnyRole('ADMIN_ORG', 'MANAGER', 'keygo_admin')"
  )
  @GetMapping
  public ResponseEntity<BaseResponse<PagedData<ContractData>>> listContracts(
      @PathVariable String tenantSlug) {
    // Hierarchía: ADMIN_ORG > MANAGER > USER
    // Cualquiera con MANAGER+ puede ver contratos
  }
}
```

[↑ Volver al inicio](#authorization-patterns)

---

## Validación de Tenant Scope

### TenantAuthorizationEvaluator Service

```java
@Component
public class TenantAuthorizationEvaluator {

  /**
   * Valida que el usuario tiene acceso al tenant solicitado.
   * 
   * Retorna true si:
   * 1. Usuario es keygo_admin (acceso global), O
   * 2. JWT tenant_slug coincide con tenant solicitado Y usuario tiene rol suficiente
   */
  public boolean hasTenantAccess(
      Authentication authentication,
      String requestedTenantSlug) {
    
    // Paso 1: ¿keygo_admin?
    if (hasRole(authentication, "keygo_admin")) {
      return true;  // Acceso a cualquier tenant
    }
    
    // Paso 2: Extraer tenant del JWT
    String tokenTenantSlug = extractTenantSlugFromJwt(authentication);
    if (tokenTenantSlug == null) {
      return false;  // Token sin tenant (platform-level) no puede acceder
    }
    
    // Paso 3: ¿Coinciden?
    return requestedTenantSlug.equals(tokenTenantSlug);
  }

  private String extractTenantSlugFromJwt(Authentication authentication) {
    JwtAuthenticationToken token = (JwtAuthenticationToken) authentication;
    Jwt jwt = token.getToken();
    return jwt.getClaimAsString("tenant_slug");
  }

  private boolean hasRole(Authentication authentication, String role) {
    return authentication.getAuthorities().stream()
        .anyMatch(a -> a.getAuthority().equals("ROLE_" + role));
  }
}
```

### AOP Aspect para Validación Automática (Opcional)

```java
@Aspect
@Component
public class TenantScopeValidationAspect {

  @Pointcut("@annotation(tenantScoped)")
  public void tenantScopedMethods(TenantScoped tenantScoped) {}

  @Before("tenantScopedMethods(tenantScoped)")
  public void validateTenantScope(
      JoinPoint jp,
      TenantScoped tenantScoped) throws Throwable {
    
    // Extraer tenantSlug del argumento o request
    String tenantSlug = extractTenantSlug(jp);
    
    // Validar
    SecurityContext context = SecurityContextHolder.getContext();
    if (!tenantAuthorizationEvaluator.hasTenantAccess(
        context.getAuthentication(), tenantSlug)) {
      throw new AccessDeniedException("Cross-tenant access denied");
    }
  }
}

@Target(METHOD)
@Retention(RUNTIME)
public @interface TenantScoped {
  String value() default "";
}
```

**Uso:**
```java
@TenantScoped("tenantSlug")
@GetMapping("/api/v1/tenants/{tenantSlug}/users")
public ResponseEntity<?> listUsers(@PathVariable String tenantSlug) { ... }
```

[↑ Volver al inicio](#authorization-patterns)

---

## Matriz de Roles

### Platform Level

| Rol | Permisos | Acceso |
|-----|----------|--------|
| `keygo_admin` | Gestión global de tenants, usuarios, estadísticas | Todos los endpoints `/api/v1/platform/*` |
| `keygo_account_admin` | Gestión de usuarios de plataforma, audit logs | `/api/v1/platform/users`, `/api/v1/platform/audit` |
| `keygo_user` | Acceso a propias configuraciones | `/api/v1/account/*` |

### Tenant Level

| Rol | Permisos | Típicamente |
|-----|----------|---|
| `ADMIN_ORG` | Gestión completa del tenant: usuarios, apps, roles, contratos | Admin del tenant |
| `MANAGER` | Gestión de usuarios, viewing de contratos | Gerente de proyecto |
| `USER` | Gestión de propias configuraciones, acceso limitado | Miembro regular |
| `VIEWER` | Solo lectura de recursos | Auditor, cliente |

### App Level (Ejemplos)

| App | Roles | Significado |
|-----|-------|---|
| **myapp** | `EDITOR`, `VIEWER`, `ADMIN_APP` | Editor = puede modificar; Viewer = solo leer |
| **dashboard** | `ANALYST`, `EXECUTIVE`, `ADMIN_DASH` | Analyst = análisis básico; Executive = reportes altos |
| **billing** | `ACCOUNTANT`, `FINANCE_MANAGER` | Accountant = ver facturas; Manager = generar, aprobar |

[↑ Volver al inicio](#authorization-patterns)

---

## Anti-Patterns

### ❌ No validar tenant scope en endpoints

```java
// MAL: Sin validación de tenant_slug
@GetMapping("/api/v1/tenants/{tenantSlug}/users")
public ResponseEntity<?> listUsers(@PathVariable String tenantSlug) {
  // Usuario del tenant A puede acceder a usuarios del tenant B
  return userService.findByTenant(tenantSlug);  // BREACH!
}
```

### ✅ Siempre validar tenant scope

```java
// BIEN: Con validación
@GetMapping("/api/v1/tenants/{tenantSlug}/users")
@PreAuthorize("@tenantAuthorizationEvaluator.hasTenantAccess(authentication, #tenantSlug)")
public ResponseEntity<?> listUsers(@PathVariable String tenantSlug) {
  return userService.findByTenant(tenantSlug);  // SAFE
}
```

---

### ❌ Confiar en roles sin validar tenant

```java
// MAL: Rol sin tenant
if (hasRole(authentication, "ADMIN_ORG")) {
  // ¿ADMIN_ORG de cuál tenant? Asumido implícitamente
  return userService.deleteUser(userId);  // Podría ser otro tenant!
}
```

### ✅ Validar tanto rol como tenant

```java
// BIEN: Rol + tenant
@PreAuthorize(
  "hasRole('ADMIN_ORG') and " +
  "@tenantAuthorizationEvaluator.hasTenantAccess(authentication, #tenantSlug)"
)
public ResponseEntity<?> deleteUser(
    @PathVariable String tenantSlug,
    @PathVariable String userId) {
  return userService.deleteUser(userId, tenantSlug);  // SAFE
}
```

---

### ❌ Pasar tenant_id sin validar en token

```java
// MAL: Cliente puede cambiar tenant_id en JWT
@PostMapping("/api/v1/users")
public ResponseEntity<?> updateProfile(
    @RequestBody UpdateProfileRequest request) {
  // request.tenantId viene del cliente (MUTABLE)
  userService.update(request.tenantId, request);  // BREACH!
}
```

### ✅ Extraer tenant del token, no del request

```java
// BIEN: Tenant del JWT
@PostMapping("/api/v1/account/profile")
public ResponseEntity<?> updateProfile(
    Authentication authentication,
    @RequestBody UpdateProfileRequest request) {
  
  String tenantSlug = extractTenantSlug(authentication);  // Immutable
  String userId = extractUserId(authentication);           // Immutable
  
  userService.update(userId, tenantSlug, request);  // SAFE
}
```

[↑ Volver al inicio](#authorization-patterns)

---

## References

- **Spring Security @PreAuthorize:** [Spring Docs](https://spring.io/projects/spring-security)
- **JWT RFC 7519:** [JWT Specification](https://tools.ietf.org/html/rfc7519)
- **Multi-Tenancy Patterns:** See `architecture.md` § Multi-Tenancy
- **OAuth2/OIDC Flows:** See `oauth2-oidc-contract.md`

---

[← Índice](./README.md) | [< Anterior](./oauth2-oidc-contract.md) | [Siguiente >](./api-versioning-strategy.md)
