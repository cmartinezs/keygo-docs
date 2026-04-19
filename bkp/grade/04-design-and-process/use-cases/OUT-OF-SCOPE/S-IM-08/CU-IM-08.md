# CU-IM-08 — Resolución manual de identidades

- [Revisión](review.md)
- [Volver](../../README.md#3-ingesta-móvil)

## Escenario origen: S-IM-08 | Identificación manual de estudiantes

### RF relacionados: RF4, RF8

**Actor principal:** Docente / Asistente de aula  
**Actores secundarios:** Sistema GRADE (Gestión de calificaciones), Coordinador académico

---

### Objetivo
Permitir la identificación manual de estudiantes en páginas escaneadas que no pudieron ser identificadas automáticamente, mediante interfaces de matching visual y herramientas de búsqueda, garantizando que todas las respuestas capturadas puedan ser asociadas correctamente a sus autores.

### Precondiciones
- Existen resultados de ingesta en estado **Listo** sin estudiante identificado.
- El usuario tiene permisos sobre el curso y evaluación correspondiente.
- La lista de estudiantes matriculados está disponible y actualizada.
- Las imágenes de páginas escaneadas están accesibles para visualización.

### Postcondiciones
- Páginas sin identificar quedan asociadas a estudiantes específicos.
- Los resultados de ingesta actualizados pueden proceder al posting de calificaciones.
- Las identificaciones manuales quedan registradas en auditoría con justificación.
- Se generan métricas de calidad del proceso de identificación automática.

### Flujo principal (éxito)
1. **Acceso al panel de resolución:**
   - Usuario navega a **"Anomalías pendientes"** desde el dashboard de monitoreo
   - Sistema muestra lista de lotes con páginas sin identificar
   - Usuario selecciona lote específico para procesar
2. **Vista de páginas sin identificar:**
   - Sistema presenta lista de páginas problemáticas con:
     - Thumbnail de la imagen escaneada
     - Información del QR detectado (si existe pero es inválido)
     - Timestamp de captura y dispositivo origen
     - Razón de falla en identificación automática
3. **Selección de página a resolver:**
   - Usuario selecciona una página específica
   - Sistema abre vista detallada con:
     - Imagen completa en alta resolución
     - Herramientas de zoom y rotación
     - Información técnica del procesamiento (opcional)
4. **Búsqueda y matching de estudiante:**
   - **Opción A - Búsqueda por nombre:**
     - Usuario ingresa nombre parcial o completo
     - Sistema filtra lista de estudiantes matriculados
   - **Opción B - Búsqueda por ID:**
     - Usuario ingresa número de matrícula o ID
     - Sistema busca coincidencias exactas
   - **Opción C - Lista completa:**
     - Usuario navega lista completa de estudiantes del curso
     - Sistema permite ordenar por nombre, matrícula, etc.
5. **Confirmación de matching:**
   - Usuario selecciona estudiante identificado
   - Sistema muestra confirmación con:
     - Datos del estudiante seleccionado
     - Preview de respuestas detectadas en la página
     - Advertencia si el estudiante ya tiene respuestas registradas
6. **Validación y registro:**
   - Usuario confirma la identificación
   - Sistema valida que no genere duplicados problemáticos
   - Actualiza resultado de ingesta con estudiante resuelto
   - Registra identificación manual en auditoría
7. **Continuación del flujo:**
   - Sistema marca página como resuelta
   - Pregunta si continuar con siguiente página sin identificar
   - Actualiza contadores de progreso del lote

### Flujos alternativos / Excepciones
- **A1 — Estudiante ya tiene respuestas:**
  - Sistema detecta que estudiante seleccionado ya respondió la evaluación
  - Muestra advertencia con opciones:
    - Reemplazar respuestas existentes (requiere justificación)
    - Mantener respuestas originales y descartar página actual
    - Marcar como anomalía para revisión administrativa
- **A2 — Estudiante no matriculado:**
  - Usuario no encuentra al estudiante en la lista del curso
  - Sistema ofrece opciones: verificar matriculación, contactar coordinador
  - Permite marcar página como "estudiante no encontrado" para escalación
- **A3 — Calidad de imagen insuficiente:**
  - Usuario no puede identificar información legible en la página
  - Sistema ofrece opciones: solicitar recaptura, marcar para descarte
  - Permite agregar notas explicativas para auditoría
- **A4 — Página en blanco o dañada:**
  - Usuario identifica que la página no contiene respuestas válidas
  - Sistema permite marcar como "página inválida" con justificación
  - Registra el descarte para métricas de calidad
- **A5 — Múltiples estudiantes en una página:**
  - Usuario detecta que una página contiene respuestas de varios estudiantes
  - Sistema requiere identificación de cada sección por separado
  - Permite dividir página en múltiples resultados de ingesta
- **A6 — Información contradictoria:**
  - QR indica un estudiante pero escritura sugiere otro
  - Sistema presenta ambas opciones con evidencia visual
  - Usuario debe resolver conflicto con justificación detallada

### Reglas de negocio
- **RN-1:** Solo usuarios con permisos sobre el curso pueden resolver identidades.
- **RN-2:** Toda identificación manual debe incluir justificación del usuario.
- **RN-3:** Si un estudiante ya tiene respuestas, requiere aprobación de supervisor.
- **RN-4:** Las páginas resueltas manualmente se marcan con flag especial.
- **RN-5:** El sistema debe mantener trazabilidad de quién resolvió cada identidad.
- **RN-6:** Páginas marcadas como inválidas no procesan al posting.

### Datos principales
- **Resultado de Ingesta** (identificador, estudiante resuelto, anomalías, estado, método resolución)
- **Resolución Manual** (resultado ingesta, usuario resolvedor, estudiante asignado, justificación, timestamp)
- **Lista de Estudiantes** (identificador, nombre, matrícula, curso, foto, activo)
- **Conflicto de Identidad** (página, estudiante sugerido automático, estudiante asignado manual, razón)
- **Página Inválida** (página escaneada, marcada inválida, razón descarte, usuario que descartó)

### Consideraciones de seguridad/permiso
- **Autorización granular:** Solo acceso a lotes del curso del usuario.
- **Auditoría completa:** Registro de todas las decisiones de identificación.
- **Validación de integridad:** Prevención de duplicados y inconsistencias.
- **Justificación obligatoria:** Documentación del razonamiento para cambios.
- **Supervisión:** Alertas automáticas para resoluciones problemáticas.

### No funcionales
- **Rendimiento:** 
  - Carga de imagen en alta resolución < 2s p95
  - Búsqueda de estudiantes < 500ms p95
- **Usabilidad:** 
  - Interfaz intuitiva con herramientas visuales claras
  - Navegación eficiente entre páginas pendientes
- **Precisión:** 
  - Herramientas de zoom hasta 400% sin pérdida de calidad
  - Lista de estudiantes siempre actualizada
- **Productividad:** 
  - Resolución promedio < 30s por página
  - Shortcuts de teclado para acciones frecuentes

### Criterios de aceptación (QA)
- **CA-1:** Usuario debe poder ver imagen completa con herramientas de zoom y rotación.
- **CA-2:** Búsqueda de estudiantes debe funcionar por nombre parcial e ID completo.
- **CA-3:** Sistema debe prevenir duplicados y mostrar advertencias claras.
- **CA-4:** Identificaciones manuales deben quedar registradas con usuario y timestamp.
- **CA-5:** Páginas resueltas deben proceder automáticamente al posting si no hay otros bloqueos.
- **CA-6:** Justificaciones deben ser obligatorias para casos conflictivos.
- **CA-7:** Navegación entre páginas pendientes debe ser fluida y mantener progreso.

---

## Anexo Técnico (para desarrollo)

> Esta sección contiene los detalles técnicos de implementación del sistema de resolución manual de identidades según el modelo de datos del sistema de Ingesta Móvil.

### Resumen del modelo de datos

#### Entidades principales involucradas
- **`ingest_results`**: Resultados de ingesta con `resolved_student_fk` null que requieren identificación manual.
- **`scanned_pages`**: Páginas escaneadas con imágenes para visualización durante resolución.
- **`page_qrs`**: Códigos QR detectados que pueden contener pistas de identidad.
- **`students`**: Lista de estudiantes matriculados disponibles para matching.
- **`enrollments`**: Matriculaciones activas para validar pertenencia al curso.
- **`manual_resolutions`**: Registro de identificaciones manuales con auditoría.
- **`identity_conflicts`**: Registro de conflictos entre identificación automática y manual.

#### Relaciones clave
- Los **resultados de ingesta** sin estudiante resuelto se presentan para identificación manual.
- Los **estudiantes matriculados** en el curso de la evaluación son candidatos válidos.
- Las **resoluciones manuales** crean vínculo auditable entre página y estudiante.
- Los **conflictos de identidad** documentan discrepancias para análisis posterior.

#### Campos críticos para este caso de uso
**En `ingest_results`:**
- `resolved_student_fk` (null para casos pendientes), `anomalies` (razones de falla automática)
- `state` ('Ready' → 'Posted' después de resolución), `scanned_page_fk`

**En `manual_resolutions`:**
- `ingest_result_fk`, `resolved_by_fk`, `assigned_student_fk`
- `justification`, `resolution_method`, `resolved_at`

**En `students` y `enrollments`:**
- `identifier`, `full_name`, `photo_url` para presentación en interfaz
- `course_fk`, `active` para validación de elegibilidad

#### Arquitectura de Resolución
El sistema usa **interfaces web responsivas** con **carga lazy de imágenes**, **búsqueda con debouncing**, y **validación en tiempo real** de conflictos.

### Validaciones implementadas en base de datos

**Consultar páginas pendientes de identificación:**
```sql
SELECT 
    ir.ingest_result_id,
    ir.scanned_page_fk,
    sp.image_uri,
    sp.captured_at,
    e.title as evaluation_name,
    c.name as course_name,
    ir.anomalies->'student_resolution'->>'status' as failure_reason,
    pqr.student_identifier as qr_student_hint
FROM ingest_results ir
JOIN scanned_pages sp ON ir.scanned_page_fk = sp.scanned_page_id
JOIN ingest_batches ib ON sp.ingest_batch_fk = ib.ingest_batch_id
JOIN evaluations e ON ib.evaluation_fk = e.evaluation_id
JOIN courses c ON e.course_fk = c.course_id
LEFT JOIN page_qrs pqr ON sp.scanned_page_id = pqr.scanned_page_fk
WHERE ir.resolved_student_fk IS NULL
AND ir.state = 'Ready'
AND c.course_id IN (
    -- Cursos donde el usuario tiene permisos
    SELECT course_id FROM user_course_permissions 
    WHERE user_fk = :user_id AND can_grade = true
)
ORDER BY sp.captured_at DESC;
```

**Búsqueda de estudiantes matriculados:**
```sql
-- Búsqueda por nombre parcial
SELECT s.student_id, s.identifier, s.full_name, s.email, s.photo_url
FROM students s
JOIN enrollments en ON s.student_id = en.student_fk
WHERE en.course_fk = :course_id
AND en.active = true
AND (
    LOWER(s.full_name) LIKE LOWER('%' || :search_term || '%')
    OR s.identifier ILIKE '%' || :search_term || '%'
)
ORDER BY s.full_name;

-- Búsqueda por ID exacto
SELECT s.student_id, s.identifier, s.full_name, s.email, s.photo_url
FROM students s
JOIN enrollments en ON s.student_id = en.student_fk
WHERE en.course_fk = :course_id
AND en.active = true
AND s.identifier = :student_id;
```

**Validar conflictos potenciales:**
```sql
-- Verificar si estudiante ya tiene respuestas para esta evaluación
SELECT se.student_evaluation_id, se.total_score, se.finished_at
FROM student_evaluations se
WHERE se.evaluation_fk = :evaluation_id
AND se.student_fk = :proposed_student_id;

-- Verificar respuestas específicas por pregunta
SELECT sa.student_answer_id, eq.question_text, sa.points_earned
FROM student_answers sa
JOIN student_evaluations se ON sa.student_evaluation_fk = se.student_evaluation_id
JOIN evaluation_questions eq ON sa.evaluation_question_fk = eq.evaluation_question_id
WHERE se.evaluation_fk = :evaluation_id
AND se.student_fk = :proposed_student_id;
```

### Ejemplo de implementación de resolución manual

```sql
-- PASO 1: Registrar resolución manual
INSERT INTO manual_resolutions (
    ingest_result_fk, resolved_by_fk, assigned_student_fk,
    justification, resolution_method, resolved_at
) VALUES (
    :result_id, :user_id, :student_id,
    :justification, :method, NOW()
) RETURNING manual_resolution_id;

-- PASO 2: Actualizar resultado de ingesta
UPDATE ingest_results 
SET 
    resolved_student_fk = :student_id,
    anomalies = jsonb_set(
        COALESCE(anomalies, '{}'),
        '{manual_resolution}',
        jsonb_build_object(
            'resolved_by', :user_id,
            'resolved_at', NOW()::text,
            'method', :method,
            'justification', :justification
        )
    )
WHERE ingest_result_id = :result_id;

-- PASO 3: Registrar conflicto si había identificación automática previa
INSERT INTO identity_conflicts (
    scanned_page_fk, automatic_suggestion, manual_assignment,
    conflict_type, resolved_by_fk, resolved_at, notes
)
SELECT 
    :page_id, 
    (anomalies->'student_resolution'->>'suggested_student_id')::BIGINT,
    :student_id,
    'qr_vs_manual',
    :user_id,
    NOW(),
    :justification
FROM ingest_results 
WHERE ingest_result_id = :result_id
AND anomalies->'student_resolution'->>'suggested_student_id' IS NOT NULL
AND (anomalies->'student_resolution'->>'suggested_student_id')::BIGINT != :student_id;
```

### Interfaz web para resolución

**Endpoint para cargar página pendiente:**
```javascript
// GET /api/manual-resolution/batches/:batchId/pending-pages
app.get('/api/manual-resolution/batches/:batchId/pending-pages', async (req, res) => {
    const { batchId } = req.params;
    const userId = req.user.id;
    
    // Validar permisos sobre el lote
    const hasAccess = await validateBatchAccess(userId, batchId);
    if (!hasAccess) {
        return res.status(403).json({ error: 'Access denied' });
    }
    
    const pendingPages = await getPendingPagesForResolution(batchId);
    const courseStudents = await getCourseStudents(pendingPages[0]?.courseId);
    
    res.json({
        pendingPages: pendingPages,
        availableStudents: courseStudents,
        totalPending: pendingPages.length
    });
});

// POST /api/manual-resolution/resolve-identity
app.post('/api/manual-resolution/resolve-identity', async (req, res) => {
    const { resultId, studentId, justification, method } = req.body;
    const userId = req.user.id;
    
    try {
        // Validar que usuario tiene permisos sobre este resultado
        const result = await getIngestResultWithPermissionCheck(resultId, userId);
        if (!result) {
            return res.status(404).json({ error: 'Result not found' });
        }
        
        // Verificar conflictos potenciales
        const conflicts = await checkResolutionConflicts(resultId, studentId);
        if (conflicts.hasConflicts && !req.body.forceResolve) {
            return res.status(409).json({
                error: 'Conflicts detected',
                conflicts: conflicts.details,
                requiresConfirmation: true
            });
        }
        
        // Ejecutar resolución
        const resolution = await resolveIdentityManually({
            resultId,
            studentId,
            userId,
            justification,
            method
        });
        
        res.json({
            success: true,
            resolutionId: resolution.id,
            message: 'Identity resolved successfully'
        });
        
    } catch (error) {
        res.status(500).json({ error: 'Resolution failed' });
    }
});
```

### Herramientas de análisis y mejora

**Métricas de calidad de identificación automática:**
```sql
-- Calcular tasa de éxito de identificación automática
SELECT 
    DATE_TRUNC('week', sp.captured_at) as week,
    COUNT(*) as total_pages,
    COUNT(ir.resolved_student_fk) as auto_identified,
    COUNT(mr.manual_resolution_id) as manually_resolved,
    ROUND(
        COUNT(ir.resolved_student_fk) * 100.0 / COUNT(*), 2
    ) as auto_success_rate
FROM scanned_pages sp
JOIN ingest_results ir ON sp.scanned_page_id = ir.scanned_page_fk
LEFT JOIN manual_resolutions mr ON ir.ingest_result_id = mr.ingest_result_fk
WHERE sp.captured_at >= NOW() - INTERVAL '30 days'
GROUP BY DATE_TRUNC('week', sp.captured_at)
ORDER BY week DESC;
```

**Análisis de patrones de falla:**
```sql
-- Identificar razones más comunes de falla automática
SELECT 
    anomalies->'student_resolution'->>'status' as failure_reason,
    COUNT(*) as occurrences,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
FROM ingest_results
WHERE resolved_student_fk IS NULL
AND anomalies->'student_resolution'->>'status' IS NOT NULL
GROUP BY anomalies->'student_resolution'->>'status'
ORDER BY occurrences DESC;
```

### Optimizaciones de performance

**Índices para búsqueda rápida:**
```sql
-- Índice para búsqueda de estudiantes
CREATE INDEX idx_students_name_search ON students 
USING gin(to_tsvector('spanish', full_name));

-- Índice para páginas pendientes
CREATE INDEX idx_ingest_results_pending ON ingest_results 
(resolved_student_fk, state) 
WHERE resolved_student_fk IS NULL;

-- Índice para conflictos
CREATE INDEX idx_manual_resolutions_result ON manual_resolutions (ingest_result_fk);
```

**Caché de datos frecuentes:**
```javascript
// Cache de estudiantes por curso (renovación cada hora)
const courseStudentsCache = new Map();

async function getCachedCourseStudents(courseId) {
    const cacheKey = `course_students_${courseId}`;
    
    if (courseStudentsCache.has(cacheKey)) {
        const cached = courseStudentsCache.get(cacheKey);
        if (Date.now() - cached.timestamp < 3600000) { // 1 hora
            return cached.data;
        }
    }
    
    const students = await db.query(`
        SELECT s.student_id, s.identifier, s.full_name, s.photo_url
        FROM students s
        JOIN enrollments e ON s.student_id = e.student_fk
        WHERE e.course_fk = $1 AND e.active = true
        ORDER BY s.full_name
    `, [courseId]);
    
    courseStudentsCache.set(cacheKey, {
        data: students.rows,
        timestamp: Date.now()
    });
    
    return students.rows;
}
```

### Referencias al modelo completo
Para más detalles sobre la estructura completa, restricciones, tipos de datos y triggers:
- [Modelo Entidad-Relación completo](../../../../06-data-model/mobile-ingest/mer.md)
- [Script DDL de creación](../../../../06-data-model/mobile-ingest/DDL.sql)
- [Triggers y funciones](../../../../06-data-model/mobile-ingest/TRIGGERS.sql)

---

[Subir](#cu-im-08--resolución-manual-de-identidades)
