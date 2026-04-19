-- Mobile Ingest – TRIGGERS y funciones (PostgreSQL)
-- Este script implementa validaciones declaradas en el MER/DDL para el módulo de Ingesta Móvil.
-- Requisitos principales:
--  1) ingest_batches.course_fk debe coincidir con evaluations.course_fk
--  2) recognition_mappings: evaluation_option_fk debe pertenecer a evaluation_question_fk
--     y la burbuja referenciada debe corresponder a la misma scanned_page_fk
--  3) ingest_results: al pasar a 'Posted', el estudiante debe estar matriculado en el curso de la evaluación

BEGIN;

-- ===============================
-- Utilidades
-- ===============================
CREATE OR REPLACE FUNCTION _raise(text) RETURNS void AS $$
BEGIN
  RAISE EXCEPTION USING MESSAGE = $1;
END; $$ LANGUAGE plpgsql;

-- ===============================
-- (1) Validar course_fk del lote vs evaluación
-- ===============================
CREATE OR REPLACE FUNCTION fn_validate_ingest_batch_course()
RETURNS trigger AS $$
DECLARE
  eval_course BIGINT;
BEGIN
  SELECT e.course_fk INTO eval_course
  FROM evaluations e
  WHERE e.evaluation_id = NEW.evaluation_fk;

  IF eval_course IS NULL THEN
    RAISE EXCEPTION 'Evaluation % no existe', NEW.evaluation_fk;
  END IF;

  IF NEW.course_fk IS DISTINCT FROM eval_course THEN
    RAISE EXCEPTION 'ingest_batches.course_fk (%) no coincide con evaluations.course_fk (%) para evaluation %', NEW.course_fk, eval_course, NEW.evaluation_fk;
  END IF;

  RETURN NEW;
END; $$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_ingest_batches_course_consistency ON ingest_batches;
CREATE TRIGGER trg_ingest_batches_course_consistency
BEFORE INSERT OR UPDATE OF evaluation_fk, course_fk ON ingest_batches
FOR EACH ROW
EXECUTE FUNCTION fn_validate_ingest_batch_course();

-- ===============================
-- (2) Consistencia en recognition_mappings
--   a) La opción pertenece a la pregunta indicada
--   b) La burbuja mapeada pertenece a la misma scanned_page_fk
-- ===============================
CREATE OR REPLACE FUNCTION fn_validate_recognition_mapping()
RETURNS trigger AS $$
DECLARE
  eo_question BIGINT;
  bubble_page BIGINT;
BEGIN
  -- a) Verificar que evaluation_option ↔ evaluation_question coinciden
  SELECT eo.evaluation_question_fk INTO eo_question
  FROM evaluation_options eo
  WHERE eo.evaluation_option_id = NEW.evaluation_option_fk;

  IF eo_question IS NULL THEN
    RAISE EXCEPTION 'evaluation_option % no existe', NEW.evaluation_option_fk;
  END IF;

  IF NEW.evaluation_question_fk IS DISTINCT FROM eo_question THEN
    RAISE EXCEPTION 'evaluation_option % pertenece a evaluation_question_fk %, no a %', NEW.evaluation_option_fk, eo_question, NEW.evaluation_question_fk;
  END IF;

  -- b) Verificar que la burbuja referenciada corresponde a la misma scanned_page_fk
  SELECT sp.scanned_page_id INTO bubble_page
  FROM bubble_detections bd
  JOIN page_detections pd ON pd.page_detection_id = bd.page_detection_fk
  JOIN scanned_pages sp ON sp.scanned_page_id = pd.scanned_page_fk
  WHERE bd.bubble_detection_id = NEW.bubble_detection_fk;

  IF bubble_page IS NULL THEN
    RAISE EXCEPTION 'bubble_detection % no existe', NEW.bubble_detection_fk;
  END IF;

  IF NEW.scanned_page_fk IS DISTINCT FROM bubble_page THEN
    RAISE EXCEPTION 'recognition_mappings.scanned_page_fk (%) no coincide con la página de la burbuja (%)', NEW.scanned_page_fk, bubble_page;
  END IF;

  RETURN NEW;
END; $$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_recognition_mappings_validate ON recognition_mappings;
CREATE TRIGGER trg_recognition_mappings_validate
BEFORE INSERT OR UPDATE OF scanned_page_fk, bubble_detection_fk, evaluation_question_fk, evaluation_option_fk ON recognition_mappings
FOR EACH ROW
EXECUTE FUNCTION fn_validate_recognition_mapping();

-- ===============================
-- (3) Validación al publicar resultados (ingest_results)
--      Reglas:
--        - Al cambiar a state = 'Posted':
--            • resolved_student_fk NO NULL
--            • Estudiante matriculado en el curso de la evaluación (course_students)
--            • (opcional) Existe algún page_qr para la scanned_page con la misma evaluation_fk
-- ===============================
CREATE OR REPLACE FUNCTION fn_validate_ingest_result_post()
RETURNS trigger AS $$
DECLARE
  eval_course BIGINT;
  enrolled_id BIGINT;
  qr_exists BOOLEAN;
BEGIN
  -- Si no se actualiza a 'Posted', no validar
  IF NOT (NEW.state = 'Posted' AND (OLD.state IS DISTINCT FROM NEW.state)) THEN
    RETURN NEW;
  END IF;

  IF NEW.resolved_student_fk IS NULL THEN
    RAISE EXCEPTION 'No se puede publicar (state=Posted) sin resolved_student_fk';
  END IF;

  -- Obtener curso de la evaluación
  SELECT e.course_fk INTO eval_course
  FROM evaluations e
  WHERE e.evaluation_id = NEW.evaluation_fk;

  IF eval_course IS NULL THEN
    RAISE EXCEPTION 'Evaluation % no existe', NEW.evaluation_fk;
  END IF;

  -- Verificar matrícula
  SELECT cs.course_student_id INTO enrolled_id
  FROM course_students cs
  WHERE cs.course_fk = eval_course
    AND cs.student_fk = NEW.resolved_student_fk;

  IF enrolled_id IS NULL THEN
    RAISE EXCEPTION 'Student % no está matriculado en el course % de evaluation %', NEW.resolved_student_fk, eval_course, NEW.evaluation_fk;
  END IF;

  -- (Opcional) validar coherencia evaluation_fk con lo decodificado en la página (si existe QR)
  SELECT EXISTS (
    SELECT 1
    FROM page_qrs pq
    WHERE pq.scanned_page_fk = NEW.scanned_page_fk
      AND pq.evaluation_fk   = NEW.evaluation_fk
  ) INTO qr_exists;

  IF NOT qr_exists THEN
    RAISE EXCEPTION 'No hay QR asociado a scanned_page % que refiera a evaluation %', NEW.scanned_page_fk, NEW.evaluation_fk;
  END IF;

  RETURN NEW;
END; $$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_ingest_results_validate_post ON ingest_results;
CREATE TRIGGER trg_ingest_results_validate_post
BEFORE UPDATE OF state ON ingest_results
FOR EACH ROW
EXECUTE FUNCTION fn_validate_ingest_result_post();

COMMIT;
