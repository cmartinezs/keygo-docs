# RF9 — Paneles operativos y métricas

**Descripción (alto nivel)**  
GRADE debe ofrecer **paneles de monitoreo** que permitan a los usuarios autorizados (principalmente Administradores) supervisar el estado del sistema y obtener métricas operativas clave, para facilitar decisiones y reducir la carga de soporte.

**Alcance incluye**
- Dashboard con métricas generales del sistema:
    - Nº de evaluaciones creadas, aplicadas y calificadas.
    - Tiempo medio de calificación.
    - Tasa de error en procesos de ingesta (OCR/foto/CSV).
    - Uso del banco de preguntas (ítems nuevos vs. reutilizados).
- Indicadores de **estado y salud del sistema** (ej. colas de procesamiento activas, servicios disponibles).
- Alertas básicas ante fallos (ej. error en carga de respuestas, tiempos de procesamiento excedidos).
- Visualización accesible solo para roles con permisos adecuados (Administrador principalmente).
- Exportación de métricas en formato CSV/JSON para análisis adicional.

**No incluye (MVP)**
- Analítica predictiva o avanzada (ej. IA para detectar patrones).
- Visualización gráfica compleja estilo BI (se limita a dashboards básicos).
- Integraciones con herramientas externas de monitoreo corporativo.

**Dependencias**
- RF1 (Ciclo centralizado de evaluación).
- RF4 (Ingesta de respuestas).
- RF5 (Calificación automática).
- RF8 (Auditoría).

**Criterios de aceptación (CA)**
1. El sistema muestra un **dashboard con métricas clave** (evaluaciones, tiempos, errores).
2. Los administradores pueden **visualizar alertas** en caso de fallos críticos.
3. Los datos del dashboard se **actualizan en tiempo cercano al real**.
4. Las métricas son **exportables** en CSV/JSON.
5. Solo roles autorizados (Administrador) acceden a los paneles completos.
6. La interfaz de panel es **clara y usable** para facilitar decisiones rápidas.

**Riesgos/mitigaciones**
- Exceso de métricas → definición clara de KPIs mínimos.
- Sobrecarga por actualización constante → actualización periódica (intervalos configurables).
- Acceso indebido → restricción de paneles a roles autorizados.

---

[< Anterior](rf08-audit-and-traceability.md) | [Inicio](../README.md#requerimientos-funcionales) | [Siguiente >](rf10-basic-pedagogical-reports.md)