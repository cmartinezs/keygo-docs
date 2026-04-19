# RF10 — Reportes pedagógicos básicos

**Descripción (alto nivel)**  
GRADE debe generar **reportes pedagógicos simples** que permitan a docentes y coordinadores obtener retroalimentación sobre el desempeño de los estudiantes y la calidad de los ítems utilizados en las evaluaciones.

**Alcance incluye**
- Reportes por evaluación con indicadores como:
    - Promedio, mediana y desviación estándar de notas.
    - Distribución de calificaciones en rangos.
    - Tasa de aciertos por ítem.
    - Índice de dificultad por pregunta.
- Visualización de resultados a nivel de evaluación y exportación a PDF/CSV.
- Acceso diferenciado por rol:
    - Docentes → reportes detallados de sus evaluaciones.
    - Coordinadores → estadísticas agregadas sin acceso a respuestas individuales.
    - Administradores → acceso global a reportes para supervisión.
- Registro en auditoría de la **generación y consulta** de reportes.

**No incluye (MVP)**
- Analítica avanzada (ej. correlaciones históricas, dashboards predictivos, análisis comparativos entre cursos).
- Reportes personalizados por usuario final (se definen plantillas comunes).
- Visualizaciones interactivas avanzadas (se limita a tablas y gráficos básicos).

**Dependencias**
- RF5 (Calificación automática).
- RF6 (Publicación y consulta de resultados).
- RF7 (Roles y permisos).
- RF8 (Auditoría).

**Criterios de aceptación (CA)**
1. El sistema genera **reportes básicos** con métricas pedagógicas tras calificar una evaluación.
2. Los reportes pueden **exportarse** en CSV y PDF.
3. Los roles aplican correctamente: coordinadores solo ven estadísticas agregadas.
4. Cada reporte queda **registrado en auditoría** con usuario y fecha.
5. Los indicadores (promedio, distribución, dificultad de ítems) se calculan de manera correcta y consistente.
6. El docente puede **consultar en línea** los resultados sin necesidad de exportar.

**Riesgos/mitigaciones**
- Interpretación incorrecta de métricas → documentación de indicadores en la interfaz.
- Acceso indebido a datos individuales → control estricto de permisos por rol.
- Carga de procesamiento elevada → generación asincrónica y exportación bajo demanda.

---

[< Anterior](rf09-operational-dashboards-and-metrics.md) | [Inicio](../README.md#requerimientos-funcionales) | [Siguiente >](rf11-milestone-notifications.md)