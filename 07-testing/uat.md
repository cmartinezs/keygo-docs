[← Índice](./README.md) | [< Anterior](./smoke-tests.md) | [Siguiente >](./security-testing.md)

---

# UAT — User Acceptance Testing

Pruebas de aceptación realizadas para validar que el sistema cumple los requisitos desde la perspectiva del usuario.

## Contenido

- [Propósito](#propósito)
- [Escenarios](#escenarios)
- [Scripts de Validación](#scripts-de-validación)
- [Checklist](#checklist)
- [Frecuencia](#frecuencia)

---

## Propósito

El UAT verifica que los flujos completos de usuario funcionan end-to-end, incluyendo:

- Registro y configuración de una organización
- Autenticación y gestión de sesiones
- Asignación de roles y verificación de acceso
- Registro y consumo de aplicaciones cliente

Se ejecuta en un entorno lo más cercano posible a producción.

[↑ Volver al inicio](#uat)

---

## Escenarios

| Escenario | Flujo | Criterio de Aceptación |
|-----------|-------|------------------------|
| Registro de organización | Crear tenant + primer usuario admin | Tenant activo, admin puede autenticarse |
| Login de usuario | Credenciales válidas | Sesión activa, token recibido |
| Login fallido | Credenciales inválidas | Error claro, sin token |
| Cambio de contraseña | Usuario autenticado cambia contraseña | Nueva contraseña funciona, antigua no |
| Asignación de rol | Admin asigna rol a usuario | Usuario tiene acceso correcto en siguiente sesión |
| Registro de aplicación | Admin registra app cliente | App puede solicitar tokens |
| Verificación de token | App cliente verifica token | Respuesta con claims correctos |
| Revocación de sesión | Usuario cierra sesión | Token invalidado, no funciona más |

[↑ Volver al inicio](#uat)

---

## Scripts de Validación

```bash
#!/bin/bash
# scripts/uat-validate.sh
# Requiere: jq, curl

BASE_URL="${1:-http://localhost:8080}"
TENANT="acme-test"

echo "=== UAT Validation: $TENANT ==="

# 1. Login
TOKEN=$(curl -sf -X POST "$BASE_URL/api/v1/tenants/$TENANT/oauth2/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password&username=admin@acme.test&password=Test1234!" \
  | jq -r .access_token)

[ -n "$TOKEN" ] && echo "✅ Login OK" || { echo "❌ Login FAILED"; exit 1; }

# 2. Crear usuario
USER_ID=$(curl -sf -X POST "$BASE_URL/api/v1/tenants/$TENANT/users" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"email":"newuser@acme.test","username":"newuser"}' \
  | jq -r .data.id)

[ -n "$USER_ID" ] && echo "✅ Create user OK ($USER_ID)" || { echo "❌ Create user FAILED"; exit 1; }

echo "=== UAT passed ==="
```

[↑ Volver al inicio](#uat)

---

## Checklist

Antes de marcar un release como aprobado:

- [ ] Todos los escenarios de la tabla ejecutados manualmente
- [ ] Scripts de validación corrieron sin errores
- [ ] Casos de error probados (credenciales inválidas, roles insuficientes)
- [ ] Tiempo de respuesta aceptable (< 2s en endpoints de sesión)
- [ ] Sin errores 5xx en logs durante la ejecución

[↑ Volver al inicio](#uat)

---

## Frecuencia

| Momento | Quién |
|---------|-------|
| Pre-release a producción | Equipo de QA o producto |
| Post-hotfix crítico | Equipo técnico |

[↑ Volver al inicio](#uat)

---

[← Índice](./README.md) | [< Anterior](./smoke-tests.md) | [Siguiente >](./security-testing.md)
