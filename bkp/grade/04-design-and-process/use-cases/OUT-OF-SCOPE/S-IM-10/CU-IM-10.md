# CU-IM-10 — Configuración de templates de evaluación

- [Revisión](review.md)
- [Volver](../../README.md#3-ingesta-móvil)

## Escenario origen: S-IM-10 | Configuración de plantillas para OCR

### RF relacionados: RF4, RF2

**Actor principal:** Administrador del sistema / Coordinador técnico  
**Actores secundarios:** Docente, Sistema GRADE (Pipeline de procesamiento)

---

### Objetivo
Permitir la creación, calibración y gestión de templates (plantillas) de evaluación que definen la estructura y coordenadas de elementos detectables (QR, burbujas, áreas de texto) para optimizar la precisión del procesamiento OCR y reconocimiento de respuestas.

### Precondiciones
- Usuario con permisos administrativos o de configuración técnica.
- Imagen de muestra de hoja de respuesta disponible para calibración.
- Evaluación creada con estructura de preguntas definida.
- Herramientas de calibración visual disponibles en la interfaz.

### Postcondiciones
- Template creado y asociado a evaluación específica o como template genérico.
- Coordenadas de detección calibradas y validadas para alta precisión.
- Template disponible para uso en pipeline de procesamiento OCR.
- Versiones anteriores del template archivadas para trazabilidad.
- Métricas de efectividad del template registradas para optimización.

### Flujo principal (éxito)
1. **Inicio de configuración de template:**
   - Usuario accede a **"Gestión de Templates"** desde admin
   - Selecciona **"Crear nuevo template"** o **"Editar template existente"**
   - Sistema presenta opciones: template específico o genérico
2. **Upload de imagen de referencia:**
   - Usuario sube imagen de muestra de hoja de respuesta
   - Sistema valida formato, resolución y calidad de imagen
   - Presenta imagen en interfaz de calibración visual
3. **Configuración de área de QR:**
   - Usuario marca región donde se espera encontrar código QR
   - Define tolerancias de posición y rotación
   - Sistema valida detección en imagen de muestra
   - Configura parámetros de decodificación específicos
4. **Definición de grilla de respuestas:**
   - Usuario define dimensiones de grilla (filas x columnas)
   - Marca puntos de referencia para calibración automática
   - Sistema calcula coordenadas de cada posición de burbuja
   - Usuario ajusta manualmente posiciones problemáticas
5. **Mapeo a preguntas:**
   - Usuario asocia cada posición de grilla con pregunta específica
   - Define orden de lectura (horizontal, vertical, por bloques)
   - Configura opciones válidas por pregunta (A,B,C,D vs 1,2,3,4)
   - Sistema valida coherencia con estructura de evaluación
6. **Calibración de detección:**
   - Usuario configura parámetros de sensibilidad:
     - Umbral de detección de burbujas marcadas
     - Tolerancia a ruido y variaciones de calidad
     - Algoritmos de corrección de perspectiva
   - Sistema ejecuta validación con imágenes de prueba
7. **Validación y testing:**
   - Usuario proporciona conjunto de imágenes de prueba
   - Sistema ejecuta procesamiento automático con template configurado
   - Usuario revisa resultados y ajusta parámetros si es necesario
   - Valida tasa de detección correcta y precisión de mapeo
8. **Publicación del template:**
   - Usuario confirma configuración final
   - Sistema asigna versión y activa template para uso
   - Notifica a usuarios autorizados sobre disponibilidad
   - Template queda disponible para selección en evaluaciones

### Flujos alternativos / Excepciones
- **A1 — Imagen de referencia de baja calidad:**
  - Sistema rechaza imagen si no cumple estándares mínimos
  - Sugiere mejoras: mejor iluminación, resolución, enfoque
  - Permite ajustar parámetros de procesamiento para compensar
- **A2 — Detección de QR fallida:**
  - Sistema no puede detectar o decodificar QR en posición marcada
  - Usuario puede ajustar región de búsqueda o parámetros
  - Permite marcar template como "sin QR" si no se usa
- **A3 — Grilla irregular o compleja:**
  - Imagen tiene layout no estándar (múltiples secciones, orientaciones)
  - Sistema permite definir múltiples grillas por template
  - Usuario puede configurar regiones personalizadas por sección
- **A4 — Conflicto con evaluación existente:**
  - Template no coincide con estructura de preguntas definida
  - Sistema sugiere ajustes automáticos si es posible
  - Permite editar evaluación o template para compatibilidad
- **A5 — Validación fallida:**
  - Tasa de detección correcta por debajo del umbral aceptable
  - Sistema sugiere ajustes específicos basados en análisis automático
  - Permite iteración hasta alcanzar precisión requerida
- **A6 — Template genérico vs específico:**
  - Usuario debe decidir si template se reutilizará en múltiples evaluaciones
  - Sistema aplica diferentes validaciones según tipo seleccionado

### Reglas de negocio
- **RN-1:** Solo usuarios con rol técnico o administrativo pueden crear templates.
- **RN-2:** Todo template debe validarse con al menos 5 imágenes de prueba antes de activarse.
- **RN-3:** Templates activos no pueden modificarse, solo crear nuevas versiones.
- **RN-4:** La precisión mínima requerida es 95% en detección de burbujas marcadas.
- **RN-5:** Cambios en template requieren re-validación completa del pipeline.
- **RN-6:** Templates obsoletos se archivan pero no se eliminan para trazabilidad.

### Datos principales
- **Template de Evaluación** (identificador, nombre, versión, tipo, imagen referencia, activo)
- **Configuración QR** (template, región detección, parámetros decodificación, tolerancias)
- **Grilla de Respuestas** (template, filas, columnas, coordenadas, mapeo preguntas)
- **Parámetros de Detección** (umbrales, algoritmos, correcciones, sensibilidad)
- **Validación de Template** (template, imágenes prueba, métricas precisión, resultado)
- **Historial de Versiones** (template, versión anterior, cambios realizados, razón)

### Consideraciones de seguridad/permiso
- **Acceso restringido:** Solo usuarios técnicos pueden modificar templates críticos.
- **Validación obligatoria:** Ningún template puede activarse sin pasar validaciones.
- **Versionado:** Cambios quedan registrados con usuario y justificación.
- **Rollback:** Capacidad de revertir a versiones anteriores si hay problemas.
- **Auditoría:** Registro completo de uso y efectividad de cada template.

### No funcionales
- **Precisión:** 
  - Detección de burbujas marcadas > 95%
  - Falsos positivos < 2%
- **Flexibilidad:** 
  - Soporte para múltiples layouts de hoja
  - Adaptación a diferentes resoluciones y calidades
- **Usabilidad:** 
  - Interfaz visual intuitiva para calibración
  - Feedback en tiempo real durante configuración
- **Mantenibilidad:** 
  - Templates versionados y documentados
  - Métricas de efectividad para optimización continua

### Criterios de aceptación (QA)
- **CA-1:** Usuario debe poder crear template desde imagen de muestra en < 15 minutos.
- **CA-2:** Sistema debe detectar automáticamente grillas regulares con 90% precisión.
- **CA-3:** Validación debe rechazar templates con precisión < 95% antes de activación.
- **CA-4:** Templates activos deben funcionar consistentemente en pipeline de producción.
- **CA-5:** Cambios en template deben preservar versiones anteriores para rollback.
- **CA-6:** Interfaz debe permitir ajuste fino de coordenadas con precisión pixel-level.
- **CA-7:** Sistema debe generar métricas de efectividad automáticamente durante uso.

---

## Anexo Técnico (para desarrollo)

> Esta sección contiene los detalles técnicos de implementación del sistema de templates según el modelo de datos del sistema de Ingesta Móvil.

### Resumen del modelo de datos

#### Entidades principales involucradas
- **`evaluation_templates`**: Configuración principal de templates con metadatos y versionado.
- **`template_qr_regions`**: Definición de áreas de detección de códigos QR con parámetros.
- **`template_bubble_grids`**: Configuración de grillas de burbujas con coordenadas y mapeos.
- **`template_detection_params`**: Parámetros algorítmicos para optimización de detección.
- **`template_validations`**: Registro de pruebas y métricas de efectividad.
- **`template_versions`**: Historial de cambios con trazabilidad completa.

#### Relaciones clave
- Los **templates** definen la estructura física que el pipeline OCR debe reconocer.
- Las **validaciones** aseguran que templates funcionen correctamente antes de activación.
- El **versionado** permite evolución controlada sin pérdida de trazabilidad.
- Los **parámetros de detección** se optimizan iterativamente basado en métricas reales.

#### Campos críticos para este caso de uso
**En `evaluation_templates`:**
- `name`, `version`, `type` (specific/generic), `reference_image_uri`
- `active`, `created_by_fk`, `created_at`, `precision_score`

**En `template_bubble_grids`:**
- `template_fk`, `rows`, `columns`, `grid_coordinates` (JSONB)
- `question_mapping` (JSONB), `reading_order` (horizontal/vertical/blocks)

**En `template_detection_params`:**
- `bubble_threshold`, `noise_tolerance`, `perspective_correction`
- `algorithm_version`, `optimization_flags`

#### Arquitectura de Templates
El sistema usa **configuración visual interactiva**, **validación automática** con **métricas estadísticas**, y **versionado incremental** para evolución controlada.

### Validaciones implementadas en base de datos

**Verificar compatibilidad template-evaluación:**
```sql
SELECT 
    et.template_id,
    et.name,
    et.version,
    COUNT(eq.evaluation_question_id) as total_questions,
    jsonb_array_length(tbg.question_mapping) as template_positions
FROM evaluation_templates et
JOIN template_bubble_grids tbg ON et.template_id = tbg.template_fk
JOIN evaluations e ON e.template_fk = et.template_id
JOIN evaluation_questions eq ON e.evaluation_id = eq.evaluation_fk
WHERE et.template_id = :template_id
GROUP BY et.template_id, et.name, et.version, tbg.question_mapping
HAVING COUNT(eq.evaluation_question_id) = jsonb_array_length(tbg.question_mapping);
```

**Consultar métricas de efectividad:**
```sql
SELECT 
    tv.template_fk,
    tv.validation_date,
    tv.test_images_count,
    tv.detection_accuracy,
    tv.false_positive_rate,
    tv.processing_time_avg,
    tv.validation_status
FROM template_validations tv
WHERE tv.template_fk = :template_id
ORDER BY tv.validation_date DESC
LIMIT 10;
```

### Ejemplo de implementación de creación de template

```sql
-- PASO 1: Crear template base
INSERT INTO evaluation_templates (
    name, version, type, reference_image_uri,
    created_by_fk, created_at, active
) VALUES (
    :template_name, '1.0', :template_type, :image_uri,
    :user_id, NOW(), false
) RETURNING template_id;

-- PASO 2: Configurar región de QR
INSERT INTO template_qr_regions (
    template_fk, region_x, region_y, region_width, region_height,
    rotation_tolerance, detection_params
) VALUES (
    :template_id, :qr_x, :qr_y, :qr_width, :qr_height,
    :rotation_tolerance, :qr_params_json
);

-- PASO 3: Definir grilla de burbujas
INSERT INTO template_bubble_grids (
    template_fk, rows, columns, grid_coordinates,
    question_mapping, reading_order
) VALUES (
    :template_id, :grid_rows, :grid_cols, :coordinates_json,
    :question_mapping_json, :reading_order
);

-- PASO 4: Configurar parámetros de detección
INSERT INTO template_detection_params (
    template_fk, bubble_threshold, noise_tolerance,
    perspective_correction, algorithm_version
) VALUES (
    :template_id, :threshold, :noise_tolerance,
    :perspective_correction, :algorithm_version
);
```

### Sistema de validación automática

**Función de validación de template:**
```sql
CREATE OR REPLACE FUNCTION validate_template(template_id BIGINT, test_images TEXT[])
RETURNS JSONB AS $$
DECLARE
    validation_results JSONB;
    detection_stats RECORD;
    total_tests INTEGER;
    successful_detections INTEGER;
    false_positives INTEGER;
BEGIN
    -- Inicializar contadores
    total_tests := array_length(test_images, 1);
    successful_detections := 0;
    false_positives := 0;
    
    -- Simular procesamiento de cada imagen de prueba
    -- (En implementación real, aquí se llamaría al motor OCR)
    FOR i IN 1..total_tests LOOP
        -- Simular resultados de detección
        -- Aquí iría la lógica real de procesamiento con el template
        IF random() > 0.05 THEN  -- Simular 95% de éxito
            successful_detections := successful_detections + 1;
        END IF;
        
        IF random() < 0.02 THEN  -- Simular 2% de falsos positivos
            false_positives := false_positives + 1;
        END IF;
    END LOOP;
    
    -- Calcular métricas
    validation_results := jsonb_build_object(
        'total_tests', total_tests,
        'successful_detections', successful_detections,
        'detection_accuracy', ROUND(successful_detections * 100.0 / total_tests, 2),
        'false_positive_rate', ROUND(false_positives * 100.0 / total_tests, 2),
        'validation_passed', (successful_detections * 100.0 / total_tests) >= 95
    );
    
    -- Registrar validación
    INSERT INTO template_validations (
        template_fk, validation_date, test_images_count,
        detection_accuracy, false_positive_rate,
        validation_status, validation_details
    ) VALUES (
        template_id, NOW(), total_tests,
        (validation_results->>'detection_accuracy')::NUMERIC,
        (validation_results->>'false_positive_rate')::NUMERIC,
        CASE WHEN (validation_results->>'validation_passed')::BOOLEAN 
             THEN 'passed' ELSE 'failed' END,
        validation_results
    );
    
    RETURN validation_results;
END;
$$ LANGUAGE plpgsql;
```

### Interfaz de calibración visual

**API para configuración interactiva:**
```javascript
// POST /api/templates/create-from-image
app.post('/api/templates/create-from-image', upload.single('referenceImage'), async (req, res) => {
    const { templateName, templateType } = req.body;
    const userId = req.user.id;
    const imagePath = req.file.path;
    
    try {
        // Validar permisos
        if (!await hasTemplatePermissions(userId)) {
            return res.status(403).json({ error: 'Template creation permission required' });
        }
        
        // Procesar imagen para análisis inicial
        const imageAnalysis = await analyzeReferenceImage(imagePath);
        
        // Crear template base
        const template = await createTemplate({
            name: templateName,
            type: templateType,
            referenceImageUri: imagePath,
            createdBy: userId
        });
        
        res.json({
            templateId: template.id,
            imageAnalysis: imageAnalysis,
            suggestedRegions: imageAnalysis.detectedRegions
        });
        
    } catch (error) {
        res.status(500).json({ error: 'Template creation failed' });
    }
});

// PUT /api/templates/:id/calibrate-grid
app.put('/api/templates/:id/calibrate-grid', async (req, res) => {
    const { id } = req.params;
    const { gridRows, gridCols, referencePoints, questionMapping } = req.body;
    
    try {
        // Calcular coordenadas de grilla basado en puntos de referencia
        const gridCoordinates = calculateGridCoordinates(
            referencePoints, gridRows, gridCols
        );
        
        // Validar mapeo de preguntas
        const mappingValid = await validateQuestionMapping(
            id, questionMapping
        );
        
        if (!mappingValid.valid) {
            return res.status(400).json({ 
                error: 'Invalid question mapping', 
                details: mappingValid.errors 
            });
        }
        
        // Actualizar configuración de grilla
        await updateTemplateGrid(id, {
            rows: gridRows,
            columns: gridCols,
            coordinates: gridCoordinates,
            questionMapping: questionMapping
        });
        
        res.json({
            success: true,
            gridCoordinates: gridCoordinates,
            validation: mappingValid
        });
        
    } catch (error) {
        res.status(500).json({ error: 'Grid calibration failed' });
    }
});
```

### Algoritmos de detección y calibración

**Cálculo automático de grilla:**
```python
def calculateGridCoordinates(reference_points, rows, cols):
    """
    Calcula coordenadas de grilla basado en puntos de referencia
    """
    # Extraer puntos de esquina
    top_left = reference_points['top_left']
    top_right = reference_points['top_right']
    bottom_left = reference_points['bottom_left']
    bottom_right = reference_points['bottom_right']
    
    # Calcular transformación de perspectiva
    src_points = np.array([top_left, top_right, bottom_right, bottom_left])
    dst_points = np.array([[0, 0], [cols-1, 0], [cols-1, rows-1], [0, rows-1]])
    
    # Matrix de transformación
    transform_matrix = cv2.getPerspectiveTransform(
        src_points.astype(np.float32), 
        dst_points.astype(np.float32)
    )
    
    # Generar coordenadas de cada celda
    grid_coordinates = []
    for row in range(rows):
        for col in range(cols):
            # Coordenada en espacio normalizado
            norm_point = np.array([[col, row]], dtype=np.float32)
            
            # Transformar a coordenadas de imagen
            img_point = cv2.perspectiveTransform(
                norm_point.reshape(-1, 1, 2), 
                np.linalg.inv(transform_matrix)
            )
            
            grid_coordinates.append({
                'row': row,
                'col': col,
                'x': float(img_point[0][0][0]),
                'y': float(img_point[0][0][1]),
                'radius': calculateOptimalRadius(img_point, transform_matrix)
            })
    
    return grid_coordinates

def calculateOptimalRadius(center_point, transform_matrix):
    """
    Calcula radio óptimo para detección de burbuja
    """
    # Estimar tamaño de celda basado en transformación
    unit_square = np.array([[0, 0], [1, 0], [1, 1], [0, 1]], dtype=np.float32)
    transformed_square = cv2.perspectiveTransform(
        unit_square.reshape(-1, 1, 2), 
        np.linalg.inv(transform_matrix)
    )
    
    # Calcular dimensiones promedio de celda
    cell_width = np.mean([
        np.linalg.norm(transformed_square[1] - transformed_square[0]),
        np.linalg.norm(transformed_square[2] - transformed_square[3])
    ])
    
    cell_height = np.mean([
        np.linalg.norm(transformed_square[3] - transformed_square[0]),
        np.linalg.norm(transformed_square[2] - transformed_square[1])
    ])
    
    # Radio como porcentaje del menor dimension
    return min(cell_width, cell_height) * 0.3
```

### Métricas de efectividad en producción

**Tracking de performance de templates:**
```sql
-- Vista para métricas de efectividad
CREATE VIEW template_effectiveness_metrics AS
SELECT 
    et.template_id,
    et.name,
    et.version,
    COUNT(sp.scanned_page_id) as pages_processed,
    COUNT(CASE WHEN pd.state = 'BubblesDetected' THEN 1 END) as successful_detections,
    COUNT(CASE WHEN pd.state = 'Failed' THEN 1 END) as failed_detections,
    AVG(pd.quality_score) as avg_quality_score,
    COUNT(CASE WHEN ir.anomalies ? 'detection_issues' THEN 1 END) as anomaly_count,
    ROUND(
        COUNT(CASE WHEN pd.state = 'BubblesDetected' THEN 1 END) * 100.0 / 
        NULLIF(COUNT(sp.scanned_page_id), 0), 2
    ) as success_rate
FROM evaluation_templates et
JOIN evaluations e ON et.template_id = e.template_fk
JOIN ingest_batches ib ON e.evaluation_id = ib.evaluation_fk
JOIN scanned_pages sp ON ib.ingest_batch_id = sp.ingest_batch_fk
JOIN page_detections pd ON sp.scanned_page_id = pd.scanned_page_fk
LEFT JOIN ingest_results ir ON sp.scanned_page_id = ir.scanned_page_fk
WHERE sp.captured_at >= NOW() - INTERVAL '30 days'
GROUP BY et.template_id, et.name, et.version;
```

### Índices recomendados
- `CREATE INDEX idx_evaluation_templates_active ON evaluation_templates (active, type);`
- `CREATE INDEX idx_template_validations_template_date ON template_validations (template_fk, validation_date);`
- `CREATE INDEX idx_template_bubble_grids_template ON template_bubble_grids (template_fk);`

### Referencias al modelo completo
Para más detalles sobre la estructura completa, restricciones, tipos de datos y triggers:
- [Modelo Entidad-Relación completo](../../../../06-data-model/mobile-ingest/mer.md)
- [Script DDL de creación](../../../../06-data-model/mobile-ingest/DDL.sql)
- [Triggers y funciones](../../../../06-data-model/mobile-ingest/TRIGGERS.sql)

---

[Subir](#cu-im-10--configuración-de-templates-de-evaluación)
