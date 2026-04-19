# Modelo Entidad-Relación propuesto para GRADE

> El sistema GRADE se compone de tres módulos principales de datos: un Banco de Preguntas, la Gestión de Evaluaciones, y un módulo de Ingesta Móvil. A continuación se presenta un MER en tercera forma normal para cada módulo, con tablas nombradas en inglés (plural) y columnas en singular. Las claves primarias (PK) se nombran como `$table_id` y las foráneas (FK) como `$table_fk` según convenciones indicadas.
>
> **🔍 Auditoría Soft:** Todos los módulos implementan un sistema de [auditoría soft transversal](AUDIT.md) con campos estándar (`created_at`, `created_by`, `updated_at`, `updated_by`, `deleted_at`, `deleted_by`) para trazabilidad completa y eliminación lógica (soft delete).

[Volver](../README.md)

<!-- TOC -->
* [Modelo Entidad-Relación propuesto para GRADE](#modelo-entidad-relación-propuesto-para-grade)
  * [Auditoría del Sistema](#auditoría-del-sistema)
  * [Banco de Preguntas (Question Bank)](#banco-de-preguntas-question-bank)
  * [Gestión de Evaluaciones (Grading Management)](#gestión-de-evaluaciones-grading-management)
  * [Ingesta Móvil (Mobile Ingest)](#ingesta-móvil-mobile-ingest)
  * [Resumen y enlaces](#resumen-y-enlaces)
<!-- TOC -->

## Auditoría del Sistema

El sistema GRADE implementa **auditoría soft** transversal a todos sus módulos. Esto significa que cada tabla principal incluye campos estándar de trazabilidad que registran automáticamente quién y cuándo realizó cada operación (creación, modificación, eliminación lógica).

**Características principales:**
- ✅ **Trazabilidad completa**: Se registra quién creó, modificó o eliminó cada registro
- ✅ **Soft delete**: Los registros nunca se eliminan físicamente, solo se marcan como eliminados
- ✅ **Recuperación de datos**: Posibilidad de restaurar registros eliminados accidentalmente
- ✅ **Cumplimiento normativo**: Registro automático para auditorías y compliance
- ✅ **Consistencia**: Mismo esquema de auditoría en todos los módulos del sistema

**Campos estándar de auditoría:**
- `created_at` / `created_by`: Quién y cuándo creó el registro (nunca cambian)
- `updated_at` / `updated_by`: Última modificación (NULL si nunca se modificó)
- `deleted_at` / `deleted_by`: Eliminación lógica (NULL si está activo)

[**📖 Guía completa de Auditoría Soft**](AUDIT.md) - Documentación detallada con ejemplos de implementación, consultas SQL, triggers automáticos y mejores prácticas.

---

## Banco de Preguntas (Question Bank)

El banco de preguntas centraliza los ítems o preguntas junto con sus metadatos pedagógicos. Cada pregunta puede estar asociada a taxonomías (tema, unidad curricular, resultado de aprendizaje) y posee un control de versiones y estado de vigencia. Además, se almacenan las alternativas de respuesta para cada pregunta (ej. opciones de selección múltiple) y se identifica cuál es la correcta. Un usuario (docente o coordinador) será el autor de cada pregunta.

**Características**: Cada pregunta tiene un identificador único y se registra con sus atributos principales (enunciado, tema, unidad, resultado de aprendizaje, dificultad). El campo `active` permite retirar o reactivar preguntas sin eliminarlas. Para soportar el versionado, `original_question_fk` apunta a la pregunta original en caso de haberse creado una nueva versión (manteniendo el historial de cambios). Las preguntas están asociadas a tablas de taxonomías administrables (temas, unidades curriculares, resultados de aprendizaje), y a una tabla de dificultad para niveles predefinidos. Cada pregunta es creada por un usuario autorizado (docente, coordinador) según su rol. Adicionalmente, cada pregunta posee múltiples opciones de respuesta (almacenadas en `QUESTION_OPTIONS`), con una marcación de cuál es la correcta – esto facilita la reutilización de ítems objetivos y la corrección automática.

[Análisis completo](question-bank/mer.md)

---

## Gestión de Evaluaciones (Grading Management)

> Este módulo cubre la creación y administración de evaluaciones (pruebas) a partir de las preguntas del banco, el registro de su aplicación y la calificación automática de los estudiantes. Cada evaluación tiene atributos como nombre, fecha, duración y escala de calificación, y puede estar en distintos estados (borrador, publicada/aplicada, calificada, etc.). Las evaluaciones se componen de múltiples preguntas seleccionadas del banco, y se genera un entregable (por ejemplo, PDF) con un identificador único (código/QR) para asegurar la trazabilidad. Además, se relacionan con el curso o grupo al que pertenece y, tras su aplicación, con las respuestas y notas de los estudiantes.

**Características**: Cada evaluación es creada por un usuario (docente o coordinador) y está asociada a un curso específico (clase o asignatura) al que pertenecen los estudiantes que la rendirán. La tabla COURSE_STUDENTS representa la matrícula de estudiantes en cursos. Una evaluación en estado borrador se compone seleccionando ítems del banco de preguntas, quedando estos vínculos en la tabla EVALUATION_QUESTIONS. Se almacena la estructura (incluyendo puntaje por pregunta y orden) y se puede generar un PDF entregable con formato estándar y un código/QR único impreso para identificar la evaluación. El entregable generado se asocia a la evaluación (pdf_path) y sirve para su distribución física/digital.

Una vez publicada y aplicada la evaluación, el sistema registra la participación de los estudiantes y sus resultados. La tabla STUDENT_EVALUATIONS representa cada intento o rendición de un estudiante en una evaluación (relación muchos a muchos entre estudiantes y evaluaciones). Aquí se puede almacenar el puntaje total obtenido por el alumno y la nota final convertida según la escala definida. Cada intento tiene sus respuestas por pregunta en la tabla STUDENT_ANSWERS: por cada pregunta incluida en la evaluación, se guarda la opción elegida por el estudiante y los puntos obtenidos (ejemplo: 0 si incorrecta, puntos completos si correcta). Estos datos permiten la calificación automática de ítems objetivos y el cálculo de notas, así como la generación de reportes pedagógicos (promedios, distribuciones, dificultad de ítems, etc.). La trazabilidad completa de cada pregunta se logra sabiendo en qué evaluaciones fue usada (EVALUATION_QUESTIONS) y consultando el desempeño de los estudiantes en esas preguntas (STUDENT_ANSWERS), por ejemplo: tasa de acierto, fecha de última utilización, etc.

[Análisis completo](grading-management/mer.md)

## Ingesta Móvil (Mobile Ingest)

> El módulo de **ingesta móvil** permite digitalizar las hojas de respuestas de las evaluaciones aplicadas, a través de la captura de fotos (escaneadas por la app móvil) y su posterior envío al sistema central. Los datos capturados se almacenan temporalmente en lotes asociados a cada evaluación, asegurando la correcta vinculación mediante el código/ID único de la prueba. Cada **lote** de captura contiene múltiples imágenes (fotografías de las hojas) y tiene un estado de procesamiento (pendiente, procesando, completado, con errores). Este diseño facilita el funcionamiento **offline** (almacenando datos localmente hasta poder enviarlos) y la confirmación de procesamiento de cada lote.

**Características**: La tabla `CAPTURE_BATCHES` representa un **lote de fotos capturadas** asociado a una evaluación determinada. Al iniciar la digitalización, el usuario de la app escanea el **código/QR** de la prueba para vincular el lote a la evaluación correcta. Luego toma fotos de cada hoja de respuestas; la aplicación valida la calidad de cada imagen y las agrega al lote. Una vez finalizada la captura, el usuario envía el lote al servidor, donde queda registrado con estado "Pending/Processing".

Cada **imagen** individual se guarda en `CAPTURE_IMAGES` con referencia al lote. El sistema puede actualizar el estado a "Completed" cuando las respuestas fueron leídas exitosamente (vía OCR) y almacenadas en las tablas de respuestas de estudiantes, o a "Error" si hubo dificultades (por ejemplo, imágenes ilegibles). En caso de errores, se pueden detallar en `error_details` cuáles hojas fallaron, permitiendo al docente reintentar la captura o cargar manualmente un CSV con las respuestas faltantes.

Este diseño transitorio garantiza que las respuestas capturadas estén t**razadas al examen correspondiente** y que ninguna captura se pierda: incluso sin conexión, la app almacenará localmente los lotes y los enviará cuando haya red, preservando la información en `CAPTURE_BATCHES` una vez que arriben al servidor. Tras el procesamiento, los datos relevantes se integran al módulo de evaluaciones (poblando `STUDENT_ANSWERS` y `STUDENT_EVALUATIONS` automáticamente), mientras que las imágenes pueden ser conservadas para auditoría o eliminadas según políticas de retención.

[Análisis completo](mobile-ingest/mer.md)

---

## Resumen y enlaces

- ERM general del modelo de datos: una vista integrada de Question Bank, Gestión de Evaluaciones e Ingesta Móvil, con relaciones clave y cardinalidades.
  - Ver: [Diagrama ER general](erm-general.md)
- Diccionario de datos: definiciones de tablas y campos, tipos/longitudes, valores permitidos, nulabilidad, PK/FK/UNIQUE/CHECK, relaciones, unidades y códigos, problemas conocidos y ejemplos.
  - Ver: [Diccionario de datos](data-dictionary.md)
