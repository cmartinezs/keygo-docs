# RF8 — Auditoría y trazabilidad

**Descripción (alto nivel)**  
GRADE debe registrar de manera **detallada y confiable** todas las acciones críticas realizadas en el sistema, permitiendo trazabilidad completa y revisiones posteriores para garantizar seguridad, integridad y cumplimiento.

**Alcance incluye**
- Registro de **eventos clave**: creación, edición y eliminación de ítems, evaluaciones y usuarios.
- Registro de acciones en el ciclo de evaluación (creación, distribución, ingesta de respuestas, calificación, publicación).
- Almacenamiento de **quién, cuándo y qué** hizo cada usuario.
- Conservación de logs de auditoría en un repositorio seguro e inmutable.
- Acceso a los registros de auditoría solo para roles autorizados (Administrador).
- Posibilidad de **filtrar y consultar eventos** por usuario, fecha, tipo de acción o entidad afectada.

**No incluye (MVP)**
- Herramientas de auditoría avanzada con visualización gráfica.
- Integración con sistemas externos de cumplimiento normativo (ej. SIEM corporativos).

**Dependencias**
- RF1 (Ciclo centralizado de evaluación).
- RF2 (Banco de preguntas).
- RF6 (Publicación de resultados).
- RF7 (Roles y permisos).

**Criterios de aceptación (CA)**
1. El sistema registra toda acción relevante con **usuario, fecha/hora y acción realizada**.
2. Es posible **consultar logs de auditoría** por filtros básicos (usuario, fecha, acción).
3. Los registros de auditoría no pueden ser **alterados ni eliminados** por usuarios comunes.
4. Solo el Administrador accede a la **auditoría completa**, los demás roles solo ven la información permitida.
5. Toda modificación de parámetros globales, banco o evaluaciones queda auditada.
6. Los registros de auditoría son **exportables** en formatos estándar (CSV, JSON).

**Riesgos/mitigaciones**
- Riesgo de pérdida de logs → almacenamiento redundante y respaldos periódicos.
- Manipulación de auditoría → repositorio inmutable y accesos restringidos.
- Sobrecarga por exceso de logs → retención configurada y archivado histórico.

---

[< Anterior](rf07-roles-and-permissions.md) | [Inicio](../README.md#requerimientos-funcionales) | [Siguiente >](rf09-operational-dashboards-and-metrics.md)