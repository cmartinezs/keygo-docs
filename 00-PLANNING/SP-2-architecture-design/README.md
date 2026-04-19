# SP-2: Diseño de Arquitectura Documental

**Estado**: ✅ COMPLETADO  
**Fecha**: 2026-04-19  
**Duración**: 1 sesión

## Entregables

### 1️⃣ **information-architecture.md**
Jerarquía final de directorios y contenido:
- Principios de diseño (por dominio, agnóstico primero, navegación por rol)
- Estructura detallada de todas las secciones (01-product hasta 99-archive)
- Convenciones de profundidad (máximo 3 niveles)
- Navegación clara en cada nivel

**→ Lee esto si**: Necesitas entender la estructura final del repo

### 2️⃣ **naming-conventions.md**
Estándares de nomenclatura completos:
- Archivos: lowercase con guiones, máximo 50 chars, números secuenciales
- Directorios: lowercase, conciso, descriptivo
- README.md en cada carpeta como entry point
- Docstrings/metadata en encabezado de archivos
- Jerarquía de headings (máximo H4)
- Convenciones de links (relativos)
- Templates por tipo de documento (ADR, RFC, Runbook)
- Versionamiento con git (no números en archivos)

**→ Lee esto si**: Necesitas crear o editar documentación

### 3️⃣ **navigation-map.md**
Cómo se conectan las secciones y rutas de navegación:
- Rutas por rol (PM, Backend Dev, Frontend Dev, DevOps, Tech Lead)
- Rutas por tarea ("How do I implement feature X?", "Help! Bug in production!")
- Navegación sección a sección (links cruzados)
- Estructura del INDEX.md (homepage)

**→ Lee esto si**: Necesitas encontrar contenido o diseñar navegación

### 4️⃣ **index-structure.md**
Diseño detallado del INDEX.md (homepage):
- Estructura completa del INDEX.md con rol-based navigation
- Quick Start por rol con links específicos
- By Topic section para búsqueda temática
- FAQ (Frequently Asked Questions)
- Role-specific entry points (DOCS_FOR_BACKEND_DEVS.md, etc.)
- Cada sección tiene su README.md con mini-índice

**→ Lee esto si**: Necesitas entender cómo organizar la navegación central

---

## Comparación: SP-1 vs SP-2

| Aspecto | SP-1 (Mapeo) | SP-2 (Arquitectura) |
|---------|-------------|-------------------|
| **Pregunta** | ¿Qué existe hoy? | ¿Cómo debería organizarse? |
| **Basado en** | Análisis de 519 archivos | Propuesta de SP-1 + refinamiento |
| **Nivel de detalle** | Alto level findings | Implementación ready |
| **Accionable** | Para decisiones | Para SP-3 (consolidación) |

---

## Decisiones Clave en SP-2

### 1. Organización por Dominio (Feature), No por Tech Stack
- ❌ Evitar: `00-BACKEND/02-functional/authentication-flow.md` y `01-FRONTEND/02-functional/04-auth-flow-platform-and-tenant.md`
- ✅ Usar: `02-functional/authentication/01-architecture.md` + `02-backend-impl.md` + `03-frontend-impl.md`

**Beneficio**: Un developer entiende toda la feature (agnóstico + su tech stack), no dividido.

### 2. Agnóstico Primero, Tech-Specific Después
- Cada feature en `02-functional/[feature]/01-architecture.md` describe QUÉ hace
- Luego `02-backend-impl.md` y `03-frontend-impl.md` describen CÓMO se implementa
- Cross-references: ambos lado se refieren entre sí

**Beneficio**: Fácil cambiar implementación si se necesita (ej: cambiar backend from Java a Go).

### 3. Índices Locales + Índice Central
- `INDEX.md` en raíz (navegación global por rol)
- `README.md` en cada sección (navegación local + mini-índice)
- Role-specific guides (DOCS_FOR_BACKEND_DEVS.md, etc.)

**Beneficio**: Usuarios pueden empezar en su rol y progressivamente deep-dive.

### 4. Máximo 3 Niveles de Profundidad
```
Good:
01-product/
├── diagrams/
│   ├── use-cases.md
     (3 levels: root → diagrams → file)

Bad:
01-product/
├── diagrams/
│   ├── technical/
│   │   ├── flows/
│   │   │   ├── oauth2.md
         (5 levels - too deep)
```

**Beneficio**: No overwhelm, usuarios no se pierden en estructura.

---

## Impacto de SP-2 en SP-3

SP-2 entrega la hoja de ruta para SP-3 (Consolidación):

- **Structure Proposal** (SP-1) → REFINED (SP-2 information-architecture)
- **Naming Rules** (SP-2) → ENFORCED en todos los nuevos/moved archivos
- **Navigation Design** (SP-2) → IMPLEMENTED en SP-4 (índices)
- **Role-based paths** (SP-2) → USED en onboarding

---

## Próximo Paso

✅ **SP-2 completado**: Arquitectura definida, standards claros, navegación diseñada

👉 **SP-3: Consolidación de Secciones** (próximo)

### Decisión Necesaria

**¿Por dónde comenzamos SP-3?**

Opciones (en orden de complejidad/impacto):

1. **SP-3.1 Product** (menos complejo, alto impacto)
   - Unificar: 01-product/glossary.md (SINGLE SOURCE OF TRUTH)
   - Unificar: requirements.md
   - Resultado: Developers tienen terminología canónica
   - Tiempo: 1-2h

2. **SP-3.2 Functional** (complejo, muy alto impacto)
   - Consolidar: authentication flows (CRITICAL redundancy)
   - Consolidar: billing flows
   - Crear: Feature structure (01-architecture + 02-backend + 03-frontend)
   - Tiempo: 5-10h

3. **SP-3.3 Architecture** (complejo, crítico)
   - Consolidar multi-tenant docs
   - Consolidar authorization
   - Crear patterns catalog
   - Tiempo: 3-5h

4. **SP-3.4 Quality** (medio, importante)
   - Consolidar testing/security
   - Crear accessibility guide
   - Tiempo: 2-3h

5. **SP-3.5 Operations** (medio, importante)
   - Crear frontend deployment (missing)
   - Consolidar runbooks
   - Tiempo: 3-4h

**Recomendación**: SP-3.1 (Product) primero → SP-3.2 (Functional) luego → resto en paralelo

---

## Archivos de Este Sprint

- `information-architecture.md` (18.5KB)
- `naming-conventions.md` (22.3KB)
- `navigation-map.md` (19.8KB)
- `index-structure.md` (21.4KB)
- `README.md` (este archivo)

**Total**: ~82 KB de arquitectura y diseño

**Documentación acumulada**:
- SP-1: 48 KB (análisis)
- SP-2: 82 KB (arquitectura)
- **Total: 130 KB** de documentación de planificación
