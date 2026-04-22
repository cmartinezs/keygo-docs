# DDD + Hexagonal Architecture Template

Plantilla agnóstica y reutilizable para generar documentación completa de un producto usando Domain-Driven Design (DDD) estratégico + arquitectura hexagonal, con IA.

---

## ¿Qué es esto?

Una estructura de carpetas + documentación plantilla que define un ciclo de vida completo (SDLC) de 12 fases, cada una produciendo artefactos específicos. Diseñada para ser agnóstica de:

- **Problema o solución específica** — funciona para cualquier dominio (auth, billing, marketplace, ERP, etc.)
- **Tecnología** — no asume lenguajes, frameworks o herramientas
- **Escala** — para startups o productos empresariales
- **Contexto** — se adapta a metodologías ágiles, waterfall, o híbridas

---

## Propósito

Proporcionar una **fuente única de verdad** para tu producto que:

✅ **Captura "qué" antes de "cómo"** — distinción clara entre vision/requirements (agnóstico) vs. implementation (específico)

✅ **Es iterable** — cada feature/dominio puede estar en fases distintas simultáneamente

✅ **Facilita la colaboración con IA** — instrucciones claras y templates parametrizables para generar contenido

✅ **Es viva, no congelada** — documentación actualizada con código y decisiones en tiempo real

✅ **Garantiza trazabilidad** — requisitos → design → código → tests → métricas

---

## Estructura de Carpetas

```
ddd-hexagonal-ai-template/
├── 00-GUIDE-AND-INSTRUCTIONS/    # 👈 Comienza aquí
│   ├── README.md
│   ├── TEMPLATE-USAGE-GUIDE.md      (Cómo usar la plantilla)
│   ├── INSTRUCTIONS-FOR-AI.md       (Cómo pedir a IA que genere docs)
│   ├── TEMPLATE-ARCHITECTURE.md     (Cómo está diseñada la plantilla)
│   ├── FAQ.md
│   └── EXAMPLES/                    (Ejemplos reales de docs completadas)
│
├── 00-documental-planning/                  # Framework SDLC + convenciones
│   ├── sdlc-framework.md
│   ├── navigation-conventions.md
│   └── TEMPLATE-macro-plan.md       (Plantilla del plan anual)
│
├── 01-discovery/                 # Fase 1: ¿Qué problema resolvemos?
│   ├── README.md
│   ├── TEMPLATE-context-motivation.md
│   ├── TEMPLATE-system-vision.md
│   ├── TEMPLATE-system-scope.md
│   ├── TEMPLATE-actors.md
│   ├── TEMPLATE-needs-expectations.md
│   └── ...
│
├── 02-requirements/              # Fase 2: ¿Qué debe hacer el sistema?
│   ├── README.md
│   ├── TEMPLATE-glossary.md
│   ├── TEMPLATE-priority-matrix.md
│   ├── TEMPLATE-scope-boundaries.md
│   ├── TEMPLATE-rf-template.md      (Template para RF individual)
│   ├── TEMPLATE-rnf-template.md     (Template para RNF individual)
│   └── ...
│
├── 03-design/                    # Fase 3-4: Diseño + UI
│   ├── README.md
│   ├── TEMPLATE-strategic-design.md
│   ├── TEMPLATE-system-flows.md
│   ├── bounded-contexts/
│   │   └── TEMPLATE-context.md
│   ├── ui/
│   │   ├── TEMPLATE-design-system.md
│   │   └── TEMPLATE-wireframes.md
│   └── ...
│
├── 04-data-model/                # Fase 5: Modelo de datos
│   ├── README.md
│   ├── TEMPLATE-entities.md
│   ├── TEMPLATE-relationships.md
│   └── TEMPLATE-data-flows.md
│
├── 05-planning/                  # Fase 6: Roadmap + Planning
│   ├── README.md
│   ├── TEMPLATE-roadmap.md
│   ├── TEMPLATE-epics.md
│   └── TEMPLATE-versioning.md
│
├── 06-development/               # Fase 7: Desarrollo técnico
│   ├── README.md
│   ├── TEMPLATE-architecture.md
│   ├── TEMPLATE-api-reference.md
│   ├── TEMPLATE-coding-standards.md
│   ├── adrs/
│   │   └── TEMPLATE-adr.md
│   └── ...
│
├── 07-testing/                   # Fase 8: Testing
│   ├── README.md
│   ├── TEMPLATE-test-strategy.md
│   └── TEMPLATE-test-plans.md
│
├── 08-deployment/                # Fase 9: Deployment + CI/CD
│   ├── README.md
│   ├── TEMPLATE-cicd.md
│   ├── TEMPLATE-environments.md
│   └── TEMPLATE-release-process.md
│
├── 09-operations/                # Fase 10: Operaciones
│   ├── README.md
│   ├── TEMPLATE-runbook.md
│   ├── TEMPLATE-incident-response.md
│   └── TEMPLATE-slas.md
│
├── 10-monitoring/                # Fase 11: Monitoreo
│   ├── README.md
│   ├── TEMPLATE-metrics.md
│   ├── TEMPLATE-alerts.md
│   └── TEMPLATE-dashboards.md
│
└── 11-feedback/                  # Fase 12: Aprendizajes
    ├── README.md
    ├── TEMPLATE-retrospectives.md
    ├── TEMPLATE-user-feedback.md
    └── TEMPLATE-process-improvements.md
```

---

## Quick Start (30 minutos)

### 1. Lee la guía (5 min)

```bash
open 00-GUIDE-AND-INSTRUCTIONS/TEMPLATE-USAGE-GUIDE.md
```

### 2. Adaptá la plantilla a tu proyecto (10 min)

- Copia toda la carpeta `ddd-hexagonal-ai-template/` a tu repo
- Renombra `TEMPLATE-*.md` a nombres reales (ej: `TEMPLATE-context-motivation.md` → `context-motivation.md`)
- Actualiza `MACRO-PLAN.md` con la visión de tu producto

### 3. Usa IA para generar contenido (10-15 días)

Hay dos guías para trabajar con IA:

**A) Para empezar rápido** → Lee `00-GUIDE-AND-INSTRUCTIONS/AI-WORKFLOW-GUIDE.md`
- Flujo día a día (Día 1-10)
- Qué hacer cada día
- Ejemplos de prompts listos
- Validación en tiempo real

**B) Para ver un caso real** → Lee `00-GUIDE-AND-INSTRUCTIONS/EXAMPLE-IMPLEMENTATION.md`
- Caso completo: Documentación de Keygo
- Cada día: qué generar, cómo validar
- Prompts específicos adaptados
- Checklist de coherencia

**C) Para referencia de prompts** → Consulta `00-GUIDE-AND-INSTRUCTIONS/INSTRUCTIONS-FOR-AI.md`
- Prompts por fase (discovery, requirements, design, etc.)
- Troubleshooting avanzado
- Validation checklist detallado

---

## Filosofía

### ¿Por qué 12 fases?

El ciclo de vida completo de un producto tiene 12 momentos naturales:

1. **Discovery** → entender el problema
2. **Requirements** → especificar qué
3. **Design & Process** → diseñar cómo fluye
4. **UI Design** → diseñar cómo interactúa
5. **Data Model** → diseñar cómo se almacena
6. **Planning** → planificar la entrega
7. **Development** → construir
8. **Testing** → validar
9. **Deployment** → llevar a producción
10. **Operations** → operar
11. **Monitoring** → medir
12. **Feedback** → aprender

No es waterfall — es un mapa que permite iterar cada feature/dominio a su propio ritmo.

### ¿Por qué DDD + Hexagonal?

- **DDD** — centrado en el lenguaje del negocio (bounded contexts, ubiquitous language)
- **Hexagonal** — centrado en separar dominio de implementación técnica

Juntos garantizan que:
- ✅ La documentación es agnóstica de tecnología en las primeras fases
- ✅ El código refleja el dominio de negocio, no el framework
- ✅ Las decisiones están trazables y justificadas

---

## Próximos Pasos

1. 📖 Lee [`TEMPLATE-USAGE-GUIDE.md`](./00-GUIDE-AND-INSTRUCTIONS/TEMPLATE-USAGE-GUIDE.md) — guía completa de inicio a fin
2. 🤖 Consulta [`INSTRUCTIONS-FOR-AI.md`](./00-GUIDE-AND-INSTRUCTIONS/INSTRUCTIONS-FOR-AI.md) — cómo trabajar con IA
3. 🏗️ Lee [`TEMPLATE-ARCHITECTURE.md`](./00-GUIDE-AND-INSTRUCTIONS/TEMPLATE-ARCHITECTURE.md) — diseño interno de la plantilla
4. ❓ Revisa [`FAQ.md`](./00-GUIDE-AND-INSTRUCTIONS/FAQ.md) para dudas comunes

---

**Creado por**: [Tu nombre/equipo]  
**Basado en**: SDLC framework de Keygo (2026) + DDD + Arquitectura Hexagonal  
**Última actualización**: 2026-04-22
