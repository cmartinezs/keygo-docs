-- =========================================================
-- TRIGGERS — Integridad por tipo de pregunta (TF/SC/MC)
-- =========================================================
-- Reglas:
--   TF: exactamente 2 opciones y exactamente 1 correcta
--   SC: >= 2 opciones y exactamente 1 correcta
--   MC: >= 2 opciones y >= 1 correcta
-- Se valida después de cambios en question_options y al cambiar el tipo de pregunta.

CREATE OR REPLACE FUNCTION fn_validate_question_options(p_question_id BIGINT)
RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE
  v_qtype_code  VARCHAR(8);
  v_total       INTEGER;
  v_correct     INTEGER;
BEGIN
  SELECT qt.code
    INTO v_qtype_code
  FROM questions q
  JOIN question_types qt ON qt.question_type_id = q.question_type_fk
  WHERE q.question_id = p_question_id;

  IF v_qtype_code IS NULL THEN
    RETURN; -- pregunta inexistente por cascada
  END IF;

  SELECT COUNT(*),
         COALESCE(SUM(CASE WHEN is_correct THEN 1 ELSE 0 END), 0)
    INTO v_total, v_correct
  FROM question_options
  WHERE question_fk = p_question_id;

  IF v_qtype_code = 'TF' THEN
    IF v_total <> 2 OR v_correct <> 1 THEN
      RAISE EXCEPTION
        'Question % (TF) must have exactly 2 options and exactly 1 correct (now: total=%, correct=%)',
        p_question_id, v_total, v_correct
        USING ERRCODE = 'check_violation';
    END IF;

  ELSIF v_qtype_code = 'SC' THEN
    IF v_total < 2 OR v_correct <> 1 THEN
      RAISE EXCEPTION
        'Question % (SC) must have >=2 options and exactly 1 correct (now: total=%, correct=%)',
        p_question_id, v_total, v_correct
        USING ERRCODE = 'check_violation';
    END IF;

  ELSIF v_qtype_code = 'MC' THEN
    IF v_total < 2 OR v_correct < 1 THEN
      RAISE EXCEPTION
        'Question % (MC) must have >=2 options and >=1 correct (now: total=%, correct=%)',
        p_question_id, v_total, v_correct
        USING ERRCODE = 'check_violation';
    END IF;

  ELSE
    RAISE EXCEPTION 'Unknown question type code: %', v_qtype_code
      USING ERRCODE = 'invalid_parameter_value';
  END IF;
END;
$$;

CREATE OR REPLACE FUNCTION trg_question_options_audit()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
  v_qid BIGINT;
BEGIN
  IF TG_OP IN ('INSERT','UPDATE') THEN
    v_qid := NEW.question_fk;
  ELSE
    v_qid := OLD.question_fk;
  END IF;

  PERFORM fn_validate_question_options(v_qid);
  RETURN COALESCE(NEW, OLD);
END;
$$;

DROP TRIGGER IF EXISTS tr_question_options_audit ON question_options;
CREATE TRIGGER tr_question_options_audit
AFTER INSERT OR UPDATE OR DELETE ON question_options
FOR EACH ROW
EXECUTE FUNCTION trg_question_options_audit();

CREATE OR REPLACE FUNCTION trg_questions_guard_qtype()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  IF TG_OP = 'UPDATE' AND NEW.question_type_fk <> OLD.question_type_fk THEN
    -- Validar con las opciones existentes frente al nuevo tipo
    PERFORM fn_validate_question_options(OLD.question_id);
  END IF;
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS tr_questions_guard_qtype ON questions;
CREATE TRIGGER tr_questions_guard_qtype
BEFORE UPDATE OF question_type_fk ON questions
FOR EACH ROW
EXECUTE FUNCTION trg_questions_guard_qtype();
