-- Mobile Ingest – Datos de Prueba (PostgreSQL)
-- Objetivo: cargar un conjunto mínimo pero coherente de datos que permita
-- probar el DDL y los TRIGGERS del módulo de Ingesta Móvil junto con
-- las referencias de Question Bank y Gestión de Evaluaciones.
--
-- Requisitos que este set satisface:
--  - ingest_batches.course_fk coincide con evaluations.course_fk
--  - recognition_mappings.evaluation_option_fk pertenece a evaluation_question_fk
--  - recognition_mappings.bubble_detection_fk corresponde a la misma scanned_page_fk
--  - ingest_results con state='Posted' exige estudiante matriculado en el curso de la evaluación
--  - page_qrs enlaza scanned_page con evaluation para coherencia QR
--
-- Uso sugerido:
--  1) Ejecutar previamente los scripts DDL de Question Bank y Gestión de Evaluaciones,
--     y luego el DDL/TRIGGERS de Mobile Ingest.
--  2) Ejecutar este script.
--  3) Opcional: crear consultas de verificación (ver QUERY_TEST.sql si existe).

BEGIN;

-- ===============
-- 1) Catálogos mínimos y actores (QB/GE)
-- ===============
INSERT INTO users (user_id, name, email, role, created_at)
VALUES (1000, 'Prof. Ada Lovelace', 'ada.teacher@example.edu', 'Teacher', now())
ON CONFLICT DO NOTHING;

INSERT INTO subjects (subject_id, name, code, active)
VALUES (2000, 'Science', 'SCI', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO units (unit_id, name, subject_fk, active)
VALUES (2100, 'The Solar System', 2000, TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO topics (topic_id, name, unit_fk, active)
VALUES (2200, 'Planets', 2100, TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO difficulties (difficulty_id, level, weight)
VALUES (2300, 'Easy', 1)
ON CONFLICT DO NOTHING;

INSERT INTO question_types (question_type_id, code, name)
VALUES
  (2400, 'SC', 'Single Choice'),
  (2401, 'TF', 'True/False')
ON CONFLICT DO NOTHING;

-- Estudiantes y curso
INSERT INTO students (student_id, first_name, last_name, identifier)
VALUES
  (3000, 'Juan', 'Pérez', 'STU-0001'),
  (3001, 'Ana', 'García', 'STU-0002')
ON CONFLICT DO NOTHING;

INSERT INTO courses (course_id, name, code, user_fk)
VALUES (4000, 'Science 5A', 'SCI-5A-2025', 1000)
ON CONFLICT DO NOTHING;

INSERT INTO course_students (course_student_id, course_fk, student_fk, enrolled_on)
VALUES
  (4100, 4000, 3000, CURRENT_DATE),
  (4101, 4000, 3001, CURRENT_DATE)
ON CONFLICT DO NOTHING;

-- ===============
-- 2) Banco de preguntas: 1 pregunta SC (4 opciones) y 1 TF (2 opciones)
-- ===============
INSERT INTO questions (question_id, text, active, version, original_question_fk, topic_fk, difficulty_fk, outcome_fk, question_type_fk, user_fk, created_at)
VALUES
  (5000, 'Which planet is known as the Red Planet?', TRUE, 1, NULL, 2200, 2300, NULL, 2400, 1000, now()),
  (5001, 'The Earth is the third planet from the Sun.', TRUE, 1, NULL, 2200, 2300, NULL, 2401, 1000, now())
ON CONFLICT DO NOTHING;

INSERT INTO question_options (question_option_id, text, is_correct, position, score, question_fk)
VALUES
  -- Para Q#5000 (SC)
  (5100, 'Mercury', FALSE, 1, NULL, 5000),
  (5101, 'Venus',   FALSE, 2, NULL, 5000),
  (5102, 'Earth',   FALSE, 3, NULL, 5000),
  (5103, 'Mars',    TRUE,  4, NULL, 5000),
  -- Para Q#5001 (TF)
  (5110, 'True',    TRUE,  1, NULL, 5001),
  (5111, 'False',   FALSE, 2, NULL, 5001)
ON CONFLICT DO NOTHING;

-- ===============
-- 3) Evaluación: compone las 2 preguntas
-- ===============
INSERT INTO evaluations (evaluation_id, title, scheduled_date, duration_minutes, grade_scale, state, pdf_path, course_fk, user_fk, created_at)
VALUES (6000, 'Planets Quiz', CURRENT_DATE, 30, '0-100_to_1-7', 'Published', '/files/evals/planets-quiz.pdf', 4000, 1000, now())
ON CONFLICT DO NOTHING;

INSERT INTO evaluation_questions (evaluation_question_id, evaluation_fk, question_fk, points, position)
VALUES
  (6100, 6000, 5000, 2.0, 1),
  (6101, 6000, 5001, 1.0, 2)
ON CONFLICT DO NOTHING;

-- Snapshot de opciones en la evaluación
INSERT INTO evaluation_options (evaluation_option_id, evaluation_question_fk, text, is_correct, position, score, question_option_fk)
VALUES
  -- Para EQ#6100 (SC de Q#5000)
  (6200, 6100, 'Mercury', FALSE, 1, NULL, 5100),
  (6201, 6100, 'Venus',   FALSE, 2, NULL, 5101),
  (6202, 6100, 'Earth',   FALSE, 3, NULL, 5102),
  (6203, 6100, 'Mars',    TRUE,  4, NULL, 5103),
  -- Para EQ#6101 (TF de Q#5001)
  (6210, 6101, 'True',    TRUE,  1, NULL, 5110),
  (6211, 6101, 'False',   FALSE, 2, NULL, 5111)
ON CONFLICT DO NOTHING;

-- ===============
-- 4) Ingesta Móvil: dispositivo, lote, páginas y pipeline
-- ===============
INSERT INTO ingest_devices (device_id, name, platform, os_version, app_version, registered_by_fk, registered_at, active)
VALUES (7000, 'Teacher Phone', 'android', '14', '1.0.0', 1000, now(), TRUE)
ON CONFLICT DO NOTHING;

-- Lote coherente con la evaluación/curso
INSERT INTO ingest_batches (ingest_batch_id, evaluation_fk, course_fk, device_fk, started_at, closed_at, state, notes)
VALUES (7100, 6000, 4000, 7000, now(), NULL, 'Open', 'Batch for Planets Quiz')
ON CONFLICT DO NOTHING;

-- Página escaneada (hash simulado de 64 chars)
INSERT INTO scanned_pages (scanned_page_id, ingest_batch_fk, device_fk, image_uri, image_sha256, captured_at, width_px, height_px, dpi, status, failure_reason)
VALUES (7200, 7100, 7000, 's3://bucket/ingest/6000/page-1.jpg', 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa', now(), 2480, 3508, 300, 'Decoded', NULL)
ON CONFLICT DO NOTHING;

-- QR que vincula la página a la evaluación (coherencia para triggers)
INSERT INTO page_qrs (page_qr_id, scanned_page_fk, evaluation_fk, sheet_version, student_identifier, payload, verified, decoded_at)
VALUES (7300, 7200, 6000, 'v1', NULL, '{"ev":"6000","sig":"demo"}', TRUE, now())
ON CONFLICT DO NOTHING;

-- Detección de página y burbujas
INSERT INTO page_detections (page_detection_id, scanned_page_fk, rotation_deg, warp_mse, quality_score, state, failure_reason, processed_at)
VALUES (7400, 7200, 0.5, 0.0012, 95.0, 'BubblesDetected', NULL, now())
ON CONFLICT DO NOTHING;

-- Dos burbujas marcadas: una para cada pregunta (simplificado)
-- Para SC (pos=4 = 'Mars'), y para TF (pos=1 = 'True')
INSERT INTO bubble_detections (bubble_detection_id, page_detection_fk, row_no, col_no, bbox, fill_score, is_marked)
VALUES
  (7500, 7400, 1, 4, '{"x":0.70,"y":0.20,"w":0.02,"h":0.02}'::jsonb, 0.95, TRUE),
  (7501, 7400, 2, 1, '{"x":0.10,"y":0.30,"w":0.02,"h":0.02}'::jsonb, 0.90, TRUE)
ON CONFLICT DO NOTHING;

-- Mapeo reconocimiento → opciones de la evaluación
-- Debe cumplir: cada bubble_detection_fk es único y pertenece a la misma scanned_page_fk
INSERT INTO recognition_mappings (recognition_mapping_id, scanned_page_fk, bubble_detection_fk, evaluation_question_fk, evaluation_option_fk, confidence, mapping_rule, created_at)
VALUES
  (7600, 7200, 7500, 6100, 6203, 0.98, 'grid', now()), -- Mars para SC
  (7601, 7200, 7501, 6101, 6210, 0.96, 'grid', now())  -- True para TF
ON CONFLICT DO NOTHING;

-- Resultado consolidado (uno listo y uno publicado)
INSERT INTO ingest_results (ingest_result_id, scanned_page_fk, evaluation_fk, resolved_student_fk, total_marked, anomalies, state, posted_at, failure_reason)
VALUES
  (7700, 7200, 6000, 3000, 2, NULL, 'Ready', NULL, NULL),
  (7701, 7200, 6000, 3001, 2, NULL, 'Posted', now(), NULL)
ON CONFLICT DO NOTHING;

-- Jobs y logs (auditoría)
INSERT INTO processing_jobs (processing_job_id, scanned_page_fk, stage, started_at, finished_at, status, error)
VALUES
  (7800, 7200, 'Decode', now() - interval '2 minutes', now() - interval '1 minutes', 'Succeeded', NULL),
  (7801, 7200, 'Detect', now() - interval '1 minutes', now() - interval '30 seconds', 'Succeeded', NULL),
  (7802, 7200, 'Map',    now() - interval '30 seconds', now() - interval '15 seconds', 'Succeeded', NULL),
  (7803, 7200, 'Post',   now() - interval '15 seconds', now(), 'Succeeded', NULL)
ON CONFLICT DO NOTHING;

INSERT INTO processing_logs (processing_log_id, processing_job_fk, ts, level, message, data)
VALUES
  (7900, 7800, now() - interval '90 seconds', 'INFO', 'QR decoded', '{"evaluation":6000}'),
  (7901, 7801, now() - interval '40 seconds', 'INFO', 'Bubbles detected', '{"count":2}'),
  (7902, 7802, now() - interval '10 seconds', 'INFO', 'Mapped bubbles to options', '{"mappings":2}'),
  (7903, 7803, now(), 'INFO', 'Posted to Evaluations', '{"state":"Posted"}')
ON CONFLICT DO NOTHING;

-- ===============
-- 5) Ajuste de secuencias (evita colisiones si luego se usan IDs por defecto)
-- ===============
-- Nota: utiliza pg_get_serial_sequence para cada tabla/columna con BIGSERIAL
DO $$
DECLARE
  rec RECORD;
BEGIN
  FOR rec IN (
    SELECT tbl, col FROM (VALUES
      ('users','user_id'),
      ('subjects','subject_id'),
      ('units','unit_id'),
      ('topics','topic_id'),
      ('difficulties','difficulty_id'),
      ('question_types','question_type_id'),
      ('students','student_id'),
      ('courses','course_id'),
      ('course_students','course_student_id'),
      ('questions','question_id'),
      ('question_options','question_option_id'),
      ('evaluations','evaluation_id'),
      ('evaluation_questions','evaluation_question_id'),
      ('evaluation_options','evaluation_option_id'),
      ('ingest_devices','device_id'),
      ('ingest_batches','ingest_batch_id'),
      ('scanned_pages','scanned_page_id'),
      ('page_qrs','page_qr_id'),
      ('page_detections','page_detection_id'),
      ('bubble_detections','bubble_detection_id'),
      ('recognition_mappings','recognition_mapping_id'),
      ('ingest_results','ingest_result_id'),
      ('processing_jobs','processing_job_id'),
      ('processing_logs','processing_log_id')
    ) AS t(tbl,col)
  ) LOOP
    EXECUTE format('SELECT setval(pg_get_serial_sequence(''%I'',''%I''), COALESCE((SELECT max(%I) FROM %I), 0))', rec.tbl, rec.col, rec.col, rec.tbl);
  END LOOP;
END $$;

COMMIT;
