[← Índice](./README.md) | [< Anterior](./needs-expectations.md) | [Siguiente >](./final-reflection.md)

---

# Próximos Pasos

Este documento describe el plan de trabajo posterior al Discovery: las fases que deberá recorrer Keygo desde la definición de requisitos hasta su operación estable, los entregables esperados en cada fase y los criterios que marcarán el cierre de cada etapa.

## Contenido

- [1. Definición de Requisitos](#1-definición-de-requisitos)
- [2. Diseño Funcional y Modelado de Procesos](#2-diseño-funcional-y-modelado-de-procesos)
- [3. Modelado de Datos](#3-modelado-de-datos)
- [4. Definición de Arquitectura](#4-definición-de-arquitectura)
- [5. Implementación Iterativa del MVP](#5-implementación-iterativa-del-mvp)
- [6. Validación y Aseguramiento de Calidad](#6-validación-y-aseguramiento-de-calidad)
- [7. Retrospectiva y Roadmap v2](#7-retrospectiva-y-roadmap-v2)
- [Comentarios de los Revisores](#comentarios-de-los-revisores)

---

## 1. Definición de Requisitos

### Objetivo

Convertir las necesidades y expectativas del Discovery en un conjunto priorizado de requisitos funcionales y no funcionales, completamente trazables a los objetivos estratégicos definidos.

### Actividades principales

- Sesiones de trabajo con los actores clave del sistema (administradores de organización, equipo operativo, representantes de aplicaciones cliente).
- Priorización de requisitos según criterios de valor y riesgo.
- Redacción de criterios de aceptación alineados con los KPIs establecidos.
- Identificación de restricciones legales, de privacidad y de negocio que condicionen el diseño.

### Entregables

| Documento | Descripción |
|-----------|-------------|
| Catálogo de Requisitos Funcionales | Requisitos numerados con descripción, prioridad y criterios de aceptación. |
| Catálogo de Requisitos No Funcionales | Requisitos de seguridad, disponibilidad, rendimiento, privacidad y mantenibilidad. |
| Matriz de trazabilidad | Relación entre requisitos, necesidades del Discovery y objetivos estratégicos. |
| Glosario del dominio | Términos del dominio de identidad y acceso, acordados con los actores del sistema. |

**Responsables:** Product Owner (lidera), actores clave del sistema (validan), Security Lead (requisitos de seguridad).  
**Criterio de salida:** ≥ 90 % de los requisitos prioritarios tienen criterios de aceptación validados por el Product Owner y los actores representativos.

[↑ Volver al inicio](#próximos-pasos)

---

## 2. Diseño Funcional y Modelado de Procesos

### Objetivo

Modelar el funcionamiento extremo a extremo de Keygo antes de definir las decisiones de arquitectura, cubriendo tanto los flujos principales como los sub-procesos críticos de cada actor.

### Actividades

1. **Modelado de flujos por capacidad:**
    - Flujo de registro y configuración de una organización.
    - Flujo de gestión del ciclo de vida de un usuario (alta, modificación, suspensión, baja).
    - Flujo de autenticación: inicio de sesión, renovación de credenciales, cierre de sesión, revocación.
    - Flujo de gestión de aplicaciones cliente: registro, configuración de ámbito, revocación.
    - Flujo de auditoría: generación y consulta del historial de eventos de seguridad.
2. **Diseño de prototipos de interfaz** para los flujos de los actores principales (administrador de plataforma, administrador de organización, usuario final).
3. **Diagramas de interacción** entre actores, aplicaciones cliente y el sistema.
4. **Política de integración:**
    - Proceso de registro de una aplicación cliente.
    - Requisitos de validación y acceso al entorno de pruebas.
    - Condiciones de operación en producción.

### Entregables

| Artefacto | Contenido |
|-----------|-----------|
| Diagramas de flujo por capacidad | Flujo completo de cada capacidad del MVP, incluyendo caminos alternativos y errores. |
| Prototipos de interfaz | Pantallas clave para cada actor principal. |
| Diagramas de interacción | Secuencia de interacciones entre actores, aplicaciones y sistema. |
| Política de integración v0.1 | Proceso de registro, requisitos de validación y condiciones de operación. |

**Criterio de salida:** Prototipos validados por representantes de al menos dos organizaciones piloto, y flujos revisados y aprobados por el equipo de producto y el equipo técnico.

[↑ Volver al inicio](#próximos-pasos)

---

## 3. Modelado de Datos

### Objetivo

Definir las entidades del sistema, sus atributos, relaciones y restricciones de integridad, garantizando que el modelo soporte el aislamiento entre organizaciones como restricción central de diseño.

### Actividades

- Identificación de entidades por dominio funcional (organizaciones, usuarios, roles, sesiones, aplicaciones cliente, eventos de auditoría, suscripciones).
- Definición de relaciones, cardinalidades y restricciones de integridad.
- Verificación de que el modelo garantiza el aislamiento entre organizaciones en cada entidad.
- Validación del modelo con los flujos definidos en la fase anterior.

### Entregables

| Artefacto | Contenido |
|-----------|-----------|
| Diagrama de entidades y relaciones | Modelo completo con atributos, relaciones y restricciones. |
| Diccionario de datos | Descripción de cada entidad y atributo con sus reglas de negocio. |
| Política de retención y ciclo de vida de datos | Criterios de conservación, anonimización y eliminación por tipo de dato. |

**Criterio de salida:** Modelo revisado y aprobado por el equipo técnico y el Product Owner; verificación explícita de que el aislamiento entre organizaciones es estructuralmente imposible de violar.

[↑ Volver al inicio](#próximos-pasos)

---

## 4. Definición de Arquitectura

### Objetivo

Tomar y documentar las decisiones de diseño que determinarán cómo se construye Keygo, asegurando que satisfacen los requisitos no funcionales y permiten la evolución del sistema sin reescritura del núcleo.

### Actividades

- Redacción de registros de decisión de arquitectura para las elecciones críticas del sistema.
- Diseño de la estructura de componentes del sistema y sus responsabilidades.
- Definición de la estrategia de seguridad y gestión de credenciales.
- Definición de la estrategia de despliegue y operación continua.

### Entregables

| Artefacto | Contenido |
|-----------|-----------|
| Registros de decisión de arquitectura | Una decisión por registro: contexto, opciones evaluadas, decisión y consecuencias. |
| Diagrama de componentes del sistema | Vista de los módulos principales, sus responsabilidades y sus interacciones. |
| Estrategia de seguridad | Gestión de credenciales, política de acceso entre componentes, principios de seguridad aplicados. |
| Estrategia de despliegue | Ambientes, proceso de entrega continua, criterios de promoción entre ambientes. |

**Criterio de salida:** Las decisiones críticas de arquitectura son aprobadas por el equipo técnico; el diagrama de componentes es coherente con los flujos definidos y el modelo de datos.

[↑ Volver al inicio](#próximos-pasos)

---

## 5. Implementación Iterativa del MVP

### Objetivo

Construir y desplegar el MVP de Keygo en iteraciones cortas, priorizando las capacidades del MVP definidas en el Discovery y validando con organizaciones piloto al final de cada ciclo.

### Actividades

- Construcción del backlog de producto a partir de los requisitos priorizados.
- Desarrollo iterativo con ciclos de revisión y retroalimentación al cierre de cada iteración.
- Validación continua con actores representativos.
- Incorporación de retroalimentación al backlog para iteraciones siguientes.

### Roadmap de iteraciones iniciales

| Iteración | Capacidad objetivo | Evidencia esperada |
|-----------|--------------------|--------------------|
| I1 | Registro y configuración de organización | Organización creada y operativa con su administrador. |
| I2 | Gestión de usuarios | Alta, modificación, suspensión y baja desde el panel del administrador. |
| I3 | Autenticación de usuarios | Inicio de sesión, cierre de sesión y revocación de acceso funcionales. |
| I4 | Registro y gestión de aplicaciones cliente | Aplicación registrada, con ámbito definido y acceso verificado. |
| I5 | Control de acceso basado en roles | Rol creado, asignado a usuario y verificado en una operación real. |
| I6 | Facturación básica | Organización con plan activo y ciclo de facturación configurado. |
| I7 | Auditoría de eventos | Historial consultable de acciones críticas por el administrador de la organización. |

**Criterio de salida del MVP:** todas las capacidades del MVP son funcionales, validadas por al menos una organización piloto, y los KPIs técnicos de disponibilidad y rendimiento se cumplen.

[↑ Volver al inicio](#próximos-pasos)

---

## 6. Validación y Aseguramiento de Calidad

### Objetivo

Demostrar que el MVP cumple los criterios de calidad, seguridad y rendimiento establecidos en los requisitos, antes del lanzamiento general.

### Actividades

- Verificación funcional de cada capacidad del MVP frente a los criterios de aceptación definidos.
- Evaluación de seguridad con foco en el aislamiento entre organizaciones y la protección de credenciales.
- Pruebas de rendimiento bajo condiciones de carga representativas.
- Pruebas de usabilidad con administradores reales de las organizaciones piloto.

### Entregables

| Artefacto | Contenido |
|-----------|-----------|
| Informe de validación funcional | Resultado de la verificación de cada criterio de aceptación. |
| Informe de evaluación de seguridad | Hallazgos, severidad y estado de resolución. |
| Informe de rendimiento | Comportamiento del sistema bajo carga; comparación con umbrales definidos. |
| Informe de usabilidad | Resultados de las pruebas con administradores piloto y acciones de mejora. |

**Criterio de salida:** todos los criterios de aceptación del MVP están verificados; la evaluación de seguridad no reporta hallazgos de severidad crítica pendientes de resolución; los umbrales de rendimiento se cumplen.

[↑ Volver al inicio](#próximos-pasos)

---

## 7. Retrospectiva y Roadmap v2

### Objetivo

Aprender del ciclo del MVP y planificar la siguiente iteración de la plataforma incorporando las capacidades que las organizaciones piloto demanden y los aprendizajes del equipo.

### Actividades

- Retrospectiva con el equipo y con representantes de las organizaciones piloto.
- Análisis de los KPIs alcanzados frente a los objetivos estratégicos definidos.
- Re-priorización del backlog a partir de la retroalimentación real.
- Redacción del Roadmap v2 con nuevas épicas y metas actualizadas.

### Entregables

| Artefacto | Contenido |
|-----------|-----------|
| Informe de retrospectiva | Aprendizajes del equipo, ajustes al proceso y compromisos de mejora. |
| Análisis de KPIs | Comparación entre los objetivos definidos y los resultados obtenidos. |
| Roadmap v2 | Épicas priorizadas para la siguiente fase, con criterios de éxito actualizados. |

**Criterio de salida:** el comité de producto aprueba el Roadmap v2 con sus prioridades y recursos asignados.

[↑ Volver al inicio](#próximos-pasos)

---

## Comentarios de los Revisores

A continuación se presentan los comentarios de los revisores sobre los próximos pasos del sistema.

| Revisor | Tipo | Contenido |
| ------- | ---- | --------- |
| — | — | Pendiente de revisión |

[↑ Volver al inicio](#próximos-pasos)

---

[← Índice](./README.md) | [< Anterior](./needs-expectations.md) | [Siguiente >](./final-reflection.md)
