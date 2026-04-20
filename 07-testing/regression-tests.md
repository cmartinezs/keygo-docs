[← Índice](./README.md) | [< Anterior](./integration-tests.md) | [Siguiente >](./smoke-tests.md)

---

# Regression Tests

Pruebas que garantizan que bugs corregidos no reaparecen y que la funcionalidad existente sigue funcionando.

## Contenido

- [Propósito](#propósito)
- [Bug Fix Tests](#bug-fix-tests)
- [Suite de Regresión](#suite-de-regresión)
- [Frecuencia](#frecuencia)

---

## Propósito

Cada bug corregido debe producir un test que:

1. **Falla** en el estado roto (reproduce el bug)
2. **Pasa** con el fix aplicado
3. **Permanece** en la suite — nunca se elimina

Esto previene que el mismo bug reaparezca en futuras modificaciones.

[↑ Volver al inicio](#regression-tests)

---

## Bug Fix Tests

```java
@Test
void createUser_withDuplicateEmail_throwsDuplicateException() {
  // Given: usuario ya existente
  userRepository.save(User.builder()
      .email(EmailAddress.of("john@example.com"))
      .tenantId(tenantId)
      .build());

  // When / Then: crear otro con el mismo email debe fallar
  assertThatThrownBy(() ->
      createUserUseCase.execute(CreateUserCommand.builder()
          .email("john@example.com")
          .tenantSlug("acme")
          .build())
  ).isInstanceOf(DuplicateUserException.class);
}
```

**Convención de nombre:** incluir referencia al bug si aplica:

```
createUser_withDuplicateEmail_throwsDuplicateException  // bug #123
session_withExpiredToken_returns401                      // bug #456
```

[↑ Volver al inicio](#regression-tests)

---

## Suite de Regresión

```bash
# Ejecutar suite de regresión
./mvnw test -Dtest=*RegressionTest

# Categorías por contexto
./mvnw test -Dgroups=auth-regression
./mvnw test -Dgroups=tenant-regression
./mvnw test -Dgroups=rbac-regression
```

**Categorías:**

| Categoría | Cubre |
|-----------|-------|
| `auth-regression` | Login, logout, token refresh, expiración |
| `tenant-regression` | CRUD de organizaciones, aislamiento |
| `user-regression` | CRUD de usuarios, ciclo de vida |
| `rbac-regression` | Roles, permisos, evaluación de acceso |

[↑ Volver al inicio](#regression-tests)

---

## Frecuencia

| Momento | Alcance |
|---------|---------|
| Por commit (CI) | Smoke + auth regression |
| Por PR | Suite completa |
| Por sprint | Suite completa + reporte de tendencia |

[↑ Volver al inicio](#regression-tests)

---

[← Índice](./README.md) | [< Anterior](./integration-tests.md) | [Siguiente >](./smoke-tests.md)
