[← HOME](../README.md)

---

# Phase 6: Planning

Documentamos la estrategia de entrega: roadmap, epics, versioning.

**Pregunta central**: ¿Cuándo y cómo entregamos?

---

## Contenido

* [Roadmap](./TEMPLATE-roadmap.md)
* [Epics](./TEMPLATE-epics.md)
* [Versioning Strategy](./TEMPLATE-versioning.md)

---

## Overview

En esta fase documentamos:

1. **Roadmap** — Visión a 6-12 meses, fases de entrega
2. **Epics** — Agrupación de RF por iniciativa
3. **Versioning** — Estrategia de versiones, compatibilidad

**Entregable**: Plan de entrega. El equipo sabe en qué orden construir y cuándo hablamos de "V1", "V2", etc.

**Duración típica**: 1 semana

**Audiencia**: PMs, Tech Leads, Stakeholders

---

## Convenciones

### MVP vs. Phases

- **MVP (Minimum Viable Product)**: Lo absolutamente necesario para validar
- **Phase 2, 3, ...**: Expansiones progresivas

### Épicos

- Agrupar RF relacionados (ej: "Todo lo de autenticación")
- Dar contexto de negocio (por qué esta iniciativa)
- Estimar duración y recursos

---

## Instrucciones para Generación con IA

### Paso 1: Define Roadmap

Pide a IA:
- Fases de entrega (MVP → Phase 2 → Phase 3)
- Duración estimada de cada fase
- RF/épics por fase
- Dependencias entre fases

### Paso 2: Define Épics

Pide a IA:
- Agrupar RF relacionados
- Por cada épic: nombre, descripción, RF inclusos
- Prioridad y estimación

### Paso 3: Versioning Strategy

Pide a IA:
- Estrategia semántica (major.minor.patch)
- Ciclo de releases
- Compatibilidad backward
- Deprecation policy

---

## Checklist de Salida

Antes de continuar a Development:

- [ ] ¿MVP es claro?
- [ ] ¿Cada fase tiene un objetivo específico?
- [ ] ¿Las épics están bien delimitadas?
- [ ] ¿Las dependencias son explícitas?
- [ ] ¿El roadmap es realista (tiene estimaciones)?
- [ ] ¿Hay buffer para lo inesperado?

---

[← HOME](../README.md) | [Siguiente >](./TEMPLATE-roadmap.md)
