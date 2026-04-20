# Backend: Estrategia de Validación en Capas

**Fase:** 06-development | **Audiencia:** Equipo backend, especialistas en dominio | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Introducción](#introducción)
2. [Principio Fundamental](#principio-fundamental)
3. [Capa 1: HTTP (Request DTOs)](#capa-1-http-request-dtos)
4. [Capa 2: Domain (Value Objects & Helpers)](#capa-2-domain-value-objects--helpers)
5. [Capa 3: Use Case (Orquestación)](#capa-3-use-case-orquestación)
6. [Matriz: Qué Va Dónde](#matriz-qué-va-dónde)
7. [Testing por Capa](#testing-por-capa)
8. [Ejemplo Completo: CreateUser](#ejemplo-completo-createuser)
9. [Checklist: Nuevo Endpoint](#checklist-nuevo-endpoint)
10. [Anti-Patterns](#anti-patterns)

---

## Introducción

La validación en KeyGo ocurre en **3 capas independientes**, cada una con su responsabilidad clara:

1. **HTTP Layer:** Validaciones de formato y restricciones técnicas (no vacío, tamaño, patrón)
2. **Domain Layer:** Reglas de negocio e invariantes (política de contraseña, regex de usuario)
3. **Use Case Layer:** Validaciones contextuales y de estado (unicidad, precondiciones)

**Beneficio principal:** Las reglas de dominio son testables sin HTTP, sin Spring, sin BD. Reutilizables en CLI, eventos, APIs futuras.

---

## Principio Fundamental

> **Una validación pertenece a una capa específica según si:**
> - Es una **restricción de formato/estructura** → HTTP
> - Es una **regla de negocio** → Domain
> - Es **contextual/stateful** → Use Case

**Consecuencia:** Si haces validación de negocio en el controller, pierdes reutilizabilidad. Si haces validación contextual (unicidad) en el Value Object, no puedes testear sin DB.

---

## Capa 1: HTTP (Request DTOs)

### Propósito

Validar **restricciones de formato** que Spring puede chequear sin contexto de negocio:

- No vacío (`@NotBlank`)
- Tamaño límite (`@Size`, `@Digits`)
- Formato básico (`@Email`, `@Pattern`)
- Nulabilidad (`@NotNull`)

### Anotaciones Comunes

```java
@NotBlank(message = "field is required")              // Non-empty string
@NotNull(message = "field cannot be null")             // Non-null
@Size(min = 3, max = 100, message = "...")             // String length
@Digits(integer = 3, fraction = 2, message = "...")    // Numeric precision
@Email(message = "must be valid email")                // Email format
@Pattern(regexp = "...", message = "...")              // Regex match
@Min(value = 0)                                        // Numeric minimum
@Max(value = 100)                                      // Numeric maximum
@URL                                                   // URL format
@UUID                                                  // UUID format
```

### Ejemplo: Request DTO

```java
public record CreateUserRequest(
    @NotBlank(message = "username is required")
    @Size(min = 3, max = 100, message = "username must be 3-100 chars")
    String username,
    
    @NotBlank(message = "email is required")
    @Email(message = "email must be valid format")
    String email,
    
    @NotBlank(message = "password is required")
    @Size(min = 8, message = "password must be at least 8 chars")  // HTTP minimum only
    String password,
    
    @NotBlank(message = "first name is required")
    @Size(max = 50)
    String firstName
) {}
```

### Flujo

```
1. HTTP request llega con JSON
   {
     "username": "john_doe",
     "email": "john@example.com",
     "password": "Pass1234"
   }

2. DispatcherServlet lee @Valid en método
   public ResponseEntity<?> createUser(@Valid @RequestBody CreateUserRequest req)

3. Validación automática:
   ✓ username = "john_doe" → no vacío ✓, length 8 ✓
   ✓ email = "john@example.com" → formato email ✓
   ✓ password = "Pass1234" → length 8 ✓

4a. Si falla → 400 Bad Request con fieldErrors:
   {
     "statusCode": 400,
     "message": "Validation failed",
     "errors": [
       { "field": "email", "message": "must be valid email" }
     ]
   }

4b. Si pasa → continúa a controller/use case
```

### Limitaciones

❌ No puede validar **unicidad** (requiere BD query)
❌ No puede validar **política compleja** (lógica de negocio)
❌ No puede validar **dependencias entre campos** (contextual)
❌ No puede acceder a **repositorios** (sin Spring context)

→ Eso va en Domain o Use Case.

---

## Capa 2: Domain (Value Objects & Helpers)

### Propósito

Validar **reglas de negocio** que se reutilizan independientemente de HTTP/Spring:

- Invariantes de entidades (ej: username no puede contener caracteres especiales)
- Políticas complejas (ej: contraseña debe tener 4 clases de caracteres)
- Lógica reutilizable (ej: validar IBAN, calcular hash)

### Patrón 1: Value Object con Validación en Constructor

Un Value Object es un record con lógica de validación **en el constructor compacto**:

```java
// keygo-domain/src/main/java/.../domain/user/model/Username.java
public record Username(String value) {
  
  private static final String USERNAME_REGEX = "^[a-zA-Z0-9_.\\-]{3,100}$";
  
  public Username {  // Compact constructor: validación automática
    if (value == null || value.isBlank()) {
      throw new IllegalArgumentException("Username cannot be null or blank");
    }
    if (!value.matches(USERNAME_REGEX)) {
      throw new IllegalArgumentException(
          "Username must be 3-100 chars (letters, digits, '_', '-', '.')");
    }
  }
  
  public static Username of(String value) {
    return new Username(value);  // Constructor valida automáticamente
  }
}
```

**Uso:**
```java
// En use case
Username username = Username.of(command.username());
// Si invalid → IllegalArgumentException inmediatamente
// Si valid → Username object garantizado válido
```

### Patrón 2: EmailAddress Value Object

```java
public record EmailAddress(String value) {
  
  private static final String EMAIL_REGEX = 
      "^[a-zA-Z0-9._%+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$";
  
  public EmailAddress {
    if (value == null || value.isBlank()) {
      throw new IllegalArgumentException("Email cannot be null or blank");
    }
    if (!value.matches(EMAIL_REGEX)) {
      throw new IllegalArgumentException("Email has invalid format");
    }
  }
  
  public static EmailAddress of(String value) {
    return new EmailAddress(value);
  }
  
  // Método útil: normalización
  public EmailAddress normalized() {
    return new EmailAddress(value.toLowerCase().trim());
  }
}
```

### Patrón 3: Validation Helper (Stateless)

Para lógica compleja que no es parte de un Value Object:

```java
// keygo-domain/src/main/java/.../domain/user/model/PasswordValidationHelper.java
public final class PasswordValidationHelper {
  
  private static final int MIN_LENGTH_TEMPORARY = 8;
  private static final int MIN_LENGTH_PERMANENT = 12;
  
  /**
   * Valida contraseña según contexto.
   * @param password the raw password to validate
   * @param isTemporary true=generated (relaxed), false=user-defined (strict)
   * @throws InvalidPasswordException if validation fails
   */
  public static void validate(String password, boolean isTemporary) {
    if (isTemporary) {
      validateTemporary(password);
    } else {
      validatePermanent(password);
    }
  }
  
  private static void validateTemporary(String password) {
    if (password == null || password.length() < MIN_LENGTH_TEMPORARY) {
      throw new InvalidPasswordException(
          "temporary password must be at least " + MIN_LENGTH_TEMPORARY + " chars");
    }
  }
  
  private static void validatePermanent(String password) {
    if (password == null || password.length() < MIN_LENGTH_PERMANENT) {
      throw new InvalidPasswordException(
          "password must be at least " + MIN_LENGTH_PERMANENT + " chars");
    }
    if (!password.matches(".*[A-Z].*")) {
      throw new InvalidPasswordException("must contain uppercase letter");
    }
    if (!password.matches(".*[a-z].*")) {
      throw new InvalidPasswordException("must contain lowercase letter");
    }
    if (!password.matches(".*\\d.*")) {
      throw new InvalidPasswordException("must contain digit");
    }
    if (!password.matches(".*[^A-Za-z0-9].*")) {
      throw new InvalidPasswordException("must contain special character");
    }
  }
}
```

**Uso:**
```java
// En use case
PasswordValidationHelper.validate(command.password(), false);  // throws si invalid
```

### Beneficios de Domain Layer

✅ **Reutilizable:** CLI, eventos, test sin Spring
✅ **Testeable:** Unit tests puros, sin BD, sin HTTP
✅ **Expresivo:** El código habla el lenguaje del dominio

---

## Capa 3: Use Case (Orquestación)

### Propósito

Validar **contextual/stateful**:

- Unicidad (email/username ya existe?)
- Precondiciones (tenant está activo? usuario es admin?)
- Dependencias entre agregados

### Ejemplo: CreateUserUseCase

```java
// keygo-app/src/main/java/.../app/user/usecase/CreateUserUseCase.java
public class CreateUserUseCase {
  
  private final TenantRepositoryPort tenantRepositoryPort;
  private final UserRepositoryPort userRepositoryPort;
  private final CredentialEncoderPort credentialEncoderPort;
  
  public User execute(CreateUserCommand command) {
    // 1️⃣ Validación contextual: tenant existe?
    Tenant tenant = tenantRepositoryPort.findBySlug(TenantSlug.of(command.tenantSlug()))
        .orElseThrow(() -> new TenantNotFoundException(command.tenantSlug()));
    
    // 2️⃣ Validación de precondición: tenant está activo?
    if (tenant.isSuspended()) {
      throw new TenantSuspendedException(
          "Cannot create user in suspended tenant: " + command.tenantSlug());
    }
    
    // 3️⃣ Crear Value Objects (valida dominio automáticamente)
    EmailAddress email = EmailAddress.of(command.email());
    Username username = Username.of(command.username());
    // Excepciones lanzadas aquí si formato inválido
    
    // 4️⃣ Validación de unicidad (requiere BD)
    if (userRepositoryPort.existsByTenantIdAndEmail(tenant.getId(), email)) {
      throw new DuplicateEmailException(
          "User with email " + email.value() + " already exists in this tenant");
    }
    
    if (userRepositoryPort.existsByTenantIdAndUsername(tenant.getId(), username)) {
      throw new DuplicateUsernameException(
          "User with username " + username.value() + " already exists in this tenant");
    }
    
    // 5️⃣ Validar política de dominio
    PasswordValidationHelper.validate(command.rawPassword(), false);
    // Excepción si no cumple política
    
    // 6️⃣ Crear entidad (siempre en estado válido)
    String hashedPassword = credentialEncoderPort.encode(command.rawPassword());
    User user = User.builder()
        .tenantId(tenant.getId())
        .username(username)
        .email(email)
        .passwordHash(PasswordHash.of(hashedPassword))
        .firstName(command.firstName())
        .lastName(command.lastName())
        .status(UserStatus.ACTIVE)
        .createdAt(Instant.now())
        .build();
    
    // 7️⃣ Persistir
    return userRepositoryPort.save(user);
  }
}
```

### Excepciones y Mapping a HTTP

Cada excepción se mapea a un ResponseCode HTTP:

```java
// En GlobalExceptionHandler
@ExceptionHandler(TenantNotFoundException.class)
public ResponseEntity<?> handleTenantNotFound(TenantNotFoundException ex) {
  return ResponseEntity.status(404).body(BaseResponse.error(
      404,
      ResponseCode.RESOURCE_NOT_FOUND,
      "Tenant not found: " + ex.getMessage()
  ));
}

@ExceptionHandler(TenantSuspendedException.class)
public ResponseEntity<?> handleTenantSuspended(TenantSuspendedException ex) {
  return ResponseEntity.status(409).body(BaseResponse.error(
      409,
      ResponseCode.BUSINESS_RULE_VIOLATION,
      ex.getMessage()
  ));
}

@ExceptionHandler(DuplicateEmailException.class)
public ResponseEntity<?> handleDuplicateEmail(DuplicateEmailException ex) {
  return ResponseEntity.status(409).body(BaseResponse.error(
      409,
      ResponseCode.BUSINESS_RULE_VIOLATION,
      ex.getMessage()
  ));
}

@ExceptionHandler(InvalidPasswordException.class)
public ResponseEntity<?> handleInvalidPassword(InvalidPasswordException ex) {
  return ResponseEntity.status(400).body(BaseResponse.error(
      400,
      ResponseCode.INVALID_INPUT,
      "Password validation failed: " + ex.getMessage()
  ));
}
```

---

## Matriz: Qué Va Dónde

| Validación | Ejemplo | Capa | Mecanismo | Excepción |
|---|---|---|---|---|
| No vacío | email required | HTTP | `@NotBlank` | 400 INVALID_INPUT |
| Tamaño límite | max 255 chars | HTTP | `@Size` | 400 INVALID_INPUT |
| Formato básico | email@domain.com | HTTP | `@Email` | 400 INVALID_INPUT |
| Invariante VO | username regex | Domain | Value Object constructor | IllegalArgumentException |
| Política compleja | password 4 clases | Domain | Helper static | InvalidPasswordException |
| Unicidad | email exists? | Use Case | Repository.existsBy() | 409 BUSINESS_RULE_VIOLATION |
| Precondición | tenant active? | Use Case | Repository state check | 409 BUSINESS_RULE_VIOLATION |
| Dependencia campos | pwd ≠ old_pwd | Use Case | Custom logic | 409 BUSINESS_RULE_VIOLATION |

---

## Testing por Capa

### HTTP Layer: Unit Tests (Request Validation)

```java
@Test
void createUserRequest_emptyUsername_fails() {
  CreateUserRequest req = new CreateUserRequest(
      "",  // empty username
      "john@example.com",
      "Pass1234",
      "John"
  );
  
  // Spring @Valid aplicaría estas validaciones
  // En test manual: asumir que Spring las ejecuta
  Set<ConstraintViolation<CreateUserRequest>> violations = validator.validate(req);
  assertThat(violations).isNotEmpty();
  assertThat(violations.stream().anyMatch(v -> v.getPropertyPath().toString().equals("username")))
      .isTrue();
}

@Test
void createUserRequest_invalidEmail_fails() {
  CreateUserRequest req = new CreateUserRequest(
      "john_doe",
      "invalid-email",  // not valid email
      "Pass1234",
      "John"
  );
  
  Set<ConstraintViolation<CreateUserRequest>> violations = validator.validate(req);
  assertThat(violations).isNotEmpty();
}
```

### Domain Layer: Unit Tests (No Spring, No DB)

```java
@Test
void username_validFormat_succeeds() {
  Username username = Username.of("john_doe");
  assertThat(username.value()).isEqualTo("john_doe");
}

@Test
void username_tooShort_throws() {
  assertThrows(IllegalArgumentException.class, () -> Username.of("ab"));
}

@Test
void username_specialChars_throws() {
  assertThrows(IllegalArgumentException.class, () -> Username.of("john@doe"));
}

@Test
void passwordValidation_permanent_tooShort() {
  assertThrows(InvalidPasswordException.class,
      () -> PasswordValidationHelper.validate("Short1!", false));
}

@Test
void passwordValidation_permanent_missingUppercase() {
  assertThrows(InvalidPasswordException.class,
      () -> PasswordValidationHelper.validate("alllowercase123!", false));
}

@Test
void emailAddress_validFormat_succeeds() {
  EmailAddress email = EmailAddress.of("john@example.com");
  assertThat(email.value()).isEqualTo("john@example.com");
}
```

### Use Case Layer: Integration Tests (With DB/Mocks)

```java
@SpringBootTest
class CreateUserUseCaseTest {
  
  @Autowired private CreateUserUseCase createUserUseCase;
  @Autowired private TenantRepository tenantRepository;
  @Autowired private UserRepository userRepository;
  
  @Test
  void execute_validCommand_succeeds() {
    // Setup
    Tenant tenant = tenantRepository.save(Tenant.builder()
        .slug(TenantSlug.of("acme"))
        .name("Acme Corp")
        .status(TenantStatus.ACTIVE)
        .build());
    
    // Act
    CreateUserCommand command = new CreateUserCommand(
        "acme", "john_doe", "john@example.com", "SecurePass123!", "John", "Doe");
    
    User user = createUserUseCase.execute(command);
    
    // Assert
    assertThat(user.getId()).isNotNull();
    assertThat(user.getUsername()).isEqualTo(Username.of("john_doe"));
    assertThat(user.getEmail()).isEqualTo(EmailAddress.of("john@example.com"));
    assertThat(user.getStatus()).isEqualTo(UserStatus.ACTIVE);
  }
  
  @Test
  void execute_tenantNotFound_throws() {
    CreateUserCommand command = new CreateUserCommand(
        "non-existent-tenant", "john_doe", "john@example.com", "SecurePass123!", "John", "Doe");
    
    assertThrows(TenantNotFoundException.class, () -> createUserUseCase.execute(command));
  }
  
  @Test
  void execute_tenantSuspended_throws() {
    // Setup: suspended tenant
    Tenant tenant = tenantRepository.save(Tenant.builder()
        .slug(TenantSlug.of("suspended-org"))
        .status(TenantStatus.SUSPENDED)
        .build());
    
    CreateUserCommand command = new CreateUserCommand(
        "suspended-org", "john_doe", "john@example.com", "SecurePass123!", "John", "Doe");
    
    assertThrows(TenantSuspendedException.class, () -> createUserUseCase.execute(command));
  }
  
  @Test
  void execute_duplicateEmail_throws() {
    // Setup: user already exists
    Tenant tenant = tenantRepository.save(Tenant.builder()
        .slug(TenantSlug.of("acme"))
        .status(TenantStatus.ACTIVE)
        .build());
    
    User existing = userRepository.save(User.builder()
        .tenantId(tenant.getId())
        .username(Username.of("existing_user"))
        .email(EmailAddress.of("john@example.com"))
        .build());
    
    // Act & Assert
    CreateUserCommand command = new CreateUserCommand(
        "acme", "john_doe", "john@example.com", "SecurePass123!", "John", "Doe");
    
    assertThrows(DuplicateEmailException.class, () -> createUserUseCase.execute(command));
  }
  
  @Test
  void execute_invalidPassword_throws() {
    Tenant tenant = tenantRepository.save(Tenant.builder()
        .slug(TenantSlug.of("acme"))
        .status(TenantStatus.ACTIVE)
        .build());
    
    CreateUserCommand command = new CreateUserCommand(
        "acme", "john_doe", "john@example.com", "weak", "John", "Doe");  // weak password
    
    assertThrows(InvalidPasswordException.class, () -> createUserUseCase.execute(command));
  }
}
```

---

## Ejemplo Completo: CreateUser

### 1. Request llega

```
POST /api/v1/tenants/acme/users
Content-Type: application/json

{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "SecurePass123!",
  "firstName": "John",
  "lastName": "Doe"
}
```

### 2. HTTP Layer Valida

```java
@PostMapping("/api/v1/tenants/{tenantSlug}/users")
public ResponseEntity<BaseResponse<UserData>> createUser(
    @PathVariable String tenantSlug,
    @Valid @RequestBody CreateUserRequest request) {  // ← Spring ejecuta @Valid aquí
  
  // Si falla: 400 INVALID_INPUT con fieldErrors
  // Si pasa: continúa
  
  CreateUserCommand command = CreateUserCommand.from(tenantSlug, request);
  User user = createUserUseCase.execute(command);  // ← Pasa a use case
  
  return ResponseEntity.status(201).body(
      BaseResponse.success(userMapper.toData(user)));
}
```

### 3. Use Case Orquesta

```java
public User execute(CreateUserCommand command) {
  // Validación contextual: tenant existe?
  Tenant tenant = tenantRepositoryPort.findBySlug(TenantSlug.of(command.tenantSlug()))
      .orElseThrow(() -> new TenantNotFoundException(command.tenantSlug()));
  // ↑ Falla → 404
  
  // Precondición: tenant activo?
  if (tenant.isSuspended()) {
    throw new TenantSuspendedException(command.tenantSlug());
  }
  // ↑ Falla → 409
  
  // Domain: crear Value Objects (valida automáticamente)
  Username username = Username.of(command.username());
  // ↑ Falla si regex no coincide → 400
  
  // Domain: validar política
  PasswordValidationHelper.validate(command.password(), false);
  // ↑ Falla si débil → 400
  
  // Use Case: verificar unicidad
  if (userRepositoryPort.existsByTenantIdAndEmail(tenant.getId(), email)) {
    throw new DuplicateEmailException(email.value());
  }
  // ↑ Falla → 409
  
  // Create + Save
  User user = User.builder()...build();
  return userRepositoryPort.save(user);
}
```

### 4. Global Exception Handler Mapea

```java
TenantNotFoundException → 404 RESOURCE_NOT_FOUND
TenantSuspendedException → 409 BUSINESS_RULE_VIOLATION
IllegalArgumentException (from VO) → 400 INVALID_INPUT
InvalidPasswordException → 400 INVALID_INPUT
DuplicateEmailException → 409 BUSINESS_RULE_VIOLATION
```

### 5. Response

**Si éxito (201):**
```json
{
  "statusCode": 201,
  "message": "User created successfully",
  "data": {
    "id": "user-uuid-123",
    "username": "john_doe",
    "email": "john@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "status": "ACTIVE",
    "createdAt": "2025-01-15T10:30:00Z"
  }
}
```

**Si falla validación HTTP (400):**
```json
{
  "statusCode": 400,
  "message": "Validation failed",
  "errors": [
    { "field": "email", "message": "must be valid email format" }
  ]
}
```

**Si falla precondición (409):**
```json
{
  "statusCode": 409,
  "message": "Business rule violation",
  "errors": [
    {
      "code": "TENANT_SUSPENDED",
      "message": "Cannot create user in suspended tenant"
    }
  ]
}
```

---

## Checklist: Nuevo Endpoint

Cuando agregues un nuevo endpoint con validación:

- [ ] **HTTP Layer:** ¿Qué restricciones de formato? (@NotBlank, @Size, @Email, @Pattern)
- [ ] **Domain Layer:** ¿Qué reglas de negocio? (Value Objects, Helpers, invariantes)
- [ ] **Use Case Layer:** ¿Qué validaciones contextuales? (Unicidad, estado, precondiciones)
- [ ] **Exception Mapping:** Cada excepción mapea a ResponseCode HTTP correcto (4xx vs 5xx)
- [ ] **Tests:** 
  - [ ] HTTP layer: request validation (constraints)
  - [ ] Domain layer: value objects, helpers (unit, sin Spring)
  - [ ] Use case layer: contextual validations (integration con DB)
- [ ] **Documentation:** ERROR_CATALOG.md actualizado con nuevos response codes

---

## Anti-Patterns

### ❌ Anti-Pattern 1: Validar en Controller

```java
// MAL
@PostMapping("/users")
public void createUser(@RequestParam String email) {
  if (email.contains("@")) {  // ← Validación de negocio en controller
    createUserUseCase.execute(...);
  }
}
// Problema: Se pierde cuando llamas use case desde CLI, eventos, etc.
```

**✅ Mejor:**
```java
// BIEN
@PostMapping("/users")
public void createUser(@RequestParam @Email String email) {  // ← HTTP layer
  // Controller solo orquesta
  createUserUseCase.execute(command);  // ← Domain + Use Case validan
}
```

### ❌ Anti-Pattern 2: Validación Contextual en Domain

```java
// MAL
public record Username(String value) {
  public Username {
    // Intenta acceder a BD para validar unicidad
    if (userRepository.existsByUsername(value)) {  // ← ¡No se puede!
      throw new Exception("Username already taken");
    }
  }
}
// Problema: Value Object no puede depender de repositorio
```

**✅ Mejor:**
```java
// BIEN (Domain: solo invariante)
public record Username(String value) {
  public Username {
    if (!value.matches("^[a-zA-Z0-9_]{3,100}$")) {
      throw new IllegalArgumentException("Invalid username format");
    }
  }
}

// MEJOR (Use Case: validar unicidad)
public User execute(CreateUserCommand command) {
  Username username = Username.of(command.username());  // ← Domain valida formato
  if (userRepo.existsByUsername(username)) {  // ← Use Case valida contexto
    throw new DuplicateUsernameException();
  }
  // ...
}
```

### ❌ Anti-Pattern 3: Hardcodear Mensaje de Error

```java
// MAL
throw new IllegalArgumentException("Username must be between 3 and 100 characters");

// MEJOR
private static final String USERNAME_LENGTH_ERROR = "must be 3-100 chars (letters, digits, '_')";
throw new IllegalArgumentException(USERNAME_LENGTH_ERROR);
```

### ❌ Anti-Pattern 4: Exception Genérica

```java
// MAL
throw new Exception("Validation failed");  // ¿Qué falló? ¿Cuál es el HTTP status?

// MEJOR
throw new DuplicateEmailException("Email already registered: " + email);
// Global handler mapea a 409 BUSINESS_RULE_VIOLATION
```

---

## Véase También

- **architecture.md** — Cómo se organizan capas (HTTP → Domain → Application)
- **coding-standards.md** — Convenciones de nombres (Value Objects, Exceptions)
- **api-endpoints-comprehensive.md** — Ejemplos de endpoints con validación
- **api-versioning-strategy.md** — Cómo versionar cambios en validaciones

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Equipo Backend | **Licencia:** Keygo Docs
