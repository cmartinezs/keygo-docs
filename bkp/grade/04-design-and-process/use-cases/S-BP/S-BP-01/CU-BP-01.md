# CU-BP-01 — Crear ítem nuevo en el Banco de Preguntas

> Caso de uso detallado para la creación de un nuevo ítem en el Banco de Preguntas del sistema GRADE.
> Incluye flujos, reglas de negocio, datos principales y consideraciones técnicas.
> Basado en los requisitos funcionales RF2, RF7 y RF8.
> Parte del proceso S-BP-01.

- [Revisión](reviews.md)
- [Volver](../../README.md#1-banco-de-preguntas)

<!-- TOC -->
* [CU-BP-01 — Crear ítem nuevo en el Banco de Preguntas](#cu-bp-01--crear-ítem-nuevo-en-el-banco-de-preguntas)
  * [Escenario origen: S-BP-01 | Crear ítem nuevo](#escenario-origen-s-bp-01--crear-ítem-nuevo-)
    * [RF relacionados: RF2, RF7, RF8](#rf-relacionados-rf2-rf7-rf8-)
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
    * [Resumen del modelo de datos](#resumen-del-modelo-de-datos)
      * [Entidades principales involucradas](#entidades-principales-involucradas)
      * [Relaciones clave](#relaciones-clave)
      * [Campos críticos para este caso de uso](#campos-críticos-para-este-caso-de-uso)
      * [Auditoría Soft](#auditoría-soft)
    * [Validaciones implementadas en base de datos](#validaciones-implementadas-en-base-de-datos)
    * [Ejemplo de implementación (paso 7 del flujo principal)](#ejemplo-de-implementación-paso-7-del-flujo-principal)
    * [Inferencia de jerarquía curricular](#inferencia-de-jerarquía-curricular)
    * [Índices recomendados](#índices-recomendados)
    * [Referencias al modelo completo](#referencias-al-modelo-completo)
<!-- TOC -->

## Escenario origen: S-BP-01 | Crear ítem nuevo  
### RF relacionados: RF2, RF7, RF8  
**Actor principal:** Docente / Coordinador  
**Actores secundarios:** Sistema GRADE (validación, persistencia, indexación)

---

### Objetivo
Registrar una nueva pregunta con enunciado, tipo y opciones (si aplica), **metadatos pedagógicos completos** (tema, dificultad, resultado de aprendizaje opcional), asignar **ID único**, guardar y dejar disponible para búsqueda y reutilización por usuarios autorizados. La **unidad** y **asignatura** se infieren automáticamente a partir del tema seleccionado.

---

### Precondiciones
- Usuario autenticado con permisos para crear ítems.
- Catálogos de taxonomías (tema, unidad, nivel/dificultad, RA) disponibles y vigentes.

---

### Postcondiciones
- Ítem creado con **ID único** y marcado como **activo**.
- Metadatos asociados (tema, dificultad, tipo, resultado de aprendizaje opcional) y validados contra catálogos.
- Ítem indexado y visible en listados/búsquedas según permisos.
- Trazabilidad registrada: autor y fecha/hora de creación.

---

### Flujo principal (éxito)
1. El Docente selecciona **Nueva pregunta** en Banco de Preguntas.  
2. El Sistema muestra el formulario con campos mínimos:  
   - **Tipo de pregunta**: selección desde catálogo (Verdadero/Falso, Selección Única, Selección Múltiple).  
   - **Enunciado** (texto de la pregunta).  
   - **Alternativas** (si aplica según tipo): texto de cada opción, marcación de correcta(s), y orden de presentación.  
   - **Metadatos obligatorios**:  
     - **Tema**: selector jerárquico que muestra Asignatura > Unidad > Tema; al seleccionar el tema, la unidad y asignatura quedan implícitas.  
     - **Dificultad**: selector desde catálogo de niveles vigentes.  
   - **Metadatos opcionales**:  
     - **Resultado de Aprendizaje**: selector desde catálogo.  
3. El Docente completa el formulario.  
4. El Sistema realiza **validaciones**:  
   - Campos obligatorios completos (enunciado, tipo, tema, dificultad).  
   - Tema, dificultad y resultado de aprendizaje (si se especifica) existen en catálogos vigentes.  
   - Para tipos Verdadero/Falso, Selección Única y Selección Múltiple: validación de cantidad de opciones según reglas del tipo (ver RN-2).  
   - Al menos una alternativa marcada como correcta.  
   - Posiciones de alternativas únicas y consecutivas.  
5. El Sistema ejecuta **detección de duplicado potencial** (similitud de enunciado + metadatos tema/tipo).  
   - Si existe posible duplicado, **advierte** y permite continuar o cancelar.  
6. El Docente confirma **Guardar**.  
7. El Sistema:  
   - **Asigna ID único** a la pregunta.  
   - **Guarda** el registro de la pregunta con versión 1 y estado activo.  
   - **Guarda** las alternativas con sus textos, marcas de correctas, posiciones y relación con la pregunta.  
   - **Indexa** el ítem para búsqueda textual y por metadatos.  
8. El Sistema muestra **confirmación** con el ID asignado y acceso rápido a "Ver ítem" / "Crear otro".

---

### Flujos alternativos / Excepciones
- **A1 — Datos incompletos**: marcar campos con error y permanecer en el formulario.  
- **A2 — Metadato inválido**: no está en catálogo → bloquear guardado o sugerir alta en Taxonomías.  
- **A3 — Duplicado potencial**: mostrar coincidencias; el Docente puede continuar (forzar creación) o abrir la existente.  
- **A4 — Tipo de pregunta abierta**: omitir alternativas; solicitar **criterios de corrección**/rúbrica breve.  
- **A5 — Error de red/servidor**: mostrar mensaje y opción **Reintentar**; si hay auto-guardado, restaurar borrador.  
- **A6 — Permisos insuficientes**: denegar operación y registrar intento.  

---

### Reglas de negocio
- **RN-1**: Enunciado, Tipo, Tema y Dificultad son obligatorios.  
- **RN-2**: Cantidad de opciones según tipo:  
  - **Verdadero/Falso**: exactamente **2** opciones, exactamente **1** correcta.  
  - **Selección Única**: mínimo 2 opciones, exactamente **1** correcta.  
  - **Selección Múltiple**: mínimo 2 opciones, al menos **1** correcta.  
- **RN-3**: Los metadatos (tema, dificultad, resultado de aprendizaje) deben pertenecer a **catálogos vigentes**.  
- **RN-4**: Todas las preguntas se crean en estado **activo** (visible para búsqueda y uso).  
- **RN-5**: La creación siempre genera **versión 1** y registra **trazabilidad** de autor y fecha de creación.  
- **RN-6**: Las alternativas deben tener posiciones únicas y consecutivas dentro de cada pregunta.  
- **RN-7**: Indexación inmediata para búsqueda (eventual, menos de 10 segundos en el 95% de los casos).

---

### Datos principales
- **Pregunta**: Identificador, enunciado, versión, estado de vigencia, referencia a versión original (para versionado), tema, dificultad, resultado de aprendizaje (opcional), tipo de pregunta, autor, fecha de creación.  
- **Alternativa**: Identificador, texto, marca de correcta, posición, puntaje parcial (opcional), pregunta asociada.  
- **Trazabilidad**: Autor y fecha/hora de creación.

---

### Consideraciones de seguridad/permiso
- Visibilidad por **repositorio/banco/carpeta**; herencia de permisos.  
- Solo usuarios con rol autorizado pueden **crear** y **ver** según visibilidad.  

---

### No funcionales
- **Usabilidad**: validaciones en línea, ayuda contextual para metadatos.  
- **Rendimiento**: creación menor a 2 segundos en el 95% de los casos (sin adjuntos); indexación eventual menor a 10 segundos en el 95% de los casos.  
- **Disponibilidad**: manejo de reintentos y auto-guardado de borrador local si falla red.  

---

### Criterios de aceptación (QA)
- **CA-1**: Dado un usuario con permisos, cuando completa enunciado+tipo+metadatos y guarda, entonces el Sistema asigna **ID** y muestra confirmación; el ítem aparece en búsqueda por **tema** y **unidad**.  
- **CA-2**: Dado tipo **Selección Múltiple** con 4 alternativas y 1 correcta, al guardar se crea versión 1 y queda disponible.  
- **CA-3**: Dado un metadato inexistente, el guardado se **bloquea** con mensaje que indica seleccionar desde catálogo.  
- **CA-4**: Dado enunciado similar a otro, el Sistema muestra **advertencia de duplicado** con enlace al existente; si el usuario confirma, se crea de todas formas.  
- **CA-5**: Tras crear, el ítem es **encontrable** por texto del enunciado y por filtros de Tema/Unidad/Dificultad.  
- **CA-6**: Se registra trazabilidad (usuario, fecha/hora, acción crear).  

---

## Anexo Técnico (para desarrollo)

> Esta sección contiene los detalles técnicos de implementación según el modelo de datos del sistema GRADE.

### Resumen del modelo de datos

#### Entidades principales involucradas
- **`questions`**: Almacena el enunciado y metadatos de cada pregunta (versión, vigencia, autor, fecha, **auditoría**).
- **`question_options`**: Almacena las alternativas de cada pregunta con su marca de correcta, posición y puntaje opcional.
- **`topics`**: Define el tema curricular (que implícitamente determina la unidad y asignatura). **Incluye auditoría completa**.
- **`difficulties`**: Catálogo de niveles de dificultad.
- **`outcomes`**: Catálogo de resultados de aprendizaje (opcional). **Incluye auditoría completa**.
- **`question_types`**: Catálogo de tipos de pregunta con códigos (`TF`, `SC`, `MC`).
- **`users`**: Registro de autores para trazabilidad. **Incluye auditoría completa**.

#### Relaciones clave
- Una **pregunta** referencia directamente solo al **tema** (`topic_fk`), no a unidad ni asignatura.
- La jerarquía curricular se infiere: `questions → topics → units → subjects`.
- Cada pregunta tiene múltiples **opciones** (`question_options`) relacionadas por `question_fk`.
- El **tipo de pregunta** determina las reglas de validación de opciones:
  - **TF** (True/False): exactamente 2 opciones, 1 correcta
  - **SC** (Single Choice): ≥2 opciones, 1 correcta
  - **MC** (Multiple Choice): ≥2 opciones, ≥1 correcta

#### Campos críticos para este caso de uso
**En `questions`:**
- `text` (enunciado), `version` (siempre 1 en creación), `active` (siempre true en creación)
- `topic_fk`, `difficulty_fk` (obligatorios), `outcome_fk` (opcional)
- `question_type_fk` (determina reglas de validación)
- `user_fk` (autor/creador), `created_at` (timestamp automático)
- `original_question_fk` (null en primera versión)
- **Auditoría**: `updated_at`, `updated_by`, `deleted_at`, `deleted_by` (null en creación)

**En `question_options`:**
- `text` (contenido de la opción), `is_correct` (boolean), `position` (entero 1..n)
- `score` (opcional para crédito parcial), `question_fk` (relación con pregunta)

#### Auditoría Soft
El sistema implementa **soft delete**: los registros nunca se eliminan físicamente, sino que se marcan con `deleted_at` y `deleted_by`. Esto permite:
- ✅ Trazabilidad completa de quién eliminó qué y cuándo
- ✅ Posibilidad de recuperar datos eliminados
- ✅ Integridad referencial preservada

### Validaciones implementadas en base de datos

Las reglas de cardinalidad de opciones se validan mediante **constraint triggers DEFERRABLE** que se ejecutan al hacer COMMIT de la transacción. Esto permite insertar primero la pregunta y luego sus opciones en operaciones separadas.

### Ejemplo de implementación (paso 7 del flujo principal)

```sql
-- 1. Insertar la pregunta
INSERT INTO questions (
    text, version, active, 
    topic_fk, difficulty_fk, outcome_fk, 
    question_type_fk, user_fk
) VALUES (
    'Enunciado de la pregunta',
    1, true,
    :topic_id, :difficulty_id, :outcome_id,  -- outcome_id puede ser NULL
    :question_type_id, :user_id
) RETURNING question_id;

-- 2. Insertar las alternativas
INSERT INTO question_options (
    text, is_correct, position, score, question_fk
) VALUES 
    ('Opción 1', false, 1, NULL, :question_id),
    ('Opción 2', true, 2, NULL, :question_id),
    ('Opción 3', false, 3, NULL, :question_id),
    ('Opción 4', false, 4, NULL, :question_id);

-- 3. COMMIT dispara validación de triggers
COMMIT;
```

### Inferencia de jerarquía curricular

Para mostrar al usuario la jerarquía completa (Asignatura > Unidad > Tema) al seleccionar un tema:

```sql
SELECT 
    s.subject_id, s.name as subject_name,
    u.unit_id, u.name as unit_name,
    t.topic_id, t.name as topic_name
FROM topics t
JOIN units u ON t.unit_fk = u.unit_id
JOIN subjects s ON u.subject_fk = s.subject_id
WHERE t.active = true
ORDER BY s.name, u.name, t.name;
```

Para recuperar la información completa de una pregunta creada:

```sql
SELECT 
    q.question_id, q.text, q.version,
    t.name as topic_name,
    u.name as unit_name,
    s.name as subject_name,
    d.level as difficulty,
    qt.name as question_type,
    o.code as outcome_code
FROM questions q
JOIN topics t ON q.topic_fk = t.topic_id
JOIN units u ON t.unit_fk = u.unit_id
JOIN subjects s ON u.subject_fk = s.subject_id
JOIN difficulties d ON q.difficulty_fk = d.difficulty_id
JOIN question_types qt ON q.question_type_fk = qt.question_type_id
LEFT JOIN outcomes o ON q.outcome_fk = o.outcome_id
WHERE q.question_id = :question_id;
```

### Índices recomendados
- `CREATE INDEX idx_questions_topic_active ON questions (topic_fk, active);`
- `CREATE INDEX idx_question_options_question ON question_options (question_fk);`
- (Opcional) Búsqueda de texto completo: `CREATE INDEX idx_questions_text_fts ON questions USING GIN (to_tsvector('spanish', text));`

### Referencias al modelo completo
Para más detalles sobre la estructura completa, restricciones, tipos de datos y triggers:
- [Modelo Entidad-Relación completo](../../../../06-data-model/question-bank/mer.md)
- [Script DDL de creación](../../../../06-data-model/question-bank/DDL.sql)
- [Triggers y funciones](../../../../06-data-model/question-bank/TRIGGERS.sql)

---

[Subir](#cu-bp-01--crear-ítem-nuevo-en-el-banco-de-preguntas)
