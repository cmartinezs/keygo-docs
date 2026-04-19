# Naming Conventions - Estándares de Nomenclatura

**Estado**: SP-2 - Convenciones finales  
**Fecha**: 2026-04-19

---

## Archivo de Documentación

### Nombres de Archivos

**Formato**:
```
[número]-nombre-descriptivo.md
```

**Reglas**:
1. ✅ **Lowercase** con guiones (kebab-case)
   - ✅ `01-authentication-architecture.md`
   - ❌ `01-AuthenticationArchitecture.md`
   - ❌ `01-authentication_architecture.md`

2. ✅ **Números secuenciales** cuando hay orden
   - `01-introduction.md` → `02-architecture.md` → `03-implementation.md`
   - Facilita navegación y lectura en orden

3. ✅ **Descriptivo y específico**
   - ✅ `authentication-oauth2-flow.md`
   - ❌ `auth.md` (muy vago)
   - ❌ `implementation-details-for-oauth2-authentication-in-the-system.md` (muy largo)

4. ✅ **Máximo 50 caracteres** (legible en exploradores)
   - `01-authentication-architecture.md` (34 chars ✅)
   - `01-authentication-architecture-detailed-backend-implementation.md` (70 chars ❌)

5. ✅ **Sin artículos al inicio**
   - ✅ `error-handling.md`
   - ❌ `the-error-handling.md`

### Nombres de Directorios

**Formato**:
```
sección-nombre  (lowercase, guiones)
```

**Reglas**:
1. ✅ **Lowercase con guiones**
   - ✅ `data-and-persistence/`
   - ❌ `DataAndPersistence/`

2. ✅ **Conciso pero descriptivo**
   - ✅ `production-runbooks/`
   - ✅ `code-standards/`
   - ❌ `prod-rb/`

3. ✅ **Sin números** (a menos que sean secuenciales)
   - ✅ `SP-1-mapping-analysis/`
   - ❌ `section-1-product/`

---

## README.md (Índices)

**Ubicación**: Cada carpeta DEBE tener un `README.md`

**Estructura**:
```markdown
# [Nombre de la Sección]

**Propósito**: Una línea clara de qué contiene

**Contenidos**:
- file-1.md - Descripción corta
- file-2.md - Descripción corta

**Navega a**:
- [Sección anterior] - link
- [Sección siguiente] - link
```

**Ejemplo** (07-operations/README.md):
```markdown
# 07-OPERATIONS - Despliegue y Operaciones

**Propósito**: Guías para development setup, deployment, y production runbooks

**Subsecciones**:
- development-setup/ - Cómo configurar ambiente local
- deployment/ - CI/CD y procedimientos de despliegue
- production-runbooks/ - Cómo operar en producción

**Navega a**:
- [←](../06-quality/README.md) Quality & Testing
- [→](../08-reference/README.md) Reference
```

---

## Docstrings y Metadata

**Encabezado recomendado** para cada archivo:

```markdown
# [Título del Documento]

**Sección**: 03-architecture (opcional, para clarity)
**Tipo**: Architecture | Functional | Reference (opcional)
**Audiencia**: Developers, DevOps, Product (opcional)
**Última actualización**: 2026-04-19 (mantener actual)
**Status**: ✅ Current | ⚠️ WIP | 🚫 Deprecated (opcional)

---

[Contenido del documento]
```

**Ejemplo**:
```markdown
# Authentication Architecture

**Sección**: 02-functional/authentication  
**Tipo**: Functional - Architecture  
**Audiencia**: Backend Developers, Frontend Developers  
**Status**: ✅ Current (actualizado 2026-04-19)

---

[Contenido...]
```

---

## Títulos y Headings

### Jerarquía de Headings

```markdown
# H1 - Título del documento (usar UNA SOLA VEZ, al inicio)

## H2 - Secciones principales (2-4 por documento)

### H3 - Subsecciones (si necesario)

#### H4 - Detalles profundos (MÁXIMO)
```

**Regla**: No descender más de H4 (máximo 3 niveles de profundidad)

**Ejemplo**:
```markdown
# Authentication Architecture

## OAuth2 Flow

### Platform Authentication
#### Step 1: Initial Request
#### Step 2: Token Exchange

### Tenant Authentication
#### Step 1: Initial Request
#### Step 2: Token Exchange

## Session Management

### Cookie Strategy
...
```

---

## Links y Cross-References

### Enlaces Internos

**Formato**:
```markdown
[Link text](../path/to/file.md)
```

**Reglas**:
1. ✅ **Rutas relativas** (no absolutas)
   - ✅ `[see](../01-product/glossary.md)`
   - ❌ `[see](/keygo-docs/01-product/glossary.md)`

2. ✅ **Links con contexto**
   - ✅ `See [glossary](../01-product/glossary.md) for terminology`
   - ❌ `[click here](../01-product/glossary.md)`

3. ✅ **Backlinks desde el índice**
   - ✅ `[← Product](../01-product/README.md)`
   - ✅ `[→ Decisions](../04-decisions/README.md)`

### Cross-Sección References

**Patrón**:
```markdown
See also:
- [Authentication Architecture](../03-architecture/patterns/authentication-patterns.md)
- [Backend Implementation](./02-backend-implementation.md)
- [Frontend Implementation](./03-frontend-implementation.md)
```

---

## Convenciones de Contenido

### Listas y Bullets

**Usar bullets para items no-secuenciales**:
```markdown
✅ Do this
❌ Don't do that
⚠️ Be careful with this
```

**Usar números para pasos secuenciales**:
```markdown
1. First step
2. Second step
3. Third step
```

### Tablas

**Formato**:
```markdown
| Header 1 | Header 2 | Header 3 |
|----------|----------|----------|
| Cell     | Cell     | Cell     |
```

**Uso**: Para comparaciones, matrices, estados, opciones

### Code Blocks

**Incluir language hint**:
````markdown
```java
// Java code
public class Example {
}
```

```javascript
// JavaScript code
function example() {
}
```
````

---

## Documentación por Tipo

### Architecture Documents

**Estructura sugerida**:
```markdown
# [Architecture Name]

## Overview
[1-2 parágrafos explicando qué es]

## Design Principles
- Principio 1
- Principio 2

## Architecture Diagram
[Diagrama ASCII o link a imagen]

## Components
### Component 1
- Purpose
- Responsibilities

### Component 2
...

## Data Flow
[Explicar cómo fluyen datos]

## Considerations
- Performance
- Security
- Scalability

## Related Decisions
- [Link to ADR or RFC]
```

### Functional Guides

**Estructura sugerida**:
```markdown
# [Feature Name]

## Overview
[Qué es la feature, por qué existe]

## Architecture (agnóstico)
[Cómo funciona en general]

## Backend Implementation
[Detalles de backend]

## Frontend Implementation
[Detalles de frontend]

## Integration
[Cómo backend y frontend trabajan juntos]

## Troubleshooting
[Problemas comunes y soluciones]

## Related
- [Link to ADR if exists]
- [Link to RFC if exists]
```

### Runbooks

**Estructura sugerida**:
```markdown
# [Incident Type] Runbook

## Prerequisites
- Requisito 1
- Requisito 2

## Detection
[Cómo saber que hay un problema]

## Immediate Actions
1. Action 1
2. Action 2

## Investigation
1. Check metric X
2. Check logs Y

## Resolution
[Pasos específicos para resolver]

## Prevention
[Cómo evitar que vuelva a ocurrir]

## Escalation
[Cuándo escalar, a quién contactar]
```

---

## Versionamiento de Documentos

**No usar números de versión** en los archivos:
- ❌ `authentication-v1.md`, `authentication-v2.md`
- ✅ Un solo `authentication.md`, editar directamente

**Usar git para versionamiento**:
- Git history mantiene versiones
- `git log file.md` para ver cambios

**Marca status si necesario**:
```markdown
**Status**: ✅ Current | ⚠️ WIP | 🚫 Deprecated
```

---

## Templates por Tipo de Documento

### ADR (Architecture Decision Record)

```markdown
# ADR-XXX: [Decision Title]

## Status
Proposed | Accepted | Deprecated

## Context
[Cuál es la situación que motiva la decisión]

## Decision
[Cuál es la decisión]

## Rationale
[Por qué esta decisión]

## Consequences
**Positivas**:
- Consecuencia positiva 1
- Consecuencia positiva 2

**Negativas**:
- Consecuencia negativa 1
- Consecuencia negativa 2

## Alternatives Considered
- Alternativa 1 (rejected because...)
- Alternativa 2 (rejected because...)
```

### RFC (Request for Comments)

```markdown
# RFC: [Proposal Title]

## Summary
[1-2 parágrafos resumiendo la propuesta]

## Motivation
[Por qué necesitamos esto]

## Proposal
[Qué proponemos]

## Implementation
[Cómo lo implementaríamos]

## Risks
[Riesgos y mitigaciones]

## Alternatives
[Alternativas consideradas]

## Timeline
[Cuándo, fases, dependencias]
```

---

## Mantención y Updates

**Cuando editar documentos**:
1. Cambiar contenido
2. Actualizar fecha en header: `**Last updated**: 2026-04-19`
3. Cambiar status si es necesario
4. Commit con mensaje claro: `docs: update X - reason`

**Cuando remover documentos**:
- Mover a `99-archive/` primero, NO borrar
- Dejar nota en `99-archive/CLEANUP-LOG.md` explicando por qué

---

## Validación de Nombres

**Checklist antes de crear archivo**:

- [ ] Nombre en lowercase con guiones
- [ ] Máximo 50 caracteres
- [ ] Descriptivo (alguien sabe de qué trata sin abrirlo?)
- [ ] Sigue el patrón numérico si hay orden
- [ ] README existe en carpeta parent
- [ ] Archivo tiene H1 title que matchea nombre
- [ ] Header metadata completo
- [ ] Links relativos (no absolutos)
- [ ] No duplica contenido en otro archivo

---

## Próximo Paso

👉 Ver `navigation-map.md` para cómo se conectan las secciones  
👉 Ver `index-structure.md` para diseño de índices centrales
