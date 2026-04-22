# MACRO-PLAN: [PRODUCT NAME] — SDLC Framework

## Visión

[DESCRIBE YOUR PRODUCT AND ITS LONG-TERM VISION IN 3-4 SENTENCES]

---

## El Ciclo

```
Discovery → Requirements → Design & Process
    ↓
Feedback ←── Monitoring ←── Operating ←── Deployment ←── Development ←── Testing ←── Planning
    ↓
(repetir)
```

---

## Fases y Sub-Planes

### [SP-0] Framework SDLC ✅
**Objetivo**: Establecer el ciclo de vida del producto y sus fases.

**Entregable**: Framework documentado + convenciones de navegación

**Estado**: ✅ Completado (esta plantilla)

---

### [SP-D1] Discovery 🔲
**Objetivo**: Entender el problema, el contexto y los usuarios.

**Carpeta**: `01-discovery/`

**Entregables**:
- `context-motivation.md` — Por qué existe el producto
- `system-vision.md` — Visión a largo plazo
- `system-scope.md` — Qué entra, qué no
- `actors.md` — Usuarios y stakeholders
- `needs-expectations.md` — Necesidades específicas
- `final-analysis.md` — Análisis consolidado

**Estado**: 🔲 (No iniciado)

---

### [SP-D2] Requirements ✅
**Objetivo**: Especificar QUÉ debe hacer el sistema.

**Carpeta**: `02-requirements/`

**Entregables**:
- `glossary.md` — Vocabulario del dominio
- `functional/rf-*.md` — Requisitos funcionales
- `non-functional/rnf-*.md` — Requisitos no-funcionales
- `priority-matrix.md` — Priorización MoSCoW
- `scope-boundaries.md` — Límites explícitos

**Estado**: 🔲 (No iniciado)

---

### [SP-D3] Design & Process 🔲
**Objetivo**: Documentar flujos y modelo de dominio usando DDD.

**Carpeta**: `03-design/`

**Entregables**:
- `strategic-design.md` — Bounded Contexts, subdominios
- `system-flows.md` — Flujos principales con diagramas
- `bounded-contexts/` — Modelo de cada contexto
- `ui/design-system.md` — Principios visuales
- `ui/wireframes.md` — Pantallas principales

**Estado**: 🔲 (No iniciado)

---

### [SP-D4] Data Model 🔲
**Objetivo**: Documentar entidades, relaciones y flujos de datos.

**Carpeta**: `04-data-model/`

**Entregables**:
- `entities.md` — Entidades y atributos
- `relationships.md` — ERD y relaciones
- `data-flows.md` — Cómo fluye la información

**Estado**: 🔲 (No iniciado)

---

### [SP-D5] Planning 🔲
**Objetivo**: Documentar roadmap, epics y versioning.

**Carpeta**: `05-planning/`

**Entregables**:
- `roadmap.md` — Visión de entrega a 6-12 meses
- `epics.md` — Agrupación por iniciativa
- `versioning.md` — Estrategia de versiones

**Estado**: 🔲 (No iniciado)

---

### [SP-D6] Development 🔲
**Objetivo**: Documentar arquitectura, APIs y estándares técnicos.

**Carpeta**: `06-development/`

**Entregables**:
- `architecture.md` — Hexagonal + mapping a BC
- `api-reference.md` — Contratos de API
- `coding-standards.md` — Convenciones
- `adrs/` — Architecture Decision Records

**Estado**: 🔲 (No iniciado)

---

### [SP-D7] Testing 🔲
**Objetivo**: Documentar estrategia y planes de testing.

**Carpeta**: `07-testing/`

**Entregables**:
- `test-strategy.md` — Pirámide, cobertura, filosofía
- `test-plans.md` — Planes por feature/módulo

**Estado**: 🔲 (No iniciado)

---

### [SP-D8] Deployment 🔲
**Objetivo**: Documentar CI/CD, ambientes y release process.

**Carpeta**: `08-deployment/`

**Entregables**:
- `cicd.md` — Pipelines y gates
- `environments.md` — Dev, staging, producción
- `release-process.md` — Steps para release seguro

**Estado**: 🔲 (No iniciado)

---

### [SP-D9] Operations 🔲
**Objetivo**: Documentar operación en producción, runbooks e incidentes.

**Carpeta**: `09-operations/`

**Entregables**:
- `runbook.md` — Procedimientos operacionales
- `incident-response.md` — Protocolo de incidentes
- `slas.md` — Acuerdos de nivel de servicio

**Estado**: 🔲 (No iniciado)

---

### [SP-D10] Monitoring 🔲
**Objetivo**: Documentar métricas, alertas y observabilidad.

**Carpeta**: `10-monitoring/`

**Entregables**:
- `metrics.md` — Qué medimos
- `alerts.md` — Reglas de alerta
- `dashboards.md` — Visualización

**Estado**: 🔲 (No iniciado)

---

### [SP-D11] Feedback 🔲
**Objetivo**: Capturar aprendizajes y mejoras del proceso.

**Carpeta**: `11-feedback/`

**Entregables**:
- `retrospectives.md` — Aprendizajes por ciclo
- `user-feedback.md` — Feedback de usuarios
- `process-improvements.md` — Evolución del SDLC

**Estado**: 🔲 (No iniciado)

---

## Estructura de Carpetas

```
[YOUR-PRODUCT-DOCS]/
├── 00-documental-planning/          # Framework SDLC + convenciones
├── 00-GUIDE-AND-INSTRUCTIONS/  # Guías para usar plantilla
├── 01-discovery/         # Fase 1: Problem + Context
├── 02-requirements/      # Fase 2: Specs (RF/RNF)
├── 03-design/            # Fases 3-4: Design + UI
├── 04-data-model/        # Fase 5: Data structure
├── 05-planning/          # Fase 6: Roadmap
├── 06-development/       # Fase 7: Technical architecture
├── 07-testing/           # Fase 8: Testing strategy
├── 08-deployment/        # Fase 9: CI/CD + Release
├── 09-operations/        # Fase 10: Production operations
├── 10-monitoring/        # Fase 11: Metrics + Observability
├── 11-feedback/          # Fase 12: Learning + Retrospectives
└── MACRO-PLAN.md         # Este archivo
```

---

## Estado Actual

| Fase | Carpeta | Estado |
|------|---------|--------|
| Framework | `00-documental-planning/` | ✅ |
| Discovery | `01-discovery/` | 🔲 |
| Requirements | `02-requirements/` | 🔲 |
| Design & Process | `03-design/` | 🔲 |
| Data Model | `04-data-model/` | 🔲 |
| Planning | `05-planning/` | 🔲 |
| Development | `06-development/` | 🔲 |
| Testing | `07-testing/` | 🔲 |
| Deployment | `08-deployment/` | 🔲 |
| Operations | `09-operations/` | 🔲 |
| Monitoring | `10-monitoring/` | 🔲 |
| Feedback | `11-feedback/` | 🔲 |

---

## Próximos Pasos

1. 📖 Lee [`00-GUIDE-AND-INSTRUCTIONS/README.md`](./00-GUIDE-AND-INSTRUCTIONS/README.md)
2. 📋 Sigue [`00-GUIDE-AND-INSTRUCTIONS/TEMPLATE-USAGE-GUIDE.md`](./00-GUIDE-AND-INSTRUCTIONS/TEMPLATE-USAGE-GUIDE.md)
3. 🤖 Usa [`00-GUIDE-AND-INSTRUCTIONS/INSTRUCTIONS-FOR-AI.md`](./00-GUIDE-AND-INSTRUCTIONS/INSTRUCTIONS-FOR-AI.md) para generar cada fase

---

**Creado por**: [Your Name/Team]  
**Basado en**: SDLC framework (DDD + Hexagonal Architecture)  
**Última actualización**: [DATE]
