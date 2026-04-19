# CU-BP-14 — Importar ítems desde planilla CSV

> Este caso de uso detalla la importación masiva de preguntas desde archivos CSV al Banco de Preguntas, basado en el escenario S-BP-07 | Importar ítems desde planillas.

- [Revisión](reviews.md)
- [Volver](../../README.md#1-banco-de-preguntas)

<!-- TOC -->
* [CU-BP-14 — Importar ítems desde planilla CSV](#cu-bp-14--importar-ítems-desde-planilla-csv)
  * [Escenario origen: S-BP-07 | Importar ítems desde planillas](#escenario-origen-s-bp-07--importar-ítems-desde-planillas)
    * [RF relacionados: RF2, RF8](#rf-relacionados-rf2-rf8)
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
    * [Estructura CSV requerida](#estructura-csv-requerida)
    * [Validaciones por campo](#validaciones-por-campo)
    * [Proceso de importación](#proceso-de-importación)
    * [Manejo de errores](#manejo-de-errores)
    * [Consideraciones de implementación](#consideraciones-de-implementación)
<!-- TOC -->

## Escenario origen: S-BP-07 | Importar ítems desde planillas

### RF relacionados: RF2, RF8

**Actor principal:** Coordinador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Coordinador cargue múltiples preguntas al Banco de preguntas desde un archivo CSV con estructura predefinida, para acelerar la creación inicial del banco. Cada pregunta queda clasificada según la jerarquía curricular **Asignatura > Unidad > Tema** y con todos sus metadatos asociados.

### Precondiciones
- Usuario autenticado con permisos de Coordinador.
- El archivo CSV cumple con la estructura mínima establecida.
- Los elementos de taxonomía curricular (temas, dificultades, tipos de pregunta) referenciados ya existen en el sistema.
- Tamaño del archivo dentro de los límites permitidos.

### Postcondiciones
- Los ítems válidos de la planilla quedan registrados en el Banco de preguntas.
- Cada pregunta tiene su clasificación completa en la jerarquía curricular.
- Se generan las opciones de respuesta asociadas a cada pregunta.
- El sistema genera reporte detallado de éxito y errores encontrados.
- Los ítems importados quedan en estado **Borrador** para revisión posterior.

### Flujo principal (éxito)
1. El Coordinador accede a la opción **"Importar desde CSV"**.
2. El Sistema muestra la plantilla CSV con las columnas requeridas y ejemplos.
3. El Coordinador selecciona y sube su archivo CSV.
4. El Sistema realiza validación estructural del archivo.
5. El Sistema valida el contenido y referencias a taxonomías existentes.
6. El Sistema procesa cada fila válida:
   - Crea la pregunta con clasificación en la jerarquía curricular
   - Genera las opciones de respuesta asociadas
   - Asigna metadatos (dificultad, tipo, resultado de aprendizaje)
7. El Sistema genera reporte de importación con detalle por línea.
8. El Sistema confirma importación exitosa y muestra resumen.

### Flujos alternativos / Excepciones
- **A1 — Archivo con errores estructurales:** El Sistema rechaza la importación completa y entrega reporte de errores de formato.
- **A2 — Archivo mixto (filas válidas y erróneas):** El Sistema importa las filas válidas y genera reporte detallado con las inválidas para corrección.
- **A3 — Referencias inexistentes:** El Sistema detecta temas, dificultades o tipos de pregunta no existentes y reporta las inconsistencias.
- **A4 — Tamaño excedido:** El Sistema bloquea y sugiere dividir el archivo o contactar administrador.
- **A5 — Preguntas duplicadas:** El Sistema detecta posibles duplicados y permite al coordinador decidir si importar o saltar.
- **A6 — Cancelación:** El Coordinador puede abortar la importación en cualquier momento antes de la confirmación final.

### Reglas de negocio
- **RN-1:** El CSV debe seguir exactamente la plantilla definida con columnas obligatorias y opcionales.
- **RN-2:** Los ítems importados heredan el estado **Borrador** hasta revisión y activación manual.
- **RN-3:** Todos los registros deben incluir: enunciado, tipo de pregunta, al menos 2 opciones, respuesta correcta, y tema existente.
- **RN-4:** Los temas referenciados deben existir previamente en el sistema (creados via CU-BP-11).
- **RN-5:** Las preguntas se clasifican automáticamente según la jerarquía: tema → unidad → asignatura.
- **RN-6:** Cada pregunta debe tener al menos una opción marcada como correcta.
- **RN-7:** Las preguntas de Verdadero/Falso deben tener exactamente 2 opciones.

### Datos principales
- **Archivo CSV** (`filename`, `size`, `upload_timestamp`, `processed_rows`, `valid_rows`, `error_rows`)
- **Preguntas importadas** (`question_id`, `text`, `topic_fk`, `difficulty_fk`, `question_type_fk`, `outcome_fk`, `user_fk`, `active=false`)
- **Opciones de respuesta** (`question_option_id`, `text`, `is_correct`, `position`, `score`, `question_fk`)
- **Reporte de importación** (`total_rows`, `imported_count`, `error_count`, `error_details[]`)

### Consideraciones de seguridad/permiso
- Validar permisos de Coordinador antes de permitir importación.
- Los archivos subidos deben pasar validaciones de seguridad (sanitización, límite de tamaño, tipo MIME).
- Prevenir inyección de código malicioso en contenido de preguntas.
- Auditar todas las importaciones con usuario, timestamp y archivo procesado.

### No funcionales
- **Rendimiento:** Procesar al menos 500 ítems en < 2 minutos.
- **Usabilidad:** Reporte claro de errores por línea con descripción específica del problema.
- **Disponibilidad:** La importación no debe interrumpir otras operaciones del Banco de preguntas.
- **Escalabilidad:** Soporte para archivos de hasta 10,000 preguntas en modo batch.

### Criterios de aceptación (QA)
- **CA-1:** Al cargar un CSV válido, el sistema importa todos los ítems y muestra reporte de éxito con detalles.
- **CA-2:** Si hay filas con errores, el sistema las señala específicamente (línea, campo, problema) y permite corrección.
- **CA-3:** Los ítems importados aparecen en el Banco en estado **Borrador** con jerarquía curricular completa.
- **CA-4:** El sistema valida que temas, dificultades y tipos de pregunta existan antes de importar.
- **CA-5:** Las opciones de respuesta se crean correctamente con al menos una marcada como correcta.
- **CA-6:** El sistema bloquea archivos que exceden límites o no cumplen formato CSV válido.

---

## Anexo Técnico (para desarrollo)

> Especificaciones técnicas para implementar la importación CSV según el modelo DDL del banco de preguntas.

### Estructura CSV requerida

**Columnas obligatorias:**
- `question_text`: Enunciado de la pregunta
- `question_type`: Código del tipo (TF|SC|MC - debe existir en `question_types.code`)
- `topic`: Nombre del tema (debe existir en `topics.name` y estar activo)
- `difficulty`: Nivel de dificultad (debe existir en `difficulties.level`)
- `option_1_text`: Texto de primera opción
- `option_1_correct`: true/false si es correcta
- `option_2_text`: Texto de segunda opción  
- `option_2_correct`: true/false si es correcta

**Columnas opcionales:**
- `outcome_code`: Código del resultado de aprendizaje (debe existir en `outcomes.code`)
- `option_3_text`, `option_3_correct`: Tercera opción (para MC)
- `option_4_text`, `option_4_correct`: Cuarta opción (para MC)
- `option_5_text`, `option_5_correct`: Quinta opción (para MC)

**Ejemplo de plantilla:**
```csv
question_text,question_type,topic,difficulty,option_1_text,option_1_correct,option_2_text,option_2_correct,option_3_text,option_3_correct,outcome_code
"¿Cuál es el resultado de 2+2?",SC,"Operaciones Básicas",Easy,"3",false,"4",true,"5",false,LO-MAT-1.1
"La Tierra es plana",TF,"Geografía Física",Easy,"Verdadero",false,"Falso",true,,,LO-GEO-2.3
```

### Validaciones por campo

**Validación de estructura:**
```sql
-- Verificar que el tema existe y está activo
SELECT t.topic_id, u.unit_id, s.subject_id 
FROM topics t 
JOIN units u ON t.unit_fk = u.unit_id 
JOIN subjects s ON u.subject_fk = s.subject_id 
WHERE t.name = :topic_name AND t.active = TRUE;

-- Verificar tipo de pregunta
SELECT question_type_id FROM question_types WHERE code = :question_type_code;

-- Verificar dificultad
SELECT difficulty_id FROM difficulties WHERE level = :difficulty_level;

-- Verificar resultado de aprendizaje (opcional)
SELECT outcome_id FROM outcomes WHERE code = :outcome_code;
```

**Validación de contenido:**
- Al menos 2 opciones para cualquier tipo de pregunta
- Exactamente 2 opciones para tipo TF (Verdadero/Falso)
- Al menos una opción marcada como correcta
- Texto de pregunta no vacío (mínimo 10 caracteres)
- Textos de opciones no vacíos y únicos dentro de la pregunta

### Proceso de importación

**Flujo de procesamiento:**
```sql
-- 1. Insertar pregunta principal
INSERT INTO questions (
  text, topic_fk, difficulty_fk, question_type_fk, 
  outcome_fk, user_fk, active, created_at
) VALUES (
  :question_text, :topic_id, :difficulty_id, :question_type_id,
  :outcome_id, :user_id, FALSE, NOW()
) RETURNING question_id;

-- 2. Insertar opciones de respuesta
INSERT INTO question_options (
  text, is_correct, position, question_fk
) VALUES 
  (:option_1_text, :option_1_correct, 1, :question_id),
  (:option_2_text, :option_2_correct, 2, :question_id),
  -- ... más opciones según el tipo
;
```

**Transaccionalidad:**
- Cada pregunta (con sus opciones) se procesa en una transacción independiente
- Si una pregunta falla, no afecta a las demás
- Rollback automático por pregunta en caso de error

### Manejo de errores

**Tipos de error y códigos:**
- `ERR_MISSING_COLUMN`: Columna obligatoria faltante
- `ERR_TOPIC_NOT_FOUND`: Tema no existe o está inactivo
- `ERR_INVALID_DIFFICULTY`: Nivel de dificultad no válido
- `ERR_INVALID_QUESTION_TYPE`: Tipo de pregunta no válido
- `ERR_NO_CORRECT_OPTION`: Ninguna opción marcada como correcta
- `ERR_INVALID_TF_OPTIONS`: Pregunta TF debe tener exactamente 2 opciones
- `ERR_DUPLICATE_OPTION_TEXT`: Textos de opciones duplicados
- `ERR_QUESTION_TOO_SHORT`: Enunciado demasiado corto

**Formato de reporte de errores:**
```json
{
  "import_summary": {
    "total_rows": 150,
    "imported": 142,
    "errors": 8,
    "processing_time": "00:01:23"
  },
  "errors": [
    {
      "row": 15,
      "error_code": "ERR_TOPIC_NOT_FOUND",
      "error_message": "El tema 'Álgebra Avanzada' no existe en el sistema",
      "field": "topic"
    },
    {
      "row": 23,
      "error_code": "ERR_NO_CORRECT_OPTION", 
      "error_message": "Debe haber al menos una opción correcta",
      "field": "option_*_correct"
    }
  ]
}
```

### Consideraciones de implementación

**Procesamiento batch:**
- Procesar archivos en chunks de 100 preguntas para evitar timeouts
- Mostrar progreso en tiempo real durante la importación
- Permitir cancelación durante el procesamiento

**Validación previa:**
- Validar estructura CSV antes de procesar contenido
- Pre-cargar catálogos de temas, dificultades y tipos para validación rápida
- Verificar límites de tamaño antes de iniciar procesamiento

**API sugerida:**
```
POST /api/questions/import          # Subir archivo y iniciar importación
GET  /api/questions/import/:job_id  # Ver progreso de importación
GET  /api/questions/import/template # Descargar plantilla CSV
```

**Optimizaciones:**
- Índices en tablas de catálogo para lookups rápidos
- Pool de conexiones para procesamiento concurrente
- Cache de validaciones repetitivas (mismo tema usado múltiples veces)

**Auditoría:**
- Log de todas las importaciones con detalles del archivo
- Tracking de preguntas importadas por usuario y fecha  
- Métricas de éxito/error por coordinador para mejora continua

---

**Nota:** La importación CSV facilita la migración masiva de preguntas existentes mientras mantiene la integridad de la jerarquía curricular y todos los metadatos necesarios para el funcionamiento óptimo del banco de preguntas.

[Subir](#cu-bp-14--importar-ítems-desde-planilla-csv)