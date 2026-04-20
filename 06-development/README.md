[← HOME](../README.md)

---

# Development

Fase de documentación de arquitectura técnica, patrones, APIs y estándares de desarrollo, con énfasis en **Domain-Driven Design** y mapeo explícito de Bounded Contexts a implementación.

## Contenido

- [Resumen](#resumen)
- [Arquitectura](./architecture.md) — Arquitectura hexagonal, bounded contexts → módulos, patrones DDD
- **[OAuth2/OIDC Contract](./oauth2-oidc-contract.md)** — ⭐ Flujos de autenticación (PKCE, multi-level, refresh token rotation, replay detection)
- **[Authorization Patterns](./authorization-patterns.md)** — ⭐ RBAC multi-nivel, JWT claims, @PreAuthorize, validación de tenant scope
- **[API Versioning Strategy](./api-versioning-strategy.md)** — ⭐ URI path versioning, semantic versioning, deprecation lifecycle
- **[Database Schema](./database-schema.md)** — ⭐ ERD, Flyway migrations (V1-V33+), invariantes, multi-tenancy at DB level
- **[Observability](./observability.md)** — ⭐ Logs (MDC), Metrics (Prometheus), Traces (Jaeger), Dashboards, Alertas
- **[Frontend Architecture](./frontend-architecture.md)** — ⭐ Stack (Vite/React/TS/Query/Zustand), diseño, seguridad
- **[Frontend Project Structure](./frontend-project-structure.md)** — ⭐ Feature-first org, capas, ejemplos, anti-patterns
- **[Frontend: Auth Implementation](./frontend-auth-implementation.md)** — ⭐ Tokens en memoria, PKCE, session recovery, roles
- **[Frontend: API Integration](./frontend-api-integration.md)** — ⭐ Axios, TanStack Query, error normalization, retry strategy
- **[API Endpoints (Comprehensive)](./api-endpoints-comprehensive.md)** — ⭐ 9 grupos de endpoints (Discovery, Auth, Account, Users, Apps, Billing, Admin, Errors, Examples)
- [API Reference](./api-reference.md) — Contratos de API
- [Coding Standards](./coding-standards.md) — Convenciones de código y ubiquitous language
- [Developer Glossary](./glossary-technical.md) — Términos técnicos del stack (Java 21, Spring Boot, Jackson 3, Flyway, etc.)
- [Workflow](./workflow.md) — Ramas, commits, PRs, pre-commit hooks
- [ADRs](./adrs/) — Architecture Decision Records
- [AI Guidelines](./ai/ai-context.md) — Uso de agentes AI
- [Knowledge](./knowledge/) — Tasks, Lessons, Inconsistencies

---

## Resumen

| Artefacto | Descripción |
|-----------|-------------|
| [architecture.md](./architecture.md) | Arquitectura hexagonal, mapeo bounded contexts → módulos, patrones (Repository, Factory, ACL), flujo de requests |
| [api-reference.md](./api-reference.md) | Contratos de API REST |
| [coding-standards.md](./coding-standards.md) | Convenciones de código Java, ubiquitous language, naming DDD |
| [glossary-technical.md](./glossary-technical.md) | Referencia de términos técnicos (Jackson 3, Nimbus, Flyway, JPA, TestContainers, etc.) |
| [workflow.md](./workflow.md) | Ramas, commits, PRs, pre-commit hooks, integraciones |
| [adrs/](./adrs/) | Architecture Decision Records |
| [ai/ai-context.md](./ai/ai-context.md) | Guías para agentes AI (OpenCode, Claude, Copilot) |
| [knowledge/](./knowledge/) | Tareas, lecciones aprendidas, inconsistencias |

---

## Cómo Navegar Esta Sección

1. **Primero**: Lee [architecture.md](./architecture.md) para entender cómo los Bounded Contexts (Identity, Access Control, Organization, etc.) se mapean a módulos Java
2. **Anti-Corruption Layer**: Consulta la sección "Anti-Corruption Layer" en [architecture.md](./architecture.md) para ver cómo se protegen los contextos en integraciones
3. **Patterns**: Revisa "Patrones Arquitectónicos" para ver Repository, Factory y Mapper patterns en código real
4. **Coding**: Usa [coding-standards.md](./coding-standards.md) como referencia para nombres, estructura de paquetes y cómo hacer que el código hable el lenguaje del dominio
5. **APIs**: Consulta [api-reference.md](./api-reference.md) para contratos HTTP

[↑ Volver al inicio](#development)

---

[← HOME](../README.md) | [Siguiente >](./architecture.md)