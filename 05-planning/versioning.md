[← Índice](./README.md) | [< Anterior](./epics.md)

---

# Versioning

Estrategia de versiones de API, compatibilidad y reglas de evolución del sistema.

## Contenido

- [Filosofía](#filosofía)
- [Versionado de API](#versionado-de-api)
- [Estrategia de versiones](#estrategia-de-versiones)
- [Compatibilidad](#compatibilidad)
- [Comunicación de cambios](#comunicación-de-cambios)

---

## Filosofía

Keygo sigue el principio de **compatibilidad hacia atrás robusta**:

> Cada versión estable debe funcionar para los consumidores existentes sin cambios. La responsabilidad de la migración recae en Keygo, no en los consumidores.

Esto significa:
- **Nunca romper una API estable** sin una ruta de migración clara
- **Versionar agresivamente** hasta estar seguro de que la API es estable
- **Deprecar primero, remover después** — nunca en el mismo release

[↑ Volver al inicio](#versioning)

---

## Versionado de API

### Formato

```
v{Major}.{Minor}.{Patch}
```

| Componente | Significado | Cuándo cambia |
|------------|-------------|---------------|
| **Major** | Incompatibilidad de contrato | Se rompe compatibilidad hacia atrás |
| **Minor** | Nueva funcionalidad compatible | Se agrega feature sin romper |
| **Patch** | Bug fix sin cambio de contrato | Fix sin impacto en API |

### Ejemplos

| Cambio | Nueva versión |
|--------|---------------|
| Se agrega endpoint `POST /v1/users/invite` | v1.1.0 |
| Se modifica respuesta de `GET /v1/sessions` (se agrega campo) | v1.1.1 |
| Se REMUEVE campo `password` de respuesta de usuario | v2.0.0 |
| Se CAMBIA tipo de `role` de string a enum | v2.0.0 |

 [↑ Volver al inicio](#versioning)

---

## Estrategia de Versiones

### Fases del ciclo de vida

```
     ┌──────────┐
     │   0.x    │  ← Desarrollo (inestable, sin garantía)
     └────┬─────┘
          │
          ▼
     ┌──────────┐
     │   1.0    │  ← Primera versión estable
     └────┬─────┘
          │
    ┌─────┴─────┐
    │           │
 ▼ ▼           ▼
1.x           2.x
(Stable)     (Next)
```

| Fase | Versionado | Garantía |
|------|------------|----------|
| **Desarrollo** | 0.x | Ninguna. Puede cambiar sin notice. |
| **Beta** | 0.x con sufijo `-beta.N` | Cambio aviso con 1 sprint de anticipación |
| **Estable** | 1.x | Compatibilidad garantizada |
| **Deprecated** | 1.x con feature 2.x | Funcionalidad marcada para remoción en siguiente major |
| **Legacy** | Mantenimiento de seguridad únicamente | Sin nuevas features |

### Reglas de promotion

| De | A | Requisito |
|----|---|-----------|
| 0.x | 1.0 | Todos los RFs de MVP implementados, tests passing, docs completos |
| 1.x | 2.0 | Breaking change requiere haber pasado 1+ mes en 1.x sin incidentes críticos |

 [↑ Volver al inicio](#versioning)

---

## Compatibilidad

### Tipos de cambio

| Tipo | Ejemplo | Compatible? |
|------|---------|-------------|
| **Agregar campo** | `{ "user": { "id": "1", "name": "Jane" } }` → agregar `"email"` | ✅ Sí |
| **Agregar endpoint** | Nuevo `GET /v1/users/invite` | ✅ Sí |
| **Agregar valor a enum** | `"role": "admin"` → agregar `"superadmin"` | ✅ Sí |
| **Cambiar nombre de campo** | `"username"` → `"login"` | ❌ No |
| **Cambiar tipo** | `"id": "string"` → `"id": "number"` | ❌ No |
| **Remover campo** | Quitar `"phone"` de respuesta | ❌ No |
| **Cambiar semántica** | `"active": true` ahora significa algo diferente | ❌ No |
| **Restringir valores** | `"status": "any"` → `"status": "active|inactive"` | ❌ No |

### Regla de oro

> **Si el consumidor actual deja de funcionar, es un breaking change.**

 [↑ Volver al inicio](#versioning)

---

## Versionado de Recursos

### Endpoints

Todos los endpoints incluyen la versión en la URL:

```
GET    /v1/organizations
POST   /v1/users
GET    /v1/sessions/{id}
PATCH  /v1/applications/{id}
```

### Versionado de Schema

El schema se versiona con la API:

- `GET /v1/schema` retorna el OpenAPI spec de v1
- Cada versión mayor tiene su propio spec: `/v1/openapi.yaml`, `/v2/openapi.yaml`

### Headers

Para clientes que no pueden usar version en URL:

```
Accept: application/vnd.keygo.v1+json
```

 [↑ Volver al inicio](#versioning)

---

## Comunicación de Cambios

### Changelog

Cada release incluye:

1. **Fecha de release**
2. **Tipo de cambio** (Major/Minor/Patch)
3. **Features nuevos**
4. **Cambios incompatibles** (si aplica)
5. **Deprecations**
6. **Fixes**

### Notificación

| Tipo de release | Canal | Timing |
|-----------------|-------|--------|
| Patch | GitHub Releases | Post-deploy |
| Minor | GitHub Releases + Email a integradores | 1 semana antes |
| Major | GitHub Releases + Email + Llamada a integradores | 1 mes antes + migration guide |

### Deprecation

```http
HTTP/1.1 299 This endpoint will be removed in v2.0.0
Deprecation: true
Sunset: Sat, 01 Jan 2025 00:00:00 GMT
Link: <https://keygo.docs/api/v2/users>; rel="successor-version"
```

- **Deprecation**: Header que indica que la feature está deprecada
- **Sunset**: Fecha en que se removerá
- **Link**: Ruta a la nueva versión

 [↑ Volver al inicio](#versioning)

---

## Matriz de Versiones por Fase

| Fase | Versión objetivo | API estable | Portal |
|------|-----------------|-------------|--------|
| v0.1 | 0.1.x | Parcial (Auth) | No |
| v0.2 | 0.2.x | Parcial (+RBAC) | No |
| v0.3 | 0.3.x | Beta | Beta |
| v1.0 | 1.0.0 | v1 | v1 |
| v1.x | 1.x.y | v1 | v1 |
| v2.0 | 2.0.0 | v2 | v2 |

**Nota**: La versión 1.0.0 se alcanza cuando el MVP está completo y estable.

[↑ Volver al inicio](#versioning)

---

[← Índice](./README.md) | [< Anterior](./epics.md)