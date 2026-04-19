# CU-IM-12 — Ingesta por CSV/Web (canal alternativo)

- [Revisión](review.md)
- [Volver](../../README.md#3-ingesta-móvil)

## Escenario origen: S-IM-12 | Carga digital de respuestas alternativa

### RF relacionados: RF4, RF3, RF8

**Actor principal:** Docente / Coordinador académico  
**Actores secundarios:** Sistema GRADE (Gestión de evaluaciones), Sistema de procesamiento

---

### Objetivo
Permitir la carga de respuestas de estudiantes mediante archivos CSV o formularios web como canal alternativo a la ingesta móvil, integrándose con el mismo pipeline de procesamiento y posting para garantizar consistencia en el flujo de calificación.

### Precondiciones
- Usuario autenticado con permisos sobre la evaluación y curso.
- La evaluación está en estado **Aplicada** y acepta ingesta digital.
- Template de CSV o estructura de datos está configurada para la evaluación.
- Estudiantes están matriculados en el curso correspondiente.

### Postcondiciones
- Respuestas cargadas se integran al pipeline de procesamiento estándar.
- Se crea lote de ingesta digital con trazabilidad completa.
- Datos validados procesan automáticamente hacia sistema de calificaciones.
- Errores y anomalías se manejan consistentemente con ingesta móvil.
- Auditoría completa del proceso de carga digital.

### Flujo principal (éxito)
1. **Selección de método de ingesta:**
   - Usuario navega a la evaluación desde el dashboard
   - Selecciona **"Cargar respuestas digitalmente"**
   - Sistema presenta opciones:
     - **Upload CSV:** Para lotes masivos
     - **Formulario web:** Para entrada manual
2. **Configuración de carga CSV:**
   - Usuario selecciona **"Upload de archivo CSV"**
   - Sistema muestra template esperado y formato requerido
   - Descarga ejemplo con estructura: ID_Estudiante, P1, P2, P3...
   - Usuario prepara archivo según especificaciones
3. **Upload y validación inicial:**
   - Usuario sube archivo CSV mediante drag & drop o selector
   - Sistema ejecuta validaciones básicas:
     - Formato de archivo válido (CSV, encoding UTF-8)
     - Estructura de columnas coincide con template
     - Cantidad de preguntas coincide con evaluación
4. **Validación de contenido:**
   - Sistema procesa cada fila del CSV:
     - Valida IDs de estudiantes contra matriculación del curso
     - Verifica formato de respuestas según tipo de pregunta
     - Detecta respuestas duplicadas o inconsistentes
     - Identifica estudiantes no matriculados o IDs inválidos
5. **Revisión de anomalías:**
   - Sistema presenta reporte de validación con:
     - Respuestas válidas listas para procesar
     - Errores por fila (estudiante no encontrado, respuesta inválida)
     - Advertencias (respuestas existentes, datos sospechosos)
   - Usuario puede corregir errores y re-subir o proceder con válidas
6. **Creación de lote digital:**
   - Sistema crea lote de ingesta con tipo **Digital**
   - Asocia lote a evaluación y usuario que realizó la carga
   - Registra metadatos: archivo origen, timestamp, cantidad registros
7. **Procesamiento integrado:**
   - Sistema convierte datos CSV a formato interno estándar
   - Crea registros de ingesta equivalentes a captura móvil
   - Aplica mismo pipeline de validación y posting
   - Mantiene trazabilidad completa del origen digital
8. **Confirmación y seguimiento:**
   - Usuario recibe confirmación de carga exitosa
   - Sistema muestra progreso de procesamiento en tiempo real
   - Integración transparente con dashboard de monitoreo
   - Notificaciones siguiendo misma lógica que ingesta móvil

### Flujos alternativos / Excepciones
- **A1 — Archivo CSV con errores de formato:**
  - Sistema rechaza archivo y especifica problemas:
    - Encoding incorrecto, delimitadores mal configurados
    - Columnas faltantes o en orden incorrecto
    - Caracteres especiales que causan problemas de parsing
  - Proporciona herramientas de corrección o conversión
- **A2 — Estudiantes no matriculados:**
  - Sistema identifica IDs que no corresponden a estudiantes del curso
  - Ofrece opciones: descartar filas, mapear a estudiantes existentes
  - Permite crear solicitud de matriculación si es apropiado
- **A3 — Respuestas duplicadas:**
  - Sistema detecta que estudiantes ya tienen respuestas registradas
  - Aplica políticas configuradas: sobrescribir, mantener original, conflicto
  - Solicita confirmación explícita para cambios destructivos
- **A4 — Formulario web para corrección:**
  - Si hay pocos errores, sistema ofrece formulario web para corrección
  - Permite edición fila por fila con validación en tiempo real
  - Integra correcciones automáticamente al lote de carga
- **A5 — Archivo muy grande:**
  - Sistema procesa archivo en chunks para evitar timeouts
  - Muestra progreso de procesamiento por lotes
  - Permite cancelación durante procesamiento si es necesario
- **A6 — Formato de respuestas inconsistente:**
  - Detecta respuestas que no siguen formato esperado (A,B,C vs 1,2,3)
  - Ofrece mapeo automático o manual según patrones detectados
  - Valida que mapeo sea consistente para toda la evaluación

### Reglas de negocio
- **RN-1:** Solo usuarios con permisos de calificación pueden usar ingesta digital.
- **RN-2:** La evaluación debe estar configurada para aceptar ingesta digital.
- **RN-3:** Estudiantes deben estar matriculados en el curso para procesar sus respuestas.
- **RN-4:** El formato CSV debe coincidir exactamente con template de la evaluación.
- **RN-5:** Respuestas duplicadas requieren confirmación explícita del usuario.
- **RN-6:** Lotes digitales siguen mismo pipeline de auditoría que móviles.

### Datos principales
- **Lote de Ingesta Digital** (identificador, evaluación, archivo origen, usuario carga, tipo canal)
- **Registro de Carga** (lote, filas procesadas, filas válidas, filas con error, timestamp)
- **Mapeo de Respuestas** (lote, estudiante, pregunta, respuesta original, respuesta mapeada)
- **Error de Validación** (lote, fila, columna, tipo error, mensaje, sugerencia corrección)
- **Archivo de Origen** (lote, nombre archivo, tamaño, hash, ruta almacenamiento)

### Consideraciones de seguridad/permiso
- **Validación de archivos:** Escaneo de virus y validación de contenido antes de procesar.
- **Encriptación:** Archivos cargados se cifran inmediatamente después del upload.
- **Auditoría completa:** Registro de quién cargó qué archivo y cuándo.
- **Limpieza automática:** Archivos temporales se eliminan después del procesamiento.
- **Permisos granulares:** Solo usuarios autorizados pueden usar cada método de carga.

### No funcionales
- **Rendimiento:** 
  - Procesamiento de CSV < 10s p95 para 1000 respuestas
  - Upload de archivos < 5MB sin timeout
- **Escalabilidad:** 
  - Soporte para archivos hasta 50MB (aprox. 50k respuestas)
  - Procesamiento en paralelo para archivos grandes
- **Usabilidad:** 
  - Templates de ejemplo descargables
  - Validación con feedback específico y accionable
- **Confiabilidad:** 
  - Validación exhaustiva antes de integrar al pipeline
  - Rollback automático si procesamiento falla

### Criterios de aceptación (QA)
- **CA-1:** Usuario debe poder cargar CSV válido y ver procesamiento completo en < 30 segundos.
- **CA-2:** Sistema debe rechazar archivos con formato incorrecto con mensajes específicos.
- **CA-3:** Validaciones deben identificar todos los errores de datos antes del procesamiento.
- **CA-4:** Lotes digitales deben integrarse transparentemente con dashboard de monitoreo.
- **CA-5:** Respuestas procesadas deben aparecer en sistema de calificaciones igual que móviles.
- **CA-6:** Errores de estudiantes no matriculados deben manejarse graciosamente.
- **CA-7:** Sistema debe mantener auditoría completa del archivo origen y transformaciones.

---

## Anexo Técnico (para desarrollo)

> Esta sección contiene los detalles técnicos de implementación del sistema de ingesta digital según el modelo de datos del sistema de Ingesta Móvil.

### Resumen del modelo de datos

#### Entidades principales involucradas
- **`digital_ingest_batches`**: Lotes de ingesta específicos para canal digital con metadatos de archivo.
- **`csv_upload_sessions`**: Sesiones de carga con validaciones y estado de procesamiento.
- **`digital_response_mappings`**: Mapeo de respuestas desde formato CSV a estructura interna.
- **`upload_validation_errors`**: Errores detectados durante validación con detalles específicos.
- **`ingest_results`**: Misma tabla que móvil, con flag de origen digital.
- **`processing_jobs`**: Mismo pipeline de procesamiento que ingesta móvil.

#### Relaciones clave
- Los **lotes digitales** se integran con el pipeline estándar de `ingest_batches`.
- Las **validaciones** aseguran compatibilidad con estructura de evaluación.
- Los **mapeos de respuestas** convierten datos CSV a formato interno estándar.
- El **procesamiento** usa exactamente el mismo pipeline que ingesta móvil.

#### Campos críticos para este caso de uso
**En `digital_ingest_batches`:**
- `source_file_path`, `source_file_hash`, `upload_method` (csv/web)
- `total_rows`, `valid_rows`, `error_rows`, `processed_rows`

**En `csv_upload_sessions`:**
- `session_id`, `user_fk`, `evaluation_fk`, `upload_status`
- `validation_errors`, `processing_progress`

**En `digital_response_mappings`:**
- `batch_fk`, `student_identifier`, `responses_data`,
- `validation_status`, `mapped_at`

#### Arquitectura de Ingesta Digital
El sistema usa **parsing robusto de CSV**, **validación en múltiples fases**, y **integración transparente** con pipeline existente.

### Validaciones implementadas en base de datos

**Validar estructura de CSV:**
```sql
-- Función para validar template de CSV
CREATE OR REPLACE FUNCTION validate_csv_structure(
    evaluation_id BIGINT,
    csv_headers TEXT[]
) RETURNS JSONB AS $$
DECLARE
    expected_columns INTEGER;
    header_check RECORD;
    validation_result JSONB;
BEGIN
    -- Obtener estructura esperada de la evaluación
    SELECT COUNT(*) INTO expected_columns
    FROM evaluation_questions eq
    WHERE eq.evaluation_fk = evaluation_id
    ORDER BY eq.sequence;
    
    -- Validar que hay columna de estudiante + columnas de respuestas
    IF array_length(csv_headers, 1) != (expected_columns + 1) THEN
        validation_result := jsonb_build_object(
            'valid', false,
            'error', 'Column count mismatch',
            'expected', expected_columns + 1,
            'found', array_length(csv_headers, 1)
        );
    ELSE
        -- Validar nombres de columnas
        validation_result := jsonb_build_object(
            'valid', true,
            'student_column', csv_headers[1],
            'question_columns', array_length(csv_headers, 1) - 1
        );
    END IF;
    
    RETURN validation_result;
END;
$$ LANGUAGE plpgsql;
```

**Validar estudiantes y respuestas:**
```sql
-- Validar fila individual de CSV
CREATE OR REPLACE FUNCTION validate_csv_row(
    evaluation_id BIGINT,
    student_id TEXT,
    responses TEXT[]
) RETURNS JSONB AS $$
DECLARE
    student_record RECORD;
    question_record RECORD;
    validation_errors JSONB := '[]'::JSONB;
    i INTEGER;
BEGIN
    -- Validar estudiante
    SELECT s.student_id, s.full_name INTO student_record
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_fk
    JOIN evaluations ev ON e.course_fk = ev.course_fk
    WHERE s.identifier = student_id
    AND ev.evaluation_id = evaluation_id
    AND e.active = true;
    
    IF NOT FOUND THEN
        validation_errors := validation_errors || 
            jsonb_build_object(
                'type', 'student_not_found',
                'field', 'student_id',
                'value', student_id,
                'message', 'Student not enrolled in course'
            );
    END IF;
    
    -- Validar cada respuesta
    FOR i IN 1..array_length(responses, 1) LOOP
        SELECT eq.question_type, eq.sequence INTO question_record
        FROM evaluation_questions eq
        WHERE eq.evaluation_fk = evaluation_id
        AND eq.sequence = i;
        
        IF FOUND THEN
            -- Validar formato de respuesta según tipo
            IF question_record.question_type = 'multiple_choice' THEN
                IF responses[i] !~ '^[A-E]$' AND responses[i] !~ '^[1-5]$' THEN
                    validation_errors := validation_errors ||
                        jsonb_build_object(
                            'type', 'invalid_response_format',
                            'field', 'question_' || i,
                            'value', responses[i],
                            'message', 'Multiple choice must be A-E or 1-5'
                        );
                END IF;
            END IF;
        END IF;
    END LOOP;
    
    RETURN jsonb_build_object(
        'valid', jsonb_array_length(validation_errors) = 0,
        'errors', validation_errors,
        'student_found', student_record.student_id IS NOT NULL
    );
END;
$$ LANGUAGE plpgsql;
```

### Ejemplo de implementación de procesamiento CSV

```sql
-- FUNCIÓN PRINCIPAL DE PROCESAMIENTO CSV
CREATE OR REPLACE FUNCTION process_csv_upload(
    session_id UUID,
    evaluation_id BIGINT,
    user_id BIGINT,
    csv_data JSONB  -- Array de objetos {student_id, responses}
) RETURNS JSONB AS $$
DECLARE
    batch_id BIGINT;
    row_data JSONB;
    validation_result JSONB;
    total_rows INTEGER;
    valid_rows INTEGER := 0;
    error_rows INTEGER := 0;
    processing_result JSONB;
BEGIN
    total_rows := jsonb_array_length(csv_data);
    
    -- PASO 1: Crear lote de ingesta digital
    INSERT INTO digital_ingest_batches (
        evaluation_fk, course_fk, uploaded_by_fk,
        upload_method, total_rows, started_at, state
    )
    SELECT 
        evaluation_id,
        e.course_fk,
        user_id,
        'csv',
        total_rows,
        NOW(),
        'Processing'
    FROM evaluations e
    WHERE e.evaluation_id = evaluation_id
    RETURNING digital_batch_id INTO batch_id;
    
    -- PASO 2: Procesar cada fila
    FOR i IN 0..(total_rows - 1) LOOP
        row_data := csv_data->i;
        
        -- Validar fila
        validation_result := validate_csv_row(
            evaluation_id,
            row_data->>'student_id',
            ARRAY(SELECT jsonb_array_elements_text(row_data->'responses'))
        );
        
        IF (validation_result->>'valid')::BOOLEAN THEN
            -- Crear mapeo de respuestas válidas
            INSERT INTO digital_response_mappings (
                batch_fk, student_identifier, responses_data,
                validation_status, mapped_at
            ) VALUES (
                batch_id,
                row_data->>'student_id',
                row_data->'responses',
                'valid',
                NOW()
            );
            
            valid_rows := valid_rows + 1;
        ELSE
            -- Registrar errores de validación
            INSERT INTO upload_validation_errors (
                batch_fk, row_number, errors_data, created_at
            ) VALUES (
                batch_id,
                i + 1,
                validation_result->'errors',
                NOW()
            );
            
            error_rows := error_rows + 1;
        END IF;
    END LOOP;
    
    -- PASO 3: Actualizar estado del lote
    UPDATE digital_ingest_batches
    SET 
        valid_rows = valid_rows,
        error_rows = error_rows,
        processed_at = NOW(),
        state = CASE 
            WHEN valid_rows > 0 THEN 'Ready'
            ELSE 'Failed'
        END
    WHERE digital_batch_id = batch_id;
    
    -- PASO 4: Si hay respuestas válidas, crear resultados de ingesta
    IF valid_rows > 0 THEN
        INSERT INTO ingest_results (
            digital_batch_fk, evaluation_fk, resolved_student_fk,
            total_marked, source_type, state
        )
        SELECT 
            batch_id,
            evaluation_id,
            s.student_id,
            jsonb_array_length(drm.responses_data),
            'digital_csv',
            'Ready'
        FROM digital_response_mappings drm
        JOIN students s ON s.identifier = drm.student_identifier
        WHERE drm.batch_fk = batch_id
        AND drm.validation_status = 'valid';
    END IF;
    
    processing_result := jsonb_build_object(
        'success', true,
        'batch_id', batch_id,
        'total_rows', total_rows,
        'valid_rows', valid_rows,
        'error_rows', error_rows,
        'ready_for_posting', valid_rows > 0
    );
    
    RETURN processing_result;
END;
$$ LANGUAGE plpgsql;
```

### API para ingesta digital

**Endpoints principales:**
```javascript
// POST /api/evaluations/:id/upload-csv
app.post('/api/evaluations/:id/upload-csv', 
    upload.single('csvFile'), 
    async (req, res) => {
    const { id } = req.params;
    const userId = req.user.id;
    const csvFile = req.file;
    
    try {
        // Validar permisos sobre evaluación
        const evaluation = await getEvaluationWithPermissionCheck(id, userId);
        if (!evaluation) {
            return res.status(404).json({ error: 'Evaluation not found or access denied' });
        }
        
        // Crear sesión de upload
        const session = await createUploadSession({
            evaluationId: id,
            userId: userId,
            fileName: csvFile.originalname,
            fileSize: csvFile.size
        });
        
        // Procesar CSV
        const csvData = await parseCSVFile(csvFile.path);
        const processingResult = await processCSVUpload({
            sessionId: session.id,
            evaluationId: id,
            userId: userId,
            csvData: csvData
        });
        
        // Limpiar archivo temporal
        await fs.unlink(csvFile.path);
        
        res.json({
            sessionId: session.id,
            batchId: processingResult.batchId,
            summary: {
                totalRows: processingResult.totalRows,
                validRows: processingResult.validRows,
                errorRows: processingResult.errorRows
            },
            readyForPosting: processingResult.readyForPosting
        });
        
    } catch (error) {
        res.status(500).json({ error: 'CSV processing failed' });
    }
});

// GET /api/digital-batches/:id/validation-errors
app.get('/api/digital-batches/:id/validation-errors', async (req, res) => {
    const { id } = req.params;
    const userId = req.user.id;
    
    try {
        const errors = await getValidationErrors(id, userId);
        
        res.json({
            batchId: id,
            errors: errors,
            totalErrors: errors.length,
            suggestions: generateCorrectionSuggestions(errors)
        });
        
    } catch (error) {
        res.status(500).json({ error: 'Failed to retrieve validation errors' });
    }
});
```

### Integración con pipeline de procesamiento

**Convertir datos digitales a formato estándar:**
```javascript
async function convertDigitalToStandardFormat(digitalBatchId) {
    // Obtener mapeos de respuestas válidas
    const mappings = await db.query(`
        SELECT 
            drm.student_identifier,
            drm.responses_data,
            s.student_id,
            e.evaluation_id
        FROM digital_response_mappings drm
        JOIN students s ON s.identifier = drm.student_identifier
        JOIN digital_ingest_batches dib ON drm.batch_fk = dib.digital_batch_id
        JOIN evaluations e ON dib.evaluation_fk = e.evaluation_id
        WHERE drm.batch_fk = $1
        AND drm.validation_status = 'valid'
    `, [digitalBatchId]);
    
    // Crear registros compatibles con pipeline móvil
    for (const mapping of mappings.rows) {
        // Simular página escaneada para mantener consistencia
        const virtualPageId = await createVirtualScannedPage({
            batchId: digitalBatchId,
            studentId: mapping.student_id,
            sourceType: 'digital_csv'
        });
        
        // Crear detecciones de burbujas simuladas
        const responses = JSON.parse(mapping.responses_data);
        for (let i = 0; i < responses.length; i++) {
            await createVirtualBubbleDetection({
                pageId: virtualPageId,
                questionSequence: i + 1,
                selectedOption: responses[i],
                confidence: 1.0,  // Máxima confianza para entrada manual
                source: 'digital_input'
            });
        }
    }
}
```

### Herramientas de corrección web

**Formulario de corrección inline:**
```javascript
// Interfaz web para corregir errores menores
class CSVCorrectionInterface {
    constructor(batchId, errors) {
        this.batchId = batchId;
        this.errors = errors;
        this.corrections = new Map();
    }
    
    renderErrorRow(error) {
        return `
            <tr data-row="${error.rowNumber}">
                <td>${error.rowNumber}</td>
                <td>${error.studentId}</td>
                <td class="error">${error.errorMessage}</td>
                <td>
                    ${this.renderCorrectionField(error)}
                    <button onclick="this.validateCorrection(${error.rowNumber})">
                        Validate
                    </button>
                </td>
            </tr>
        `;
    }
    
    async submitCorrections() {
        const corrections = Array.from(this.corrections.entries());
        
        const response = await fetch(`/api/digital-batches/${this.batchId}/corrections`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ corrections })
        });
        
        if (response.ok) {
            const result = await response.json();
            this.showSuccess(`Corrected ${result.correctedRows} rows`);
            window.location.reload();
        }
    }
}
```

### Índices recomendados
- `CREATE INDEX idx_digital_ingest_batches_evaluation ON digital_ingest_batches (evaluation_fk, state);`
- `CREATE INDEX idx_digital_response_mappings_batch ON digital_response_mappings (batch_fk, validation_status);`
- `CREATE INDEX idx_upload_validation_errors_batch ON upload_validation_errors (batch_fk, row_number);`

### Referencias al modelo completo
Para más detalles sobre la estructura completa, restricciones, tipos de datos y triggers:
- [Modelo Entidad-Relación completo](../../../../06-data-model/mobile-ingest/mer.md)
- [Script DDL de creación](../../../../06-data-model/mobile-ingest/DDL.sql)
- [Triggers y funciones](../../../../06-data-model/mobile-ingest/TRIGGERS.sql)

---

[Subir](#cu-im-12--ingesta-por-csvweb-canal-alternativo)
