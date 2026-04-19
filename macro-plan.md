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

**Carpeta**: `01-product/`

**Entregables**:
- `01-product/problem-statement.md` — Por qué existe Keygo, qué problema resuelve
- `01-product/user-personas.md` — Perfiles de usuarios, roles, necesidades
- `01-product/competitive-analysis.md` — Alternativas, diferenciadores
- `01-product/glossary.md` — Vocabulario unificado del dominio

**Estado**: 🔲 Pendiente

---

### [SP-D2] Requirements ✅
**Objetivo**: Especificar QUÉ debe hacer el sistema, sin prescribir implementación.

**Carpeta**: `01-product/`

**Entregables**:
- `01-product/requirements.md` — RF + RNF + scope boundaries + traceability matrix ✅

**Estado**: ✅ Completado (primera versión)

---

### [SP-D3] Design & Process 🔲
**Objetivo**: Documentar flujos del sistema, procesos de negocio y decisiones de diseño.

**Carpeta**: `02-design/`

**Entregables**:
- `02-design/system-flows.md` — Diagramas de flujo de los procesos principales
- `02-design/process-decisions.md` — Decisiones de diseño de procesos y sus alternativas
- `02-design/domain-model.md` — Modelo conceptual del dominio (no técnico)

**Estado**: 🔲 Pendiente

---

### [SP-D4] UI Design 🔲
**Objetivo**: Documentar la interfaz de usuario, componentes y sistema de diseño.

**Carpeta**: `02-design/ui/`

**Entregables**:
- `02-design/ui/design-system.md` — Tokens, tipografía, colores, componentes base
- `02-design/ui/wireframes.md` — Pantallas principales y flujos de navegación
- `02-design/ui/ux-decisions.md` — Decisiones UX y sus fundamentos

**Estado**: 🔲 Pendiente

---

### [SP-D5] Data Model 🔲
**Objetivo**: Documentar entidades, relaciones, esquemas y flujos de datos.

**Carpeta**: `03-data-model/`

**Entregables**:
- `03-data-model/entities.md` — Entidades del dominio y sus atributos
- `03-data-model/relationships.md` — Relaciones entre entidades (ERD)
- `03-data-model/data-flows.md` — Cómo fluye la información a través del sistema

**Estado**: 🔲 Pendiente

---

### [SP-D6] Planning 🔲
**Objetivo**: Documentar el roadmap, epics y estrategia de entrega.

**Carpeta**: `04-planning/`

**Entregables**:
- `04-planning/roadmap.md` — Visión de producto a corto y mediano plazo
- `04-planning/epics.md` — Agrupación de trabajo por iniciativa
- `04-planning/versioning.md` — Estrategia de versiones y compatibilidad

**Estado**: 🔲 Pendiente

---

### [SP-D7] Development 🔲
**Objetivo**: Documentar arquitectura técnica, patrones, APIs y estándares de desarrollo.

**Carpeta**: `05-development/`

**Entregables**:
- `05-development/architecture.md` — Arquitectura del sistema (agnóstica), backend, frontend
- `05-development/api-reference.md` — Contratos de API
- `05-development/coding-standards.md` — Convenciones de código
- `05-development/adrs/` — Architecture Decision Records

**Estado**: 🔲 Pendiente (existe material en `bkp/`)

---

### [SP-D8] Testing 🔲
**Objetivo**: Documentar estrategias, planes y criterios de calidad.

**Carpeta**: `06-testing/`

**Entregables**:
- `06-testing/test-strategy.md` — Pirámide de testing, cobertura, criterios
- `06-testing/test-plans.md` — Planes por feature/módulo
- `06-testing/security-testing.md` — Pruebas de seguridad

**Estado**: 🔲 Pendiente (existe material en `bkp/`)

---

### [SP-D9] Deployment 🔲
**Objetivo**: Documentar pipelines CI/CD, ambientes y proceso de release.

**Carpeta**: `07-deployment/`

**Entregables**:
- `07-deployment/environments.md` — Dev, staging, producción y sus diferencias
- `07-deployment/cicd.md` — Pipelines, gates, automatización
- `07-deployment/release-process.md` — Cómo se hace un release

**Estado**: 🔲 Pendiente (existe material en `bkp/`)

---

### [SP-D10] Operations 🔲
**Objetivo**: Documentar operación en producción, runbooks e incidentes.

**Carpeta**: `08-operations/`

**Entregables**:
- `08-operations/runbooks/` — Procedimientos operacionales
- `08-operations/incident-response.md` — Protocolo de incidentes
- `08-operations/sla.md` — Acuerdos de nivel de servicio

**Estado**: 🔲 Pendiente (existe material en `bkp/`)

---

### [SP-D11] Monitoring 🔲
**Objetivo**: Documentar métricas, alertas, dashboards y observabilidad.

**Carpeta**: `09-monitoring/`

**Entregables**:
- `09-monitoring/metrics.md` — Métricas de sistema y negocio
- `09-monitoring/alerts.md` — Reglas de alerta, severidad, escalamiento
- `09-monitoring/dashboards.md` — Qué monitorear y cómo

**Estado**: 🔲 Pendiente

---

### [SP-D12] Feedback 🔲
**Objetivo**: Capturar aprendizajes, retros y mejoras del ciclo.

**Carpeta**: `10-feedback/`

**Entregables**:
- `10-feedback/retrospectives/` — Retros por ciclo o versión
- `10-feedback/user-feedback.md` — Feedback de usuarios
- `10-feedback/improvements.md` — Backlog de mejoras al proceso

**Estado**: 🔲 Pendiente

---

## Estructura de Carpetas

```
keygo-docs/
├── 00-PLANNING/          # Framework SDLC y metadocs de planificación
├── 01-product/           # Discovery + Requirements
├── 02-design/            # Design & Process + UI Design
├── 03-data-model/        # Data Model
├── 04-planning/          # Roadmap + Planning
├── 05-development/       # Architecture + Development
├── 06-testing/           # Testing
├── 07-deployment/        # Deployment + CI/CD
├── 08-operations/        # Operations + Runbooks
├── 09-monitoring/        # Monitoring + Observability
├── 10-feedback/          # Feedback + Retrospectives
├── bkp/                  # Material histórico (back/front raw docs, SPs anteriores)
├── macro-plan.md         # Este archivo
└── README.md             # Punto de entrada
```

---

## Estado Actual

| Fase | SP | Estado |
|------|----|--------|
| Framework | SP-0 | ✅ |
| Discovery | SP-D1 | 🔲 |
| Requirements | SP-D2 | ✅ |
| Design & Process | SP-D3 | 🔲 |
| UI Design | SP-D4 | 🔲 |
| Data Model | SP-D5 | 🔲 |
| Planning | SP-D6 | 🔲 |
| Development | SP-D7 | 🔲 |
| Testing | SP-D8 | 🔲 |
| Deployment | SP-D9 | 🔲 |
| Operations | SP-D10 | 🔲 |
| Monitoring | SP-D11 | 🔲 |
| Feedback | SP-D12 | 🔲 |

## Siguiente Paso

👉 **SP-D1: Discovery** — Crear problem statement, user personas, análisis competitivo y glosario
