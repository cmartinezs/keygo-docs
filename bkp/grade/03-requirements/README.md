# Requerimientos

> A continuación se presentan los requerimientos funcionales y no funcionales para la plataforma GRADE, derivados del análisis realizado durante la fase de discovery. Este documento sirve como base para el desarrollo y evolución del sistema, asegurando que las necesidades clave sean abordadas de manera efectiva.

[Volver al HOME](../README.md#contenido-del-wiki)

## Contenido

- [Análisis del Discovery](#análisis-del-discovery)
  - [Centralización del proceso para coherencia y seguridad](#centralización-del-proceso-para-coherencia-y-seguridad)
  - [Arquitectura modular y escalabilidad desde el inicio](#arquitectura-modular-y-escalabilidad-desde-el-inicio)
  - [Roles y gobernanza](#roles-y-gobernanza)
  - [Banco de preguntas unificado y reutilizable](#banco-de-preguntas-unificado-y-reutilizable)
  - [Automatización de la calificación](#automatización-de-la-calificación)
  - [Integración con otras plataformas](#integración-con-otras-plataformas)
  - [Experiencia de usuario](#experiencia-de-usuario)
  - [Monitoreo, analítica y soporte operativo](#monitoreo-analítica-y-soporte-operativo)
  - [Delimitación de alcance y evolución futura](#delimitación-de-alcance-y-evolución-futura)
  - [Conclusión](#conclusión)
- [Catálogo](#catálogo)
  - [Requerimientos funcionales](#requerimientos-funcionales)
  - [Requerimientos no funcionales](#requerimientos-no-funcionales)
- [Alcance del MVP](#alcance-del-mvp)

## Análisis del Discovery

En la fase **Discovery** del proyecto GRADE, el equipo de Wanku mantuvo conversaciones internas para alinear la visión y definir **qué debe lograr la plataforma**. A continuación se analizan los temas clave discutidos por el equipo, mostrando cómo cada diálogo interno llevó a decisiones concretas sobre los **requerimientos funcionales (RF)** y **requerimientos no funcionales (RNF)** finalmente aprobados.

Para más detalles, ver [Análisis del Discovery](../02-discovery/discovery-analysis.md).

---

### Centralización del proceso para coherencia y seguridad
El equipo coincidió en que GRADE debía unificar en un **flujo único y controlado** la creación de pruebas, su distribución y la corrección automatizada.
- Se buscó eliminar la dispersión de herramientas ad-hoc.
- Esto derivó en requerimientos para que GRADE sea la **fuente única** de creación y calificación de evaluaciones.
- Además, se definieron **RNF de seguridad y trazabilidad**: control de acceso por rol, bitácoras de acciones y flujos cerrados.

---

### Arquitectura modular y escalabilidad desde el inicio
Se discutió que el sistema debía ser **centralizado en procesos**, pero **modular en arquitectura**.
- Centralizado: coherencia pedagógica y seguridad.
- Modular: componentes desacoplados (banco de preguntas, OCR, motor de calificación, reportes).
- Esto llevó a requerimientos **RNF de escalabilidad** (soportar picos en periodos de examen) y de **mantenibilidad** (arquitectura extensible).

---

### Roles y gobernanza
Se acordó un **modelo de roles**:
- **Administrador**: banco de preguntas, usuarios, parámetros globales.
- **Coordinador**: diseña evaluaciones comunes, lineamientos curriculares.
- **Docente**: crea y califica sus evaluaciones.

Se definieron requerimientos funcionales de **control de acceso** por rol y se descartó, por ahora, un rol de soporte técnico. Esto generó también RNF de **seguridad y gobernanza**.

---

### Banco de preguntas unificado y reutilizable
Se definió un **repositorio centralizado de ítems** con:
- Metadatos pedagógicos,
- Control de versiones,
- Historial de uso,
- Búsqueda y selección para crear evaluaciones.

Esto derivó en RF para **gestionar ítems versionados y trazables** y RNF para mantener **coherencia curricular y evitar duplicidad**.

---

### Automatización de la calificación
Tema recurrente: **calificación automática** de ítems objetivos.
- RF: ingesta de respuestas vía escaneo OCR, foto o carga digital.
- RF: cálculo automático de puntajes y conversión a nota/escala.
- RNF: tiempos de procesamiento rápidos (minutos).

Se definió explícitamente lo **fuera de alcance** en el MVP: preguntas abiertas y rúbricas complejas.

---

### Integración con otras plataformas
El equipo acordó habilitar **integraciones controladas vía API** (REST/GraphQL y webhooks).
- RF: crear evaluaciones, enviar respuestas y consultar resultados vía API.
- RNF: seguridad en integraciones (OAuth2, cifrado, scopes).
- Se dejó **fuera de alcance** en el MVP integraciones institucionales complejas (SSO, SIS, etc.).

---

### Experiencia de usuario
Se priorizó la **usabilidad**:
- Una única interfaz integrada para todo el ciclo de evaluación.
- Reducción de pasos manuales (ej. generación automática de PDF, cálculo automático de notas).
- RNF: interfaz intuitiva, mensajes claros de error, consistencia con el resto del ecosistema Wanku.

El equipo fijó objetivos de simplificación: reducir en ≥30% los pasos manuales.

---

### Monitoreo, analítica y soporte operativo
Se definió incluir un **panel de monitoreo** con:
- Dashboard de uso (n.º de evaluaciones, tiempos de calificación, tasas de error OCR).
- Alertas de fallos y métricas operativas.
- RF: reportes pedagógicos básicos (promedios, distribuciones, índices de dificultad).

Esto redunda en RNF de **observabilidad** (métricas, logs, trazas, alertas).

---

### Delimitación de alcance y evolución futura
Se documentó claramente qué está **dentro y fuera del alcance** del MVP:
- Dentro: ítems objetivos, banco de preguntas, OCR/foto, reportes básicos.
- Fuera: proctoring, preguntas abiertas, integraciones institucionales complejas.

Se adoptó un **roadmap incremental**, con arquitectura modular que permita incorporar nuevas funcionalidades en el futuro (extensibilidad y mantenibilidad como RNF).

---

### Conclusión
Las conversaciones internas del equipo Wanku durante el discovery de GRADE fundamentaron de manera directa los requerimientos del sistema.  
Cada tema debatido —centralización, roles, banco de preguntas, automatización, integración, usabilidad, monitoreo y alcance— se reflejó en **requerimientos funcionales y no funcionales de alto nivel**.  
El resultado es una base sólida para avanzar hacia la especificación y los casos de uso, con requerimientos alineados a necesidades reales y consensuadas en el equipo.

---

## Catálogo

### Requerimientos funcionales
1. [RF01 — Ciclo de evaluación centralizado](functional/rf01-centralized-evaluation-cicle.md)
    > GRADE debe unificar en un flujo único todo el ciclo de una evaluación (creación, distribución, recolección de respuestas, calificación y publicación), garantizando coherencia, control y trazabilidad.
2. [RF02 — Banco de preguntas](functional/rf02-questions-centralized-bank.md)
    > Repositorio único y versionado de ítems reutilizables con metadatos pedagógicos, trazabilidad de uso y control de vigencia, para asegurar coherencia curricular y evitar duplicidad.
3. [RF03 — Gestión de evaluaciones y generación de entregables](functional/rf03-evaluations-and-deliverables-management.md)
    > Creación de evaluaciones a partir de ítems del banco y generación de PDF con identificadores únicos, asegurando trazabilidad y control de versiones.
4. [RF04 — Ingesta de respuestas multicanal](functional/rf04-multichannel-answers-ingest.md)
    > Permite cargar respuestas vía escaneo OCR, foto desde móvil o archivos CSV/web, asociándolas automáticamente a la evaluación mediante identificadores únicos.
5. [RF05 — Calificación automática de ítems objetivos](functional/rf05-objective-items-automatic-grading.md)
    > Corrige automáticamente respuestas de ítems cerrados, calcula puntajes y convierte resultados en notas según reglas configurables, en tiempos acotados.
6. [RF06 — Publicación y consulta de resultados](functional/rf06-results-publication-and-consulting.md)
    > Permite publicar resultados de evaluaciones, consultar estadísticas básicas y exportar en CSV/PDF, con accesos diferenciados por rol.
7. [RF07 — Roles y permisos](functional/rf07-roles-and-permissions.md)
    > Modelo con roles diferenciados (Administrador, Coordinador, Docente), cada uno con permisos específicos para garantizar seguridad y gobernanza.
8. [RF08 — Auditoría y trazabilidad](functional/rf08-audit-and-traceability.md)
    > Registro seguro e inmutable de todas las acciones críticas del sistema (quién, cuándo y qué), con consultas filtrables y accesibles solo a roles autorizados.
9. [RF09 — Paneles operativos y métricas](functional/rf09-operational-dashboards-and-metrics.md)
    > Dashboard para Administradores con métricas clave (evaluaciones, tiempos, errores) y alertas básicas, exportables en CSV/JSON.
10. [RF10 — Reportes pedagógicos básicos](functional/rf10-basic-pedagogical-reports.md)
    > Generación de reportes simples por evaluación (promedios, distribuciones, dificultad de ítems), exportables en PDF/CSV y con accesos diferenciados por rol.
11. [RF11 — Notificaciones de hitos](functional/rf11-milestone-notifications.md)
    > Notifica a usuarios sobre eventos clave (creación, carga, calificación, resultados, fallos) vía in-app y email, con preferencias configurables y registro en auditoría.
12. [RF12 — Integración con sistemas externos](functional/rf12-external-systems-integration.md)
    > Permite que aplicaciones externas creen evaluaciones, envíen respuestas y consulten resultados de forma controlada.
13. [RF13 — Administración del sistema](functional/rf13-system-administration.md)
    > Gestión global de parámetros, usuarios y políticas del banco de preguntas, con registro en auditoría y control exclusivo para Administradores.
14. [RF14 — Preguntas abiertas y calificación con rúbricas](functional/rf14-open-questions-and-grading-with-rubrics.md)
    > Soporte futuro para preguntas abiertas y ensayos con rúbricas y retroalimentación cualitativa.
15. [RF15 — Mecanismos de proctoring y antifraude](functional/rf15-proctoring-and-anti-fraud-mechanisms.md)
    > Controles y registros para reducir fraude académico, con posibilidad de integrarse a servicios externos de proctoring.
16. [RF16 — Integraciones institucionales avanzadas](functional/rf16-advanced-institutional-integrations.md)
    > Integración futura con SIS, SSO y LMS institucionales para sincronizar estudiantes, cursos y resultados.

### Requerimientos no funcionales

1. [RNF1 — Seguridad y control de acceso](non-functional/rnf01-security-and-access-control.md)
    > Autenticación robusta, autorización por rol y cifrado de datos en tránsito y en reposo.
2. [RNF2 — Privacidad y tratamiento de datos](non-functional/rnf02-privacy-and-data-handling.md)
    > Cumplimiento de principios de minimización y propósito; políticas de retención y eliminación segura.
3. [RNF3 — Rendimiento](non-functional/rnf03-performance.md)
   > Procesamiento de cargas y calificación en minutos por evaluación; tiempos de respuesta ágiles en UI.
4. [RNF4 — Disponibilidad y resiliencia](non-functional/rnf04-availability-and-resilience.md)
    > Alta disponibilidad, tolerancia a fallos y recuperación automática con respaldos periódicos.
5. [RNF5 — Escalabilidad](non-functional/rnf05-scalability.md)
    > Escalado horizontal en procesos críticos (ingesta, calificación) para soportar picos de uso en periodos de examen.
6. [RNF6 — Mantenibilidad y extensibilidad](non-functional/rnf06-maintainability-and-extensibility.md)
    > Arquitectura modular y documentada que facilite actualizaciones y la incorporación de nuevos tipos de ítems o integraciones.
7. [RNF7 — Observabilidad](non-functional/rnf07-observability.md)
    > Métricas, logs estructurados, trazas distribuidas y alertas automáticas para detectar fallos o cuellos de botella.
8. [RNF8 — Usabilidad](non-functional/rnf08-usability.md)
    > Interfaz intuitiva y consistente, con reducción de pasos manuales y mensajes de error claros.
9. [RNF9 — Compatibilidad](non-functional/rnf09-compatibility.md)
    > Soporte para navegadores modernos y despliegue alineado a la infraestructura y lineamientos de UI/UX de Wanku.
10. [RNF10 — Cumplimiento y gobernanza](non-functional/rnf10-compliance-and-governance.md)
    > Políticas documentadas de gestión de banco, roles y API; revisiones periódicas de permisos y trazabilidad.
11. [RNF-11 — Mecanismos de integración segura](non-functional/rnf11-secure-integration-mechanisms.md)
    > API REST/GraphQL documentadas con OAuth2, scopes, webhooks, registro en auditoría y límites de uso.

---

## Alcance del MVP

> El alcance del MVP de GRADE se definió cuidadosamente para equilibrar funcionalidades esenciales con un desarrollo ágil y viable.

Más detalles en:
- [Alcance funcional](functional/mvp.md)
- [Alcance no funcional](non-functional/mvp.md)