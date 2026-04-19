# CU-BP-11 — Crear elemento de taxonomía curricular

> Este caso de uso detalla la creación de elementos individuales en la jerarquía curricular (asignatura, unidad o tema) del sistema, basado en el escenario S-BP-06 | Gestionar taxonomías curriculares.

- [Revisión](reviews.md)
- [Volver](../../README.md#1-banco-de-preguntas)

<!-- TOC -->
* [CU-BP-11 — Crear elemento de taxonomía curricular](#cu-bp-11--crear-elemento-de-taxonomía-curricular)
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
    * [Tablas y unicidad por ámbito](#tablas-y-unicidad-por-ámbito)
    * [Validaciones por tipo de elemento](#validaciones-por-tipo-de-elemento)
    * [Constraints y índices recomendados](#constraints-y-índices-recomendados)
    * [Auditoría y trazabilidad](#auditoría-y-trazabilidad)
    * [Consideraciones de implementación](#consideraciones-de-implementación)
<!-- TOC -->

## Escenario origen: S-BP-06 | Gestionar taxonomías curriculares

### RF relacionados: RF2, RF7, RF13

**Actor principal:** Administrador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Administrador registre un nuevo elemento en la jerarquía curricular (asignatura, unidad o tema) de forma independiente. La jerarquía utilizada es: **Asignatura > Unidad > Tema**. Cada elemento puede crearse por separado y asociarse posteriormente a elementos existentes, permitiendo el crecimiento orgánico de la taxonomía curricular.

### Precondiciones
- Usuario autenticado con rol de Administrador.
- Para crear unidades: debe existir al menos una asignatura.
- Para crear temas: debe existir al menos una unidad.
- El nombre del elemento no debe existir en el ámbito correspondiente.

### Postcondiciones
- Se crea un nuevo elemento con identificador único.
- Queda disponible para asociación con otros elementos o para clasificar preguntas.
- Se registra la auditoría de creación.

### Flujo principal (éxito)
1. El Administrador accede al módulo de taxonomías curriculares.
2. Selecciona el tipo de elemento a crear: **Asignatura**, **Unidad** o **Tema**.
3. El Sistema presenta el formulario correspondiente:
   - **Asignatura:** Nombre y código únicos
   - **Unidad:** Nombre y selección de asignatura padre
   - **Tema:** Nombre y selección de unidad padre
4. El Administrador completa la información y confirma.
5. El Sistema valida unicidad en el ámbito correspondiente.
6. El Sistema guarda el nuevo elemento con identificador único.
7. El Sistema confirma creación exitosa y muestra el elemento en el catálogo.

### Flujos alternativos / Excepciones
- **A1 — Nombre duplicado:** El Sistema rechaza la creación si existe un nombre idéntico en el ámbito correspondiente (asignatura global, unidad por asignatura, tema por unidad).
- **A2 — Código duplicado (asignaturas):** El Sistema rechaza si el código de asignatura ya existe.
- **A3 — Elemento padre inexistente:** Para unidades/temas, el Sistema requiere seleccionar un elemento padre válido y activo.
- **A4 — Datos incompletos:** El Sistema no permite guardar sin completar campos obligatorios.

### Reglas de negocio
- **RN-1:** **Asignaturas** deben tener nombres únicos globalmente y códigos únicos.
- **RN-2:** **Unidades** deben tener nombres únicos dentro de cada asignatura.
- **RN-3:** **Temas** deben tener nombres únicos dentro de cada unidad.
- **RN-4:** Los elementos creados quedan en estado **Activo** por defecto.
- **RN-5:** Se pueden agregar nuevos elementos a la jerarquía en cualquier momento sin afectar elementos existentes.
- **RN-6:** La jerarquía puede expandirse gradualmente: no es necesario crear la taxonomía completa de una vez.

### Datos principales
- **Asignatura** (`subject_id`, `name`, `code`, `active`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`)
- **Unidad** (`unit_id`, `name`, `subject_fk`, `active`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`)
- **Tema** (`topic_id`, `name`, `unit_fk`, `active`, `created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`)

### Consideraciones de seguridad/permiso
- Solo usuarios con rol de Administrador pueden crear elementos curriculares.
- Se registra trazabilidad completa de quién y cuándo crea cada elemento.

### No funcionales
- **Usabilidad:** Formularios diferenciados por tipo con validación en tiempo real.
- **Rendimiento:** Creación < 2s p95.
- **Escalabilidad:** Soporte para cientos de asignaturas y miles de unidades/temas.

### Criterios de aceptación (QA)
- **CA-1:** Al crear una asignatura, esta aparece disponible inmediatamente para crear unidades.
- **CA-2:** Al crear una unidad, esta aparece disponible inmediatamente para crear temas.
- **CA-3:** Los elementos creados aparecen inmediatamente en los selectores de clasificación de preguntas.
- **CA-4:** La validación de unicidad funciona correctamente según el ámbito específico.
- **CA-5:** Se puede crear elementos en cualquier orden (asignaturas primero, luego unidades y temas gradualmente).

---

## Anexo Técnico (para desarrollo)

> Mapeo al modelo DDL y reglas de implementación para la creación independiente de elementos curriculares.

### Tablas y unicidad por ámbito

**Asignaturas (`subjects`)**
```sql
-- Validación: nombre y código únicos globalmente
SELECT 1 FROM subjects 
WHERE (name ILIKE :name OR code ILIKE :code) 
AND active = TRUE;

-- Inserción
INSERT INTO subjects (name, code, created_by, created_at)
VALUES (:name, :code, :user_id, NOW())
RETURNING subject_id;
```

**Unidades (`units`)**
```sql
-- Validación: nombre único por asignatura
SELECT 1 FROM units 
WHERE subject_fk = :subject_id 
AND name ILIKE :name 
AND active = TRUE;

-- Inserción
INSERT INTO units (name, subject_fk, created_by, created_at)
VALUES (:name, :subject_id, :user_id, NOW())
RETURNING unit_id;
```

**Temas (`topics`)**
```sql
-- Validación: nombre único por unidad
SELECT 1 FROM topics 
WHERE unit_fk = :unit_id 
AND name ILIKE :name 
AND active = TRUE;

-- Inserción
INSERT INTO topics (name, unit_fk, created_by, created_at)
VALUES (:name, :unit_id, :user_id, NOW())
RETURNING topic_id;
```

### Validaciones por tipo de elemento

- **Asignaturas:** Validar existencia de nombre y código únicos globalmente.
- **Unidades:** Validar existencia del `subject_id` padre y unicidad de nombre dentro de la asignatura.
- **Temas:** Validar existencia del `unit_id` padre y unicidad de nombre dentro de la unidad.
- **Todos:** Usar soft delete (`active = FALSE`) en lugar de borrado físico.

### Constraints y índices recomendados

**Constraints de unicidad a nivel de base de datos:**
```sql
ALTER TABLE subjects ADD CONSTRAINT uk_subjects_name UNIQUE (name);
ALTER TABLE subjects ADD CONSTRAINT uk_subjects_code UNIQUE (code);
ALTER TABLE units ADD CONSTRAINT uk_units_subject_name UNIQUE (subject_fk, name);
ALTER TABLE topics ADD CONSTRAINT uk_topics_unit_name UNIQUE (unit_fk, name);
```

**Índices para rendimiento:**
```sql
CREATE INDEX idx_subjects_active ON subjects (active);
CREATE INDEX idx_units_subject_active ON units (subject_fk, active);
CREATE INDEX idx_topics_unit_active ON topics (unit_fk, active);
CREATE INDEX idx_subjects_name_active ON subjects (name, active);
CREATE INDEX idx_units_name_subject ON units (name, subject_fk);
CREATE INDEX idx_topics_name_unit ON topics (name, unit_fk);
```

### Auditoría y trazabilidad
- Usar los campos estándar (`created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) que ya existen en las tablas del modelo DDL.
- Registrar en logs de aplicación las operaciones de creación con detalles del elemento creado.

### Consideraciones de implementación

**Creación independiente:**
- Cada tipo de elemento tiene su propio endpoint/formulario específico.
- Los formularios de unidades muestran solo asignaturas activas.
- Los formularios de temas muestran solo unidades activas.

**Expansión posterior:**
- La jerarquía puede crecer orgánicamente agregando elementos según necesidad.
- No se requiere pre-planificación completa de la taxonomía.
- Elementos padre pueden tener hijos agregados en cualquier momento posterior.

**Manejo de errores:**
- Usar constraints de BD como respaldo a validaciones de aplicación.
- Manejar errores de constraint como validaciones de negocio.
- Mensajes de error específicos por tipo de violación.

**API recomendada:**
```
POST /api/subjects          # Crear asignatura
POST /api/units             # Crear unidad
POST /api/topics            # Crear tema
GET  /api/subjects          # Listar asignaturas activas
GET  /api/units/:subject_id # Listar unidades de una asignatura
GET  /api/topics/:unit_id   # Listar temas de una unidad
```

---

**Nota:** Este enfoque permite construir la taxonomía curricular de forma incremental, donde los administradores pueden crear asignaturas inicialmente y luego ir agregando unidades y temas según se definan los contenidos curriculares, facilitando la adaptación a diferentes ritmos de planificación académica.

[Subir](#cu-bp-11--crear-elemento-de-taxonomía-curricular)
