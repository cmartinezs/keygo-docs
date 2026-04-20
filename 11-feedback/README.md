[← Índice](../README.md) | [macro-plan](../macro-plan.md)

---

# Feedback: Retroalimentación y Mejora Continua (SP-D12)

La fase de **Feedback** cierra el ciclo SDLC: captura aprendizajes, canaliza feedback de usuarios de vuelta al dominio, y documenta mejoras del proceso. Con enfoque en **Domain-Driven Design**, cada contexto acumulado feedback específico que informa decisiones arquitectónicas futuras.

---

## Cómo Navegar

| Sección | Propósito |
|---------|-----------|
| **[Retrospectives](#retrospectives)** | Aprendizajes por ciclo, decisiones de diseño, lecciones DDD |
| **[User Feedback Loops](#user-feedback-loops)** | Cómo feedback de usuarios se mapea a contextos y acciones |
| **[Process Improvements](#process-improvements)** | Evolución del SDLC, retrospectivas del framework |
| **[Technical Feedback](#technical-feedback)** | NPS, bugs, feature requests, analytics |

---

## Retrospectives

📄 **[retrospectives.md](./retrospectives.md)**

Retrospectivas por ciclo de desarrollo. Cada retro documenta:
- **Contextos impactados**: qué bounded context fue clave en este ciclo
- **Decisiones DDD validadas**: qué patrones funcionaron bien
- **Problemas descobertos**: anti-patterns, acoplamiento, insuficiencias
- **Acciones**: qué cambia en el próximo ciclo
- **Métricas**: NPS promedio, tasa de bugs por contexto, deployment frequency

**Audiencia**: Product, Engineering, Architecture

---

## User Feedback Loops

📄 **[user-feedback-loops.md](./user-feedback-loops.md)**

Cómo el feedback de usuarios (NPS, bugs, feature requests) fluye de vuelta al dominio:

- **NPS por Contexto**: "¿Qué contexto genera más detractores?" → mejora específica
- **Bug Patterns**: bugs recurrentes en Identity o Access Control → raíz en dominio
- **Feature Requests**: "Quiero autenticación SSO" → nueva capacidad en Identity Context
- **Multi-tenant Insights**: feedback diferente entre Enterprise, Standard, Community → features gated
- **Feedback → Requirements**: cómo lo que escuchamos se convierte en RF

**Audiencia**: Product, UX, Engineering

---

## Process Improvements

📄 **[process-improvements.md](./process-improvements.md)**

Mejoras al SDLC framework mismo:

- **Sprint Retrospectives**: qué salió bien en Discovery/Requirements/Development
- **DDD Maturity**: cómo evolucionó el dominio, dónde aparecen contextos nuevos
- **Governance**: cambios a convenciones, navigation conventions, estándares
- **Tooling**: mejoras a CI/CD, monitoring, incident response basadas en aprendizajes
- **Roadmap Adjustments**: prioridades futuras según feedback

**Audiencia**: Technical Leads, Product Managers, Architects

---

## Technical Feedback

Recolección y gestión técnica de feedback (componentes originales, reforzados con DDD):

- **[feedback-types.md](./feedback-types.md)** — NPS, surveys, bug reports, feature requests
- **[feedback-collection.md](./feedback-collection.md)** — Widgets in-app, email campaigns, APIs
- **[feedback-api.md](./feedback-api.md)** — Endpoints CRUD, webhooks
- **[feedback-analytics.md](./feedback-analytics.md)** — Dashboards por contexto, alertas

---

## Artifact Map

```
11-feedback/
├── README.md (este archivo)
├── retrospectives.md          ← Aprendizajes por ciclo
├── user-feedback-loops.md     ← Feedback → Acciones
├── process-improvements.md    ← Mejoras SDLC
├── feedback-types.md          ← Tipos de feedback técnico
├── feedback-collection.md     ← Métodos de recolección
├── feedback-api.md            ← APIs REST
└── feedback-analytics.md      ← Dashboards y métricas
```

---

## Key Insights

**Feedback with DDD Lens**:
- Cada Bounded Context (Identity, Access Control, Billing, etc.) tiene su própria fuente de feedback
- Patterns en feedback alertan sobre problemas de diseño: "Demasiadas denials en Access Control" → aggregate es muy estricto
- Multi-tenant feedback revela cómo diferentes planes de tenant priorizan capacidades diferentes

**Closing the Loop**:
- Feedback → Retrospective → Improvement → Next Cycle
- Sin cierre del loop, feedback se pierde; con cierre, cada ciclo refina el dominio

---

↑ [Volver al inicio](#feedback-retroalimentación-y-mejora-continua-sp-d12)

---

[← Volver a macro-plan](../macro-plan.md)