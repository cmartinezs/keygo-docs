# RNF7 — Observabilidad

**Descripción (alto nivel)**  
GRADE debe ofrecer **visibilidad completa** de su operación, permitiendo detectar, diagnosticar y resolver problemas rápidamente mediante métricas, logs y trazas accesibles.

**Alcance incluye**
- **Métricas clave**: número de evaluaciones procesadas, tiempos promedio de calificación, tasas de error en OCR/ingesta.
- **Logs estructurados** para todas las acciones críticas, con niveles (info, warning, error).
- **Trazas distribuidas** para identificar cuellos de botella en flujos complejos (ej. ingesta → calificación → publicación).
- **Dashboards básicos** accesibles a Administradores para monitoreo del estado.
- **Alertas automáticas** ante fallos críticos o métricas fuera de umbral.
- Retención de logs y métricas durante un período definido (ej. ≥90 días).

**No incluye (MVP)**
- Integración con sistemas corporativos de monitoreo (ej. Datadog, Prometheus externos).
- Machine learning para predicción de fallos.

**Dependencias**
- RF4 (Ingesta de respuestas).
- RF5 (Calificación automática).
- RF9 (Paneles operativos).
- RNF4 (Disponibilidad y resiliencia).

**Criterios de aceptación (CA)**
1. El sistema expone métricas básicas (tiempos, errores, cargas) accesibles en un panel.
2. Se generan **logs estructurados** para eventos críticos y errores.
3. Los procesos de ingesta y calificación cuentan con **trazabilidad completa** de punta a punta.
4. Los administradores reciben **alertas automáticas** en caso de fallos críticos.
5. Los logs y métricas se almacenan al menos **90 días** para análisis posterior.
6. Toda la información de observabilidad respeta las políticas de privacidad definidas en RNF2.

**Riesgos/mitigaciones**
- Exceso de datos de observabilidad → retención definida y filtrado de logs.
- Pérdida de visibilidad → monitoreo redundante y alertas.
- Acceso indebido a logs sensibles → controles de acceso y anonimización.
