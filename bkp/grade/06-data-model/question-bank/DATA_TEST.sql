-- ============================
-- PRUEBAS QUESTION BANK
-- ============================

-- 1) Insertar datos mínimos de jerarquía curricular y catálogos
INSERT INTO subjects (name, code) VALUES ('Science', 'SCI') RETURNING subject_id;
-- supongamos que devuelve 1

INSERT INTO units (name, subject_fk) VALUES ('The Solar System', 1) RETURNING unit_id;
-- supongamos que devuelve 1

INSERT INTO topics (name, unit_fk) VALUES ('Planets', 1) RETURNING topic_id;
-- supongamos que devuelve 1

INSERT INTO difficulties (level, weight) VALUES ('Easy', 1) RETURNING difficulty_id;
-- supongamos que devuelve 1

INSERT INTO users (name, email, role)
VALUES ('Prof. Newton', 'newton@example.com', 'Teacher') RETURNING user_id;
-- supongamos que devuelve 1

-- Outcomes (opcional)
INSERT INTO outcomes (code, description, subject_fk)
VALUES ('SCI-5.2', 'Identify and count the planets in the Solar System', 1) RETURNING outcome_id;
-- supongamos que devuelve 1

-- Buscar tipos de pregunta creados por semilla
SELECT * FROM question_types;
-- TF = 1, SC = 2, MC = 3 (asumiendo IDs consecutivos)

-- ============================
-- 2) Pregunta tipo True/False
-- ============================
INSERT INTO questions (text, topic_fk, difficulty_fk, outcome_fk, question_type_fk, user_fk)
VALUES ('The Earth is a planet of the Solar System.', 1, 1, 1, 1, 1) RETURNING question_id;
-- supongamos que devuelve 1

-- Opciones correctas
INSERT INTO question_options (text, is_correct, position, question_fk)
VALUES ('True',  TRUE,  1, 1),
       ('False', FALSE, 2, 1);

-- Esto pasa ✔️.
-- Si intentas agregar una 3ª opción, el trigger levantará error.

-- ============================
-- 3) Pregunta tipo Single Choice
-- ============================
INSERT INTO questions (text, topic_fk, difficulty_fk, outcome_fk, question_type_fk, user_fk)
VALUES ('How many planets are in the Solar System?', 1, 1, 1, 2, 1) RETURNING question_id;
-- supongamos que devuelve 2

INSERT INTO question_options (text, is_correct, position, question_fk)
VALUES ('7',  FALSE, 1, 2),
       ('8',  TRUE,  2, 2),
       ('9',  FALSE, 3, 2);

-- Esto pasa ✔️ (3 opciones, exactamente 1 correcta).
-- Si intentas marcar 2 correctas → error.

-- ============================
-- 4) Pregunta tipo Multiple Choice
-- ============================
INSERT INTO questions (text, topic_fk, difficulty_fk, outcome_fk, question_type_fk, user_fk)
VALUES ('Which of the following are gas giants?', 1, 1, 1, 3, 1) RETURNING question_id;
-- supongamos que devuelve 3

INSERT INTO question_options (text, is_correct, position, question_fk)
VALUES ('Jupiter',  TRUE,  1, 3),
       ('Saturn',   TRUE,  2, 3),
       ('Mars',     FALSE, 3, 3),
       ('Neptune',  TRUE,  4, 3);

-- Esto pasa ✔️ (4 opciones, >=1 correctas).

-- ============================
-- 5) Casos de error esperados
-- ============================

-- ERROR: TF con solo 1 opción
INSERT INTO questions (text, topic_fk, difficulty_fk, outcome_fk, question_type_fk, user_fk)
VALUES ('The Sun is a planet.', 1, 1, 1, 1, 1) RETURNING question_id;
-- supongamos que devuelve 4

INSERT INTO question_options (text, is_correct, position, question_fk)
VALUES ('True', FALSE, 1, 4);
-- ❌ ERROR: TF requiere exactamente 2 opciones y 1 correcta.

-- ERROR: SC con 2 correctas
INSERT INTO questions (text, topic_fk, difficulty_fk, outcome_fk, question_type_fk, user_fk)
VALUES ('Which is the largest planet?', 1, 1, 1, 2, 1) RETURNING question_id;
-- supongamos que devuelve 5

INSERT INTO question_options (text, is_correct, position, question_fk)
VALUES ('Earth',   TRUE,  1, 5),
       ('Jupiter', TRUE,  2, 5),
       ('Venus',   FALSE, 3, 5);
-- ❌ ERROR: SC requiere exactamente 1 correcta.

-- ERROR: MC sin correctas
INSERT INTO questions (text, topic_fk, difficulty_fk, outcome_fk, question_type_fk, user_fk)
VALUES ('Which planets have rings?', 1, 1, 1, 3, 1) RETURNING question_id;
-- supongamos que devuelve 6

INSERT INTO question_options (text, is_correct, position, question_fk)
VALUES ('Earth', FALSE, 1, 6),
       ('Mars',  FALSE, 2, 6);
-- ❌ ERROR: MC requiere >=1 correctas.
