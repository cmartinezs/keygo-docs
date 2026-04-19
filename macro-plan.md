# MACRO-PLAN: Documentación KeyGo — SDLC Framework

## Visión

Construir una documentación completa, coherente y viva que cubra el ciclo de vida completo del producto Keygo. Cada fase del ciclo produce artefactos específicos que viven en este repositorio como única fuente de verdad.

## El Ciclo

```
Discovery → Requirements → Design & Process → UI Design → Data Model
    ↓                                                           ↓
Feedback ←── Monitoring ←── Operating ←── Deployment ←── Development ←── Testing ←── Planning
    ↓
(repetir)
```

El ciclo no es waterfall — se itera por feature, dominio o versión del producto.

---

## Fases y Sub-Planes

### [SP-0] Framework SDLC ✅
**Objetivo**: Definir el ciclo, sus fases, qué produce cada una, y cómo se mapea a carpetas.

**Entregable**: `00-PLANNING/sdlc-framework.md`

**Estado**: ✅ Completado

---

### [SP-D1] Discovery 🔲
**Objetivo**: Capturar el problema, el contexto de negocio, los usuarios y el mercado.

**Carpeta**: `01-discovery/`

**Entregables**:
- `01-discovery/README.md` — Índice y resumen del discovery (punto de entrada)
- `01-discovery/context-motivation.md` — Por qué existe Keygo, problema que resuelve, motivación estratégica
- `01-discovery/system-vision.md` — Visión del sistema: qué es, qué no es, hacia dónde va
- `01-discovery/system-scope.md` — Alcance: qué está dentro y fuera del sistema
- `01-discovery/actors.md` — Actores del sistema: usuarios, roles, stakeholders
- `01-discovery/needs-expectations.md` — Necesidades y expectativas por actor
- `01-discovery/next-steps.md` — Qué sigue después del discovery
- `01-discovery/final-reflection.md` — Reflexión final y cierre del discovery
- `01-discovery/final-analysis.md` — Análisis consolidado: insights, riesgos, oportunidades

**Estado**: ✅ Completado

---

### [SP-D2] Requirements ✅
**Objetivo**: Especificar QUÉ debe hacer el sistema, sin prescribir implementación.

**Carpeta**: `02-requirements/`

**Entregables**:
- `02-requirements/README.md` — Índice, resumen y guía de navegación
- `02-requirements/glossary.md` — Términos del dominio de identidad y acceso
- `02-requirements/priority-matrix.md` — Priorización MoSCoW de todos los RF/RNF
- `02-requirements/scope-boundaries.md` — Qué está dentro del MVP y qué queda fuera explícitamente
- `02-requirements/traceability.md` — Matriz RF/RNF ↔ Necesidades ↔ Objetivos estratégicos
- `02-requirements/functional/rf01-*.md … rf-N-*.md` — Un archivo por requisito funcional
- `02-requirements/non-functional/rnf01-*.md … rnf-N-*.md` — Un archivo por requisito no funcional

**Referencia**: Material previo disponible en `bkp/01-product/requirements.md` y `bkp/grade/03-requirements/`

**Estado**: ✅ Completado

---

### [SP-D3] Design & Process 🔲
**Objetivo**: Documentar flujos del sistema, procesos de negocio y decisiones de diseño.

**Carpeta**: `03-design/`

**Entregables**:
- `03-design/README.md` — Índice y resumen de diseño
- `03-design/system-flows.md` — Diagramas de flujo de los procesos principales
- `03-design/process-decisions.md` — Decisiones de diseño de procesos y sus alternativas
- `03-design/domain-model.md` — Modelo conceptual del dominio (no técnico)

**Estado**: 🔲 Pendiente

---

### [SP-D4] UI Design 🔲
**Objetivo**: Documentar la interfaz de usuario, componentes y sistema de diseño.

**Carpeta**: `03-design/ui/`

**Entregables**:
- `03-design/ui/README.md` — Índice de UI design
- `03-design/ui/design-system.md` — Tokens, tipografía, colores, componentes base
- `03-design/ui/wireframes.md` — Pantallas principales y flujos de navegación
- `03-design/ui/ux-decisions.md` — Decisiones UX y sus fundamentos

**Estado**: 🔲 Pendiente

---

### [SP-D5] Data Model 🔲
**Objetivo**: Documentar entidades, relaciones, esquemas y flujos de datos.

**Carpeta**: `04-data-model/`

**Entregables**:
- `04-data-model/README.md` — Índice del modelo de datos
- `04-data-model/entities.md` — Entidades del dominio y sus atributos
- `04-data-model/relationships.md` — Relaciones entre entidades (ERD)
- `04-data-model/data-flows.md` — Cómo fluye la información a través del sistema

**Estado**: 🔲 Pendiente

---

### [SP-D6] Planning 🔲
**Objetivo**: Documentar el roadmap, epics y estrategia de entrega.

**Carpeta**: `05-planning/`

**Entregables**:
- `05-planning/README.md` — Índice de planificación
- `05-planning/roadmap.md` — Visión de producto a corto y mediano plazo
- `05-planning/epics.md` — Agrupación de trabajo por iniciativa
- `05-planning/versioning.md` — Estrategia de versiones y compatibilidad

**Estado**: 🔲 Pendiente

---

### [SP-D7] Development 🔲
**Objetivo**: Documentar arquitectura técnica, patrones, APIs y estándares de desarrollo.

**Carpeta**: `06-development/`

**Entregables**:
- `06-development/README.md` — Índice de desarrollo
- `06-development/architecture.md` — Arquitectura del sistema (agnóstica), backend, frontend
- `06-development/api-reference.md` — Contratos de API
- `06-development/coding-standards.md` — Convenciones de código
- `06-development/adrs/` — Architecture Decision Records

**Referencia**: Material previo disponible en `bkp/00-BACKEND/` y `bkp/01-FRONTEND/`

**Estado**: 🔲 Pendiente

---

### [SP-D8] Testing 🔲
**Objetivo**: Documentar estrategias, planes y criterios de calidad.

**Carpeta**: `07-testing/`

**Entregables**:
- `07-testing/README.md` — Índice de testing
- `07-testing/test-strategy.md` — Pirámide de testing, cobertura, criterios
- `07-testing/test-plans.md` — Planes por feature/módulo
- `07-testing/security-testing.md` — Pruebas de seguridad

**Referencia**: Material previo disponible en `bkp/00-BACKEND/06-quality/`

**Estado**: 🔲 Pendiente

---

### [SP-D9] Deployment 🔲
**Objetivo**: Documentar pipelines CI/CD, ambientes y proceso de release.

**Carpeta**: `08-deployment/`

**Entregables**:
- `08-deployment/README.md` — Índice de deployment
- `08-deployment/environments.md` — Dev, staging, producción y sus diferencias
- `08-deployment/cicd.md` — Pipelines, gates, automatización
- `08-deployment/release-process.md` — Cómo se hace un release

**Referencia**: Material previo disponible en `bkp/00-BACKEND/07-operations/`

**Estado**: 🔲 Pendiente

---

### [SP-D10] Operations 🔲
**Objetivo**: Documentar operación en producción, runbooks e incidentes.

**Carpeta**: `09-operations/`

**Entregables**:
- `09-operations/README.md` — Índice de operaciones
- `09-operations/runbooks/` — Procedimientos operacionales
- `09-operations/incident-response.md` — Protocolo de incidentes
- `09-operations/sla.md` — Acuerdos de nivel de servicio

**Referencia**: Material previo disponible en `bkp/00-BACKEND/07-operations/`

**Estado**: 🔲 Pendiente

---

### [SP-D11] Monitoring 🔲
**Objetivo**: Documentar métricas, alertas, dashboards y observabilidad.

**Carpeta**: `10-monitoring/`

**Entregables**:
- `10-monitoring/README.md` — Índice de monitoreo
- `10-monitoring/metrics.md` — Métricas de sistema y negocio
- `10-monitoring/alerts.md` — Reglas de alerta, severidad, escalamiento
- `10-monitoring/dashboards.md` — Qué monitorear y cómo

**Estado**: 🔲 Pendiente

---

### [SP-D12] Feedback 🔲
**Objetivo**: Capturar aprendizajes, retros y mejoras del ciclo.

**Carpeta**: `11-feedback/`

**Entregables**:
- `11-feedback/README.md` — Índice de feedback
- `11-feedback/retrospectives/` — Retros por ciclo o versión
- `11-feedback/user-feedback.md` — Feedback de usuarios
- `11-feedback/improvements.md` — Backlog de mejoras al proceso

**Estado**: 🔲 Pendiente

---

## Estructura de Carpetas

```
keygo-docs/
├── 00-PLANNING/          # Framework SDLC y metadocs de planificación
├── 01-discovery/         # Discovery (contexto, visión, alcance, actores, necesidades)
├── 02-requirements/      # Requirements (RF, RNF, scope boundaries, trazabilidad)
├── 03-design/            # Design & Process + UI Design
├── 04-data-model/        # Data Model
├── 05-planning/          # Roadmap + Planning
├── 06-development/       # Architecture + Development
├── 07-testing/           # Testing
├── 08-deployment/        # Deployment + CI/CD
├── 09-operations/        # Operations + Runbooks
├── 10-monitoring/        # Monitoring + Observability
├── 11-feedback/          # Feedback + Retrospectives
├── bkp/                  # Material histórico (back/front raw docs, SPs anteriores)
├── macro-plan.md         # Este archivo
└── README.md             # Punto de entrada
```

---

## Estado Actual

| Fase | SP | Carpeta | Estado |
|------|----|---------|--------|
| Framework | SP-0 | `00-PLANNING/` | ✅ |
| Discovery | SP-D1 | `01-discovery/` | ✅ |
| Requirements | SP-D2 | `02-requirements/` | ✅ |
| Design & Process | SP-D3 | `03-design/` | 🔲 |
| UI Design | SP-D4 | `03-design/ui/` | 🔲 |
| Data Model | SP-D5 | `04-data-model/` | 🔲 |
| Planning | SP-D6 | `05-planning/` | 🔲 |
| Development | SP-D7 | `06-development/` | 🔲 |
| Testing | SP-D8 | `07-testing/` | 🔲 |
| Deployment | SP-D9 | `08-deployment/` | 🔲 |
| Operations | SP-D10 | `09-operations/` | 🔲 |
| Monitoring | SP-D11 | `10-monitoring/` | 🔲 |
| Feedback | SP-D12 | `11-feedback/` | 🔲 |

## Siguiente Paso

👉 **SP-D3: Design & Process** — Crear `03-design/` con flujos del sistema, decisiones de proceso y modelo conceptual del dominio.
