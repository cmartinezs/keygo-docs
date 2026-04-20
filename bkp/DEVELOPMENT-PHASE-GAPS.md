# Development Phase (SP-D7) — Gap Analysis

**Fecha:** 2026-04-21  
**Revisión:** Comparativa oficial (06-development/) vs. backup (bkp/00-BACKEND/03-architecture/)

---

## Resumen Ejecutivo

- **Documentos en oficial:** 5 + subdirs (README, architecture, api-reference, coding-standards, glossary-technical, workflow)
- **Documentos en backup:** 8 + subdirs
- **Brechas identificadas:** 5 documentos del backup **NO están integrados** en la versión oficial
- **Criticidad:** 4 CRÍTICOS (oauth2, authorization, api-versioning, database-schema), 1 IMPORTANTE (provisioning)

---

## Documentos en Oficial (06-development/)

| Archivo | Líneas | Completitud | Observaciones |
|---------|--------|------------|---|
| `README.md` | 50 | ✅ 100% | Índice + navegación de secciones |
| `architecture.md` | 985 | ✅ 100% | Muy completo: hexagonal, bounded contexts, patrones DDD, multi-tenancy |
| `api-reference.md` | ? | ? | No revisado aún |
| `coding-standards.md` | ? | ? | No revisado aún |
| `glossary-technical.md` | ? | ? | No revisado aún |
| `workflow.md` | ? | ? | No revisado aún |
| `adrs/` | ? | ? | ADRs presentes |
| `ai/` | ? | ? | AI guidelines presentes |
| `knowledge/` | ? | ? | Tasks, lessons, inconsistencies |

---

## Documentos en Backup (bkp/00-BACKEND/03-architecture/)

| Archivo | Líneas | Status | Motivo de Ausencia |
|---------|--------|--------|---|
| `architecture.md` | ~110 | ✅ INTEGRADO | Versión expandida en oficial (~985 líneas vs ~110) |
| `api-reference.md` | ? | ✅ EN OFICIAL | Existe con otro nombre probablemente |
| `oauth2-oidc-multidomain-contract.md` | ~400 | ❌ **CRÍTICO** | **FALTA INTEGRAR** — Especificación OAuth2/OIDC multi-nivel |
| `authorization-patterns.md` | ~300 | ❌ **CRÍTICO** | **FALTA INTEGRAR** — JWT claims, 3 niveles RBAC, @PreAuthorize |
| `api-versioning-strategy.md` | ~150 | ❌ **CRÍTICO** | **FALTA INTEGRAR** — Estrategia de versioning (URI path, semantic versioning) |
| `database-schema.md` | ~200 | ❌ **CRÍTICO** | **FALTA INTEGRAR** — ERD, migraciones Flyway, índices |
| `provisioning-strategy.md` | ~200 | ❌ IMPORTANTE | **FALTA INTEGRAR** — Multi-tenant provisioning flow |
| `observability.md` | ~150 | ⚠️ PARCIAL | Posiblemente cubierto en `architecture.md`, revisar |
| `security/` | ? | ⚠️ PARCIAL | Subdir con security details, revisar cobertura |

---

## Análisis Detallado de Brechas

### 1. **oauth2-oidc-multidomain-contract.md** — CRÍTICO

**Contenido del backup:**
- Arquitectura de dos niveles (Platform Auth + Tenant Auth)
- Flujo 1: PKCE Authorization Code (hosted login)
- Flujo 2: Token endpoint (code → access_token)
- Flujo 3: Refresh token rotation
- Flujo 4: Logout + revocación
- Validaciones por flujo
- Snippets de request/response con ejemplos reales

**Ubicación en oficial:** ⚠️ PARCIAL
- `architecture.md` menciona JWT claims (líneas 712-723)
- `system-flows.md` (03-design/) tiene flujos de dominio
- **FALTA:** Detalle técnico de contratos OAuth2/OIDC, dos niveles de auth, ejemplos HTTP

**Recomendación:**
- ✅ Crear `06-development/oauth2-oidc-contract.md` basado en backup
- Integrar con referencias a `system-flows.md` (03-design/)
- Complementar con `coding-standards.md` para implementación

**Esfuerzo:** 2-3 horas

---

### 2. **authorization-patterns.md** — CRÍTICO

**Contenido del backup:**
- Principio fundamental: "Identidad es global, pertenencia es por tenant, acceso es por app"
- JWT claims structure (sub, tenant_slug, roles, aud, iss)
- 3 niveles RBAC: Platform, Tenant, App
- @PreAuthorize patterns
- Validación de tenant scope
- Ejemplos de code

**Ubicación en oficial:** ⚠️ PARCIAL
- `architecture.md` líneas 712-741: JWT claims, 3 niveles RBAC, validación
- **FALTA:** Detalle de patrones específicos, tablas de equivalencia roles, ejemplo @PreAuthorize por nivel

**Recomendación:**
- ✅ Crear `06-development/authorization-patterns.md` expandido desde backup
- Integrar con link desde `architecture.md` sección "Seguridad"
- Incluir matriz de roles platform/tenant/app

**Esfuerzo:** 2-3 horas

---

### 3. **api-versioning-strategy.md** — CRÍTICO

**Contenido del backup:**
- Decisión: URI path versioning (/api/v1, /api/v2)
- Semantic versioning de API (v1.0 → v1.1 backward-compat, v1.0 → v2.0 breaking)
- Tipos de cambios: backward-compatible vs breaking
- Deprecation policy
- Ejemplos de cambios

**Ubicación en oficial:** ❌ NO EXISTE
- `api-reference.md` probablemente lista endpoints, pero NO estrategia de versioning

**Recomendación:**
- ✅ Crear `06-development/api-versioning-strategy.md` desde backup
- Incluir en README como referencia
- Vincular desde `api-reference.md`

**Esfuerzo:** 1-2 horas

---

### 4. **database-schema.md** — CRÍTICO

**Contenido del backup:**
- ERD (Entity-Relationship Diagram)
- Tablas principales (tenants, users, roles, permissions, contracts, invoices, etc.)
- Migraciones Flyway (V1 → V33+)
- Índices y constraints
- Estrategia soft-delete
- Multi-tenancy a nivel de schema

**Ubicación en oficial:** ❌ NO EXISTE
- `architecture.md` menciona "ddl-auto: validate" + Flyway, pero NO detalla schema

**Recomendación:**
- ✅ Crear `06-development/database-schema.md` desde backup
- Incluir ERD en Mermaid
- Documentar migraciones presentes y nomenclatura para nuevas (V34+)
- Vincular desde `architecture.md` sección "Persistencia"

**Esfuerzo:** 2-3 horas

---

### 5. **provisioning-strategy.md** — IMPORTANTE

**Contenido del backup:**
- Multi-tenant provisioning flow
- Resource allocation per tenant
- Quota management
- Scaling considerations

**Ubicación en oficial:** ⚠️ POSIBLEMENTE CUBIERTO
- `architecture.md` sección "Multi-Tenancy" cubre aislamiento, pero NO provisioning

**Recomendación:**
- ⚠️ Revisar si es crítico para Q2 2026 (probablemente NO)
- Crear `06-development/provisioning-strategy.md` si hay tempo
- Prioridad baja comparada con oauth2, authorization, api-versioning, database-schema

**Esfuerzo:** 1-2 horas (baja prioridad)

---

## Matriz de Impacto

| Documento | Criticidad | Dependencia | Devs Bloqueados | Riesgo |
|-----------|----------|-----------|---|---|
| oauth2-oidc-contract | 🔴 CRÍTICA | Frontend (consumo OAuth2) | Sí | Implementación inconsistente |
| authorization-patterns | 🔴 CRÍTICA | Backend (seguridad) | Sí | Vulnerabilidades de access control |
| api-versioning-strategy | 🔴 CRÍTICA | API design | Sí | Breaking changes sin plan |
| database-schema | 🔴 CRÍTICA | Backend/QA (schema validation) | Sí | Migraciones fallidas, inconsistencia |
| provisioning-strategy | 🟡 IMPORTANTE | Ops (capacity planning) | No | Subestimación de recursos |

---

## Plan de Integración Recomendado

### Fase 1: CRÍTICA (Hacer ahora)

1. **Crear `06-development/oauth2-oidc-contract.md`** (2-3h)
   - Base: bkp/00-BACKEND/03-architecture/oauth2-oidc-multidomain-contract.md
   - Expandir ejemplos HTTP con curl + responses
   - Aplicar DDD lens: mapear a bounded contexts (Identity, Access Control)
   - Link desde README + architecture.md

2. **Crear `06-development/authorization-patterns.md`** (2-3h)
   - Base: bkp/00-BACKEND/03-architecture/authorization-patterns.md
   - Expandir con tablas de equivalencia roles
   - Incluir @PreAuthorize examples por nivel
   - Link desde architecture.md

3. **Crear `06-development/database-schema.md`** (2-3h)
   - Base: bkp/00-BACKEND/03-architecture/database-schema.md
   - Agregar ERD en Mermaid
   - Documentar Flyway V1-V33 presentes
   - Definir convención para V34+
   - Link desde architecture.md

4. **Crear `06-development/api-versioning-strategy.md`** (1-2h)
   - Base: bkp/00-BACKEND/03-architecture/api-versioning-strategy.md
   - Integrar ejemplos con endpoints KeyGo reales
   - Link desde README + api-reference.md

**Subtotal Fase 1:** 8-11 horas

### Fase 2: IMPORTANTE (Si hay tempo)

5. **Crear `06-development/provisioning-strategy.md`** (1-2h)
   - Base: bkp/00-BACKEND/03-architecture/provisioning-strategy.md
   - Link desde architecture.md sección Multi-Tenancy

**Subtotal Fase 2:** 1-2 horas

### Fase 3: VALIDACIÓN

6. **Actualizar README** (0.5h)
   - Agregar links a nuevos documentos
   - Reordenar índice si es necesario

7. **Actualizar architecture.md** (1h)
   - Agregar referencias cruzadas a nuevos documentos
   - Secciones "Leer también" donde aplique

**Subtotal Fase 3:** 1.5 horas

---

## Decisiones de Integración

### Pregunta 1: ¿Expandir architecture.md o crear nuevos archivos?

**Decisión:** ✅ **Crear nuevos archivos**

**Razón:** architecture.md ya tiene 985 líneas. Mantenerlo como "architectural overview" (principios hexagonales, módulos, bounded contexts, patrones generales). Los detalles específicos (oauth2, authorization, versioning, database) van en archivos separados con Referencias cruzadas.

### Pregunta 2: ¿Integrar backup directamente o refactorizar?

**Decisión:** ✅ **Refactorizar aplicando DDD + actualizando ejemplos**

**Razón:** El backup es fuente de verdad de **contenido**, pero:
- Aplicar DDD lens (mapear a bounded contexts)
- Actualizar ejemplos HTTP con endpoints reales de KeyGo
- Armonizar con código actual (Java 21, Spring 4.x, Jackson 3)
- Verificar que no haya drift técnico vs. implementación

### Pregunta 3: ¿Prioridad: Fase 1 ahora o después?

**Decisión:** ✅ **Fase 1 ahora** (ANTES de que devs empiecen a implementar Q2 2026)

**Razón:** HITO 1 comienza en Q2 2026 con "Auth Security". Sin oauth2-oidc-contract + authorization-patterns, riesgo de implementación inconsistente. Las 8-11 horas de Fase 1 son inversión crítica.

---

## Trabajo Requerido

| Artefacto | Tipo | Autor | Tiempo | Bloqueante |
|-----------|------|-------|--------|-----------|
| oauth2-oidc-contract.md | Nuevo | Copilot (desde backup) | 2-3h | SÍ |
| authorization-patterns.md | Nuevo | Copilot (desde backup) | 2-3h | SÍ |
| database-schema.md | Nuevo | Copilot (desde backup) | 2-3h | SÍ |
| api-versioning-strategy.md | Nuevo | Copilot (desde backup) | 1-2h | SÍ |
| README + cross-refs | Actualización | Copilot | 1.5h | NO |
| provisioning-strategy.md | Nuevo | TBD | 1-2h | NO (baja prioridad) |

---

## Siguientes Pasos

1. **Usuario confirma:** ¿Proceder con integración de Fase 1?
2. **Si SÍ:** Ejecutar creación de 4 documentos críticos (8-11h)
3. **Después:** Actualizar referencias, validar links, hacer commit
4. **Fase 2:** Evaluar si hay tempo para provisioning-strategy.md

---
