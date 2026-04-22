[← HOME](../README.md)

---

# Phase 1: Discovery

Exploramos el problema, el contexto de mercado, los usuarios y sus necesidades.

**Pregunta central**: ¿Qué problema resolvemos y para quién?

---

## Contenido

* [Context & Motivation](./TEMPLATE-context-motivation.md)
* [System Vision](./TEMPLATE-system-vision.md)
* [System Scope](./TEMPLATE-system-scope.md)
* [Actors](./TEMPLATE-actors.md)
* [Needs & Expectations](./TEMPLATE-needs-expectations.md)
* [Final Analysis](./TEMPLATE-final-analysis.md)

---

## Overview

En esta fase documentamos:

1. **Problema real** — qué duele a nuestros usuarios (no la solución)
2. **Contexto de negocio** — por qué ahora, competencia, oportunidad
3. **Usuarios y actores** — quién usa el sistema, qué incentivos tiene
4. **Necesidades específicas** — qué necesita cada actor, dolor puntos
5. **Riesgos y oportunidades** — qué puede salir mal, qué ganamos

**Entregable**: Visión compartida del problema. Todos entienden por qué existe el producto.

**Duración típica**: 1-2 semanas

**Audiencia**: PMs, Founders, Tech Leads, Key Users

---

## Instrucciones para Generación con IA

### Paso 1: Reúne contexto básico

Proporciona a IA:
- Descripción del producto (2-3 oraciones)
- Problema específico
- Target users
- Contexto de mercado
- Restricciones iniciales

### Paso 2: Genera documento por documento

**NO** pidas todos de una vez. Orden recomendado:

1. **context-motivation.md** (plantilla primera)
   - Usa prompt en `00-GUIDE-AND-INSTRUCTIONS/INSTRUCTIONS-FOR-AI.md`
   
2. **system-vision.md** (requiere context-motivation como entrada)
   - Proporciona el documento anterior a IA
   
3. **actors.md** (requiere contexto)
   - Proporciona los anteriores
   
4. **needs-expectations.md** (requiere actors)
   - Proporciona los anteriores
   
5. **system-scope.md** (requiere vision + needs)
6. **final-analysis.md** (requiere todo anterior)

### Paso 3: Valida con equipo

- ¿El problema está claro?
- ¿Se entiende por qué es importante?
- ¿Todos los stakeholders están representados?
- ¿Hay riesgos u oportunidades no mencionadas?

### Paso 4: Ajusta y refina

- Agrega ejemplos específicos si falta
- Elimina genéricos
- Asegúrate de agnóstico (sin tecnologías mencionadas)

---

## Templates Disponibles

Cada documento tiene un template `TEMPLATE-*.md`:

- `TEMPLATE-context-motivation.md` — Plantilla para problema + contexto
- `TEMPLATE-system-vision.md` — Plantilla para visión
- `TEMPLATE-system-scope.md` — Plantilla para límites
- `TEMPLATE-actors.md` — Plantilla para usuarios
- `TEMPLATE-needs-expectations.md` — Plantilla para necesidades
- `TEMPLATE-final-analysis.md` — Plantilla para análisis consolidado

**Cómo usar**: Lee el template, proporciónalo a IA como ejemplo, pide que genere el documento real.

---

## Checklist de Salida

Antes de continuar a Requirements, valida:

- [ ] ¿Contexto-motivation responde por qué existe el producto?
- [ ] ¿System-vision es diferente del problema (uno es "qué es", otro es "adónde va")?
- [ ] ¿Scope está claro (qué dentro, qué fuera)?
- [ ] ¿Actors cubre todos los stakeholders (usuarios, admins, externos)?
- [ ] ¿Needs es user-centric (duele, no soluciones)?
- [ ] ¿Final-analysis consolida riesgos + oportunidades?
- [ ] ¿Todo es agnóstico? (sin mencionar tecnologías)

---

[← HOME](../README.md) | [Siguiente >](./TEMPLATE-context-motivation.md)
