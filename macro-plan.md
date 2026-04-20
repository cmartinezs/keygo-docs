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

### [SP-D3] Design & Process ✅
**Objetivo**: Documentar flujos del sistema, procesos de negocio y decisiones de diseño usando DDD estratégico.

**Carpeta**: `03-design/`

**Entregables**:
- `03-design/README.md` — Índice y resumen de diseño
- `03-design/strategic-design.md` — Clasificación de subdominios, Domain Vision Statement y contextos candidatos
- `03-design/ubiquitous-language.md` — Lenguaje ubicuo por bounded context
- `03-design/context-map.md` — Mapa de bounded contexts y sus relaciones (patrones DDD)
- `03-design/domain-events.md` — Catálogo de eventos de dominio por contexto y flujos cross-context
- `03-design/system-flows.md` — 12 flujos del sistema con diagramas de secuencia
- `03-design/process-decisions.md` — 14 decisiones de diseño con alternativas descartadas
- `03-design/bounded-contexts/README.md` — Índice del subfolder de bounded contexts
- `03-design/bounded-contexts/identity.md` — Modelo del contexto Identity (Core Domain)
- `03-design/bounded-contexts/access-control.md` — Modelo del contexto Access Control (Core Domain)
- `03-design/bounded-contexts/organization.md` — Modelo del contexto Organization (Supporting)
- `03-design/bounded-contexts/client-applications.md` — Modelo del contexto Client Applications (Supporting)
- `03-design/bounded-contexts/billing.md` — Modelo del contexto Billing (Supporting)
- `03-design/bounded-contexts/audit.md` — Modelo del contexto Audit (Supporting)
- `03-design/bounded-contexts/platform.md` — Modelo del contexto Platform (Supporting)

**Estado**: ✅ Completado

---

### [SP-D4] UI Design ✅
**Objetivo**: Documentar la interfaz de usuario, portales, pantallas y decisiones de experiencia.

**Carpeta**: `03-design/ui/`

**Entregables**:
- `03-design/ui/README.md` — Índice de UI design y descripción de los dos portales
- `03-design/ui/design-system.md` — Principios visuales, lenguaje de componentes y patrones de interacción
- `03-design/ui/wireframes.md` — Inventario de pantallas por portal y flujos de navegación
- `03-design/ui/ux-decisions.md` — 8 decisiones UX con alternativas descartadas y justificación

**Nota**: El material de `bkp/chatgpt/` es arquitectura técnica de frontend (React, patrones de componentes, state management) y pertenece a SP-D7 (Development).

**Estado**: ✅ Completado

---

### [SP-D5] Data Model ✅
**Objetivo**: Documentar entidades, relaciones, esquemas y flujos de datos.

**Carpeta**: `04-data-model/`

**Entregables**:
- `04-data-model/README.md` — Índice del modelo de datos
- `04-data-model/entities.md` — Entidades del dominio y sus atributos
- `04-data-model/relationships.md` — Relaciones entre entidades (ERD)
- `04-data-model/data-flows.md` — Cómo fluye la información a través del sistema

**Estado**: ✅ Completado

---

### [SP-D6] Planning 🔲
**Objetivo**: Documentar el roadmap, epics y estrategia de entrega.

**Carpeta**: `05-planning/`

**Entregables**:
- `05-planning/README.md` — Índice de planificación
- `05-planning/roadmap.md` — Visión de producto a corto y mediano plazo
- `05-planning/epics.md` — Agrupación de trabajo por iniciativa
- `05-planning/versioning.md` — Estrategia de versiones y compatibilidad

**Estado**: ✅ Completado

---

### [SP-D7] Development ✅
**Objetivo**: Documentar arquitectura técnica, patrones, APIs y estándares de desarrollo, con énfasis en mapeo explícito de Bounded Contexts a implementación usando DDD táctico.

**Carpeta**: `06-development/`

**Entregables**:
- `06-development/README.md` — Índice de desarrollo con navegación
- `06-development/architecture.md` — Arquitectura hexagonal, bounded contexts → módulos, patrones (Repository, Factory, ACL), flujo de requests
- `06-development/api-reference.md` — Contratos de API REST
- `06-development/coding-standards.md` — Convenciones de código con énfasis en ubiquitous language
- `06-development/workflow.md` — Ramas, commits, PRs, pre-commit hooks
- `06-development/adrs/` — Architecture Decision Records
- `06-development/ai/ai-context.md` — Guías para agentes AI
- `06-development/knowledge/` — Tareas, lecciones aprendidas

**Referencia**: Material previo disponible en `bkp/00-BACKEND/` y `bkp/01-FRONTEND/`

**Cambios Realizados**:
- ✅ Mapeo explícito: cada Bounded Context (Identity, Access Control, Organization, etc.) → estructura de paquetes Java
- ✅ Patrones DDD tácticos: Repository, Factory, Anti-Corruption Layer con ejemplos reales
- ✅ Ubiquitous Language reforzado en `coding-standards.md` con anti-patrones
- ✅ Anti-Corruption Layer documentado: cuándo, cómo y ejemplos (Payment Provider, Identity Provider)

**Estado**: ✅ Completado

---

### [SP-D8] Testing ✅
**Objetivo**: Documentar estrategias, planes y criterios de calidad, con énfasis en testing de agregados, value objects y eventos de dominio por Bounded Context.

**Carpeta**: `07-testing/`

**Entregables**:
- `07-testing/README.md` — Índice de testing con navegación
- `07-testing/test-strategy.md` — Pirámide de testing, cobertura, filosofía, testing de eventos
- `07-testing/test-plans.md` — Planes específicos por Bounded Context (Identity, Access Control, Organization, Billing, Audit, Platform)
- `07-testing/unit-tests.md` — Unit tests agnósticos al framework
- `07-testing/unit-test-coverage.md` — Metas de cobertura y configuración JaCoCo
- `07-testing/integration-tests.md` — Tests con BD real y MockMvc
- `07-testing/regression-tests.md` — Prevención de regresiones
- `07-testing/smoke-tests.md` — Verificación post-deploy
- `07-testing/uat.md` — User Acceptance Testing
- `07-testing/security-testing.md` — OWASP, compliance, PII

**Cambios Realizados**:
- ✅ Nuevo `test-plans.md`: planes por contexto (Identity, Access Control, Organization, Client Apps, Billing, Audit, Platform)
- ✅ Testing de agregados y value objects: metas específicas por capa de dominio
- ✅ Testing de domain events: ejemplos de cómo testear emisión y handlers
- ✅ Distribución de cobertura orientada a DDD: Value Objects 95%+, Agregados 90%+, Use Cases 80%+
- ✅ Escenarios Gherkin por contexto con Given/When/Then

**Estado**: ✅ Completado

---

### [SP-D9] Deployment ✅
**Objetivo**: Documentar pipelines CI/CD, ambientes y estrategias de release, con énfasis en automatización, seguridad y aislamiento multi-tenant.

**Carpeta**: `08-deployment/`

**Entregables**:
- `08-deployment/README.md` — Índice de deployment con estrategias (Blue-Green, Canary, Feature Flags)
- `08-deployment/environments.md` — Dev, Staging, Production; multi-tenancy en deployment; migraciones sin downtime
- `08-deployment/cicd.md` — GitHub Actions, SAST, Snyk, Cosign
- `08-deployment/release-process.md` — Versionado semántico, checklist, rollback, disaster recovery

**Cambios Realizados**:
- ✅ README mejorado con descripción de estrategias de deployment (Blue-Green, Canary)
- ✅ Sección completa sobre **Multi-Tenancy en Deployment**: aislamiento por ambiente, migraciones forward-compatible, feature flags por tenant
- ✅ Feature Flags documentados con ejemplos Java: rollout gradual por tenant, rollback instant
- ✅ Validación de aislamiento tenant antes de deploy
- ✅ Secrets Management: AWS Secrets Manager / HashiCorp Vault

**Estado**: ✅ Completado

---

### [SP-D10] Operations ✅
**Objetivo**: Documentar operación en producción, runbooks e incidentes, con énfasis en multi-tenant incident isolation.

**Carpeta**: `09-operations/`

**Entregables**:
- `09-operations/README.md` — Índice de operaciones con sección multi-tenancy
- `09-operations/runbook.md` — Procedimientos operacionales: deployment en K8s, monitoreo, escalamiento
- `09-operations/incident-response.md` — Niveles de severidad, multi-tenant isolation, post-incident
- `09-operations/slas.md` — SLAs diferenciados por tenant y plan
- `09-operations/support.md` — Sistema de tickets de soporte

**Cambios Realizados**:
- ✅ README mejorado con sección "Multi-Tenancy en Operaciones"
- ✅ Incident Response: diagnóstico de scope (¿qué tenants afectados?)
- ✅ Single-Tenant vs Multi-Tenant incident response diferenciado
- ✅ Aislamiento: rollback por tenant vs sistema completo
- ✅ Comunicación por tenant con SLAs diferenciados
- ✅ Post-incident: template detallada con timeline, RCA, action items

**Estado**: ✅ Completado

---

### [SP-D11] Monitoring ✅
**Objetivo**: Documentar métricas, alertas y dashboards de observabilidad, con énfasis en monitoreo por Bounded Context y multi-tenant alerting.

**Carpeta**: `10-monitoring/`

**Entregables**:
- `10-monitoring/README.md` — Índice con métricas por Bounded Context y multi-tenant alerting
- `10-monitoring/metrics.md` — Catálogo: HTTP, JVM, Database, Application, Business, Context-Specific metrics
- `10-monitoring/alerts.md` — Reglas de alerta por severidad
- `10-monitoring/dashboards.md` — Paneles de Grafana

**Cambios Realizados**:
- ✅ README: métricas por Bounded Context (Identity, Access Control, Billing, Audit, Platform)
- ✅ README: Multi-tenant alerting con umbrales diferenciados por plan (Enterprise, Standard, Community)
- ✅ metrics.md: nuevas métricas custom por contexto
- ✅ Queries PromQL específicas para cada contexto

**Estado**: ✅ Completado

---

### [SP-D12] Feedback ✅
**Objetivo**: Capturar aprendizajes, retros y mejoras del ciclo.

**Carpeta**: `11-feedback/`

**Entregables**:
- `11-feedback/README.md` — Índice de feedback (mejorado con DDD lens, multi-tenant emphasis)
- `11-feedback/retrospectives.md` — Retros por ciclo, DDD maturity assessment, lecciones por contexto
- `11-feedback/user-feedback-loops.md` — Cómo feedback de usuarios mapea a contextos y acciones
- `11-feedback/process-improvements.md` — Evolución del SDLC, governance, tooling, collaboration

**Componentes Existentes (reforzados con DDD)**:
- `11-feedback/feedback-types.md` — NPS, surveys, bugs, features
- `11-feedback/feedback-collection.md` — Widgets, campaigns, APIs
- `11-feedback/feedback-api.md` — REST endpoints
- `11-feedback/feedback-analytics.md` — Dashboards, metrics

**Estado**: ✅ Completado

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
| Design & Process | SP-D3 | `03-design/` | ✅ |
| UI Design | SP-D4 | `03-design/ui/` | ✅ |
| Data Model | SP-D5 | `04-data-model/` | ✅ |
| Planning | SP-D6 | `05-planning/` | ✅ |
| Development | SP-D7 | `06-development/` | ✅ |
| Testing | SP-D8 | `07-testing/` | ✅ |
| Deployment | SP-D9 | `08-deployment/` | ✅ |
| Operations | SP-D10 | `09-operations/` | ✅ |
| Monitoring | SP-D11 | `10-monitoring/` | ✅ |
| Feedback | SP-D12 | `11-feedback/` | ✅ |

## SDLC Status

**Fases Completadas**: SP-0, SP-D1, SP-D2, SP-D3, SP-D4, SP-D5, SP-D6, SP-D7, SP-D8, SP-D9, SP-D10, SP-D11, SP-D12 (13 de 13)

**Status**: 🎉 **SDLC FRAMEWORK COMPLETE**

**Siguiente paso**: Iteración continua — cada ciclo refina el dominio y el proceso.
