-- Mobile Ingest – Consultas de Prueba (PostgreSQL)
-- Objetivo: validar rápidamente la coherencia del DDL/TRIGGERS y navegar la trazabilidad extremo a extremo
-- usando el dataset de products/grade/06-data-model/mobile-ingest/DATA_TEST.sql.
--
-- Uso sugerido en psql:
--   \i products/grade/06-data-model/mobile-ingest/DDL.sql
--   \i products/grade/06-data-model/mobile-ingest/TRIGGERS.sql
--   \i products/grade/06-data-model/mobile-ingest/DATA_TEST.sql
--   \i products/grade/06-data-model/mobile-ingest/QUERY_TEST.sql
--
-- Variables por defecto (ajustables)
\set evaluation_id 6000
\set course_id 4000
\set scanned_page_id 7200
\set student_id 3000

-- 0) Resumen de conteos básicos
SELECT 'ingest_devices' AS table, COUNT(*) AS cnt FROM ingest_devices
UNION ALL SELECT 'ingest_batches', COUNT(*) FROM ingest_batches
UNION ALL SELECT 'scanned_pages', COUNT(*) FROM scanned_pages
UNION ALL SELECT 'page_qrs', COUNT(*) FROM page_qrs
UNION ALL SELECT 'page_detections', COUNT(*) FROM page_detections
UNION ALL SELECT 'bubble_detections', COUNT(*) FROM bubble_detections
UNION ALL SELECT 'recognition_mappings', COUNT(*) FROM recognition_mappings
UNION ALL SELECT 'ingest_results', COUNT(*) FROM ingest_results
UNION ALL SELECT 'processing_jobs', COUNT(*) FROM processing_jobs
UNION ALL SELECT 'processing_logs', COUNT(*) FROM processing_logs
ORDER BY table;

-- 1) Lotes coherentes (trigger 1): course_fk del lote coincide con evaluation.course_fk
SELECT ib.ingest_batch_id, ib.evaluation_fk, e.course_fk AS course_in_evaluation, ib.course_fk AS course_in_batch,
       (e.course_fk = ib.course_fk) AS course_match, ib.state
FROM ingest_batches ib
JOIN evaluations e ON e.evaluation_id = ib.evaluation_fk
ORDER BY ib.ingest_batch_id;

-- 2) Páginas por lote y dispositivo
SELECT sp.scanned_page_id, sp.image_uri, sp.captured_at, sp.status,
       ib.ingest_batch_id, d.name AS device_name
FROM scanned_pages sp
JOIN ingest_batches ib ON ib.ingest_batch_id = sp.ingest_batch_fk
JOIN ingest_devices d ON d.device_id = sp.device_fk
ORDER BY sp.captured_at DESC;

-- 3) QR decodificado y vínculo a evaluación
SELECT pq.page_qr_id, pq.scanned_page_fk, pq.evaluation_fk, e.title, pq.sheet_version, pq.verified, pq.decoded_at
FROM page_qrs pq
JOIN evaluations e ON e.evaluation_id = pq.evaluation_fk
WHERE pq.scanned_page_fk = :scanned_page_id;

-- 4) Calidad/detección en la página
SELECT pd.page_detection_id, pd.scanned_page_fk, pd.quality_score, pd.state, pd.processed_at
FROM page_detections pd
WHERE pd.scanned_page_fk = :scanned_page_id;

-- 5) Burbujas detectadas y su mapeo a opciones (incluye verificación de consistencia)
SELECT rm.recognition_mapping_id, rm.scanned_page_fk, bd.bubble_detection_id,
       bd.row_no, bd.col_no, bd.fill_score, bd.is_marked,
       rm.evaluation_question_fk, eq.question_fk,
       rm.evaluation_option_fk, eo.text AS option_text, eo.is_correct,
       CASE WHEN eo.evaluation_question_fk = rm.evaluation_question_fk THEN 'OK' ELSE 'MISMATCH' END AS option_question_consistency
FROM recognition_mappings rm
JOIN bubble_detections bd ON bd.bubble_detection_id = rm.bubble_detection_fk
JOIN evaluation_questions eq ON eq.evaluation_question_id = rm.evaluation_question_fk
JOIN evaluation_options eo ON eo.evaluation_option_id = rm.evaluation_option_fk
WHERE rm.scanned_page_fk = :scanned_page_id
ORDER BY bd.row_no, bd.col_no;

-- 6) Resumen por pregunta (qué opción fue seleccionada por página)
SELECT eq.evaluation_question_id, q.text AS question_text,
       eo.evaluation_option_id, eo.text AS option_text, eo.is_correct,
       rm.confidence, rm.mapping_rule
FROM recognition_mappings rm
JOIN evaluation_questions eq ON eq.evaluation_question_id = rm.evaluation_question_fk
JOIN questions q ON q.question_id = eq.question_fk
JOIN evaluation_options eo ON eo.evaluation_option_id = rm.evaluation_option_fk
WHERE rm.scanned_page_fk = :scanned_page_id
ORDER BY eq.position, eo.position;

-- 7) Resultados listos vs publicados y validaciones de pertenencia (trigger 3)
SELECT ir.ingest_result_id, ir.scanned_page_fk, ir.evaluation_fk, ir.resolved_student_fk,
       s.first_name || ' ' || s.last_name AS student,
       ir.total_marked, ir.state, ir.posted_at
FROM ingest_results ir
LEFT JOIN students s ON s.student_id = ir.resolved_student_fk
WHERE ir.evaluation_fk = :evaluation_id
ORDER BY ir.ingest_result_id;

-- 8) Traza completa: desde selección a imagen (student_answer_options → recognition_mappings → imagen)
-- (Para datasets publicados, esta consulta muestra el link de auditoría hacia la imagen)
SELECT sao.student_answer_option_id, se.student_evaluation_id, e.title,
       q.text AS question_text, eo.text AS option_text, eo.is_correct,
       sp.image_uri
FROM student_answer_options sao
JOIN student_answers sa           ON sa.student_answer_id = sao.student_answer_fk
JOIN student_evaluations se       ON se.student_evaluation_id = sa.student_evaluation_fk
JOIN evaluations e                ON e.evaluation_id = se.evaluation_fk
JOIN evaluation_options eo        ON eo.evaluation_option_id = sao.evaluation_option_fk
JOIN evaluation_questions eq      ON eq.evaluation_question_id = eo.evaluation_question_fk
JOIN recognition_mappings rm      ON rm.evaluation_option_fk = eo.evaluation_option_id
JOIN scanned_pages sp             ON sp.scanned_page_id = rm.scanned_page_fk
JOIN questions q                  ON q.question_id = eq.question_fk
ORDER BY sao.student_answer_option_id;

-- 9) Auditoría de pipeline (jobs + logs) para la página
SELECT pj.processing_job_id, pj.stage, pj.status, pj.started_at, pj.finished_at,
       pl.processing_log_id, pl.level, pl.message
FROM processing_jobs pj
LEFT JOIN processing_logs pl ON pl.processing_job_fk = pj.processing_job_id
WHERE pj.scanned_page_fk = :scanned_page_id
ORDER BY pj.processing_job_id, pl.processing_log_id;

-- 10) Consultas de apoyo: índices esperados (nombres) para comprobar existencia
SELECT indexname, indexdef
FROM pg_indexes
WHERE schemaname = ANY (CURRENT_SCHEMAS(true))
  AND tablename IN ('scanned_pages','page_qrs','bubble_detections','recognition_mappings','ingest_results','processing_jobs','processing_logs')
ORDER BY tablename, indexname;

-- 11) Ejemplos de EXPLAIN (descomentar si desea analizar planes)
-- EXPLAIN ANALYZE
-- SELECT * FROM recognition_mappings WHERE evaluation_question_fk IN (SELECT evaluation_question_id FROM evaluation_questions WHERE evaluation_fk = :evaluation_id);

-- 12) Validación: no debe haber inconsistencias detectables (devolver 0 filas)
-- 12.a) Mapeos donde la opción no corresponde a la pregunta
SELECT rm.recognition_mapping_id
FROM recognition_mappings rm
JOIN evaluation_options eo ON eo.evaluation_option_id = rm.evaluation_option_fk
WHERE eo.evaluation_question_fk <> rm.evaluation_question_fk;

-- 12.b) Burbujas cuya página no coincide con recognition_mappings.scanned_page_fk
SELECT rm.recognition_mapping_id
FROM recognition_mappings rm
JOIN bubble_detections bd  ON bd.bubble_detection_id = rm.bubble_detection_fk
JOIN page_detections pd    ON pd.page_detection_id    = bd.page_detection_fk
WHERE pd.scanned_page_fk <> rm.scanned_page_fk;

-- 13) Vista rápida: respuestas "consolidadas" por estudiante (si ya están publicadas)
-- Nota: En este repo la publicación real a student_answers no está automatizada por trigger.
--       Esta consulta asume que ya existen filas correspondientes; si no, retornará vacío.
SELECT se.student_evaluation_id, s.student_id, s.first_name || ' ' || s.last_name AS student,
       eq.evaluation_question_id, q.text AS question,
       array_agg(eo.text ORDER BY eo.position) AS selected_options
FROM student_answers sa
JOIN student_evaluations se  ON se.student_evaluation_id = sa.student_evaluation_fk
JOIN students s              ON s.student_id = se.student_fk
JOIN evaluation_questions eq ON eq.evaluation_question_id = sa.evaluation_question_fk
JOIN questions q             ON q.question_id = eq.question_fk
LEFT JOIN student_answer_options sao ON sao.student_answer_fk = sa.student_answer_id
LEFT JOIN evaluation_options eo      ON eo.evaluation_option_id = sao.evaluation_option_fk
WHERE se.evaluation_fk = :evaluation_id
GROUP BY se.student_evaluation_id, s.student_id, s.first_name, s.last_name, eq.evaluation_question_id, q.text
ORDER BY s.student_id, eq.evaluation_question_id;
