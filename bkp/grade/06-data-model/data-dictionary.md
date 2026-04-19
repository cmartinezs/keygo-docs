# Diccionario de Datos – Modelo Entidad–Relación (GRADE)

[Volver](README.md)

> Objetivo: Documentar el modelo de datos unificado de GRADE (Banco de Preguntas, Gestión de Evaluaciones e Ingesta Móvil), detallando para cada objeto: nombre, descripción, tipo de datos, tamaño/precisión, valores permitidos, restricciones y nulabilidad, relaciones, unidades de medida y codificación de valores. Se incluyen ejemplos, problemas conocidos y contexto de negocio.

**Convenciones generales**
- Base de datos objetivo: PostgreSQL 14+.
- Nombres: tablas en inglés (plural); PK = $table_id (BIGSERIAL); FK = $table_fk (BIGINT).
- Tipos: TEXT/VARCHAR(n), NUMERIC(p,s), INTEGER, BIGINT, BOOLEAN, DATE, TIMESTAMPTZ, JSONB, CHAR(n).
- Nulabilidad: “Sí” indica que el campo permite NULL; “No” indica obligatorio.
- Restricciones: PK, FK, UNIQUE, CHECK, defauts y triggers relevantes.

**Índice de módulos**
- Banco de Preguntas (QB)
- Gestión de Evaluaciones (GE)
- Ingesta Móvil (IM)
- Codificación y unidades comunes
- Problemas conocidos y consideraciones de calidad de datos
- Contexto de negocio y sensibilidad

---

## Banco de Preguntas (QB)

### Tabla: users — Autores y administradores
Descripción: Personas con acceso que crean y mantienen preguntas (trazabilidad de autoría).

| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| user_id | BIGSERIAL | 64 bits | No | auto | Identificador del usuario | PK | — |
| name | TEXT | — | No | — | Nombre completo | — | — |
| email | TEXT | — | No | — | Correo electrónico | UNIQUE | formato email app-level |
| role | TEXT | — | No | — | Rol de usuario | — | p.ej., Teacher/Coordinator/Admin |
| created_at | TIMESTAMPTZ | — | No | now() | Marca de creación | — | UTC |

### Tabla: subjects — Asignaturas
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| subject_id | BIGSERIAL | 64 bits | No | auto | Identificador de asignatura | PK | — |
| name | TEXT | — | No | — | Nombre | — | — |
| code | VARCHAR | 64 | No | — | Código único | UNIQUE | Alfanumérico institucional |
| active | BOOLEAN | — | No | TRUE | Vigencia | — | TRUE/FALSE |

### Tabla: units — Unidades
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| unit_id | BIGSERIAL | — | No | auto | Identificador de unidad | PK | — |
| name | TEXT | — | No | — | Nombre de unidad | UNIQUE (subject_fk, name) | — |
| subject_fk | BIGINT | — | No | — | Asignatura | FK → subjects.subject_id | — |
| active | BOOLEAN | — | No | TRUE | Vigencia | — | TRUE/FALSE |

### Tabla: topics — Tópicos
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| topic_id | BIGSERIAL | — | No | auto | Identificador de tópico | PK | — |
| name | TEXT | — | No | — | Nombre del tópico | UNIQUE (unit_fk, name) | — |
| unit_fk | BIGINT | — | No | — | Unidad | FK → units.unit_id | — |
| active | BOOLEAN | — | No | TRUE | Vigencia | — | TRUE/FALSE |

### Tabla: question_types — Tipos de pregunta
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| question_type_id | BIGSERIAL | — | No | auto | Identificador del tipo | PK | — |
| code | VARCHAR | 8 | No | — | Código corto | UNIQUE | TF, SC, MC |
| name | VARCHAR | 64 | No | — | Descripción | — | True/False, Single Choice, Multiple Choice |

### Tabla: difficulties — Dificultades
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| difficulty_id | BIGSERIAL | — | No | auto | Identificador | PK | — |
| level | VARCHAR | 32 | No | — | Nivel textual | UNIQUE | Easy/Medium/Hard u ordinal |
| weight | INTEGER | — | Sí | — | Peso relativo | CHECK (weight >= 0 OR NULL) | 0..n |

### Tabla: outcomes — Resultados de aprendizaje
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| outcome_id | BIGSERIAL | — | No | auto | Identificador | PK | — |
| code | VARCHAR | 64 | No | — | Código único | UNIQUE | p.ej., LO-SCI-5.2 |
| description | TEXT | — | No | — | Descripción | — | — |
| subject_fk | BIGINT | — | Sí | — | Asignatura (opcional) | FK → subjects.subject_id | — |

### Tabla: questions — Preguntas (ítems)
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| question_id | BIGSERIAL | — | No | auto | Identificador de la pregunta | PK | — |
| text | TEXT | — | No | — | Enunciado | — | — |
| active | BOOLEAN | — | No | TRUE | Vigencia | — | TRUE/FALSE |
| version | INTEGER | — | No | 1 | Versión del ítem | CHECK (version >= 1) | 1..n |
| original_question_fk | BIGINT | — | Sí | — | Referencia a versión raíz | FK → questions.question_id | — |
| topic_fk | BIGINT | — | No | — | Tópico | FK → topics.topic_id | — |
| difficulty_fk | BIGINT | — | No | — | Dificultad | FK → difficulties.difficulty_id | — |
| outcome_fk | BIGINT | — | Sí | — | Outcome asociado | FK → outcomes.outcome_id | — |
| question_type_fk | BIGINT | — | No | — | Tipo de pregunta | FK → question_types.question_type_id | — |
| user_fk | BIGINT | — | No | — | Autor | FK → users.user_id | — |
| created_at | TIMESTAMPTZ | — | No | now() | Fecha de creación | — | UTC |

### Tabla: question_options — Alternativas por pregunta
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| question_option_id | BIGSERIAL | — | No | auto | Identificador de opción | PK | — |
| text | TEXT | — | No | — | Texto/etiqueta | UNIQUE (question_fk, text) | — |
| is_correct | BOOLEAN | — | No | FALSE | Marca de correcta | — | TRUE/FALSE |
| position | INTEGER | — | No | — | Orden visual 1..n | CHECK (position >= 1), UNIQUE (question_fk, position) | 1..n |
| score | NUMERIC | (6,3) | Sí | — | Crédito parcial | CHECK (score >= 0 OR NULL) | 0..n |
| question_fk | BIGINT | — | No | — | Pregunta | FK → questions.question_id ON DELETE CASCADE | — |

Relaciones clave (QB)
- units.subject_fk → subjects.subject_id
- topics.unit_fk → units.unit_id
- questions.topic_fk → topics.topic_id; questions.question_type_fk → question_types.question_type_id
- question_options.question_fk → questions.question_id

Ejemplo (QB)
- Pregunta SC: 4 opciones, 1 correcta (is_correct = TRUE). TF: 2 opciones (True, False), 1 correcta.

---

## Gestión de Evaluaciones (GE)

### Tabla: users, students, courses, course_students
Se reutilizan users de QB. A continuación, tablas específicas:

### Tabla: students — Estudiantes
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| student_id | BIGSERIAL | — | No | auto | Identificador del estudiante | PK | — |
| first_name | TEXT | — | No | — | Nombres | — | — |
| last_name | TEXT | — | No | — | Apellidos | — | — |
| identifier | VARCHAR | 64 | No | — | Identificador institucional | UNIQUE | p.ej., RUT/legajo |

### Tabla: courses — Cursos/Secciones
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| course_id | BIGSERIAL | — | No | auto | Identificador del curso | PK | — |
| name | TEXT | — | No | — | Nombre del curso | — | — |
| code | VARCHAR | 64 | No | — | Código institucional | UNIQUE | — |
| user_fk | BIGINT | — | No | — | Docente responsable | FK → users.user_id | — |

### Tabla: course_students — Matrícula
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| course_student_id | BIGSERIAL | — | No | auto | Identificador de matrícula | PK | — |
| course_fk | BIGINT | — | No | — | Curso | FK → courses.course_id | UNIQUE (course_fk, student_fk) |
| student_fk | BIGINT | — | No | — | Estudiante | FK → students.student_id | UNIQUE (course_fk, student_fk) |
| enrolled_on | DATE | — | No | CURRENT_DATE | Fecha de inscripción | — | formato ISO |

### Tabla: evaluations — Evaluaciones
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| evaluation_id | BIGSERIAL | — | No | auto | Identificador | PK | — |
| title | TEXT | — | No | — | Título | — | — |
| scheduled_date | DATE | — | No | — | Fecha programada | — | YYYY-MM-DD |
| duration_minutes | INTEGER | — | No | — | Duración | CHECK (duration_minutes > 0) | minutos |
| grade_scale | VARCHAR | 64 | No | — | Escala de nota | — | p.ej., 0-100_to_1-7 |
| state | VARCHAR | 16 | No | Draft | Estado | CHECK (IN ('Draft','Published','Applied','Graded','Archived')) | catálogo |
| pdf_path | TEXT | — | Sí | — | Ruta/URL del artefacto (PDF con QR) | — | URI |
| course_fk | BIGINT | — | No | — | Curso | FK → courses.course_id | — |
| user_fk | BIGINT | — | No | — | Creador/gestor | FK → users.user_id | — |
| created_at | TIMESTAMPTZ | — | No | now() | Creación | — | UTC |

### Tabla: evaluation_questions — Composición de evaluación
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| evaluation_question_id | BIGSERIAL | — | No | auto | Identificador del ítem en evaluación | PK | — |
| evaluation_fk | BIGINT | — | No | — | Evaluación | FK → evaluations.evaluation_id | UNIQUE (evaluation_fk, question_fk); UNIQUE (evaluation_fk, position) |
| question_fk | BIGINT | — | No | — | Pregunta (QB) | FK → questions.question_id | — |
| points | NUMERIC | (6,2) | No | — | Puntaje asignado | CHECK (points > 0) | ≥ 0 |
| position | INTEGER | — | No | — | Orden visual | CHECK (position >= 1) | 1..n |

### Tabla: evaluation_options — Opciones congeladas por evaluación
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| evaluation_option_id | BIGSERIAL | — | No | auto | Identificador de la opción | PK | — |
| evaluation_question_fk | BIGINT | — | No | — | Pregunta en evaluación | FK → evaluation_questions.evaluation_question_id | — |
| text | TEXT | — | No | — | Texto de opción | — | — |
| is_correct | BOOLEAN | — | No | — | Marca de correcta | — | TRUE/FALSE |
| position | INTEGER | — | No | — | Orden | CHECK (position >= 1) | 1..n |
| score | NUMERIC | (6,3) | Sí | — | Puntaje parcial | CHECK (score >= 0 OR NULL) | 0..n |
| question_option_fk | BIGINT | — | Sí | — | Línea de origen (QB) | FK → question_options.question_option_id | Trazabilidad |

### Tabla: student_evaluations — Rendición del estudiante
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| student_evaluation_id | BIGSERIAL | — | No | auto | Identificador del intento | PK | — |
| evaluation_fk | BIGINT | — | No | — | Evaluación | FK → evaluations.evaluation_id | UNIQUE (evaluation_fk, student_fk) o con attempt_no |
| student_fk | BIGINT | — | No | — | Estudiante | FK → students.student_id | — |
| total_score | NUMERIC | (8,3) | No | 0 | Puntaje total obtenido | CHECK (total_score >= 0) | ≥ 0 |
| grade | NUMERIC | (5,2) | Sí | — | Nota final | — | según grade_scale |
| taken_on | TIMESTAMPTZ | — | Sí | — | Fecha/hora de rendición | — | UTC |
| attempt_no | INTEGER | — | Sí | — | Nº intento | CHECK (attempt_no >= 1 OR NULL) | 1..n |
| state | VARCHAR | 16 | Sí | — | Estado del intento | CHECK (IN ('InProgress','Submitted','Graded')) | catálogo |

### Tabla: student_answers — Respuestas por pregunta
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| student_answer_id | BIGSERIAL | — | No | auto | Identificador | PK | — |
| student_evaluation_fk | BIGINT | — | No | — | Intento | FK → student_evaluations.student_evaluation_id | — |
| evaluation_question_fk | BIGINT | — | No | — | Pregunta en evaluación | FK → evaluation_questions.evaluation_question_id | — |
| points_earned | NUMERIC | (6,3) | No | 0 | Puntaje obtenido en la pregunta | CHECK (points_earned >= 0) | ≤ points (trigger recomendado) |

### Tabla: student_answer_options — Selección de alternativas
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| student_answer_option_id | BIGSERIAL | — | No | auto | Identificador | PK | — |
| student_answer_fk | BIGINT | — | No | — | Respuesta del estudiante | FK → student_answers.student_answer_id | — |
| evaluation_option_fk | BIGINT | — | No | — | Opción elegida (snapshot) | FK → evaluation_options.evaluation_option_id | — |

Relaciones clave (GE)
- evaluations.course_fk → courses.course_id; evaluations.user_fk → users.user_id
- evaluation_questions.evaluation_fk → evaluations.evaluation_id; .question_fk → questions.question_id
- evaluation_options.evaluation_question_fk → evaluation_questions.evaluation_question_id
- student_evaluations.(evaluation_fk, student_fk) con pertenencia a course_students (validación recomendada)
- student_answers.student_evaluation_fk → student_evaluations; .evaluation_question_fk → evaluation_questions
- student_answer_options.evaluation_option_fk → evaluation_options

Ejemplo (GE)
- Evaluation “Planets Quiz” con 2 preguntas: SC y TF. StudentEvaluations para Juan/Ana; StudentAnswers y StudentAnswerOptions reflejan opciones seleccionadas.

---

## Ingesta Móvil (IM)

### Tabla: ingest_devices — Dispositivos móviles
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| device_id | BIGSERIAL | — | No | auto | Identificador del dispositivo | PK | — |
| name | TEXT | — | No | — | Nombre del dispositivo | — | — |
| platform | VARCHAR | 32 | No | — | Plataforma | CHECK (IN ('ios','android','other')) | catálogo |
| os_version | TEXT | — | Sí | — | Versión del SO | — | p.ej., 17.5 |
| app_version | TEXT | — | Sí | — | Versión de app | — | semver |
| registered_by_fk | BIGINT | — | No | — | Usuario que registra | FK → users.user_id | — |
| registered_at | TIMESTAMPTZ | — | No | now() | Fecha de registro | — | UTC |
| active | BOOLEAN | — | No | TRUE | Vigencia | — | TRUE/FALSE |

### Tabla: ingest_batches — Lotes de captura
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| ingest_batch_id | BIGSERIAL | — | No | auto | Identificador del lote | PK | — |
| evaluation_fk | BIGINT | — | No | — | Evaluación objetivo | FK → evaluations.evaluation_id | — |
| course_fk | BIGINT | — | No | — | Curso de la evaluación | FK → courses.course_id | — |
| device_fk | BIGINT | — | No | — | Dispositivo que inicia | FK → ingest_devices.device_id | — |
| started_at | TIMESTAMPTZ | — | No | now() | Inicio de lote | — | UTC |
| closed_at | TIMESTAMPTZ | — | Sí | — | Cierre del lote | — | UTC |
| state | VARCHAR | 16 | No | 'Open' | Estado del lote | CHECK (IN ('Open','Processing','Closed')) | catálogo |
| notes | TEXT | — | Sí | — | Notas | — | — |

Validación: course_fk debe coincidir con evaluations.course_fk (TRIGGER IM).

### Tabla: scanned_pages — Páginas/imágenes
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| scanned_page_id | BIGSERIAL | — | No | auto | Identificador de página | PK | — |
| ingest_batch_fk | BIGINT | — | No | — | Lote | FK → ingest_batches.ingest_batch_id | — |
| device_fk | BIGINT | — | No | — | Dispositivo que capturó | FK → ingest_devices.device_id | — |
| image_uri | TEXT | — | No | — | Ruta/URL del objeto | — | URI |
| image_sha256 | CHAR | 64 | No | — | Huella de imagen | UNIQUE | Hex(64) |
| captured_at | TIMESTAMPTZ | — | No | now() | Fecha de captura | — | UTC |
| width_px | INTEGER | — | No | — | Ancho px | CHECK (width_px > 0) | píxeles |
| height_px | INTEGER | — | No | — | Alto px | CHECK (height_px > 0) | píxeles |
| dpi | INTEGER | — | Sí | — | DPI | CHECK (dpi > 0 OR NULL) | puntos por pulgada |
| status | VARCHAR | 16 | No | 'Queued' | Estado procesamiento | CHECK (IN ('Queued','Decoded','Failed')) | catálogo |
| failure_reason | TEXT | — | Sí | — | Motivo fallo | — | — |

Índices: (ingest_batch_fk, captured_at), UNIQUE(image_sha256).

### Tabla: page_qrs — Decodificación de QR/código
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| page_qr_id | BIGSERIAL | — | No | auto | Identificador de QR leído | PK | — |
| scanned_page_fk | BIGINT | — | No | — | Página de origen | FK → scanned_pages.scanned_page_id | — |
| evaluation_fk | BIGINT | — | No | — | Evaluación identificada | FK → evaluations.evaluation_id | — |
| sheet_version | VARCHAR | 32 | No | — | Versión/plantilla impresa | — | p.ej., v1 |
| student_identifier | TEXT | — | Sí | — | Código de estudiante | — | se resuelve a students.identifier en consolidación |
| payload | TEXT | — | No | — | JSON/string con claims firmadas | — | codificación app |
| verified | BOOLEAN | — | No | FALSE | Verificación/firma | — | TRUE/FALSE |
| decoded_at | TIMESTAMPTZ | — | No | now() | Fecha/hora de decodificación | — | UTC |

Índice: (evaluation_fk, decoded_at).

### Tabla: page_detections — Normalización y estado
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| page_detection_id | BIGSERIAL | — | No | auto | Identificador detección | PK | — |
| scanned_page_fk | BIGINT | — | No | — | Página analizada | FK → scanned_pages.scanned_page_id | — |
| rotation_deg | NUMERIC | (6,2) | Sí | — | Rotación estimada | — | grados |
| warp_mse | NUMERIC | (10,4) | Sí | — | Error de warping (MSE) | — | — |
| quality_score | NUMERIC | (5,2) | Sí | — | Calidad 0..100 | CHECK (0..100 OR NULL) | 0..100 |
| state | VARCHAR | 16 | No | 'Ready' | Estado detectado | CHECK (IN ('Ready','BubblesDetected','Failed')) | catálogo |
| failure_reason | TEXT | — | Sí | — | Motivo fallo | — | — |
| processed_at | TIMESTAMPTZ | — | Sí | — | Fin de procesamiento | — | UTC |

### Tabla: bubble_detections — Detección por burbuja
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| bubble_detection_id | BIGSERIAL | — | No | auto | Identificador burbuja | PK | — |
| page_detection_fk | BIGINT | — | No | — | Detección de página | FK → page_detections.page_detection_id | — |
| row_no | INTEGER | — | No | — | Fila | CHECK (row_no >= 1) | 1..n |
| col_no | INTEGER | — | No | — | Columna | CHECK (col_no >= 1) | 1..n |
| bbox | JSONB | — | No | — | Caja [x,y,w,h] normalizada | — | 0..1 |
| fill_score | NUMERIC | (5,3) | No | — | Intensidad de relleno | CHECK (fill_score >= 0) | ≥ 0 |
| is_marked | BOOLEAN | — | No | — | Marcada por umbral | — | TRUE/FALSE |

Índices: (page_detection_fk), (is_marked, fill_score).

### Tabla: recognition_mappings — Mapeo a evaluation_options
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| recognition_mapping_id | BIGSERIAL | — | No | auto | Identificador mapeo | PK | — |
| scanned_page_fk | BIGINT | — | No | — | Página de origen | FK → scanned_pages.scanned_page_id | — |
| bubble_detection_fk | BIGINT | — | No | — | Burbuja detectada | FK → bubble_detections.bubble_detection_id | UNIQUE (bubble_detection_fk) |
| evaluation_question_fk | BIGINT | — | No | — | Pregunta (eval) | FK → evaluation_questions.evaluation_question_id | — |
| evaluation_option_fk | BIGINT | — | No | — | Opción elegida (snapshot) | FK → evaluation_options.evaluation_option_id | — |
| confidence | NUMERIC | (5,3) | No | — | Confianza 0..1 | CHECK (0 <= confidence <= 1) | 0..1 |
| mapping_rule | VARCHAR | 32 | No | — | Regla/algoritmo | — | p.ej., grid, ocr-fallback |
| created_at | TIMESTAMPTZ | — | No | now() | Fecha de mapeo | — | UTC |

Validaciones (TRIGGER IM):
- evaluation_option_fk debe pertenecer a evaluation_question_fk.
- La burbuja debe corresponder a la misma scanned_page_fk.

### Tabla: ingest_results — Consolidación
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| ingest_result_id | BIGSERIAL | — | No | auto | Identificador resultado | PK | — |
| scanned_page_fk | BIGINT | — | No | — | Página fuente | FK → scanned_pages.scanned_page_id | — |
| evaluation_fk | BIGINT | — | No | — | Evaluación | FK → evaluations.evaluation_id | — |
| resolved_student_fk | BIGINT | — | Sí | — | Estudiante resuelto | FK → students.student_id | — |
| total_marked | INTEGER | — | No | 0 | Cantidad de burbujas marcadas | CHECK (total_marked >= 0) | ≥ 0 |
| anomalies | JSONB | — | Sí | — | Anomalías detectadas | — | esquema libre |
| state | VARCHAR | 16 | No | 'Ready' | Estado publicación | CHECK (IN ('Ready','Posted','Failed')) | catálogo |
| posted_at | TIMESTAMPTZ | — | Sí | — | Fecha de publicación | — | UTC |
| failure_reason | TEXT | — | Sí | — | Motivo de falla | — | — |

Validación (TRIGGER IM al pasar a Posted):
- resolved_student_fk no nulo; estudiante matriculado en el curso de la evaluación; existe un QR coherente para la página.

### Tabla: processing_jobs — Pipeline
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| processing_job_id | BIGSERIAL | — | No | auto | Identificador job | PK | — |
| scanned_page_fk | BIGINT | — | No | — | Página asociada | FK → scanned_pages.scanned_page_id | — |
| stage | VARCHAR | 16 | No | 'Decode' | Etapa | CHECK (IN ('Decode','Detect','Map','Post')) | catálogo |
| started_at | TIMESTAMPTZ | — | No | now() | Inicio | — | UTC |
| finished_at | TIMESTAMPTZ | — | Sí | — | Fin | — | UTC |
| status | VARCHAR | 16 | No | 'Running' | Estado del job | CHECK (IN ('Running','Succeeded','Failed','Skipped')) | catálogo |
| error | TEXT | — | Sí | — | Error si aplica | — | — |

### Tabla: processing_logs — Logs por job
| Campo | Tipo | Largo/Precisión | Nulo | Default | Descripción | Restricciones | Valores/Codificación |
|---|---|---|---|---|---|---|---|
| processing_log_id | BIGSERIAL | — | No | auto | Identificador log | PK | — |
| processing_job_fk | BIGINT | — | No | — | Job asociado | FK → processing_jobs.processing_job_id | — |
| ts | TIMESTAMPTZ | — | No | now() | Timestamp | — | UTC |
| level | VARCHAR | 8 | No | — | Nivel | CHECK (IN ('INFO','WARN','ERROR','DEBUG')) | catálogo |
| message | TEXT | — | No | — | Mensaje | — | — |
| data | JSONB | — | Sí | — | Datos extra | — | — |

Relaciones clave (IM)
- Dispositivo→Lote→Páginas→QR/Detecciones/Burbujas→Mapeos→Resultados; Pipeline Jobs/Logs por página.

Ejemplo (IM)
- Página 7200 decodifica QR de evaluation 6000; detecta 2 burbujas; mapea a opciones 6203 (SC) y 6210 (TF); resultado consolidado con 2 marcadas; jobs y logs documentan el pipeline.

---

## Codificación y unidades comunes
- Fechas/horas: TIMESTAMPTZ en UTC. Fecha pura en DATE (ISO-8601).
- Identificadores hash: image_sha256 como CHAR(64), contenido hexadecimal en minúsculas.
- Métricas de imagen: width_px/height_px en píxeles; dpi en puntos por pulgada; rotation_deg en grados (NUMERIC(6,2)); quality_score en 0..100.
- Confianza (confidence): 0..1 (NUMERIC(5,3)).
- Estados (catálogos):
  - evaluations.state: Draft, Published, Applied, Graded, Archived.
  - ingest_batches.state: Open, Processing, Closed.
  - scanned_pages.status: Queued, Decoded, Failed.
  - page_detections.state: Ready, BubblesDetected, Failed.
  - ingest_results.state: Ready, Posted, Failed.
  - processing_jobs.stage: Decode, Detect, Map, Post.
  - processing_jobs.status: Running, Succeeded, Failed, Skipped.
  - processing_logs.level: INFO, WARN, ERROR, DEBUG.
- Tipos de pregunta: question_types.code ∈ {TF, SC, MC}.

## Ejemplos de datos
- Ver: products/grade/06-data-model/mobile-ingest/DATA_TEST.sql para un flujo completo (QB+GE+IM).
- Consultas de prueba: products/grade/06-data-model/mobile-ingest/QUERY_TEST.sql.

## Problemas conocidos y consideraciones
- Validaciones de cardinalidad en question_options por tipo de pregunta pueden requerir constraint triggers DEFERRABLE (implementación fuera de este repo).
- En GE, la cota superior de points_earned ≤ points se recomienda implementar vía trigger.
- En IM, la publicación a student_answers no está automatizada por trigger en este repo; se valida solo el cambio de estado a Posted.
- Integridad inter-módulo depende del orden de carga de DDL y de la existencia de catálogos base (QB/GE) antes de IM.

## Contexto de negocio y sensibilidad de datos
- Datos personales: students (identificador, nombres) y logs con posibles identificadores; deben cumplir políticas de privacidad (GDPR/LPDP). Minimizar exposición de image_uri si contiene PII.
- Auditoría y trazabilidad: jobs/logs permiten reconstruir el pipeline para auditorías académicas.
- Idempotencia: image_sha256 único evita duplicación por reintentos en ingesta.

## Referencias cruzadas
- MER y especificaciones: 
  - Banco de Preguntas: products/grade/06-data-model/question-bank/mer.md
  - Gestión de Evaluaciones: products/grade/06-data-model/grading-management/mer.md
  - Ingesta Móvil: products/grade/06-data-model/mobile-ingest/mer.md
- SQL:
  - IM DDL/TRIGGERS/DATA_TEST/QUERY_TEST en products/grade/06-data-model/mobile-ingest/

## Glosario
- SC: Single Choice; TF: True/False; MC: Multiple Choice.
- Snapshot: copia de opciones del banco en el contexto de una evaluación.
- Pipeline: etapas de procesamiento de ingesta.
