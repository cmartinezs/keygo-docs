# CU-BP-15 — Consultar analítica avanzada de ítems

> Este caso de uso detalla el acceso a métricas pedagógicas y psicométricas específicas de los ítems del Banco de Preguntas, basado en el escenario S-BP-08 | Analítica básica de ítems.

- [Revisión](reviews.md)
- [Volver](../../README.md#1-banco-de-preguntas)

<!-- TOC -->
* [CU-BP-15 — Consultar analítica avanzada de ítems](#cu-bp-15--consultar-analítica-avanzada-de-ítems)
  * [Escenario origen: S-BP-08 | Analítica básica de ítems](#escenario-origen-s-bp-08--analítica-básica-de-ítems)
    * [RF relacionados: RF10](#rf-relacionados-rf10)
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
    * [Métricas psicométricas calculadas](#métricas-psicométricas-calculadas)
    * [Análisis por taxonomía curricular](#análisis-por-taxonomía-curricular)
    * [Alertas y recomendaciones automáticas](#alertas-y-recomendaciones-automáticas)
    * [Consideraciones de implementación](#consideraciones-de-implementación)
<!-- TOC -->

## Escenario origen: S-BP-08 | Analítica básica de ítems

### RF relacionados: RF10

**Actor principal:** Coordinador / Administrador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Coordinador o Administrador acceda a métricas pedagógicas y psicométricas específicas de los ítems, organizadas por la jerarquía curricular **Asignatura > Unidad > Tema**, para tomar decisiones fundamentadas sobre mantenimiento, ajuste o retiro de preguntas del banco.

### Precondiciones
- Usuario autenticado con permisos de análisis (Coordinador o Administrador).
- Ítems con historial de uso en evaluaciones aplicadas y calificadas.
- Evaluaciones en estado "Graded" con respuestas de estudiantes registradas.
- Al menos 10 respuestas por ítem para cálculos estadísticos confiables.

### Postcondiciones
- El sistema muestra métricas psicométricas detalladas por ítem y agregadas por taxonomía.
- Se generan alertas automáticas para ítems problemáticos.
- Los datos están disponibles para exportación y toma de decisiones.
- Se registra el acceso a la analítica para auditoría.

### Flujo principal (éxito)
1. El Coordinador accede al módulo **"Analítica de Ítems"**.
2. El Sistema presenta el dashboard con filtros por:
   - Asignatura, Unidad, Tema
   - Rango de fechas de evaluaciones
   - Estado del ítem (Activo/Inactivo)
   - Umbral mínimo de respuestas
3. El Coordinador selecciona filtros y ejecuta consulta.
4. El Sistema calcula y presenta métricas en tiempo real:
   - **Panel General:** Resumen de ítems analizados y alertas
   - **Métricas por Ítem:** Tabla detallada con indicadores específicos
   - **Análisis Agregado:** Estadísticas por taxonomía curricular
   - **Tendencias Temporales:** Gráficos de evolución
5. El Sistema destaca ítems con alertas automáticas (problemas detectados).
6. El Coordinador analiza resultados y puede:
   - Ver detalles específicos de cada ítem
   - Marcar ítems para revisión o retiro
   - Exportar reporte para equipo docente
   - Acceder a recomendaciones automáticas

### Flujos alternativos / Excepciones
- **A1 — Datos insuficientes:** El Sistema informa ítems con < 10 respuestas y sugiere esperar más evaluaciones.
- **A2 — Sin evaluaciones aplicadas:** El Sistema muestra mensaje indicativo y sugiere revisar ítems después de aplicar evaluaciones.
- **A3 — Filtros sin resultados:** El Sistema informa que no hay ítems que cumplan los criterios y sugiere ajustar filtros.
- **A4 — Error en cálculos:** El Sistema muestra error técnico y registra en logs para soporte.
- **A5 — Timeout en consulta:** Para análisis masivos, el Sistema ofrece generar reporte en segundo plano.

### Reglas de negocio
- **RN-1:** Solo se consideran evaluaciones en estado "Graded" para cálculos estadísticos.
- **RN-2:** Los cálculos se basan en datos agregados, nunca en respuestas individuales identificables.
- **RN-3:** Se requieren mínimo 10 respuestas para métricas confiables (configurable).
- **RN-4:** Las alertas automáticas se generan según umbrales pedagógicos predefinidos.
- **RN-5:** Los datos se actualizan automáticamente después de cada ciclo de calificación.
- **RN-6:** El acceso a métricas respeta la jerarquía de permisos por rol.

### Datos principales
- **Métricas por ítem** (`question_id`, `difficulty_index`, `discrimination_index`, `reliability_coefficient`, `distractor_analysis`, `usage_frequency`, `temporal_trend`)
- **Alertas generadas** (`alert_type`, `severity`, `description`, `recommendation`, `generated_at`)
- **Análisis agregado** (`taxonomy_level`, `taxonomy_id`, `avg_performance`, `item_count`, `trend_direction`)
- **Reporte de exportación** (`report_id`, `filters_applied`, `items_included`, `generated_by`, `export_format`)

### Consideraciones de seguridad/permiso
- **Coordinadores:** Acceso completo a ítems de sus áreas curriculares asignadas.
- **Administradores:** Acceso irrestricto a todas las métricas del sistema.
- **Docentes:** Acceso limitado solo a ítems de su autoría (si se habilita).
- **Datos anonimizados:** Todas las métricas se calculan sin identificación de estudiantes específicos.
- **Auditoría completa:** Se registra quién accede a qué métricas y cuándo.

### No funcionales
- **Rendimiento:** Cálculo de métricas < 10s para hasta 500 ítems; reportes masivos en segundo plano.
- **Usabilidad:** Dashboard intuitivo con visualizaciones claras y alertas destacadas.
- **Disponibilidad:** Acceso 24/7 con datos actualizados automáticamente post-calificación.
- **Escalabilidad:** Soporte para análisis de hasta 10,000 ítems con historial de 5 años.
- **Precisión:** Cálculos estadísticamente válidos según estándares psicométricos.

### Criterios de aceptación (QA)
- **CA-1:** El dashboard muestra correctamente las 6 métricas clave por ítem con valores precisos.
- **CA-2:** Las alertas automáticas se generan según umbrales configurados y destacan problemas reales.
- **CA-3:** Los filtros por taxonomía (Asignatura > Unidad > Tema) funcionan correctamente.
- **CA-4:** El análisis agregado muestra tendencias coherentes por área curricular.
- **CA-5:** Los ítems con datos insuficientes se identifican claramente con recomendaciones.
- **CA-6:** La exportación genera reportes utilizables para toma de decisiones pedagógicas.

---

## Anexo Técnico (para desarrollo)

> Especificaciones técnicas para implementar la analítica avanzada de ítems basada en el modelo de datos de evaluaciones y respuestas estudiantiles.

### Métricas psicométricas calculadas

**1. Índice de Dificultad (P-Value)**
```sql
-- Porcentaje de estudiantes que respondieron correctamente
WITH question_performance AS (
  SELECT 
    eq.question_fk,
    COUNT(sa.student_answer_id) as total_attempts,
    SUM(CASE WHEN sa.points_earned > 0 THEN 1 ELSE 0 END) as correct_answers
  FROM evaluation_questions eq
  JOIN student_answers sa ON eq.evaluation_question_id = sa.evaluation_question_fk
  JOIN student_evaluations se ON sa.student_evaluation_fk = se.student_evaluation_id
  JOIN evaluations e ON se.evaluation_fk = e.evaluation_id
  WHERE e.state = 'Graded'
  GROUP BY eq.question_fk
  HAVING COUNT(sa.student_answer_id) >= 10
)
SELECT 
  question_fk,
  total_attempts,
  ROUND(correct_answers::numeric / total_attempts, 3) as difficulty_index
FROM question_performance;
```

**2. Índice de Discriminación**
```sql
-- Diferencia entre grupo alto (27% superior) y grupo bajo (27% inferior)
WITH student_scores AS (
  SELECT 
    se.student_evaluation_id,
    se.total_score,
    NTILE(100) OVER (PARTITION BY se.evaluation_fk ORDER BY se.total_score DESC) as percentile
  FROM student_evaluations se
  JOIN evaluations e ON se.evaluation_fk = e.evaluation_id
  WHERE e.state = 'Graded'
),
discrimination_calc AS (
  SELECT 
    eq.question_fk,
    AVG(CASE WHEN ss.percentile <= 27 THEN 
        CASE WHEN sa.points_earned > 0 THEN 1.0 ELSE 0.0 END 
      END) as high_group_correct,
    AVG(CASE WHEN ss.percentile >= 73 THEN 
        CASE WHEN sa.points_earned > 0 THEN 1.0 ELSE 0.0 END 
      END) as low_group_correct
  FROM evaluation_questions eq
  JOIN student_answers sa ON eq.evaluation_question_id = sa.evaluation_question_fk
  JOIN student_scores ss ON sa.student_evaluation_fk = ss.student_evaluation_id
  GROUP BY eq.question_fk
)
SELECT 
  question_fk,
  ROUND(high_group_correct - low_group_correct, 3) as discrimination_index
FROM discrimination_calc;
```

**3. Análisis de Distractores**
```sql
-- Efectividad de cada opción incorrecta
SELECT 
  eo.evaluation_question_fk,
  eo.position as option_position,
  eo.text as option_text,
  eo.is_correct,
  COUNT(sao.student_answer_option_id) as selection_count,
  ROUND(
    COUNT(sao.student_answer_option_id)::numeric / 
    SUM(COUNT(sao.student_answer_option_id)) OVER (PARTITION BY eo.evaluation_question_fk), 
    3
  ) as selection_percentage
FROM evaluation_options eo
JOIN student_answer_options sao ON eo.evaluation_option_id = sao.evaluation_option_fk
JOIN student_answers sa ON sao.student_answer_fk = sa.student_answer_id
GROUP BY eo.evaluation_question_fk, eo.position, eo.text, eo.is_correct
ORDER BY eo.evaluation_question_fk, eo.position;
```

**4. Frecuencia de Uso**
```sql
-- Cantidad de evaluaciones donde se ha utilizado cada ítem
SELECT 
  eq.question_fk,
  COUNT(DISTINCT eq.evaluation_fk) as usage_count,
  MIN(e.scheduled_date) as first_used,
  MAX(e.scheduled_date) as last_used,
  SUM(COUNT(sa.student_answer_id)) OVER (PARTITION BY eq.question_fk) as total_student_responses
FROM evaluation_questions eq
JOIN evaluations e ON eq.evaluation_fk = e.evaluation_id
LEFT JOIN student_answers sa ON eq.evaluation_question_id = sa.evaluation_question_fk
WHERE e.state IN ('Applied', 'Graded')
GROUP BY eq.question_fk
ORDER BY usage_count DESC;
```

### Análisis por taxonomía curricular

**Rendimiento agregado por jerarquía:**
```sql
-- Métricas agregadas por Asignatura > Unidad > Tema
SELECT 
  s.subject_id, s.name as subject_name,
  u.unit_id, u.name as unit_name,
  t.topic_id, t.name as topic_name,
  COUNT(DISTINCT q.question_id) as total_items,
  AVG(perf.difficulty_index) as avg_difficulty,
  AVG(perf.discrimination_index) as avg_discrimination,
  COUNT(CASE WHEN perf.difficulty_index < 0.3 THEN 1 END) as hard_items,
  COUNT(CASE WHEN perf.difficulty_index > 0.8 THEN 1 END) as easy_items,
  COUNT(CASE WHEN perf.discrimination_index < 0.2 THEN 1 END) as low_discrimination_items
FROM subjects s
JOIN units u ON s.subject_id = u.subject_fk
JOIN topics t ON u.unit_id = t.unit_fk  
JOIN questions q ON t.topic_id = q.topic_fk
LEFT JOIN question_performance_view perf ON q.question_id = perf.question_id
WHERE q.active = TRUE
GROUP BY s.subject_id, s.name, u.unit_id, u.name, t.topic_id, t.name
ORDER BY s.name, u.name, t.name;
```

### Alertas y recomendaciones automáticas

**Umbrales para alertas:**
```sql
-- Generación automática de alertas basada en umbrales pedagógicos
WITH item_alerts AS (
  SELECT 
    question_id,
    CASE 
      WHEN difficulty_index > 0.95 THEN 'VERY_EASY'
      WHEN difficulty_index < 0.15 THEN 'VERY_HARD'  
      WHEN discrimination_index < 0.15 THEN 'POOR_DISCRIMINATION'
      WHEN usage_count > 10 THEN 'OVERUSED'
      WHEN total_responses < 10 THEN 'INSUFFICIENT_DATA'
    END as alert_type,
    CASE
      WHEN difficulty_index > 0.95 THEN 'Considerar reformular para mayor desafío'
      WHEN difficulty_index < 0.15 THEN 'Revisar enunciado y opciones, posible error'
      WHEN discrimination_index < 0.15 THEN 'Ítem no discrimina entre estudiantes con diferente habilidad'
      WHEN usage_count > 10 THEN 'Ítem sobreexpuesto, considerar rotación'
      WHEN total_responses < 10 THEN 'Datos insuficientes para análisis confiable'
    END as recommendation
  FROM question_performance_summary
  WHERE alert_type IS NOT NULL
)
SELECT * FROM item_alerts;
```

### Consideraciones de implementación

**Optimización de performance:**
- Vista materializada para métricas calculadas diariamente
- Índices específicos en tablas de respuestas por question_fk y evaluation_fk
- Cache de resultados frecuentes (últimos 30 días)

**Actualización automática:**
- Trigger post-calificación para recalcular métricas afectadas
- Job nocturno para actualización completa de vistas materializadas
- Invalidación de cache tras cambios en evaluaciones

**Dashboard interactivo:**
- Filtros dinámicos por taxonomía curricular
- Exportación a Excel/PDF con gráficos incluidos
- Alertas destacadas con colores y iconos
- Drill-down desde agregado hacia ítem específico

**API sugerida:**
```
GET /api/analytics/items?subject_id=1&unit_id=2     # Métricas filtradas
GET /api/analytics/items/:id/details                # Detalle de ítem específico  
GET /api/analytics/alerts?severity=high             # Alertas generadas
POST /api/analytics/export                          # Generar reporte
```

---

**Nota:** Esta analítica avanzada transforma datos de respuestas estudiantiles en inteligencia pedagógica accionable, permitiendo mejora continua del banco de preguntas basada en evidencia psicométrica sólida.

[Subir](#cu-bp-15--consultar-analítica-avanzada-de-ítems)
