-- ===================================================================
-- CONSTRAINT TRIGGERS DEFERRABLE — INTEGRIDAD CRÍTICA
-- (Se validan al COMMIT; ideales para operaciones en lote)
-- ===================================================================

-- 1) Guardar que EVALUATION_QUESTIONS solo se edite en Draft
CREATE OR REPLACE FUNCTION fn_guard_edit_eq()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE v_state text;
BEGIN
  SELECT state INTO v_state FROM evaluations
   WHERE evaluation_id = (SELECT evaluation_fk
                          FROM evaluation_questions
                          WHERE evaluation_question_id = COALESCE(NEW.evaluation_question_id, OLD.evaluation_question_id));
  IF v_state IS NULL THEN
    RAISE EXCEPTION 'Evaluation not found';
  END IF;

  IF v_state <> 'Draft' THEN
    RAISE EXCEPTION 'EvaluationQuestions can only be modified in Draft state (current: %)', v_state
      USING ERRCODE = 'check_violation';
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$;

DROP TRIGGER IF EXISTS tr_guard_edit_eq ON evaluation_questions;
CREATE CONSTRAINT TRIGGER tr_guard_edit_eq
AFTER INSERT OR UPDATE OR DELETE ON evaluation_questions
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION fn_guard_edit_eq();

-- 2) Guardar que EVALUATION_OPTIONS:
--    - Se creen solo cuando la evaluación está Published (snapshot).
--    - No se puedan UPDATE/DELETE (inmutables) una vez creadas.
CREATE OR REPLACE FUNCTION fn_guard_eval_options()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE v_eval_id bigint; v_state text;
BEGIN
  SELECT eq.evaluation_fk INTO v_eval_id
  FROM evaluation_questions eq
  WHERE eq.evaluation_question_id = COALESCE(NEW.evaluation_question_fk, OLD.evaluation_question_fk);

  SELECT state INTO v_state FROM evaluations WHERE evaluation_id = v_eval_id;

  IF TG_OP = 'INSERT' THEN
    IF v_state <> 'Published' THEN
      RAISE EXCEPTION 'EvaluationOptions can only be inserted when evaluation is Published (current: %)', v_state
        USING ERRCODE = 'check_violation';
    END IF;
  ELSIF TG_OP IN ('UPDATE','DELETE') THEN
    RAISE EXCEPTION 'EvaluationOptions are immutable once inserted'
      USING ERRCODE = 'check_violation';
  END IF;

  RETURN COALESCE(NEW, OLD);
END;
$$;

DROP TRIGGER IF EXISTS tr_guard_eval_options ON evaluation_options;
CREATE CONSTRAINT TRIGGER tr_guard_eval_options
AFTER INSERT OR UPDATE OR DELETE ON evaluation_options
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION fn_guard_eval_options();

-- 3) Validar que el estudiante esté matriculado en el curso de la evaluación
CREATE OR REPLACE FUNCTION fn_validate_student_membership()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE v_course bigint;
BEGIN
  SELECT e.course_fk INTO v_course
  FROM evaluations e
  WHERE e.evaluation_id = NEW.evaluation_fk;

  IF NOT EXISTS (
    SELECT 1 FROM course_students cs
    WHERE cs.course_fk = v_course AND cs.student_fk = NEW.student_fk
  ) THEN
    RAISE EXCEPTION 'Student % is not enrolled in course % for evaluation %',
      NEW.student_fk, v_course, NEW.evaluation_fk
      USING ERRCODE = 'check_violation';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tr_validate_student_membership ON student_evaluations;
CREATE CONSTRAINT TRIGGER tr_validate_student_membership
AFTER INSERT ON student_evaluations
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION fn_validate_student_membership();

-- 4) Validar que la respuesta pertenezca a la evaluación del intento
--    y que no exceda los puntos de la pregunta
CREATE OR REPLACE FUNCTION fn_validate_student_answer()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE v_eval_from_se bigint;
DECLARE v_eval_from_eq bigint;
DECLARE v_points numeric(6,2);
BEGIN
  SELECT se.evaluation_fk INTO v_eval_from_se
  FROM student_evaluations se
  WHERE se.student_evaluation_id = NEW.student_evaluation_fk;

  SELECT eq.evaluation_fk, eq.points INTO v_eval_from_eq, v_points
  FROM evaluation_questions eq
  WHERE eq.evaluation_question_id = NEW.evaluation_question_fk;

  IF v_eval_from_se IS NULL OR v_eval_from_eq IS NULL OR v_eval_from_se <> v_eval_from_eq THEN
    RAISE EXCEPTION 'Answer must reference a question that belongs to the same evaluation as the attempt'
      USING ERRCODE = 'check_violation';
  END IF;

  IF NEW.points_earned > v_points THEN
    RAISE EXCEPTION 'points_earned (%.3f) cannot exceed question points (%.2f)',
      NEW.points_earned, v_points
      USING ERRCODE = 'check_violation';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tr_validate_student_answer_i ON student_answers;
CREATE CONSTRAINT TRIGGER tr_validate_student_answer_i
AFTER INSERT ON student_answers
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION fn_validate_student_answer();

DROP TRIGGER IF EXISTS tr_validate_student_answer_u ON student_answers;
CREATE CONSTRAINT TRIGGER tr_validate_student_answer_u
AFTER UPDATE OF points_earned, evaluation_question_fk, student_evaluation_fk ON student_answers
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION fn_validate_student_answer();

-- 5) Validar que las opciones elegidas pertenezcan a la misma evaluation_question que la respuesta
CREATE OR REPLACE FUNCTION fn_validate_sao_consistency()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE v_eq_from_sa bigint;
DECLARE v_eq_from_opt bigint;
BEGIN
  SELECT sa.evaluation_question_fk INTO v_eq_from_sa
  FROM student_answers sa
  WHERE sa.student_answer_id = NEW.student_answer_fk;

  SELECT eo.evaluation_question_fk INTO v_eq_from_opt
  FROM evaluation_options eo
  WHERE eo.evaluation_option_id = NEW.evaluation_option_fk;

  IF v_eq_from_sa IS NULL OR v_eq_from_opt IS NULL OR v_eq_from_sa <> v_eq_from_opt THEN
    RAISE EXCEPTION 'Selected evaluation_option does not belong to the same evaluation_question as the answer'
      USING ERRCODE = 'check_violation';
  END IF;

  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tr_validate_sao_consistency ON student_answer_options;
CREATE CONSTRAINT TRIGGER tr_validate_sao_consistency
AFTER INSERT OR UPDATE ON student_answer_options
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION fn_validate_sao_consistency();

-- 6) Validar cardinalidad por tipo de pregunta (TF/SC/MC) en el SNAPSHOT
--    y también la cardinalidad de selección por respuesta del estudiante.
--    (question_types ya existe; se usa questions -> question_types.code)
CREATE OR REPLACE FUNCTION fn_validate_eval_options_cardinality(p_evaluation_question_id BIGINT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE v_qtype_code varchar(8);
DECLARE v_total int;
DECLARE v_correct int;
BEGIN
  SELECT qt.code INTO v_qtype_code
  FROM evaluation_questions eq
  JOIN questions q      ON q.question_id = eq.question_fk
  JOIN question_types qt ON qt.question_type_id = q.question_type_fk
  WHERE eq.evaluation_question_id = p_evaluation_question_id;

  SELECT COUNT(*),
         COALESCE(SUM(CASE WHEN is_correct THEN 1 ELSE 0 END),0)
  INTO v_total, v_correct
  FROM evaluation_options
  WHERE evaluation_question_fk = p_evaluation_question_id;

  IF v_qtype_code = 'TF' THEN
    IF v_total <> 2 OR v_correct <> 1 THEN
      RAISE EXCEPTION 'TF requires exactly 2 options with exactly 1 correct (now: total=%, correct=%)', v_total, v_correct
        USING ERRCODE = 'check_violation';
    END IF;
  ELSIF v_qtype_code = 'SC' THEN
    IF v_total < 2 OR v_correct <> 1 THEN
      RAISE EXCEPTION 'SC requires >=2 options with exactly 1 correct (now: total=%, correct=%)', v_total, v_correct
        USING ERRCODE = 'check_violation';
    END IF;
  ELSIF v_qtype_code = 'MC' THEN
    IF v_total < 2 OR v_correct < 1 THEN
      RAISE EXCEPTION 'MC requires >=2 options with >=1 correct (now: total=%, correct=%)', v_total, v_correct
        USING ERRCODE = 'check_violation';
    END IF;
  ELSE
    RAISE EXCEPTION 'Unknown question type code: %', v_qtype_code
      USING ERRCODE = 'invalid_parameter_value';
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION fn_trigger_validate_eval_options()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  PERFORM fn_validate_eval_options_cardinality(COALESCE(NEW.evaluation_question_fk, OLD.evaluation_question_fk));
  RETURN COALESCE(NEW, OLD);
END;
$$;

DROP TRIGGER IF EXISTS tr_validate_eval_options ON evaluation_options;
CREATE CONSTRAINT TRIGGER tr_validate_eval_options
AFTER INSERT OR UPDATE OR DELETE ON evaluation_options
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION fn_trigger_validate_eval_options();

-- 7) Validar cardinalidad de selección por respuesta (TF/SC = exactamente 1; MC >=1)
CREATE OR REPLACE FUNCTION fn_validate_sao_cardinality(p_student_answer_id BIGINT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE v_eq_id bigint;
DECLARE v_qtype_code varchar(8);
DECLARE v_cnt int;
BEGIN
  SELECT sa.evaluation_question_fk INTO v_eq_id
  FROM student_answers sa
  WHERE sa.student_answer_id = p_student_answer_id;

  SELECT qt.code INTO v_qtype_code
  FROM evaluation_questions eq
  JOIN questions q       ON q.question_id = eq.question_fk
  JOIN question_types qt ON qt.question_type_id = q.question_type_fk
  WHERE eq.evaluation_question_id = v_eq_id;

  SELECT COUNT(*) INTO v_cnt
  FROM student_answer_options
  WHERE student_answer_fk = p_student_answer_id;

  IF v_qtype_code = 'TF' OR v_qtype_code = 'SC' THEN
    IF v_cnt <> 1 THEN
      RAISE EXCEPTION 'TF/SC answers must select exactly 1 option (now: %)', v_cnt
        USING ERRCODE = 'check_violation';
    END IF;
  ELSIF v_qtype_code = 'MC' THEN
    IF v_cnt < 1 THEN
      RAISE EXCEPTION 'MC answers must select at least 1 option'
        USING ERRCODE = 'check_violation';
    END IF;
  ELSE
    RAISE EXCEPTION 'Unknown question type code: %', v_qtype_code
      USING ERRCODE = 'invalid_parameter_value';
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION fn_trigger_validate_sao_cardinality()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  PERFORM fn_validate_sao_cardinality(COALESCE(NEW.student_answer_fk, OLD.student_answer_fk));
  RETURN COALESCE(NEW, OLD);
END;
$$;

DROP TRIGGER IF EXISTS tr_validate_sao_cardinality ON student_answer_options;
CREATE CONSTRAINT TRIGGER tr_validate_sao_cardinality
AFTER INSERT OR UPDATE OR DELETE ON student_answer_options
DEFERRABLE INITIALLY DEFERRED
FOR EACH ROW
EXECUTE FUNCTION fn_trigger_validate_sao_cardinality();

-- TRIGGER GENÉRICO DE AUDITORÍA SOFT

CREATE OR REPLACE FUNCTION update_audit_fields()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW IS DISTINCT FROM OLD THEN
    NEW.updated_at = now();
    BEGIN
      NEW.updated_by = current_setting('app.current_user_id')::BIGINT;
    EXCEPTION WHEN OTHERS THEN
      NEW.updated_by = NULL;
    END;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar a tablas principales
DROP TRIGGER IF EXISTS trg_courses_audit ON courses;
CREATE TRIGGER trg_courses_audit
  BEFORE UPDATE ON courses
  FOR EACH ROW
  EXECUTE FUNCTION update_audit_fields();

DROP TRIGGER IF EXISTS trg_students_audit ON students;
CREATE TRIGGER trg_students_audit
  BEFORE UPDATE ON students
  FOR EACH ROW
  EXECUTE FUNCTION update_audit_fields();

DROP TRIGGER IF EXISTS trg_course_students_audit ON course_students;
CREATE TRIGGER trg_course_students_audit
  BEFORE UPDATE ON course_students
  FOR EACH ROW
  EXECUTE FUNCTION update_audit_fields();

DROP TRIGGER IF EXISTS trg_evaluations_audit ON evaluations;
CREATE TRIGGER trg_evaluations_audit
  BEFORE UPDATE ON evaluations
  FOR EACH ROW
  EXECUTE FUNCTION update_audit_fields();
