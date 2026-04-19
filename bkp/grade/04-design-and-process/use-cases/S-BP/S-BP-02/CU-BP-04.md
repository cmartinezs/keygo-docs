# CU-BP-04 — Editar Ítem (No recomendado - Ver nota)

> **IMPORTANTE:** Este caso de uso describe la edición directa de un ítem existente, lo cual **NO es el flujo recomendado** según el modelo de datos actual. El modelo privilegia el **versionado** (CU-BP-02) para mantener trazabilidad completa. La edición directa solo se considera para casos excepcionales bajo política institucional específica.

- [Revisión](reviews.md)
- [Volver](../../README.md#1-banco-de-preguntas)

<!-- TOC -->
* [CU-BP-04 — Editar Ítem (No recomendado - Ver nota)](#cu-bp-04--editar-ítem-no-recomendado---ver-nota)
  * [Escenario origen: S-BP-02 | Editar / versionar / clonar ítem](#escenario-origen-s-bp-02--editar--versionar--clonar-ítem)
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
    * [Consideraciones importantes sobre edición directa](#consideraciones-importantes-sobre-edición-directa)
    * [Por qué el versionado es preferible](#por-qué-el-versionado-es-preferible)
    * [Verificación de uso en evaluaciones (paso 2)](#verificación-de-uso-en-evaluaciones-paso-2)
    * [Ejemplo de implementación (pasos 9 del flujo principal)](#ejemplo-de-implementación-pasos-9-del-flujo-principal)
    * [Recomendación de implementación](#recomendación-de-implementación)
    * [Alternativa recomendada: Sistema de borradores](#alternativa-recomendada-sistema-de-borradores)
    * [Referencias al modelo completo](#referencias-al-modelo-completo)
<!-- TOC -->

## Escenario origen: S-BP-02 | Editar / versionar / clonar ítem

### RF relacionados: RF2, RF7, RF8

**Actor principal:** Coordinador (con permisos especiales)  
**Actores secundarios:** Sistema GRADE

---

> **NOTA IMPORTANTE:** Este caso de uso describe la edición directa de un ítem existente, lo cual **NO es el flujo recomendado** según el modelo de datos actual. El modelo privilegia el **versionado** (CU-BP-02) para mantener trazabilidad completa. La edición directa solo se considera para casos excepcionales bajo política institucional específica.

---

### Objetivo
Permitir que un Coordinador con permisos especiales **modifique directamente un ítem existente** en el Banco de preguntas, cuando la política institucional lo permita y bajo condiciones controladas. Esta operación modifica el registro existente sin crear una nueva versión.

### Precondiciones
- Usuario autenticado con permisos especiales de edición directa (rol Coordinador o superior).
- El ítem existe en el banco y está accesible.
- La política institucional permite edición directa bajo ciertas condiciones.
- El ítem **no ha sido utilizado en evaluaciones aplicadas** (verificación obligatoria).

### Postcondiciones
- El ítem queda actualizado con los cambios realizados en el mismo registro (mismo ID).
- Se registra la modificación en el historial de auditoría.
- Evaluaciones futuras que utilicen el ítem reflejarán la versión editada.
- **RIESGO:** Si el ítem fue usado en evaluaciones previas, se pierde la trazabilidad de qué versión exacta vieron los estudiantes.

### Flujo principal (éxito)
1. El Coordinador accede al Banco de preguntas y selecciona un ítem.
2. El Sistema **verifica** si el ítem ha sido utilizado en evaluaciones aplicadas.
3. Si el ítem **NO** ha sido usado, el Sistema habilita la opción **"Editar directamente"** (con advertencia).
4. El Coordinador confirma que desea editar directamente (aceptando los riesgos).
5. El Sistema muestra el contenido del ítem en modo edición.
6. El Coordinador actualiza enunciado, alternativas y/o metadatos.
7. El Coordinador guarda los cambios.
8. El Sistema valida:
   - Campos obligatorios completos.
   - Metadatos existen en catálogos vigentes.
   - Cardinalidad de opciones según tipo de pregunta.
   - Al menos una alternativa marcada como correcta.
9. El Sistema:
   - Actualiza el registro existente (mismo `question_id`).
   - Actualiza las opciones asociadas.
   - Registra en auditoría: usuario, fecha/hora, campos modificados.
   - Re-indexa para búsqueda.
10. El Sistema confirma la edición exitosa con advertencia sobre el impacto.

### Flujos alternativos / Excepciones
- **A1 — Ítem en uso en evaluaciones aplicadas:** El Sistema **bloquea** la edición directa y sugiere obligatoriamente usar **Versionar** (CU-BP-02).
- **A2 — Datos incompletos:** El Sistema marca errores y no permite guardar hasta corregir.
- **A3 — Metadato inválido:** Bloquear guardado con mensaje explicativo.
- **A4 — Cancelación:** Si el Coordinador cancela antes de guardar, no se registran cambios.
- **A5 — Usuario sin permisos especiales:** El Sistema deniega el acceso y registra el intento.

### Reglas de negocio
- **RN-1:** La edición directa **solo** está permitida para ítems que **NO** han sido utilizados en evaluaciones aplicadas.
- **RN-2:** Solo usuarios con rol Coordinador o superior y permisos especiales pueden editar directamente.
- **RN-3:** Todo cambio directo debe quedar registrado en el historial de auditoría (usuario, fecha, campos modificados, valores anteriores).
- **RN-4:** El sistema debe advertir claramente al usuario sobre los riesgos de la edición directa versus versionado.
- **RN-5:** La política por defecto del sistema debe favorecer el **versionado** sobre la edición directa.
- **RN-6:** No se debe alterar el campo `version` ni `original_question_fk` en una edición directa.

### Datos principales
- **Pregunta**: Identificador (sin cambio), enunciado, metadatos, autor original, fecha de creación original, versión (sin cambio).
- **Alternativas**: Actualizadas in-place o reemplazadas.
- **Auditoría**: Usuario editor, acción, fecha/hora, campos modificados, valores anteriores y nuevos.

### Consideraciones de seguridad/permiso
- Edición directa restringida a roles con permisos especiales explícitos.
- Todo intento de edición no autorizado debe quedar registrado y bloqueado.
- Se recomienda implementar un flag de configuración institucional que permita habilitar/deshabilitar esta funcionalidad.

### No funcionales
- **Usabilidad:** Interfaz debe distinguir claramente entre *Editar directamente* (riesgoso) y *Versionar* (recomendado).
- **Rendimiento:** Edición y guardado deben completarse en menos de 2 segundos en el 95% de los casos.
- **Trazabilidad:** Los cambios deben reflejarse inmediatamente en listados y búsquedas.
- **Auditoría:** Debe registrarse de forma diferenciada de otras operaciones (crear, versionar, clonar).

### Criterios de aceptación (QA)
- **CA-1:** Al intentar editar un ítem nunca usado, el sistema permite la edición con advertencia clara.
- **CA-2:** Al intentar editar un ítem usado en evaluaciones aplicadas, el Sistema bloquea y sugiere versionado.
- **CA-3:** Con permisos de Coordinador, el usuario puede editar un ítem elegible y el cambio queda registrado en auditoría con valores anteriores y nuevos.
- **CA-4:** Sin permisos especiales, cualquier usuario ve solo las opciones "Versionar" o "Clonar", nunca "Editar directamente".
- **CA-5:** La auditoría muestra claramente que fue una edición directa (no versionado) y quién la realizó.
- **CA-6:** El `question_id` y `version` del ítem permanecen sin cambios después de la edición.

---

## Anexo Técnico (para desarrollo)

> Esta sección contiene los detalles técnicos de implementación según el modelo de datos del sistema GRADE.

### Consideraciones importantes sobre edición directa

El modelo de datos actual **NO incluye un campo "estado" o "borrador"**. Todas las preguntas se crean con `active = true`. Por lo tanto, **la edición directa presenta riesgos significativos de pérdida de trazabilidad** si el ítem ya fue utilizado en evaluaciones.

### Por qué el versionado es preferible

| Aspecto | Edición Directa (CU-BP-04) | Versionado (CU-BP-02) |
|---------|---------------------------|----------------------|
| **Trazabilidad** | ❌ Se pierde historial | ✅ Historial completo preservado |
| **Seguridad** | ⚠️ Riesgo de alterar evaluaciones pasadas | ✅ Evaluaciones pasadas intactas |
| **ID** | Mismo `question_id` | Nuevo `question_id` |
| **Versión** | Sin cambio | Incrementa (v2, v3...) |
| **Auditoría** | Requiere log detallado de cambios | Implícita en el linaje |
| **Recomendación** | ⚠️ Solo casos excepcionales | ✅ **Flujo estándar recomendado** |

### Verificación de uso en evaluaciones (paso 2)

Antes de permitir la edición directa, **debe verificarse** que el ítem no ha sido utilizado:

```sql
-- Verificar si la pregunta ha sido usada en evaluaciones
-- (Esto asume que existe un módulo de evaluaciones con tabla evaluation_questions)
SELECT EXISTS (
    SELECT 1 
    FROM evaluation_questions eq
    JOIN evaluations e ON eq.evaluation_fk = e.evaluation_id
    WHERE eq.question_fk = :question_id
      AND e.status IN ('APPLIED', 'CLOSED', 'PUBLISHED')
) AS is_used_in_evaluations;

-- Si is_used_in_evaluations = true → BLOQUEAR edición directa
-- Si is_used_in_evaluations = false → PERMITIR pero con advertencia
```

### Ejemplo de implementación (pasos 9 del flujo principal)

```sql
BEGIN;

-- 1. Guardar valores anteriores para auditoría (opcional, para log externo)
SELECT 
    text, topic_fk, difficulty_fk, outcome_fk, question_type_fk
INTO @old_text, @old_topic, @old_difficulty, @old_outcome, @old_type
FROM questions
WHERE question_id = :question_id;

-- 2. Actualizar el ítem existente (mismo ID, misma versión)
-- IMPORTANTE: Los campos updated_at y updated_by se actualizan automáticamente
UPDATE questions
SET 
    text = :new_text,
    topic_fk = :new_topic_id,
    difficulty_fk = :new_difficulty_id,
    outcome_fk = :new_outcome_id,
    question_type_fk = :new_question_type_id,
    updated_at = now(),              -- Registra cuándo se modificó
    updated_by = :current_user_id    -- Registra quién modificó
    -- NO actualizar: question_id, version, original_question_fk, user_fk, created_at
WHERE question_id = :question_id;

-- 3. Eliminar opciones anteriores
DELETE FROM question_options
WHERE question_fk = :question_id;

-- 4. Insertar nuevas opciones
INSERT INTO question_options (
    text, is_correct, position, score, question_fk
) VALUES 
    ('Opción 1 editada', false, 1, NULL, :question_id),
    ('Opción 2 editada', true, 2, NULL, :question_id),
    ('Opción 3 editada', false, 3, NULL, :question_id),
    ('Opción 4 editada', false, 4, NULL, :question_id);

COMMIT;
```

**Nota sobre auditoría**: La edición directa actualiza `updated_at` y `updated_by`, pero:
- **NO** cambia `user_fk` (sigue siendo el autor original)
- **NO** cambia `created_at` (sigue siendo la fecha de creación original)
- **NO** cambia `version` (mantiene el mismo número de versión)

Esto permite distinguir entre:
- **Quién creó** el ítem originalmente (`user_fk` + `created_at`)
- **Quién lo modificó** por última vez (`updated_by` + `updated_at`)

### Recomendación de implementación

**Opción 1: Deshabilitar edición directa completamente**
```javascript
// Configuración del sistema
const ALLOW_DIRECT_EDIT = false; // Forzar siempre versionado

if (!ALLOW_DIRECT_EDIT) {
    // Solo mostrar opciones: "Crear nueva versión" y "Clonar"
    // Nunca mostrar "Editar directamente"
}
```

**Opción 2: Permitir solo para ítems nunca usados**
```javascript
// Lógica de negocio
if (question.isUsedInEvaluations()) {
    throw new Error('Cannot directly edit: question already used. Please create a new version.');
}

if (!user.hasRole('COORDINATOR') || !user.hasPermission('DIRECT_EDIT')) {
    throw new Error('Insufficient permissions for direct edit.');
}

// Mostrar advertencia prominente antes de permitir edición
showWarning('Direct edit will modify the original question. Consider versioning instead.');
```

### Alternativa recomendada: Sistema de borradores

Si se requiere un flujo de edición más flexible, se recomienda **extender el modelo** con una tabla de borradores:

```sql
CREATE TABLE question_drafts (
    draft_id BIGSERIAL PRIMARY KEY,
    based_on_question_fk BIGINT REFERENCES questions(question_id),
    user_fk BIGINT NOT NULL REFERENCES users(user_id),
    draft_data JSONB NOT NULL,  -- Contenido completo del borrador
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    status VARCHAR(20) NOT NULL DEFAULT 'DRAFT'  -- 'DRAFT', 'PUBLISHED', 'DISCARDED'
);
```

Esto permitiría:
- Trabajar en borradores sin afectar el ítem publicado
- Múltiples usuarios trabajando en paralelo
- Previsualización antes de publicar
- Cuando se publica, se crea una nueva versión (CU-BP-02)

### Referencias al modelo completo
- [Modelo Entidad-Relación completo](../../../../06-data-model/question-bank/mer.md)
- [Script DDL de creación](../../../../06-data-model/question-bank/DDL.sql)
- [Triggers y funciones](../../../../06-data-model/question-bank/TRIGGERS.sql)

---

[Subir](#cu-bp-04--editar-ítem-no-recomendado---ver-nota)
