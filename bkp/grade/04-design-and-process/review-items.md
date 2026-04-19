# Cosas por revisar — 04-design-and-process

- [Volver al índice](README.md)

Este archivo recoge ideas, propuestas y decisiones potenciales que surgieron durante el refinamiento de los casos de uso del *Banco de Preguntas* (S-BP). Son entradas de alcance futuro: no forman parte del MVP ni deben materializarse en esta etapa sin planificación adicional.

Notas generales
- Ubicación de referencia de los CUs afectados:
  - `use-cases/S-BP/S-BP-03/` (Retirar / Reactivar / Editar)
  - `use-cases/S-BP/S-BP-04/` (Buscar / Seleccionar)
  - `use-cases/S-BP/S-BP-05/` (Trazabilidad / Reportes)
- Objetivo del documento: mantener un registro práctico y ordenado de ideas técnicas/arquitectónicas que requieren discusión y priorización.

---

## 1) A — Vista/materialized view `question_metrics` (pre-computación de métricas)

Resumen
- Crear una vista materializada o tabla `question_metrics` que almacene métricas precomputadas por pregunta: `usage_count`, `overall_accuracy`, `last_used_on`, `avg_difficulty_estimate`, etc.

Motivación
- Las consultas de trazabilidad y los dashboards pueden ser costosas al derivar métricas on‑the‑fly de tablas de evaluación con mucho histórico.
- Precomputar reduce latencia en la UI y permite ofrecer SLAs de respuesta interactiva.

Impacto / Consideraciones
- Requiere job batch (p. ej. nightly) para recalcular/refresh.
- Diseñar estrategia de actualización incremental vs. full-refresh.
- Añadir índices apropiados y políticas de retención.

Dependencias
- `grading-management` (tables: `evaluation_questions`, `student_answers`, `student_evaluations`).

Estado: Pendiente — Prioridad: Media/Alta (planificar para iteración posterior)

Criterios de aceptación (cuando se implemente)
- La vista/tablas debe actualizarse sin bloquear la operación normal de la BD.
- Los dashboards que consumen `question_metrics` muestran números iguales o consistentes con las consultas de agregación en un entorno de prueba.

---

## 2) B — Tabla `reports` / `audit_logs` para registrar generación y descarga de reportes

Resumen
- Introducir una tabla de auditoría `reports` o usar `audit_logs` para registrar:
  - `report_id`, `entity` (p.ej. 'question'), `entity_id`, `user_id`, `format`, `created_at`, `status`, `storage_url`.

Motivación
- Auditoría de accesos y exportaciones de datos (cumplimiento, seguridad).
- Facilita trazabilidad sobre quién generó qué reporte y la posibilidad de limpiar/expirar archivos.

Impacto / Consideraciones
- Implica cambios menores en DDL y en los flujos de export/generación de reportes (CU-BP-10).
- Debe incluir políticas de retención y control de acceso a `storage_url`.

Dependencias
- `question-bank` y `grading-management` (para validar entidad / permisos).

Estado: Pendiente — Prioridad: Media (implementar cuando la generación/descarga asíncrona entre en alcance)

Criterios de aceptación
- Cada petición de generación de reporte queda registrada con usuario y timestamp.
- Los enlaces de descarga caducan según política y son invocados solo por usuarios autorizados.

---

## 3) C — `DATA_TEST.sql` con escenarios de prueba para consultas de trazabilidad

Resumen
- Añadir un script de datos de prueba (pequeño) `DATA_TEST.sql` que inserte: preguntas, evaluaciones, evaluation_questions, student_evaluations, student_answers y evaluation_options para validar las consultas de trazabilidad (CU-BP-09, CU-BP-10).

Motivación
- Permite probar y validar las consultas SQL de los anexos técnicos localmente y en CI.
- Facilita la verificación de la semántica (conteo de intentos, cálculo de tasa de acierto, manejo de borrados lógicos).

Impacto / Consideraciones
- Archivo de test no se debe ejecutar en producción.
- Mantenerlo pequeño y comentado; incluir expectativas (valores esperados) para cada consulta.

Estado: Pendiente — Prioridad: Baja/Media (útil para QA antes de implementación DDL)

Criterios de aceptación
- `DATA_TEST.sql` se ejecuta en una BD de desarrollo y las consultas ejemplo retornan los valores documentados en el script.

---

## 4) D — Sistema de etiquetas (`tags` + `question_tags`)

Resumen
- Crear tablas `tags` y `question_tags` para permitir etiquetar preguntas de forma libre y relacional.

Motivación
- Facilita búsquedas por etiquetas y permitirá funcionalidades UX (filtros por etiquetas, recomendaciones, agrupamientos temáticos).

Impacto / Consideraciones
- Cambios DDL y migración de datos si hay campos actuales que pretendan usarse como etiquetas.
- Índices y mantenimiento: `question_tags(question_fk, tag_fk)` con `UNIQUE` para evitar duplicados.

Dependencias
- `question-bank` DDL; UI para gestión de tags y asignación.

Estado: Pendiente — Prioridad: Media

Criterios de aceptación
- Permitir crear tags, asignarlos a preguntas y filtrar por tag en la búsqueda.

---

## 5) E — Campos opcionales en `questions`: `usage_count`, `is_draft`

Resumen
- Evaluar añadir columnas opcionales en `questions`:
  - `usage_count INTEGER DEFAULT 0` — contador de usos para consultas rápidas.
  - `is_draft BOOLEAN DEFAULT FALSE` — marca para borradores privados.

Motivación
- `usage_count` acelera el filtrado/ordenamiento por popularidad; `is_draft` permite gestión de borradores sin exponerlos públicamente.

Impacto / Consideraciones
- Aumenta la carga en operaciones de escritura si se actualiza en cada uso (consistencia y concurrencia).
- Alternativa: mantener métricas en `question_metrics` (entry A) y gestionar borradores vía `workspaces` o visibilidad en la aplicación.

Dependencias
- Decisión sobre cuándo y cómo actualizar el contador (sincronous vs event-driven).

Estado: Pendiente — Prioridad: Media/Baja

Criterios de aceptación
- Las consultas que usan `usage_count` muestran resultados consistentes con la derivación por agregación en un entorno de prueba.

---

## 6) F — Funciones/Procedimientos en DB para transiciones de estado

Resumen
- Implementar funciones PL/pgSQL que encapsulen las reglas de negocio para `retirar` y `reactivar` ítems (validación de permisos, actualización de campos de auditoría, registro en audit_logs).

Motivación
- Centralizar la lógica crítica en la BD garantiza consistencia, evita duplicación de reglas en múltiples servicios y protege integridad ante múltiples clientes.

Impacto / Consideraciones
- Requiere definir la manera de validar el usuario actual en la sesión DB (p. ej. `SET LOCAL app.current_user_id`).
- Debe complementarse con tests y control de permisos en la capa de aplicación.

Dependencias
- `questions` y tabla de auditoría (`audit_logs` o `question_state_changes`).

Estado: Pendiente — Prioridad: Media

Criterios de aceptación
- Las funciones validan permisos, actualizan campos de auditoría y no permiten violar constraints (p. ej. reactivar ítem ya activo devuelve error 409 lógico).

---

## 7) G — Tabla `question_state_changes` (registro de motivos y cambios de estado)

Resumen
- Crear `question_state_changes` para registrar cada cambio de estado con `reason TEXT`, `user_id`, `created_at`, `from_state`, `to_state`.

Motivación
- Permitir almacenar el "motivo" de reactivaciones o retiros sin modificar la tabla `questions` y mejorar trazabilidad.

Impacto / Consideraciones
- Complementa la auditoría soft; debe integrarse con triggers o llamadas desde las funciones de transición.

Dependencias
- `questions`, `users`.

Estado: Pendiente — Prioridad: Media

Criterios de aceptación
- Cada cambio de estado crea una fila en `question_state_changes` con motivo y usuario.

---

## 8) H — `DESIGN-DECISIONS.md` consolidado para S-BP-04

Resumen
- Crear un documento `DESIGN-DECISIONS.md` en `use-cases/S-BP/S-BP-04/` que consolide las decisiones de diseño (p. ej. descarga como formato oficial, no persistir workspace por ahora, política de intentos para métricas, uso de materialized views cuando sea necesario).

Motivación
- Facilitar el handoff entre producto y desarrollo, y dejar un rastro claro de por qué se tomó cada decisión.

Impacto / Consideraciones
- Documento de solo lectura para referencia; debe actualizarse cuando se modifiquen decisiones.

Estado: Pendiente — Prioridad: Baja

Criterios de aceptación
- Contiene las decisiones clave y enlaces a CUs y anexos técnicos.

---

## 9) I — CU para Gestión de Evaluaciones: contrato de import (formalizar)

Resumen
- Redactar un CU mínimo en el módulo de Gestión de Evaluaciones que formalice el contrato de import (p.ej. `POST /evaluation-composer/import` que acepte `QuestionExport[]` o el JSON descargado desde el Banco).

Motivación
- Mantener contrato claro entre módulos y facilitar la integración cuando llegue el momento.

Impacto / Consideraciones
- Requiere coordinación con el equipo responsable de Evaluaciones y definir políticas de validación y permisos.

Estado: Pendiente — Prioridad: Baja

Criterios de aceptación
- CU documentado en el módulo de Evaluaciones y con el contrato de ejemplo incluido.

---

## 10) J — Sweep de consistencia en repositorio

Resumen
- Ejecutar una revisión (sweep) en todo el repositorio para localizar referencias técnicas dispersas (nombres de columnas, SQL en secciones de usuario) y alinear la documentación para que detalles técnicos queden solo en anexos.

Motivación
- Evitar contradicciones y asegurar que la documentación para usuarios no técnicos no contenga referencias técnicas.

Impacto / Consideraciones
- Trabajo de escritura; no modifica código, solo documentación.

Estado: Pendiente — Prioridad: Baja

Criterios de aceptación
- Reporte con archivos modificados y cambios aplicados para homogeneizar el lenguaje.

---

## 11) K — Ejemplo de `export-service` (propuesta de carpeta `tools/export-service`)

Resumen
- Mantener como propuesta el ejemplo de servicio (Node.js/Express) que implemente `POST /export` y `GET /questions/batch` para permitir descargar JSON/CSV desde la selección del Banco.

Motivación
- Proveer un patrón de referencia y un ejemplo runnable para equipos que implementen la exportación.

Impacto / Consideraciones
- Si se implementa, incluir `package.json`, tests y README; respetar política de seguridad y jobs asíncronos.

Estado: Pendiente — Prioridad: Baja

Criterios de aceptación
- Repo ejemplo creado con scripts `npm start` y `npm test` que demuestren la generación básica del JSON/CSV.

---

## H1) DESIGN-DECISIONS (consolidado) — S-BP-04 / S-BP-05

Resumen
- Consolidación de decisiones de diseño adoptadas durante el refinamiento de los CUs del Banco de Preguntas (S-BP-04 Buscar/Seleccionar y S-BP-05 Trazabilidad). Este bloque actúa como registro de decisiones tomadas en esta fase y referencia para implementación.

Decisiones acordadas (estado: acordado / recomendación)

1. Formato de exportación por defecto
   - Decisión: **JSON** como formato recomendado para exportaciones desde el Banco (interoperabilidad). **CSV** opcional para intercambio con hojas de cálculo.
   - Motivo: JSON conserva la estructura de opciones/metadata; CSV es útil para usuarios no técnicos.
   - Referencia: `CU-BP-08` (Anexo Técnico) — esquema `QuestionExport`.

2. Workspace (carpeta temporal)
   - Decisión: No persistir workspaces en el MVP. Mantener workspace en sesión/app-side (memoria/redis). Persistencia en DB (`workspaces`/`workspace_items`) queda como mejora futura (ver `review-items.md` A/B/C).
   - Motivo: reducir DDL y complejidad en la primera iteración; permitir export inmediato mediante download.
   - Referencia: `CU-BP-08` (Flujo) y `review-items.md` (entry A).

3. Métricas y política de intentos
   - Decisión recomendada (por defecto): Para métricas agregadas contar **el último intento válido** por estudiante por evaluación (si el sistema soporta varios intentos). Si la política local es "un solo intento", usar `attempt_no IS NULL`.
   - Motivo: evitar sesgos por múltiples intentos y ofrecer métricas pedagógicamente útiles.
   - Referencia: `CU-BP-09` / `CU-BP-10` (Anexos técnicos con ejemplos SQL).

4. Precomputación de métricas
   - Decisión: Implementación de `question_metrics` como materialized view o tabla precomputada queda recomendada para producción, pero **no** en MVP. Se planifica como tarea posterior (entry A en `review-items.md`).
   - Motivo: rendimiento y experiencia de usuario en dashboards.

5. Etiquetas y metadata adicional
   - Decisión: `tags` y `question_tags` son deseables pero no obligatorias en MVP; planificar su DDL e UI en una iteración posterior (entry D en `review-items.md`).

6. Auditoría de exportes y trazabilidad de reportes
   - Decisión: Registrar generación/descarga de reportes en `reports` / `audit_logs` (entry B). Política de expiración de enlaces y control de acceso obligatorio.

7. Seguridad y privacidad
   - Regla fija: Los reportes y vistas de trazabilidad deben exponer únicamente datos agregados. NUNCA incluir `student_id` o `identifier` en exportes ni en UI de trazabilidad.
   - Incluir control de accesos por rol (Coordinator/Admin) y auditoría de quien genera/exporta.

8. Implementación técnica de retiradas/reactivaciones
   - Recomendación: Encapsular la lógica crítica en funciones PL/pgSQL (entry F) y registrar motivos en `question_state_changes` (entry G) cuando se implemente la persistencia de motivos.

9. Contrato entre módulos (Banco ↔ Evaluaciones)
   - Recomendación: Documentar y acordar un endpoint de import (por ejemplo `POST /evaluation-composer/import`) en el módulo de Evaluaciones; documentarlo como CU mínimo cuando se programe la integración (entry I).

Acciones siguientes (para backlog)
- Registrar las entradas A..K de `review-items.md` en el backlog con prioridad y responsable. Esta sección sirve como resumen ejecutivo de decisiones para el equipo técnico.

Referencias cruzadas
- `use-cases/S-BP/S-BP-04/CU-BP-07.md` (Buscar ítems)
- `use-cases/S-BP/S-BP-04/CU-BP-08.md` (Seleccionar ítems)
- `use-cases/S-BP/S-BP-05/CU-BP-09.md` (Consultar trazabilidad)
- `use-cases/S-BP/S-BP-05/CU-BP-10.md` (Generar reporte)

---

## Proceso de revisión y responsable propuesto
- Propuesta: mantener este archivo como la lista oficial de "ideas pendientes" dentro de `04-design-and-process`.
- Responsable inicial (sugerido): Coordinador Técnico / Product Owner del módulo de Banco de Preguntas.
- Próximo paso sugerido: incorporar estas entradas en el backlog del producto y priorizarlas con el equipo de infraestructura/DB.

---

## Historial
- 2025-10-06: Creado a partir del refinamiento de CUs S-BP-04 y S-BP-05; incluye A/B/C discutidos en sesión.

[Volver al índice](README.md)
