# CU-IM-04 — Postear resultados de ingesta a calificaciones

- [Revisión](review.md)
- [Volver](../../README.md#3-ingesta-móvil)

## Escenario origen: S-IM-04 | Enviar lote y confirmar recepción

### RF relacionados: RF4, RF8

**Actor principal:** Sistema GRADE (Pipeline de posting)  
**Actores secundarios:** Docente/Asistente de aula, Sistema de calificaciones, Sistema de notificaciones

---

### Objetivo
Transferir automáticamente los resultados procesados desde el sistema de ingesta móvil hacia el sistema de calificaciones, validando identidad de estudiantes, resolviendo anomalías cuando sea posible, y notificando al usuario sobre el progreso y elementos que requieren intervención manual.

### Precondiciones
- Existen resultados de ingesta en estado **Listo** con procesamiento completo.
- Los lotes de ingesta asociados están en estado **Procesando** o **Cerrado**.
- Las evaluaciones están en estado **Aplicada** o **Calificada**.
- Los estudiantes están matriculados en los cursos correspondientes.
- El sistema de calificaciones está operativo y accesible.

### Postcondiciones
- Resultados válidos se transfieren exitosamente a respuestas de estudiantes y opciones de respuesta.
- Los resultados de ingesta cambian a estado **Posteado** con timestamp de posting.
- Se crean evaluaciones de estudiante si no existen previamente.
- Las anomalías no resueltas quedan documentadas para intervención manual.
- El usuario recibe notificación detallada del proceso y resultados.

### Flujo principal (éxito)
1. **Inicio del proceso:** El sistema toma resultados de ingesta en estado **Listo**
2. **Validación de precondiciones:**
   - Verifica que la evaluación esté en estado válido para recibir respuestas
   - Confirma que el lote esté en estado **Procesando** o **Cerrado**
   - Valida disponibilidad del sistema de calificaciones
3. **Resolución de identidad estudiantil:**
   - Si hay estudiante resuelto, valida matriculación en el curso
   - Si no hay identidad resuelta, intenta resolver por:
     - Patrones de QR válidos en páginas QR
     - Algoritmos de matching por características de escritura
     - Base de datos de estudiantes matriculados
4. **Creación/validación de evaluación de estudiante:**
   - Busca evaluación de estudiante existente para la evaluación/estudiante
   - Si no existe, crea nuevo registro:
     - Evaluación y estudiante del resultado procesado
     - Puntaje total inicial en cero (se calculará al final)
     - Estado **En Progreso** o según configuración
5. **Transferencia de respuestas:**
   - Por cada mapeo de reconocimiento con confianza mayor o igual al umbral:
     - Crea respuesta de estudiante asociada a pregunta de evaluación
     - Calcula puntos obtenidos según puntaje de opciones de evaluación
     - Crea opciones de respuesta de estudiante para opciones marcadas
6. **Manejo de anomalías:**
   - **Múltiples respuestas:** Aplica regla configurada (anular pregunta, tomar primera, etc.)
   - **Respuestas ambiguas:** Marca para revisión manual si confianza por debajo del umbral
   - **Estudiante no identificado:** Mantiene resultado en estado pendiente
7. **Cálculo de puntajes:**
   - Suma puntos obtenidos de todas las respuestas del estudiante
   - Actualiza puntaje total de evaluación de estudiante
   - Aplica escala de calificación si está configurada
8. **Finalización exitosa:**
   - Actualiza estado de resultado de ingesta a **Posteado**
   - Registra fecha y hora de posting
   - Actualiza contadores de progreso en el lote
   - Notifica al usuario sobre resultados exitosos
9. **Consolidación del lote:**
   - Si todos los resultados de ingesta del lote están **Posteados**, cierra el lote
   - Genera reporte final con estadísticas de procesamiento

### Flujos alternativos / Excepciones
- **A1 — Estudiante no matriculado:**
  - Marca resultado de ingesta con anomalía "student_not_enrolled"
  - No postea respuestas, mantiene para resolución manual
  - Notifica al docente para verificar matriculación
- **A2 — Evaluación en estado incompatible:**
  - Si evaluación está **Archived** o **Draft**, rechaza posting
  - Notifica error específico al usuario
  - Mantiene resultado de ingesta en estado **Listo** para retry
- **A3 — Duplicado de respuestas:**
  - Detecta respuesta de estudiante existente para la misma pregunta
  - Aplica política configurada:
    - **Sobrescribir**: Reemplaza respuesta existente
    - **Mantener original**: Descarta nueva respuesta
    - **Marcar conflicto**: Escala para resolución manual
- **A4 — Error de integridad referencial:**
  - Si pregunta de evaluación o opción de evaluación no existen
  - Marca como anomalía técnica y escala a soporte
  - No interrumpe procesamiento de otros resultados
- **A5 — Sistema de calificaciones no disponible:**
  - Mantiene resultados de ingesta en cola con retry programado
  - Notifica al administrador sobre problema de integración
  - Reintenta automáticamente según configuración
- **A6 — Anomalías múltiples por resultado:**
  - Procesa lo que sea posible y documenta todos los problemas
  - Genera reporte detallado para revisión manual
  - Postea respuestas válidas, mantiene problemáticas pendientes
- **A7 — Timeout de procesamiento:**
  - Para lotes muy grandes, procesa en partes
  - Mantiene progreso parcial y continúa desde donde quedó
  - Si persiste timeout, escala para revisión de capacidad del sistema

### Reglas de negocio
- **RN-1:** Solo resultados de ingesta en estado **Ready** pueden ser posteados.
- **RN-2:** El estudiante debe estar matriculado en el curso de la evaluación.
- **RN-3:** La evaluación debe estar en estado **Applied** o **Graded** para recibir respuestas.
- **RN-4:** Solo mapeos con confianza >= 0.8 se postean automáticamente.
- **RN-5:** Si existe respuesta previa del estudiante, aplica política de duplicados configurada.
- **RN-6:** El puntaje total se calcula sumando puntos de todas las respuestas válidas.
- **RN-7:** Anomalías no críticas no bloquean el posting de respuestas válidas.

### Datos principales
- **Resultado de Ingesta** (identificador, página escaneada, evaluación, estudiante resuelto, total marcadas, anomalías, estado, fecha posting)
- **Evaluación de Estudiante** (identificador, evaluación, estudiante, puntaje total, estado, fecha inicio, fecha finalización)
- **Respuesta de Estudiante** (identificador, evaluación estudiante, pregunta evaluación, puntos obtenidos, fecha respuesta)
- **Opción Respuesta de Estudiante** (identificador, respuesta estudiante, opción evaluación, seleccionada)
- **Mapeo de Reconocimiento** (identificador, página, burbuja, pregunta evaluación, opción evaluación, confianza)
- **Log de Posting** (identificador, resultado ingesta, timestamp, acción, resultado, detalles)

### Consideraciones de seguridad/permiso
- **Integridad transaccional:** Todas las operaciones de posting en transacciones atómicas.
- **Validación de permisos:** Solo docentes/coordinadores del curso pueden visualizar resultados.
- **Auditoría completa:** Registro detallado de todas las transferencias y modificaciones.
- **Rollback:** Capacidad de revertir posting completo si se detectan problemas.
- **Encriptación:** Datos de estudiantes encriptados durante transferencia.

### No funcionales
- **Rendimiento:** 
  - Posting completo de lote < 2 minutos p95
  - Procesamiento por resultado < 5s p95
- **Confiabilidad:** 
  - Tasa de éxito > 99% para resultados válidos
  - Recuperación automática de fallos transitorios
- **Escalabilidad:** 
  - Procesamiento paralelo de resultados independientes
  - Particionamiento por curso/evaluación
- **Disponibilidad:** 
  - Cola de reintentos para fallos de integración
  - Notificaciones automáticas de estado

### Criterios de aceptación (QA)
- **CA-1:** Un resultado **Ready** con estudiante matriculado debe crear/actualizar `student_evaluation` y `student_answers`.
- **CA-2:** Si el estudiante no está matriculado, debe marcar anomalía sin postear respuestas.
- **CA-3:** Mapeos con confianza >= 0.8 deben crear `student_answer_options` para opciones marcadas.
- **CA-4:** El puntaje total debe calcularse correctamente sumando puntos de todas las respuestas.
- **CA-5:** Duplicados deben manejarse según política configurada (sobrescribir/mantener/conflicto).
- **CA-6:** Anomalías múltiples deben documentarse completamente en `ingest_results.anomalies`.
- **CA-7:** Al completar todos los resultados de un lote, debe cerrar el lote automáticamente.

---

## Anexo Técnico (para desarrollo)

> Esta sección contiene los detalles técnicos de implementación del proceso de posting según el modelo de datos integrado entre Ingesta Móvil y Gestión de Evaluaciones.

### Resumen del modelo de datos

#### Entidades principales involucradas
**Del sistema de Ingesta Móvil:**
- **`ingest_results`**: Resultados consolidados listos para posting con estudiante identificado y anomalías.
- **`recognition_mappings`**: Mapeos de burbujas a opciones de evaluación con niveles de confianza.
- **`ingest_batches`**: Lotes de ingesta que controlan el proceso de posting masivo.

**Del sistema de Gestión de Evaluaciones:**
- **`student_evaluations`**: Evaluaciones de estudiantes (se crean/actualizan durante posting).
- **`student_answers`**: Respuestas individuales por pregunta con puntajes obtenidos.
- **`student_answer_options`**: Opciones específicas seleccionadas por el estudiante.
- **`evaluations`**, **`evaluation_questions`**, **`evaluation_options`**: Snapshots de evaluación.

#### Relaciones clave
- Los **resultados de ingesta** se convierten en **evaluaciones de estudiante** con múltiples **respuestas**.
- Los **mapeos de reconocimiento** determinan qué **opciones de evaluación** se marcan como seleccionadas.
- La **integridad referencial** se mantiene: `student_answers.evaluation_question_fk → evaluation_questions.evaluation_question_id`.
- El **puntaje total** se calcula agregando `student_answers.points_earned` de todas las respuestas.

#### Campos críticos para este caso de uso
**En `ingest_results`:**
- `resolved_student_fk` (null si no se pudo identificar), `state` ('Ready' → 'Posted')
- `total_marked` (total de burbujas), `anomalies` (JSONB con problemas detectados)
- `posted_at` (timestamp del posting exitoso)

**En `student_evaluations`:**
- `evaluation_fk`, `student_fk` (claves foráneas), `total_score` (calculado automáticamente)
- `state` ('InProgress', 'Submitted', 'Graded'), `started_at`, `finished_at`

**En `recognition_mappings`:**
- `confidence` (umbral 0.8), `evaluation_question_fk`, `evaluation_option_fk`
- Solo mapeos con confianza >= 0.8 se procesan automáticamente

#### Auditoría en Posting
El proceso de posting mantiene **trazabilidad completa** con timestamps de transferencia y logs detallados de cada operación realizada.

### Validaciones implementadas en base de datos

**Verificar resultados listos para posting:**
```sql
SELECT ir.ingest_result_id, ir.evaluation_fk, ir.resolved_student_fk, 
       ir.total_marked, ir.anomalies
FROM ingest_results ir
JOIN ingest_batches ib ON ir.scanned_page_fk IN (
    SELECT sp.scanned_page_id 
    FROM scanned_pages sp 
    WHERE sp.ingest_batch_fk = ib.ingest_batch_id
)
WHERE ir.state = 'Ready'
AND ir.resolved_student_fk IS NOT NULL
AND ib.state IN ('Processing', 'Closed')
ORDER BY ir.ingest_result_id;
```

**Validar matriculación del estudiante:**
```sql
SELECT s.student_id, s.identifier, e.evaluation_id, c.course_id
FROM students s
JOIN enrollments en ON s.student_id = en.student_fk
JOIN courses c ON en.course_fk = c.course_id
JOIN evaluations e ON c.course_id = e.course_fk
WHERE s.student_id = :student_id
AND e.evaluation_id = :evaluation_id
AND en.active = true;
```

**Verificar duplicados de respuestas:**
```sql
SELECT sa.student_answer_id, sa.points_earned
FROM student_answers sa
JOIN student_evaluations se ON sa.student_evaluation_fk = se.student_evaluation_id
WHERE se.evaluation_fk = :evaluation_id
AND se.student_fk = :student_id
AND sa.evaluation_question_fk = :question_id;
```

### Ejemplo de implementación del proceso completo

```sql
-- PASO 1: Crear/obtener evaluación de estudiante
INSERT INTO student_evaluations (
    evaluation_fk, student_fk, total_score, state, started_at
) VALUES (
    :evaluation_id, :student_id, 0, 'InProgress', NOW()
)
ON CONFLICT (evaluation_fk, student_fk) 
DO UPDATE SET state = 'InProgress'
RETURNING student_evaluation_id;

-- PASO 2: Procesar cada mapeo con confianza suficiente
WITH high_confidence_mappings AS (
    SELECT rm.evaluation_question_fk, rm.evaluation_option_fk, 
           eo.score, rm.confidence
    FROM recognition_mappings rm
    JOIN ingest_results ir ON rm.scanned_page_fk = ir.scanned_page_fk
    JOIN evaluation_options eo ON rm.evaluation_option_fk = eo.evaluation_option_id
    WHERE ir.ingest_result_id = :result_id
    AND rm.confidence >= 0.8
)
-- Crear respuestas de estudiante
INSERT INTO student_answers (
    student_evaluation_fk, evaluation_question_fk, 
    points_earned, answered_at
)
SELECT 
    :student_evaluation_id, 
    hcm.evaluation_question_fk,
    COALESCE(SUM(hcm.score), 0),  -- suma por pregunta en caso de múltiple selección
    NOW()
FROM high_confidence_mappings hcm
GROUP BY hcm.evaluation_question_fk
ON CONFLICT (student_evaluation_fk, evaluation_question_fk)
DO UPDATE SET 
    points_earned = EXCLUDED.points_earned,
    answered_at = EXCLUDED.answered_at
RETURNING student_answer_id, evaluation_question_fk, points_earned;

-- PASO 3: Crear opciones de respuesta de estudiante
INSERT INTO student_answer_options (
    student_answer_fk, evaluation_option_fk, selected
)
SELECT sa.student_answer_id, hcm.evaluation_option_fk, true
FROM student_answers sa
JOIN high_confidence_mappings hcm ON sa.evaluation_question_fk = hcm.evaluation_question_fk
WHERE sa.student_evaluation_fk = :student_evaluation_id;

-- PASO 4: Actualizar puntaje total
UPDATE student_evaluations 
SET 
    total_score = (
        SELECT COALESCE(SUM(sa.points_earned), 0)
        FROM student_answers sa
        WHERE sa.student_evaluation_fk = :student_evaluation_id
    ),
    finished_at = NOW(),
    state = 'Submitted'
WHERE student_evaluation_id = :student_evaluation_id;

-- PASO 5: Marcar resultado como posteado
UPDATE ingest_results 
SET 
    state = 'Posted',
    posted_at = NOW()
WHERE ingest_result_id = :result_id;
```

### Manejo de anomalías durante posting

**Resolución de estudiante no identificado:**
```sql
-- Intentar resolver por patrones de QR
UPDATE ingest_results ir
SET resolved_student_fk = (
    SELECT s.student_id
    FROM page_qrs pqr
    JOIN scanned_pages sp ON pqr.scanned_page_fk = sp.scanned_page_id
    JOIN students s ON s.identifier = pqr.student_identifier
    JOIN enrollments e ON s.student_id = e.student_fk
    WHERE sp.scanned_page_id = ir.scanned_page_fk
    AND pqr.verified = true
    AND e.course_fk = (SELECT course_fk FROM evaluations WHERE evaluation_id = ir.evaluation_fk)
    AND e.active = true
    LIMIT 1
)
WHERE ir.resolved_student_fk IS NULL
AND ir.state = 'Ready';
```

**Registrar anomalías detalladas:**
```json
// Estructura del campo anomalies en ingest_results
{
  "student_resolution": {
    "status": "unidentified",
    "qr_found": false,
    "attempts": ["qr_decode", "handwriting_match", "manual_lookup"]
  },
  "multiple_marks": [
    {
      "question_id": 123,
      "marked_options": [1, 3],
      "resolution": "took_first",
      "confidence_scores": [0.95, 0.87]
    }
  ],
  "low_confidence_mappings": [
    {
      "bubble_id": 456,
      "question_id": 124,
      "confidence": 0.65,
      "reason": "poor_image_quality"
    }
  ]
}
```

### Políticas de manejo de duplicados

**Configuración por evaluación:**
```sql
-- Tabla de configuración (ejemplo conceptual)
CREATE TABLE evaluation_posting_policies (
    evaluation_id BIGINT REFERENCES evaluations(evaluation_id),
    duplicate_policy VARCHAR(20) CHECK (duplicate_policy IN ('overwrite', 'keep_original', 'manual_review')),
    low_confidence_threshold NUMERIC(3,2) DEFAULT 0.8,
    multiple_marks_policy VARCHAR(20) CHECK (multiple_marks_policy IN ('take_first', 'take_last', 'nullify', 'sum_partial'))
);
```

### Índices recomendados
- `CREATE INDEX idx_ingest_results_state_student ON ingest_results (state, resolved_student_fk);`
- `CREATE INDEX idx_recognition_mappings_confidence ON recognition_mappings (confidence, scanned_page_fk);`
- `CREATE INDEX idx_student_evaluations_eval_student ON student_evaluations (evaluation_fk, student_fk);`
- `CREATE INDEX idx_student_answers_evaluation_question ON student_answers (student_evaluation_fk, evaluation_question_fk);`

### Referencias al modelo completo
Para más detalles sobre la estructura completa, restricciones, tipos de datos y triggers:
- [Modelo Entidad-Relación de Ingesta Móvil](../../../../06-data-model/mobile-ingest/mer.md)
- [Modelo Entidad-Relación de Gestión de Evaluaciones](../../../../06-data-model/grading-management/mer.md)
- [Script DDL de Ingesta Móvil](../../../../06-data-model/mobile-ingest/DDL.sql)
- [Script DDL de Gestión de Evaluaciones](../../../../06-data-model/grading-management/DDL.sql)

---

[Subir](#cu-im-04--postear-resultados-de-ingesta-a-calificaciones)
