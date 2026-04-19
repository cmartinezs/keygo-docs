# CU-BP-02 — Versionar Ítem

> Permite que un Docente o Coordinador cree una nueva versión de una pregunta existente, manteniendo la trazabilidad y sin afectar evaluaciones previas.
> Diferencia con clonar: versionar mantiene el linaje y la relación con la versión original, mientras que clonar crea una copia independiente sin relación.
> Ver también: [CU-BP-03 — Clonar Ítem](CU-BP-03.md)
> Ver también: [Diferencia entre Clonar y Versionar](#diferencia-entre-clonar-y-versionar)
> Ver también: [Modelo de datos y SQL para versionado](#anexo-técnico-para-desarrollo)

- [Revisión](reviews.md)
- [Volver](../../README.md#1-banco-de-preguntas)

<!-- TOC -->
* [CU-BP-02 — Versionar Ítem](#cu-bp-02--versionar-ítem)
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
    * [Diferencia entre Clonar y Versionar](#diferencia-entre-clonar-y-versionar)
    * [Resumen del modelo de datos para versionado](#resumen-del-modelo-de-datos-para-versionado)
      * [Campos clave en `questions` para versionado](#campos-clave-en-questions-para-versionado)
      * [Estrategia de versionado](#estrategia-de-versionado)
      * [Interacción con Auditoría Soft](#interacción-con-auditoría-soft)
    * [Ejemplo de implementación (pasos 4 y 8 del flujo principal)](#ejemplo-de-implementación-pasos-4-y-8-del-flujo-principal)
    * [Consulta para obtener historial de versiones](#consulta-para-obtener-historial-de-versiones)
    * [Consulta para obtener la última versión](#consulta-para-obtener-la-última-versión)
    * [Consideraciones importantes](#consideraciones-importantes)
    * [Índices recomendados adicionales](#índices-recomendados-adicionales)
    * [Referencias al modelo completo](#referencias-al-modelo-completo)
<!-- TOC -->

## Escenario origen: S-BP-02 | Editar / versionar / clonar ítem

### RF relacionados: RF2, RF7, RF8

**Actor principal:** Docente / Coordinador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Docente o Coordinador actualice una pregunta existente mediante la creación de una **nueva versión**, garantizando trazabilidad y sin alterar evaluaciones anteriores que utilizaron la versión original.

### Precondiciones
- Usuario autenticado con permisos de edición.
- El ítem a versionar existe y está accesible.

### Postcondiciones
- Se crea una **nueva versión (vN+1)** del ítem marcada como **activa**.
- La versión anterior se mantiene intacta en la base de datos para trazabilidad histórica.
- La relación entre versiones queda registrada mediante la referencia a la versión original.
- Trazabilidad registrada: autor de la nueva versión y fecha/hora de creación.

### Flujo principal (éxito)
1. El Docente busca y selecciona un ítem existente.
2. El Sistema muestra detalles del ítem (enunciado, alternativas, metadatos, versión actual) y las acciones disponibles.
3. El Docente selecciona **"Crear nueva versión"**.
4. El Sistema:
   - Clona todo el contenido del ítem actual (enunciado, tipo, metadatos, alternativas).
   - Asigna un nuevo ID único a la nueva versión.
   - Incrementa el número de versión (vN+1).
   - Mantiene la referencia a la versión raíz original.
   - Presenta el formulario de edición con los datos clonados.
5. El Docente edita el contenido deseado:
   - Enunciado de la pregunta.
   - Alternativas (agregar, modificar, eliminar, cambiar orden).
   - Metadatos (tema, dificultad, resultado de aprendizaje).
6. El Docente guarda la nueva versión.
7. El Sistema valida:
   - Campos obligatorios completos.
   - Metadatos existen en catálogos vigentes.
   - Cardinalidad de opciones según tipo de pregunta.
   - Al menos una alternativa marcada como correcta.
8. El Sistema:
   - Persiste la nueva versión con su nuevo ID.
   - Registra el autor y fecha/hora de creación.
   - Marca la nueva versión como activa.
   - Indexa para búsqueda.
9. El Sistema confirma la creación de la nueva versión mostrando el ID asignado y el número de versión.

### Flujos alternativos / Excepciones
- **A1 — Datos incompletos/erróneos:** El Sistema valida y marca errores; no permite guardar hasta corregir.
- **A2 — Metadato inválido:** No está en catálogo vigente → bloquear guardado con mensaje explicativo.
- **A3 — Cancelación:** El Docente puede abortar la edición; la nueva versión no se crea y no se registra en base de datos.
- **A4 — Error de red/servidor:** Mostrar mensaje y opción **Reintentar**; si hay auto-guardado, restaurar borrador local.

### Reglas de negocio
- **RN-1:** Nunca se modifica una versión existente; toda edición genera una nueva versión con nuevo ID.
- **RN-2:** El sistema debe mantener un **historial de versiones** mediante el campo de versión y la referencia a la versión original.
- **RN-3:** Todas las versiones (antiguas y nuevas) se mantienen activas en el sistema para permitir trazabilidad histórica.
- **RN-4:** La nueva versión hereda todos los metadatos de la versión anterior, pero pueden ser modificados durante la edición.
- **RN-5:** El número de versión se incrementa automáticamente (la versión original determina el linaje).
- **RN-6:** Evaluaciones ya aplicadas mantienen su referencia a la versión específica que utilizaron.

### Datos principales
- **Pregunta**: Identificador único, enunciado, versión, estado de vigencia, referencia a versión original, tema, dificultad, resultado de aprendizaje (opcional), tipo de pregunta, autor, fecha de creación.
- **Alternativa**: Identificador, texto, marca de correcta, posición, puntaje parcial (opcional), pregunta asociada.
- **Trazabilidad**: Autor de cada versión y fecha/hora de creación.

### Consideraciones de seguridad/permiso
- Solo usuarios con permisos de edición pueden generar nuevas versiones.
- Auditoría obligatoria de cada versión creada (usuario, fecha/hora, acción).
- Las versiones anteriores permanecen protegidas contra modificación.

### No funcionales
- **Disponibilidad:** No debe interrumpir acceso a versiones antiguas durante la creación de la nueva versión.
- **Rendimiento:** La creación de una nueva versión debe completarse en menos de 2 segundos en el 95% de los casos.
- **Usabilidad:** Interfaz clara que muestre el número de versión actual y el que se creará.

### Criterios de aceptación (QA)
- **CA-1:** Al crear una nueva versión de un ítem v1, se genera un nuevo registro con v2, ID único, y referencia a la versión original.
- **CA-2:** La nueva versión hereda todo el contenido de la versión anterior en el formulario de edición.
- **CA-3:** El historial muestra la relación entre v1 y v2 con autor y fecha de cada una.
- **CA-4:** Evaluaciones que usaron v1 siguen referenciando v1 sin alteraciones.
- **CA-5:** La nueva versión aparece en búsquedas y listados con su número de versión visible.
- **CA-6:** Se puede crear una v3 desde v2, manteniendo la referencia a la versión original (v1).

---

## Anexo Técnico (para desarrollo)

> Esta sección contiene los detalles técnicos de implementación según el modelo de datos del sistema GRADE.

### Diferencia entre Clonar y Versionar

| Aspecto | Versionar (CU-BP-02) | Clonar (CU-BP-03) |
|---------|---------------------|-------------------|
| **Nuevo ID** | Sí, nuevo `question_id` | Sí, nuevo `question_id` |
| **Versión** | Incrementa (v2, v3...) | Siempre **v1** |
| **`original_question_fk`** | Apunta a la raíz del linaje | **NULL** (sin linaje) |
| **Relación con original** | Historial de versiones | Ninguna (independiente) |
| **Autor** | Usuario que versiona | Usuario que clona |
| **Uso típico** | Actualizar/corregir pregunta existente | Crear variantes o preguntas similares |

### Resumen del modelo de datos para versionado

#### Campos clave en `questions` para versionado
- **`question_id`**: PK única para cada versión (cada versión es un registro independiente).
- **`version`**: Número entero que se incrementa (1, 2, 3...).
- **`original_question_fk`**: Referencia auto-referencial a la **versión raíz** (v1), permitiendo rastrear todo el linaje.
  - Para v1: `original_question_fk = NULL` (o puede apuntar a sí misma).
  - Para v2+: `original_question_fk` apunta al `question_id` de v1.
- **`active`**: Todas las versiones permanecen activas (`true`) para permitir trazabilidad.
- **`user_fk`**: Representa el **creador** de esta versión específica (no del ítem original).
- **`created_at`**: Fecha de creación de **esta versión**.
- **Auditoría**: `updated_at`, `updated_by`, `deleted_at`, `deleted_by` (permiten rastrear modificaciones posteriores o eliminación lógica).

#### Estrategia de versionado
El modelo implementa **versionado mediante registro completo**:
- Cada versión es un registro completamente independiente en `questions` con su propio `question_id`.
- Las opciones se clonan también en `question_options` con `question_fk` apuntando al nuevo `question_id`.
- El campo `original_question_fk` mantiene el linaje hacia la versión raíz.
- **Importante**: Cada versión tiene su propio autor (`user_fk`) que indica **quién creó esa versión**, no quién creó el ítem original.

#### Interacción con Auditoría Soft
- **Creación de versión**: Se registra con `user_fk` = usuario actual y `created_at` = timestamp actual
- **No se modifica la versión anterior**: La v1 mantiene su `user_fk` y `created_at` originales
- **Soft delete de una versión**: Si se necesita "ocultar" una versión específica, se marca con `deleted_at` y `deleted_by`
- **Historial completo**: Combinando `version`, `original_question_fk`, `user_fk` y `created_at` se puede reconstruir toda la historia del ítem

### Ejemplo de implementación (pasos 4 y 8 del flujo principal)

```sql
-- Supongamos que vamos a versionar question_id = 100 (versión 2)

BEGIN;

-- 1. Obtener datos de la versión anterior
SELECT 
    q.text, q.topic_fk, q.difficulty_fk, q.outcome_fk, 
    q.question_type_fk, q.version, q.original_question_fk
FROM questions q
WHERE q.question_id = 100;

-- 2. Determinar la versión original (raíz)
-- Si original_question_fk es NULL, la raíz es 100
-- Si no, la raíz es el valor de original_question_fk
SET @root_question_id = COALESCE(original_question_fk, 100);

-- 3. Insertar la nueva versión (después de que el usuario edite)
INSERT INTO questions (
    text, 
    version,
    active,
    original_question_fk,  -- apunta a la raíz
    topic_fk,
    difficulty_fk,
    outcome_fk,
    question_type_fk,
    user_fk  -- autor de la NUEVA versión
) VALUES (
    'Enunciado modificado',
    3,  -- versión incrementada
    true,
    @root_question_id,  -- referencia a v1
    :topic_id,
    :difficulty_id,
    :outcome_id,
    :question_type_id,
    :current_user_id  -- quien está creando esta versión
) RETURNING question_id;  -- nuevo ID, p.ej., 150

-- 4. Clonar las opciones (modificadas por el usuario)
INSERT INTO question_options (
    text, is_correct, position, score, question_fk
) VALUES 
    ('Opción 1 modificada', false, 1, NULL, 150),
    ('Opción 2 modificada', true, 2, NULL, 150),
    ('Opción 3 nueva', false, 3, NULL, 150),
    ('Opción 4 modificada', false, 4, NULL, 150);

COMMIT;
```

### Consulta para obtener historial de versiones

Para mostrar al usuario todas las versiones de una pregunta:

```sql
-- Obtener todas las versiones de una pregunta (dado cualquier version_id)
WITH root AS (
    SELECT COALESCE(original_question_fk, question_id) as root_id
    FROM questions
    WHERE question_id = :any_version_id
)
SELECT 
    q.question_id,
    q.version,
    q.text,
    q.active,
    u.name as author,
    q.created_at
FROM questions q
JOIN users u ON q.user_fk = u.user_id
WHERE q.original_question_fk = (SELECT root_id FROM root)
   OR q.question_id = (SELECT root_id FROM root)
ORDER BY q.version ASC;
```

### Consulta para obtener la última versión

```sql
-- Obtener la versión más reciente de una familia de preguntas
WITH root AS (
    SELECT COALESCE(original_question_fk, question_id) as root_id
    FROM questions
    WHERE question_id = :any_version_id
)
SELECT q.*
FROM questions q
WHERE (q.original_question_fk = (SELECT root_id FROM root)
    OR q.question_id = (SELECT root_id FROM root))
  AND q.active = true
ORDER BY q.version DESC
LIMIT 1;
```

### Consideraciones importantes

1. **Integridad referencial en evaluaciones**: Las tablas del módulo de evaluaciones deben referenciar `question_id` específico, no "la pregunta en general". Así se preserva qué versión exacta se usó.

2. **Búsqueda y listados**: Por defecto, mostrar solo la versión más reciente, pero permitir ver historial completo.

3. **Desactivación de versiones**: Si se requiere "ocultar" una versión específica, se puede usar `active = false`, pero esto es opcional según la política del sistema.

4. **Performance**: El índice sobre `original_question_fk` es crucial para consultas de historial.

### Índices recomendados adicionales
- `CREATE INDEX idx_questions_original ON questions (original_question_fk) WHERE original_question_fk IS NOT NULL;`
- `CREATE INDEX idx_questions_version ON questions (original_question_fk, version);`

### Referencias al modelo completo
- [Modelo Entidad-Relación completo](../../../../06-data-model/question-bank/mer.md)
- [Script DDL de creación](../../../../06-data-model/question-bank/DDL.sql)
- [Triggers y funciones](../../../../06-data-model/question-bank/TRIGGERS.sql)

---

[Subir](#cu-bp-02--versionar-ítem)