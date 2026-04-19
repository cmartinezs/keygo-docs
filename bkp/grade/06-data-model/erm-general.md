# Diagrama general de Base de Datos

A continuación se presenta un diagrama Entidad-Relación (ER) general que integra los tres módulos principales del sistema GRADE: Banco de Preguntas, Gestión de Evaluaciones e Ingesta Móvil. Este diagrama ilustra las entidades clave, sus atributos principales y las relaciones entre ellas, proporcionando una visión global de la estructura de datos del sistema.

```mermaid
erDiagram
    %% === Banco de Preguntas (QB) ===
    USERS ||--o{ QUESTIONS : "author"
    SUBJECTS ||--o{ UNITS : "has"
    UNITS ||--o{ TOPICS : "has"
    TOPICS ||--o{ QUESTIONS : "has"
    QUESTIONS ||--|{ QUESTION_OPTIONS : "has"
    DIFFICULTIES ||--o{ QUESTIONS : "level"
    OUTCOMES ||--o{ QUESTIONS : "learning outcome (optional)"
    QUESTION_TYPES ||--o{ QUESTIONS : "typed as"

    %% === Gestión de cursos y evaluaciones (GE) ===
    USERS ||--o{ COURSES : "owns"
    USERS ||--o{ EVALUATIONS : "creates"
    COURSES ||--o{ COURSE_STUDENTS : "has"
    STUDENTS ||--o{ COURSE_STUDENTS : "enrolls"
    COURSES ||--o{ EVALUATIONS : "includes"

    %% === Composición de la evaluación (snapshot) ===
    EVALUATIONS ||--o{ EVALUATION_QUESTIONS : "composes"
    QUESTIONS ||--o{ EVALUATION_QUESTIONS : "sourced from"
    EVALUATION_QUESTIONS ||--|{ EVALUATION_OPTIONS : "snapshots options"
    QUESTION_OPTIONS ||--o{ EVALUATION_OPTIONS : "source of (lineage)"

    %% === Rendición y respuestas ===
    EVALUATIONS ||--o{ STUDENT_EVALUATIONS : "attempts"
    STUDENTS ||--o{ STUDENT_EVALUATIONS : "participates"
    STUDENT_EVALUATIONS ||--|{ STUDENT_ANSWERS : "has"
    EVALUATION_QUESTIONS ||--o{ STUDENT_ANSWERS : "answered"
    STUDENT_ANSWERS ||--|{ STUDENT_ANSWER_OPTIONS : "selects"
    EVALUATION_OPTIONS ||--o{ STUDENT_ANSWER_OPTIONS : "chosen"

    %% === Ingesta Móvil (IM) ===
    INGEST_DEVICES ||--o{ INGEST_BATCHES : "uses"
    INGEST_DEVICES ||--o{ SCANNED_PAGES : "captures"
    INGEST_BATCHES ||--o{ SCANNED_PAGES : "groups"

    SCANNED_PAGES ||--|{ PAGE_QRS : "decoded as"
    SCANNED_PAGES ||--|{ PAGE_DETECTIONS : "detected"
    PAGE_DETECTIONS ||--|{ BUBBLE_DETECTIONS : "has"

    SCANNED_PAGES ||--|{ RECOGNITION_MAPPINGS : "maps"
    BUBBLE_DETECTIONS ||--o| RECOGNITION_MAPPINGS : "mapped"
    RECOGNITION_MAPPINGS ||--o{ EVALUATION_OPTIONS : "to"
    RECOGNITION_MAPPINGS ||--o{ EVALUATION_QUESTIONS : "context"

    SCANNED_PAGES ||--o{ INGEST_RESULTS : "consolidates"

    SCANNED_PAGES ||--o{ PROCESSING_JOBS : "pipeline"
    PROCESSING_JOBS ||--o{ PROCESSING_LOGS : "logs"

    %% === Enlaces inter-módulo ===
    EVALUATIONS ||--o{ INGEST_BATCHES : "target"
    EVALUATIONS ||--o{ INGEST_RESULTS : "results"
```