[← Índice](./README.md) | [← Volver a macro-plan](../macro-plan.md)

---

# Technical & Functional Constraints: Restricciones No-Negociables

Documento de referencia para **arquitectos**, **desarrolladores** y **product managers** que especifica restricciones técnicas y funcionales que son **inmutables** por decisión estratégica.

**Fecha de vigencia**: 2026-04-20  
**Última revisión**: 2026-04-20

---

## Contenido

- [Technical Constraints (T1-T6)](#technical-constraints-t1-t6)
- [Functional Constraints (F1-F3)](#functional-constraints-f1-f3)
- [Regulatory/Compliance Constraints](#regulatoryompliance-constraints)
- [Impact & Decision Matrix](#impact--decision-matrix)
- [How to Challenge a Constraint](#how-to-challenge-a-constraint)

---

## Technical Constraints (T1-T6)

Estas restricciones están ancladas en **decisiones arquitectónicas anteriores** y no pueden modificarse sin reescritura mayor de código. Son restricciones de **"portabilidad cero"**.

### **T1: Stack Fijo — Java 21 + Spring Boot 4.x + PostgreSQL**

**Descripción**: La pila tecnológica es no-negociable. No se migra a Go, Node.js, Rust, o cualquier otro lenguaje/framework.

**Implicaciones**:
- ✅ Todas las decisiones deben alinearse con el ecosistema Spring
- ✅ ORM es JPA (nunca custom Hibernate)
- ✅ Observabilidad usa Micrometer (nunca Jaeger custom)
- ✅ Gestión de dependencias vía Maven (nunca Gradle)

**Referencia**: `06-development/architecture.md` § "Stack"

**Violación Detectable**: 
- Proponer usar Kotlin → Rechazado
- Proponer microservicios Go → Rechazado
- Proponer MongoDB en lugar de PostgreSQL → Rechazado

---

### **T2: Migraciones Flyway — Versionado Inmutable**

**Descripción**: Una vez aplicada una migración SQL, jamás se edita. Si hay error post-aplicación, se crea V-siguiente.

**Regla de Oro**:
```
✅ CORRECTO:    V24__add_table.sql → error → V25__fix_table_add_column.sql
❌ INCORRECTO:  editar V24__add_table.sql después de aplicada
```

**Rationale**: 
- Historial de migraciones es "write-once". Una vez en prod, no puede reescribirse.
- Facilita reproducibilidad en múltiples ambientes (dev, staging, prod).
- Previene conflictos en monorepo con múltiples developers.

**Implicaciones**:
- 🧪 Testing de SQL **previo a commit** es obligatorio
- 🔄 CI valida schema contra BD test antes de merge
- 🚫 Revert de migración: nunca editar, solo crear V-siguiente

**Violación Detectable**:
- Editar `V23__add_password_reset_codes.sql` post-merge → **Rechazado**
- Renombrar `.sql` file → **Rechazado**

---

### **T3: `keygo-domain` Sin Spring — Arquitectura Hexagonal**

**Descripción**: El módulo `keygo-domain` es **puramente de negocio**. Sin anotaciones Spring, sin dependencias `@SpringBootTest`, sin Autowired, sin persistencia.

**Regla de Oro**:
```java
❌ INCORRECTO:
public class Tenant {
    @Id private Long id;
    @Column private String slug;
}

✅ CORRECTO:
public record TenantId(Long value) { }
public class Tenant {
    private TenantId id;
    private TenantSlug slug;
    
    // Métodos de negocio
    public void activate() { ... }
}
```

**Rationale**:
- Dominio testeable **sin framework** (JUnit 4, sin `@SpringBootTest`)
- Cambio de persistencia (JPA → MongoDB) no afecta dominio
- Modelos de negocio son value objects, no entidades JPA

**Implicaciones**:
- 🧪 Tests de `keygo-domain` ejecutan en < 100ms (sin BDD)
- 📦 `keygo-domain` es reutilizable en otros contextos (CLI, batch, etc.)
- 🚫 Sin importes de `org.springframework.*` en `keygo-domain/src`

**Violación Detectable**:
- Agregar `@Entity` a clase en `keygo-domain` → **Rechazado**
- Importar `org.springframework.boot.*` en dominio → **Rechazado**
- Usar `@Autowired` en dominio → **Rechazado**

---

### **T4: Jackson 3 — Namespace `tools.jackson`**

**Descripción**: Spring Boot 4.x usa Jackson 3; los imports **cambiaron de namespace**.

**Regla de Oro**:
```java
✅ CORRECTO:    import tools.jackson.databind.json.JsonMapper;
❌ INCORRECTO:  import com.fasterxml.jackson.databind.ObjectMapper;
```

**Implicaciones**:
- 📚 Código legacy copy-pasted con imports old fallará en compilación
- 🛠️ IntelliJ IDEA auto-complete propone import incorrecto → Configurar code style
- 🔍 Linter debe detectar imports de `com.fasterxml.jackson` y rechazar

**Violación Detectable**:
- Usar `com.fasterxml.jackson.*` imports → Compilación falla
- Mix de `tools.jackson` + `com.fasterxml.jackson` en mismo file → **Rechazado**

---

### **T5: `context-path=/keygo-server` — Prefijo Obligatorio**

**Descripción**: Todos los endpoints REST tienen prefijo `/keygo-server`.

**Regla de Oro**:
```http
✅ CORRECTO:    GET /keygo-server/api/v1/tenants/{slug}/users
❌ INCORRECTO:  GET /api/v1/tenants/{slug}/users
```

**Rationale**:
- Cliente hardcodea URLs con prefijo
- Documentación (Postman, OpenAPI) debe incluir prefijo
- Proxies/gateways deben stripear ruta correctamente

**Implicaciones**:
- 🌐 URLs en cliente incluyen `/keygo-server`
- 📖 Documentación OpenAPI genera rutas con prefijo
- 🔄 Proxies deben configurarse para strip/add prefijo según contexto

**Violación Detectable**:
- Endpoint sin prefijo → 404 (no encontrado por servidor)
- Cliente código con rutas sin prefijo → Fallos en integración

---

### **T6: Seguridad Bearer-Only — No `X-KEYGO-ADMIN`**

**Descripción**: Desde **2026-03-25**, autenticación es **`Authorization: Bearer <jwt>` exclusivamente**. Header `X-KEYGO-ADMIN` está **deprecated y rechazado**.

**Regla de Oro**:
```http
✅ CORRECTO:    Authorization: Bearer eyJhbGciOiJSUzI1NiJ9...
❌ INCORRECTO:  X-KEYGO-ADMIN: token
```

**Rationale**:
- RFC 6750 (OAuth 2.0 Bearer Token Usage)
- `@PreAuthorize` por endpoint extrae roles del JWT
- Tenant resolution automática desde JWT claim `iss`

**Implicaciones**:
- 🔐 RBAC por endpoint vía `@PreAuthorize("hasRole('ADMIN_TENANT')")`
- 🏢 Tenant slug resuelto desde JWT claim `iss`
- 📝 Docstring `@PreAuthorize` debe listar roles permitidos

**Violación Detectable**:
- Handler que acepta `X-KEYGO-ADMIN` → **Rechazado en code review**
- Endpoint sin `@PreAuthorize` → **Rechazado**
- JWT sin claim `iss` → 401 Unauthorized

---

## Functional Constraints (F1-F3)

Restricciones sobre **cómo funciona el sistema**, no sobre tecnología.

### **F1: Multi-Tenant Aislamiento por Path**

**Descripción**: Tenant se resuelve desde **path variable `/{tenantSlug}/`**. Data de tenants **nunca se mezcla**.

**Regla de Oro**:
```http
GET /keygo-server/api/v1/tenants/{tenantSlug}/users
    → Solo usuarios del tenant {tenantSlug}, nunca otro tenant
```

**Implicaciones**:
- 🗝️ Queries JPA **siempre filtran por `tenant_id`** (no opcional)
- 🚨 Errores de aislamiento = **violación de seguridad P0**
- 🧪 Tests deben validar: "usuario de tenant A no ve users de tenant B"
- 🔍 Code review: Toda query debe incluir `WHERE tenant_id = ?`

**Violación Detectable**:
```java
// ❌ INCORRECTO
List<User> users = userRepository.findAll(); // Sin filtro tenant

// ✅ CORRECTO
List<User> users = userRepository.findByTenantId(tenantSlug);
```

**Auditoría**: 
- Buscar en codebase: `findAll()` sin contexto tenant → **Rechazado**
- Buscar en SQL: `SELECT * FROM users` sin `WHERE tenant_id` → **Rechazado**

---

### **F2: OIDC Claims Estándar**

**Descripción**: JWT `id_token` incluye claims estándar **OIDC** (OpenID Connect Core 1.0). No hay custom claims en `id_token`.

**Regla de Oro** (payload `id_token` de ejemplo):
```json
{
  "sub": "user-uuid",
  "iss": "https://keygo.local/tenants/acme",
  "aud": "client-id",
  "iat": 1712329500,
  "exp": 1712333100,
  "name": "John Doe",
  "email": "john@acme.com",
  "email_verified": true,
  "picture": "https://...",
  "phone_number": "+1234567890",
  "birthdate": "1990-01-15",
  "locale": "es-MX",
  "updated_at": 1712329500
}
```

**Implicaciones**:
- 📋 Claims no-estándar van a `app_plan_entitlements` o metadata (futuro T-044, T-045)
- 🔧 Mapeo de claims personalizado por app (futuro T-045)
- 🔐 Clients (frontend, mobile) confían en estructura estándar

**Violación Detectable**:
- Custom claim en `id_token` (ej. `team_id`, `department`) → **Rechazado** (debe ir en entitlements)

---

### **F3: Sesiones Stateless — Sin Server-Side Session**

**Descripción**: Una vez JWT emitido, **no hay sesión server-side duradera**. Revocación es por **lista negra con TTL** (futuro Redis, T-038).

**Regla de Oro**:
```
Usuario login → JWT emitido con exp=1h
Usuario logout → /oauth2/revoke actualiza refresh_token status=REVOKED
Pero: access_token sigue siendo válido hasta exp (no hay sesión que lo invalide)
```

**Implicaciones**:
- ⏱️ Revocación **no es inmediata** (espera expiración de access_token)
- 📱 Clientes deben manejar token expiration (401 → refresh o logout)
- 🔄 Caché JTI (T-038) permite revocación inmediata (Largo plazo, no MVP)

**Violación Detectable**:
- Crear sesión server-side en login → **Rechazado** (uso stateless de JWT)
- Esperar que access_token se invalide inmediatamente post-logout → **No soportado** (by design)

---

## Regulatory/Compliance Constraints

### **GDPR (General Data Protection Regulation)**

**Status**: 🟡 Parcialmente soportado (futuro T-XXX)

- ✅ Actual: Datos en PostgreSQL, data residency configurable por env
- 🔲 Faltante: Right to be forgotten (borrado de datos), data export, consent management

---

### **CFDI México (Comprobantes Fiscales Digitales)**

**Status**: 🔲 Pendiente (futuro T-088, T-087, T-090)

- Facturas electrónicas para clientes en MXN
- Requiere integración con PAC (Proveedor Autorizado Certificación)
- Impacto: 3 propuestas futuras (PDF, CFDI, dunning)

---

### **PCI DSS (Para Billing / Payment Gateway)**

**Status**: 🟡 Diseño compliant, implementación pendiente (futuro T-084)

- Gateway real (Stripe/MercadoPago) = PCI Level 1
- KeyGo **nunca maneja números de tarjeta** (delegado a gateway)
- Almacenamiento: solo `payment_method_id` de gateway, no números

---

## Impact & Decision Matrix

| Constraint | Type | Impact if Violated | Severity | Team Decision |
|-----------|------|-------------------|----------|---------------|
| **T1** (Stack fijo) | Technical | Rewrite 80% codebase | 🔴 P0 | Architecture |
| **T2** (Flyway immutable) | Technical | Data corruption, recovery impossible | 🔴 P0 | DevOps |
| **T3** (keygo-domain sin Spring) | Technical | Harder to test, slower iteration | 🟠 P1 | Architecture |
| **T4** (Jackson 3) | Technical | Compilation fails | 🔴 P0 | Build |
| **T5** (context-path) | Technical | Client breaks, gateway routing fails | 🔴 P0 | DevOps |
| **T6** (Bearer-only) | Functional | Security breach (auth bypass) | 🔴 P0 | Security |
| **F1** (Multi-tenant isolation) | Functional | Data leak between tenants | 🔴 P0 | Security |
| **F2** (OIDC claims std) | Functional | Non-compliant clients, fragmentation | 🟡 P2 | Product |
| **F3** (Stateless sessions) | Functional | Immediate logout not supported | 🟡 P2 | Product |

---

## How to Challenge a Constraint

Si necesitas cambiar una restricción, sigue este proceso:

### **Step 1: Documentar Razón**
```
Escribir RFC (Request for Comments) en 00-documental-planning/rfcs/ con:
- Problema actual
- Propuesta de cambio
- Impacto (líneas de código, esfuerzo, riesgo)
- Alternativas consideradas
```

### **Step 2: Escalate**
```
Enviado a: Arquitectura + Product + DevOps
Decide: ¿Es cambio viable? ¿Qué impacto tiene?
```

### **Step 3: Consensus & Approval**
```
Requiere: Unanimidad de stakeholders
Una vez aprobado: Actualizar este documento
```

### **Ejemplo: Desafiar T2 (Flyway)**

❌ **NO viable**: "Queremos usar Liquibase en lugar de Flyway"
- Razón: Migración de historiales de migraciones es tediosa
- Impacto: 80 horas de work + riesgo de data loss
- Decision: **Rechazado**

✅ **SÍ viable**: "Queremos usar Flyway + callback para validaciones extra"
- Razón: Flyway callbacks permite ejecutar validaciones post-migración
- Impacto: 4 horas + cero riesgo
- Decision: **Aprobado** (futuro T-092)

---

↑ [Volver al inicio](#technical--functional-constraints-restricciones-no-negociables)

---

[← Volver a Development](./README.md)
