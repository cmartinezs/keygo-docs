# CU-BP-03 — Clonar Ítem

> Permite a un Docente o Coordinador crear un nuevo ítem independiente a partir de una copia de otro existente, para modificarlo sin afectar el original y enriquecer el banco con variantes.
> El ítem clonado no comparte historial de versiones con el original.
> Relacionado: [CU-BP-02 — Versionar ítem](CU-BP-02.md)
> Ver también: [Diferencia entre Clonar y Versionar](#diferencia-entre-clonar-y-versionar)
> Ver también: [Modelo de datos y SQL para versionado](#anexo-técnico-para-desarrollo)

- [Revisión](reviews.md)
- [Volver](../../README.md#1-banco-de-preguntas)

<!-- TOC -->
* [CU-BP-03 — Clonar Ítem](#cu-bp-03--clonar-ítem)
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
    * [Ejemplo de implementación (pasos 4 y 8 del flujo principal)](#ejemplo-de-implementación-pasos-4-y-8-del-flujo-principal)
    * [Consulta para obtener opciones del ítem original (paso 4)](#consulta-para-obtener-opciones-del-ítem-original-paso-4)
    * [Auditoría de clonado (opcional pero recomendado)](#auditoría-de-clonado-opcional-pero-recomendado)
    * [Consideraciones importantes](#consideraciones-importantes)
    * [Referencias al modelo completo](#referencias-al-modelo-completo)
<!-- TOC -->

## Escenario origen: S-BP-02 | Editar / versionar / clonar ítem

### RF relacionados: RF2, RF7, RF8

**Actor principal:** Docente / Coordinador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Docente o Coordinador genere un **nuevo ítem completamente independiente** a partir de una copia de otro existente, para modificarlo sin afectar el original y enriquecer el banco con variantes. El ítem clonado no comparte historial de versiones con el original.

### Precondiciones
- Usuario autenticado con permisos de creación.
- Ítem existente accesible en el banco.

### Postcondiciones
- Se crea un **nuevo ítem independiente** con ID único y **versión 1**.
- El nuevo ítem hereda contenido y metadatos del original pero es totalmente autónomo.
- El nuevo ítem queda marcado como **activo** y disponible para uso.
- No existe relación de versionado entre el ítem clonado y el original.
- Trazabilidad registrada: autor del clon y fecha/hora de creación.

### Flujo principal (éxito)
1. El Docente busca y selecciona un ítem existente.
2. El Sistema muestra detalles del ítem (enunciado, alternativas, metadatos).
3. El Docente selecciona **"Clonar ítem"**.
4. El Sistema:
   - Crea un nuevo registro con ID único.
   - Copia todo el contenido del ítem original (enunciado, tipo, metadatos, alternativas).
   - Asigna **versión 1** al nuevo ítem.
   - **No** establece referencia a versión original (`original_question_fk = NULL`).
   - Presenta el formulario de edición con los datos copiados.
5. El Docente modifica el contenido deseado:
   - Enunciado de la pregunta.
   - Alternativas (agregar, modificar, eliminar, cambiar orden).
   - Metadatos (tema, dificultad, resultado de aprendizaje, tipo de pregunta).
6. El Docente guarda el nuevo ítem.
7. El Sistema valida:
   - Campos obligatorios completos.
   - Metadatos existen en catálogos vigentes.
   - Cardinalidad de opciones según tipo de pregunta.
   - Al menos una alternativa marcada como correcta.
8. El Sistema:
   - Persiste el nuevo ítem con su ID único.
   - Registra el autor (usuario actual) y fecha/hora de creación.
   - Marca el ítem como activo.
   - Indexa para búsqueda.
9. El Sistema confirma la creación mostrando el ID del nuevo ítem.

### Flujos alternativos / Excepciones
- **A1 — Datos incompletos:** El Sistema valida y marca errores; no permite guardar hasta corregir.
- **A2 — Metadato inválido:** No está en catálogo vigente → bloquear guardado con mensaje explicativo.
- **A3 — Cancelación:** Si el Docente abandona antes de guardar, el clon se descarta y no se registra en base de datos.
- **A4 — Error de red/servidor:** Mostrar mensaje y opción **Reintentar**; si hay auto-guardado, restaurar borrador local.

### Reglas de negocio
- **RN-1:** El clon **no** se considera una versión del ítem original, sino un ítem completamente independiente.
- **RN-2:** El nuevo ítem debe tener un **ID único** distinto del original y cualquier otra pregunta.
- **RN-3:** El clon comienza con **versión 1** y puede generar su propio historial de versiones posteriormente.
- **RN-4:** El clon puede ser modificado sin restricción, incluyendo cambio de tipo de pregunta, tema, y cualquier metadato.
- **RN-5:** El autor del clon es el usuario que ejecuta la acción de clonar, no el autor original.
- **RN-6:** No existe vínculo formal entre el ítem original y el clon (aunque opcionalmente puede registrarse en auditoría).

### Datos principales
- **Pregunta clonada**: Identificador único nuevo, enunciado, versión 1, estado activo, sin referencia a versión original, tema, dificultad, resultado de aprendizaje (opcional), tipo de pregunta, autor (usuario actual), fecha de creación.
- **Alternativas clonadas**: Nuevos identificadores, textos copiados, marcas de correctas, posiciones, pregunta asociada (nuevo ID).
- **Trazabilidad**: Autor del clon y fecha/hora de creación.

### Consideraciones de seguridad/permiso
- Solo usuarios con permisos de creación pueden clonar.
- Registro en auditoría: acción de clonar, usuario, fecha/hora, ítem origen (referencia opcional para trazabilidad).

### No funcionales
- **Rendimiento:** La creación del clon debe ejecutarse en menos de 2 segundos en el 95% de los casos.
- **Usabilidad:** Debe quedar claro para el usuario que el nuevo ítem es independiente del original.
- **Disponibilidad:** La operación de clonado no debe afectar el acceso al ítem original.

### Criterios de aceptación (QA)
- **CA-1:** Al clonar un ítem, se crea un nuevo registro con ID único, versión 1, y sin referencia a versión original.
- **CA-2:** El ítem clonado hereda todo el contenido del original en el formulario de edición.
- **CA-3:** El ítem clonado no afecta al original ni aparece en su historial de versiones.
- **CA-4:** El nuevo ítem aparece en listados y búsquedas como independiente.
- **CA-5:** El Docente puede modificar cualquier campo (incluyendo tipo de pregunta) y guardar cambios exitosamente.
- **CA-6:** El autor registrado del clon es el usuario que ejecutó la acción, no el autor original.
- **CA-7:** Si posteriormente se versiona el clon, este inicia su propio linaje de versiones independiente.

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

### Ejemplo de implementación (pasos 4 y 8 del flujo principal)

```sql
-- Supongamos que vamos a clonar question_id = 100

BEGIN;

-- 1. Obtener datos del ítem original
SELECT 
    q.text, q.topic_fk, q.difficulty_fk, q.outcome_fk, 
    q.question_type_fk
FROM questions q
WHERE q.question_id = 100;

-- 2. Insertar el nuevo ítem (después de que el usuario edite)
INSERT INTO questions (
    text, 
    version,              -- SIEMPRE 1 para clones
    active,
    original_question_fk, -- NULL para clones (no hay linaje)
    topic_fk,
    difficulty_fk,
    outcome_fk,
    question_type_fk,
    user_fk               -- Usuario que está clonando, NO el autor original
) VALUES (
    'Enunciado clonado y modificado',
    1,                    -- versión inicial
    true,
    NULL,                 -- sin referencia a versión original
    :topic_id,
    :difficulty_id,
    :outcome_id,
    :question_type_id,
    :current_user_id      -- autor del clon
) RETURNING question_id;  -- nuevo ID, p.ej., 250

-- 3. Clonar las opciones del original (modificadas por el usuario)
INSERT INTO question_options (
    text, is_correct, position, score, question_fk
) VALUES 
    ('Opción 1 clonada', false, 1, NULL, 250),
    ('Opción 2 clonada', true, 2, NULL, 250),
    ('Opción 3 clonada', false, 3, NULL, 250),
    ('Opción 4 clonada', false, 4, NULL, 250);

COMMIT;
```

### Consulta para obtener opciones del ítem original (paso 4)

```sql
-- Obtener las opciones del ítem original para copiarlas
SELECT 
    text, is_correct, position, score
FROM question_options
WHERE question_fk = :original_question_id
ORDER BY position;
```

### Auditoría de clonado (opcional pero recomendado)

Para mantener trazabilidad de que un ítem fue clonado desde otro, puede registrarse en una tabla de auditoría o logs:

```sql
-- Ejemplo de registro de auditoría
INSERT INTO audit_log (
    action,
    user_fk,
    timestamp,
    details
) VALUES (
    'CLONE_QUESTION',
    :current_user_id,
    now(),
    jsonb_build_object(
        'source_question_id', 100,
        'new_question_id', 250,
        'modifications', 'enunciado y opciones'
    )
);
```

### Consideraciones importantes

1. **Sin linaje de versiones**: El campo `original_question_fk` debe ser **NULL** para ítems clonados, lo que los diferencia claramente de las versiones.

2. **Autoría**: El campo `user_fk` debe registrar al usuario que ejecuta la clonación, no al autor del ítem original.

3. **Modificación libre**: A diferencia del versionado, el clon puede cambiar cualquier aspecto, incluso el tipo de pregunta (requiere validar que las opciones sean coherentes con el nuevo tipo).

4. **Búsqueda de duplicados**: Es recomendable ejecutar la detección de duplicados (similar a CU-BP-01) al guardar el clon para evitar preguntas idénticas en el banco.

5. **Versionado posterior del clon**: Si el clon se versiona posteriormente, iniciará su propio linaje:
   ```
   Original (ID 100, v1) → Original (ID 101, v2)
   
   Clon (ID 250, v1, original_question_fk = NULL) → Clon versionado (ID 251, v2, original_question_fk = 250)
   ```

### Referencias al modelo completo
- [Modelo Entidad-Relación completo](../../../../06-data-model/question-bank/mer.md)
- [Script DDL de creación](../../../../06-data-model/question-bank/DDL.sql)
- [Triggers y funciones](../../../../06-data-model/question-bank/TRIGGERS.sql)

---

[Subir](#cu-bp-03--clonar-ítem)