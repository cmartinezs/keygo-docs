[← Índice](./README.md) | [< Anterior](./api-reference.md) | [Siguiente >](./workflow.md)

---

# Coding Standards

Convenciones de código, naming, estructura y principios de diseño, con énfasis en **Ubiquitous Language** — garantizar que el código refleja el lenguaje del dominio.

## Contenido

- [Principios de Diseño](#principios-de-diseño)
- [Ubiquitous Language en Código](#ubiquitous-language-en-código)
- [Naming](#naming)
- [Estructura de Paquetes](#estructura-de-paquetes)
- [Convenciones Java](#convenciones-java)
- [Reglas de Calidad](#reglas-de-calidad)
- [Patrones a Evitar](#patrones-a-evitar)

---

## Principios de Diseño

| Principio | Descripción | Aplicación |
|----------|-------------|-----------|
| **SOLID** | SRP, OCP, LSP, ISP, DIP | Interfaces pequeñas, dependencias explícitas |
| **DRY** | Don't Repeat Yourself | Utilidades reutilizables, no duplicación |
| **KISS** | Keep It Simple, Stupid | Soluciones simples primero, complejidad justificada |
| **Clean Code** | Legible, mantenible, testeable | Nombres significativos, métodos pequeños |
| **YAGNI** | You Aren't Gonna Need It | No agregar funcionalidad que no se necesite |
| **DDD** | Domain-Driven Design | El código habla el lenguaje del negocio, no el técnico |

[↑ Volver al inicio](#coding-standards)

---

## Ubiquitous Language en Código

El **ubiquitous language** es el lenguaje compartido entre expertos del dominio y desarrolladores. Se expresa en nombres de clases, métodos y variables. Si el código usa nombres técnicos en lugar de dominio, el lenguaje se pierde.

### Regla de Oro

> **Si un experto de negocio no puede leer el nombre de una clase o método y entender qué hace, el nombre es técnico, no de dominio.**

### Anti-patrones: Nombres Técnicos ❌

| Técnico | Dominio ✅ | Por qué |
|---------|-----------|--------|
| `DataProcessor` | `IdentityAuthenticator` | El código no procesa datos genéricos; autentica identidades |
| `Manager` | `RoleAssigner` | "Manager" es un patrón tecnico; "Assigner" es una acción de dominio |
| `Service` (genérico) | `AuthenticationService`, `AccessEvaluator` | Se entiende qué servicio específico es |
| `Helper` | `PasswordValidator` | "Helper" no comunica intent; "Validator" es específico |
| `Processor` | `ClaimProcessor` | En el contexto de seguros, se "procesan" claims; nómbralo así |
| `Utils` | `DateCalculator`, `EmailFormatter` | Utilidades genéricas van a `shared/`; pero sus métodos específicos |
| `request`/`response` (genéricos) | `RegisterUserRequest`, `UserProfileData` | El tipo de request/response siempre acompañar al sustantivo |

### Ejemplo: Ubicación de Lenguaje en Componentes

**Identity Context (Core Domain):**

```java
// ✅ CORRECTO: Lenguaje de dominio en todos lados
public class Identity {                     // Concepto del dominio
  private IdentityId id;                    // Value Object
  private EmailAddress email;               // Value Object
  private HashedPassword hashedPassword;    // Value Object: abstrae la técnica de hash
  
  public void authenticate(PlainPassword password) {
    if (!hashedPassword.matches(password)) {
      throw new AuthenticationFailedException();
    }
  }
}

public class AuthenticationFailedException extends DomainException { }

@Component
public class RegisterIdentityUseCase {      // Caso de uso específico
  private final IdentityFactory factory;
  
  public Identity execute(RegisterIdentityCommand cmd) {
    Identity identity = factory.createNewIdentity(
        EmailAddress.of(cmd.email()),
        cmd.password(),
        cmd.platformRole());
    return identityRepository.save(identity);
  }
}

// ❌ EVITAR: Naming técnico
public class UserProcessor { }              // Qué procesa?
public class AuthService { }                // Todos tienen "Service"
public void handleRequest(Object obj) { }   // "request" sin contexto, "handle" sin acción
```

**Access Control Context (Core Domain):**

```java
// ✅ CORRECTO
public class Role {                         // Agregado
  private RoleId id;
  private List<Permission> permissions;
  
  public boolean permits(Permission permission) {
    return permissions.contains(permission);
  }
}

public class Membership {                   // Agregado: relación entre Sujeto y Rol
  private MembershipId id;
  private IdentityId subjectId;
  private RoleId roleId;
  private ApplicationId applicationId;
}

public interface RoleRepositoryPort {
  PagedResult<Role> findByTenant(TenantSlug tenant, RoleFilter filter);
  Role save(Role role);
}

// ❌ EVITAR
public class PermissionManager { }
public PagedResult<RoleDTO> getRoles() { }  // "getRoles" vs "findByTenant()"
```

### Variables y Métodos: Lenguaje de Dominio

| Técnico | Dominio ✅ | Contexto |
|---------|-----------|---------|
| `data` | `identity`, `charge`, `subscription` | Sé específico sobre qué dato |
| `handle()` | `authenticate()`, `authorize()`, `evaluate()` | Cada acción tiene un nombre en el dominio |
| `process()` | `claimAdjuster.evaluate()`, `underwriter.underwrite()` | Nombres de verbos del dominio |
| `x`, `temp`, `aux` | Evitar; si necesitas, es variable temporal en scope pequeño | Local scopes solamente |
| `validate()` (genérico) | `validateEmailFormat()`, `validateOrganizationActive()` | Sé específico sobre qué se valida |
| `map()` (en traducción) | `toPaymentTransaction()`, `toDomainModel()`, `toIdentity()` | Dirección clara: de→a |

### Métodos: Comandos vs Queries

En el lenguaje del dominio:

- **Comandos** (acciones que cambian estado): Verbos activos en presente
  - `authenticate()`, `authorize()`, `suspend()`, `assignRole()`, `updateProfile()`
- **Queries** (lectura, sin efectos secundarios): Preguntas o nombres sustantivos
  - `canAccess()`, `hasPermission()`, `isActive()`, `findByEmail()`, `getActiveMembers()`

```java
// ✅ CORRECTO
public interface RoleRepositoryPort {
  Optional<Role> findById(RoleId id);             // Query
  PagedResult<Role> findByTenant(TenantSlug t);  // Query
  Role save(Role role);                            // Command (persiste)
  void deleteById(RoleId id);                      // Command (modifica)
}

public class AccessEvaluator {
  public boolean canAccess(Subject subject, Resource resource) { }  // Query
  public void assignRole(Subject subject, Role role) { }            // Command
}

// ❌ EVITAR
public Role getRole(RoleId id) { }                 // "get" vs "find"
public void processRole(Role role) { }             // "process" no dice qué
public boolean evaluate(Subject s) { }             // "evaluate" genérico; "canAccess" es claro
```

[↑ Volver al inicio](#coding-standards)

[↑ Volver al inicio](#coding-standards)

---

## Naming

### Clases por Tipo

| Tipo | Sufijo / Convención | Ejemplo | Módulo |
|------|------------------|--------|---------|
| Use Case | `<Acción><Entidad>UseCase` | `CreateUserUseCase` | `keygo-app` |
| Puerto OUT | `<Entidad>Provider` | `UserProvider` | `keygo-app` |
| Controlador | `<Entidad>Controller` | `UserController` | `keygo-api` |
| DTO Respuesta | `<Entidad>Data` | `UserData` | `keygo-api` |
| DTO Petición | `<Entidad>Request` | `CreateUserRequest` | `keygo-api` |
| Entidad JPA | `<Entidad>Entity` | `UserEntity` | `keygo-supabase` |
| Repositorio JPA | `<Entidad>Repository` | `UserRepository` | `keygo-supabase` |
| Adaptador | `<Entidad>RepositoryAdapter` | `UserRepositoryAdapter` | `keygo-supabase` |
| Mapper | `<Entidad>PersistenceMapper` | `UserPersistenceMapper` | `keygo-supabase` |
| Excepción | `<Concepto>Exception` | `UserNotFoundException` | `keygo-domain` |
| Value Object | `<Concepto>Value` o Domain Type | `EmailAddress` | `keygo-domain` |

### Paquetes por Feature

```
io.cmartinezs.keygo.<módulo>/
  <feature>/
    controller/
    response/
    request/
    port/
    usecase/
    entity/
    repository/
  shared/
  error/
  config/
```

[↑ Volver al inicio](#coding-standards)

---

## Convenciones Java

### Formato

| Regla | Valor |
|-------|-------|
| Indentación | 2 espacios |
| Longitud máxima de línea | 100 caracteres |
| Encoding | UTF-8 |
| Final de línea | LF (Unix) |

### Imports

- Sin wildcard: `import java.util.*` — ❌
- Orden: Java → Jakarta → Spring → Third-party → Proyecto interno

### Anotaciones Lombok

```java
@Getter              // Solo donde necesario
@Setter              // Evitar en entidades JPA (@Data es malo)
@Builder            // Para builders
@RequiredArgsConstructor  // Inyección de dependencias
@Slf4j              // Logging
```

### Javadoc

- Toda clase pública → Javadoc
- Métodos complejos → Javadoc con `@param`, `@return`
- Comentar el **por qué**, no el **qué**

[↑ Volver al inicio](#coding-standards)

---

## Estructura de Paquetes

### Por Feature, No Por Capa

```
MAL (por capa):
┌─────────────────────────────────┐
│ io.cmartinezs.keygo.domain/       │
│   controllers/                   │
│   services/                      │
│   repositories/                  │
└─────────────────────────────────┘

BIEN (por feature):
┌─────────────────────────────────┐
│ io.cmartinezs.keygo.user/         │
│   controller/  (keygo-api)      │
│   response/    (keygo-api)       │
│   port/       (keygo-app)        │
│   usecase/    (keygo-app)        │
│   entity/    (keygo-supabase)   │
│   repository/(keygo-supabase)   │
└─────────────────────────────────┘
```

[↑ Volver al inicio](#coding-standards)

---

## Reglas de Calidad

### Tests Unitarios

```java
@ExtendWith(MockitoExtension.class)
class CreateUserUseCaseTest {

  @Test
  void execute_whenEmailExists_throwsDuplicateException() {
    // Given
    when(userRepository.existsByEmail(any())).thenReturn(true);

    // When / Then
    assertThatThrownBy(() -> useCase.execute(cmd))
        .isInstanceOf(DuplicateUserException.class);
  }
}
```

- Framework: JUnit 5 + Mockito + AssertJ
- Sin Spring context en unit tests
- Estructura: `// Given / When / Then`

### Enforcer Plugin

```bash
./mvnw validate
```

- Java 21+
- Maven 3.9+
- UTF-8
- Sin dependencias duplicadas

[↑ Volver al inicio](#coding-standards)

---

## Patrones a Evitar

### ❌ Lógica de Negocio en Controllers

```java
@PostMapping("/users")
public void create(@RequestBody CreateUserRequest req) {
  // MALO: lógica aquí
  if (userRepository.existsByEmail(req.email())) {
    throw new BadRequestException();
  }
  User user = new User(req.email());
  userRepository.save(user);
}
```

### ✅ Lógica en Use Case

```java
public class CreateUserUseCase {
  public User execute(CreateUserCommand cmd) {
    EmailAddress email = EmailAddress.of(cmd.email());
    if (userRepository.existsByEmail(email)) {
      throw new DuplicateUserException();
    }
    return userRepository.save(User.builder().email(email).build());
  }
}
```

### ❌ N+1 Queries

```java
List<User> users = userRepository.findAll();
for (User user : users) {
  List<Membership> memberships = membershipRepository.findByUserId(user.getId());
  // 1 + N queries
}
```

### ✅ Eager Loading o Join

```java
Specification<UserEntity> spec = (root, query, cb) -> {
  root.fetch("memberships", JoinType.LEFT);
  return cb.conjunction();
};
```

### ❌ Transacciones Largas

```java
@Transactional
public void processBatch() {
  for (User user : users) {
    emailService.send(user.getEmail());  // HTTP dentro de TX
  }
}
```

### ✅ Transacciones Acotadas

```java
@Transactional(readOnly = true)
public List<User> getUsers() { return userRepository.findAll(); }

public void processBatch() {
  List<User> users = getUsers();  // TX termina
  for (User user : users) {
    emailService.send(user.getEmail()); // Sin TX
  }
}
```

### ❌ Entidades Enormes

```java
@Entity
public class User {
  // 50 campos
  // Trae todo aunque solo necesites email
}
```

### ✅ DTOs Específicos

```java
public record UserSummaryDto(String username, String email) {}

@Query("SELECT new dto.UserSummaryDto(u.username, u.email) FROM User u WHERE u.id = :id")
UserSummaryDto findSummary(@Param("id") UUID id);
```

[↑ Volver al inicio](#coding-standards)

---

[← Índice](./README.md) | [< Anterior](./api-reference.md) | [Siguiente >](./workflow.md)