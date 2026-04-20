[← Índice](./README.md) | [Siguiente >](./cicd.md)

---

# Environments

Descripción de los ambientes de desarrollo, staging y producción.

## Contenido

- [Resumen de Ambientes](#resumen-de-ambientes)
- [Dev](#dev)
- [Staging](#staging)
- [Production](#production)
- [Configuration](#configuration)

---

## Resumen de Ambientes

| Environment | Propósito |URL | Deploy |
|-------------|-----------|-----|--------|
| **Dev** | Desarrollo local | `localhost:8080` | Auto (push a develop) |
| **Staging** | QA y pre-producción | `api-staging.keygo.io` | Manual (workflow dispatch) |
| **Production** | Producción | `api.keygo.io` | Manual con aprobación |

[↑ Volver al inicio](#environments)

---

## Dev

**Características:**
- Base de datos local PostgreSQL (Docker)
- Debug logging habilitado
- H2 para tests
- No SSL
- CORS permitido para desarrollo frontend

**Variables:**
```bash
SPRING_PROFILES_ACTIVE=local
SUPABASE_URL=jdbc:postgresql://localhost:5432/keygo
KEYGO_ISSUER_BASE_URL=http://localhost:8080
```

**Deploy:**
- Auto-deploy en push a rama `develop`
- GitHub Actions: `ci.yml` → deploy automático

[↑ Volver al inicio](#environments)

---

## Staging

**Características:**
- PostgreSQL dedicado en staging
- Información de logging
- SSL (Let's Encrypt)
- CORS restringido a dominios de staging
- Simula producción

**URL:** `https://api-staging.keygo.io`

**Deploy:**
- Manual via GitHub Actions workflow dispatch
- Pre-deployment: ejecutar smoke tests
- Backup de base de datos

**Pre-deployment checklist:**
- [ ] Tests passing en CI
- [ ] Database backup verificado
- [ ] Rollback plan documentado
- [ ] Monitoreo configurado

[↑ Volver al inicio](#environments)

---

## Production

**Características:**
- PostgreSQL High Availability (Patroni o Cloud SQL)
- Logging estructurado
- SSL con certificado válido (Let's Encrypt o wildcard)
- CORS solo para dominios production
- Alertas activas
- Blue-Green deployment (zero downtime)
- Multi-tenant isolation garantizado

**URL:** `https://api.keygo.io`

**Deploy:**
- Manual via GitHub Actions con versión (git tag)
- Requiere aprobación de environment
- Blue-Green strategy (mantener dos versiones activas)
- Pre y post-deployment checklist completo
- Smoke tests automáticos post-deploy

**Pre-deployment checklist:**
- [ ] Todos los tests pasando
- [ ] Quality gate SonarQube passed
- [ ] Snyk scan sin high/critical CVEs
- [ ] Imagen Docker firmada con Cosign
- [ ] Backup de base de datos
- [ ] Plan de rollback documentado
- [ ] Alertas configuradas
- [ ] Equipo notificado
- [ ] Multi-tenant data integrity validado

[↑ Volver al inicio](#environments)

---

## Multi-Tenancy en Deployment

Keygo es una plataforma **multi-tenant**, lo que significa que múltiples organizaciones comparten infraestructura pero están completamente aisladas. Esto tiene implicaciones críticas en deployment:

### Aislamiento de Datos por Ambiente

| Ambiente | BD | Scope | Acceso |
|----------|----|----|--------|
| **Dev** | Local PostgreSQL | Todos los tenants | Completo (todos los tenants) |
| **Staging** | PostgreSQL dedicado | Tenants de staging | Restringido a equipo de QA |
| **Production** | PostgreSQL HA | Tenants de producción | Solo datos del tenant autenticado |

### Migraciones de BD Multi-Tenant

Cuando se deploya en staging o producción, las migraciones deben considerar:

1. **Forward-compatibility**: El nuevo código funciona con BD vieja
2. **No downtime**: Cambios en fases (columnas nullable primero)
3. **Data integrity**: Validar que ningún tenant tiene datos corruptos

**Ejemplo: Agregar nueva columna sin downtime:**

```sql
-- Step 1: Agregar columna nullable (instant)
ALTER TABLE users ADD COLUMN email_verified_at TIMESTAMP NULL;

-- Step 2: Migración de datos (puede tomar tiempo)
UPDATE users SET email_verified_at = created_at WHERE status = 'ACTIVE';

-- Step 3: Una vez completado, cambiar a NOT NULL
ALTER TABLE users ALTER COLUMN email_verified_at SET NOT NULL;
```

### Feature Flags por Tenant

Diferentes tenants pueden estar en diferentes versiones del producto:

```java
@Service
public class FeatureFlagService {
  @Autowired
  private FeatureFlagRepository repository;
  
  public boolean isEnabled(String featureName, String tenantSlug) {
    // Primero busca override específico del tenant
    Optional<FeatureFlag> flag = repository
        .findByNameAndTenant(featureName, tenantSlug);
    
    if (flag.isPresent() && flag.get().isEnabled()) {
      return true;
    }
    
    // Fallback a default de plataforma
    return repository
        .findByNameAndDefault(featureName)
        .map(FeatureFlag::isEnabled)
        .orElse(false);
  }
}
```

**Uso en controlador:**

```java
@GetMapping("/api/v1/tenants/{slug}/advanced-search")
public ResponseEntity<?> advancedSearch(@PathVariable String slug, ...) {
  if (!featureFlags.isEnabled("ADVANCED_SEARCH", slug)) {
    return ResponseEntity.status(404).build();  // Feature not available for this tenant
  }
  // Lógica de búsqueda avanzada
}
```

### Validación de Aislamiento en Deploy

Antes de desplegar a producción, validar:

```bash
# Verificar que no hay data leaks entre tenants
./scripts/validate-tenant-isolation.sh

# Ejecutar smoke tests por tenant
for tenant in $(list_tenants); do
  curl -X GET https://api.keygo.io/health \
    -H "Authorization: Bearer $TENANT_TOKEN" \
    -H "X-Tenant-Slug: $tenant"
done
```

[↑ Volver al inicio](#environments)

---

## Configuration

### Estructura de archivos .env

```
envs/
├── .env.example
├── .env-local
├── .env-staging
└── .env-prod

.env              # activo en raíz del repo
```

### Variables Críticas (por Ambiente)

| Variable | Dev | Staging | Production |
|----------|-----|---------|------------|
| `SPRING_PROFILES_ACTIVE` | local | staging | production |
| `SUPABASE_URL` | jdbc:postgresql://localhost:5432/keygo_dev | jdbc://staging-db:5432/keygo_staging | jdbc://prod-db:5432/keygo_prod |
| `KEYGO_ISSUER_BASE_URL` | http://localhost:8080 | https://api-staging.keygo.io | https://api.keygo.io |
| `KEYGO_CORS_ALLOWED_ORIGINS` | http://localhost:3000 | https://staging.keygo.io | https://keygo.io |

### Secrets Management

Usar **AWS Secrets Manager** o **HashiCorp Vault** para:
- Database passwords
- API keys
- JWT signing keys
- OAuth credentials

**Nunca commitear:** passwords, API keys, private keys, BD credentials

[↑ Volver al inicio](#environments)

---

[← Índice](./README.md) | [Siguiente >](./cicd.md)