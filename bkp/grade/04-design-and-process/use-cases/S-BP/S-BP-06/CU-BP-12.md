# CU-BP-12 — Editar elemento de taxonomía curricular

> Este caso de uso detalla la edición de elementos individuales en la jerarquía curricular (asignatura, unidad o tema) del sistema, basado en el escenario S-BP-06 | Gestionar taxonomías curriculares.

- [Revisión](reviews.md)
- [Volver](../../README.md#1-banco-de-preguntas)

<!-- TOC -->
* [CU-BP-12 — Editar elemento de taxonomía curricular](#cu-bp-12--editar-elemento-de-taxonomía-curricular)
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
    * [Operaciones de edición por tipo](#operaciones-de-edición-por-tipo)
    * [Validaciones específicas](#validaciones-específicas)
    * [Manejo de relaciones jerárquicas](#manejo-de-relaciones-jerárquicas)
    * [Auditoría y trazabilidad](#auditoría-y-trazabilidad)
    * [Consideraciones de implementación](#consideraciones-de-implementación)
<!-- TOC -->

## Escenario origen: S-BP-06 | Gestionar taxonomías curriculares

### RF relacionados: RF2, RF7, RF13

**Actor principal:** Administrador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Administrador modifique elementos existentes en la jerarquía curricular (asignatura, unidad o tema), manteniendo la integridad referencial y trazabilidad de cambios. La jerarquía utilizada es: **Asignatura > Unidad > Tema**. Los cambios pueden incluir modificación de nombre, código (asignaturas) o reasignación jerárquica.

### Precondiciones
- Usuario autenticado con rol de Administrador.
- El elemento seleccionado existe y está activo.
- Para reasignaciones jerárquicas: el nuevo elemento padre debe existir y estar activo.

### Postcondiciones
- El elemento queda actualizado con los nuevos datos.
- Se mantiene la integridad referencial con elementos hijos y preguntas asociadas.
- Se registra la auditoría de modificación.
- Los elementos hijos y preguntas mantienen su relación correcta.

### Flujo principal (éxito)
1. El Administrador accede al módulo de taxonomías curriculares.
2. Selecciona un elemento existente (asignatura, unidad o tema) para editar.
3. El Sistema muestra el formulario con los datos actuales:
   - **Asignatura:** Nombre y código editables
   - **Unidad:** Nombre editable y opción de cambiar asignatura padre
   - **Tema:** Nombre editable y opción de cambiar unidad padre
4. El Administrador modifica los campos deseados.
5. El Sistema valida unicidad en el ámbito correspondiente (si cambió el nombre).
6. El Sistema valida integridad referencial (si cambió la jerarquía).
7. El Sistema actualiza el elemento y registra auditoría.
8. El Sistema confirma edición exitosa.

### Flujos alternativos / Excepciones
- **A1 — Nombre duplicado:** El Sistema rechaza si el nuevo nombre ya existe en el ámbito correspondiente.
- **A2 — Código duplicado (asignaturas):** El Sistema rechaza si el nuevo código ya existe.
- **A3 — Element padre inválido:** Para reasignaciones jerárquicas, el Sistema valida que el nuevo padre existe y está activo.
- **A4 — Reasignación circular:** El Sistema impide mover una unidad a una de sus propias asignaturas derivadas (evitar ciclos).
- **A5 — Elemento inactivo:** El Sistema no permite editar elementos marcados como inactivos.

### Reglas de negocio
- **RN-1:** **Asignaturas**: nombres y códigos únicos globalmente.
- **RN-2:** **Unidades**: nombres únicos dentro de cada asignatura.
- **RN-3:** **Temas**: nombres únicos dentro de cada unidad.
- **RN-4:** Las modificaciones deben quedar registradas en auditoría con timestamp y usuario.
- **RN-5:** Al reasignar jerárquicamente, todos los elementos hijos se mantienen asociados.
- **RN-6:** Las preguntas asociadas mantienen su clasificación actualizada automáticamente.

### Datos principales
- **Asignatura** (`subject_id`, `name`, `code`, `active`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`)
- **Unidad** (`unit_id`, `name`, `subject_fk`, `active`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`)
- **Tema** (`topic_id`, `name`, `unit_fk`, `active`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`)

### Consideraciones de seguridad/permiso
- Solo usuarios con rol de Administrador pueden editar elementos curriculares.
- Se registra trazabilidad completa de quién y cuándo modifica cada elemento.

### No funcionales
- **Usabilidad:** Formularios con validación en tiempo real y preview de impacto.
- **Rendimiento:** Edición < 2s p95, incluso con reasignaciones jerárquicas.
- **Integridad:** Transaccionalidad para operaciones que afecten múltiples tablas.

### Criterios de aceptación (QA)
- **CA-1:** Al editar nombre/código de una asignatura, las unidades y temas asociados mantienen su estructura.
- **CA-2:** Al reasignar una unidad a otra asignatura, sus temas se mueven junto con ella.
- **CA-3:** Al reasignar un tema a otra unidad, las preguntas clasificadas mantienen la nueva jerarquía.
- **CA-4:** Las validaciones de unicidad funcionan correctamente según el nuevo ámbito tras reasignaciones.
- **CA-5:** La edición queda registrada en auditoría con detalles del cambio.

---

## Anexo Técnico (para desarrollo)

> Mapeo al modelo DDL y reglas de implementación para editar elementos curriculares de forma segura.

### Operaciones de edición por tipo

**Asignaturas (`subjects`)**
```sql
-- Validación previa (si cambió nombre o código)
SELECT 1 FROM subjects 
WHERE (name ILIKE :new_name OR code ILIKE :new_code) 
AND subject_id != :current_id 
AND active = TRUE;

-- Actualización
UPDATE subjects 
SET name = :new_name, 
    code = :new_code,
    updated_at = NOW(),
    updated_by = :user_id
WHERE subject_id = :subject_id 
AND active = TRUE
RETURNING subject_id;
```

**Unidades (`units`) - Cambio de nombre**
```sql
-- Validación previa
SELECT 1 FROM units 
WHERE subject_fk = :subject_fk 
AND name ILIKE :new_name 
AND unit_id != :current_id 
AND active = TRUE;

-- Actualización
UPDATE units 
SET name = :new_name,
    updated_at = NOW(),
    updated_by = :user_id
WHERE unit_id = :unit_id 
AND active = TRUE;
```

**Unidades (`units`) - Reasignación de asignatura**
```sql
-- Validación: nuevo nombre único en asignatura destino
SELECT 1 FROM units 
WHERE subject_fk = :new_subject_id 
AND name ILIKE :current_name 
AND active = TRUE;

-- Reasignación (dentro de transacción)
UPDATE units 
SET subject_fk = :new_subject_id,
    updated_at = NOW(),
    updated_by = :user_id
WHERE unit_id = :unit_id 
AND active = TRUE;
-- Los topics asociados se mantienen automáticamente por FK
```

**Temas (`topics`) - Reasignación de unidad**
```sql
-- Validación: nombre único en unidad destino  
SELECT 1 FROM topics 
WHERE unit_fk = :new_unit_id 
AND name ILIKE :current_name 
AND active = TRUE;

-- Reasignación
UPDATE topics 
SET unit_fk = :new_unit_id,
    updated_at = NOW(),
    updated_by = :user_id
WHERE topic_id = :topic_id 
AND active = TRUE;
-- Las questions asociadas mantienen la referencia por topic_fk
```

### Validaciones específicas

**Prevención de ciclos jerárquicos:**
- Al mover unidades, validar que la asignatura destino no sea derivada de la unidad.
- En el modelo actual (3 niveles fijos) esto es menos crítico, pero mantener buenas prácticas.

**Validación de integridad:**
```sql
-- Verificar que elemento padre existe y está activo
SELECT 1 FROM subjects WHERE subject_id = :new_subject_id AND active = TRUE;
SELECT 1 FROM units WHERE unit_id = :new_unit_id AND active = TRUE;
```

### Manejo de relaciones jerárquicas

**Impacto de cambios:**
- **Editar asignatura**: No afecta FKs directamente, solo datos descriptivos
- **Reasignar unidad**: Todos sus temas se mantienen asociados automáticamente
- **Reasignar tema**: Las preguntas mantienen su `topic_fk`, nueva jerarquía se refleja en consultas

**Consultas para verificar impacto:**
```sql
-- Contar elementos hijos antes de reasignación
SELECT COUNT(*) FROM units WHERE subject_fk = :subject_id;
SELECT COUNT(*) FROM topics WHERE unit_fk = :unit_id;
SELECT COUNT(*) FROM questions WHERE topic_fk = :topic_id;
```

### Auditoría y trazabilidad
- Usar campos estándar `updated_at`/`updated_by` para tracking básico
- Para cambios jerárquicos significativos, considerar log detallado del cambio
- Mantener historial de clasificación de preguntas para reportes

### Consideraciones de implementación

**Transaccionalidad:**
- Operaciones de reasignación jerárquica deben ser atómicas
- Usar transacciones explícitas para operaciones multi-tabla

**UX recomendada:**
- Mostrar preview del impacto (cantidad de elementos hijos afectados)
- Confirmación explícita para reasignaciones jerárquicas
- Validación en tiempo real de unicidad durante escritura

**API sugerida:**
```
PUT /api/subjects/:id      # Editar asignatura
PUT /api/units/:id         # Editar unidad (nombre y/o asignatura padre)  
PUT /api/topics/:id        # Editar tema (nombre y/o unidad padre)
GET /api/subjects/:id/impact  # Preview de impacto antes de cambios
```

**Manejo de errores:**
- Constraints de BD como respaldo a validaciones de aplicación
- Mensajes específicos por tipo de error (duplicado, padre inválido, etc.)
- Rollback automático en caso de errores durante reasignaciones

---

**Nota:** Las operaciones de edición mantienen la flexibilidad del modelo jerárquico mientras preservan la integridad referencial y la trazabilidad necesaria para un sistema académico robusto.

[Subir](#cu-bp-12--editar-elemento-de-taxonomía-curricular)
