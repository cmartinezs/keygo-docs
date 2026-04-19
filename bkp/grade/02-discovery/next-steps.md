# Plan de trabajo post-Discovery

---

## Contenido
- [1. Definición de Requisitos (RF / RNF)](#1-definición-de-requisitos-rf--rnf)
- [2. Diseño Funcional & Modelado de Procesos](#2-diseño-funcional--modelado-de-procesos)
- [3. Definición de Tecnologías & Arquitectura](#3-definición-de-tecnologías--arquitectura)
- [4. Implementación Iterativa (MVP)](#4-implementación-iterativa-mvp)
- [5. QA & Validación](#5-qa--validación)
- [6. Retro & Roadmap v2](#6-retro--roadmap-v2)

---

## 1. Definición de Requisitos (RF / RNF)

### Objetivo
Convertir las necesidades y expectativas del discovery en un conjunto priorizado de requisitos funcionales y no funcionales, totalmente trazables a los objetivos estratégicos.

### Actividades principales
- Talleres y entrevistas con Docentes, Coordinadores y Administrador.
- Priorización MoSCoW.
- Redacción de criterios de aceptación basados en KPI.
- Identificación de restricciones técnicas, legales y de datos.

### Entregables
| Documento | Descripción | Formato |
|-----------|-------------|---------|
| Catálogo RF | REQ-F-001… con historia, prioridad, CA | Markdown / Jira |
| Catálogo RNF | Seguridad, rendimiento, compatibilidad | Markdown |
| Matriz trazabilidad | RF ↔ Necesidad ↔ Objetivo | Mermaid / Excel |
| Glosario | Términos pedagógicos y técnicos | Markdown |

**Responsables:** Product Owner (lidera), UX (historias), Security Lead (RNF).  
**Criterio de salida:** ≥ 90 % de epics *Must/Should* tienen CA validado por PO + Stakeholders.

---

## 2. Diseño Funcional & Modelado de Procesos

### Objetivo
Modelar el funcionamiento extremo-a-extremo de GRADE antes de elegir tecnologías, cubriendo tanto el flujo general de evaluación como los sub-procesos críticos.

### Actividades
1. **Modelado de flujos BPMN / Mermaid**
    - **Flujo global**: “Crear → Publicar → Aplicar → Calificar → Reportar”.
    - **Sub-flujo Banco de Preguntas**: alta, edición, versión y reutilización de ítems.
    - **Sub-flujo Escaneo & Calificación automática**: carga de PDF/foto, OCR, scoring y registro de evidencias.
2. **Wireframes high-fidelity** (desktop + mobile) para cada paso crítico.
3. **Diagramas de interacción** (secuencia) entre actores, aplicaciones integradas y sistema.
4. **Política de integración**:
    - Pasos de registro de una app externa.
    - Scopes OAuth y ejemplo de llamadas API.
    - Requisitos de sandbox y homologación.

### Entregables
| Documento / Artefacto            | Contenido                           | Formato               |
|----------------------------------|-------------------------------------|-----------------------|
| BPMN “Evaluación”                | Del docente al reporte final        | .bpmn / .md (Mermaid) |
| BPMN “Banco de Preguntas”        | Alta, versión, aprobación           | .bpmn / Mermaid       |
| BPMN “Escaneo & OCR”             | Validación archivo → nota publicada | .bpmn / Mermaid       |
| Wireframes v0.2                  | Pantallas clave (web + móvil)       | Figma                 |
| Especificación OpenAPI 3 (draft) | Endpoints, schemas                  | YAML                  |
| Guía de Integración v0.1         | Registro app, scopes, sandbox       | Markdown              |

### Criterio de salida
Prototipo navegable validado por **5 docentes** (SUS ≥ 80/100) **y** los tres diagramas BPMN revisados por el equipo técnico y de negocio.

---

## 3. Definición de Tecnologías & Arquitectura

### Objetivo
Seleccionar stack y patrones que satisfagan los RNF.

### Actividades
- Redacción de **ADR**.
- Matriz de decisión (framework, DB, OCR, cloud).
- Diseño **C4** (Context, Container, Component, Code).
- Modelo de datos (ER + migraciones).
- Estrategia de cifrado / gestión de secretos.

### Entregables
| ADR     | Tema              | Estado      |
|---------|-------------------|-------------|
| ADR-001 | Framework backend | Aprobado    |
| ADR-002 | Motor OCR         | En análisis |
| ADR-003 | Cloud provider    | Aprobado    |

**Criterio de salida:** Comité de arquitectura aprueba ADR críticos + diagrama C4 publicado.

---

## 4. Implementación Iterativa (MVP)

### Objetivo
Construir y desplegar el MVP en sprints de 2 semanas.

### Actividades
- Crear backlog (épicas → historias).
- Configurar CI/CD (tests, SAST).
- Desarrollo TDD, PR obligatoria, code review.
- Demo + retro cada sprint.

### Roadmap de sprint inicial
| Sprint | Epic objetivo           | Demo / Evidencia        |
|--------|-------------------------|-------------------------|
| S1     | Banco de preguntas CRUD | API + UI Lista/Detalle  |
| S2     | Generador PDF           | Descarga & hash versión |
| S3     | Motor OCR               | Calificación 10 ítems   |
| S4     | Reportes básicos        | Promedio + Histograma   |

**DoD global MVP:** cobertura ≥ 80 %, imágenes Docker firmadas, KPI técnicos (≤ 5 min/procesamiento, SLA 99,9 %).

---

## 5. QA & Validación

### Objetivo
Demostrar que el MVP cumple calidad, seguridad y rendimiento.

### Actividades
- Pruebas unit, integration, e2e (Playwright).
- Pentest externo + ZAP en pipeline.
- Pruebas de carga k6 (2× pico).
- Usabilidad con docentes (NPS early).

### Entregables
- Informe de pruebas.
- Certificado pentest (0 críticos).
- Reporte k6 (latencia p95 < 300 ms).
- Encuesta NPS piloto.

**Criterio de salida:** Todos los tests pasan, sin vulnerabilidades críticas, métricas cumplen umbrales.

---

## 6. Retro & Roadmap v2

### Objetivo
Aprender del piloto y planificar la versión 2 (preguntas abiertas, IA, etc.).

### Actividades
- Retro con equipo + docentes piloto.
- Análisis KPI vs. objetivos.
- Re-priorización backlog.
- Redacción Roadmap v2.

### Entregables
- Informe retro + plan de acción.
- Roadmap v2 con épicas y nuevas metas KPI.

**Criterio de salida:** Steering committee aprueba Roadmap v2 y presupuesto correspondiente.

---

[< Anterior](need-expectations.md) | [Inicio](README.md) | [Siguiente >](reflection.md)