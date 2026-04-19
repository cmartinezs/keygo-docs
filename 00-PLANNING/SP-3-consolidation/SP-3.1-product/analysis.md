# SP-3.1 Analysis - Consolidación de 01-product

**Estado**: Análisis en progreso  
**Fecha**: 2026-04-19

---

## Contenido Actual a Consolidar

### Backend (00-BACKEND/01-product/)
```
glossary.md               550 líneas - Muy completo, alfabético
requirements.md           200+ líneas - Requisitos por bounded context  
vision.md                 (no existe, contenido en requirements)
constraints-limitations.md (era pain-points.md)
dependency-map.md         Presente
diagrams/                 6 diagrams (auth, billing, account, tenant, use-cases, README)
README.md                 Presente
bounded-contexts.md       Presente
current-state.md          Presente
solution-proposal.md      Presente
```

### Frontend (01-FRONTEND/01-product/)
```
02-role-model.md          24 líneas - Tabla de 3 roles
01-vision-and-scope.md    (no visto, necesito leer)
README.md                 Presente
```

---

## Análisis Detallado

### 🔵 GLOSSARY.md (Backend)

**Contenido**: Diccionario alfabético de 100+ términos
- **Cobertura**: A-Z (A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, R, S, T, U, V, W, X, Y, Z)
- **Categorías**: Auth, Tenants, Billing, Account, Arquitectura, API
- **Contextos**: Cada término tiene contexto claro, tabla asociada (si aplica), ejemplos
- **Términos principales**:
  - Auth: Access Token, Authorization Code, Bearer Token, JWT, PKCE, etc.
  - Tenants: Tenant, Tenant User, Tenant Admin, Admin, App, AppRole, Membership
  - Billing: Contractor, Contract, AppPlan, Entitlement, Billing Period
  - Arquitectura: Bounded Context, Hexagonal Architecture, Port, Use Case, Domain Model

**Calidad**: ⭐⭐⭐⭐⭐ Excelente
- Bien estructurado
- Contextualizado
- Referencias cruzadas a tablas DB
- Último actualizado: 2026-04-05 (reciente)

**Frontend equivalente**: NO EXISTE
- Frontend usa solo 3 roles simples (ADMIN, ADMIN_TENANT, USER_TENANT)
- No tiene glossary completo

**Recomendación**: USAR backend glossary como single source of truth, EXPANDIR si frontend necesita términos adicionales.

---

### 🔵 ROLE-MODEL.md (Frontend)

**Contenido**: Tabla de 3 roles + referencias a otras docs
```
ADMIN              - Operación global
ADMIN_TENANT       - Gestión tenant
USER_TENANT        - Uso cotidiano
```

**Calidad**: ⭐⭐⭐ OK pero muy corto
- Solo tabla + referencias
- No define qué puede hacer cada rol (detalles en otros docs)
- Referencias a: role-based-areas.md, auth-and-session.md

**Relación con backend glossary**: 
- Glossary backend tiene definiciones más detalladas:
  - Admin (Rol) - línea 19
  - Admin Tenant (Rol) - línea 27
  - User Tenant (Rol) - línea 485

**Recomendación**: MERGE role-model.md contenido EN glossary como sección "Roles" expandida.

---

### 🔵 REQUIREMENTS.md (Backend)

**Contenido**: Requisitos funcionales por bounded context (200+ líneas)
- **Estructura**: RF-A1, RF-A2, ... (Authentication), RF-B1, RF-B2 (Billing), etc.
- **Información por requisito**: Descripción, endpoint, parámetros, validaciones, status (✅ o ⏳), propuestas asociadas
- **Cobertura actual**: A (Authentication) completamente documentado

**Calidad**: ⭐⭐⭐⭐ Muy bueno
- Detallado
- Status claro
- Referencias a tickets (T-XXX)
- Bien estructurado

**Frontend equivalente**: NO EXISTE
- Frontend no tiene requirements específicos documentados

**Recomendación**: USAR backend requirements como source, EXPANDIR otros bounded contexts (Tenants, Billing, Account).

---

### 🔴 VISION.md 

**Existe**: NO (solo está en requirements.md implícitamente)

**Necesario**: SÍ (según SP-2 information-architecture)
- Debe ser statement claro de QUÉ estamos construyendo
- 1-2 párrafos, no confundir con requisitos técnicos

**Frontend**: 01-vision-and-scope.md existía pero no lo leí
- Necesito verificar qué contiene

**Recomendación**: CREAR vision.md AG NÓSTICO a partir de ambos documentos.

---

### 🔴 CONSTRAINTS-LIMITATIONS.md

**Existe**: NO (era pain-points.md)

**Necesario**: SÍ (según SP-2 architecture)
- Registrar limitaciones, pain points identificados
- Restricciones técnicas, no funcionales

**Contenido potencial**:
- FROM backend: pain-points.md (existía)
- FROM frontend: constraints identificados en vision-and-scope

**Recomendación**: CREAR consolidando pain-points.

---

## Plan de Consolidación

**Principio**: Los nuevos documentos en `01-product/` REEMPLAZAN completamente los raw files.
- ❌ NO mantener referencias entre nuevo y raw
- ✅ Documentos nuevos son autónomos y completos
- ✅ Raw files serán eliminados después de SP-3 completo

### Fase 1: Crear Glossary Unificado ✅ (THIS SPRINT)

**Archivos fuente**:
- 📖 00-BACKEND/01-product/glossary.md (principal - 550 líneas)
- 📖 01-FRONTEND/01-product/02-role-model.md (input - 24 líneas)

**Procesamiento**:
1. TOMAR contenido de backend glossary como base (es más completo)
2. EXTRAER definiciones de roles de frontend role-model.md
3. EXPANDIR sección "Roles" con definiciones detalladas (ADMIN, ADMIN_TENANT, USER_TENANT)
4. CREAR NUEVO: `01-product/glossary.md` (completamente autónomo)

**Output**: `01-product/glossary.md`
- Contenido completo (100+ términos alfabéticos)
- Roles bien definidos
- **SINGLE SOURCE OF TRUTH**
- Independiente de raw docs (no hace referencia a ellos)

---

### Fase 2: Crear Requirements Consolidado ✅ (THIS SPRINT)

**Archivos fuente**:
- 📖 00-BACKEND/01-product/requirements.md (principal - 200+ líneas)
- ❌ 01-FRONTEND/01-product/ (no encontrado, solo backend)

**Procesamiento**:
1. TOMAR contenido backend requirements completo (es fuente principal)
2. CREAR NUEVO: `01-product/requirements.md` (reemplaza backend requirements.md)
3. NOTAR: Otros bounded contexts (Tenants, Billing, Account) están incompletos - dejar placeholder

**Output**: `01-product/requirements.md`
- Estructura: Requisitos funcionales + no-funcionales por bounded context
- Auth (RF-A): Completo ✅
- Tenants (RF-T): Placeholder ⏳
- Billing (RF-B): Placeholder ⏳
- Account (RF-C): Placeholder ⏳
- Independiente de raw docs

---

### Fase 3: Crear Vision.md Agnóstico ✅ (THIS SPRINT)

**Archivos fuente**:
- 📖 01-FRONTEND/01-product/01-vision-and-scope.md (17 líneas - inspiración)
- 📖 Backend: implícito en requirements

**Procesamiento**:
1. LEER vision-and-scope.md frontend
2. EXTRAER "vision" part (no "scope")
3. CREAR NUEVO: `01-product/vision.md` agnóstico (What, For whom, Key Principles, Core Features)
4. Sin mencionar backend/frontend/Java/React

**Output**: `01-product/vision.md`
- AGNÓSTICO (aplicable a cualquier implementación)
- Claro: What are we building? For whom? What are key principles?
- Conciso: 1-2 páginas máximo
- Independiente de raw docs

---

### Fase 4: Crear Constraints-Limitations.md ✅ (THIS SPRINT)

**Archivos fuente**:
- 📖 00-BACKEND/01-product/pain-points.md (80+ líneas)
- 📖 FROM vision-and-scope.md (si aplica)

**Procesamiento**:
1. TOMAR contenido pain-points.md
2. CREAR NUEVO: `01-product/constraints-limitations.md` (renombrado para clarity)
3. MANTENER estructura: Pain points con causa raíz + impacto + soluciones

**Output**: `01-product/constraints-limitations.md`
- Pain points de desarrollo (conocimiento disperso, desalineación, inconsistencias, falta diagramas)
- Restricciones técnicas
- Non-functional limitations
- Independiente de raw docs

---

### Fase 5: Organize Diagrams ⏳ (POST-CONSOLIDATION)

**Archivos presentes**:
- diagrams/authentication-flow.md
- diagrams/billing-flow.md
- diagrams/account-flow.md
- diagrams/tenant-management-flow.md
- diagrams/use-cases.md
- diagrams/README.md

**Action**: Revisar si están bien organizadas, mantener como están

---

## Orden de Trabajo (Esta sesión)

1. **Consolidate glossary** (30 min)
   - Leer role-model.md completo
   - Expandir roles section en glossary backend
   - Crear 01-product/glossary.md nuevo

2. **Consolidate requirements** (20 min)
   - Copiar requirements backend
   - Crear 01-product/requirements.md nuevo

3. **Create vision.md** (20 min)
   - Leer vision-and-scope.md
   - Escribir agnóstico vision.md

4. **Create constraints.md** (15 min)
   - Mover pain-points.md
   - Criar constraints-limitations.md

5. **Create README.md para 01-product/** (10 min)
   - Index local de la sección

6. **Commit y documentar** (5 min)

**Total tiempo estimado**: 1.5 horas ✅

---

## Decisiones de Consolidación

### Glossary

**¿Mantener backend glossary en 00-BACKEND/01-product/?**
- ❌ NO - migrar a 01-product/glossary.md (nueva estructura)
- ✅ Después de SP-3 completo, marcar 00-BACKEND/ como deprecated

**¿Qué pasa con role-model.md?**
- ❌ NO mantener - merge content en glossary
- ✅ Después marcar 01-FRONTEND/ como deprecated

**¿Quién es source of truth?**
- ✅ 01-product/glossary.md (nuevo, centralizad

o)
- ❌ NO 00-BACKEND/ (será marcado deprecated)

---

### Requirements

**¿Mantener backend requirements en 00-BACKEND/?**
- ❌ NO - migrar a 01-product/requirements.md
- ✅ Después marcar 00-BACKEND/ como deprecated

**¿Agregar reqs de frontend?**
- ✅ SÍ si existen, pero no encontrados por ahora
- ❌ Por ahora solo consolidar backend (que es más completo)

---

### Vision

**¿Crear nuevo vision.md?**
- ✅ SÍ - agnóstico, no tech-specific

**¿Usar vision-and-scope.md frontend?**
- ✅ SÍ como input, extraer "vision" part

---

## Archivos a Crear/Mover

| Archivo Actual | Nueva Ubicación | Acción | Nuevo Name |
|---|---|---|---|
| `00-BACKEND/01-product/glossary.md` | `01-product/glossary.md` | MOVE + EXPAND | glossary.md |
| `01-FRONTEND/01-product/02-role-model.md` | DELETE (merge en glossary) | REMOVE | — |
| `00-BACKEND/01-product/requirements.md` | `01-product/requirements.md` | MOVE | requirements.md |
| `01-FRONTEND/01-product/01-vision-and-scope.md` | EXTRACT → `01-product/vision.md` | EXTRACT | vision.md |
| `00-BACKEND/01-product/pain-points.md` | `01-product/constraints-limitations.md` | MOVE + RENAME | constraints-limitations.md |

---

## Próximo Paso

👉 Proceder con consolidación (ver merge-plan.md para detalles específicos de qué agregar/cambiar)
