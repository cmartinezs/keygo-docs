[← Índice](./README.md) | [macro-plan](../macro-plan.md)

---

# Developer Glossary: Términos Técnicos del Stack

Referencia rápida de términos, tecnologías, y acrónimos usados en Keygo Server. Para desarrolladores que necesitan entender código, propuestas, y debates sin googlear cada término.

**Audiencia**: Backend developers, DevOps, Tech leads  
**Última actualización**: 2026-04-20

---

## Contenido

- [Stack Technologies](#stack-technologies)
- [Frameworks & Libraries](#frameworks--libraries)
- [Architecture & Patterns](#architecture--patterns)
- [Database & Migrations](#database--migrations)
- [Testing & Quality](#testing--quality)
- [Observability & Monitoring](#observability--monitoring)
- [Acronyms & Common Terms](#acronyms--common-terms)

---

## Stack Technologies

### **Java 21**
Versión LTS de Java con soporte extendido (hasta 2031). Keygo requiere Java 21+ por Record types, pattern matching, virtual threads (futuro).

**Relevancia**: Cualquier feature nueva debe soportar Java 21 (no usar APIs deprecated).

---

### **Spring Boot 4.x**
Framework de aplicación para Java. Keygo usa Spring Boot para REST APIs, dependency injection, y configuration.

**Key features usado**:
- `@RestController` — Controladores REST
- `@Service` — Servicios de negocio
- `@Repository` — Acceso a datos
- `@Component` — Componentes genéricos

**Versión actual**: 4.x (requerida, no negociable per T1)

---

### **Spring Security**
Módulo de Spring para autenticación y autorización.

**Keygo usage**:
- `@PreAuthorize("hasRole('...')")` — RBAC por endpoint
- `JwtAuthenticationProvider` — Validación de JWTs
- `OAuth2ResourceServerConfigurerAdapter` — OIDC compliance

---

### **PostgreSQL 15**
Base de datos relacional. Keygo usa PostgreSQL para persistencia.

**Keygo features usado**:
- Row-Level Security (RLS) — futuro para multi-tenant isolation
- JSONB — almacenamiento de configuraciones complejas
- Citext — case-insensitive text (para emails)

---

### **Jackson 3** 
Librería JSON para serialización/deserialización. Spring Boot 4.x viene con Jackson 3.

**Cambio clave**: Namespace cambió de `com.fasterxml.jackson` a `tools.jackson`.

```java
// ✅ CORRECTO (Jackson 3)
import tools.jackson.databind.json.JsonMapper;

// ❌ INCORRECTO (Jackson 2, deprecated)
import com.fasterxml.jackson.databind.ObjectMapper;
```

---

### **JWT (JSON Web Token)**
Token seguro con firma criptográfica. En Keygo: acceso/refresh tokens + id_token.

**Especificación**: RFC 7519  
**Algoritmo en Keygo**: RS256 (RSA + SHA-256)

---

## Frameworks & Libraries

### **Flyway** 
Herramienta de versionado de migraciones SQL. En Keygo: cada cambio de schema es un archivo `VXXX__description.sql`.

**Característica clave**: Versionado inmutable (una migración nunca se edita post-aplicación, per T2).

```sql
-- ✅ CORRECTO
V1__create_tenants.sql
V2__add_users.sql
V3__fix_users_email_index.sql  (si hay error en V2)

-- ❌ INCORRECTO
editar V2__add_users.sql después de aplicado
```

---

### **JPA (Java Persistence API)**
Especificación de ORM. Keygo usa Hibernate (implementación JPA).

**Keygo entities**:
- `TenantEntity` → tabla `tenants`
- `TenantUserEntity` → tabla `tenant_users`
- `SessionEntity` → tabla `sessions`
- `RefreshTokenEntity` → tabla `refresh_tokens`

**Regla**: Entidades JPA viven en `keygo-supabase/`. Dominio (`keygo-domain`) no tiene `@Entity`.

---

### **Nimbus**
Librería Java para JWT signing/verification. Usa criptografía moderna (RSA 2048+).

**Keygo adapters**:
- `NimbusJwtSignerAdapter` — firmar JWTs
- `NimbusJwksBuilder` — construir JWKS endpoint
- `NimbusJwtVerifier` — validar JWTs

---

### **BCrypt**
Algoritmo de hash de contraseñas con work factor adaptativo (no salt simple).

**Work factor en Keygo**: 12 (equilibrio seguridad/performance)

```java
// Ejemplo
String hashed = BCrypt.hashpw(password, BCrypt.gensalt(12));
boolean valid = BCrypt.checkpw(password, hashed);
```

---

### **TestContainers**
Framework para tests de integración. Crea containers Docker (PostgreSQL, etc.) durante tests.

**Keygo usage**: Tests de JPA sin BD real, sin mock.

```java
@Container
PostgreSQLContainer postgres = new PostgreSQLContainer<>()
    .withDatabaseName("keygo_test");
```

---

### **JUnit 5**
Framework de testing (successor a JUnit 4). Con anotaciones como `@Test`, `@BeforeEach`, etc.

---

### **Mockito**
Framework para mocking en tests. Crea stubs de dependencias.

---

### **Checkstyle**
Linter para código Java. Verifica conformidad a estándares (naming, imports, líneas máximas, etc.).

**Configuración**: `checkstyle.xml`

---

### **Spotless**
Formateador automático de código Java (similar a Prettier en JavaScript).

**Configuración**: `pom.xml` plugin `com.diffplug.spotless`

---

## Architecture & Patterns

### **Hexagonal Architecture (Ports & Adapters)**
Patrón donde el dominio está en el centro, conectado vía puertos (interfaces) a adaptadores exteriores.

**En Keygo**:
```
keygo-domain       ← Centro (lógica puro)
    ↓
keygo-app         ← Puertos (interfaces como PasswordHasherPort)
    ↓
keygo-infra       ← Adapters (BCryptPasswordHasherAdapter)
keygo-supabase    ← Adapters (JPA repositories)
keygo-api         ← Adapters (REST controllers)
```

**Ventaja**: Cambiar BCrypt por Argon2 requiere cambiar 1 adapter, no 100 lugares.

---

### **Bounded Contexts**
Concepto de Domain-Driven Design. En Keygo: 7 contextos (Identity, Access Control, Billing, Organization, Audit, Client Apps, Platform).

Cada contexto tiene su propio modelo de dominio.

---

### **Value Objects**
Objetos sin identidad única, comparados por valor. Ej.: `Money`, `Email`, `Password`.

En Keygo: `TenantSlug` es Value Object (dos slugs iguales son equivalentes).

---

### **Aggregates**
Cluster de entidades + value objects con un single root entity que enforce consistency.

En Keygo: `Tenant` aggregate incluye `TenantUsers` (pueden modificarse solo a través de `Tenant` root).

---

### **Domain Events**
Eventos que capturan "algo pasó en el dominio". Ej.: `UserCreated`, `TokenRevoked`.

En Keygo: usado para logging, auditoría, y comunicación entre contextos.

---

### **Repository Pattern**
Abstracción que simula una colección en-memoria de agregates. Oculta detalles de persistencia.

```java
// Port (interfaz)
public interface UserRepositoryPort {
    void save(User user);
    User findById(UserId id);
}

// Adapter (implementación JPA)
@Repository
public class UserRepositoryAdapter implements UserRepositoryPort {
    @Autowired private UserJpaRepository jpaRepo;
    
    public void save(User user) {
        jpaRepo.save(toEntity(user));
    }
}
```

---

### **RBAC (Role-Based Access Control)**
Control de acceso basado en roles. Usuario tiene rol (ADMIN, ADMIN_TENANT, USER), rol tiene permisos.

En Keygo:
- `ADMIN` — plataforma global
- `ADMIN_TENANT` — administrador de tenant específico
- `USER_TENANT` — usuario regular dentro tenant

---

### **OIDC (OpenID Connect)**
Capa de autenticación sobre OAuth2. Adiciona ID Token + userinfo endpoint.

**Especificación**: OpenID Connect Core 1.0  
**En Keygo**: Implementado en endpoints `/oauth2/authorize`, `/oauth2/token`, `/userinfo`, `/.well-known/openid-configuration`

---

## Database & Migrations

### **Row-Level Security (RLS)**
Característica de PostgreSQL para filtrar filas por usuario/tenant automáticamente.

**Keygo future**: Planificado para T-XXX (aislamiento multi-tenant en BD).

---

### **Citext** (case-insensitive text)
Extensión PostgreSQL para comparaciones case-insensitive. Útil para emails.

```sql
CREATE TABLE tenant_users (
    email citext UNIQUE NOT NULL
);
-- Ahora "john@acme.com" == "JOHN@acme.com" en queries
```

---

## Testing & Quality

### **JaCoCo** (Java Code Coverage)
Herramienta que mide cobertura de código en tests (% de líneas ejecutadas).

**Target en Keygo**:
- `keygo-domain`: 90%+ (dominio crítico)
- `keygo-app`: 85%+
- `keygo-supabase`: 60%+ (adaptadores menos críticos)

---

### **Mutation Testing** (futuro)
Técnica que introduce "mutaciones" (cambios menores) en código y verifica que tests las detecten.

Si mutation vive sin tests fallando → gap en cobertura.

---

### **Integration Tests**
Tests que verifican interacción entre múltiples componentes (JPA ↔ BD, API ↔ controllers, etc.).

En Keygo: Usado con TestContainers para verificar JPA vs migraciones.

---

### **Unit Tests**
Tests de componentes aislados sin dependencias externas (sin BD, sin HTTP, sin librerías).

En Keygo: Tests de `keygo-domain` son unit tests (sin Spring, sin BD).

---

## Observability & Monitoring

### **Micrometer**
Librería para métricas. Abstracción sobre Prometheus, Datadog, etc.

**En Keygo**: Usado para registrar contadores, timers, gauges.

```java
@Timed(value = "oauth2.token.created", description = "Tokens emitted")
public void createToken(User user) { ... }
```

---

### **Logging**
En Keygo: SLF4J + Logback (logging framework estándar en Spring).

```java
Logger logger = LoggerFactory.getLogger(this.getClass());
logger.info("User {} logged in", userId);
```

---

### **Tracing** (futuro)
Distributed tracing (ej. Jaeger) para seguir request a través de múltiples servicios.

**Keygo future**: Planificado cuando se divida en microservicios.

---

## Acronyms & Common Terms

| Acrónimo | Significado | Contexto | Ejemplo |
|----------|-------------|---------|---------|
| **OIDC** | OpenID Connect | Autenticación | `/oauth2/authorize` es endpoint OIDC |
| **OAuth2** | Open Authorization | Autorización | RFC 6749 (estándar) |
| **RBAC** | Role-Based Access Control | Control de acceso | `@PreAuthorize("hasRole('ADMIN')")` |
| **JWT** | JSON Web Token | Token | Access token es JWT (RFC 7519) |
| **RS256** | RSA + SHA-256 | Firma JWT | Algoritmo de firma de JWTs |
| **PKCE** | Proof Key for Code Exchange | OAuth2 seguridad | RFC 7636, previene code interception |
| **M2M** | Machine to Machine | Autenticación | Client Credentials grant (sin usuario final) |
| **BCrypt** | Blowfish crypt | Hash password | Algorithm de hash de contraseñas |
| **RLS** | Row-Level Security | PostgreSQL | Filtrado automático de filas por tenant |
| **TTL** | Time To Live | Expiración | Authorization codes expiran en 10 minutos |
| **JPA** | Java Persistence API | ORM | Standard de ORM en Java |
| **VO** | Value Object | DDD | Objetos inmutables sin identidad |
| **Entity** | Entidad de dominio | DDD | Objetos con identidad única y duradera |
| **RFC** | Request for Comments | Estándares | RFC 6749 (OAuth2), RFC 7519 (JWT) |
| **PII** | Personally Identifiable Info | Privacidad | Email, phone, nombre usuario |
| **GDPR** | General Data Protection Reg. | Compliance | Derecho a ser olvidado, data export |
| **PCI DSS** | Payment Card Industry | Compliance | No almacenar números tarjeta |
| **CI/CD** | Continuous Integration/Deploy | DevOps | GitHub Actions, automated testing |
| **SLA** | Service Level Agreement | Operaciones | 99.99% uptime, 15-min response |

---

## Quick Reference: "I need to..."

- 🔐 **Validar un JWT** → Usar `NimbusJwtVerifier` (implementa port `TokenVerifierPort`)
- 🔑 **Hash una contraseña** → Usar `BCryptPasswordHasherAdapter` (implementa port `PasswordHasherPort`)
- 💾 **Guardar usuario** → Usar `UserRepositoryAdapter` (implementa port `UserRepositoryPort`)
- 🧪 **Test con BD** → TestContainers + `@Container PostgreSQLContainer`
- 🎯 **Proteger endpoint** → Agregar `@PreAuthorize("hasRole('...')")`
- 📊 **Agregar métrica** → Usar `@Timed` (Micrometer)
- 📝 **Migración SQL** → Crear `VXXX__description.sql` en Flyway (nunca editar posterior)
- 🚀 **Deploy cambios** → CI/CD ejecuta tests + lint + builds Docker image

---

↑ [Volver al inicio](#developer-glossary-términos-técnicos-del-stack)

---

[← Volver a Development](./README.md)
