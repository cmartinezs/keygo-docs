[← Índice](./README.md) | [< Anterior](./adr-001-hexagonal-architecture.md) | [Siguiente >](./adr-003-jwt-with-roles.md)

---

# ADR-002: Multi-Tenancy con Aislamiento a Nivel de Modelo

## Estado

**Aceptado** | Fecha: 2026-04-10

## Contexto

KeyGo es una plataforma multi-tenant de identidad y acceso. Cada organización (tenant) debe estar completamente aislada de las demás, tanto en datos como en acceso.

## Decisión

El aislamiento multi-tenant se implementa a **nivel de modelo de datos**, no como preocupación transversal (filter/interceptor):

### 1. Modelo de Datos

- Toda entidad tiene `tenant_id` como campo obligatorio
- Queries filtran automáticamente por tenant
- No existen entidades "globales" que contengan datos de múltiples tenants

### 2. Consulta Obligatoria

```java
public interface UserRepositoryPort {
  PagedResult<User> findByTenantSlug(String tenantSlug, UserFilter filter);
}
```

El `tenantSlug` es **obligatorio** en todas las operaciones tenant-scoped.

### 3. JWT Claim

```json
{
  "tenant_slug": "my-company",
  "roles": ["ADMIN_ORG"]
}
```

### 4. Autorización

```java
@PreAuthorize("@tenantAuthorizationEvaluator.hasTenantAccess(authentication)")
@GetMapping("/api/v1/tenants/{tenantSlug}/users")
```

Valida que `tenant_slug` en JWT == `tenantSlug` en URL.

## Consecuencias

### Positivas

- ✅ Aislamiento real a nivel de datos
- ✅ Consultas imposibles sin especificar tenant
- ✅ Compliance natural (datos de tenants no se mezclan)
- ✅ Debugging facilita: siempre se sabe a qué tenant pertenece cada query

### Negativas

- ⚠️ No hay soporte para datos cross-tenant (requiere diseño explícito)
- ⚠️ Queries más complejas cuando se necesita acceso global (platform admin)

## Alternativas Consideradas

| Alternativa | Por qué fue descartada |
|-------------|----------------------|
| Schema por tenant (PostgreSQL schemas) | Overhead operacional, complejidad |
| Base de datos por tenant | Costo, complejidad de operaciones |
| Filter/interceptor con softcoding | Riesgo de bypass, no hay aislamiento real en BD |

## Referencias

- [Arquitectura - Multi-Tenancy](architecture.md#multi-tenancy)
- [Authorization Patterns](authorization-patterns.md)

[↑ Volver al inicio](#adr-002-multi-tenancy-con-aislamiento-a-nivel-de-modelo)

---

[← Índice](./README.md) | [< Anterior](./adr-001-hexagonal-architecture.md) | [Siguiente >](./adr-003-jwt-with-roles.md)
