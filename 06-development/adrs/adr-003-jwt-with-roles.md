[← Índice](./README.md) | [< Anterior](./adr-002-multi-tenant-model.md)

---

# ADR-003: JWT con Roles por Claim

## Estado

**Aceptado** | Fecha: 2026-04-10

## Contexto

KeyGo necesita un mecanismo para transporte de roles desde el backend hasta las aplicaciones cliente, permitiendo autorización granular a nivel de plataforma, tenant y aplicación.

## Decisión

Los roles se transportan en el **JWT claim `roles`**:

```json
{
  "sub": "user-uuid",
  "email": "user@example.com",
  "tenant_slug": "my-company",
  "roles": ["ADMIN_ORG", "USER"],
  "aud": "keygo-console",
  "iss": "https://keygo.local/api/v1/tenants/my-company"
}
```

### Tres Niveles de Roles

| Nivel | Claim | Ejemplo | Acceso |
|-------|-------|--------|--------|
| **Platform** | `roles` | `keygo_admin` | Admin global |
| **Tenant** | `tenant_slug` + `roles` | `ADMIN_ORG` | Admin de organización |
| **App** | `app_id` + `roles` | `EDITOR` | Roles por aplicación |

### Ejemplo de Evaluación

```java
// Platform
@PreAuthorize("hasRole('keygo_admin')")

// Tenant
@PreAuthorize("hasAnyRole('ADMIN_ORG', 'keygo_admin') and @tenantAuthorizationEvaluator.hasTenantAccess(auth)")

// App (client app evalúa localmente)
@PreAuthorize("hasRole('EDITOR')")
```

## Consecuencias

### Positivas

- ✅ Roles disponibles sin llamada a BD adicional
- ✅ Evaluación stateless
- ✅ Soporte para tres niveles de granularidad
- ✅ Compatible con estándar OAuth2

### Negativas

- ⚠️ Revocación de roles no inmediata (hasta expiración de token)
- ⚠️ Token más grande con muchos roles
- ⚠️ Necesidad de refrescar token para ver cambios de rol

## Alternativas Consideradas

| Alternativa | Por qué fue descartada |
|-------------|----------------------|
| Database lookup por request | Latencia, bottleneck |
| Introspección OAuth2 | Extra round-trip, complejidad |
| Custom claims en lugar de `roles` | No es estándar |

## Referencias

- [Authorization Patterns](authorization-patterns.md)
- [JWT Claims](architecture.md#seguridad)

[↑ Volver al inicio](#adr-003-jwt-con-roles-por-claim)

---

[← Índice](./README.md) | [< Anterior](./adr-002-multi-tenant-model.md)