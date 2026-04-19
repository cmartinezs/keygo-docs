-- Mobile Ingest – DDL (PostgreSQL)
-- Nota: Este script crea únicamente las tablas, claves y restricciones según el MER.
-- Triggers de validación inter-módulo (p.ej., validar course_fk de evaluation) irán en TRIGGERS.sql.

BEGIN;

-- 1) ingest_devices
CREATE TABLE IF NOT EXISTS ingest_devices (
    device_id         BIGSERIAL PRIMARY KEY,
    name              TEXT        NOT NULL,
    platform          VARCHAR(32) NOT NULL CHECK (platform IN ('ios','android','other')),
    os_version        TEXT        NULL,
    app_version       TEXT        NULL,
    registered_by_fk  BIGINT      NOT NULL,
    registered_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    active            BOOLEAN     NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_ingest_devices_registered_by
        FOREIGN KEY (registered_by_fk) REFERENCES users(user_id)
);

-- 2) ingest_batches
CREATE TABLE IF NOT EXISTS ingest_batches (
    ingest_batch_id BIGSERIAL   PRIMARY KEY,
    evaluation_fk   BIGINT      NOT NULL,
    course_fk       BIGINT      NOT NULL,
    device_fk       BIGINT      NOT NULL,
    started_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    closed_at       TIMESTAMPTZ NULL,
    state           VARCHAR(16) NOT NULL DEFAULT 'Open' CHECK (state IN ('Open','Processing','Closed')),
    notes           TEXT        NULL,
    CONSTRAINT fk_ingest_batches_evaluation
        FOREIGN KEY (evaluation_fk) REFERENCES evaluations(evaluation_id),
    CONSTRAINT fk_ingest_batches_course
        FOREIGN KEY (course_fk) REFERENCES courses(course_id),
    CONSTRAINT fk_ingest_batches_device
        FOREIGN KEY (device_fk) REFERENCES ingest_devices(device_id)
);
-- Regla: course_fk debe coincidir con evaluations.course_fk (validar vía trigger en TRIGGERS.sql)

-- 3) scanned_pages
CREATE TABLE IF NOT EXISTS scanned_pages (
    scanned_page_id BIGSERIAL   PRIMARY KEY,
    ingest_batch_fk BIGINT      NOT NULL,
    device_fk       BIGINT      NOT NULL,
    image_uri       TEXT        NOT NULL,
    image_sha256    CHAR(64)    NOT NULL,
    captured_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    width_px        INTEGER     NOT NULL CHECK (width_px > 0),
    height_px       INTEGER     NOT NULL CHECK (height_px > 0),
    dpi             INTEGER     NULL CHECK (dpi IS NULL OR dpi > 0),
    status          VARCHAR(16) NOT NULL DEFAULT 'Queued' CHECK (status IN ('Queued','Decoded','Failed')),
    failure_reason  TEXT        NULL,
    CONSTRAINT uq_scanned_pages_image_sha256 UNIQUE (image_sha256),
    CONSTRAINT fk_scanned_pages_batch FOREIGN KEY (ingest_batch_fk) REFERENCES ingest_batches(ingest_batch_id),
    CONSTRAINT fk_scanned_pages_device FOREIGN KEY (device_fk) REFERENCES ingest_devices(device_id)
);

-- 4) page_qrs
CREATE TABLE IF NOT EXISTS page_qrs (
    page_qr_id         BIGSERIAL   PRIMARY KEY,
    scanned_page_fk    BIGINT      NOT NULL,
    evaluation_fk      BIGINT      NOT NULL,
    sheet_version      VARCHAR(32) NOT NULL,
    student_identifier TEXT        NULL,
    payload            TEXT        NOT NULL,
    verified           BOOLEAN     NOT NULL DEFAULT FALSE,
    decoded_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT fk_page_qrs_scanned_page FOREIGN KEY (scanned_page_fk) REFERENCES scanned_pages(scanned_page_id),
    CONSTRAINT fk_page_qrs_evaluation FOREIGN KEY (evaluation_fk) REFERENCES evaluations(evaluation_id)
);

-- 5) page_detections
CREATE TABLE IF NOT EXISTS page_detections (
    page_detection_id BIGSERIAL    PRIMARY KEY,
    scanned_page_fk   BIGINT       NOT NULL,
    rotation_deg      NUMERIC(6,2) NULL,
    warp_mse          NUMERIC(10,4) NULL,
    quality_score     NUMERIC(5,2)  NULL CHECK (quality_score IS NULL OR (quality_score >= 0 AND quality_score <= 100)),
    state             VARCHAR(16)  NOT NULL DEFAULT 'Ready' CHECK (state IN ('Ready','BubblesDetected','Failed')),
    failure_reason    TEXT         NULL,
    processed_at      TIMESTAMPTZ  NULL,
    CONSTRAINT fk_page_detections_scanned_page FOREIGN KEY (scanned_page_fk) REFERENCES scanned_pages(scanned_page_id)
);

-- 6) bubble_detections
CREATE TABLE IF NOT EXISTS bubble_detections (
    bubble_detection_id BIGSERIAL    PRIMARY KEY,
    page_detection_fk   BIGINT       NOT NULL,
    row_no              INTEGER      NOT NULL CHECK (row_no >= 1),
    col_no              INTEGER      NOT NULL CHECK (col_no >= 1),
    bbox                JSONB        NOT NULL,
    fill_score          NUMERIC(5,3) NOT NULL CHECK (fill_score >= 0),
    is_marked           BOOLEAN      NOT NULL,
    CONSTRAINT fk_bubble_detections_page_detection FOREIGN KEY (page_detection_fk) REFERENCES page_detections(page_detection_id)
);

-- 7) recognition_mappings
CREATE TABLE IF NOT EXISTS recognition_mappings (
    recognition_mapping_id BIGSERIAL    PRIMARY KEY,
    scanned_page_fk        BIGINT       NOT NULL,
    bubble_detection_fk    BIGINT       NOT NULL,
    evaluation_question_fk BIGINT       NOT NULL,
    evaluation_option_fk   BIGINT       NOT NULL,
    confidence             NUMERIC(5,3) NOT NULL CHECK (confidence >= 0 AND confidence <= 1),
    mapping_rule           VARCHAR(32)  NOT NULL,
    created_at             TIMESTAMPTZ  NOT NULL DEFAULT now(),
    CONSTRAINT uq_recognition_mappings_bubble UNIQUE (bubble_detection_fk),
    CONSTRAINT fk_recognition_mappings_scanned_page FOREIGN KEY (scanned_page_fk) REFERENCES scanned_pages(scanned_page_id),
    CONSTRAINT fk_recognition_mappings_bubble FOREIGN KEY (bubble_detection_fk) REFERENCES bubble_detections(bubble_detection_id),
    CONSTRAINT fk_recognition_mappings_eval_question FOREIGN KEY (evaluation_question_fk) REFERENCES evaluation_questions(evaluation_question_id),
    CONSTRAINT fk_recognition_mappings_eval_option FOREIGN KEY (evaluation_option_fk) REFERENCES evaluation_options(evaluation_option_id)
);
-- Consistencia adicional: evaluation_option_fk debe pertenecer a evaluation_question_fk (validar vía trigger en TRIGGERS.sql)

-- 8) ingest_results
CREATE TABLE IF NOT EXISTS ingest_results (
    ingest_result_id     BIGSERIAL   PRIMARY KEY,
    scanned_page_fk      BIGINT      NOT NULL,
    evaluation_fk        BIGINT      NOT NULL,
    resolved_student_fk  BIGINT      NULL,
    total_marked         INTEGER     NOT NULL DEFAULT 0 CHECK (total_marked >= 0),
    anomalies            JSONB       NULL,
    state                VARCHAR(16) NOT NULL DEFAULT 'Ready' CHECK (state IN ('Ready','Posted','Failed')),
    posted_at            TIMESTAMPTZ NULL,
    failure_reason       TEXT        NULL,
    CONSTRAINT fk_ingest_results_scanned_page FOREIGN KEY (scanned_page_fk) REFERENCES scanned_pages(scanned_page_id),
    CONSTRAINT fk_ingest_results_evaluation FOREIGN KEY (evaluation_fk) REFERENCES evaluations(evaluation_id),
    CONSTRAINT fk_ingest_results_student FOREIGN KEY (resolved_student_fk) REFERENCES students(student_id)
);
-- Regla de pertenencia (course vs enrollment) a validar en TRIGGERS.sql antes de postear

-- 9) processing_jobs
CREATE TABLE IF NOT EXISTS processing_jobs (
    processing_job_id BIGSERIAL   PRIMARY KEY,
    scanned_page_fk   BIGINT      NOT NULL,
    stage             VARCHAR(16) NOT NULL CHECK (stage IN ('Decode','Detect','Map','Post')),
    started_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
    finished_at       TIMESTAMPTZ NULL,
    status            VARCHAR(16) NOT NULL DEFAULT 'Running' CHECK (status IN ('Running','Succeeded','Failed','Skipped')),
    error             TEXT        NULL,
    CONSTRAINT fk_processing_jobs_scanned_page FOREIGN KEY (scanned_page_fk) REFERENCES scanned_pages(scanned_page_id)
);

-- 10) processing_logs
CREATE TABLE IF NOT EXISTS processing_logs (
    processing_log_id BIGSERIAL   PRIMARY KEY,
    processing_job_fk BIGINT      NOT NULL,
    ts                TIMESTAMPTZ NOT NULL DEFAULT now(),
    level             VARCHAR(8)  NOT NULL CHECK (level IN ('INFO','WARN','ERROR','DEBUG')),
    message           TEXT        NOT NULL,
    data              JSONB       NULL,
    CONSTRAINT fk_processing_logs_job FOREIGN KEY (processing_job_fk) REFERENCES processing_jobs(processing_job_id)
);

-- =====================
-- Índices sugeridos
-- =====================

-- scanned_pages
CREATE INDEX IF NOT EXISTS idx_scanned_pages_batch_captured
    ON scanned_pages (ingest_batch_fk, captured_at);
CREATE UNIQUE INDEX IF NOT EXISTS uq_scanned_pages_image_sha256
    ON scanned_pages (image_sha256);

-- page_qrs
CREATE INDEX IF NOT EXISTS idx_page_qrs_eval_decoded
    ON page_qrs (evaluation_fk, decoded_at);

-- bubble_detections
CREATE INDEX IF NOT EXISTS idx_bubble_detections_page
    ON bubble_detections (page_detection_fk);
CREATE INDEX IF NOT EXISTS idx_bubble_detections_marked_score
    ON bubble_detections (is_marked, fill_score);

-- recognition_mappings
CREATE INDEX IF NOT EXISTS idx_recognition_mappings_eval_question
    ON recognition_mappings (evaluation_question_fk);
CREATE INDEX IF NOT EXISTS idx_recognition_mappings_eval_option
    ON recognition_mappings (evaluation_option_fk);

-- ingest_results
CREATE INDEX IF NOT EXISTS idx_ingest_results_eval_student
    ON ingest_results (evaluation_fk, resolved_student_fk);

-- FK helper indexes (joins frecuentes)
CREATE INDEX IF NOT EXISTS idx_scanned_pages_device
    ON scanned_pages (device_fk);
CREATE INDEX IF NOT EXISTS idx_scanned_pages_batch
    ON scanned_pages (ingest_batch_fk);
CREATE INDEX IF NOT EXISTS idx_processing_jobs_page
    ON processing_jobs (scanned_page_fk);
CREATE INDEX IF NOT EXISTS idx_processing_logs_job
    ON processing_logs (processing_job_fk);

COMMIT;
