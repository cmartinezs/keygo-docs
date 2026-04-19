# CU-BP-13 — Eliminar elemento de taxonomía curricular

> Este caso de uso detalla el proceso para que un Administrador elimine elementos en la jerarquía curricular (asignatura, unidad o tema) del Banco de Preguntas, basado en el escenario S-BP-06 | Gestionar taxonomías curriculares.

- [Revisión](reviews.md)
- [Volver](../../README.md#1-banco-de-preguntas)

<!-- TOC -->
* [CU-BP-13 — Eliminar elemento de taxonomía curricular](#cu-bp-13--eliminar-elemento-de-taxonomía-curricular)
  * [Escenario origen: S-BP-06 | Gestionar taxonomías curriculares](#escenario-origen-s-bp-06--gestionar-taxonomías-curriculares)
    * [RF relacionados: RF2, RF7, RF13](#rf-relacionados-rf2-rf7-rf13)
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
    * [Estrategias de eliminación por tipo](#estrategias-de-eliminación-por-tipo)
    * [Validación de dependencias](#validación-de-dependencias)
    * [Eliminación lógica (soft delete)](#eliminación-lógica-soft-delete)
    * [Manejo de elementos dependientes](#manejo-de-elementos-dependientes)
    * [Auditoría y trazabilidad](#auditoría-y-trazabilidad)
    * [Consideraciones de implementación](#consideraciones-de-implementación)
<!-- TOC -->

## Escenario origen: S-BP-06 | Gestionar taxonomías curriculares

### RF relacionados: RF2, RF7, RF13

**Actor principal:** Administrador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Administrador elimine elementos obsoletos o no vigentes de la jerarquía curricular (asignatura, unidad o tema), garantizando que los elementos dependientes y preguntas asociadas no pierdan trazabilidad. La jerarquía utilizada es: **Asignatura > Unidad > Tema**. La eliminación es lógica para preservar integridad referencial.

### Precondiciones
- Usuario autenticado con rol de Administrador.
- El elemento seleccionado existe y está activo.
- Se han evaluado las dependencias del elemento (elementos hijos y preguntas asociadas).

### Postcondiciones
- El elemento cambia a estado **Inactivo** (eliminación lógica).
- Los elementos dependientes mantienen referencia histórica pero quedan inaccesibles para nuevas operaciones.
- Las preguntas asociadas conservan su clasificación histórica.
- Se registra la auditoría de eliminación.

### Flujo principal (éxito)
1. El Administrador accede al módulo de taxonomías curriculares.
2. Selecciona un elemento existente (asignatura, unidad o tema) para eliminar.
3. El Sistema muestra información de impacto:
   - Cantidad de elementos hijos que serán afectados
   - Cantidad de preguntas que perderán clasificación activa
4. El Sistema solicita confirmación explícita del administrador.
5. El Administrador confirma la eliminación.
6. El Sistema ejecuta eliminación lógica en cascada:
   - Marca el elemento como inactivo
   - Marca elementos hijos como inactivos (si aplica)
   - Mantiene preguntas con referencia histórica
7. El Sistema registra la auditoría de eliminación.
8. El Sistema confirma eliminación exitosa.

### Flujos alternativos / Excepciones
- **A1 — Elemento con dependencias críticas:** El Sistema permite solo inactivación, no eliminación física, mostrando el impacto completo.
- **A2 — Cancelación:** Si el Administrador cancela, no se modifica ningún estado.
- **A3 — Elemento ya inactivo:** El Sistema informa que el elemento ya está eliminado lógicamente.
- **A4 — Error de integridad:** Si hay problemas técnicos, se revierte toda la operación.

### Reglas de negocio
- **RN-1:** Nunca se elimina físicamente un elemento con dependencias (elementos hijos o preguntas asociadas).
- **RN-2:** La eliminación siempre es lógica (`active = FALSE`, `deleted_at`, `deleted_by`).
- **RN-3:** Al eliminar una asignatura, todas sus unidades y temas quedan inactivos en cascada.
- **RN-4:** Al eliminar una unidad, todos sus temas quedan inactivos en cascada.
- **RN-5:** Al eliminar un tema, las preguntas asociadas mantienen la referencia pero no pueden clasificarse nuevas preguntas con ese tema.
- **RN-6:** La eliminación debe quedar registrada en auditoría con motivo y usuario.

### Datos principales
- **Asignatura** (`subject_id`, `name`, `code`, `active`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`)
- **Unidad** (`unit_id`, `name`, `subject_fk`, `active`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`)
- **Tema** (`topic_id`, `name`, `unit_fk`, `active`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`)

### Consideraciones de seguridad/permiso
- Solo usuarios con rol de Administrador pueden eliminar elementos curriculares.
- Se requiere confirmación explícita debido al impacto en cascada.
- Se registra trazabilidad completa de quién y cuándo elimina cada elemento.

### No funcionales
- **Disponibilidad:** Los cambios deben reflejarse inmediatamente en formularios de creación/búsqueda.
- **Trazabilidad:** Elementos eliminados deben conservar referencia histórica para reportes.
- **Integridad:** Operación atómica para eliminaciones en cascada.

### Criterios de aceptación (QA)
- **CA-1:** Al eliminar una asignatura, esta desaparece de formularios de creación pero se mantiene en históricos.
- **CA-2:** Al eliminar una unidad, sus temas también se marcan como inactivos automáticamente.
- **CA-3:** Las preguntas clasificadas con elementos eliminados siguen mostrando la taxonomía en reportes históricos.
- **CA-4:** La eliminación queda registrada en auditoría con timestamp y usuario.
- **CA-5:** Elementos eliminados no aparecen en selectores para nuevas clasificaciones.

---

## Anexo Técnico (para desarrollo)

> Implementación de eliminación lógica segura con manejo de dependencias jerárquicas.

### Estrategias de eliminación por tipo

**Asignaturas (`subjects`) - Eliminación en cascada**
```sql
-- Verificar dependencias
SELECT 
  (SELECT COUNT(*) FROM units WHERE subject_fk = :subject_id AND active = TRUE) as units_count,
  (SELECT COUNT(*) FROM questions q 
   JOIN topics t ON q.topic_fk = t.topic_id 
   JOIN units u ON t.unit_fk = u.unit_id 
   WHERE u.subject_fk = :subject_id) as questions_count;

-- Eliminación lógica en cascada (transacción)
BEGIN;
  -- Marcar temas como inactivos
  UPDATE topics SET active = FALSE, deleted_at = NOW(), deleted_by = :user_id
  WHERE unit_fk IN (SELECT unit_id FROM units WHERE subject_fk = :subject_id);
  
  -- Marcar unidades como inactivas
  UPDATE units SET active = FALSE, deleted_at = NOW(), deleted_by = :user_id
  WHERE subject_fk = :subject_id;
  
  -- Marcar asignatura como inactiva
  UPDATE subjects SET active = FALSE, deleted_at = NOW(), deleted_by = :user_id
  WHERE subject_id = :subject_id;
COMMIT;
```

**Unidades (`units`) - Eliminación con temas**
```sql
-- Verificar dependencias
SELECT 
  (SELECT COUNT(*) FROM topics WHERE unit_fk = :unit_id AND active = TRUE) as topics_count,
  (SELECT COUNT(*) FROM questions q 
   JOIN topics t ON q.topic_fk = t.topic_id 
   WHERE t.unit_fk = :unit_id) as questions_count;

-- Eliminación lógica en cascada
BEGIN;
  -- Marcar temas como inactivos
  UPDATE topics SET active = FALSE, deleted_at = NOW(), deleted_by = :user_id
  WHERE unit_fk = :unit_id;
  
  -- Marcar unidad como inactiva
  UPDATE units SET active = FALSE, deleted_at = NOW(), deleted_by = :user_id
  WHERE unit_id = :unit_id;
COMMIT;
```

**Temas (`topics`) - Eliminación simple**
```sql
-- Verificar dependencias
SELECT COUNT(*) FROM questions WHERE topic_fk = :topic_id;

-- Eliminación lógica
UPDATE topics 
SET active = FALSE, 
    deleted_at = NOW(), 
    deleted_by = :user_id
WHERE topic_id = :topic_id 
AND active = TRUE;
```

### Validación de dependencias

**Consultas para mostrar impacto:**
```sql
-- Impacto de eliminar asignatura
WITH impact AS (
  SELECT 
    s.name as subject_name,
    COUNT(DISTINCT u.unit_id) as units_affected,
    COUNT(DISTINCT t.topic_id) as topics_affected,
    COUNT(DISTINCT q.question_id) as questions_affected
  FROM subjects s
  LEFT JOIN units u ON s.subject_id = u.subject_fk AND u.active = TRUE
  LEFT JOIN topics t ON u.unit_id = t.unit_fk AND t.active = TRUE  
  LEFT JOIN questions q ON t.topic_id = q.topic_fk
  WHERE s.subject_id = :subject_id
  GROUP BY s.subject_id, s.name
)
SELECT * FROM impact;
```

### Eliminación lógica (soft delete)

**Campos utilizados:**
- `active = FALSE`: Marca el elemento como inactivo
- `deleted_at = NOW()`: Timestamp de eliminación
- `deleted_by = :user_id`: Usuario que realizó la eliminación

**Filtros en consultas:**
```sql
-- Listar solo elementos activos
SELECT * FROM subjects WHERE active = TRUE;
SELECT * FROM units WHERE active = TRUE AND subject_fk = :subject_id;
SELECT * FROM topics WHERE active = TRUE AND unit_fk = :unit_id;

-- Incluir eliminados para reportes históricos
SELECT * FROM subjects; -- Sin filtro de active
```

### Manejo de elementos dependientes

**Políticas implementadas:**
1. **Eliminación en cascada:** Al eliminar padre, hijos se marcan inactivos automáticamente
2. **Preservación histórica:** Las preguntas mantienen sus `topic_fk` para trazabilidad
3. **Bloqueo de uso futuro:** Elementos inactivos no aparecen en formularios de creación

**Índices necesarios:**
```sql
-- Para verificaciones rápidas de dependencias
CREATE INDEX idx_units_subject_active ON units (subject_fk, active);
CREATE INDEX idx_topics_unit_active ON topics (unit_fk, active);  
CREATE INDEX idx_questions_topic ON questions (topic_fk);
CREATE INDEX idx_subjects_active ON subjects (active);
```

### Auditoría y trazabilidad

**Registro de eliminación:**
- Usar campos estándar `deleted_at`/`deleted_by` del modelo DDL
- Opcional: Log detallado en tabla de auditoría con motivo y elementos afectados

**Consultas de auditoría:**
```sql
-- Elementos eliminados por usuario y fecha
SELECT s.name, s.deleted_at, s.deleted_by, u.name as deleted_by_user
FROM subjects s
JOIN users u ON s.deleted_by = u.user_id  
WHERE s.active = FALSE
ORDER BY s.deleted_at DESC;
```

### Consideraciones de implementación

**Transaccionalidad:**
- Todas las eliminaciones en cascada deben ser atómicas
- Usar transacciones explícitas para operaciones multi-tabla
- Rollback automático en caso de errores

**UX recomendada:**
- Preview detallado del impacto antes de confirmar
- Confirmación explícita con resumen de elementos afectados
- Opción de "Reactivar" para elementos eliminados lógicamente

**API sugerida:**
```
DELETE /api/subjects/:id        # Eliminar asignatura (en cascada)
DELETE /api/units/:id           # Eliminar unidad (con temas)
DELETE /api/topics/:id          # Eliminar tema
GET /api/subjects/:id/impact    # Preview de impacto antes de eliminar
POST /api/subjects/:id/restore  # Reactivar elemento eliminado
```

**Validaciones de seguridad:**
- Verificar permisos antes de mostrar opciones de eliminación
- Confirmar que elemento existe y está activo antes de procesar
- Validar integridad referencial durante operaciones en cascada

---

**Nota:** La eliminación lógica preserva la integridad histórica del sistema mientras permite mantener un catálogo limpio y actualizado para operaciones futuras. Las operaciones en cascada respetan la jerarquía curricular establecida.

[Subir](#cu-bp-13--eliminar-elemento-de-taxonomía-curricular)
