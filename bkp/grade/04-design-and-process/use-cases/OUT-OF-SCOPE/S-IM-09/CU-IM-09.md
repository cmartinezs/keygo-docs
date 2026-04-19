# CU-IM-09 — Administración de anomalías y excepciones

- [Revisión](review.md)
- [Volver](../../README.md#3-ingesta-móvil)

## Escenario origen: S-IM-09 | Gestión centralizada de casos problemáticos

### RF relacionados: RF4, RF8, RF9

**Actor principal:** Coordinador académico / Administrador  
**Actores secundarios:** Docente, Sistema GRADE (Pipeline de procesamiento), Soporte técnico

---

### Objetivo
Proporcionar una interfaz centralizada para la gestión, seguimiento y resolución de anomalías detectadas en el proceso de ingesta móvil, permitiendo workflows de escalación, asignación de responsabilidades y métricas de calidad del sistema.

### Precondiciones
- Existen anomalías registradas en el sistema desde diferentes fuentes de ingesta.
- El usuario tiene permisos administrativos o de coordinación académica.
- Los workflows de resolución están configurados según políticas institucionales.
- Los usuarios responsables de resolución están identificados y activos.

### Postcondiciones
- Anomalías están categorizadas, priorizadas y asignadas apropiadamente.
- Workflows de resolución están en progreso según políticas institucionales.
- Métricas de calidad actualizadas reflejan estado del sistema.
- Notificaciones enviadas a responsables según escalación configurada.
- Reportes de tendencias disponibles para mejora de procesos.

### Flujo principal (éxito)
1. **Acceso al dashboard de anomalías:**
   - Usuario accede a **"Centro de Administración de Anomalías"**
   - Sistema presenta vista consolidada con:
     - Resumen ejecutivo de anomalías por tipo y estado
     - Filtros por período, curso, evaluación, tipo, prioridad
     - Indicadores de SLA y tiempo de resolución
2. **Revisión y categorización:**
   - Usuario selecciona conjunto de anomalías para revisar
   - Sistema muestra detalles contextuales de cada anomalía
   - Usuario puede:
     - Ajustar prioridad (Baja, Media, Alta, Crítica)
     - Reclasificar tipo de anomalía si es necesario
     - Agregar notas administrativas
3. **Asignación de responsabilidades:**
   - Sistema sugiere asignación automática basada en:
     - Tipo de anomalía y expertise requerido
     - Carga de trabajo actual de usuarios
     - Políticas de escalación configuradas
   - Usuario puede confirmar o modificar asignaciones
   - Se envían notificaciones a usuarios asignados
4. **Seguimiento de progreso:**
   - Dashboard muestra progreso en tiempo real
   - Estados: Pendiente → En Progreso → Bajo Revisión → Resuelto
   - Alertas automáticas por SLA próximos a vencimiento
   - Métricas de throughput por usuario y tipo
5. **Escalación automática:**
   - Sistema detecta anomalías que exceden tiempos configurados
   - Escala automáticamente según matriz de escalación:
     - Nivel 1: Docente responsable (24h)
     - Nivel 2: Coordinador académico (48h)
     - Nivel 3: Soporte técnico (72h)
     - Nivel 4: Administrador de sistema (96h)
6. **Análisis de tendencias:**
   - Sistema genera reportes automáticos de:
     - Tipos de anomalías más frecuentes
     - Tiempos promedio de resolución por categoría
     - Efectividad de diferentes estrategias de resolución
     - Identificación de puntos de mejora en el pipeline
7. **Cierre y documentación:**
   - Usuario marca anomalías como resueltas con documentación
   - Sistema valida que la resolución sea efectiva
   - Se actualiza base de conocimiento para casos similares
   - Métricas de calidad se recalculan automáticamente

### Flujos alternativos / Excepciones
- **A1 — Anomalía crítica del sistema:**
  - Sistema detecta anomalías que afectan operación general
  - Escala inmediatamente a soporte técnico con alerta alta
  - Implementa medidas de contingencia automáticas si están configuradas
- **A2 — Volumen masivo de anomalías:**
  - Sistema detecta incremento anómalo en cantidad de excepciones
  - Activa protocolo de gestión de crisis con notificación a administradores
  - Sugiere acciones de mitigación masiva (pausar procesamiento, etc.)
- **A3 — Usuario asignado no disponible:**
  - Sistema detecta que usuario asignado está inactivo o sobrecargado
  - Reasigna automáticamente según matriz de respaldo
  - Notifica cambio a supervisor correspondiente
- **A4 — Anomalía recurrente:**
  - Sistema identifica patrones de anomalías similares
  - Sugiere cambios de proceso o configuración para prevención
  - Genera recomendaciones para mejora del pipeline
- **A5 — Conflicto de resolución:**
  - Diferentes usuarios proponen resoluciones contradictorias
  - Sistema escala a nivel superior para arbitraje
  - Mantiene historial de decisiones para casos similares

### Reglas de negocio
- **RN-1:** Anomalías críticas deben asignarse automáticamente dentro de 15 minutos.
- **RN-2:** Todo cambio de prioridad debe justificarse y quedar auditado.
- **RN-3:** La escalación automática no puede omitir niveles sin autorización.
- **RN-4:** Anomalías resueltas no pueden reabrirse sin aprobación de supervisor.
- **RN-5:** Métricas de SLA se calculan en horario hábil únicamente.
- **RN-6:** Usuarios pueden ver solo anomalías de sus cursos asignados.

### Datos principales
- **Anomalía** (identificador, tipo, prioridad, estado, origen, descripción, impacto)
- **Asignación** (anomalía, usuario asignado, fecha asignación, SLA, estado)
- **Resolución** (anomalía, método usado, tiempo total, usuario resolvedor, efectividad)
- **Escalación** (anomalía, nivel origen, nivel destino, razón, timestamp)
- **Métrica de Calidad** (período, tipo anomalía, cantidad, tiempo promedio resolución, tasa éxito)
- **Workflow de Resolución** (tipo anomalía, pasos requeridos, responsables, tiempos límite)

### Consideraciones de seguridad/permiso
- **Roles diferenciados:** Administrador ve todo, coordinador solo su ámbito, docente solo sus cursos.
- **Auditoría completa:** Registro de todas las acciones administrativas con timestamps.
- **Confidencialidad:** Información de estudiantes mostrada solo a usuarios autorizados.
- **Integridad:** Validación de que cambios de estado son consistentes y autorizados.
- **Trazabilidad:** Historial completo de decisiones para accountability.

### No funcionales
- **Rendimiento:** 
  - Dashboard principal < 1s p95 para cargar
  - Filtros y búsquedas < 300ms p95
- **Escalabilidad:** 
  - Soporte para 10,000+ anomalías simultáneas
  - Procesamiento de alertas sin impacto en performance
- **Usabilidad:** 
  - Interfaz intuitiva con workflows claramente definidos
  - Acciones masivas para eficiencia operacional
- **Disponibilidad:** 
  - Sistema de alertas con 99.9% uptime
  - Notificaciones redundantes por múltiples canales

### Criterios de aceptación (QA)
- **CA-1:** Dashboard debe mostrar resumen ejecutivo actualizado en tiempo real.
- **CA-2:** Asignaciones automáticas deben respetar carga de trabajo y expertise.
- **CA-3:** Escalaciones deben ejecutarse automáticamente según SLA configurados.
- **CA-4:** Filtros y búsquedas deben permitir localizar anomalías específicas rápidamente.
- **CA-5:** Reportes de tendencias deben generarse automáticamente con datos precisos.
- **CA-6:** Notificaciones deben entregarse por canal preferido de cada usuario.
- **CA-7:** Métricas de calidad deben reflejar impacto real de las resoluciones.

---

## Anexo Técnico (para desarrollo)

> Esta sección contiene los detalles técnicos de implementación del sistema de administración de anomalías según el modelo de datos del sistema de Ingesta Móvil.

### Resumen del modelo de datos

#### Entidades principales involucradas
- **`anomaly_registry`**: Registro central de todas las anomalías detectadas en el sistema.
- **`anomaly_assignments`**: Asignaciones de anomalías a usuarios responsables con SLA.
- **`anomaly_resolutions`**: Registro de resoluciones con métodos y efectividad.
- **`escalation_matrix`**: Configuración de workflows de escalación por tipo de anomalía.
- **`quality_metrics`**: Métricas agregadas de calidad del sistema de ingesta.
- **`resolution_workflows`**: Templates de procesos de resolución por categoría.

#### Relaciones clave
- Las **anomalías** se detectan desde múltiples fuentes (`ingest_results`, `processing_jobs`, `scanned_pages`).
- Las **asignaciones** vinculan anomalías con usuarios según expertise y disponibilidad.
- Las **escalaciones** siguen matrices predefinidas con tiempos y responsables.
- Las **métricas** se calculan en tiempo real desde el historial de resoluciones.

#### Campos críticos para este caso de uso
**En `anomaly_registry`:**
- `type` (student_resolution, quality_issue, technical_error), `priority` (1-4)
- `source_table`, `source_record_id` (referencia a origen), `impact_level`
- `detected_at`, `resolved_at`, `status` (pending/assigned/in_progress/resolved)

**En `anomaly_assignments`:**
- `anomaly_fk`, `assigned_to_fk`, `assigned_at`, `sla_deadline`
- `escalation_level` (1-4), `status` (active/completed/escalated)

**En `escalation_matrix`:**
- `anomaly_type`, `level`, `role_required`, `sla_hours`
- `auto_escalate`, `notification_template`

#### Arquitectura de Gestión
El sistema usa **workflows configurables**, **escalación automática** con **cron jobs**, y **métricas en tiempo real** calculadas con **vistas materializadas**.

### Validaciones implementadas en base de datos

**Consultar anomalías pendientes con contexto:**
```sql
SELECT 
    ar.anomaly_id,
    ar.type,
    ar.priority,
    ar.description,
    ar.detected_at,
    aa.assigned_to_fk,
    u.full_name as assigned_to_name,
    aa.sla_deadline,
    CASE 
        WHEN aa.sla_deadline < NOW() THEN 'overdue'
        WHEN aa.sla_deadline < NOW() + INTERVAL '4 hours' THEN 'warning'
        ELSE 'on_time'
    END as sla_status,
    e.title as evaluation_name,
    c.name as course_name
FROM anomaly_registry ar
LEFT JOIN anomaly_assignments aa ON ar.anomaly_id = aa.anomaly_fk AND aa.status = 'active'
LEFT JOIN users u ON aa.assigned_to_fk = u.user_id
LEFT JOIN ingest_results ir ON ar.source_table = 'ingest_results' AND ar.source_record_id = ir.ingest_result_id
LEFT JOIN scanned_pages sp ON ir.scanned_page_fk = sp.scanned_page_id
LEFT JOIN ingest_batches ib ON sp.ingest_batch_fk = ib.ingest_batch_id
LEFT JOIN evaluations e ON ib.evaluation_fk = e.evaluation_id
LEFT JOIN courses c ON e.course_fk = c.course_id
WHERE ar.status IN ('pending', 'assigned', 'in_progress')
ORDER BY ar.priority DESC, aa.sla_deadline ASC;
```

**Detectar anomalías que requieren escalación:**
```sql
SELECT 
    aa.assignment_id,
    ar.anomaly_id,
    ar.type,
    aa.escalation_level,
    em.sla_hours,
    aa.assigned_at + INTERVAL em.sla_hours||' hours' as escalation_deadline
FROM anomaly_assignments aa
JOIN anomaly_registry ar ON aa.anomaly_fk = ar.anomaly_id
JOIN escalation_matrix em ON ar.type = em.anomaly_type AND aa.escalation_level = em.level
WHERE aa.status = 'active'
AND em.auto_escalate = true
AND NOW() > aa.assigned_at + INTERVAL em.sla_hours||' hours'
AND NOT EXISTS (
    SELECT 1 FROM anomaly_assignments aa2 
    WHERE aa2.anomaly_fk = aa.anomaly_fk 
    AND aa2.escalation_level > aa.escalation_level
);
```

### Ejemplo de implementación de gestión de anomalías

```sql
-- PASO 1: Crear registro de anomalía
INSERT INTO anomaly_registry (
    type, priority, description, source_table, source_record_id,
    impact_level, detected_at, status
) VALUES (
    :anomaly_type, :priority, :description, :source_table, :source_id,
    :impact_level, NOW(), 'pending'
) RETURNING anomaly_id;

-- PASO 2: Asignar automáticamente según matriz de escalación
WITH assignment_target AS (
    SELECT 
        em.role_required,
        em.sla_hours,
        em.level as escalation_level
    FROM escalation_matrix em
    WHERE em.anomaly_type = :anomaly_type
    AND em.level = 1
),
available_user AS (
    SELECT u.user_id
    FROM users u
    JOIN user_roles ur ON u.user_id = ur.user_fk
    JOIN assignment_target at ON ur.role_name = at.role_required
    LEFT JOIN (
        SELECT assigned_to_fk, COUNT(*) as current_load
        FROM anomaly_assignments 
        WHERE status = 'active'
        GROUP BY assigned_to_fk
    ) load ON u.user_id = load.assigned_to_fk
    WHERE u.active = true
    ORDER BY COALESCE(load.current_load, 0)
    LIMIT 1
)
INSERT INTO anomaly_assignments (
    anomaly_fk, assigned_to_fk, assigned_at, sla_deadline, escalation_level, status
)
SELECT 
    :anomaly_id,
    au.user_id,
    NOW(),
    NOW() + INTERVAL at.sla_hours||' hours',
    at.escalation_level,
    'active'
FROM available_user au, assignment_target at;

-- PASO 3: Actualizar estado de anomalía
UPDATE anomaly_registry 
SET status = 'assigned'
WHERE anomaly_id = :anomaly_id;
```

### Sistema de escalación automática

**Función de escalación programada:**
```sql
CREATE OR REPLACE FUNCTION process_automatic_escalations()
RETURNS INTEGER AS $$
DECLARE
    escalation_record RECORD;
    next_level_user INTEGER;
    escalations_processed INTEGER := 0;
BEGIN
    -- Procesar cada anomalía que requiere escalación
    FOR escalation_record IN (
        SELECT 
            aa.assignment_id,
            aa.anomaly_fk,
            ar.type as anomaly_type,
            aa.escalation_level
        FROM anomaly_assignments aa
        JOIN anomaly_registry ar ON aa.anomaly_fk = ar.anomaly_id
        JOIN escalation_matrix em ON ar.type = em.anomaly_type 
            AND aa.escalation_level = em.level
        WHERE aa.status = 'active'
        AND em.auto_escalate = true
        AND NOW() > aa.assigned_at + INTERVAL em.sla_hours||' hours'
    ) LOOP
        -- Encontrar usuario del siguiente nivel
        SELECT u.user_id INTO next_level_user
        FROM users u
        JOIN user_roles ur ON u.user_id = ur.user_fk
        JOIN escalation_matrix em ON ur.role_name = em.role_required
        WHERE em.anomaly_type = escalation_record.anomaly_type
        AND em.level = escalation_record.escalation_level + 1
        AND u.active = true
        ORDER BY RANDOM()  -- Distribución equitativa
        LIMIT 1;
        
        IF next_level_user IS NOT NULL THEN
            -- Cerrar asignación actual
            UPDATE anomaly_assignments 
            SET status = 'escalated', escalated_at = NOW()
            WHERE assignment_id = escalation_record.assignment_id;
            
            -- Crear nueva asignación en nivel superior
            INSERT INTO anomaly_assignments (
                anomaly_fk, assigned_to_fk, assigned_at, sla_deadline,
                escalation_level, status
            )
            SELECT 
                escalation_record.anomaly_fk,
                next_level_user,
                NOW(),
                NOW() + INTERVAL em.sla_hours||' hours',
                em.level,
                'active'
            FROM escalation_matrix em
            WHERE em.anomaly_type = escalation_record.anomaly_type
            AND em.level = escalation_record.escalation_level + 1;
            
            escalations_processed := escalations_processed + 1;
        END IF;
    END LOOP;
    
    RETURN escalations_processed;
END;
$$ LANGUAGE plpgsql;

-- Programar ejecución cada 15 minutos
SELECT cron.schedule('process-escalations', '*/15 * * * *', 'SELECT process_automatic_escalations();');
```

### Dashboard de métricas en tiempo real

**Vista materializada para performance:**
```sql
CREATE MATERIALIZED VIEW anomaly_metrics_dashboard AS
SELECT 
    ar.type as anomaly_type,
    ar.priority,
    COUNT(*) as total_count,
    COUNT(CASE WHEN ar.status = 'pending' THEN 1 END) as pending_count,
    COUNT(CASE WHEN ar.status = 'resolved' THEN 1 END) as resolved_count,
    AVG(
        CASE WHEN ar.resolved_at IS NOT NULL 
        THEN EXTRACT(EPOCH FROM (ar.resolved_at - ar.detected_at)) / 3600 
        END
    ) as avg_resolution_hours,
    COUNT(CASE WHEN aa.sla_deadline < NOW() AND ar.status != 'resolved' THEN 1 END) as overdue_count,
    MAX(ar.detected_at) as last_occurrence
FROM anomaly_registry ar
LEFT JOIN anomaly_assignments aa ON ar.anomaly_id = aa.anomaly_fk AND aa.status = 'active'
WHERE ar.detected_at >= NOW() - INTERVAL '30 days'
GROUP BY ar.type, ar.priority
WITH DATA;

-- Refresh cada 5 minutos
SELECT cron.schedule('refresh-anomaly-metrics', '*/5 * * * *', 
    'REFRESH MATERIALIZED VIEW anomaly_metrics_dashboard;');
```

### API para administración de anomalías

**Endpoints principales:**
```javascript
// GET /api/admin/anomalies/dashboard
app.get('/api/admin/anomalies/dashboard', async (req, res) => {
    const { timeframe = '7d', type, priority } = req.query;
    const userId = req.user.id;
    
    // Validar permisos administrativos
    if (!await hasAdminPermissions(userId)) {
        return res.status(403).json({ error: 'Admin access required' });
    }
    
    const [
        summary,
        trendData,
        overdueItems,
        topTypes
    ] = await Promise.all([
        getAnomalySummary(timeframe, type, priority),
        getAnomalyTrends(timeframe),
        getOverdueAnomalies(userId),
        getTopAnomalyTypes(timeframe)
    ]);
    
    res.json({
        summary,
        trends: trendData,
        overdue: overdueItems,
        topTypes: topTypes,
        lastUpdated: new Date().toISOString()
    });
});

// POST /api/admin/anomalies/:id/assign
app.post('/api/admin/anomalies/:id/assign', async (req, res) => {
    const { id } = req.params;
    const { assignToUserId, priority, notes } = req.body;
    const adminUserId = req.user.id;
    
    try {
        const result = await assignAnomaly({
            anomalyId: id,
            assignToUserId,
            assignedBy: adminUserId,
            newPriority: priority,
            notes
        });
        
        // Enviar notificación al usuario asignado
        await sendAssignmentNotification(assignToUserId, result.anomalyDetails);
        
        res.json({
            success: true,
            assignmentId: result.assignmentId,
            slaDeadline: result.slaDeadline
        });
        
    } catch (error) {
        res.status(500).json({ error: 'Assignment failed' });
    }
});
```

### Sistema de notificaciones inteligentes

**Generación de alertas contextuales:**
```sql
-- Trigger para notificaciones automáticas
CREATE OR REPLACE FUNCTION send_anomaly_notifications()
RETURNS TRIGGER AS $$
BEGIN
    -- Notificación de asignación nueva
    IF TG_OP = 'INSERT' THEN
        INSERT INTO user_notifications (
            user_fk, type, priority, title, content, channel
        )
        SELECT 
            NEW.assigned_to_fk,
            'anomaly_assigned',
            CASE ar.priority 
                WHEN 4 THEN 'high'
                WHEN 3 THEN 'normal' 
                ELSE 'low'
            END,
            'Nueva anomalía asignada: ' || ar.type,
            jsonb_build_object(
                'anomaly_id', NEW.anomaly_fk,
                'type', ar.type,
                'description', ar.description,
                'sla_deadline', NEW.sla_deadline,
                'escalation_level', NEW.escalation_level
            ),
            CASE ar.priority WHEN 4 THEN 'push' ELSE 'email' END
        FROM anomaly_registry ar
        WHERE ar.anomaly_id = NEW.anomaly_fk;
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tr_anomaly_assignment_notifications
    AFTER INSERT OR UPDATE ON anomaly_assignments
    FOR EACH ROW EXECUTE FUNCTION send_anomaly_notifications();
```

### Índices recomendados
- `CREATE INDEX idx_anomaly_registry_status_priority ON anomaly_registry (status, priority, detected_at);`
- `CREATE INDEX idx_anomaly_assignments_sla ON anomaly_assignments (status, sla_deadline);`
- `CREATE INDEX idx_anomaly_registry_type_resolved ON anomaly_registry (type, resolved_at);`
- `CREATE INDEX idx_escalation_matrix_type_level ON escalation_matrix (anomaly_type, level);`

### Referencias al modelo completo
Para más detalles sobre la estructura completa, restricciones, tipos de datos y triggers:
- [Modelo Entidad-Relación completo](../../../../06-data-model/mobile-ingest/mer.md)
- [Script DDL de creación](../../../../06-data-model/mobile-ingest/DDL.sql)
- [Triggers y funciones](../../../../06-data-model/mobile-ingest/TRIGGERS.sql)

---

[Subir](#cu-im-09--administración-de-anomalías-y-excepciones)
