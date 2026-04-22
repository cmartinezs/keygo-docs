# CLAUDE.md - Contexto para Claude Code

## Comportamiento Esperado

- **Sé preciso y directo**: respuestas cortas, sin preámbulos, sin resúmenes al final
- **Sin verborrea**: no expliques lo que acabas de hacer si el diff lo dice; no repitas el contexto que ya conoces
- **Calidad sin extensión**: conciso no significa superficial — responde exactamente lo necesario, ni más ni menos
- **Acción sobre narración**: ejecuta primero, comenta solo si hay algo no obvio

---

## Propósito del Repositorio

Documentación unificada de Keygo — única fuente de verdad para backend y frontend (submódulo de ambos repos).

---

## Estructura Actual

```
00-documental-planning/         # Framework SDLC, convenciones, metadocs
01-discovery/        # Contexto, visión, alcance, actores, necesidades
02-requirements/     # RF, RNF, scope boundaries, trazabilidad
03-design/           # Flujos de sistema, decisiones de proceso, UI
04-data-model/       # Entidades, ERD, flujos de datos
05-planning/         # Roadmap, epics, versioning
06-development/      # Arquitectura, APIs, coding standards, ADRs
07-testing/          # Estrategia, planes, seguridad
08-deployment/       # CI/CD, ambientes, release process
09-operations/       # Runbooks, incident response, SLA
10-monitoring/       # Métricas, alertas, dashboards
11-feedback/         # Retrospectivas, user feedback
bkp/                 # Material histórico (back/front raw docs, SPs anteriores)
```

---

## Archivos Clave

- `macro-plan.md` — Estado y próximos pasos de cada SP
- `AGENTS.md` — Instrucciones para agentes de IA
- `00-documental-planning/sdlc-framework.md` — Ciclo SDLC y mapping fase→carpeta
- `00-documental-planning/navigation-conventions.md` — Reglas de navegación obligatorias

---

## Reglas de Trabajo

- Lee `macro-plan.md` antes de actuar
- No edites contenido sin un plan previo
- Aplica siempre las convenciones de `navigation-conventions.md`
- Preserva histórico en `bkp/`, no borres

## Regla de Fase: Discovery y Requirements

En las fases `01-discovery/` y `02-requirements/`, el enfoque es el **qué**, nunca el **cómo**:

- **Prohibido**: nombres de tecnologías, frameworks, lenguajes, protocolos específicos (JWT, OAuth2, PKCE, RFC XXXX, Spring, PostgreSQL, RS256, `@PreAuthorize`, endpoints, queries, patrones de código)
- **Permitido**: capacidades del sistema, comportamientos esperados, restricciones de negocio, actores, necesidades
- El material de `bkp/` es **referencia de contexto**, no fuente de implementación — extrae el *qué*, ignora el *cómo*
- Asume que **nada está construido aún**: describe como si el sistema fuera a diseñarse desde cero
