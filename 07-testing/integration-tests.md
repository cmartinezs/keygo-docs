[← Índice](./README.md) | [< Anterior](./unit-test-coverage.md) | [Siguiente >](./regression-tests.md)

---

# Integration Tests

Pruebas de integración que verifican la colaboración entre componentes reales — tanto en backend como en frontend.

## Contenido

- [Principios](#principios)
- [Backend: Stack](#backend-stack)
- [Backend: Testcontainers](#backend-testcontainers)
- [Backend: Fixtures con SQL](#backend-fixtures-con-sql)
- [Backend: API Tests con MockMvc](#backend-api-tests-con-mockmvc)
- [Frontend: Stack](#frontend-stack)
- [Frontend: Component Tests](#frontend-component-tests)
- [Frontend: Mock Service Worker](#frontend-mock-service-worker)
- [Comandos](#comandos)

---

## Principios

Los integration tests verifican que los componentes reales colaboran correctamente:

- **Backend**: base de datos real (Testcontainers), contexto Spring completo — no H2, no mocks de repositorio
- **Frontend**: componentes reales renderizados, API mockeada a nivel de red (MSW) — no mocks de módulo de servicio
- Son más lentos que los unit tests — ejecutar en suite separada

[↑ Volver al inicio](#integration-tests)

---

## Backend: Stack

| Herramienta | Rol |
|-------------|-----|
| **JUnit 5** | Motor de ejecución |
| **Testcontainers** | Base de datos real en Docker |
| **Spring Boot Test** | Contexto completo de la aplicación |
| **MockMvc** | Pruebas de endpoints HTTP sin servidor real |
| **AssertJ** | Assertions |

[↑ Volver al inicio](#integration-tests)

---

## Backend: Testcontainers

```java
@SpringBootTest
@Testcontainers
class UserRepositoryIntegrationTest {

  @Container
  static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16-alpine")
      .withDatabaseName("keygo_test")
      .withUsername("keygo")
      .withPassword("test-password");

  @DynamicPropertySource
  static void setProperties(DynamicPropertyRegistry registry) {
    registry.add("spring.datasource.url", postgres::getJdbcUrl);
    registry.add("spring.datasource.username", postgres::getUsername);
    registry.add("spring.datasource.password", postgres::getPassword);
  }

  @Autowired
  UserRepositoryPort userRepository;

  @Test
  void createAndFindUserByEmail() {
    User saved = userRepository.save(User.builder()
        .email(EmailAddress.of("john@example.com"))
        .build());

    Optional<User> found = userRepository.findByEmail(EmailAddress.of("john@example.com"));

    assertThat(found).isPresent();
    assertThat(found.get().getId()).isEqualTo(saved.getId());
  }
}
```

[↑ Volver al inicio](#integration-tests)

---

## Backend: Fixtures con SQL

```java
@SpringBootTest
@Sql("/fixtures/tenants.sql")
@Sql("/fixtures/users.sql")
class TenantRepositoryIntegrationTest {

  @Autowired
  TenantRepositoryPort tenantRepository;

  @Test
  void findTenantBySlug_returnsExistingTenant() {
    Optional<Tenant> tenant = tenantRepository.findBySlug("acme-corp");
    assertThat(tenant).isPresent();
  }
}
```

**Ubicación de fixtures:**

```
keygo-supabase/src/test/resources/fixtures/
├── tenants.sql
├── users.sql
└── memberships.sql
```

[↑ Volver al inicio](#integration-tests)

---

## Backend: API Tests con MockMvc

```java
@SpringBootTest
@AutoConfigureMockMvc
class UserControllerIntegrationTest {

  @Autowired MockMvc mockMvc;
  @Autowired ObjectMapper objectMapper;

  @Test
  void createUser_withValidRequest_returns201() throws Exception {
    CreateUserRequest request = new CreateUserRequest("john@example.com", "jsmith");

    mockMvc.perform(
        post("/api/v1/tenants/{tenantSlug}/users", "acme")
            .contentType(MediaType.APPLICATION_JSON)
            .content(objectMapper.writeValueAsString(request))
            .with(jwt().jwt(jwt -> jwt
                .subject("admin-uuid")
                .claim("tenant_slug", "acme")
                .claim("roles", List.of("ADMIN_ORG"))))
    )
    .andExpect(status().isCreated())
    .andExpect(jsonPath("$.data.email").value("john@example.com"));
  }
}
```

[↑ Volver al inicio](#integration-tests)

---

## Frontend: Stack

| Herramienta | Rol |
|-------------|-----|
| **Vitest** | Motor de ejecución |
| **React Testing Library** | Render de componentes reales |
| **Mock Service Worker (MSW)** | Intercepta llamadas HTTP a nivel de red |
| **@testing-library/user-event** | Simulación de interacción real |

MSW es preferido sobre mocks de módulo para integration tests porque prueba el contrato HTTP real entre el frontend y la API.

[↑ Volver al inicio](#integration-tests)

---

## Frontend: Component Tests

Testear flujos completos de componentes con estado real y navegación:

```typescript
describe('UserListPage', () => {
  it('loads and displays users on mount', async () => {
    // MSW maneja la llamada a la API (ver sección siguiente)
    render(<UserListPage />, { wrapper: AppProviders });

    // Loading state
    expect(screen.getByRole('progressbar')).toBeInTheDocument();

    // Users loaded
    await screen.findByText('alice@example.com');
    expect(screen.getByText('bob@example.com')).toBeInTheDocument();
  });

  it('shows error state when API fails', async () => {
    server.use(
      http.get('/api/v1/tenants/:slug/users', () =>
        HttpResponse.json({ error: 'SERVER_ERROR' }, { status: 500 })
      )
    );

    render(<UserListPage />, { wrapper: AppProviders });

    await screen.findByRole('alert');
    expect(screen.getByText(/error al cargar/i)).toBeInTheDocument();
  });
});
```

[↑ Volver al inicio](#integration-tests)

---

## Frontend: Mock Service Worker

```typescript
// src/mocks/handlers.ts
import { http, HttpResponse } from 'msw';

export const handlers = [
  http.get('/api/v1/tenants/:slug/users', () =>
    HttpResponse.json({
      data: [
        { id: '1', email: 'alice@example.com', username: 'alice' },
        { id: '2', email: 'bob@example.com', username: 'bob' },
      ],
    })
  ),
];

// src/mocks/server.ts
import { setupServer } from 'msw/node';
export const server = setupServer(...handlers);

// vitest.setup.ts
beforeAll(() => server.listen());
afterEach(() => server.resetHandlers());
afterAll(() => server.close());
```

[↑ Volver al inicio](#integration-tests)

---

## Comandos

### Backend

```bash
# Todos los tests (unit + integration)
./mvnw verify

# Solo integration tests
./mvnw verify -DskipUnitTests=true

# Por módulo
./mvnw -pl keygo-supabase verify
```

### Frontend

```bash
# Todos los tests (unit + component)
npm run test -- --run

# Con cobertura
npm run test -- --coverage --run
```

[↑ Volver al inicio](#integration-tests)

---

[← Índice](./README.md) | [< Anterior](./unit-test-coverage.md) | [Siguiente >](./regression-tests.md)
