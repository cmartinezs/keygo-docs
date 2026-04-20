[← Índice](./README.md) | [< Anterior](./unit-test-coverage.md) | [Siguiente >](./integration-tests.md)

---

# Test Plans por Bounded Context

Planes de testing específicos por Bounded Context y módulo, con énfasis en testing de agregados, value objects y domain events.

## Contenido

- [Identity Context (Core Domain)](#identity-context-core-domain)
- [Access Control Context (Core Domain)](#access-control-context-core-domain)
- [Organization Context (Supporting)](#organization-context-supporting)
- [Client Applications Context (Supporting)](#client-applications-context-supporting)
- [Billing Context (Supporting)](#billing-context-supporting)
- [Audit Context (Supporting)](#audit-context-supporting)
- [Platform Context (Supporting)](#platform-context-supporting)

---

## Identity Context (Core Domain)

**Módulo principal**: `io.cmartinezs.keygo.identity`

**Agregados y Value Objects**:
- `Identity` (Aggregate Root): ID, email, contraseña, estado, roles
- `EmailAddress` (Value Object): validación de formato
- `HashedPassword` (Value Object): validación y comparación segura
- `IdentityStatus` (Enum): ACTIVE, SUSPENDED

**Eventos de Dominio**:
- `IdentityCreatedEvent`
- `IdentityAuthenticatedEvent`
- `IdentityPasswordChangedEvent`
- `IdentitySuspendedEvent`

### Unit Tests

```gherkin
Scenario: Crear una nueva identidad con email válido
  Given un email válido
  And una contraseña válida
  When se crea una identidad
  Then se genera un ID único
  And se emite IdentityCreatedEvent
  And el estado es ACTIVE

Scenario: Autenticar identidad con contraseña correcta
  Given una identidad con contraseña hasheada
  When se autentica con la contraseña correcta
  Then retorna true
  And se emite IdentityAuthenticatedEvent

Scenario: Autenticar identidad con contraseña incorrecta
  Given una identidad con contraseña hasheada
  When se autentica con la contraseña incorrecta
  Then lanza AuthenticationFailedException
  And NO se emite IdentityAuthenticatedEvent

Scenario: Cambiar contraseña
  Given una identidad activa
  When se cambia a una nueva contraseña válida
  Then se actualiza el hash
  And se emite IdentityPasswordChangedEvent
  And se invalidan todas las sesiones activas

Scenario: Suspender identidad
  Given una identidad activa
  When se suspende
  Then el estado cambia a SUSPENDED
  And se emite IdentitySuspendedEvent
  And todas las sesiones se invalidan inmediatamente
```

### Integration Tests

```gherkin
Scenario: Registro de identidad completo (API → DB)
  Given POST /api/v1/identities con email y password
  When se ejecuta la petición
  Then se retorna 201 Created
  And la identidad se persiste en BD
  And se puede consultar por email
  And la contraseña está hasheada

Scenario: Login genera sesión válida
  Given una identidad registrada
  When POST /api/v1/identities/{id}/authenticate
  Then se retorna 200 OK con token JWT
  And el token contiene identity_id y tenant_id
  And el token es verificable sin consultar la BD
```

### Cobertura Mínima: 90%

| Componente | Mínimo | Objetivo |
|-----------|--------|----------|
| `Identity` aggregate | 90% | 95% |
| `EmailAddress` VO | 95% | 100% |
| `HashedPassword` VO | 95% | 100% |
| `RegisterIdentityUseCase` | 85% | 95% |
| `AuthenticationUseCase` | 85% | 95% |
| `IdentityController` | 75% | 85% |

[↑ Volver al inicio](#test-plans-por-bounded-context)

---

## Access Control Context (Core Domain)

**Módulo principal**: `io.cmartinezs.keygo.accesscontrol`

**Agregados y Value Objects**:
- `Role` (Aggregate Root): ID, nombre, permisos
- `Permission` (Value Object): acción, recurso
- `Membership` (Aggregate Root): identity, role, aplicación

**Eventos de Dominio**:
- `RoleCreatedEvent`
- `RoleAssignedEvent`
- `PermissionGrantedEvent`
- `AccessRevokedEvent`

### Unit Tests

```gherkin
Scenario: Crear rol con permisos
  Given un nombre de rol y lista de permisos
  When se crea un rol
  Then se genera ID único
  And el rol contiene exactamente los permisos especificados
  And se emite RoleCreatedEvent

Scenario: Evaluar si rol permite una acción
  Given un rol con permisos específicos
  When se evalúa si permite lectura de usuarios
  Then retorna true si el permiso existe
  And retorna false si no existe

Scenario: Asignar rol a identidad en aplicación
  Given una identidad y una aplicación
  And el rol existe
  When se asigna el rol
  Then se crea una Membership
  And se emite RoleAssignedEvent
  And el acceso se puede verificar inmediatamente

Scenario: Revocar acceso
  Given una Membership activa
  When se revoca
  Then se marca como REVOKED
  And se emite AccessRevokedEvent
  And la evaluación de acceso retorna false
```

### Integration Tests

```gherkin
Scenario: Flujo completo: asignar rol y evaluar acceso
  Given POST /api/v1/tenants/{slug}/roles con permisos
  And POST /api/v1/tenants/{slug}/memberships para asignar
  When GET /api/v1/tenants/{slug}/memberships/{membership_id}/can-access
  Then retorna { "allowed": true }

Scenario: Prevenir acceso a recurso sin rol
  Given una identidad sin membresía en aplicación
  When GET /api/v1/tenants/{slug}/memberships/{identity_id}/can-access
  Then retorna { "allowed": false }
  And NO se accede al recurso protegido
```

### Cobertura Mínima: 90%

| Componente | Mínimo | Objetivo |
|-----------|--------|----------|
| `Role` aggregate | 90% | 95% |
| `Permission` VO | 95% | 100% |
| `Membership` aggregate | 90% | 95% |
| `AccessEvaluator` | 85% | 95% |
| `RoleAssignmentUseCase` | 85% | 95% |
| `AccessControlController` | 75% | 85% |

[↑ Volver al inicio](#test-plans-por-bounded-context)

---

## Organization Context (Supporting)

**Módulo principal**: `io.cmartinezs.keygo.organization`

**Agregados**:
- `Organization` (Aggregate Root): slug, nombre, estado, suscripción

**Eventos de Dominio**:
- `OrganizationRegisteredEvent`
- `OrganizationActivatedEvent`
- `OrganizationSuspendedEvent`

### Unit Tests

```gherkin
Scenario: Registrar organización con slug único
  Given un slug válido (lowercase, sin espacios)
  And un nombre
  When se registra la organización
  Then se genera ID único
  And el estado es PENDING_ACTIVATION
  And se emite OrganizationRegisteredEvent

Scenario: Validar slug único
  Given una organización registrada con slug "acme"
  When se intenta registrar otra con slug "acme"
  Then lanza DuplicateOrganizationSlugException

Scenario: Activar organización
  Given una organización en PENDING_ACTIVATION
  When se activa
  Then el estado cambia a ACTIVE
  And se emite OrganizationActivatedEvent

Scenario: Suspender organización
  Given una organización ACTIVE
  When se suspende
  Then el estado cambia a SUSPENDED
  And se emite OrganizationSuspendedEvent
```

### Integration Tests

```gherkin
Scenario: Crear organización con datos multi-tenant
  Given POST /api/v1/organizations con slug y nombre
  When se ejecuta la petición
  Then se retorna 201 Created
  And la organización existe en BD
  And todos los datos posteriores están scoped a esta org
```

### Cobertura Mínima: 80%

| Componente | Mínimo | Objetivo |
|-----------|--------|----------|
| `Organization` aggregate | 85% | 95% |
| `OrganizationSlug` VO | 90% | 100% |
| `RegisterOrganizationUseCase` | 80% | 90% |

[↑ Volver al inicio](#test-plans-por-bounded-context)

---

## Client Applications Context (Supporting)

**Módulo principal**: `io.cmartinezs.keygo.clientapplication`

**Agregados**:
- `ClientApplication` (Aggregate Root): nombre, credenciales, scopes

**Eventos de Dominio**:
- `ClientApplicationRegisteredEvent`
- `ClientApplicationCredentialsRotatedEvent`

### Unit Tests

```gherkin
Scenario: Registrar aplicación cliente
  Given un nombre y scopes válidos
  When se registra
  Then se genera client_id y client_secret
  And se emite ClientApplicationRegisteredEvent

Scenario: Rotar credenciales
  Given una aplicación con credenciales activas
  When se rota
  Then se generan nuevas credenciales
  And se emite ClientApplicationCredentialsRotatedEvent
  And las antiguas se invalidan
```

### Integration Tests

```gherkin
Scenario: Obtener JWKS público de aplicación
  Given una aplicación registrada
  When GET /api/v1/tenants/{slug}/applications/{app_id}/.well-known/jwks.json
  Then retorna array de claves públicas
  And las claves son verificables sin autenticación
```

### Cobertura Mínima: 80%

[↑ Volver al inicio](#test-plans-por-bounded-context)

---

## Billing Context (Supporting)

**Módulo principal**: `io.cmartinezs.keygo.billing`

**Agregados**:
- `Subscription` (Aggregate Root): plan, estado, período
- `Charge` (Aggregate Root): monto, estado

**Eventos de Dominio**:
- `SubscriptionCreatedEvent`
- `ChargeInitiatedEvent`
- `ChargeCompletedEvent`

### Unit Tests

```gherkin
Scenario: Crear suscripción
  Given un plan válido y organización
  When se crea
  Then se genera Subscription
  And el estado es ACTIVE
  And se emite SubscriptionCreatedEvent

Scenario: Iniciar cobro
  Given una suscripción ACTIVE
  When se inicia cobro
  Then se crea Charge con estado PENDING
  And se emite ChargeInitiatedEvent

Scenario: Traducir respuesta de proveedor de pago
  Given una respuesta de proveedor externo
  When se traduce a Charge
  Then se mapea status externo → estado local
  And se protege contra cambios futuros del proveedor
```

### Integration Tests

```gherkin
Scenario: Anti-Corruption Layer: proveedor de pago falla
  Given una llamada al proveedor de pago que falla
  When se procesa
  Then se captura la excepción externa
  And se traduce a PaymentFailedException
  And el código de dominio no ve la excepción externa
```

### Cobertura Mínima: 80%

[↑ Volver al inicio](#test-plans-por-bounded-context)

---

## Audit Context (Supporting)

**Módulo principal**: `io.cmartinezs.keygo.audit`

**Eventos de Dominio**:
- `AuditEventLogged` (publicador, consume eventos de todos los contextos)

### Unit Tests

```gherkin
Scenario: Registrar evento de auditoría
  Given un evento de dominio (ej. IdentityCreatedEvent)
  When se recibe
  Then se crea AuditLog con timestamp, actor, acción
  And se persiste inmediatamente

Scenario: Auditoría es append-only
  Given logs de auditoría registrados
  When se intenta modificar o borrar
  Then falla la operación
```

### Integration Tests

```gherkin
Scenario: Todos los eventos importantes generan entrada en auditoría
  Given operaciones en Identity, Access Control, etc.
  When se ejecutan
  Then aparecen en GET /api/v1/tenants/{slug}/audit-logs
```

### Cobertura Mínima: 75%

[↑ Volver al inicio](#test-plans-por-bounded-context)

---

## Platform Context (Supporting)

**Módulo principal**: `io.cmartinezs.keygo.platform`

**Responsabilidad**: Admin de plataforma, visibilidad global

### Unit Tests

```gherkin
Scenario: Listar todas las organizaciones (solo admin)
  Given un admin de plataforma
  When consulta organizaciones
  Then ve todas las organizaciones
  And los datos se traducen desde cada contexto
```

### Integration Tests

```gherkin
Scenario: Conformist pattern: Platform lee datos de otros contextos
  Given datos en Organization, Billing, etc.
  When Platform consulta
  Then obtiene vista consolidada
  And los modelos se traducen al formato de Platform
```

### Cobertura Mínima: 70%

[↑ Volver al inicio](#test-plans-por-bounded-context)

---

## Cross-Context Tests (Smoke / UAT)

Estas pruebas validan flujos que cruzan múltiples contextos:

```gherkin
Scenario: Flujo completo de usuario: registro → autenticación → acceso
  Given POST /api/v1/organizations (Organization Context)
  And POST /api/v1/tenants/{slug}/identities (Identity Context)
  And POST /api/v1/tenants/{slug}/applications (ClientApplications Context)
  And POST /api/v1/tenants/{slug}/roles (Access Control Context)
  And POST /api/v1/tenants/{slug}/memberships (Access Control Context)
  When el usuario intenta acceder a un recurso protegido
  Then se evalúa Identity → Access Control
  And se autoriza
  And aparece en Audit logs
```

[↑ Volver al inicio](#test-plans-por-bounded-context)

---

[← Índice](./README.md) | [< Anterior](./unit-test-coverage.md) | [Siguiente >](./integration-tests.md)
