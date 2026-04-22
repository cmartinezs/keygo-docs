[← HOME](../README.md)

---

# Phase 3-4: Design & UI Design

Documentamos cómo fluye el sistema y cómo interactúa el usuario, usando DDD estratégico.

**Pregunta central**: ¿Cómo fluye el sistema y cuál es el modelo de dominio?

---

## Contenido

* [Strategic Design](./TEMPLATE-strategic-design.md)
* [System Flows](./TEMPLATE-system-flows.md)
* [Bounded Contexts](./bounded-contexts/TEMPLATE-context.md) (one per context)
* [UI Design System](./ui/TEMPLATE-design-system.md)
* [UI Wireframes](./ui/TEMPLATE-wireframes.md)

---

## Overview

En esta fase documentamos:

1. **Strategic Design (DDD)** — Bounded Contexts, subdominios, lenguaje ubicuo
2. **System Flows** — Flujos principales con diagramas
3. **Bounded Context Models** — Agregados, value objects, eventos de dominio
4. **UI Design System** — Principios visuales, componentes base
5. **UI Wireframes** — Pantallas principales y flujos de navegación

**Entregable**: Arquitectura de dominio + flujos operacionales + wireframes. El equipo entiende qué contextos existen y cómo interactúan.

**Duración típica**: 2-3 semanas

**Audiencia**: Tech Leads, Architects, Designers, Senior Developers

---

## Estructura de Carpetas

```
03-design/
├── README.md (este archivo)
├── TEMPLATE-strategic-design.md
├── TEMPLATE-system-flows.md
├── bounded-contexts/
│   ├── README.md
│   └── TEMPLATE-context.md (copiar para cada contexto)
└── ui/
    ├── README.md
    ├── TEMPLATE-design-system.md
    └── TEMPLATE-wireframes.md
```

---

## Convenciones

### DDD Strategic Design

- **Bounded Context**: Límite explícito del dominio
- **Subdomain**: Clasificación (Core, Supporting, Generic)
- **Ubiquitous Language**: Términos específicos del contexto
- **Domain Events**: Eventos importantes del negocio
- **Aggregates**: Raíces de agregados (entidades principales)

**Agnóstico**: ✅ SÍ — DDD es arquitectural pero no técnico

### System Flows

- **Actores**: Quién participa (usuarios, sistemas externos)
- **Steps**: Paso a paso (1. Usuario hace X, 2. Sistema responde Y)
- **Diagrams**: Mermaid sequence o flowchart
- **Contextos involucrados**: Qué bounded contexts se usan

---

## Instrucciones para Generación con IA

### Paso 1: Strategic Design

Pide a IA:
- Análisis de subdominios (Core vs Supporting vs Generic)
- Definición de 3-5 Bounded Contexts
- Lenguaje ubicuo por contexto
- Domain Vision Statement

### Paso 2: System Flows

Pide a IA:
- 5-10 flujos principales (registration, login, main process, etc.)
- Por cada flujo: diagrama + narrativa
- Incluir variantes y excepciones

### Paso 3: Bounded Context Models

Para cada contexto, pide:
- Agregados principales
- Value Objects
- Invariantes de dominio
- Eventos de dominio
- Interfaces (cómo interactúa con otros contextos)

### Paso 4: UI Design (si tienes equipo de design)

Pide:
- Design system: tokens, colores, tipografía
- Wireframes: pantallas principales
- Navigation flows

---

## Checklist de Salida

Antes de continuar a Data Model:

- [ ] ¿Bounded Contexts están claramente definidos?
- [ ] ¿El lenguaje ubicuo es consistente dentro de cada contexto?
- [ ] ¿Los system flows cubren las RF principales?
- [ ] ¿Las context interactions (entre contextos) están documentadas?
- [ ] ¿Los domain events representan eventos del negocio, no técnicos?
- [ ] ¿Las decisiones de design tienen alternativas documentadas?
- [ ] ¿Los wireframes mapean a los flujos del sistema?

---

[← HOME](../README.md) | [Siguiente >](./TEMPLATE-strategic-design.md)
