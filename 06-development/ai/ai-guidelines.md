[← Índice](./README.md)

---

# AI Guidelines

Guías para el uso de agentes AI en el desarrollo de KeyGo.

> **Origen:** `bkp/00-BACKEND/09-ai/`

## Contenido

- [Agentes Soportados](#agentes-soportados)
- [Contexto del Proyecto](#contexto-del-proyecto)
- [Workflow](#workflow)
- [Operaciones](#operaciones)
- [Lessons Learned](#lessons-learned)

---

## Agentes Soportados

| Agente | Uso | Configuración |
|--------|-----|---------------|
| **OpenCode** | Desarrollo general | Configuración local |
| **Claude CLI** | Desarrollo, code review | Configuración local |
| **Copilot** | Autocompletado | VS Code extension |
| **Codex** | Scripts, automatización | API config |

### Configuración de Contexto

Al iniciar una sesión con un agente, proporcionar:

1. **Macro plan** → `macro-plan.md`
2. **Navegación** → `00-PLANNING/navigation-conventions.md`
3. **Principios** → Estructura de carpetas actual

---

## Contexto del Proyecto

### Stack

| Componente | Tecnología |
|-----------|------------|
| Backend | Java 21 + Spring Boot |
| Frontend | React + Vite + TypeScript |
| Base de datos | PostgreSQL |
| API | REST + OpenAPI |

### Arquitectura

- Hexagonal / Ports & Adapters
- DDD (Domain-Driven Design)
- Multi-tenant (aislamiento por tenant)

### Estructura de Documentación

```
keygo-docs/
├── 00-PLANNING/     # Navegación, conventions
├── 01-discovery/    # Contexto de producto
├── 02-requirements/ # RF/RNF, priorización
├── 03-design/      # Arquitectura, API, UI
├── 04-data-model/  # Entidades
├── 05-planning/    # Roadmap, epics
├── 06-development/ # Estándares, patrones
├── 07-testing/    # Test strategy
├── 08-deployment/  # CI/CD
├── 09-operations/ # Runbook, SLAs
├── 10-monitoring/  # Dashboards
└── 11-feedback/   # Feedback system
```

↑ Volver al inicio](#ai-guidelines)

---

## Workflow

### Iniciar Nueva Tarea

1. **Leer macro-plan.md** → identificar SP actual
2. **Revisar bkp/** → material de referencia
3. **Crear/editar archivos** según SP
4. **Actualizar estado** en macro-plan.md

### Antes de Escribir Código

1. **Buscar patrones existentes** en `bkp/` o carpeta actual
2. **Entender convenciones** de naming y estructura
3. **Verificar dependencias** con otros documentos

### Después de Completar Tarea

1. **Actualizar macro-plan.md** con estado completado
2. **Identificar siguiente paso**
3. **Informar al usuario**

---

## Operaciones

### Búsqueda

```bash
# Buscar en documentación
grep -r "pattern" bkp/

# Buscar en código
glob "**/*.java"
glob "**/*.ts"
```

### Archivos

- **Leer antes de editar** → usar Read tool
- **Crear carpetas si no existen** → usar Bash New-Item
- **No destruir** → mover a bkpen lugar de eliminar

### Convenciones

- **Navegación** → seguir `00-PLANNING/navigation-conventions.md`
- **Naming** → seguir patrones existentes en carpeta
- **Formatos** → mantener consistencia con archivos existentes

↑ Volver al inicio](#ai-guidelines)

---

## Lessons Learned

### Dominio

| Lección | Referencia |
|---------|-----------|
| Modelo de datos debe ser consistente | INC-H01, INC-H02 |
| Multi-tenant requiere diseño específico | INC-H03 |

### API

| Lección | Referencia |
|---------|-----------|
| Documentar cambios de контракт | INC-H04 |
| Versionar API claramente | lessons-learned/api.md |

### Herramientas

| Lección | Descripción |
|---------|-------------|
| Validar antes de asumir | Siempre verificar archivos existentes |
| Mantener contexto | Referenciar macro-plan en cada operación |
| No sobre-engineering | Seguir principios KISS, YAGNI |

↑ Volver al inicio](#ai-guidelines)

---

[← Índice](./README.md)
