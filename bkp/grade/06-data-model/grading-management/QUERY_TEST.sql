--1) Evaluaciones, estado y curso
SELECT e.evaluation_id, e.title, e.state, e.scheduled_date,
       c.code AS course_code, u.name AS owner
FROM evaluations e
JOIN courses c ON c.course_id = e.course_fk
JOIN users   u ON u.user_id   = e.user_fk
ORDER BY e.evaluation_id;

--2) Composición de cada evaluación (ítems y puntaje)
SELECT e.title, eq.evaluation_question_id, q.question_id, eq.points, eq.position
FROM evaluation_questions eq
JOIN evaluations e ON e.evaluation_id = eq.evaluation_fk
JOIN questions   q ON q.question_id   = eq.question_fk
ORDER BY e.evaluation_id, eq.position;

--3) Opciones “congeladas” por evaluación/pregunta (con correctas)
SELECT e.title, eq.evaluation_question_id, eo.evaluation_option_id,
       eo.position, eo.text, eo.is_correct
FROM evaluation_options eo
JOIN evaluation_questions eq ON eq.evaluation_question_id = eo.evaluation_question_fk
JOIN evaluations e           ON e.evaluation_id = eq.evaluation_fk
ORDER BY e.evaluation_id, eq.position, eo.position;

--4) Estudiantes matriculados por curso
SELECT c.code AS course_code, s.student_id, s.first_name, s.last_name, s.identifier
FROM course_students cs
JOIN courses  c ON c.course_id   = cs.course_fk
JOIN students s ON s.student_id   = cs.student_fk
ORDER BY c.code, s.last_name, s.first_name;

--5) Intentos por evaluación/estudiante
SELECT e.title, s.first_name || ' ' || s.last_name AS student,
       se.student_evaluation_id, se.state, se.taken_on,
       se.total_score, se.grade
FROM student_evaluations se
JOIN evaluations e ON e.evaluation_id = se.evaluation_fk
JOIN students    s ON s.student_id    = se.student_fk
ORDER BY e.evaluation_id, student;

--6) Respuestas por intento con detalle de selección y corrección
SELECT
  e.title,
  sa.student_evaluation_fk,
  sa.evaluation_question_fk,
  eq.points AS max_points,
  sa.points_earned,
  sao.student_answer_option_id,
  eo.evaluation_option_id,
  eo.text AS option_text,
  eo.is_correct
FROM student_answers sa
JOIN evaluation_questions eq   ON eq.evaluation_question_id  = sa.evaluation_question_fk
JOIN student_evaluations se    ON se.student_evaluation_id   = sa.student_evaluation_fk
JOIN evaluations e             ON e.evaluation_id            = se.evaluation_fk
LEFT JOIN student_answer_options sao ON sao.student_answer_fk = sa.student_answer_id
LEFT JOIN evaluation_options eo      ON eo.evaluation_option_id = sao.evaluation_option_fk
ORDER BY e.evaluation_id, sa.student_evaluation_fk, sa.evaluation_question_fk, eo.position;

--7) Reconteo de puntos (suma por intento) — control de consistencia
SELECT
  se.student_evaluation_id,
  SUM(sa.points_earned) AS recomputed_total,
  se.total_score        AS stored_total
FROM student_answers sa
JOIN student_evaluations se ON se.student_evaluation_id = sa.student_evaluation_fk
GROUP BY se.student_evaluation_id, se.total_score
ORDER BY se.student_evaluation_id;

--8) Aciertos por pregunta (tasa de correctas por EQ)
-- Considera correcta una respuesta cuando todas las opciones seleccionadas son correctas
-- y no se eligieron incorrectas (apto para TF/SC; para MC es una heurística simple).
WITH picks AS (
  SELECT
    sa.student_answer_id,
    sa.evaluation_question_fk,
    BOOL_AND(eo.is_correct) AS all_selected_are_correct,
    SUM(CASE WHEN eo.is_correct THEN 1 ELSE 0 END) AS sel_correct,
    SUM(CASE WHEN eo.is_correct THEN 0 ELSE 1 END) AS sel_wrong
  FROM student_answers sa
  LEFT JOIN student_answer_options sao ON sao.student_answer_fk = sa.student_answer_id
  LEFT JOIN evaluation_options eo      ON eo.evaluation_option_id = sao.evaluation_option_fk
  GROUP BY sa.student_answer_id, sa.evaluation_question_fk
)
SELECT
  e.title,
  eq.evaluation_question_id,
  COUNT(*)                                  AS attempts,
  SUM(CASE WHEN sel_wrong = 0 AND sel_correct >= 1 THEN 1 ELSE 0 END) AS fully_correct_attempts,
  ROUND(100.0 * SUM(CASE WHEN sel_wrong = 0 AND sel_correct >= 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0), 1) AS pct_correct
FROM picks p
JOIN evaluation_questions eq ON eq.evaluation_question_id = p.evaluation_question_fk
JOIN evaluations e           ON e.evaluation_id          = eq.evaluation_fk
GROUP BY e.title, eq.evaluation_question_id
ORDER BY e.title, eq.evaluation_question_id;

--9) Notas por evaluación (muestra básica usando total_score)
SELECT
  e.title,
  s.first_name || ' ' || s.last_name AS student,
  se.total_score,
  se.grade
FROM student_evaluations se
JOIN evaluations e ON e.evaluation_id = se.evaluation_fk
JOIN students    s ON s.student_id    = se.student_fk
ORDER BY e.evaluation_id, student;
