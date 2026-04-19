# CU-IM-11 — Cierre y consolidación de lotes

- [Revisión](review.md)
- [Volver](../../README.md#3-ingesta-móvil)

## Escenario origen: S-IM-11 | Finalización controlada de sesiones de captura

### RF relacionados: RF4, RF8

**Actor principal:** Docente / Asistente de aula  
**Actores secundarios:** Sistema GRADE (Pipeline de procesamiento), Coordinador académico

---

### Objetivo
Permitir el cierre controlado y consolidación de lotes de ingesta, validando completitud del procesamiento, generando reportes finales y bloqueando modificaciones posteriores para garantizar integridad del proceso de calificación.

### Precondiciones
- Existe un lote de ingesta en estado **Abierto** o **Procesando**.
- El usuario tiene permisos sobre la evaluación y curso correspondiente.
- Todas las páginas del lote han sido procesadas o marcadas apropiadamente.
- Las anomalías críticas han sido resueltas o documentadas.

### Postcondiciones
- Lote cambia a estado **Cerrado** con timestamp de cierre.
- Se genera reporte final consolidado del lote con métricas completas.
- Todas las páginas válidas han sido posteadas al sistema de calificaciones.
- El lote queda bloqueado contra modificaciones no autorizadas.
- Se dispara notificación de finalización a usuarios relevantes.

### Flujo principal (éxito)
1. **Solicitud de cierre:**
   - Usuario navega al dashboard de monitoreo de lotes
   - Selecciona lote en estado **Abierto** o **Procesando**
   - Inicia proceso de cierre mediante **"Finalizar lote"**
2. **Validaciones pre-cierre:**
   - Sistema verifica que no hay trabajos de procesamiento pendientes
   - Confirma que todas las páginas están en estado final (Decoded/Failed)
   - Valida que anomalías críticas han sido resueltas
   - Verifica integridad de datos y consistencia referencial
3. **Revisión de completitud:**
   - Sistema presenta resumen ejecutivo:
     - Total de páginas capturadas vs procesadas exitosamente
     - Páginas con anomalías resueltas vs pendientes
     - Estudiantes identificados vs no identificados
     - Respuestas posteadas al sistema de calificaciones
4. **Manejo de anomalías pendientes:**
   - Si hay anomalías no críticas pendientes, sistema ofrece opciones:
     - **Cerrar con anomalías:** Documentar y proceder
     - **Resolver ahora:** Ir a herramientas de resolución manual
     - **Posponer cierre:** Mantener lote abierto para resolución posterior
5. **Confirmación de cierre:**
   - Usuario revisa resumen final y confirma cierre
   - Sistema solicita notas opcionales de cierre
   - Usuario confirma entendimiento de que el cierre es irreversible
6. **Proceso de consolidación:**
   - Sistema actualiza estado del lote a **Cerrado**
   - Registra timestamp de cierre y usuario que ejecutó la acción
   - Bloquea modificaciones futuras en páginas del lote
   - Genera y almacena reporte final consolidado
7. **Finalización y notificación:**
   - Sistema confirma cierre exitoso con ID de reporte
   - Envía notificaciones a usuarios relevantes (docente, coordinador)
   - Actualiza métricas de evaluación y dashboard general
   - Dispara procesos post-cierre (archivado, backup, etc.)

### Flujos alternativos / Excepciones
- **A1 — Procesamiento incompleto:**
  - Sistema detecta páginas aún en procesamiento
  - Ofrece opciones: esperar finalización, forzar cierre, cancelar
  - Si se forza, marca páginas pendientes como "proceso interrumpido"
- **A2 — Anomalías críticas no resueltas:**
  - Sistema bloquea cierre hasta resolución de anomalías críticas
  - Presenta lista de anomalías que requieren intervención
  - Redirige a herramientas de resolución con contexto específico
- **A3 — Fallo en posting de calificaciones:**
  - Sistema detecta problemas en transferencia a sistema de calificaciones
  - Mantiene lote en estado "Procesando" con alerta específica
  - Permite reintentar posting o proceder con cierre manual
- **A4 — Pérdida de conectividad durante cierre:**
  - Sistema mantiene estado intermedio seguro
  - Al reconectar, permite completar proceso desde donde quedó
  - Preserva integridad de datos durante todo el proceso
- **A5 — Solicitud de reapertura:**
  - Usuario autorizado puede solicitar reapertura excepcional
  - Requiere justificación y aprobación de supervisor
  - Sistema registra reapertura con auditoría completa
- **A6 — Volumen alto de anomalías:**
  - Si más del 20% de páginas tienen anomalías, sugiere revisión
  - Recomienda análisis de causa raíz antes del cierre
  - Permite proceder con documentación de problema sistémico

### Reglas de negocio
- **RN-1:** Solo el creador del lote o un supervisor pueden cerrarlo.
- **RN-2:** Lotes cerrados no pueden modificarse sin autorización especial.
- **RN-3:** El cierre debe completarse dentro de 7 días desde la última captura.
- **RN-4:** Anomalías críticas deben resolverse antes del cierre.
- **RN-5:** Todo cierre debe generar reporte automático archivable.
- **RN-6:** Páginas no identificadas no bloquean el cierre si están documentadas.

### Datos principales
- **Lote de Ingesta** (identificador, estado, fecha cierre, usuario que cerró, notas cierre)
- **Reporte de Cierre** (lote, métricas finales, anomalías resueltas, tiempo total procesamiento)
- **Bloqueo de Modificación** (lote, fecha bloqueo, excepciones autorizadas)
- **Notificación de Cierre** (lote, destinatarios, fecha envío, contenido reporte)
- **Auditoría de Cierre** (lote, usuario, timestamp, acciones realizadas, validaciones)

### Consideraciones de seguridad/permiso
- **Autorización:** Solo usuarios con permisos sobre el curso pueden cerrar lotes.
- **Irreversibilidad:** Cierre normal no puede revertirse sin proceso de excepción.
- **Integridad:** Validación completa de datos antes de permitir cierre.
- **Trazabilidad:** Registro detallado de quién, cuándo y por qué se cerró.
- **Archivado:** Reporte final almacenado permanentemente para auditoría.

### No funcionales
- **Rendimiento:** 
  - Proceso de cierre completo < 30s p95
  - Generación de reporte < 10s p95
- **Confiabilidad:** 
  - Proceso de cierre sin pérdida de datos 99.99%
  - Recuperación automática de fallos transitorios
- **Usabilidad:** 
  - Proceso guiado con validaciones claras
  - Feedback en tiempo real durante consolidación
- **Disponibilidad:** 
  - Cierre funciona con conectividad intermitente
  - Estado intermedio preservado durante interrupciones

### Criterios de aceptación (QA)
- **CA-1:** Usuario debe poder cerrar lote sin anomalías críticas en < 30 segundos.
- **CA-2:** Sistema debe bloquear cierre si hay anomalías críticas no resueltas.
- **CA-3:** Reporte final debe incluir todas las métricas relevantes del procesamiento.
- **CA-4:** Lote cerrado debe quedar bloqueado contra modificaciones no autorizadas.
- **CA-5:** Notificaciones de cierre deben entregarse a todos los usuarios relevantes.
- **CA-6:** Proceso debe ser recuperable si se interrumpe por problemas técnicos.
- **CA-7:** Todas las páginas válidas deben estar posteadas antes del cierre.

---

## Anexo Técnico (para desarrollo)

> Esta sección contiene los detalles técnicos de implementación del cierre y consolidación de lotes según el modelo de datos del sistema de Ingesta Móvil.

### Resumen del modelo de datos

#### Entidades principales involucradas
- **`ingest_batches`**: Lotes que cambian de estado "Open/Processing" a "Closed" con metadata de cierre.
- **`batch_closure_reports`**: Reportes consolidados generados durante el cierre.
- **`scanned_pages`**: Páginas que deben estar en estado final antes del cierre.
- **`processing_jobs`**: Trabajos que deben completarse antes de permitir cierre.
- **`ingest_results`**: Resultados que deben estar posteados o documentados apropiadamente.
- **`batch_modifications_log`**: Auditoría de cambios post-cierre si se requieren excepciones.

#### Relaciones clave
- El **cierre de lote** valida que todas las **páginas escaneadas** estén en estado final.
- Los **trabajos de procesamiento** activos bloquean el cierre hasta completarse.
- Los **resultados de ingesta** deben estar posteados o marcados como excepciones.
- El **reporte de cierre** consolida métricas de todo el pipeline del lote.

#### Campos críticos para este caso de uso
**En `ingest_batches`:**
- `state` ('Open'/'Processing' → 'Closed'), `closed_at`, `closed_by_fk`
- `closure_notes`, `final_page_count`, `successful_posts_count`

**En `batch_closure_reports`:**
- `ingest_batch_fk`, `total_pages`, `successful_pages`, `failed_pages`
- `posted_results`, `unidentified_pages`, `generated_at`, `generated_by_fk`
- `report_data` (JSONB con métricas detalladas)

#### Arquitectura de Cierre
El sistema usa **validaciones en cascada**, **transacciones atómicas** para integridad, y **generación asíncrona** de reportes para performance.

### Validaciones implementadas en base de datos

**Verificar elegibilidad para cierre:**
```sql
-- Validar que no hay trabajos de procesamiento activos
SELECT COUNT(*) as active_jobs
FROM processing_jobs pj
JOIN scanned_pages sp ON pj.scanned_page_fk = sp.scanned_page_id
WHERE sp.ingest_batch_fk = :batch_id
AND pj.status IN ('Running', 'Queued');

-- Verificar estado de páginas
SELECT 
    COUNT(*) as total_pages,
    COUNT(CASE WHEN sp.status = 'Decoded' THEN 1 END) as successful_pages,
    COUNT(CASE WHEN sp.status = 'Failed' THEN 1 END) as failed_pages,
    COUNT(CASE WHEN sp.status = 'Queued' THEN 1 END) as pending_pages
FROM scanned_pages sp
WHERE sp.ingest_batch_fk = :batch_id;

-- Verificar anomalías críticas pendientes
SELECT COUNT(*) as critical_anomalies
FROM anomaly_registry ar
JOIN ingest_results ir ON ar.source_table = 'ingest_results' 
    AND ar.source_record_id = ir.ingest_result_id
JOIN scanned_pages sp ON ir.scanned_page_fk = sp.scanned_page_id
WHERE sp.ingest_batch_fk = :batch_id
AND ar.priority = 4  -- Crítica
AND ar.status != 'resolved';
```

**Calcular métricas de cierre:**
```sql
SELECT 
    ib.ingest_batch_id,
    COUNT(sp.scanned_page_id) as total_pages,
    COUNT(CASE WHEN sp.status = 'Decoded' THEN 1 END) as successful_pages,
    COUNT(CASE WHEN sp.status = 'Failed' THEN 1 END) as failed_pages,
    COUNT(CASE WHEN ir.state = 'Posted' THEN 1 END) as posted_results,
    COUNT(CASE WHEN ir.resolved_student_fk IS NULL THEN 1 END) as unidentified_pages,
    AVG(EXTRACT(EPOCH FROM (sp.captured_at - ib.started_at)) / 3600) as avg_processing_hours,
    COUNT(DISTINCT CASE WHEN ir.anomalies IS NOT NULL THEN ir.ingest_result_id END) as pages_with_anomalies
FROM ingest_batches ib
LEFT JOIN scanned_pages sp ON ib.ingest_batch_id = sp.ingest_batch_fk
LEFT JOIN ingest_results ir ON sp.scanned_page_id = ir.scanned_page_fk
WHERE ib.ingest_batch_id = :batch_id
GROUP BY ib.ingest_batch_id;
```

### Ejemplo de implementación del proceso de cierre

```sql
-- FUNCIÓN PRINCIPAL DE CIERRE DE LOTE
CREATE OR REPLACE FUNCTION close_ingest_batch(
    batch_id BIGINT, 
    user_id BIGINT, 
    closure_notes TEXT DEFAULT NULL
) RETURNS JSONB AS $$
DECLARE
    validation_result JSONB;
    closure_metrics RECORD;
    report_id BIGINT;
    closure_result JSONB;
BEGIN
    -- PASO 1: Validaciones pre-cierre
    SELECT jsonb_build_object(
        'active_jobs', (
            SELECT COUNT(*) FROM processing_jobs pj
            JOIN scanned_pages sp ON pj.scanned_page_fk = sp.scanned_page_id
            WHERE sp.ingest_batch_fk = batch_id
            AND pj.status IN ('Running', 'Queued')
        ),
        'critical_anomalies', (
            SELECT COUNT(*) FROM anomaly_registry ar
            JOIN ingest_results ir ON ar.source_table = 'ingest_results' 
                AND ar.source_record_id = ir.ingest_result_id
            JOIN scanned_pages sp ON ir.scanned_page_fk = sp.scanned_page_id
            WHERE sp.ingest_batch_fk = batch_id
            AND ar.priority = 4 AND ar.status != 'resolved'
        )
    ) INTO validation_result;
    
    -- Verificar que no hay bloqueos
    IF (validation_result->>'active_jobs')::INTEGER > 0 THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'Cannot close batch with active processing jobs',
            'active_jobs', validation_result->>'active_jobs'
        );
    END IF;
    
    IF (validation_result->>'critical_anomalies')::INTEGER > 0 THEN
        RETURN jsonb_build_object(
            'success', false,
            'error', 'Cannot close batch with unresolved critical anomalies',
            'critical_anomalies', validation_result->>'critical_anomalies'
        );
    END IF;
    
    -- PASO 2: Calcular métricas finales
    SELECT * INTO closure_metrics FROM (
        SELECT 
            COUNT(sp.scanned_page_id) as total_pages,
            COUNT(CASE WHEN sp.status = 'Decoded' THEN 1 END) as successful_pages,
            COUNT(CASE WHEN sp.status = 'Failed' THEN 1 END) as failed_pages,
            COUNT(CASE WHEN ir.state = 'Posted' THEN 1 END) as posted_results,
            COUNT(CASE WHEN ir.resolved_student_fk IS NULL THEN 1 END) as unidentified_pages
        FROM scanned_pages sp
        LEFT JOIN ingest_results ir ON sp.scanned_page_id = ir.scanned_page_fk
        WHERE sp.ingest_batch_fk = batch_id
    ) metrics;
    
    -- PASO 3: Cerrar lote (transacción atómica)
    UPDATE ingest_batches 
    SET 
        state = 'Closed',
        closed_at = NOW(),
        closed_by_fk = user_id,
        closure_notes = closure_notes,
        final_page_count = closure_metrics.total_pages,
        successful_posts_count = closure_metrics.posted_results
    WHERE ingest_batch_id = batch_id;
    
    -- PASO 4: Generar reporte de cierre
    INSERT INTO batch_closure_reports (
        ingest_batch_fk, total_pages, successful_pages, failed_pages,
        posted_results, unidentified_pages, generated_at, generated_by_fk,
        report_data
    ) VALUES (
        batch_id, closure_metrics.total_pages, closure_metrics.successful_pages,
        closure_metrics.failed_pages, closure_metrics.posted_results,
        closure_metrics.unidentified_pages, NOW(), user_id,
        jsonb_build_object(
            'closure_summary', closure_metrics,
            'validation_checks', validation_result,
            'closure_timestamp', NOW()
        )
    ) RETURNING closure_report_id INTO report_id;
    
    -- Resultado exitoso
    closure_result := jsonb_build_object(
        'success', true,
        'batch_id', batch_id,
        'closure_report_id', report_id,
        'metrics', row_to_json(closure_metrics),
        'closed_at', NOW()
    );
    
    RETURN closure_result;
END;
$$ LANGUAGE plpgsql;
```

### Sistema de reportes de cierre

**Generación de reporte detallado:**
```sql
CREATE OR REPLACE FUNCTION generate_closure_report_detailed(batch_id BIGINT)
RETURNS JSONB AS $$
DECLARE
    batch_info RECORD;
    page_summary RECORD;
    anomaly_summary RECORD;
    timing_analysis RECORD;
    report_data JSONB;
BEGIN
    -- Información básica del lote
    SELECT 
        ib.ingest_batch_id, ib.started_at, ib.closed_at,
        e.title as evaluation_name, c.name as course_name,
        u.full_name as closed_by_name
    INTO batch_info
    FROM ingest_batches ib
    JOIN evaluations e ON ib.evaluation_fk = e.evaluation_id
    JOIN courses c ON e.course_fk = c.course_id
    JOIN users u ON ib.closed_by_fk = u.user_id
    WHERE ib.ingest_batch_id = batch_id;
    
    -- Resumen de páginas procesadas
    SELECT 
        COUNT(*) as total_pages,
        COUNT(CASE WHEN sp.status = 'Decoded' THEN 1 END) as successful,
        COUNT(CASE WHEN sp.status = 'Failed' THEN 1 END) as failed,
        AVG(pd.quality_score) as avg_quality,
        MIN(sp.captured_at) as first_capture,
        MAX(sp.captured_at) as last_capture
    INTO page_summary
    FROM scanned_pages sp
    LEFT JOIN page_detections pd ON sp.scanned_page_id = pd.scanned_page_fk
    WHERE sp.ingest_batch_fk = batch_id;
    
    -- Resumen de anomalías
    SELECT 
        COUNT(*) as total_anomalies,
        COUNT(CASE WHEN ar.status = 'resolved' THEN 1 END) as resolved,
        COUNT(CASE WHEN ar.priority = 4 THEN 1 END) as critical,
        COUNT(CASE WHEN ar.priority = 3 THEN 1 END) as high,
        COUNT(CASE WHEN ar.priority <= 2 THEN 1 END) as low_medium
    INTO anomaly_summary
    FROM anomaly_registry ar
    JOIN ingest_results ir ON ar.source_table = 'ingest_results' 
        AND ar.source_record_id = ir.ingest_result_id
    JOIN scanned_pages sp ON ir.scanned_page_fk = sp.scanned_page_id
    WHERE sp.ingest_batch_fk = batch_id;
    
    -- Análisis de tiempos
    SELECT 
        EXTRACT(EPOCH FROM (batch_info.closed_at - batch_info.started_at)) / 3600 as total_hours,
        AVG(EXTRACT(EPOCH FROM (pj.finished_at - pj.started_at))) as avg_processing_seconds,
        MAX(EXTRACT(EPOCH FROM (pj.finished_at - pj.started_at))) as max_processing_seconds
    INTO timing_analysis
    FROM processing_jobs pj
    JOIN scanned_pages sp ON pj.scanned_page_fk = sp.scanned_page_id
    WHERE sp.ingest_batch_fk = batch_id
    AND pj.status = 'Succeeded';
    
    -- Consolidar reporte
    report_data := jsonb_build_object(
        'batch_info', row_to_json(batch_info),
        'page_summary', row_to_json(page_summary),
        'anomaly_summary', row_to_json(anomaly_summary),
        'timing_analysis', row_to_json(timing_analysis),
        'success_rate', ROUND(
            page_summary.successful * 100.0 / NULLIF(page_summary.total_pages, 0), 2
        ),
        'generated_at', NOW()
    );
    
    RETURN report_data;
END;
$$ LANGUAGE plpgsql;
```

### API de cierre para aplicaciones

**Endpoint principal de cierre:**
```javascript
// POST /api/batches/:id/close
app.post('/api/batches/:id/close', async (req, res) => {
    const { id } = req.params;
    const { closureNotes, forceClose = false } = req.body;
    const userId = req.user.id;
    
    try {
        // Validar permisos sobre el lote
        const batch = await getBatchWithPermissionCheck(id, userId);
        if (!batch) {
            return res.status(404).json({ error: 'Batch not found or access denied' });
        }
        
        if (batch.state === 'Closed') {
            return res.status(400).json({ error: 'Batch is already closed' });
        }
        
        // Ejecutar validaciones pre-cierre
        const validations = await performPreClosureValidations(id);
        
        if (!validations.canClose && !forceClose) {
            return res.status(409).json({
                error: 'Batch cannot be closed',
                validations: validations,
                requiresForce: true
            });
        }
        
        // Ejecutar cierre
        const closureResult = await closeBatch({
            batchId: id,
            userId: userId,
            notes: closureNotes,
            forced: forceClose
        });
        
        // Generar y enviar reporte
        const detailedReport = await generateDetailedReport(id);
        await sendClosureNotifications(id, detailedReport);
        
        res.json({
            success: true,
            batchId: id,
            closedAt: closureResult.closedAt,
            reportId: closureResult.reportId,
            metrics: closureResult.metrics
        });
        
    } catch (error) {
        res.status(500).json({ error: 'Batch closure failed' });
    }
});

// GET /api/batches/:id/closure-readiness
app.get('/api/batches/:id/closure-readiness', async (req, res) => {
    const { id } = req.params;
    const userId = req.user.id;
    
    try {
        const readiness = await assessClosureReadiness(id, userId);
        
        res.json({
            batchId: id,
            canClose: readiness.canClose,
            blockers: readiness.blockers,
            warnings: readiness.warnings,
            metrics: readiness.currentMetrics,
            recommendations: readiness.recommendations
        });
        
    } catch (error) {
        res.status(500).json({ error: 'Readiness assessment failed' });
    }
});
```

### Sistema de notificaciones de cierre

**Notificaciones automáticas:**
```sql
-- Trigger para enviar notificaciones de cierre
CREATE OR REPLACE FUNCTION send_closure_notifications()
RETURNS TRIGGER AS $$
BEGIN
    -- Solo ejecutar cuando el estado cambia a 'Closed'
    IF NEW.state = 'Closed' AND OLD.state != 'Closed' THEN
        -- Notificar al usuario que cerró el lote
        INSERT INTO user_notifications (
            user_fk, type, priority, title, content, channel
        ) VALUES (
            NEW.closed_by_fk,
            'batch_closed',
            'normal',
            'Lote de ingesta cerrado exitosamente',
            jsonb_build_object(
                'batch_id', NEW.ingest_batch_id,
                'closed_at', NEW.closed_at,
                'total_pages', NEW.final_page_count,
                'posted_results', NEW.successful_posts_count
            ),
            'email'
        );
        
        -- Notificar al coordinador del curso
        INSERT INTO user_notifications (
            user_fk, type, priority, title, content, channel
        )
        SELECT 
            c.coordinator_fk,
            'batch_closed_coordinator',
            'low',
            'Lote de evaluación finalizado: ' || e.title,
            jsonb_build_object(
                'batch_id', NEW.ingest_batch_id,
                'evaluation_name', e.title,
                'course_name', c.name,
                'closed_by', u.full_name,
                'metrics_summary', jsonb_build_object(
                    'total_pages', NEW.final_page_count,
                    'successful_posts', NEW.successful_posts_count
                )
            ),
            'email'
        FROM evaluations e
        JOIN courses c ON e.course_fk = c.course_id
        JOIN users u ON NEW.closed_by_fk = u.user_id
        WHERE e.evaluation_id = NEW.evaluation_fk
        AND c.coordinator_fk IS NOT NULL;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_batch_closure_notifications
    AFTER UPDATE ON ingest_batches
    FOR EACH ROW EXECUTE FUNCTION send_closure_notifications();
```

### Índices recomendados
- `CREATE INDEX idx_ingest_batches_state_closed ON ingest_batches (state, closed_at);`
- `CREATE INDEX idx_batch_closure_reports_batch ON batch_closure_reports (ingest_batch_fk);`
- `CREATE INDEX idx_scanned_pages_batch_status ON scanned_pages (ingest_batch_fk, status);`

### Referencias al modelo completo
Para más detalles sobre la estructura completa, restricciones, tipos de datos y triggers:
- [Modelo Entidad-Relación completo](../../../../06-data-model/mobile-ingest/mer.md)
- [Script DDL de creación](../../../../06-data-model/mobile-ingest/DDL.sql)
- [Triggers y funciones](../../../../06-data-model/mobile-ingest/TRIGGERS.sql)

---

[Subir](#cu-im-11--cierre-y-consolidación-de-lotes)
