# RF11 — Notificaciones de hitos

**Descripción (alto nivel)**  
GRADE debe notificar a los usuarios sobre los **eventos relevantes** del ciclo de vida de las evaluaciones, asegurando que docentes y administradores estén informados de avances, resultados o fallos sin necesidad de monitoreo constante.

**Alcance incluye**
- Notificaciones cuando:
    - Se crea o publica una nueva evaluación.
    - Se procesan cargas de respuestas (OCR/foto/CSV).
    - Finaliza el proceso de calificación automática.
    - Los resultados están disponibles para consulta.
    - Se produce un fallo en la carga o calificación.
- Canales de notificación:
    - **In-app** (dentro de la interfaz de GRADE).
    - **Correo electrónico** para eventos críticos (fallos, disponibilidad de resultados).
- Configuración básica de preferencias por usuario (activar/desactivar notificaciones por email).
- Registro en la auditoría de todas las notificaciones emitidas.

**No incluye (MVP)**
- Notificaciones push en dispositivos móviles.
- Integraciones con herramientas externas de mensajería (ej. Slack, Teams).
- Configuración avanzada de reglas de notificación.

**Dependencias**
- RF1 (Ciclo de evaluación centralizado).
- RF4 (Ingesta de respuestas).
- RF5 (Calificación automática).
- RF6 (Publicación de resultados).
- RF8 (Auditoría).

**Criterios de aceptación (CA)**
1. El docente recibe una **notificación en la aplicación** cuando finaliza la calificación de una evaluación.
2. Se envía un **correo electrónico** al docente si ocurre un fallo en la carga de respuestas.
3. Los resultados disponibles generan una notificación automática.
4. Todas las notificaciones quedan **registradas en la auditoría**.
5. El usuario puede ajustar si desea recibir notificaciones por email.
6. Los administradores reciben notificaciones en caso de **errores críticos** en el sistema.

**Riesgos/mitigaciones**
- Sobrecarga de notificaciones → limitar a hitos relevantes y permitir configurar preferencias.
- Pérdida de correos → sistema de reintentos y logs de entrega.
- Falta de claridad en mensajes → plantillas de notificación con información precisa y estandarizada.

---

[< Anterior](rf10-basic-pedagogical-reports.md) | [Inicio](../README.md#requerimientos-funcionales) | [Siguiente >](rf12-external-systems-integration.md)