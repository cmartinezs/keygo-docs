# AGENTS.md - Instrucciones para Agentes de IA

## Contexto

Repositorio de documentación SDLC para Keygo (plataforma multi-tenant de autenticación/autorización). Ciclo: Discovery → Requirements → Design → UI → Data Model → Planning → Development → Testing → Deployment → Operations → Monitoring → Feedback.

Estado y pendientes: ver `macro-plan.md`.

---

## Principios

1. **Análisis antes de acción**: mapear antes de mover o crear
2. **No destruir**: mover a `bkp/` antes de eliminar
3. **Convenciones obligatorias**: toda navegación sigue `00-documental-planning/navigation-conventions.md`
4. **Agnóstico cuando sea posible**: tech-specific solo donde sea necesario

---

## Flujo de Trabajo

1. Leer `macro-plan.md` — identificar SP activo y estado
2. Revisar material de referencia en `bkp/` si el SP lo indica
3. Crear o editar archivos según el SP, aplicando navigation-conventions
4. Actualizar estado en `macro-plan.md` al completar

---

## Output Esperado

- Documentación navegable, sin redundancia, con propósito claro por sección
- Cada carpeta con su `README.md` índice
- Cada doc (no README) con header/footer de navegación, índice propio y back-to-top por sección
