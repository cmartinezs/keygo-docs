[← HOME](../README.md)

---

# Diseño y Proceso

Esta fase documenta **cómo está estructurado el dominio de Keygo** y **cómo fluyen sus procesos principales**, sin prescribir implementación. El enfoque es DDD (Domain-Driven Design) en su capa estratégica: identificar dónde está el valor real del sistema, trazar fronteras entre contextos, establecer el lenguaje compartido y modelar los eventos que conectan el dominio.

El diseño técnico (arquitectura, APIs, estructura de código) se aborda en `06-development/`.

---

## Contenido

| Documento | Descripción |
|-----------|-------------|
| [Diseño Estratégico](./strategic-design.md) | Clasificación de subdominios, Domain Vision Statement y contextos candidatos. |
| [Lenguaje Ubicuo](./ubiquitous-language.md) | Términos del dominio consensuados entre negocio y desarrollo. |
| [Mapa de Contextos](./context-map.md) | Bounded contexts y sus relaciones. |
| [Eventos de Dominio](./domain-events.md) | Eventos clave por contexto y cómo conectan el dominio. |
| [Flujos del Sistema](./system-flows.md) | Procesos principales descritos en lenguaje del dominio. |
| [Decisiones de Diseño](./process-decisions.md) | Decisiones tomadas, alternativas descartadas y su justificación. |
| [Contextos — Identity](./bounded-contexts/identity.md) | Modelo conceptual del contexto de Identidad. |
| [Contextos — Access Control](./bounded-contexts/access-control.md) | Modelo conceptual del contexto de Control de Acceso. |
| [Contextos — Organization](./bounded-contexts/organization.md) | Modelo conceptual del contexto de Organización. |
| [Contextos — Client Applications](./bounded-contexts/client-applications.md) | Modelo conceptual del contexto de Aplicaciones Cliente. |
| [Contextos — Billing](./bounded-contexts/billing.md) | Modelo conceptual del contexto de Facturación. |
| [Contextos — Audit](./bounded-contexts/audit.md) | Modelo conceptual del contexto de Auditoría. |
| [Contextos — Platform](./bounded-contexts/platform.md) | Modelo conceptual del contexto de Plataforma. |
| [Contracts](./contracts/README.md) | Contratos de integración Back ↔ Front. |
| [UI — Índice](./ui/README.md) | Índice del diseño de interfaz de usuario. |
| [UI — Sistema de Diseño](./ui/design-system.md) | Principios visuales, lenguaje de componentes y patrones de interacción. |
| [UI — Inventario de pantallas](./ui/wireframes.md) | Pantallas por portal, flujos de navegación y propósito de cada sección. |
| [UI — Decisiones UX](./ui/ux-decisions.md) | Decisiones de experiencia de usuario con alternativas y justificación. |
| [UI — Flujos Públicos](./ui-flows-public-experience.md) | Landing, login (OAuth2 PKCE), registro, recuperación de contraseña, flujo de suscripción. |
| [UI — Áreas por Rol](./ui-flows-rbac-areas.md) | Dashboards y funcionalidades por rol: admin platform, admin tenant, usuario final. |

---

[← HOME](../README.md) | [Siguiente >](./strategic-design.md)
