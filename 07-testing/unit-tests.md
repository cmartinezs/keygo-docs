[← Índice](./README.md) | [< Anterior](./test-strategy.md) | [Siguiente >](./unit-test-coverage.md)

---

# Unit Tests

Guía de pruebas unitarias para backend (Java) y frontend (TypeScript): sin framework, velocidad máxima, lógica verificada en aislamiento.

## Contenido

- [Principios Comunes](#principios-comunes)
- [Backend: Stack](#backend-stack)
- [Backend: Convenciones](#backend-convenciones)
- [Backend: Value Objects](#backend-value-objects)
- [Backend: Domain Services](#backend-domain-services)
- [Backend: Use Cases](#backend-use-cases)
- [Backend: Mocking](#backend-mocking)
- [Frontend: Stack](#frontend-stack)
- [Frontend: Convenciones](#frontend-convenciones)
- [Frontend: Hooks y Lógica](#frontend-hooks-y-lógica)
- [Frontend: Componentes](#frontend-componentes)
- [Frontend: Mocking](#frontend-mocking)
- [Anti-Patterns](#anti-patterns)

---

## Principios Comunes

Los unit tests de Keygo son **agnósticos al framework** en ambos ámbitos:

- **Backend**: sin `@SpringBootTest`, sin contexto de Spring, sin base de datos
- **Frontend**: sin renderizado de página completa, sin servidor real, sin llamadas HTTP reales
- Instantáneos: cada test debe correr en milisegundos
- Determinísticos: mismo resultado siempre, sin importar el orden

> Un unit test prueba una unidad de comportamiento, no la plomería del framework.

[↑ Volver al inicio](#unit-tests)

---

## Backend: Stack

| Herramienta | Rol |
|-------------|-----|
| **JUnit 5** | Motor de ejecución |
| **Mockito** | Dobles de prueba para dependencias externas |
| **AssertJ** | Assertions fluidas y expresivas |

Sin Spring, sin Testcontainers, sin HTTP.

[↑ Volver al inicio](#unit-tests)

---

## Backend: Convenciones

### Estructura: Given / When / Then

```java
@Test
void createUserWithValidEmailSucceeds() {
  // Given
  EmailAddress email = EmailAddress.of("john@example.com");

  // When
  User user = User.builder().email(email).build();

  // Then
  assertThat(user.getEmail()).isEqualTo(email);
}
```

### Nombres de test

```
<método>_cuando<Condición>_<ResultadoEsperado>

createUser_whenEmailExists_throwsDuplicateException
validatePassword_whenTooShort_failsValidation
```

### Extensión

```java
@ExtendWith(MockitoExtension.class)
class CreateUserUseCaseTest {
  // Sin contexto Spring — nunca @SpringBootTest aquí
}
```

[↑ Volver al inicio](#unit-tests)

---

## Backend: Value Objects

Verificar inmutabilidad, validación y igualdad estructural:

```java
@Test
void emailAddressRejectsInvalidFormat() {
  assertThatThrownBy(() -> EmailAddress.of("invalid-email"))
      .isInstanceOf(DomainException.class)
      .hasMessageContaining("EMAIL_INVALID_FORMAT");
}

@Test
void emailAddressNormalizesToLowerCase() {
  EmailAddress email = EmailAddress.of("USER@EXAMPLE.COM");
  assertThat(email.value()).isEqualTo("user@example.com");
}

@Test
void emailAddressEqualityByValue() {
  assertThat(EmailAddress.of("a@b.com"))
      .isEqualTo(EmailAddress.of("a@b.com"));
}
```

[↑ Volver al inicio](#unit-tests)

---

## Backend: Domain Services

Lógica de negocio pura, sin dependencias de infraestructura:

```java
@Test
void validatePasswordWithWeakStrengthFails() {
  ValidationResult result = PasswordValidator.validate("123");
  assertThat(result.isValid()).isFalse();
  assertThat(result.errors()).contains("PASSWORD_TOO_SHORT");
}

@Test
void validatePasswordWithStrongStrengthSucceeds() {
  ValidationResult result = PasswordValidator.validate("MyStr0ng!Pass#2");
  assertThat(result.isValid()).isTrue();
}
```

[↑ Volver al inicio](#unit-tests)

---

## Backend: Use Cases

Inyectar puertos como mocks, probar lógica de aplicación:

```java
@ExtendWith(MockitoExtension.class)
class CreateUserUseCaseTest {

  @Mock UserRepositoryPort userRepository;
  @Mock EmailSenderPort emailSender;
  @InjectMocks CreateUserUseCase useCase;

  @Test
  void execute_whenEmailExists_throwsDuplicateException() {
    when(userRepository.existsByEmail(any())).thenReturn(true);

    assertThatThrownBy(() -> useCase.execute(validCommand()))
        .isInstanceOf(DuplicateUserException.class);

    verify(emailSender, never()).send(any());
  }

  @Test
  void execute_whenValid_savesUserAndSendsEmail() {
    when(userRepository.existsByEmail(any())).thenReturn(false);
    when(userRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

    User created = useCase.execute(validCommand());

    assertThat(created.getEmail().value()).isEqualTo("john@example.com");
    verify(emailSender, times(1)).send(any());
  }
}
```

[↑ Volver al inicio](#unit-tests)

---

## Backend: Mocking

**Mockear solo dependencias externas al dominio**: repositorios (puertos OUT), servicios HTTP, email senders.

```java
// ✅ Correcto: mock del puerto OUT
@Mock UserRepositoryPort userRepository;

// ❌ Incorrecto: mock de entidad de dominio
@Mock User user;
```

**No mockear:** entidades de dominio, Value Objects, Domain Services (son clases puras — instanciar directo).

[↑ Volver al inicio](#unit-tests)

---

## Frontend: Stack

| Herramienta | Rol |
|-------------|-----|
| **Vitest** | Motor de ejecución (compatible con Jest API) |
| **React Testing Library** | Render de componentes aislados |
| **@testing-library/user-event** | Simulación de interacción de usuario |
| **vi.fn() / vi.mock()** | Dobles de prueba |

Sin llamadas HTTP reales, sin router completo, sin estado global de aplicación.

[↑ Volver al inicio](#unit-tests)

---

## Frontend: Convenciones

### Estructura: Arrange / Act / Assert

```typescript
it('shows error message when email is invalid', () => {
  // Arrange
  render(<LoginForm onSubmit={vi.fn()} />);

  // Act
  await userEvent.type(screen.getByLabelText('Email'), 'not-an-email');
  await userEvent.click(screen.getByRole('button', { name: /login/i }));

  // Assert
  expect(screen.getByRole('alert')).toHaveTextContent('Email inválido');
});
```

### Nombres de test

```
<componente/función>_<condición>_<comportamientoEsperado>

LoginForm_withInvalidEmail_showsValidationError
useSession_whenTokenExpires_redirectsToLogin
formatDate_withNullValue_returnsEmptyString
```

[↑ Volver al inicio](#unit-tests)

---

## Frontend: Hooks y Lógica

La lógica de negocio del frontend vive en hooks y utilidades. Estos se testean sin renderizado de componente:

```typescript
import { renderHook, act } from '@testing-library/react';

describe('usePasswordValidation', () => {
  it('returns invalid for password shorter than 8 chars', () => {
    const { result } = renderHook(() => usePasswordValidation());

    act(() => result.current.validate('short'));

    expect(result.current.isValid).toBe(false);
    expect(result.current.errors).toContain('PASSWORD_TOO_SHORT');
  });

  it('returns valid for strong password', () => {
    const { result } = renderHook(() => usePasswordValidation());

    act(() => result.current.validate('MyStr0ng!Pass'));

    expect(result.current.isValid).toBe(true);
  });
});
```

[↑ Volver al inicio](#unit-tests)

---

## Frontend: Componentes

Testear comportamiento observable del componente, no su estructura interna:

```typescript
describe('UserCard', () => {
  it('displays user email and username', () => {
    render(<UserCard user={{ email: 'a@b.com', username: 'alice' }} />);

    expect(screen.getByText('a@b.com')).toBeInTheDocument();
    expect(screen.getByText('alice')).toBeInTheDocument();
  });

  it('calls onEdit when edit button is clicked', async () => {
    const onEdit = vi.fn();
    render(<UserCard user={mockUser} onEdit={onEdit} />);

    await userEvent.click(screen.getByRole('button', { name: /editar/i }));

    expect(onEdit).toHaveBeenCalledWith(mockUser.id);
  });
});
```

[↑ Volver al inicio](#unit-tests)

---

## Frontend: Mocking

**Mockear servicios de API y módulos externos**, no la lógica del propio componente:

```typescript
// ✅ Mock del servicio de API
vi.mock('@/services/userService', () => ({
  getUser: vi.fn().mockResolvedValue({ id: '1', email: 'a@b.com' }),
}));

// ✅ Mock de hook de navegación
vi.mock('react-router-dom', async () => ({
  ...(await vi.importActual('react-router-dom')),
  useNavigate: () => vi.fn(),
}));

// ❌ No mockear lógica interna del componente que se está testeando
```

[↑ Volver al inicio](#unit-tests)

---

## Anti-Patterns

| Anti-pattern | Backend | Frontend |
|-------------|---------|----------|
| Contexto de framework en unit test | `@SpringBootTest` en clase sin `@Container` | Renderizar `<App>` completo con router y store |
| Testear implementación interna | `hasFieldOrProperty` en campos privados | `container.querySelector('.internal-class')` |
| Dependencia de orden o tiempo | `Thread.sleep()` | `setTimeout` / `waitFor` sin condición |
| Mock de lo que se está testeando | Mock del use case dentro de su propio test | Mock del componente dentro de su propio test |

[↑ Volver al inicio](#unit-tests)

---

[← Índice](./README.md) | [< Anterior](./test-strategy.md) | [Siguiente >](./unit-test-coverage.md)
