[← Índice](./README.md) | [Siguiente >](./api-reference.md)

---

# Arquitectura del Sistema

Arquitectura técnica de KeyGo: stack, módulos, patrones arquitectónicos y flujo de request.

## Contenido

- [Principios](#principios)
- [Stack Tecnológico](#stack-tecnológico)
- [Arquitectura Hexagonal](#arquitectura-hexagonal)
- [Módulos](#módulos)
- [Patrones Arquitectónicos](#patrones-arquitectónicos)
- [Flujo de Request](#flujo-de-request)
- [Multi-Tenancy](#multi-tenancy)
- [Seguridad](#seguridad)
- [Patrones de Infraestructura](#patrones-de-infraestructura)
- [Observabilidad](#observabilidad)

---

## Principios

| Principio | Descripción |
|----------|-------------|
| **Hexagonal / Ports & Adapters** | Dominio puro desacoplado de frameworks; infraestructura intercambiable |
| **DDD Táctico** | Entidades, Value Objects, Agregados, Servicios de Dominio |
| **Multi-Tenancy Core** | Aislamiento desde el núcleo del modelo, no como preocupación transversal |
| **API Versionada** | Contratos HTTP explícitos con versionado en URL — ver [API Versioning Strategy](./api-versioning-strategy.md) |
| **Contratos Claros** | DTOs específicos por caso de uso, no entidades JPA expuestas |
| **Observabilidad** | Logging estructurado, métricas, tracing desde el diseño |

[↑ Volver al inicio](#arquitectura-del-sistema)

---

## Stack Tecnológico

| Componente | Tecnología | Versión |
|------------|------------|---------|
| Lenguaje | Java | 21 |
| Framework | Spring Boot | 4.x |
| Serialización | Jackson | 3 |
| Persistencia | Spring Data JPA | - |
| Migraciones | Flyway | - |
| Base de datos | PostgreSQL | - |
| API Docs | OpenAPI | 3.x |

[↑ Volver al inicio](#arquitectura-del-sistema)

---

## Arquitectura Hexagonal

### Capas y Dependencias

```
┌─────────────────────────────────────────────────────────────┐
│                    keygo-domain                             │
│  (Entidades, Value Objects, Agregados, domain services)       │
│  ← SIN dependencias de Spring                                  │
└─────────────────────────────────────────────────────────────┘
                           ← ←
┌─────────────────────────────────────────────────────────────┐
│                    keygo-app                              │
│  (Use Cases, Commands, Queries, Ports OUT)                   │
└─────────────────────────────────────────────────────────────┘
                           ← ←
┌──────────────────────┐    ┌──────────────────────┐
│   keygo-infra    │    │    keygo-api     │
│  (JWT, JWKS,   │    │ (Controllers,   │
│   adapters)     │    │   DTOs, errors)  │
└──────────────────────┘    └──────────────────────┘
                           ← ←
┌─────────────────────────────────────────────────────────────┐
│                  keygo-supabase                         │
│  (JPA Entities, Repositories, Migrations, Adapters)    │
└─────────────────────────────────────────────────────────────┘
                           ← ←
┌─────────────────────────────────────────────────────────────┐
│                    keygo-run                             │
│  (Spring Boot main, wiring, filtros, config)              │
└─────────────────────────────────────────────────────────────┘
```

### Regla Crítica

**`keygo-domain` no depende de Spring ni de ningún otro módulo interno.**

[↑ Volver al inicio](#arquitectura-del-sistema)

---

## Módulos

| Módulo | Responsabilidad | Contiene |
|--------|----------------|----------|
| `keygo-domain` | Dominio puro: entidades, value objects, invariantes | Modelos de dominio, excepciones de dominio |
| `keygo-app` | Casos de uso y puertos OUT | Use cases, comandos, queries, interfaces de puerto |
| `keygo-api` | Contratos HTTP | Controllers, DTOs, errores, OpenAPI |
| `keygo-infra` | Adaptadores de infraestructura | JWT signer, JWKS builder, PKCE verifier |
| `keygo-supabase` | Persistencia JPA | Entidades JPA, repositorios, migraciones Flyway |
| `keygo-run` | Bootstrap Spring | Main, wiring, filtros, seguridad |
| `keygo-bom` | Gestión de versiones | Dependencias centralizadas |
| `keygo-common` | Utilidades compartidas | Helpers, utilities |

[↑ Volver al inicio](#arquitectura-del-sistema)

---

## Bounded Contexts → Módulos (Mapeo DDD)

Cada Bounded Context del diseño estratégico se implementa como un **paquete Java por feature** que extiende horizontalmente a través de los módulos. El mapeo garantiza que:

1. El **ubiquitous language** del contexto se refleja en los nombres de clases, métodos y paquetes
2. Las **fronteras de consistencia** (agregados) se respetan dentro del paquete feature
3. Las **relaciones entre contextos** (Customer/Supplier, ACL, etc.) se implementan explícitamente

### Estructura por Bounded Context

```
io.cmartinezs.keygo.<feature>/
  ├── <KEYGO-DOMAIN>
  │   ├── domain/
  │   │   ├── <AggregateRoot>.java           (Entidad raíz del agregado)
  │   │   ├── <ValueObject>.java             (Immutable, no ID)
  │   │   ├── <Entity>.java                  (Entidad dentro del agregado, con ID)
  │   │   ├── <DomainEvent>.java             (Evento emitido por el agregado)
  │   │   └── <DomainService>.java           (Lógica de dominio que no cabe en agregado)
  │   └── exception/
  │       └── <DomainException>.java         (Excepciones de negocio)
  │
  ├── <KEYGO-APP>
  │   ├── command/
  │   │   └── <Action><Entity>Command.java   (DTO de entrada)
  │   ├── query/
  │   │   └── <Find><Entity>Query.java       (Query de lectura)
  │   ├── port/
  │   │   └── <Entity>RepositoryPort.java    (Puerto OUT: contrato de persistencia)
  │   └── usecase/
  │       └── <Action><Entity>UseCase.java   (Orquestación de dominio)
  │
  ├── <KEYGO-API>
  │   ├── controller/
  │   │   └── <Entity>Controller.java        (HTTP endpoint, @PreAuthorize)
  │   ├── request/
  │   │   └── <Action><Entity>Request.java   (DTO de request HTTP)
  │   ├── response/
  │   │   └── <Entity>Data.java              (DTO de response HTTP)
  │   └── error/
  │       └── <Entity>ErrorHandler.java      (Traducción: excepciones → HTTP status)
  │
  └── <KEYGO-SUPABASE>
      ├── entity/
      │   └── <Entity>Entity.java            (JPA Entity, replicada del dominio)
      ├── repository/
      │   └── <Entity>Repository.java        (JPA Repository interface)
      ├── adapter/
      │   └── <Entity>RepositoryAdapter.java (Implementación del puerto OUT)
      └── mapper/
          └── <Entity>PersistenceMapper.java (Persistencia ↔ Dominio)
```

### Ejemplos por Bounded Context

#### Identity Context (CORE)

```
io.cmartinezs.keygo.identity/
  ├── domain/
  │   ├── Identity.java                      (Aggregate Root)
  │   ├── EmailAddress.java                  (Value Object)
  │   ├── IdentityStatus.java                (Enum: ACTIVE, SUSPENDED, etc.)
  │   ├── PasswordHasher.java                (Domain Service)
  │   ├── IdentityCreatedEvent.java          (Domain Event)
  │   └── exception/
  │       ├── IdentityNotFoundException.java
  │       └── DuplicateEmailException.java
  ├── app/
  │   ├── command/
  │   │   └── RegisterIdentityCommand.java
  │   ├── port/
  │   │   └── IdentityRepositoryPort.java
  │   └── usecase/
  │       ├── RegisterIdentityUseCase.java
  │       └── AuthenticateIdentityUseCase.java
  ├── api/
  │   ├── controller/IdentityController.java
  │   ├── request/RegisterIdentityRequest.java
  │   └── response/IdentityData.java
  └── infra/
      ├── entity/IdentityEntity.java
      ├── repository/IdentityJpaRepository.java
      ├── adapter/IdentityRepositoryAdapter.java
      └── mapper/IdentityPersistenceMapper.java
```

#### Access Control Context (CORE)

```
io.cmartinezs.keygo.accesscontrol/
  ├── domain/
  │   ├── Role.java                          (Aggregate Root)
  │   ├── Permission.java                    (Value Object)
  │   ├── Membership.java                    (Aggregate Root)
  │   ├── RoleEvaluator.java                 (Domain Service)
  │   ├── RoleAssignedEvent.java             (Domain Event)
  │   └── exception/
  │       ├── RoleNotFoundException.java
  │       └── InsufficientPermissionException.java
  ├── app/
  │   ├── command/
  │   │   └── AssignRoleCommand.java
  │   ├── query/
  │   │   └── EvaluateAccessQuery.java
  │   ├── port/
  │   │   ├── RoleRepositoryPort.java
  │   │   └── IdentityProviderPort.java     (Puerto para consultar identidades)
  │   └── usecase/
  │       ├── AssignRoleUseCase.java
  │       └── EvaluateAccessUseCase.java
  ├── api/
  │   ├── controller/AccessControlController.java
  │   ├── request/AssignRoleRequest.java
  │   └── response/RoleData.java
  └── infra/
      ├── entity/
      │   ├── RoleEntity.java
      │   └── MembershipEntity.java
      ├── repository/
      │   ├── RoleJpaRepository.java
      │   └── MembershipJpaRepository.java
      ├── adapter/
      │   ├── RoleRepositoryAdapter.java
      │   └── IdentityProviderAdapter.java   (Anti-Corruption Layer)
      └── mapper/
          ├── RolePersistenceMapper.java
          └── MembershipPersistenceMapper.java
```

#### Organization Context (SUPPORTING)

```
io.cmartinezs.keygo.organization/
  ├── domain/
  │   ├── Organization.java                  (Aggregate Root)
  │   ├── OrganizationSlug.java              (Value Object)
  │   ├── OrganizationName.java              (Value Object)
  │   └── exception/
  │       └── OrganizationNotFoundException.java
  ├── app/
  │   ├── command/
  │   │   └── RegisterOrganizationCommand.java
  │   ├── port/
  │   │   └── OrganizationRepositoryPort.java
  │   └── usecase/
  │       └── RegisterOrganizationUseCase.java
  └── infra/
      ├── entity/OrganizationEntity.java
      ├── adapter/OrganizationRepositoryAdapter.java
      └── mapper/OrganizationPersistenceMapper.java
```

[↑ Volver al inicio](#arquitectura-del-sistema)

---

## Patrones Arquitectónicos

### 1. Puerto (Interface) → Adaptador (Implementation)

```java
// Puerto (keygo-app) — Interface
public interface UserRepositoryPort {
  Optional<User> findById(UserId id);
  User save(User user);
  PagedResult<User> findPaged(UserFilter filter);
}

// Adaptador (keygo-supabase) — Implementation
@Repository
public class UserRepositoryAdapter implements UserRepositoryPort {
  private final UserJpaRepository jpaRepository;

  @Override
  public Optional<User> findById(UserId id) {
    return jpaRepository.findById(id.value())
        .map(UserPersistenceMapper::toDomain);
  }
}
```

### 2. Value Objects con Validación Implícita

```java
public record EmailAddress(String value) {
  public EmailAddress {
    if (!isValid(value)) {
      throw new IllegalArgumentException("Invalid email: " + value);
    }
  }

  private static boolean isValid(String value) {
    return value != null && value.matches("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
  }
}
```

### 3. Agregados: Raíz y Límites

```java
@Builder
@Getter
public class Tenant {
  private TenantId id;
  private TenantSlug slug;
  private TenantName name;
  private TenantStatus status;

  public boolean isActive() {
    return status == TenantStatus.ACTIVE;
  }

  public void suspend() {
    this.status = TenantStatus.SUSPENDED;
  }
}
```

### 4. Domain Services: Generación y Derivación

```java
public final class PasswordValidationHelper {
  public static void validate(String password, boolean isTemporary) {
    if (isTemporary) {
      requireMinLength(password, 8);
    } else {
      requireMinLength(password, 12);
      requireCharacterClasses(password, 4);
    }
  }
}
```

### 5. Mappers: Persistencia ↔ Dominio

```java
public class UserPersistenceMapper {
  public static User toDomain(UserEntity entity) {
    return User.builder()
        .id(new UserId(entity.getId()))
        .email(EmailAddress.of(entity.getEmail()))
        .status(UserStatus.valueOf(entity.getStatus()))
        .build();
  }
}
```

### 6. Soft-Delete con Índice Parcial

```java
@Entity
@Table(name = "users", indexes = {
  @Index(name = "idx_removed_at", columnList = "removed_at")
})
public class UserEntity {
  @Id private UUID id;
  @Column(name = "removed_at")
  private OffsetDateTime removedAt;  // null = activo

  public boolean isActive() {
    return removedAt == null;
  }
}
```

### 7. Paginación DB-Side con JPA Specifications

```java
public PagedResult<User> findPaged(UserFilter filter) {
  Specification<UserEntity> spec = buildSpecification(filter);
  Page<UserEntity> page = jpaRepository.findAll(spec, PageRequest.of(
    filter.getPage(), filter.getSize(), Sort.by(filter.getSortBy())));
  return PagedResult.of(page.map(UserPersistenceMapper::toDomain));
}
```

### 8. Repository Pattern: Puertos y Adaptadores

El patrón Repository encapsula la persistencia detrás de una interfaz en el dominio. El dominio nunca conoce JPA, SQL ni detalles de infraestructura.

**Puerto (keygo-app):**

```java
// Interfaz en el dominio (lenguaje del negocio)
public interface RoleRepositoryPort {
  Optional<Role> findById(RoleId id, TenantSlug tenant);
  Role save(Role role);
  PagedResult<Role> findByTenant(TenantSlug tenant, RoleFilter filter);
  void deleteById(RoleId id);
}
```

**Adaptador (keygo-supabase):**

```java
@Repository
@RequiredArgsConstructor
public class RoleRepositoryAdapter implements RoleRepositoryPort {
  private final RoleJpaRepository jpaRepository;

  @Override
  public Optional<Role> findById(RoleId id, TenantSlug tenant) {
    return jpaRepository.findByIdAndTenantSlug(id.value(), tenant.value())
        .map(RolePersistenceMapper::toDomain);
  }

  @Override
  public Role save(Role role) {
    RoleEntity entity = RolePersistenceMapper.toEntity(role);
    RoleEntity saved = jpaRepository.save(entity);
    return RolePersistenceMapper.toDomain(saved);
  }

  @Override
  public PagedResult<Role> findByTenant(TenantSlug tenant, RoleFilter filter) {
    Specification<RoleEntity> spec = (root, query, cb) ->
        cb.equal(root.get("tenantSlug"), tenant.value());
    
    Page<RoleEntity> page = jpaRepository.findAll(spec,
        PageRequest.of(filter.page(), filter.size()));
    
    return PagedResult.of(page.map(RolePersistenceMapper::toDomain));
  }

  @Override
  public void deleteById(RoleId id) {
    jpaRepository.deleteById(id.value());
  }
}
```

### 9. Factory Pattern: Creación Compleja de Agregados

Factories encapsulan la creación de agregados garantizando que se crean siempre en estado válido. Especialmente útil cuando la creación requiere:
- Validación de invariantes complejas
- Generación de IDs o valores derivados
- Coordinación con otro dominio

**Factory en el dominio:**

```java
public class IdentityFactory {
  private final PasswordHasher passwordHasher;
  private final EmailValidator emailValidator;

  public Identity createNewIdentity(
      EmailAddress email,
      String plainPassword,
      IdentityRole platformRole) {
    
    // Validación de invariantes
    if (!emailValidator.isValid(email)) {
      throw new InvalidEmailException(email.value());
    }
    
    // Generación segura de identificador y contraseña hasheada
    IdentityId id = IdentityId.generate();
    HashedPassword hashedPassword = passwordHasher.hash(plainPassword);
    
    // Creación en estado garantizado válido
    Identity identity = Identity.builder()
        .id(id)
        .email(email)
        .hashedPassword(hashedPassword)
        .status(IdentityStatus.ACTIVE)
        .createdAt(Instant.now())
        .build();
    
    // Emitir evento de dominio
    identity.recordThat(new IdentityCreatedEvent(id, email, Instant.now()));
    
    return identity;
  }
}
```

[↑ Volver al inicio](#arquitectura-del-sistema)

---

## Anti-Corruption Layer (ACL)

El ACL es una **frontera defensiva** entre dos Bounded Contexts cuando hay asimetría de poder o cuando un modelo externo no debe contaminar el modelo interno. Es especialmente crítica en contextos multi-tenant.

### Cuándo usar ACL

| Situación | Razón | Ejemplo |
|-----------|-------|---------|
| **Integración con sistema externo** | El sistema externo tiene un modelo que no queremos que penetre el nuestro | Proveedor de pago: sus conceptos de "transacción" y "webhook" son internos; nosotros hablamos de "cobro" y "auditoría de pago" |
| **Contexto Supporting consume Core** | El contexto que consume es menos importante; debe adaptarse al Core Domain | `Billing` consume eventos de `Identity` pero tiene su propio modelo de Usuario (solo los campos que necesita para suscripciones) |
| **Legacy system integration** | El sistema antiguo tiene un modelo incompatible; queremos migrar sin contaminarnos | Wrappeamos el API legacy detrás de un adaptador que traduce a nuestro ubiquitous language |
| **Multi-tenancy security boundary** | Traducción de tenant-ID a contexto de tenant aplicado | Cuando consultamos datos de otro contexto, traducimos el identificador del tenant |

### Estructura del ACL

```
adapter/
  └── <ExternalSystem>Adapter.java          (Frontera defensiva)
      └── Traduce modelo externo → modelo interno
```

### Ejemplo 1: Identity Provider Adapter (Access Control → Identity)

```java
@Component
@RequiredArgsConstructor
public class IdentityProviderAdapter {
  private final IdentityRepositoryPort identityRepository;

  // Puerto OUT que Access Control usa para consultar identidades
  public Optional<Identity> findIdentityById(IdentityId id) {
    // El ACL traduce la solicitud al modelo de Identity
    return identityRepository.findById(id);
  }

  // Traducción defensiva: el modelo que Identity expone vs. lo que Access Control necesita
  public RoleContext buildRoleContextFor(Identity identity) {
    // No exponemos el objeto Identity completo
    // Traducimos solo lo que Access Control necesita saber
    return RoleContext.builder()
        .identityId(identity.id())
        .email(identity.email())
        .tenantId(identity.tenantId())
        .build();
  }
}
```

### Ejemplo 2: Payment Provider Adapter (Billing → External System)

```java
@Component
@RequiredArgsConstructor
public class PaymentProviderAdapter {
  private final PaymentProviderClient client;

  // Traducción SALIENTE: modelo de Billing → modelo externo
  public PaymentTransaction processPayment(Charge charge) {
    try {
      // Traducir Charge (ubiquitous language de Billing)
      // al formato que el proveedor entiende
      ExternalPaymentRequest externalReq = PaymentTranslator.translate(charge);
      
      // Llamar al proveedor
      ExternalPaymentResponse externalResp = client.processPayment(externalReq);
      
      // Traducir ENTRADA: respuesta externa → modelo de dominio
      PaymentTransaction transaction = PaymentTranslator.toPaymentTransaction(externalResp);
      
      return transaction;
    } catch (ExternalPaymentException e) {
      // Traducir errores externos a excepciones de dominio
      throw new PaymentFailedException(charge.id(), e.getMessage());
    }
  }
}

// Translator (parte del ACL)
public class PaymentTranslator {
  public static ExternalPaymentRequest translate(Charge charge) {
    return ExternalPaymentRequest.builder()
        .amount(charge.amount().value())
        .currency(charge.amount().currency())
        .customerId(charge.customerId().value())
        .description("Billing for tenant: " + charge.tenantSlug().value())
        .metadata(Map.of(
            "tenant_id", charge.tenantSlug().value(),
            "charge_id", charge.id().value()
        ))
        .build();
  }

  public static PaymentTransaction toPaymentTransaction(ExternalPaymentResponse resp) {
    return PaymentTransaction.builder()
        .id(PaymentTransactionId.of(resp.getTransactionId()))
        .amount(Money.of(resp.getAmount(), resp.getCurrency()))
        .status(translateStatus(resp.getStatus()))
        .externalReference(resp.getReferenceNumber())
        .processedAt(resp.getTimestamp())
        .build();
  }

  private static PaymentStatus translateStatus(String externalStatus) {
    return switch (externalStatus) {
      case "APPROVED" -> PaymentStatus.COMPLETED;
      case "PENDING" -> PaymentStatus.PENDING;
      case "FAILED" -> PaymentStatus.FAILED;
      case "CANCELLED" -> PaymentStatus.CANCELLED;
      default -> throw new IllegalArgumentException("Unknown status: " + externalStatus);
    };
  }
}
```

### Reglas del ACL

1. **Unidireccional**: El ACL es una frontera defensiva; siempre está en el lado del contexto consumidor (downstream)
2. **Transparente**: El dominio interno nunca ve el modelo externo
3. **Traducción completa**: No es suficiente con mappear campos; hay que traducir conceptos
4. **Error handling**: Los errores externos se traducen a excepciones de dominio
5. **No lógica de negocio**: El ACL es traducción pura, no decisión de negocio

[↑ Volver al inicio](#arquitectura-del-sistema)

[↑ Volver al inicio](#arquitectura-del-sistema)

---

## Flujo de Request

```
HTTP Request
    ↓
┌─────────────────────────────────────────────────────────────────┐
│ keygo-run: Filtros y seguridad (Bootstrap)            │
│ - JWT validation                            │
│ - Tenant scope extraction                 │
│ - Correlation ID (MDC)                  │
└─────────────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────────┐
│ keygo-api: Controller                     │
│ - DTO de request → Validación             │
│ - @PreAuthorize                        │
│ - Endpoint: POST /api/v1/tenants/{slug}/users   │
└─────────────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────────┐
│ keygo-app: Use Case                     │
│ - Comando → Lógica de dominio         │
│ - Invoca puerto OUT                    │
└─────────────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────────┐
│ keygo-supabase: Adapter                 │
│ - Repository → JPA                    │
│ - Query con Specifications            │
└─────────────────────────────────────────────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────────┐
│ keygo-domain: Persistence             │
│ - Entity JPA                       │
│ - Retorna domain model               │
└─────────────────────────────────────────────────────────────────┘
    ↓
BaseResponse<T> → JSON
```

[↑ Volver al inicio](#arquitectura-del-sistema)

---

## Multi-Tenancy

### Implementación

El aislamiento tenant se implementa a nivel de:

1. **Modelo de Dominio**: cada entidad tiene `tenant_id` — ver [Database Schema](./database-schema.md) § Multi-Tenancy Isolation
2. **Consultas**: filtrado automático por tenant en repositorios
3. **JWT**: claim `tenant_slug` en token — ver [Authorization Patterns](./authorization-patterns.md) § JWT Canonical Structure
4. **Autorización**: validación de scope en `@PreAuthorize` — ver [Authorization Patterns](./authorization-patterns.md) § RBAC y @PreAuthorize
5. **OAuth2 Contract**: dos niveles independientes (Platform + Tenant) — ver [OAuth2/OIDC Contract](./oauth2-oidc-contract.md)

### Aislamiento en queries

```java
public interface UserRepositoryPort {
  PagedResult<User> findByTenantSlug(String tenantSlug, UserFilter filter);
}

public class UserRepositoryAdapter {
  @Override
  public PagedResult<User> findByTenantSlug(String tenantSlug, UserFilter filter) {
    Specification<UserEntity> spec = (root, query, cb) -> {
      return cb.equal(root.get("tenant").get("slug"), tenantSlug);
    };
    //会自动添加 removed_at IS NULL
    return jpaRepository.findAll(spec, pageRequest);
  }
}
```

### Rol Tenant-Scoped

```java
@PreAuthorize("@tenantAuthorizationEvaluator.hasTenantAccess(authentication)")
@GetMapping("/api/v1/tenants/{tenantSlug}/users")
public ResponseEntity<BaseResponse<PagedData<UserData>>> listUsers(...) {
  // valida: tenant_slug en JWT == tenantSlug en URL
}
```

[↑ Volver al inicio](#arquitectura-del-sistema)

---

## Seguridad

### JWT Claims & RBAC

Detalles completos en [Authorization Patterns](./authorization-patterns.md):
- Estructura canónica de JWT claims (sub, tenant_slug, roles, aud, iss)
- Tres niveles de RBAC (Platform, Tenant, App)
- Patrón @PreAuthorize con validación de scope tenant

### OAuth2/OIDC Contract

Flujos de autenticación multi-nivel, refresh token rotation con replay detection (T-035), y JWKS discovery en [OAuth2/OIDC Contract](./oauth2-oidc-contract.md):
- PKCE Authorization Code Flow
- Refresh Token Rotation (con cadena de tokens y detección de replay)
- Logout y revocación de tokens
- Endpoint JWKS por tenant

### Validación en Código

```java
@PreAuthorize("hasRole('keygo_admin')")
// O
@PreAuthorize("@tenantAuthorizationEvaluator.hasTenantAccess(authentication)")
// O con rol específico
@PreAuthorize("hasAnyRole('ADMIN_ORG', 'keygo_admin') and @tenantAuthorizationEvaluator.hasTenantAccess(auth)")
```

Ver [Authorization Patterns](./authorization-patterns.md) § @PreAuthorize Patterns para ejemplos completos.

[↑ Volver al inicio](#arquitectura-del-sistema)

---

## Patrones de Infraestructura

### Resiliencia: Retry + Circuit Breaker

```java
@Configuration
public class ResilienceConfig {

  @Bean
  public RetryRegistry retryRegistry() {
    return RetryRegistry.ofDefaults();
  }

  @Bean
  public CircuitBreakerRegistry circuitBreakerRegistry() {
    return CircuitBreakerRegistry.ofDefaults();
  }
}
```

**Uso en use case:**

```java
@Service
public class ExternalUserService {

  @CircuitBreaker(name = "externalApi", fallbackMethod = "fallback")
  @Retry(name = "externalApi", maxAttempts = 3, delay = 500ms)
  public ExternalUser fetchUser(String id) {
    return httpClient.get("/users/" + id);
  }

  public ExternalUser fallback(String id, Exception e) {
    return ExternalUser.unknown();
  }
}
```

**Configuración:**

```yaml
resilience4j:
  circuitbreaker:
    instances:
      externalApi:
        sliding-window-size: 10
        failure-rate-threshold: 50
        wait-duration-in-open-state: 30s
  retry:
    instances:
      externalApi:
        max-attempts: 3
        wait-duration: 500ms
```

### Rate Limiting

```java
@Component
public class RateLimitFilter extends OncePerRequestFilter {

  private final RateLimiterRegistry registry = RateLimiterRegistry.ofDefaults();

  @Override
  protected void doFilterInternal(HttpServletRequest request, 
      HttpServletResponse response, FilterChain chain) 
      throws ServletException, IOException {

    String clientId = getClientId(request);
    RateLimiter limiter = registry.rateLimiter("api_" + clientId);

    if (limiter.acquirePermission()) {
      chain.doFilter(request, response);
    } else {
      response.setStatus(429);
      response.getWriter().write("{\"error\":\"RATE_LIMITED\"}");
    }
  }
}
```

**Límites por plan:**

| Plan | Requests/min | Requests/día |
|------|------------|-------------|
| Free | 60 | 1,000 |
| Pro | 600 | 50,000 |
| Enterprise | 6,000 | Unlimited |

### IP Blacklist

```java
@Component
public class IpBlacklistFilter extends OncePerRequestFilter {

  private final Set<String> blacklist = Set.of(
    "192.168.1.100",  // Ejemplo
    "10.0.0.50"
  );

  @Override
  protected void doFilterInternal(HttpServletRequest request, 
      HttpServletResponse response, FilterChain chain) 
      throws ServletException, IOException {

    String clientIp = getClientIp(request);

    if (blacklist.contains(clientIp)) {
      response.setStatus(403);
      response.getWriter().write("{\"error\":\"IP_BLOCKED\"}");
      return;
    }

    chain.doFilter(request, response);
  }
}
```

**Endpoints configurables:**

```java
@Obsersable
@TargetRateLimiter(name = "login")
@IpRateLimit(maxRequests = 5, window = 10 minutes)
@PostMapping("/oauth/token")
public ResponseEntity<?> token(...) { ... }
```

### Caché

```java
@Configuration
public class CacheConfig {

  @Bean
  public CacheManager cacheManager() {
    SimpleCacheManager manager = new SimpleCacheManager();
    manager.setCaches(Set.of(
      new ConcurrentMapCache("users"),
      new ConcurrentMapCache("tenants"),
      new ConcurrentMapCache("serviceInfo")
    ));
    return manager;
  }
}
```

**Uso en servicio:**

```java
@Service
public class UserService {

  @Cacheable(value = "users", key = "#tenantSlug + ':' + #userId")
  public Optional<User> findUser(String tenantSlug, String userId) {
    return repository.findById(userId, tenantSlug);
  }

  @CacheEvict(value = "users", key = "#tenantSlug + ':' + #userId")
  public void deleteUser(String tenantSlug, String userId) {
    repository.delete(userId);
  }

  @CachePut(value = "users", key = "#result.id")
  public User saveUser(User user) {
    return repository.save(user);
  }
}
```

**TTL por caché:**

| Caché | TTL | Política |
|------|-----|----------|
| Service info | 5 min | Stale-while-revalidate |
| Tenant config | 1 min | LRU |
| User session | Session | Evict on logout |

### Fallback Strategies

```java
@Service
public class UserService {

  public User getUser(String id) {
    try {
      return httpClient.getUser(id);
    } catch (Exception e) {
      // Fallback: cache
      return cache.get("user_" + id).orElse(User.unknown());
    }
  }

  public User fallback(Exception e) {
    log.warn("External service unavailable, using fallback");
    return User.unknown();
  }
}
```

[↑ Volver al inicio](#arquitectura-del-sistema)

---

## Observabilidad

### Logging Estructurado

- Correlation ID (`X-Trace-ID`) en MDC
- Formato JSON para parseo automático
- Niveles: ERROR (alert), WARN (retry), INFO (important)

```java
MDC.put("traceId", traceId);
log.info("User created: userId={}, email={}", userId, email);
// Output: 2026-04-10 [thread] INFO  CreateUserUseCase - 550e8400 - User created: userId=123
```

### Métricas

- `/actuator/prometheus` — Prometheus exposition
- Custom: use case success/failure, latencia por endpoint

### Tracing

- Micrometer + Spring Cloud Sleuth
- Trace ID propagado en headers

### Health Checks

- `/actuator/health/liveness` — Application liveness
- `/actuator/health/readiness` — Application readiness

[↑ Volver al inicio](#arquitectura-del-sistema)

---

[← Índice](./README.md) | [Siguiente >](./api-reference.md)

