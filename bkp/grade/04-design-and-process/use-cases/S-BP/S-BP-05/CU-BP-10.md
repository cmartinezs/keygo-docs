# CU-BP-10 — Generar reporte de trazabilidad

> Este caso de uso detalla la generación de un reporte descargable con la trazabilidad de un ítem, basado en el escenario S-BP-05 | Ver trazabilidad de uso del ítem.

- [Revisión](reviews.md)
- [Volver](../../README.md#1-banco-de-preguntas)

<!-- TOC -->
* [CU-BP-10 — Generar reporte de trazabilidad](#cu-bp-10--generar-reporte-de-trazabilidad)
  * [Escenario origen: S-BP-05 | Ver trazabilidad de uso del ítem](#escenario-origen-s-bp-05--ver-trazabilidad-de-uso-del-ítem)
    * [RF relacionados: RF10](#rf-relacionados-rf10)
    * [Objetivo](#objetivo)
    * [Precondiciones](#precondiciones)
    * [Postcondiciones](#postcondiciones)
    * [Flujo principal (éxito)](#flujo-principal-éxito)
    * [Flujos alternativos / Excepciones](#flujos-alternativos--excepciones)
    * [Reglas de negocio](#reglas-de-negocio)
    * [Datos principales](#datos-principales)
    * [Consideraciones de seguridad/permiso](#consideraciones-de-seguridadpermiso)
    * [No funcionales](#no-funcionales)
    * [Criterios de aceptación (QA)](#criterios-de-aceptación-qa)
  * [Anexo Técnico (para desarrollo)](#anexo-técnico-para-desarrollo)
    * [Tablas relevantes](#tablas-relevantes)
    * [Consideraciones de política](#consideraciones-de-política)
    * [Ejemplo: consulta SQL para fila del CSV por evaluación](#ejemplo-consulta-sql-para-fila-del-csv-por-evaluación)
    * [Generación del CSV](#generación-del-csv)
    * [Generación de PDF](#generación-de-pdf)
    * [Seguridad y privacidad](#seguridad-y-privacidad)
    * [Rendimiento y mantenimiento](#rendimiento-y-mantenimiento)
    * [Ejemplo de proceso asíncrono (pseudo)](#ejemplo-de-proceso-asíncrono-pseudo)
    * [Referencias](#referencias)
<!-- TOC -->

## Escenario origen: S-BP-05 | Ver trazabilidad de uso del ítem

### RF relacionados: RF10

**Actor principal:** Coordinador / Administrador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un usuario genere un reporte descargable de la trazabilidad de un ítem en formatos estándar (CSV, PDF), para fines de análisis pedagógico y auditoría.

### Precondiciones
- Usuario autenticado con permisos de consulta avanzada.
- Ítem seleccionado con historial de uso disponible.

### Postcondiciones
- Se genera un archivo con el historial de uso y métricas del ítem.
- El archivo queda disponible para descarga o consulta en línea.

### Flujo principal (éxito)
1. El Coordinador visualiza la trazabilidad de un ítem.
2. Selecciona la opción **“Generar reporte”**.
3. El Sistema prepara el archivo con:
    - Evaluaciones asociadas.
    - Cantidad de estudiantes que respondieron.
    - Tasa de acierto promedio.
    - Fecha de última utilización.
4. El Sistema ofrece la descarga del archivo en formato elegido (CSV o PDF).
5. El Coordinador descarga el reporte.

### Flujos alternativos / Excepciones
- **A1 — Ítem sin historial:** El Sistema no permite generar reporte y muestra mensaje.
- **A2 — Error en generación:** El Sistema informa y permite reintentar.

### Reglas de negocio
- **RN-1:** El reporte debe contener únicamente datos agregados, nunca información individualizada de estudiantes.
- **RN-2:** El reporte debe incluir fecha y usuario que lo generó.

### Datos principales
- **Reporte de trazabilidad**(ítem, evaluaciones asociadas, métricas de desempeño, fecha de generación, usuario solicitante).

### Consideraciones de seguridad/permiso
- Los reportes generados deben estar protegidos y visibles solo para el usuario solicitante, salvo que se comparta con otros roles autorizados.

### No funcionales
- **Rendimiento:** generación de reporte < 5s p95.
- **Portabilidad:** formatos de exportación estándar (CSV, PDF).
- **Seguridad:** los archivos deben expirar o tener control de acceso.

### Criterios de aceptación (QA)
- **CA-1:** Al generar reporte de un ítem con historial, el archivo incluye todas las evaluaciones asociadas y métricas.
- **CA-2:** Para ítems sin uso, el sistema bloquea la generación de reporte.
- **CA-3:** El reporte incluye fecha y usuario solicitante.
- **CA-4:** El archivo es descargable en CSV y PDF.  

---

## Anexo Técnico (para desarrollo)

> Mapeo al modelo de datos y ejemplo de implementación para la generación de reportes de trazabilidad (basado en el DDL de Grading Management y Question Bank).

### Tablas relevantes
- `questions` (Question Bank) — ítem origen.
- `evaluation_questions` — mapea `evaluation` ↔ `questions` (contiene `evaluation_question_id`).
- `evaluations` — metadatos de la evaluación (title, scheduled_date, state, course_fk).
- `student_evaluations` — rendiciones por estudiante (contiene `taken_on`, `total_score`, `student_fk`).
- `student_answers` — respuestas por pregunta dentro de una rendición.
- `student_answer_options` y `evaluation_options` — permiten determinar si una respuesta fue correcta.

> Nota: el modelo no contiene métricas precomputadas; el reporte debe generarlas por agregación o usar una vista/materialized view o tabla de métricas precomputada (`question_metrics`).

### Consideraciones de política
- Definir si se cuentan todos los intentos o solo uno (el más reciente o `attempt_no IS NULL`). El DDL actual tiene un índice que contempla el caso de un único intento.
- Incluir/excluir evaluaciones según estado (por ejemplo `Applied`, `Graded`, `Archived`) y según `deleted_at`.

### Ejemplo: consulta SQL para fila del CSV por evaluación
```text
-- Cabecera esperada por fila: evaluation_id,title,scheduled_date,course_name,total_responses,correct_responses,accuracy,last_taken_on
SELECT
  e.evaluation_id,
  e.title,
  e.scheduled_date,
  c.name AS course_name,
  COALESCE(COUNT(sa.student_answer_id),0) AS total_responses,
  COALESCE(SUM(CASE WHEN eo.is_correct THEN 1 ELSE 0 END),0) AS correct_responses,
  CASE WHEN COUNT(sa.student_answer_id)=0 THEN NULL
       ELSE SUM(CASE WHEN eo.is_correct THEN 1 ELSE 0 END)::numeric / COUNT(sa.student_answer_id)
  END AS accuracy,
  MAX(se.taken_on) AS last_taken_on
FROM evaluation_questions eq
JOIN evaluations e ON eq.evaluation_fk = e.evaluation_id
JOIN courses c ON e.course_fk = c.course_id
LEFT JOIN student_answers sa ON sa.evaluation_question_fk = eq.evaluation_question_id
LEFT JOIN student_answer_options sao ON sao.student_answer_fk = sa.student_answer_id
LEFT JOIN evaluation_options eo ON eo.evaluation_option_id = sao.evaluation_option_fk
LEFT JOIN student_evaluations se ON sa.student_evaluation_fk = se.student_evaluation_id
WHERE eq.question_fk = :question_id
  AND (e.deleted_at IS NULL)
  -- AND e.state IN ('Applied','Graded','Archived')  -- aplicar según política
GROUP BY e.evaluation_id, e.title, e.scheduled_date, c.name
ORDER BY e.scheduled_date DESC;
```

### Generación del CSV
- Para sets pequeños, ejecutar la consulta y stream el resultado como CSV (server-side streaming). Establecer `Content-Disposition` y `Content-Type` apropiados.
- Para sets grandes, crear job en background:
  1. Crear job que ejecuta la consulta y escribe el CSV en object storage (S3/GCS) o en filesystem accesible.
  2. Notificar al usuario (UI notificación o email) con enlace temporal para descarga.
  3. Mantener logs/auditoría del job (quién solicitó, cuándo, filtros usados).

### Generación de PDF
- Transformar el CSV o la estructura agregada a PDF mediante una librería de reportes (p.ej. wkhtmltopdf, Puppeteer, ReportLab) y aplicar template institucional.
- Para grandes reportes, generar asíncronamente y almacenar el PDF en object storage con control de acceso.

### Seguridad y privacidad
- El contenido del reporte debe contener sólo datos agregados; excluir `student_id`, `identifier`, o cualquier campo que identifique alumnos.
- Registrar en auditoría quién generó el reporte y cuándo (`reports` table o `audit_logs`).
- Controlar acceso a archivos generados mediante tokens temporales y expiración automática.

### Rendimiento y mantenimiento
- Consultas pueden ser costosas si el historial es grande; se recomienda:
  - Índices: `idx_evaluation_questions_question_fk`, `idx_student_answers_evaluation_question_fk`, `idx_student_evaluations_evaluation_fk`.
  - Vistas/materialized views para métricas precomputadas y un job nightly para refresh.
  - Tabla `question_metrics` para lecturas rápidas en dashboards (actualizada por batch jobs).

### Ejemplo de proceso asíncrono (pseudo)
```text
1. Usuario solicita /questions/:id/report?format=csv
2. API crea job en queue con payload { question_id, user_id, format }
3. Worker ejecuta la consulta agregada, escribe CSV en object storage y marca job como ready
4. API notifica al usuario y proporciona URL temporal para descargar
5. El usuario descarga el archivo; el archivo expira según política
```

### Referencias
- `products/grade/06-data-model/grading-management/DDL.sql` (evaluations, evaluation_questions, student_evaluations, student_answers, student_answer_options)
- `products/grade/06-data-model/question-bank/DDL.sql` (questions, question_options)

---

[Subir](#cu-bp-10--generar-reporte-de-trazabilidad)