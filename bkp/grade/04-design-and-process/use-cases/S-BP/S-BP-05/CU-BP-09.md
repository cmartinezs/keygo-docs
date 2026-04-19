# CU-BP-09 — Consultar trazabilidad de ítem

> Este caso de uso detalla el proceso para que un Coordinador o Administrador pueda consultar la trazabilidad de un ítem en el Banco de preguntas, incluyendo su historial de uso en evaluaciones y métricas de desempeño.

- [Revisión](reviews.md)
- [Volver](../../README.md#1-banco-de-preguntas)

<!-- TOC -->
* [CU-BP-09 — Consultar trazabilidad de ítem](#cu-bp-09--consultar-trazabilidad-de-ítem)
  * [Escenario origen: S-BP-05 | Ver trazabilidad de uso del ítem](#escenario-origen-s-bp-05--ver-trazabilidad-de-uso-del-ítem)
    * [RF relacionados: RF2, RF8, RF10](#rf-relacionados-rf2-rf8-rf10)
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
    * [Tablas relevantes (resumen)](#tablas-relevantes-resumen)
    * [Consideraciones de negocio / reglas en DB](#consideraciones-de-negocio--reglas-en-db)
    * [Ejemplo de consultas](#ejemplo-de-consultas)
    * [Notas operacionales](#notas-operacionales)
    * [Seguridad y privacidad](#seguridad-y-privacidad)
    * [Referencias al modelo completo](#referencias-al-modelo-completo)
<!-- TOC -->

## Escenario origen: S-BP-05 | Ver trazabilidad de uso del ítem

### RF relacionados: RF2, RF8, RF10

**Actor principal:** Coordinador / Administrador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir a un Coordinador o Administrador consultar el historial de uso de un ítem, incluyendo evaluaciones donde fue aplicado, cantidad de respuestas registradas y métricas de desempeño de los estudiantes.

### Precondiciones
- Usuario autenticado con permisos de consulta avanzada.
- Ítem seleccionado existe en el Banco de preguntas.

### Postcondiciones
- El sistema muestra el historial de uso del ítem con evaluaciones asociadas y métricas de desempeño.
- La información queda disponible para análisis pedagógico.

### Flujo principal (éxito)
1. El Coordinador accede al Banco de preguntas y selecciona un ítem.
2. El Coordinador elige la opción **“Ver trazabilidad”**.
3. El Sistema consulta el historial del ítem.
4. El Sistema muestra:
    - Evaluaciones donde fue utilizado.
    - Cantidad de estudiantes que respondieron.
    - Tasa de acierto promedio.
    - Fecha de última utilización.
5. El Coordinador analiza la información.

### Flujos alternativos / Excepciones
- **A1 — Ítem sin historial:** El Sistema informa que el ítem no ha sido utilizado aún.
- **A2 — Datos incompletos:** El Sistema muestra advertencia si no se dispone de todas las métricas (ej.: evaluaciones eliminadas).

### Reglas de negocio
- **RN-1:** La trazabilidad debe incluir todas las evaluaciones en que el ítem fue usado, activas e históricas.
- **RN-2:** Los datos de desempeño deben provenir de fuentes oficiales de resultados.
- **RN-3:** No se deben exponer identificadores de estudiantes, solo métricas agregadas.

### Datos principales
- **Ítem**(ID, estado, enunciado, metadatos).
- **Evaluaciones asociadas**(ID, curso, fecha, cantidad de estudiantes).
- **Métricas de desempeño**(tasa de acierto, discriminación, fecha de última utilización).

### Consideraciones de seguridad/permiso
- Solo Coordinadores o Administradores pueden consultar trazabilidad completa.
- Docentes pueden tener acceso restringido a métricas agregadas de sus propios cursos.

### No funcionales
- **Rendimiento:** consulta de trazabilidad < 3s p95.
- **Usabilidad:** interfaz clara con filtros por fecha, curso o nivel.
- **Disponibilidad:** la información debe estar accesible incluso para evaluaciones históricas cerradas.

### Criterios de aceptación (QA)
- **CA-1:** Al seleccionar un ítem con historial, el sistema muestra lista de evaluaciones con métricas agregadas.
- **CA-2:** Para ítems sin uso, el sistema informa claramente que no existen registros.
- **CA-3:** La tasa de acierto y fecha de última utilización se muestran correctamente.
- **CA-4:** No se exponen datos individuales de estudiantes.

---

## Anexo Técnico (para desarrollo)

> Mapeo al modelo de datos y ejemplo de consultas para calcular trazabilidad y métricas (basado en el DDL de Grading Management).

### Tablas relevantes (resumen)
- `evaluations` — filas de evaluaciones (fecha, estado, curso).
- `evaluation_questions` — composición de una evaluación (relaciona `questions.question_id` con la `evaluation_question_id`).
- `student_evaluations` — rendiciones por estudiante (per-evaluation per-student record, contiene `taken_on`, `total_score`).
- `student_answers` — respuestas por pregunta dentro de una rendición (relaciona a `evaluation_question_id`).
- `student_answer_options` + `evaluation_options` — opciones seleccionadas y si eran correctas (para calcular aciertos en preguntas de opción).

> Observación: el modelo no almacena métricas pre-calculadas (`usage_count`, `tasa_acierto`), por lo que deben derivarse por agregación de las tablas de evaluación/rendición.

### Consideraciones de negocio / reglas en DB
- Definir claramente política de conteo cuando hay múltiples intentos (usar el intento más reciente, contar solo `attempt_no IS NULL`, etc.). El DDL contiene un índice único condicional para el caso de un único intento.
- Incluir evaluaciones históricas (estado `Applied`, `Graded`, `Archived`) según RN-1; decidir si excluir borrados lógicos (`deleted_at IS NOT NULL`).
- Nunca exponer `student_id` o `identifier` en los reportes; solo agregar/contar anónimamente.

### Ejemplo de consultas
A continuación hay ejemplos simplificados. Ajustar filtros (curso, fecha, intentos) según políticas locales.

1) Encontrar evaluaciones donde una pregunta del banco fue usada:
```text
SELECT DISTINCT e.evaluation_id, e.title, e.scheduled_date, e.state
FROM evaluation_questions eq
JOIN evaluations e ON eq.evaluation_fk = e.evaluation_id
WHERE eq.question_fk = :question_id
ORDER BY e.scheduled_date DESC;
```

2) Resumen por evaluación — respuestas y tasa de acierto (por evaluación)
```text
-- Total de respuestas por evaluación
SELECT e.evaluation_id,
       COUNT(sa.student_answer_id) AS total_responses,
       COUNT(DISTINCT sa.student_answer_id) FILTER (
         WHERE EXISTS (
           SELECT 1
           FROM student_answer_options sao
           JOIN evaluation_options eo ON eo.evaluation_option_id = sao.evaluation_option_fk
           WHERE sao.student_answer_fk = sa.student_answer_id
             AND eo.is_correct = TRUE
         )
       ) AS correct_responses
FROM evaluation_questions eq
LEFT JOIN student_answers sa ON sa.evaluation_question_fk = eq.evaluation_question_id
JOIN evaluations e ON eq.evaluation_fk = e.evaluation_id
WHERE eq.question_fk = :question_id
GROUP BY e.evaluation_id;

-- Luego la tasa de acierto por evaluación = correct_responses::numeric / NULLIF(total_responses,0)
```

3) Tasa de acierto agregada y fecha de última utilización (todas las evaluaciones)
```text
WITH per_eval AS (
  SELECT e.evaluation_id,
         COUNT(sa.student_answer_id) AS total_responses,
         COUNT(DISTINCT sa.student_answer_id) FILTER (
           WHERE EXISTS (
             SELECT 1
             FROM student_answer_options sao
             JOIN evaluation_options eo ON eo.evaluation_option_id = sao.evaluation_option_fk
             WHERE sao.student_answer_fk = sa.student_answer_id
               AND eo.is_correct = TRUE
           )
         ) AS correct_responses,
         MAX(se.taken_on) AS last_taken_on
  FROM evaluation_questions eq
  LEFT JOIN student_answers sa ON sa.evaluation_question_fk = eq.evaluation_question_id
  LEFT JOIN student_evaluations se ON sa.student_evaluation_fk = se.student_evaluation_id
  JOIN evaluations e ON eq.evaluation_fk = e.evaluation_id
  WHERE eq.question_fk = :question_id
  GROUP BY e.evaluation_id
)
SELECT SUM(correct_responses)::numeric / NULLIF(SUM(total_responses),0) AS overall_accuracy,
       MAX(last_taken_on) AS last_used_on
FROM per_eval;
```

### Notas operacionales
- Las consultas pueden ser costosas en bancos grandes; crear vistas/materialized views y/o índices sobre `evaluation_questions(question_fk)` y `student_answers(evaluation_question_fk)` ayuda.
- Para rendimiento en dashboards/UX, pre-computar métricas periódicamente (job nightly) en una tabla de `question_metrics` si la operativa lo requiere.
- Consistencia con intentos: si el sistema permite múltiples intentos, decidir si contar todos o solo el último.

### Seguridad y privacidad
- Agregar roles/privilegios a nivel de aplicación y, si es posible, en la BD; restringir quién puede ejecutar consultas de trazabilidad.
- Al exportar reportes, eliminar columnas sensibles y aplicar control de acceso y expiración en enlaces de descarga.

### Referencias al modelo completo
- `products/grade/06-data-model/grading-management/DDL.sql` (evaluations, evaluation_questions, student_evaluations, student_answers, student_answer_options)
- `products/grade/06-data-model/question-bank/DDL.sql` (questions, question_options)

---

[Subir](#cu-bp-09--consultar-trazabilidad-de-ítem)