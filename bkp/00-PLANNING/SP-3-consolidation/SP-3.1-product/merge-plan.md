# SP-3.1 Merge Plan - Acciones Específicas

**Estado**: Plan ejecutable  
**Fecha**: 2026-04-19  
**Tiempo estimado**: 1.5 horas

---

## 📋 Checklist de Acciones

### ✅ ACCIÓN 1: Consolidar Glossary (30 min)

**Fuente**: 
- Backend: `00-BACKEND/01-product/glossary.md` (550 líneas - BASE)
- Frontend: `01-FRONTEND/01-product/02-role-model.md` (24 líneas - EXTRACT)

**Que hacer**:

1. Tomar glossary backend como base (es completo y bien estructurado)

2. Expandir la sección de Roles (ahora línea 19, 27, 485):
   ```markdown
   ## R
   
   ### **ADMIN / KEYGO_ADMIN (Rol)**
   Usuario con permisos en toda la plataforma KeyGo. Puede crear/suspender tenants, ver estadísticas globales. Scope global (no acotado a tenant).
   
   **Contexto:** Auth/Tenants/Platform  
   **Sinónimos:** KEYGO_ADMIN, SuperAdmin  
   **Responsabilidad:** Operación global de la plataforma KeyGo  
   **Navegación**: Dashboard global, tenants, usuarios de plataforma, estado del servicio  
   **Referencias**: Frontend role-based-areas.md, Backend auth-and-session.md
   ```

3. Agregar después de Admin Tenant:
   ```markdown
   ### **USER_TENANT / KEYGO_USER (Rol)**
   Usuario de una aplicación dentro de un tenant. Puede ver su perfil, sesiones, cambiar password. No gestiona otros usuarios.
   
   **Contexto:** Tenants/Account  
   **Sinónimos:** KEYGO_USER, TenantUser  
   **Responsabilidad:** Uso cotidiano, perfil y acceso personal  
   **Permisos:** GET /account/profile, DELETE /account/sessions, etc (no CRUD usuarios)  
   **Navegación**: Autoservicio: perfil, configuración, sesiones, preferencias
   ```

4. **Output**: Crear nuevo archivo en `01-product/glossary.md` (no en 00-BACKEND)
   - Copiar contenido completo de backend glossary.md
   - Agregar/expandir roles como arriba
   - Cambiar fecha de última actualización a 2026-04-19
   - Mantener estructura alfabética

**Validar**:
- [ ] Roles ADMIN, ADMIN_TENANT, USER_TENANT todas bien definidas
- [ ] Ningún conflicto de definiciones
- [ ] Contextos claros

---

### ✅ ACCIÓN 2: Consolidar Requirements (20 min)

**Fuente**: 
- Backend: `00-BACKEND/01-product/requirements.md` (200+ líneas - BASE)
- Frontend: No encontrado

**Que hacer**:

1. Copiar `00-BACKEND/01-product/requirements.md` completo

2. **Crear**: `01-product/requirements.md` nuevo con:
   - Mismo contenido que backend
   - Cambiar fecha a 2026-04-19
   - NOTA AL INICIO:
   ```markdown
   > **Fuente única de verdad para requisitos funcionales y no-funcionales de KeyGo.** 
   > Actualizar este documento cuando se agreguen/cierren requisitos.
   > Requisitos por bounded context: Authentication, Tenants, Billing, Account.
   ```

3. **Estructura mantener**:
   - RF-A1, RF-A2, ... (Requisitos de Authentication - completos ✅)
   - RF-B1, RF-B2, ... (Requisitos de Billing - incomplete)
   - RF-T1, RF-T2, ... (Requisitos de Tenants - incomplete)
   - RF-C1, RF-C2, ... (Requisitos de Account - incomplete)
   - RF-P1, RF-P2, ... (Requisitos de Platform - si existen)

4. **Completar contextos faltantes** (no en esta sesión, pero dejar nota):
   ```markdown
   ### **B. BILLING (Facturación & Pagos)**
   [Requisitos de Billing - PENDIENTE COMPLETAR EN PRÓXIMA SESIÓN]
   
   ### **T. TENANTS (Gestión de Organizaciones)**
   [Requisitos de Tenants - PENDIENTE COMPLETAR EN PRÓXIMA SESIÓN]
   
   ### **C. ACCOUNT (Autoservicio de Cuenta)**
   [Requisitos de Account - PENDIENTE COMPLETAR EN PRÓXIMA SESIÓN]
   ```

5. **Output**: `01-product/requirements.md`

**Validar**:
- [ ] Todos los requisitos Auth tienen RF-Axx
- [ ] Cada requisito tiene: Descripción, Endpoint (si aplica), Validaciones, Status, Propuestas asociadas
- [ ] Status claro (✅ = Completado, ⏳ = En progreso)

---

### ✅ ACCIÓN 3: Crear Vision.md (20 min)

**Fuente**:
- Frontend: `01-FRONTEND/01-product/01-vision-and-scope.md` (17 líneas - EXTRACT VISION PART)
- Backend: Implícito en requirements

**Que hacer**:

1. **Extraer** la parte "vision" (no "scope") de vision-and-scope.md:
   ```markdown
   # Product Vision — KeyGo
   
   **Tagline**: Gestión de identidad y acceso multi-tenant con una única fuente de verdad.
   
   ## What
   KeyGo es una plataforma de autenticación, autorización y gestión de acceso para organizaciones multi-tenant.
   
   ## For whom
   - Desarrolladores que necesitan OAuth2/OIDC en aplicaciones multi-tenant
   - Administradores que gestionan identidad de usuarios en organizaciones
   - Usuarios finales que necesitan login seguro y autoservicio de cuenta
   
   ## Key Principles
   1. **Un punto de login único** - OAuth2/PKCE como estándar
   2. **Experiencia diferenciada por rol** - Dashboard varía según ADMIN, ADMIN_TENANT, USER_TENANT
   3. **Seguridad en memoria** - Tokens en memoria; UI no persiste secretos en storage
   4. **Fuente de verdad única** - Documentación, código, diagrama consistentes
   
   ## Core Features
   - Acceso público: Landing, login, registro, recuperación de acceso, contratación
   - Operación de plataforma: Dashboard global, tenants, usuarios de plataforma, estado
   - Gestión tenant: Aplicaciones, usuarios, memberships, sesiones, billing
   - Autoservicio: Perfil, configuración, sesiones, preferencias
   ```

2. **Agnóstico**: No mencionar "backend/frontend"; hablar de "plataforma" + "usuarios"

3. **Output**: `01-product/vision.md` NUEVO

**Validar**:
- [ ] Claro qué es KeyGo (What)
- [ ] Para quién (For whom)
- [ ] Principios clave (Key Principles)
- [ ] Features principales (Core Features)
- [ ] NO detalles técnicos profundos (eso es para architecture)

---

### ✅ ACCIÓN 4: Crear Constraints-Limitations.md (15 min)

**Fuente**:
- Backend: `00-BACKEND/01-product/pain-points.md` (80+ líneas - MOVER + RENAME)

**Que hacer**:

1. **Mover** contenido de pain-points.md (líneas 1-80+ completas)

2. **Renombrar** a constraints-limitations.md (más claro para futura búsqueda)

3. **Agregar encabezado nuevo**:
   ```markdown
   # Constraints & Limitations — KeyGo
   
   > **Propósito**: Documentar restricciones técnicas, pain points identificados y limitations conocidas.
   > Referencia para decisiones de diseño y priorización de trabajo.
   > Última actualización: 2026-04-19
   
   ---
   ```

4. **Secciones**:
   - Dolores de desarrollo (Conocimiento disperso, Desalineación, Inconsistencias, Falta diagramas)
   - Restricciones técnicas (Tengo que leer más del archivo)
   - Limitaciones no-funcionales (Performance, Escalabilidad)

5. **Output**: `01-product/constraints-limitations.md`

**Validar**:
- [ ] Pain points principales documentados
- [ ] Causas raíz explicadas
- [ ] Impacto cuantificado (ej: "onboarding ~10-15 horas")
- [ ] Soluciones/mitigaciones identificadas

---

### ✅ ACCIÓN 5: Crear README.md para 01-product/ (10 min)

**Que hacer**:

```markdown
# 01-PRODUCT - Visión, Requisitos y Definiciones

**Propósito**: Documentar QUÉ estamos construyendo (no CÓMO). Agnóstico de tecnología.

## Contenido

### [vision.md](vision.md)
Visión general de KeyGo: propósito, para quién, principios clave, features principales.
**Leer si**: Necesitas entender qué es KeyGo en 5 minutos.

### [glossary.md](glossary.md) ⭐ SINGLE SOURCE OF TRUTH
Diccionario unificado de ~100 términos: Auth, Tenants, Billing, Account, Arquitectura, Roles.
**Leer si**: Necesitas aclaración sobre cualquier término usado en KeyGo.

### [requirements.md](requirements.md)
Requisitos funcionales y no-funcionales organizados por bounded context:
- Authentication (RF-A: Auth Code, Token Exchange, Refresh, Revocation, etc.)
- Tenants (RF-T: próximamente)
- Billing (RF-B: próximamente)
- Account (RF-C: próximamente)
**Leer si**: Necesitas saber qué debe hacer KeyGo (especificaciones).

### [constraints-limitations.md](constraints-limitations.md)
Pain points identificados, restricciones técnicas, limitations conocidas.
- Dolor 1: Conocimiento disperso
- Dolor 2: Desalineación roadmap-código
- Dolor 3: Inconsistencias docs ↔ código
- Dolor 4: Falta diagramas visuales
**Leer si**: Necesitas entender restricciones que afectan decisiones de diseño.

### [diagrams/](diagrams/)
Diagramas visuales agnósticas:
- use-cases.md - Casos de uso
- authentication-flow.md - Flujo OAuth2/OIDC
- billing-flow-contractor.md - Modelo de billing
- account-flow.md - Ciclo vida de cuenta
- tenant-management-flow.md - Ciclo vida de tenant
**Leer si**: Prefieres visuales que texto.

## Navega a

- [← Raíz](../../) - Índice principal
- [→ Functional](../02-functional/) - Cómo implementar features
- [→ Architecture](../03-architecture/) - Diseño técnico

---

**Última actualización**: 2026-04-19
```

**Output**: `01-product/README.md`

---

### ✅ ACCIÓN 6: Eliminar Raw Files (después de validar)

**Estrategia**: Los documentos raw serán ELIMINADOS (no deprecados), reemplazados completamente por los nuevos.

**Archivos a ELIMINAR**:
- `00-BACKEND/01-product/` → Será eliminado completamente después de SP-3 (todo migrado a 01-product/)
- `01-FRONTEND/01-product/` → Será eliminado completamente después de SP-3 (todo migrado)

**Timing**: NO eliminar en esta sesión, hacerlo al final de SP-3 cuando todo esté migrado y validado.

**Importancia**: Los nuevos documentos NO deben tener referencias a los raw files.
- ❌ NO hacer links como "See 00-BACKEND/01-product/glossary.md"
- ✅ Documentos nuevos son autónomos y completos

---

## 📐 Estructura Final de 01-product/

**Después de SP-3.1 (esta sesión)**:

```
01-product/                          [Nueva sección UNIFICADA - fuente única de verdad]
├── README.md                        ← Entry point
├── vision.md                        ← NEW: Visión agnóstica
├── glossary.md                      ← NEW CONSOLIDATED: Fuente única (reemplaza raw)
├── requirements.md                  ← NEW CONSOLIDATED: Requisitos por BC (reemplaza raw)
├── constraints-limitations.md        ← NEW CONSOLIDATED: Pain points (reemplaza raw)
├── diagrams/                        ← KEEP: Use cases, flows, etc.
│   ├── README.md
│   ├── use-cases.md
│   ├── authentication-flow.md
│   ├── billing-flow-contractor.md
│   ├── account-flow.md
│   └── tenant-management-flow.md
└── [otros archivos]                 ← Evaluar en SP-3 qué mantener/consolidar
```

**Después de SP-3 COMPLETO**:
- ❌ `00-BACKEND/01-product/` - Será eliminado (todo ya en 01-product/)
- ❌ `01-FRONTEND/01-product/` - Será eliminado (todo ya en 01-product/)
- ✅ `01-product/` - ÚNICA fuente de verdad para documentación de producto

---

## 🧪 Validación Pre-Commit

Antes de hacer commit, verificar:

### Contenido
- [ ] **glossary.md**: 
  - Roles ADMIN, ADMIN_TENANT, USER_TENANT definidos
  - Alfabético de A-Z
  - Sin duplicados de definiciones
  
- [ ] **requirements.md**: 
  - RF-A1 a RF-A8+ todos completos (Authentication)
  - Otros contextos (B, T, C) presentes aunque incomplete
  - Cada RF tiene: Descripción, Endpoint, Validaciones, Status
  
- [ ] **vision.md**: 
  - What, For whom, Key Principles, Core Features
  - Agnóstico (no "backend", "frontend", "Java", "React" menciones)
  - 1-2 páginas máximo
  
- [ ] **constraints-limitations.md**: 
  - Pain points con causa raíz + impacto
  - Soluciones/mitigaciones mencionadas
  
- [ ] **README.md**: 
  - Link a cada doc con descripción
  - Navegación hacia otras secciones

### Crítico: SIN REFERENCIAS A RAW DOCS
- [ ] **Ningún documento nuevo** hace referencia a 00-BACKEND/01-product/ o 01-FRONTEND/01-product/
- [ ] Todos son **autónomos y completos** (no dependen de raw docs)
- [ ] Links solo a otros documentos en 01-product/ o secciones 02+
- [ ] Si hay información en raw docs que falta, **INCLUIR EN EL NUEVO DOCUMENTO**

---

## ⏱️ Timing

| Acción | Tiempo | Cumulative |
|--------|--------|-----------|
| 1. Consolidar Glossary | 30 min | 30 min |
| 2. Consolidar Requirements | 20 min | 50 min |
| 3. Crear Vision | 20 min | 70 min |
| 4. Crear Constraints | 15 min | 85 min |
| 5. Crear README | 10 min | 95 min |
| 6. Validar + Commit | 10 min | 105 min |
| **TOTAL** | | **~1.5h** ✅ |

---

## 📋 Próximo Paso

Ejecutar acciones en orden, validar cada una, commit final al terminar.
