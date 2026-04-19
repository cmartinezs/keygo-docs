-- ===================================================================
-- DATA TEST - Gestión de Evaluaciones
-- ===================================================================

-- 1) Curso de prueba
INSERT INTO courses (name, code, user_fk)
VALUES ('Science 5A', 'SCI5A-2025', 1)  -- asumiendo user_id=1 ya existe
RETURNING course_id;

-- Supongamos devuelve course_id = 1

-- 2) Estudiantes
INSERT INTO students (first_name, last_name, identifier)
VALUES ('Juan', 'Pérez', 'STU001'),
       ('Ana',  'García', 'STU002')
RETURNING student_id;

-- Supongamos: Juan=1, Ana=2

-- 3) Matrícula en el curso
INSERT INTO course_students (course_fk, student_fk)
VALUES (1, 1), (1, 2);

-- 4) Evaluaciones
INSERT INTO evaluations (title, scheduled_date, duration_minutes, grade_scale, state, course_fk, user_fk)
VALUES 
  ('Quiz Planets', CURRENT_DATE, 30, '0-100_to_1-7', 'Draft', 1, 1),
  ('Quiz Solar System', CURRENT_DATE + 7, 40, '0-100_to_1-7', 'Draft', 1, 1)
RETURNING evaluation_id;

-- Supongamos eval1=1, eval2=2

-- 5) Composición de cada evaluación (usando preguntas del banco: q1, q2)
INSERT INTO evaluation_questions (evaluation_fk, question_fk, points, position)
VALUES 
  (1, 1, 2.0, 1),
  (1, 2, 3.0, 2),
  (2, 1, 5.0, 1);

-- Supongamos eq1=1, eq2=2, eq3=3

-- 6) Opciones congeladas (simples, copiando manualmente texto)
-- (En producción, esto se llena al "Publicar" copiando de question_options)
INSERT INTO evaluation_options (evaluation_question_fk, text, is_correct, position)
VALUES
  (1, '8 planets', TRUE, 1),
  (1, '9 planets', FALSE, 2),
  (2, 'Mercury', TRUE, 1),
  (2, 'Venus',   TRUE, 2),
  (2, 'Pluto',   FALSE,3),
  (3, 'Earth',   TRUE, 1),
  (3, 'Mars',    TRUE, 2),
  (3, 'Jupiter', TRUE, 3);

-- 7) Rendiciones de alumnos
INSERT INTO student_evaluations (evaluation_fk, student_fk, total_score, grade, taken_on, state)
VALUES
  (1, 1, 0, NULL, now(), 'InProgress'),
  (1, 2, 0, NULL, now(), 'InProgress'),
  (2, 1, 0, NULL, now(), 'InProgress');

-- Supongamos se1=1, se2=2, se3=3

-- 8) Respuestas de estudiantes
INSERT INTO student_answers (student_evaluation_fk, evaluation_question_fk, points_earned)
VALUES
  (1, 1, 2.0),   -- Juan acertó la 1 de eval1
  (1, 2, 1.0),   -- Juan parcial en la 2
  (2, 1, 0.0),   -- Ana falló la 1 de eval1
  (2, 2, 3.0),   -- Ana acertó la 2 de eval1
  (3, 3, 5.0);   -- Juan acertó única pregunta de eval2

-- 9) Opciones elegidas
INSERT INTO student_answer_options (student_answer_fk, evaluation_option_fk)
VALUES
  (1, 1),  -- Juan eligió '8 planets' (correcta)
  (2, 4),  -- Juan eligió 'Venus'
  (3, 2),  -- Ana eligió '9 planets' (incorrecta)
  (4, 3),  -- Ana eligió 'Mercury'
  (5, 7);  -- Juan eligió 'Mars' en eval2

