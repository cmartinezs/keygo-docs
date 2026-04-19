# CU-IM-03 — Procesar y validar páginas capturadas

- [Revisión](review.md)
- [Volver](../../README.md#3-ingesta-móvil)

## Escenario origen: S-IM-03 | Validar calidad y repetir captura

### RF relacionados: RF4, RF8

**Actor principal:** Sistema GRADE (Pipeline de procesamiento)  
**Actores secundarios:** Docente/Asistente de aula, Motor de OCR, Sistema de notificaciones

---

### Objetivo
Ejecutar el pipeline automático de procesamiento de páginas capturadas a través de las etapas Decode → Detect → Map → Post, validando calidad, detectando elementos de la hoja (QR, burbujas), mapeando respuestas y generando alertas para intervención manual cuando sea necesario.

### Precondiciones
- Existen páginas capturadas en estado **En Cola** con trabajos de procesamiento en etapa **Decodificación**.
- Las imágenes están disponibles localmente o en almacenamiento accesible.
- El sistema de procesamiento está operativo con capacidad disponible.
- Los templates de evaluación están configurados para el mapeo de coordenadas.

### Postcondiciones
- Las páginas procesadas exitosamente tienen estado **Decodificada** y resultados de ingesta generados.
- Se crean registros de detección de páginas, códigos QR y burbujas según corresponda.
- Los trabajos de procesamiento avanzan por las etapas o fallan con error registrado.
- Las páginas problemáticas quedan marcadas para intervención manual.
- Se generan notificaciones automáticas para el usuario sobre el progreso.

### Flujo principal (éxito)
1. **Etapa DECODIFICACIÓN:** El sistema toma páginas escaneadas con estado **En Cola**
2. **Análisis de calidad básica:**
   - Carga la imagen y valida integridad por hash
   - Detecta orientación y calcula métricas de calidad
   - Crea registro de detección de página con rotación y puntaje de calidad
3. **Detección de códigos QR:**
   - Busca códigos QR en la imagen
   - Si encuentra QR válido, crea registro con:
     - Identificador de estudiante, versión de hoja, evaluación
     - Valida coherencia con la evaluación del lote de ingesta
     - Marca como verificado si es consistente
4. **Etapa DETECCIÓN:** Actualiza trabajo de procesamiento a etapa **Detección**
5. **Detección de burbujas:**
   - Ejecuta algoritmos de computer vision para detectar áreas de respuesta
   - Crea registros de detección de burbujas por cada burbuja encontrada:
     - Posición en grilla (fila, columna)
     - Coordenadas del área detectada
     - Nivel de relleno detectado (0-1)
     - Determinación si está marcada
6. **Etapa MAPEO:** Actualiza trabajo de procesamiento a etapa **Mapeo**
7. **Mapeo a preguntas:**
   - Crea registros de mapeo asociando cada burbuja detectada con:
     - Pregunta específica de la evaluación
     - Opción de respuesta correspondiente
     - Nivel de confianza del mapeo (0-1)
     - Algoritmo utilizado para el mapeo
8. **Etapa POSTING:** Actualiza trabajo de procesamiento a etapa **Posting**
9. **Generación de resultados:**
   - Crea registro de resultado de ingesta con:
     - Estudiante identificado (si hay QR válido)
     - Cantidad total de burbujas marcadas
     - Irregularidades detectadas
     - Estado **Listo** para posting a calificaciones
10. **Finalización exitosa:**
    - Actualiza estado de página escaneada a **Decodificada**
    - Marca trabajo de procesamiento como **Exitoso**
    - Notifica al usuario sobre progreso exitoso

### Flujos alternativos / Excepciones
- **A1 — Imagen corrupta o ilegible:**
  - Estado de detección de página marcado como **Fallido**
  - Trabajo de procesamiento marcado como **Fallido** con error detallado
  - Página escaneada marcada como **Fallida** con razón específica
  - Notificación al usuario para recapturar
- **A2 — QR no encontrado o inválido:**
  - QR de página marcado como no verificado o no se crea registro
  - Continúa procesamiento pero marca anomalías en resultados de ingesta
  - Queda para resolución manual de identidad estudiantil
- **A3 — Calidad insuficiente (borrosa, mal iluminada):**
  - Puntaje de calidad de detección por debajo del umbral mínimo
  - Estado marcado como **Fallido** con razón **Calidad Pobre**
  - Solicita recaptura con recomendaciones específicas
- **A4 — Detección de burbujas fallida:**
  - Estado de detección de página marcado como **Fallido**
  - Detecciones de burbujas vacías o insuficientes
  - Marca para procesamiento manual o template alternativo
- **A5 — Mapeo inconsistente:**
  - Mapeos de reconocimiento con confianza por debajo del umbral aceptable
  - Genera anomalías en resultados de ingesta
  - Requiere validación manual antes de posting
- **A6 — Múltiples respuestas por pregunta:**
  - Detecta múltiples burbujas marcadas para una pregunta
  - Registra en anomalías como "marcas múltiples"
  - Estado **Listo** pero requiere revisión manual
- **A7 — Timeout de procesamiento:**
  - Trabajo de procesamiento marcado como **Fallido** por tiempo excedido
  - Reintenta automáticamente hasta límite configurable
  - Si persiste, escala a revisión técnica

### Reglas de negocio
- **RN-1:** El procesamiento debe ejecutarse en el orden: Decode → Detect → Map → Post.
- **RN-2:** Cada etapa debe completarse exitosamente antes de pasar a la siguiente.
- **RN-3:** El QR debe coincidir con la evaluación del lote de ingesta para ser marcado como verificado.
- **RN-4:** Una página con calidad inferior al umbral mínimo (score < 60) debe ser rechazada.
- **RN-5:** Solo burbujas con fill_score > 0.5 se consideran marcadas.
- **RN-6:** El mapeo debe tener confianza >= 0.8 para ser aceptado automáticamente.
- **RN-7:** Si hay múltiples burbujas marcadas por pregunta, se registra como anomalía pero no bloquea el procesamiento.

### Datos principales
- **Detección de Página** (identificador, página escaneada, rotación, error de warping, puntaje calidad, estado, fecha procesamiento)
- **QR de Página** (identificador, página escaneada, evaluación, versión hoja, identificador estudiante, payload, verificado)
- **Detección de Burbuja** (identificador, detección página, fila, columna, coordenadas, puntaje relleno, marcada)
- **Mapeo de Reconocimiento** (identificador, página, burbuja, pregunta evaluación, opción evaluación, confianza, regla mapeo)
- **Resultado de Ingesta** (identificador, página, evaluación, estudiante resuelto, total marcadas, anomalías, estado)
- **Trabajo de Procesamiento** (identificador, página, etapa, inicio, fin, estado, error)
- **Log de Procesamiento** (identificador, trabajo, timestamp, nivel, mensaje, datos adicionales)

### Consideraciones de seguridad/permiso
- **Integridad:** Validación de hash de imagen antes de procesar.
- **Trazabilidad:** Registro completo de cada etapa del pipeline con logs detallados.
- **Aislamiento:** Procesamiento en contenedores aislados para prevenir interferencias.
- **Recuperación:** Capacidad de reiniciar procesamiento desde cualquier etapa fallida.
- **Auditoría:** Logs inmutables de todas las decisiones del algoritmo.

### No funcionales
- **Rendimiento:** 
  - Procesamiento completo < 30s p95 por página
  - Etapa de decodificación < 10s p95
  - Detección de burbujas < 15s p95
- **Escalabilidad:** 
  - Procesamiento paralelo de múltiples páginas
  - Auto-scaling basado en cola de trabajo
- **Disponibilidad:** 
  - Reintentos automáticos con backoff exponencial
  - Fallback a procesamiento manual si falla automático
- **Calidad:** 
  - Tasa de éxito > 95% para páginas con calidad adecuada
  - Falsos positivos < 2% en detección de burbujas marcadas

### Criterios de aceptación (QA)
- **CA-1:** Una página **Queued** con calidad adecuada debe procesarse completamente hasta **Ready** en < 30s.
- **CA-2:** Si la imagen tiene calidad insuficiente, debe fallar en etapa **Decode** con razón específica.
- **CA-3:** Si se detecta QR válido, debe crear `page_qr` con evaluación correcta y marcarlo como verificado.
- **CA-4:** Las burbujas detectadas deben crear registros en `bubble_detections` con coordenadas y scores precisos.
- **CA-5:** El mapeo debe asociar correctamente burbujas con `evaluation_options` del snapshot.
- **CA-6:** Las anomalías (múltiples marcas, QR inválido) deben registrarse en `ingest_results.anomalies`.
- **CA-7:** Cada etapa del procesamiento debe generar logs detallados en `processing_logs`.

---

## Anexo Técnico (para desarrollo)

> Esta sección contiene los detalles técnicos de implementación del pipeline de procesamiento según el modelo de datos del sistema de Ingesta Móvil.

### Resumen del modelo de datos

#### Entidades principales involucradas
- **`scanned_pages`**: Páginas capturadas que ingresan al pipeline con estado "Queued".
- **`page_detections`**: Análisis geométrico y de calidad de cada página procesada.
- **`page_qrs`**: Códigos QR decodificados con información de evaluación y estudiante.
- **`bubble_detections`**: Burbujas individuales detectadas en cada página con sus coordenadas y scores.
- **`recognition_mappings`**: Mapeo de burbujas detectadas a preguntas y opciones de evaluación.
- **`ingest_results`**: Consolidación final por página/estudiante lista para posting.
- **`processing_jobs`**: Control del pipeline con etapas y estados de procesamiento.
- **`processing_logs`**: Logs detallados de cada paso del procesamiento.

#### Relaciones clave
- El **pipeline de procesamiento** sigue la secuencia: `scanned_pages → page_detections → bubble_detections → recognition_mappings → ingest_results`.
- Cada **página escaneada** tiene exactamente una **detección de página** y opcionalmente un **QR de página**.
- Una **detección de página** puede tener múltiples **detecciones de burbuja**.
- Cada **burbuja detectada** puede mapearse a una **opción de evaluación** vía `recognition_mappings`.
- El **resultado final** consolida todas las burbujas marcadas por página/estudiante.

#### Campos críticos para este caso de uso
**En `page_detections`:**
- `scanned_page_fk` (página origen), `quality_score` (0-100, umbral mínimo 60)
- `rotation_deg` (corrección geométrica), `state` (Ready/BubblesDetected/Failed)
- `processed_at` (timestamp de finalización), `failure_reason` (si falla)

**En `bubble_detections`:**
- `page_detection_fk` (página padre), `row_no`, `col_no` (posición en grilla)
- `fill_score` (0-1, umbral 0.5 para marcada), `is_marked` (boolean calculado)
- `bbox` (JSONB con coordenadas [x,y,w,h] normalizadas)

**En `recognition_mappings`:**
- `bubble_detection_fk` (burbuja origen), `evaluation_question_fk`, `evaluation_option_fk`
- `confidence` (0-1, umbral 0.8 para aceptación automática)
- `mapping_rule` (algoritmo usado: 'grid', 'ocr-fallback', etc.)

#### Auditoría en Pipeline de Procesamiento
El sistema usa **logs inmutables** con timestamps específicos (`decoded_at`, `processed_at`, `started_at`, `finished_at`) que permiten reconstruir el estado exacto en cualquier momento del procesamiento.

### Validaciones implementadas en base de datos

**Verificar páginas pendientes de procesamiento:**
```sql
SELECT sp.scanned_page_id, sp.image_uri, sp.captured_at
FROM scanned_pages sp
JOIN processing_jobs pj ON sp.scanned_page_id = pj.scanned_page_fk
WHERE sp.status = 'Queued'
AND pj.stage = 'Decode'
AND pj.status = 'Running'
ORDER BY sp.captured_at;
```

**Verificar coherencia QR con lote:**
```sql
SELECT pqr.page_qr_id, pqr.evaluation_fk, ib.evaluation_fk as batch_evaluation
FROM page_qrs pqr
JOIN scanned_pages sp ON pqr.scanned_page_fk = sp.scanned_page_id
JOIN ingest_batches ib ON sp.ingest_batch_fk = ib.ingest_batch_id
WHERE pqr.evaluation_fk != ib.evaluation_fk;
```

### Ejemplo de implementación del pipeline completo

```sql
-- ETAPA 1: DECODE - Análisis de calidad y QR
-- Crear detección de página
INSERT INTO page_detections (
    scanned_page_fk, rotation_deg, quality_score, 
    state, processed_at
) VALUES (
    :page_id, :calculated_rotation, :quality_score,
    CASE WHEN :quality_score >= 60 THEN 'Ready' ELSE 'Failed' END,
    NOW()
) RETURNING page_detection_id;

-- Si hay QR válido, crear registro
INSERT INTO page_qrs (
    scanned_page_fk, evaluation_fk, sheet_version,
    student_identifier, payload, verified, decoded_at
) VALUES (
    :page_id, :qr_evaluation_id, :sheet_version,
    :student_code, :qr_payload, 
    :qr_evaluation_id = :batch_evaluation_id, -- verificado si coincide
    NOW()
);

-- ETAPA 2: DETECT - Detección de burbujas
INSERT INTO bubble_detections (
    page_detection_fk, row_no, col_no, bbox, 
    fill_score, is_marked
) VALUES (
    :detection_id, :row, :col, :coordinates_json,
    :calculated_fill, :calculated_fill > 0.5
);

-- ETAPA 3: MAP - Mapeo a evaluación
INSERT INTO recognition_mappings (
    scanned_page_fk, bubble_detection_fk, 
    evaluation_question_fk, evaluation_option_fk,
    confidence, mapping_rule
) VALUES (
    :page_id, :bubble_id,
    :mapped_question_id, :mapped_option_id,
    :confidence_score, 'grid'
);

-- ETAPA 4: POST - Resultado consolidado
INSERT INTO ingest_results (
    scanned_page_fk, evaluation_fk, resolved_student_fk,
    total_marked, anomalies, state
) VALUES (
    :page_id, :evaluation_id, :student_id,
    :total_bubbles_marked, :anomalies_json, 'Ready'
);
```

### Manejo de errores y reintentos

**Configuración de reintentos por etapa:**
```sql
-- Reintento automático con backoff exponencial
UPDATE processing_jobs 
SET 
    started_at = NOW(),
    status = 'Running',
    error = NULL
WHERE scanned_page_fk = :page_id
AND stage = :failed_stage
AND status = 'Failed'
AND (finished_at IS NULL OR finished_at < NOW() - INTERVAL '5 minutes');
```

**Escalación a procesamiento manual:**
```sql
-- Marcar para intervención manual después de 3 intentos fallidos
UPDATE scanned_pages 
SET 
    status = 'Failed',
    failure_reason = 'Max retries exceeded - requires manual review'
WHERE scanned_page_id IN (
    SELECT pj.scanned_page_fk 
    FROM processing_jobs pj
    WHERE pj.status = 'Failed'
    GROUP BY pj.scanned_page_fk
    HAVING COUNT(*) >= 3
);
```

### Algoritmos de detección y mapeo

**Detección de calidad de imagen:**
```python
def calculate_quality_score(image):
    # Métricas combinadas para score 0-100
    sharpness = cv2.Laplacian(image, cv2.CV_64F).var()  # > 100
    brightness = np.mean(image) / 255.0                 # 0.3-0.8 
    contrast = image.std() / 255.0                      # > 0.4
    
    # Score compuesto (0-100)
    quality_score = min(100, (
        (min(sharpness/100, 1.0) * 40) +      # 40 pts max sharpness
        (brightness_penalty(brightness) * 30) + # 30 pts brightness
        (min(contrast/0.4, 1.0) * 30)         # 30 pts contrast
    ))
    
    return quality_score
```

**Mapeo de burbujas a coordenadas:**
```python
def map_bubble_to_evaluation_option(bubble_row, bubble_col, evaluation_template):
    # Mapeo basado en template de evaluación
    grid_mapping = evaluation_template['bubble_grid']
    
    if bubble_row <= len(grid_mapping) and bubble_col <= len(grid_mapping[0]):
        question_seq = grid_mapping[bubble_row-1]['question']
        option_seq = grid_mapping[bubble_row-1]['options'][bubble_col-1]
        
        # Buscar en snapshot de evaluación
        question_id = get_evaluation_question_id(evaluation_id, question_seq)
        option_id = get_evaluation_option_id(question_id, option_seq)
        
        confidence = calculate_mapping_confidence(bubble_row, bubble_col, template)
        
        return {
            'evaluation_question_fk': question_id,
            'evaluation_option_fk': option_id,
            'confidence': confidence,
            'mapping_rule': 'grid'
        }
```

### Índices recomendados
- `CREATE INDEX idx_page_detections_page_state ON page_detections (scanned_page_fk, state);`
- `CREATE INDEX idx_bubble_detections_page_marked ON bubble_detections (page_detection_fk, is_marked);`
- `CREATE INDEX idx_recognition_mappings_page_confidence ON recognition_mappings (scanned_page_fk, confidence);`
- `CREATE INDEX idx_processing_jobs_stage_status ON processing_jobs (stage, status, started_at);`

### Referencias al modelo completo
Para más detalles sobre la estructura completa, restricciones, tipos de datos y triggers:
- [Modelo Entidad-Relación completo](../../../../06-data-model/mobile-ingest/mer.md)
- [Script DDL de creación](../../../../06-data-model/mobile-ingest/DDL.sql)
- [Triggers y funciones](../../../../06-data-model/mobile-ingest/TRIGGERS.sql)

---

[Subir](#cu-im-03--procesar-y-validar-páginas-capturadas)
