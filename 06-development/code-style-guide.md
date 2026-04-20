# Development: Code Style & Conventions

**Fase:** 06-development | **Audiencia:** Backend developers | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Formatting](#formatting)
2. [Naming Conventions](#naming-conventions)
3. [Package Structure](#package-structure)
4. [Comments & Documentation](#comments--documentation)
5. [Tooling](#tooling)

---

## Formatting

### Basics

| Rule | Value |
|------|-------|
| **Indentation** | 2 spaces (no tabs) |
| **Max line length** | 100 characters |
| **File encoding** | UTF-8 |
| **Line ending** | LF (Unix) |
| **Blank lines** | 1 between methods, 2 between classes |

### Example

```java
package io.keygo.auth.domain;

import java.time.Instant;

/**
 * Represents a user in the identity context.
 */
public class User {
  private final String id;
  private final String email;
  private final String passwordHash;
  
  public User(String id, String email, String passwordHash) {
    this.id = id;
    this.email = email;
    this.passwordHash = passwordHash;
  }
  
  public String id() { return id; }
  
  public String email() { return email; }
}
```

---

## Naming Conventions

### Classes by Architectural Role

| Type | Suffix | Example | Module |
|------|--------|---------|--------|
| **Use Case** | `<Action><Entity>UseCase` | `GetServiceInfoUseCase` | keygo-app |
| **Port (interface)** | `<Entity>Provider` or `<Entity>Port` | `TenantProvider` | keygo-app |
| **Controller** | `<Entity>Controller` | `TenantController` | keygo-api |
| **Response DTO** | `<Entity>Response` | `TenantResponse` | keygo-api |
| **Request DTO** | `<Entity>Request` | `CreateTenantRequest` | keygo-api |
| **JPA Entity** | `<Entity>Entity` | `UserEntity` | keygo-persistence |
| **Repository** | `<Entity>Repository` | `UserRepository` | keygo-persistence |
| **Repository Adapter** | `<Entity>RepositoryAdapter` | `TenantRepositoryAdapter` | keygo-persistence |
| **Mapper** | `<Entity>Mapper` | `TenantPersistenceMapper` | keygo-persistence |
| **Configuration** | `<Feature>Config` | `SecurityConfig` | keygo-bootstrap |
| **Filter** | `<Feature>Filter` | `TenantContextFilter` | keygo-bootstrap |
| **Exception** | `<Concept>Exception` | `TenantNotFoundException` | keygo-domain |
| **Value Object** | `<Concept>` (no suffix) | `Email`, `Username`, `TenantSlug` | keygo-domain |

### Methods and Variables

```java
// ✅ GOOD: Clear, business-focused names
public void suspendTenant(TenantId id, String reason) { }
public Optional<User> findByEmail(Email email) { }
private void validateBillingConfiguration() { }
private boolean isContractExpired(Contract contract) { }

// ❌ BAD: Generic, unclear names
public void process(String data) { }
public void handle(Object obj) { }
private void checkStuff() { }
private boolean validate() { }
```

### Constants

```java
// ✅ GOOD: Uppercase with underscores
private static final int MAX_FAILED_ATTEMPTS = 5;
private static final Duration TOKEN_EXPIRATION = Duration.ofHours(1);
private static final String DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss'Z'";

// ❌ BAD: Lowercase or inconsistent
private static final int max = 5;
private static final int MAXFAILEDATTEMPTS = 5;
```

---

## Package Structure

Organize by **feature**, not by technical layer:

```
com.keygo/
├── tenant/                    # Feature: Tenant management
│   ├── controller/           # REST endpoints
│   ├── request/              # Request DTOs
│   ├── response/             # Response DTOs
│   ├── usecase/              # Business logic (application layer)
│   ├── port/                 # Outbound ports/interfaces
│   ├── entity/               # JPA entities
│   ├── repository/           # Spring Data repositories
│   └── persistence/          # Repository adapters, mappers
│
├── auth/                     # Feature: Authentication
│   ├── controller/
│   ├── request/
│   ├── response/
│   ├── usecase/
│   ├── port/
│   ├── entity/
│   └── repository/
│
├── shared/                   # Cross-cutting utilities
│   ├── response/             # Response envelope, error codes
│   ├── exception/            # Global exception handlers
│   └── util/                 # Utilities (Mappers, Validators, etc.)
│
└── config/                   # Spring configuration
    ├── SecurityConfig.java
    ├── JpaConfig.java
    └── WebConfig.java
```

### Benefits

- ✅ Related code grouped together
- ✅ Easy to understand feature scope
- ✅ Reduces cognitive load when reading related classes
- ✅ Clear boundaries between features

---

## Comments & Documentation

### Javadoc

**Required for:**
- All public classes
- All public methods in classes
- Complex algorithms
- Non-obvious behavior

**Not required for:**
- Getters/setters (unless they do something special)
- Override methods (unless adding new info)

### Example

```java
/**
 * Represents a user's email address in the identity context.
 * 
 * Enforces validation rules:
 * - Email must be valid (RFC 5322)
 * - Email must be lowercase
 * - Email must be non-empty
 */
public class Email {
  private final String value;
  
  /**
   * Creates an Email, validating format and case.
   * 
   * @param value raw email string
   * @throws InvalidEmailException if format invalid or case incorrect
   */
  public Email(String value) {
    this.value = validate(value);
  }
  
  /**
   * Returns the email value in lowercase.
   * 
   * @return normalized email
   */
  public String value() {
    return value;
  }
}
```

### Inline Comments

**Comment the WHY, not the WHAT:**

```java
// ❌ BAD: Comments state the obvious
int age = currentYear - birthYear;  // Subtract birth year from current year
for (User user : users) {           // Loop through users
  if (user.isActive()) {            // Check if user is active
    count++;                        // Increment count
  }
}

// ✅ GOOD: Comments explain business logic
// Tenants can only see users from their own tenant; filter out others
List<User> visibleUsers = users.stream()
  .filter(u -> u.tenantId().equals(currentTenant))
  .collect(toList());

// Retry with exponential backoff (1s, 2s, 4s, 8s, 16s max)
// to account for Stripe API rate limits during high load
int delayMs = Math.min(1000 * (int) Math.pow(2, retryCount), 16000);
```

---

## Tooling

### Maven Enforcer Plugin

Validates project structure on build:

```bash
mvn validate
```

Checks:
- Java version >= 21
- Maven version >= 3.9
- Encoding UTF-8
- No duplicate dependencies

### Format Validation

Consider adding to your build:

```bash
# Check formatting without applying
mvn spotless:check

# Apply formatting
mvn spotless:apply
```

### Code Coverage

Run tests with coverage report:

```bash
mvn verify
# Report: target/site/jacoco/index.html
```

Target minimum coverage:
- **Value Objects**: 95%+
- **Aggregates**: 90%+
- **Use Cases**: 80%+
- **Controllers**: 70%+

---

## Anti-Patterns

### ❌ Generic Classes/Methods

```java
// BAD: Generic names hide intent
public class DataProcessor { }
public void process(Object data) { }
public List<Object> handleData(String input) { }
```

**Better:**
```java
// GOOD: Domain-focused names
public class TenantInvitationService { }
public void sendInvitations(Set<Email> recipients) { }
public List<TenantInvitation> createBulkInvitations(String csvData) { }
```

### ❌ God Objects

```java
// BAD: One class doing everything
public class UserService {
  public void createUser() { }
  public void updateUser() { }
  public void deleteUser() { }
  public void sendEmail() { }
  public void generateReport() { }
  public void updateBilling() { }
}
```

**Better:**
```java
// GOOD: Separate concerns
public class CreateUserUseCase { }
public class UpdateUserProfileUseCase { }
public class GenerateUserReportUseCase { }
```

### ❌ Data Classes with All Logic

```java
// BAD: Entity carrying business logic
public class UserEntity {
  private String email;
  private boolean active;
  
  public boolean validatePassword(String input) { }
  public void sendResetEmail() { }
  public void updateSubscription() { }
}
```

**Better:**
```java
// GOOD: Separate domain logic from persistence
public class User {  // Domain model
  public void resetPassword(PasswordReset reset) { }
}

public class UserEntity {  // Persistence model
  // Only fields, no logic
}
```

---

## Véase También

- **validation-strategy.md** — Validation patterns
- **api-endpoints-comprehensive.md** — API naming and structure
- **frontend-project-structure.md** — Frontend code organization

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Backend | **Licencia:** Keygo Docs
