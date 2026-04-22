[← HOME](../README.md)

---

# Phase 5: Data Model

Especificamos las entidades, relaciones y flujos de datos del sistema.

**Pregunta central**: ¿Cómo se estructura y fluye la información?

---

## Contenido

* [Entities](./TEMPLATE-entities.md)
* [Relationships & ERD](./TEMPLATE-relationships.md)
* [Data Flows](./TEMPLATE-data-flows.md)

---

## Overview

En esta fase documentamos:

1. **Entities** — Qué datos guardamos, sus atributos, invariantes
2. **Relationships** — Cómo se relacionan (ERD: Entity Relationship Diagram)
3. **Data Flows** — Cómo se transforma y mueve la información

**Entregable**: Modelo de datos conceptual. Se extrae del Design anterior.

**Duración típica**: 1 semana (paralela con Design)

**Audiencia**: Architects, DBAs, Backend Developers

---

## Convenciones

### Agnóstico de Base de Datos

**NO mencionar**:
- Tipos SQL (INTEGER, VARCHAR, TIMESTAMP, etc.)
- Optimizaciones de DB (índices, particiones, etc.)
- Tecnologías específicas (PostgreSQL, MongoDB, etc.)

**Mencionar**:
- Tipos conceptuales (identificador único, texto, fecha, número)
- Invariantes (qué siempre debe cumplirse)
- Restricciones de negocio (valores permitidos, relaciones)

### Entidades vs. Value Objects

**Entidades** (tienen identidad única):
- Usuario
- Orden
- Transacción

**Value Objects** (son valores):
- Dirección
- Precio
- Cantidad

---

## Instrucciones para Generación con IA

### Paso 1: Extrae Entidades

Pide a IA (basándose en Design + Requirements):
- Lista de entidades principales
- Por cada una: atributos, tipo, obligatorio/opcional
- Invariantes (qué siempre debe cumplirse)

### Paso 2: Define Relaciones

Pide a IA:
- Relaciones entre entidades (1:1, 1:N, N:N)
- Cardinalidad (obligatoria/opcional)
- ERD (diagrama Mermaid)

### Paso 3: Document Data Flows

Pide a IA:
- Cómo fluyen los datos a través del sistema
- Transformaciones (qué cambia en cada paso)
- Puntos de sincronización (cuándo se guardan)

---

## Checklist de Salida

Antes de continuar a Planning:

- [ ] ¿Cada entidad corresponde a un concepto del dominio?
- [ ] ¿Las relaciones soportan los flujos del Design?
- [ ] ¿Las invariantes son claras?
- [ ] ¿El ERD es legible?
- [ ] ¿Los data flows muestran end-to-end?
- [ ] ¿Todo es agnóstico de tecnología?

---

[← HOME](../README.md) | [Siguiente >](./TEMPLATE-entities.md)
