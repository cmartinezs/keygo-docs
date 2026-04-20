[← Índice](./README.md) | [< Anterior](./regression-tests.md) | [Siguiente >](./uat.md)

---

# Smoke Tests

Pruebas rápidas post-despliegue que verifican que el sistema arranca y responde correctamente.

## Contenido

- [Propósito](#propósito)
- [Suite de Smoke Tests](#suite-de-smoke-tests)
- [Integración CI/CD](#integración-cicd)
- [Frecuencia](#frecuencia)

---

## Propósito

Los smoke tests no verifican lógica de negocio — verifican que el sistema **está vivo y accesible**:

- El proceso arrancó
- Los endpoints críticos responden
- Los endpoints protegidos rechazan accesos sin credenciales

Deben correr en segundos, no minutos.

[↑ Volver al inicio](#smoke-tests)

---

## Suite de Smoke Tests

```bash
#!/bin/bash
# scripts/test-smoke.sh

set -e
BASE_URL="${1:-http://localhost:8080}"

echo "=== KeyGo Smoke Tests ==="
echo "Target: $BASE_URL"

# 1. Liveness
curl -sf "$BASE_URL/actuator/health/liveness" \
  && echo "✅ Liveness OK" || { echo "❌ Liveness FAILED"; exit 1; }

# 2. Readiness
curl -sf "$BASE_URL/actuator/health/readiness" \
  && echo "✅ Readiness OK" || { echo "❌ Readiness FAILED"; exit 1; }

# 3. Service info (endpoint público)
curl -sf "$BASE_URL/api/v1/platform/service-info" \
  && echo "✅ Service info OK" || { echo "❌ Service info FAILED"; exit 1; }

# 4. Endpoint protegido debe rechazar sin token
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL/api/v1/tenants/test/users")
[ "$STATUS" = "401" ] \
  && echo "✅ Auth guard OK (401)" || { echo "❌ Auth guard FAILED (got $STATUS)"; exit 1; }

echo "=== All smoke tests passed ==="
```

[↑ Volver al inicio](#smoke-tests)

---

## Integración CI/CD

```yaml
# .github/workflows/smoke.yml
name: Smoke Tests

on:
  workflow_run:
    workflows: [Deploy]
    types: [completed]

jobs:
  smoke:
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run smoke tests
        run: ./scripts/test-smoke.sh ${{ vars.STAGING_URL }}
```

[↑ Volver al inicio](#smoke-tests)

---

## Frecuencia

| Momento | Entorno |
|---------|---------|
| Post-deploy a staging | Staging |
| Post-deploy a producción | Producción |
| Cada build en CI | Local (con app levantada) |

[↑ Volver al inicio](#smoke-tests)

---

[← Índice](./README.md) | [< Anterior](./regression-tests.md) | [Siguiente >](./uat.md)
