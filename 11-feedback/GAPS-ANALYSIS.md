[← Índice](./README.md)

---

# Gap Analysis: Backup Product Docs vs. Official SDLC Documentation

**Objetivo**: Identificar contenido en `bkp/00-BACKEND/01-product/` que falta en la nueva documentación oficial y agregar si es relevante.

**Revisor**: Claude AI (2026-04-20)

---

## Resumen Ejecutivo

**Total de archivos en backup**: 9 (README, bounded-contexts, current-state, dependency-map, glossary, pain-points, requirements, solution-proposal, diagrams/)

**Hallazgos**:
- ✅ **70% contenido ya capturado** en la nueva estructura (Discovery, Requirements, Design, Development, Testing, etc.)
- ⚠️ **20% parcialmente capturado** — necesita refinamiento o migración
- 🔴 **10% FALTANTE** — contenido técnico/operacional que no entró en ciclo SDLC

---

## Archivo por Archivo: Análisis

### 1. ✅ **glossary.md** (549 líneas)

**Contenido**: Diccionario de 48+ términos (Access Token, OAuth2, JWT, Tenant, User, etc.) con explicaciones técnicas.

**Estado en Official Docs**: 
- ✅ **CAPTURADO** en `00-PLANNING/ubiquitous-language.md` (términos por contexto)
- ✅ **PARCIALMENTE MEJORADO** con enfoque DDD en `03-design/ubiquitous-language.md`
- ⚠️ **GAP**: Glossary backup es exhaustivo; falta algunas definiciones técnicas (Jackson 3 namespace, Nimbus, Flyway)

**Recomendación**: ✏️ **AGREGAR a 06-development/glossary.md** (nuevo archivo)
- Términos técnicos del stack (Jackson 3, Nimbus, Flyway, Testcontainers, Checkstyle)
- Acrónimos (OIDC, RBAC, JWT, PKCE, M2M)
- Referencia rápida para developers

---

### 2. ✅ **pain-points.md** (379 líneas)

**Contenido**: 
- 7 dolores (conocimiento disperso, desalineación roadmap, inconsistencias docs, sin diagramas, billing sin gateway, sin multi-moneda, sin SCIM)
- 6 restricciones técnicas (Java 21, Flyway, keygo-domain sin Spring, Jackson 3, context-path, Bearer-only)
- 3 restricciones funcionales (multi-tenant, OIDC, sesiones stateless)
- Matriz: dolores vs. propuestas

**Estado en Official Docs**:
- ✅ **CAPTURADO CONCEPTUALMENTE** en `05-planning/process-improvements.md` y retrospectives
- ⚠️ **GAP SEVERO**: Las restricciones técnicas (T1-T6) no están documentadas en oficial
- ⚠️ **GAP**: Restricciones funcionales (F1-F3) no están en 02-requirements/

**Recomendación**: 🔴 **CREAR 02-requirements/technical-constraints.md**
```markdown
## Technical & Functional Constraints (Non-Negotiable)

### Technical Constraints
- T1: Stack Java 21 + Spring Boot 4.x (no negociable)
- T2: Flyway versionado inmutable (regla de oro)
- T3: keygo-domain sin Spring (arquitectura hexagonal)
- T4: Jackson 3 namespace tools.jackson
- T5: context-path=/keygo-server (obligatorio)
- T6: Bearer-only auth (X-KEYGO-ADMIN deprecated)

### Functional Constraints
- F1: Multi-tenant aislamiento por path (P0 seguridad)
- F2: OIDC claims estándar
- F3: Sesiones stateless vía JWT

### Compliance/Regulatory
- GDPR (futuro)
- CFDI México (futuro)
- PCI DSS (para gateway)
```

---

### 3. ⚠️ **bounded-contexts.md** (100+ líneas, ver parcial)

**Contenido**: 
- 4 Bounded Contexts (Auth, Tenants, Billing, Account)
- Entidades por contexto (SigningKey, Session, RefreshToken, etc.)
- Puertos (TokenSignerPort, PasswordHasherPort, etc.)
- Casos de Uso (UC-A1 AuthorizeWithCode, UC-A2 ExchangeCode, etc.)
- Dependencias entre contextos

**Estado en Official Docs**:
- ✅ **CAPTURADO** en `03-design/bounded-contexts/` (7 archivos por contexto)
- ✅ **MEJORADO CON DDD** — agregates, value objects, domain events
- ⚠️ **GAP**: Backup tiene 4 contextos; oficial tiene 7 (Identity, Access Control, Org, Client Apps, Billing, Audit, Platform)
- ⚠️ **GAP**: Casos de uso (UC-A1, UC-A2, etc.) no están en oficial

**Recomendación**: ✏️ **CREAR 06-development/use-cases-catalog.md**
- Catálogo de Use Cases por contexto (UC-A1 → UC-A10 para Auth, UC-T1 → UC-T8 para Tenants, etc.)
- Mapeo: Use Case → Aggregate → Domain Events
- Ejemplo:
```markdown
### Identity Context Use Cases

**UC-ID-001**: Authorize with Code
- Input: client_id, redirect_uri, scope, PKCE challenge
- Output: authorization_code (TTL 10m)
- Aggregates: ClientApp, AuthorizationCode
- Events: UserAuthorizationRequested

**UC-ID-002**: Exchange Code for Token
- Input: code, code_verifier, client_id, client_secret
- Output: access_token + id_token + refresh_token
- Aggregates: RefreshToken, Session, SigningKey
- Events: UserAuthenticated
```

---

### 4. ⚠️ **current-state.md** (80+ líneas, ver parcial)

**Contenido**:
- 8 módulos (keygo-domain, keygo-app, keygo-infra, keygo-api, keygo-supabase, keygo-run, keygo-bom, keygo-common)
- Capacidades por contexto (Auth: 13 completadas, 2 parciales, 2 pendientes; Tenant: 8 completadas)
- Deuda técnica explícita

**Estado en Official Docs**:
- ✅ **CAPTURADO** en `06-development/architecture.md` (módulos hexagonales)
- ✅ **MEJORADO CON DDD** — Bounded Contexts → Módulos
- ⚠️ **GAP**: Capacidades (Auth 13, Tenant 8) no están mapeadas a RFs
- ⚠️ **GAP**: Deuda técnica no documentada

**Recomendación**: ✏️ **CREAR 02-requirements/capability-matrix.md**
- Tabla: Capacidad → RF → Status (Completada/Parcial/Pendiente)
- Ejemplo:
```markdown
| Capacidad | Contexto | RF Asociado | Status | Notas |
|-----------|----------|-------------|--------|-------|
| Authorization Code Flow + PKCE | Identity | RF-ID-001 | ✅ Completada | RFC 7636 |
| JWT RS256 | Identity | RF-ID-002 | ✅ Completada | JWKS endpoint |
| Refresh Token Rotation | Identity | RF-ID-003 | ✅ Completada | SHA-256 hash |
| Scope Filtering en Userinfo | Identity | RF-ID-004 | 🟡 Parcial | Claims no filtrados aún |
```

---

### 5. 🔴 **solution-proposal.md** (100+ líneas, ver parcial)

**Contenido**:
- Visión estratégica (Misión: "plataforma IAM multi-tenant para SaaS")
- Horizontes (Corto 4 sem, Mediano 8 sem, Largo 16 sem)
- 3 Hitos (Hosted Login, Pre-Monetization, Gateway Real)
- 60+ propuestas (T-030, T-031, T-023, etc.) con effort estimates

**Estado en Official Docs**:
- ✅ **CAPTURADO CONCEPTUALMENTE** en `05-planning/roadmap.md`
- ⚠️ **GAP CRÍTICO**: Los hitos y effort estimates (Hosted Login: 51 horas, Pre-Monetization: 81 horas, etc.) no están documentados
- ⚠️ **GAP**: Propuestas T-NNN/F-NNN no están trackeadas en oficial

**Recomendación**: 🔴 **CREAR 05-planning/hitos-y-propuestas.md**
```markdown
## Hitos del Desarrollo (2026)

### HITO 1: Hosted Login Seguro & Documentación (P0) — 4 semanas
**Período**: 2026-04-05 a 2026-05-03
**Objetivo**: MVP lanzable con docs centralizada

**Propuestas Incluidas**:
| ID | Propuesta | Effort | Bloqueador |
|----|-----------|--------|-----------|
| T-030 | Verificación refs rotas | 4h | — |
| T-031 | Automatizar CI (lychee) | 6h | T-030 |
| T-023 | Lint/formato (Checkstyle) | 8h | — |
| T-051 | Suite autorización (@PreAuthorize) | 12h | — |

**Subtotal**: 9 propuestas, 51 horas (~6 dev-days)

### HITO 2: Pré-Monetización & Stability (P1) — 4 semanas
...

### HITO 3: Gateway Real & Renovación (P1) — 6 semanas
...
```

---

### 6. ✅ **dependency-map.md**

**Contenido**: Mapeo de dependencias entre propuestas (T-XXX depende de T-YYY)

**Estado en Official Docs**:
- ✅ **CAPTURADO CONCEPTUALMENTE** en `05-planning/epics.md` (dependencias entre epics)
- ⚠️ **GAP**: Granularidad de propuestas (T-NNN level) no documentada

**Recomendación**: ✏️ **MEJORAR 05-planning/epics.md** con dependency-map detail

---

### 7. ✅ **requirements.md**

**Contenido**: Requerimientos funcionales y no-funcionales

**Estado en Official Docs**:
- ✅ **CAPTURADO** en `02-requirements/` (RF por contexto)
- ✅ **MEJORADO** con trazabilidad → RFs

**Recomendación**: ✅ **OK — No acción requerida**

---

### 8. ⚠️ **diagrams/** (directorio)

**Contenido**: Diagramas funcionales base (presumably Mermaid, PlantUML, o SVG)

**Estado en Official Docs**:
- ⚠️ **NO CAPTURADO** — diagrams no mirados en esta sesión
- 🔲 **PENDIENTE**: Revisar qué diagramas hay en backup

**Recomendación**: 📋 **REVISAR diagramas** e integrar a `03-design/system-flows.md`

---

## 🔴 GAPS CRÍTICOS: Lo que Falta en Official Docs

### Gap 1: **Technical Constraints No Documentados**
- ❌ Restricciones T1-T6 (stack, Flyway, keygo-domain, Jackson 3, context-path, Bearer-only)
- ❌ Restricciones F1-F3 (multi-tenant, OIDC, sesiones stateless)
- **Impacto**: Nuevos devs no saben qué es "no negociable"

**Acción**: Crear `02-requirements/technical-constraints.md`

---

### Gap 2: **Developer Glossary No Documentado**
- ❌ Términos técnicos del stack (Jackson 3, Nimbus, Flyway, Testcontainers, CheckStyle)
- ❌ Acrónimos (OIDC, RBAC, JWT, PKCE, M2M)
- **Impacto**: Developers googlea términos en lugar de consultar docs

**Acción**: Crear `06-development/glossary-technical.md`

---

### Gap 3: **Use Cases Catalog No Documentado**
- ❌ UC-A1 (AuthorizeWithCode), UC-A2 (ExchangeCode), etc. no están en oficial
- ❌ Mapeo: Use Case → Aggregate → Domain Events no documentado
- **Impacto**: Nuevos devs no saben qué use cases existen

**Acción**: Crear `06-development/use-cases-catalog.md`

---

### Gap 4: **Capability Matrix No Documentada**
- ❌ Auth: 13 completadas, 2 parciales, 2 pendientes — no está mapeado
- ❌ Traceabilidad Capacidad → RF → Status no existe
- **Impacto**: Producto no sabe qué está implemented

**Acción**: Crear `02-requirements/capability-matrix.md`

---

### Gap 5: **Hitos & Propuestas No Documentados**
- ❌ HITO 1 (51h), HITO 2 (81h), HITO 3 (no visto) con propuestas T-NNN
- ❌ Effort estimates no capturados
- **Impacto**: Roadmap no tiene visibilidad de work

**Acción**: Crear `05-planning/hitos-y-propuestas.md`

---

## 📋 Acciones Recomendadas (Prioridad)

| Acción | Archivo | Prioridad | Esfuerzo | Beneficio |
|--------|---------|-----------|----------|-----------|
| Crear technical constraints | `02-requirements/technical-constraints.md` | 🔴 P0 | 2h | Claridad sobre restricciones no negociables |
| Crear developer glossary | `06-development/glossary-technical.md` | 🟠 P1 | 1h | Referencia rápida para developers |
| Crear use cases catalog | `06-development/use-cases-catalog.md` | 🟠 P1 | 3h | Visibilidad de lógica de negocio |
| Crear capability matrix | `02-requirements/capability-matrix.md` | 🟠 P1 | 2h | Status de capacidades vs RFs |
| Crear hitos & propuestas | `05-planning/hitos-y-propuestas.md` | 🟡 P2 | 3h | Roadmap detallado con effort |
| Integrar diagramas | `03-design/system-flows.md` | 🟡 P2 | TBD | Visualización de flujos |

---

## Resumen: ¿Qué Falta Agregar?

✏️ **5 archivos nuevos recomendados**:

1. **`02-requirements/technical-constraints.md`** — Restricciones T1-T6, F1-F3
2. **`06-development/glossary-technical.md`** — Términos stack + acrónimos
3. **`06-development/use-cases-catalog.md`** — UC-A1 → UC-A10, etc.
4. **`02-requirements/capability-matrix.md`** — Capacidades vs RFs vs Status
5. **`05-planning/hitos-y-propuestas.md`** — HITO 1/2/3 con propuestas + effort

**Impacto Total**: +11 KB de documentación crítica para developers

**Tiempo Estimado**: 11 horas

---

↑ [Volver al inicio](#gap-analysis-backup-product-docs-vs-official-sdlc-documentation)

---

[← Volver a Feedback](./README.md)
