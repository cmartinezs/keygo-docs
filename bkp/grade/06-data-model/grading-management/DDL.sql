-- ===================================================================
-- (Opcional) Usar schema dedicado
-- ===================================================================
-- CREATE SCHEMA IF NOT EXISTS grade;
-- SET search_path TO grade, public;

-- ===================================================================
-- TABLAS PRINCIPALES (Evaluations Domain)
-- ===================================================================

-- Cursos/Secciones (dueño: users ya existe en Question Bank)
CREATE TABLE IF NOT EXISTS courses (
  course_id   BIGSERIAL PRIMARY KEY,
  name        TEXT NOT NULL,
  code        VARCHAR(64) NOT NULL,
  user_fk     BIGINT NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_by  BIGINT NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
  updated_at  TIMESTAMPTZ NULL,
  updated_by  BIGINT NULL REFERENCES users(user_id) ON DELETE SET NULL,
  deleted_at  TIMESTAMPTZ NULL,
  deleted_by  BIGINT NULL REFERENCES users(user_id) ON DELETE SET NULL,
  CONSTRAINT uq_courses_code UNIQUE (code)
);

-- Estudiantes
CREATE TABLE IF NOT EXISTS students (
  student_id  BIGSERIAL PRIMARY KEY,
  first_name  TEXT NOT NULL,
  last_name   TEXT NOT NULL,
  identifier  VARCHAR(64) NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_by  BIGINT NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
  updated_at  TIMESTAMPTZ NULL,
  updated_by  BIGINT NULL REFERENCES users(user_id) ON DELETE SET NULL,
  deleted_at  TIMESTAMPTZ NULL,
  deleted_by  BIGINT NULL REFERENCES users(user_id) ON DELETE SET NULL,
  CONSTRAINT uq_students_identifier UNIQUE (identifier)
);

-- Matrícula
CREATE TABLE IF NOT EXISTS course_students (
  course_student_id BIGSERIAL PRIMARY KEY,
  course_fk         BIGINT NOT NULL REFERENCES courses(course_id)  ON DELETE RESTRICT,
  student_fk        BIGINT NOT NULL REFERENCES students(student_id) ON DELETE RESTRICT,
  enrolled_on       DATE   NOT NULL DEFAULT CURRENT_DATE,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  created_by        BIGINT NOT NULL REFERENCES users(user_id) ON DELETE RESTRICT,
  updated_at        TIMESTAMPTZ NULL,
  updated_by        BIGINT NULL REFERENCES users(user_id) ON DELETE SET NULL,
  deleted_at        TIMESTAMPTZ NULL,
  deleted_by        BIGINT NULL REFERENCES users(user_id) ON DELETE SET NULL,
  CONSTRAINT uq_course_students UNIQUE (course_fk, student_fk)
);

-- Evaluaciones
CREATE TABLE IF NOT EXISTS evaluations (
  evaluation_id     BIGSERIAL   PRIMARY KEY,
  title             TEXT        NOT NULL,
  scheduled_date    DATE        NOT NULL,
  duration_minutes  INTEGER     NOT NULL,
  grade_scale       VARCHAR(64) NOT NULL, -- ej: "0-100_to_1-7"
  state             VARCHAR(16) NOT NULL, -- Draft/Published/Applied/Graded/Archived
  pdf_path          TEXT,
  course_fk         BIGINT      NOT NULL REFERENCES courses(course_id) ON DELETE RESTRICT,
  user_fk           BIGINT      NOT NULL REFERENCES users(user_id)    ON DELETE RESTRICT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ NULL,
  updated_by        BIGINT NULL REFERENCES users(user_id) ON DELETE SET NULL,
  deleted_at        TIMESTAMPTZ NULL,
  deleted_by        BIGINT NULL REFERENCES users(user_id) ON DELETE SET NULL,
  CONSTRAINT ck_evaluations_duration_pos CHECK (duration_minutes > 0),
  CONSTRAINT ck_evaluations_state CHECK (state IN ('Draft','Published','Applied','Graded','Archived'))
);

CREATE INDEX IF NOT EXISTS idx_evaluations_course_state_date
  ON evaluations (course_fk, state, scheduled_date);

-- Composición de evaluación (ítems)
CREATE TABLE IF NOT EXISTS evaluation_questions (
  evaluation_question_id BIGSERIAL   PRIMARY KEY,
  evaluation_fk          BIGINT      NOT NULL REFERENCES evaluations(evaluation_id) ON DELETE CASCADE,
  question_fk            BIGINT      NOT NULL REFERENCES questions(question_id)     ON DELETE RESTRICT,
  points                 NUMERIC(6,2) NOT NULL,
  position               INTEGER      NOT NULL,
  CONSTRAINT ck_eval_q_points_pos CHECK (points > 0),
  CONSTRAINT ck_eval_q_position_pos CHECK (position >= 1),
  CONSTRAINT uq_eval_q_eval_question UNIQUE (evaluation_fk, question_fk),
  CONSTRAINT uq_eval_q_eval_position UNIQUE (evaluation_fk, position)
);

CREATE INDEX IF NOT EXISTS idx_evaluation_questions_eval_pos
  ON evaluation_questions (evaluation_fk, position);

-- Snapshot de opciones por evaluación
CREATE TABLE IF NOT EXISTS evaluation_options (
  evaluation_option_id    BIGSERIAL   PRIMARY KEY,
  evaluation_question_fk  BIGINT      NOT NULL REFERENCES evaluation_questions(evaluation_question_id) ON DELETE CASCADE,
  text                    TEXT        NOT NULL,
  is_correct              BOOLEAN     NOT NULL DEFAULT FALSE,
  position                INTEGER     NOT NULL,
  score                   NUMERIC(6,3),
  -- trazabilidad (opcional) a la opción fuente del banco
  question_option_fk      BIGINT      REFERENCES question_options(question_option_id) ON DELETE RESTRICT,
  CONSTRAINT ck_eval_opt_position_pos CHECK (position >= 1),
  CONSTRAINT ck_eval_opt_score_nonneg CHECK (score IS NULL OR score >= 0),
  CONSTRAINT uq_eval_opt_text UNIQUE (evaluation_question_fk, text),
  CONSTRAINT uq_eval_opt_position UNIQUE (evaluation_question_fk, position)
);

CREATE INDEX IF NOT EXISTS idx_evaluation_options_eq
  ON evaluation_options (evaluation_question_fk);

-- Rendiciones
CREATE TABLE IF NOT EXISTS student_evaluations (
  student_evaluation_id BIGSERIAL   PRIMARY KEY,
  evaluation_fk         BIGINT      NOT NULL REFERENCES evaluations(evaluation_id) ON DELETE CASCADE,
  student_fk            BIGINT      NOT NULL REFERENCES students(student_id)       ON DELETE RESTRICT,
  total_score           NUMERIC(8,3) NOT NULL DEFAULT 0,
  grade                 NUMERIC(5,2),
  taken_on              TIMESTAMPTZ,
  attempt_no            INTEGER,
  state                 VARCHAR(16),
  CONSTRAINT ck_se_attempt_no CHECK (attempt_no IS NULL OR attempt_no >= 1),
  CONSTRAINT ck_se_total_score_nonneg CHECK (total_score >= 0)
);

-- (Elige una de estas 2 UNIQUE según política de intentos)
-- Un solo intento por evaluación/estudiante:
CREATE UNIQUE INDEX IF NOT EXISTS uq_student_evaluations_single
  ON student_evaluations (evaluation_fk, student_fk)
  WHERE attempt_no IS NULL;

-- Múltiples intentos (si se usa):
-- CREATE UNIQUE INDEX uq_student_evaluations_multi
--   ON student_evaluations (evaluation_fk, student_fk, attempt_no);

CREATE INDEX IF NOT EXISTS idx_student_evaluations_eval_student
  ON student_evaluations (evaluation_fk, student_fk);

-- Respuestas por pregunta de la evaluación
CREATE TABLE IF NOT EXISTS student_answers (
  student_answer_id       BIGSERIAL   PRIMARY KEY,
  student_evaluation_fk   BIGINT      NOT NULL REFERENCES student_evaluations(student_evaluation_id) ON DELETE CASCADE,
  evaluation_question_fk  BIGINT      NOT NULL REFERENCES evaluation_questions(evaluation_question_id) ON DELETE CASCADE,
  points_earned           NUMERIC(6,3) NOT NULL DEFAULT 0,
  CONSTRAINT ck_sa_points_nonneg CHECK (points_earned >= 0),
  CONSTRAINT uq_sa_per_question UNIQUE (student_evaluation_fk, evaluation_question_fk)
);

CREATE INDEX IF NOT EXISTS idx_student_answers_se_eq
  ON student_answers (student_evaluation_fk, evaluation_question_fk);

-- Selección de alternativas (soporta MC)
CREATE TABLE IF NOT EXISTS student_answer_options (
  student_answer_option_id BIGSERIAL PRIMARY KEY,
  student_answer_fk        BIGINT    NOT NULL REFERENCES student_answers(student_answer_id)  ON DELETE CASCADE,
  evaluation_option_fk     BIGINT    NOT NULL REFERENCES evaluation_options(evaluation_option_id) ON DELETE RESTRICT
);

CREATE INDEX IF NOT EXISTS idx_sao_sa
  ON student_answer_options (student_answer_fk);

CREATE INDEX IF NOT EXISTS idx_sao_eval_option
  ON student_answer_options (evaluation_option_fk);
