[← HOME](../README.md)

---

# Phase 2: Requirements

Especificamos QUÉ debe hacer el sistema, sin prescribir tecnología de implementación.

**Pregunta central**: ¿Qué debe hacer el sistema?

---

## Contenido

* [Glossary](./TEMPLATE-glossary.md)
* [Priority Matrix](./TEMPLATE-priority-matrix.md)
* [Scope Boundaries](./TEMPLATE-scope-boundaries.md)
* [Functional Requirements](./TEMPLATE-rf-template.md) (one per RF)
* [Non-Functional Requirements](./TEMPLATE-rnf-template.md) (one per RNF)

---

## Overview

En esta fase documentamos:

1. **Glossary** — vocabulario unificado del dominio
2. **Functional Requirements (RF)** — capacidades que el usuario espera
3. **Non-Functional Requirements (RNF)** — atributos de calidad (seguridad, performance, escalabilidad)
4. **Priority Matrix** — priorización MoSCoW de requisitos
5. **Scope Boundaries** — qué entra en MVP, qué queda fuera, por qué

**Entregable**: Especificación completa y agnóstica. El equipo de desarrollo sabe exactamente qué construir.

**Duración típica**: 1-2 semanas

**Audiencia**: PMs, QA, Tech Leads, Developers

---

## Convenciones

### Requisitos Agnósticos

**Prohibido**:
- Nombres de tecnologías (JWT, OAuth2, PostgreSQL, etc.)
- Implementaciones (usar Redis, Spring Security, etc.)
- Patrones de código (MVC, hexagonal, etc.)

**Permitido**:
- Capacidades (usuario puede loguear)
- Atributos (response <500ms, soporta 10k users)
- Restricciones de negocio (GDPR compliant, disponible 24/7)

### Estructura de Requisito

Cada RF/RNF sigue un template:

```markdown
# [ID]: [Nombre]

**Descripción**: [Qué debe hacer - 1-2 oraciones]

**Justificación**: [Por qué es importante]

**Criterios de Aceptación**: [Given/When/Then - Gherkin format]

**Dependencias**: [Otros RF/RNF que requiere]

**Riesgos**: [Qué podría salir mal]
```

---

## Instrucciones para Generación con IA

### Paso 1: Prepara lista de requisitos

Proporciona a IA:
- Listado base de RF/RNF (puedes proporcionarla o pedirle que genere primero)
- Para cada uno: descripción breve
- Contexto del Discovery anterior

### Paso 2: Genera Glossary

Pide a IA:
- 30-50 términos del dominio
- Definiciones claras
- Ejemplos de uso

### Paso 3: Genera RF/RNF individuales

**NO** pidas todo de una vez. Por cada RF/RNF:

1. Proporciónale el template
2. Proporciona el contexto (por qué es importante)
3. Pide que complete el documento
4. Valida y ajusta

### Paso 4: Genera Priority Matrix & Scope

Pide a IA:
- Matriz MoSCoW de todos los RF/RNF
- Tabla de scope boundaries (dentro/fuera con razones)

### Paso 5: Valida Trazabilidad

Asegúrate de que:
- Cada RF/RNF conecta con necesidades del Discovery
- No hay requisitos sin justificación
- Las prioridades tienen sentido

---

## Checklist de Salida

Antes de continuar a Design:

- [ ] ¿Glossary cubre todos los términos importantes?
- [ ] ¿Cada RF responde a una necesidad del Discovery?
- [ ] ¿Cada RNF es medible?
- [ ] ¿Los criterios de aceptación son verificables (no subjetivos)?
- [ ] ¿Las dependencias están documentadas?
- [ ] ¿MVP está claro (Must-haves)?
- [ ] ¿Todo es agnóstico? (sin tecnologías mencionadas)
- [ ] ¿Scope boundaries son explícitas? (no solo lo no mencionado)

---

[← HOME](../README.md) | [Siguiente >](./TEMPLATE-glossary.md)
