# CU-BP-05 — Retirar Ítem

> Este caso de uso describe el proceso para que un Coordinador o Administrador retire (desactive) un ítem del Banco de Preguntas, asegurando que no se utilice en nuevas evaluaciones, pero manteniendo su historial para trazabilidad.

- [Revisión](reviews.md)
- [Volver](../../README.md#1-banco-de-preguntas)

<!-- TOC -->
* [CU-BP-05 — Retirar Ítem](#cu-bp-05--retirar-ítem)
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
  * [Apartado técnico (implementación según DDL)](#apartado-técnico-implementación-según-ddl)
    * [Retiro de ítem (desactivación lógica)](#retiro-de-ítem-desactivación-lógica)
    * [Auditoría soft](#auditoría-soft)
    * [Reactivación](#reactivación)
<!-- TOC -->

## Escenario origen: S-BP-03 | Retirar / reactivar ítem

### RF relacionados: RF2, RF7, RF8

**Actor principal:** Coordinador (o Administrador en casos especiales)  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Coordinador o Administrador marque un ítem como **Inactivo**, de modo que no pueda ser utilizado en nuevas evaluaciones; el ítem no se borra y su historial queda preservado.

### Precondiciones
- Usuario autenticado con permisos de retiro.
- El ítem está actualmente disponible/activo en el Banco de Preguntas.

### Postcondiciones
- El ítem queda en estado **Inactivo** y deja de aparecer en las listas y búsquedas para composición de nuevas evaluaciones.
- El historial de la pregunta conserva el registro de la acción (quién realizó el retiro y cuándo).
- Las evaluaciones ya aplicadas no se ven afectadas.

### Flujo principal (éxito)
1. El Coordinador accede al Banco de preguntas y localiza el ítem.
2. El Coordinador selecciona la opción **“Retirar ítem”**.
3. El Sistema solicita confirmación.
4. El Coordinador confirma la acción.
5. El Sistema marca el ítem como inactivo.
6. El Sistema registra en el historial quién realizó la acción y cuándo.
7. El Sistema confirma que el ítem fue retirado.

### Flujos alternativos / Excepciones
- **A1 — Ítem ya retirado:** El Sistema informa que el ítem ya está inactivo y no realiza cambios.
- **A2 — Ítem en evaluaciones programadas:** El Sistema muestra advertencia y solicita confirmación del retiro, indicando el posible impacto.
- **A3 — Cancelación:** Si el Coordinador cancela en la confirmación, no se modifica el estado.

### Reglas de negocio
- **RN-1:** El retiro no elimina el ítem; lo pone en estado inactivo para que no se use en nuevas evaluaciones.
- **RN-2:** Las evaluaciones ya aplicadas conservan el ítem en su historial.
- **RN-3:** Solo usuarios con rol de Coordinador o Administrador pueden retirar ítems.
- **RN-4:** La acción de retiro debe quedar registrada en el historial con información de quién la realizó y cuándo.

### Datos principales
- **Ítem:** enunciado, versión visible, estado (activo/inactivo) y metadatos pedagógicos (tema, dificultad, tipo, autor, fecha de creación).
- **Historial:** registro de acciones sobre el ítem (quién hizo qué y cuándo); puede incluir motivo si la organización lo decide.

### Consideraciones de seguridad/permiso
- Validar permisos antes de permitir el retiro.
- Registrar en el historial la acción para asegurar trazabilidad.

### No funcionales
- **Disponibilidad:** la acción debe reflejarse inmediatamente en la experiencia de usuario (listados y búsquedas).
- **Historial claro:** el retiro debe quedar registrado de forma que se pueda ver quién lo hizo y cuándo.

### Criterios de aceptación (QA)
- **CA-1:** Al retirar un ítem, pasa a mostrarse como inactivo y deja de aparecer en búsquedas y listados para crear nuevas evaluaciones.
- **CA-2:** Las evaluaciones existentes mantienen acceso al ítem retirado en su historial.
- **CA-3:** La acción de retiro queda registrada con usuario y fecha/hora en el historial del ítem.
- **CA-4:** Intentar retirar un ítem ya inactivo muestra advertencia y no provoca cambios.

---

## Apartado técnico (implementación según DDL)

### Retiro de ítem (desactivación lógica)

El retiro de un ítem se implementa cambiando el campo `active` a `FALSE` y actualizando los campos de auditoría soft. Ejemplo SQL:

```text
-- Retirar ítem (questions)
UPDATE questions
SET active = FALSE,
    updated_at = now(),
    updated_by = :current_user_id
WHERE question_id = :question_id
  AND active = TRUE;
```

- Si el ítem ya está retirado (`active = FALSE`), no se realiza ningún cambio y se informa al usuario.
- El sistema debe filtrar por `active = TRUE` en búsquedas y composición de evaluaciones:

```text
SELECT * FROM questions WHERE active = TRUE AND deleted_at IS NULL;
```

### Auditoría soft
- El retiro NO usa soft delete (`deleted_at`, `deleted_by`), solo desactiva el ítem.
- Los campos `updated_at` y `updated_by` permiten saber quién y cuándo realizó el retiro.
- El historial completo se mantiene en la tabla, sin eliminar registros.

### Reactivación
- Para reactivar un ítem, se puede cambiar `active` a `TRUE` y registrar la acción en auditoría:

```text
UPDATE questions
SET active = TRUE,
    updated_at = now(),
    updated_by = :current_user_id
WHERE question_id = :question_id
  AND active = FALSE;
```

---

[Subir](#cu-bp-05--retirar-ítem)