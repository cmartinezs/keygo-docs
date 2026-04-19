# CU-IM-06 — Monitoreo en tiempo real y notificaciones inteligentes

- [Revisión](review.md)
- [Volver](../../README.md#3-ingesta-móvil)

## Escenario origen: S-IM-06 | Estado de procesamiento y notificación

### RF relacionados: RF4, RF11

**Actor principal:** Docente/Asistente de aula  
**Actores secundarios:** Sistema de notificaciones, Dashboard de monitoreo, Pipeline de procesamiento

---

### Objetivo
Proporcionar visibilidad completa en tiempo real del progreso de procesamiento de lotes de ingesta, páginas escaneadas y trabajos de procesamiento, con notificaciones proactivas sobre éxito, problemas, y acciones requeridas, permitiendo intervención oportuna cuando sea necesaria.

### Precondiciones
- El usuario tiene lotes de ingesta asociados en cualquier estado (Abierto, Procesando, Cerrado).
- Existen páginas escaneadas y trabajos de procesamiento con historial de procesamiento.
- El usuario está autenticado con permisos sobre las evaluaciones correspondientes.
- El sistema de notificaciones está configurado (push, email, in-app).

### Postcondiciones
- El usuario tiene visibilidad completa del estado de todos sus lotes y páginas.
- Las notificaciones han sido entregadas según preferencias configuradas.
- Los elementos que requieren acción manual están claramente identificados.
- El dashboard muestra métricas actualizadas en tiempo real.
- Los logs detallados están disponibles para troubleshooting si es necesario.

### Flujo principal (éxito)
1. **Dashboard principal:**
   - El usuario accede a la sección **"Monitoreo de Ingesta"** en la app/web
   - El sistema presenta dashboard con vista agregada:
     - Resumen por evaluación (batches activos, completados, con problemas)
     - Progreso en tiempo real de procesamiento
     - Alertas prioritarias que requieren atención
2. **Vista detallada por batch:**
   - El usuario selecciona un batch específico
   - El sistema muestra estado detallado:
     - **Metadatos:** Evaluación, curso, fecha, cantidad de páginas
     - **Pipeline de procesamiento:** Progreso por etapas (Decode → Detect → Map → Post)
     - **Estado individual por página:** Con métricas de calidad y anomalías
     - **Timeline:** Historial cronológico de eventos importantes
3. **Monitoreo en tiempo real:**
   - **WebSocket/SSE:** Actualizaciones automáticas sin refresh
   - **Indicadores visuales:** Barras de progreso, códigos de color, badges de estado
   - **Métricas live:** Tiempo estimado de finalización, throughput, tasa de éxito
4. **Notificaciones inteligentes:**
   - **Procesamiento completado:** Resumen de éxito con estadísticas
   - **Anomalías detectadas:** Detalle específico y acciones sugeridas
   - **Errores críticos:** Alertas inmediatas con información para resolución
   - **Milestones importantes:** Finalización de etapas, inicio de posting
5. **Análisis de problemas:**
   - **Drill-down:** Desde alertas generales hacia páginas específicas problemáticas
   - **Logs contextuales:** Acceso a logs de procesamiento filtrados por relevancia
   - **Recomendaciones:** Acciones sugeridas basadas en tipo de problema
6. **Acciones correctivas:**
   - **Retry automático:** Para fallos temporales según configuración
   - **Reprocessamiento manual:** Para páginas específicas que requieren ajustes
   - **Escalación:** Contacto directo con soporte técnico desde la interfaz

### Flujos alternativos / Excepciones
- **A1 — Lote en estado crítico:**
  - Detecta múltiples fallos consecutivos en trabajos de procesamiento
  - Genera alerta de alta prioridad con análisis automático de causa raíz
  - Ofrece opciones: retry automático, reprocessamiento, escalación técnica
- **A2 — Anomalías de calidad masivas:**
  - Detecta patrón de baja calidad en múltiples páginas del mismo lote
  - Sugiere problemas sistemáticos (iluminación, enfoque, template)
  - Recomienda recaptura completa vs ajustes de configuración
- **A3 — Estudiantes no identificados:**
  - Identifica páginas sin estudiante resuelto en resultados de ingesta
  - Presenta interfaz para resolución manual de identidad
  - Ofrece herramientas de matching automático basado en patrones
- **A4 — Timeout de procesamiento:**
  - Detecta trabajos de procesamiento que exceden tiempo esperado
  - Analiza carga del sistema y capacidad de procesamiento
  - Ajusta prioridades automáticamente o sugiere redistribución de carga
- **A5 — Conflictos de posting:**
  - Identifica problemas en transferencia a sistema de calificaciones
  - Muestra detalles de conflictos (duplicados, inconsistencias)
  - Facilita resolución con políticas predefinidas
- **A6 — Pérdida de conectividad durante monitoreo:**
  - Mantiene última información conocida en caché local
  - Muestra indicador de desconexión y timestamp de última actualización
  - Re-sincroniza automáticamente al restablecer conectividad

### Reglas de negocio
- **RN-1:** Las notificaciones deben enviarse según preferencias del usuario (inmediata, agrupada, diaria).
- **RN-2:** Solo usuarios con permisos sobre el curso pueden ver el monitoreo de sus lotes.
- **RN-3:** Las alertas críticas deben entregarse en menos de 30 segundos desde su detección.
- **RN-4:** El dashboard debe actualizarse automáticamente cada 5 segundos para datos críticos.
- **RN-5:** Los logs de procesamiento se mantienen por 30 días para troubleshooting.
- **RN-6:** Las métricas agregadas se calculan en tiempo real sin afectar performance del sistema.

### Datos principales
- **Estado de Lote** (identificador, evaluación, estado, progreso, métricas tiempo real, alertas activas)
- **Estado de Página** (identificador, lote, estado procesamiento, calidad, anomalías, tiempo procesamiento)
- **Trabajo de Procesamiento** (identificador, página, etapa, estado, inicio, fin, error, logs)
- **Notificación** (identificador, usuario, tipo, prioridad, título, contenido, entregada, leída)
- **Métrica de Monitoreo** (timestamp, lote, páginas procesadas, tasa éxito, tiempo promedio, alertas)
- **Preferencia de Usuario** (usuario, tipo notificación, canal preferido, frecuencia, filtros)

### Consideraciones de seguridad/permiso
- **Autorización granular:** Solo acceso a lotes/evaluaciones del curso del usuario.
- **Filtrado de logs:** Logs sensibles (errores técnicos) solo para roles administrativos.
- **Rate limiting:** Prevenir abuse de APIs de notificaciones.
- **Datos personales:** Cifrado de información de estudiantes en notificaciones.
- **Auditoría:** Registro de acceso a información de monitoreo.

### No funcionales
- **Rendimiento:** 
  - Actualización de dashboard < 200ms p95
  - Entrega de notificaciones críticas < 30s
- **Escalabilidad:** 
  - Soporte para 1000+ usuarios concurrentes monitoreando
  - Agregación de métricas sin impacto en performance de procesamiento
- **Usabilidad:** 
  - Interfaz responsiva para móviles y escritorio
  - Indicadores visuales claros de estado y progreso
- **Disponibilidad:** 
  - Sistema de notificaciones con 99.9% uptime
  - Fallback graceful si falla monitoreo en tiempo real

### Criterios de aceptación (QA)
- **CA-1:** El dashboard debe mostrar estado actualizado de lotes en < 5 segundos desde cambios.
- **CA-2:** Notificaciones críticas deben entregarse por canal preferido en < 30 segundos.
- **CA-3:** Vista detallada debe mostrar progreso individual por página con métricas precisas.
- **CA-4:** Filtros y drill-down deben permitir identificar páginas problemáticas rápidamente.
- **CA-5:** Acciones correctivas (retry, reprocess) deben ejecutarse inmediatamente desde la interfaz.
- **CA-6:** Logs contextuales deben estar disponibles para troubleshooting técnico.
- **CA-7:** Sistema debe funcionar offline mostrando última información conocida.

---

## Anexo Técnico (para desarrollo)

> Esta sección contiene los detalles técnicos de implementación del sistema de monitoreo y notificaciones según el modelo de datos del sistema de Ingesta Móvil.

### Resumen del modelo de datos

#### Entidades principales involucradas
- **`ingest_batches`**: Lotes con estados que se monitorean en tiempo real.
- **`scanned_pages`**: Páginas individuales con estados de procesamiento y métricas.
- **`processing_jobs`**: Trabajos del pipeline con timestamps y estados detallados.
- **`processing_logs`**: Logs granulares del procesamiento para troubleshooting.
- **`user_notifications`**: Sistema de notificaciones con preferencias y entrega.
- **`monitoring_metrics`**: Métricas agregadas calculadas para dashboard.

#### Relaciones clave
- El **monitoreo** agrega información desde múltiples niveles: `ingest_batches → scanned_pages → processing_jobs → processing_logs`.
- Las **notificaciones** se disparan por eventos del pipeline y se entregan según preferencias del usuario.
- Las **métricas** se calculan en tiempo real usando vistas materializadas y cache distribuido.
- Los **permisos** se validan a nivel de curso para filtrar información visible.

#### Campos críticos para este caso de uso
**En `processing_jobs`:**
- `stage`, `status`, `started_at`, `finished_at` (para cálculo de progreso y tiempos)
- `error` (para identificación de problemas y generación de alertas)

**En `processing_logs`:**
- `level` (INFO/WARN/ERROR), `message`, `data` (para análisis detallado)
- `ts` (timestamp para correlación temporal de eventos)

**En `user_notifications`:**
- `user_fk`, `type`, `priority`, `channel`, `delivered_at`, `read_at`
- `content` (JSONB con datos específicos del evento)

#### Arquitectura de Monitoreo
El sistema usa **WebSockets** para actualizaciones en tiempo real, **métricas pre-calculadas** para performance, y **notificaciones asíncronas** con múltiples canales.

### Validaciones implementadas en base de datos

**Consulta de estado agregado por lote:**
```sql
SELECT 
    ib.ingest_batch_id,
    ib.evaluation_fk,
    ib.state as batch_state,
    COUNT(sp.scanned_page_id) as total_pages,
    COUNT(CASE WHEN sp.status = 'Decoded' THEN 1 END) as pages_completed,
    COUNT(CASE WHEN sp.status = 'Failed' THEN 1 END) as pages_failed,
    ROUND(
        COUNT(CASE WHEN sp.status = 'Decoded' THEN 1 END) * 100.0 / 
        NULLIF(COUNT(sp.scanned_page_id), 0), 2
    ) as completion_percentage,
    MAX(pj.started_at) as last_activity
FROM ingest_batches ib
LEFT JOIN scanned_pages sp ON ib.ingest_batch_id = sp.ingest_batch_fk
LEFT JOIN processing_jobs pj ON sp.scanned_page_id = pj.scanned_page_fk
WHERE ib.device_fk IN (
    SELECT device_id FROM ingest_devices 
    WHERE registered_by_fk = :user_id
)
GROUP BY ib.ingest_batch_id, ib.evaluation_fk, ib.state
ORDER BY ib.started_at DESC;
```

**Detección de anomalías para alertas:**
```sql
-- Páginas con múltiples fallos consecutivos
SELECT sp.scanned_page_id, sp.image_uri, COUNT(pj.processing_job_id) as failed_attempts,
       MAX(pj.error) as last_error
FROM scanned_pages sp
JOIN processing_jobs pj ON sp.scanned_page_id = pj.scanned_page_fk
WHERE pj.status = 'Failed'
AND pj.started_at >= NOW() - INTERVAL '1 hour'
GROUP BY sp.scanned_page_id, sp.image_uri
HAVING COUNT(pj.processing_job_id) >= 3;
```

### Ejemplo de implementación del sistema en tiempo real

**WebSocket handler para actualizaciones live:**
```javascript
class IngestMonitoringService {
    constructor() {
        this.wsConnections = new Map();
        this.metricsCache = new Redis();
    }
    
    async sendBatchUpdate(batchId, updateData) {
        // Calcular métricas en tiempo real
        const metrics = await this.calculateBatchMetrics(batchId);
        
        // Preparar payload para WebSocket
        const payload = {
            type: 'batch_update',
            batchId: batchId,
            timestamp: Date.now(),
            data: {
                ...updateData,
                metrics: metrics,
                lastUpdated: new Date().toISOString()
            }
        };
        
        // Enviar a usuarios suscritos con permisos
        const authorizedUsers = await this.getAuthorizedUsers(batchId);
        authorizedUsers.forEach(userId => {
            const ws = this.wsConnections.get(userId);
            if (ws && ws.readyState === WebSocket.OPEN) {
                ws.send(JSON.stringify(payload));
            }
        });
    }
    
    async calculateBatchMetrics(batchId) {
        const cacheKey = `batch_metrics:${batchId}`;
        let metrics = await this.metricsCache.get(cacheKey);
        
        if (!metrics) {
            // Calcular métricas desde BD
            metrics = await this.queryBatchMetrics(batchId);
            // Cache por 30 segundos
            await this.metricsCache.setex(cacheKey, 30, JSON.stringify(metrics));
        } else {
            metrics = JSON.parse(metrics);
        }
        
        return metrics;
    }
}
```

**Sistema de notificaciones inteligentes:**
```sql
-- Trigger para generar notificaciones automáticas
CREATE OR REPLACE FUNCTION notify_processing_events()
RETURNS TRIGGER AS $$
BEGIN
    -- Notificar completion de batch
    IF NEW.state = 'Closed' AND OLD.state != 'Closed' THEN
        INSERT INTO user_notifications (
            user_fk, type, priority, title, content, channel
        )
        SELECT 
            id.registered_by_fk,
            'batch_completed',
            'normal',
            'Lote de ingesta completado',
            jsonb_build_object(
                'batch_id', NEW.ingest_batch_id,
                'evaluation_name', e.title,
                'total_pages', (SELECT COUNT(*) FROM scanned_pages WHERE ingest_batch_fk = NEW.ingest_batch_id),
                'success_rate', (SELECT ROUND(
                    COUNT(CASE WHEN status = 'Decoded' THEN 1 END) * 100.0 / COUNT(*), 2
                ) FROM scanned_pages WHERE ingest_batch_fk = NEW.ingest_batch_id)
            ),
            'push'
        FROM ingest_devices id
        JOIN evaluations e ON NEW.evaluation_fk = e.evaluation_id
        WHERE id.device_id = NEW.device_fk;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### Dashboard de métricas en tiempo real

**Vista materializada para performance:**
```sql
CREATE MATERIALIZED VIEW batch_monitoring_summary AS
SELECT 
    ib.ingest_batch_id,
    ib.evaluation_fk,
    e.title as evaluation_name,
    c.name as course_name,
    ib.state,
    ib.started_at,
    ib.closed_at,
    COUNT(sp.scanned_page_id) as total_pages,
    COUNT(CASE WHEN sp.status = 'Decoded' THEN 1 END) as completed_pages,
    COUNT(CASE WHEN sp.status = 'Failed' THEN 1 END) as failed_pages,
    COUNT(CASE WHEN ir.state = 'Posted' THEN 1 END) as posted_results,
    COALESCE(AVG(
        EXTRACT(EPOCH FROM (pj_last.finished_at - pj_first.started_at))
    ), 0) as avg_processing_time_seconds,
    MAX(pl.ts) as last_activity,
    COUNT(CASE WHEN pl.level = 'ERROR' THEN 1 END) as error_count
FROM ingest_batches ib
JOIN evaluations e ON ib.evaluation_fk = e.evaluation_id
JOIN courses c ON e.course_fk = c.course_id
LEFT JOIN scanned_pages sp ON ib.ingest_batch_id = sp.ingest_batch_fk
LEFT JOIN ingest_results ir ON sp.scanned_page_id = ir.scanned_page_fk
LEFT JOIN processing_jobs pj_first ON sp.scanned_page_id = pj_first.scanned_page_fk AND pj_first.stage = 'Decode'
LEFT JOIN processing_jobs pj_last ON sp.scanned_page_id = pj_last.scanned_page_fk AND pj_last.stage = 'Post'
LEFT JOIN processing_logs pl ON pj_first.processing_job_id = pl.processing_job_fk
GROUP BY ib.ingest_batch_id, ib.evaluation_fk, e.title, c.name, ib.state, ib.started_at, ib.closed_at
WITH DATA;

-- Refresh automático cada minuto
CREATE OR REPLACE FUNCTION refresh_batch_monitoring()
RETURNS void AS $$
BEGIN
    REFRESH MATERIALIZED VIEW batch_monitoring_summary;
END;
$$ LANGUAGE plpgsql;

SELECT cron.schedule('refresh-monitoring', '* * * * *', 'SELECT refresh_batch_monitoring();');
```

### Sistema de alertas inteligentes

**Detección de patrones problemáticos:**
```sql
-- Función para detectar anomalías de calidad masivas
CREATE OR REPLACE FUNCTION detect_quality_anomalies(batch_id BIGINT)
RETURNS TABLE (
    anomaly_type TEXT,
    affected_pages INTEGER,
    avg_quality_score NUMERIC,
    recommended_action TEXT
) AS $$
BEGIN
    -- Detectar baja calidad generalizada
    RETURN QUERY
    SELECT 
        'low_quality_pattern'::TEXT,
        COUNT(*)::INTEGER,
        AVG(pd.quality_score),
        CASE 
            WHEN AVG(pd.quality_score) < 30 THEN 'recapture_all'
            WHEN AVG(pd.quality_score) < 50 THEN 'adjust_settings'
            ELSE 'review_individual'
        END::TEXT
    FROM scanned_pages sp
    JOIN page_detections pd ON sp.scanned_page_id = pd.scanned_page_fk
    WHERE sp.ingest_batch_fk = batch_id
    AND pd.quality_score < 60
    GROUP BY sp.ingest_batch_fk
    HAVING COUNT(*) > (
        SELECT COUNT(*) * 0.5 FROM scanned_pages WHERE ingest_batch_fk = batch_id
    );
END;
$$ LANGUAGE plpgsql;
```

### API de monitoreo para aplicaciones

**Endpoint REST para dashboard:**
```javascript
// GET /api/monitoring/batches/:batchId/detailed-status
app.get('/api/monitoring/batches/:batchId/detailed-status', async (req, res) => {
    const { batchId } = req.params;
    
    // Validar permisos del usuario
    const hasAccess = await validateBatchAccess(req.user.id, batchId);
    if (!hasAccess) {
        return res.status(403).json({ error: 'Access denied' });
    }
    
    const [
        batchSummary,
        pageDetails,
        processingTimeline,
        activeAlerts
    ] = await Promise.all([
        getBatchSummary(batchId),
        getPageDetails(batchId),
        getProcessingTimeline(batchId),
        getActiveAlerts(batchId)
    ]);
    
    res.json({
        batch: batchSummary,
        pages: pageDetails,
        timeline: processingTimeline,
        alerts: activeAlerts,
        lastUpdated: new Date().toISOString()
    });
});
```

### Índices recomendados para monitoreo
- `CREATE INDEX idx_processing_jobs_page_stage_status ON processing_jobs (scanned_page_fk, stage, status);`
- `CREATE INDEX idx_processing_logs_job_level_ts ON processing_logs (processing_job_fk, level, ts);`
- `CREATE INDEX idx_user_notifications_user_delivered ON user_notifications (user_fk, delivered_at);`
- `CREATE INDEX idx_scanned_pages_batch_status ON scanned_pages (ingest_batch_fk, status);`

### Referencias al modelo completo
Para más detalles sobre la estructura completa, restricciones, tipos de datos y triggers:
- [Modelo Entidad-Relación completo](../../../../06-data-model/mobile-ingest/mer.md)
- [Script DDL de creación](../../../../06-data-model/mobile-ingest/DDL.sql)
- [Triggers y funciones](../../../../06-data-model/mobile-ingest/TRIGGERS.sql)

---

[Subir](#cu-im-06--monitoreo-en-tiempo-real-y-notificaciones-inteligentes)
