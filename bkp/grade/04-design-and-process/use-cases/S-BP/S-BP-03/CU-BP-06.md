# CU-BP-06 — Reactivar Ítem

> Este caso de uso describe el proceso para que un Coordinador o Administrador reactive (vuelva a activar) un ítem previamente retirado en el Banco de Preguntas, devolviéndolo a disponibilidad para futuras evaluaciones.

- [Revisión](reviews.md)
- [Volver](../../README.md#1-banco-de-preguntas)

<!-- TOC -->
* [CU-BP-06 — Reactivar Ítem](#cu-bp-06--reactivar-ítem)
  * [Escenario origen: S-BP-03 | Retirar / reactivar ítem](#escenario-origen-s-bp-03--retirar--reactivar-ítem)
    * [RF relacionados: RF2, RF7, RF8](#rf-relacionados-rf2-rf7-rf8)
    * [Objetivo](#objetivo)
    * [Precondiciones](#precondiciones)
    * [Postcondiciones](#postcondiciones)
    * [Flujo principal (éxito)](#flujo-principal-éxito)
    * [Flujos alternativos / Excepciones](#flujos-alternativos--excepciones)
    * [Reglas de negocio](#reglas-de-negocio)
    * [Datos principales](#datos-principales)
    * [Consideraciones de seguridad/permiso](#consideraciones-de-seguridadpermiso)
    * [No funcionales](#no-funcionales)
    * [Criterios de aceptación (QA)](#criterios-de-aceptación-qa)
  * [Anexo Técnico (para desarrollo)](#anexo-técnico-para-desarrollo)
    * [Resumen del modelo de datos (relevante para reactivación)](#resumen-del-modelo-de-datos-relevante-para-reactivación)
    * [Comportamiento esperado según DDL/Auditoría](#comportamiento-esperado-según-ddlauditoría)
    * [SQL de ejemplo (operación atómica)](#sql-de-ejemplo-operación-atómica)
    * [Validaciones y condiciones de negocio en la capa de datos](#validaciones-y-condiciones-de-negocio-en-la-capa-de-datos)
    * [Registro de motivo (inconsistencia detectada vs documento original)](#registro-de-motivo-inconsistencia-detectada-vs-documento-original)
    * [Índices recomendados](#índices-recomendados)
    * [Ejemplo de API (pseudo-código)](#ejemplo-de-api-pseudo-código)
    * [Referencias al modelo completo](#referencias-al-modelo-completo)
<!-- TOC -->

## Escenario origen: S-BP-03 | Retirar / reactivar ítem

### RF relacionados: RF2, RF7, RF8

**Actor principal:** Coordinador (o Administrador en casos especiales)  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Coordinador o Administrador cambie el estado de un ítem previamente retirado a **Activo**, devolviéndolo a búsquedas y habilitándolo para uso en futuras evaluaciones.

### Precondiciones
- Usuario autenticado con permisos de reactivación (por ejemplo, rol Coordinador o Administrador).
- El ítem se encuentra retirado/inactivo en el Banco de Preguntas.

### Postcondiciones
- El ítem queda en estado **Activo** y vuelve a estar disponible para búsquedas y selección en evaluaciones.
- La acción de reactivación queda registrada en el historial de la pregunta (quién la reactivó y cuándo).

### Flujo principal (éxito)
1. El Coordinador accede al Banco de preguntas y localiza un ítem retirado.
2. El Coordinador selecciona la opción **“Reactivar ítem”**.
3. El Sistema solicita confirmación y (opcionalmente) un motivo de reactivación.
4. El Coordinador confirma la acción.
5. El Sistema valida que el usuario tenga permisos para reactivar y que el ítem esté efectivamente retirado.
6. El Sistema realiza la reactivación y registra la operación en el historial de la pregunta.
7. El Sistema confirma al usuario que el ítem fue reactivado y vuelve a mostrarlo en listados y búsquedas.

### Flujos alternativos / Excepciones
- **A1 — Ítem ya activo:** Si el ítem ya está activo, el Sistema informa que no puede reactivarse nuevamente y no realiza cambios.
- **A2 — Cancelación:** Si el Coordinador cancela en la confirmación, no se modifica el estado.
- **A3 — Permisos insuficientes:** Si el usuario no tiene permiso para reactivar ítems, se deniega la operación y se registra el intento.

### Reglas de negocio
- **RN-1:** La reactivación devuelve el ítem a estado **Activo** sin alterar su historial ni la versión visible del ítem.
- **RN-2:** Solo usuarios con los roles autorizados (Coordinador o Administrador) pueden reactivar ítems.
- **RN-3:** La operación debe registrarse con información de trazabilidad (usuario y fecha/hora de la acción).

### Datos principales
- **Ítem:** Identificador, enunciado, versión y estado (activo/inactivo), más sus metadatos pedagógicos (tema, dificultad, tipo, autor, fecha de creación).
- **Historial / auditoría:** Registro de acciones sobre el ítem (quién hizo qué y cuándo); puede incluir motivo si la organización lo decide.

### Consideraciones de seguridad/permiso
- Validar permisos del usuario antes de permitir la reactivación.
- Todas las reactivaciones deben quedar registradas en el historial del ítem para trazabilidad.

### No funcionales
- **Disponibilidad:** la reactivación debe reflejarse de forma inmediata en la experiencia de usuario (listados/búsquedas).
- **Trazabilidad:** el historial debe mostrar claramente quién reactivó el ítem y cuándo.

### Criterios de aceptación (QA)
- **CA-1:** Al reactivar un ítem, pasa a mostrarse como activo y es encontrable en búsquedas y listados.
- **CA-2:** La acción de reactivación queda registrada con usuario y fecha/hora; si se captura un motivo, también debe quedar registrado.
- **CA-3:** Intentar reactivar un ítem ya activo muestra advertencia y no provoca cambios.

---

## Anexo Técnico (para desarrollo)

> Detalles técnicos y referencias al modelo DDL para implementar la reactivación de ítems.

### Resumen del modelo de datos (relevante para reactivación)

Entidades involucradas:
- `questions`: registro principal del ítem. Campos clave para reactivación: `question_id`, `active` (BOOLEAN), `deleted_at` (TIMESTAMPTZ), `deleted_by` (BIGINT), `updated_at`, `updated_by`, `user_fk` (creador).
- `users`: contiene `user_id` y `role` (valores esperados: `Admin`, `Coordinator`, `Teacher`).
- `question_options`: detalle de opciones; la reactivación no altera estas filas salvo que existan reglas adicionales.

### Comportamiento esperado según DDL/Auditoría
- El sistema utiliza auditoría soft: los registros no se borran físicamente; cuando se retira un ítem se marca con `deleted_at` y `deleted_by` (y/o `active = false`). Para recuperar:
  - `deleted_at` y `deleted_by` deben ponerse a NULL.
  - `active` debe establecerse a `true`.
  - `updated_at` y `updated_by` deben reflejar la acción de reactivación.
- No existe un campo textual `motivo` en `questions` por lo que cualquier motivo debe guardarse en la capa de auditoría (tabla `audit_logs` o similar).

### SQL de ejemplo (operación atómica)

-- Validación previa (leer estado y permisos)
SELECT active, deleted_at FROM questions WHERE question_id = :question_id;
SELECT role FROM users WHERE user_id = :current_user_id;

-- Reactivación (ejecutar dentro de transacción y después de validar permisos)
UPDATE questions
SET
    deleted_at = NULL,
    deleted_by = NULL,
    active = TRUE,
    updated_at = now(),
    updated_by = :current_user_id
WHERE question_id = :question_id
  AND (deleted_at IS NOT NULL OR active = FALSE);

-- Opcional: insertar un registro en una tabla de auditoría detallada
INSERT INTO audit_logs (entity, entity_id, action, user_id, reason, created_at)
VALUES ('question', :question_id, 'reactivate', :current_user_id, :reason, now());

-- Nota: `audit_logs` es una tabla propuesta si se requiere almacenar `reason` o metadatos extra.

### Validaciones y condiciones de negocio en la capa de datos
- Verificar que el usuario tenga `role IN ('Admin','Coordinator')` antes de ejecutar el UPDATE (esto puede hacerse en la capa de aplicación o mediante una función/rol en DB).
- Comprobar que la pregunta existe y que actualmente está inactiva (`deleted_at IS NOT NULL OR active = FALSE`). Si ya está activa, devolver un error de tipo 409 (Conflict) con mensaje claro.
- La operación debe ser atómica y disparar las actualizaciones de índices/servicios de búsqueda (indexación eventual o inmediata según implementación).

### Registro de motivo (inconsistencia detectada vs documento original)
- El documento original menciona que la auditoría registra `motivo`; el modelo DDL actual no tiene campo `motivo` en `questions`.
- Recomendación: si `motivo` es obligatorio en la operación, implementar una tabla `audit_logs` o `question_state_changes` con campos: `log_id`, `question_id`, `action` (reactivate/retire), `user_id`, `reason` (TEXT), `created_at`.

### Índices recomendados
- `idx_questions_topic_active` ya existe y permite filtrar por `topic_fk` y `active`.
- Asegurar índices en filtros por `deleted_at` si hay consultas frecuentes que listan elementos retirados.

### Ejemplo de API (pseudo-código)

async function reactivateQuestion(questionId, currentUser) {
  // 1. Verificar rol
  if (!['Admin','Coordinator'].includes(currentUser.role)) throw new Error('PERMISSION_DENIED');

  // 2. Leer estado
  const q = await db.query('SELECT active, deleted_at FROM questions WHERE question_id = $1', [questionId]);
  if (!q.rowCount) throw new Error('NOT_FOUND');
  if (q.rows[0].active && q.rows[0].deleted_at == null) throw new Error('ALREADY_ACTIVE');

  // 3. Ejecutar reactivación dentro de transacción
  await db.query('BEGIN');
  await db.query(`UPDATE questions
    SET deleted_at = NULL, deleted_by = NULL, active = TRUE, updated_at = now(), updated_by = $1
    WHERE question_id = $2`, [currentUser.user_id, questionId]);

  // Opcional: registrar motivo
  // await db.query('INSERT INTO audit_logs (...) VALUES (...)', [...]);
  await db.query('COMMIT');
}

### Referencias al modelo completo
- [MER del Banco de Preguntas](../../../../06-data-model/question-bank/mer.md)
- [DDL del Banco de Preguntas](../../../../06-data-model/question-bank/DDL.sql)
- [Guía de Auditoría Soft](../../../../06-data-model/AUDIT.md)

---

[Subir](#cu-bp-06--reactivar-ítem)