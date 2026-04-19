# RF12 — Integración con sistemas externos

**Descripción (alto nivel)**  
GRADE debe permitir que aplicaciones externas se **integren con el sistema** para:
- Crear evaluaciones.
- Enviar respuestas de estudiantes.
- Consultar resultados y estadísticas.

**Alcance incluye**
- Integración con aplicaciones del ecosistema Wanku u otros sistemas autorizados.
- Disponibilidad de puntos de entrada que permitan realizar las operaciones funcionales clave.
- Registro de toda interacción externa en el historial del sistema.

**No incluye (MVP)**
- Integraciones institucionales complejas (SIS, SSO corporativo, pasarelas de pago).
- Adaptadores dedicados a plataformas externas específicas (ej. Moodle, Canvas).

**Dependencias**
- RF1 (Ciclo de evaluación centralizado).
- RF4 (Ingesta de respuestas).
- RF6 (Publicación de resultados).
- RF8 (Auditoría).
- RF11 (Notificaciones).

**Criterios de aceptación (CA)**
1. Una aplicación externa puede **crear una evaluación** de forma controlada.
2. Una aplicación externa puede **enviar respuestas** y asociarlas a una evaluación existente.
3. Una aplicación externa puede **consultar resultados** de evaluaciones a las que tiene permiso de acceso.
4. Todas las integraciones externas quedan **registradas en auditoría**.
5. Los accesos se restringen según permisos definidos.

**Riesgos/mitigaciones**
- Accesos indebidos → control estricto de permisos y autenticación.
- Fallos en integración → documentación y entornos de prueba para terceros.
- Sobrecarga de solicitudes externas → límites de uso definidos (rate limiting).

---

[< Anterior](rf11-milestone-notifications.md) | [Inicio](../README.md#requerimientos-funcionales) | [Siguiente >](rf13-system-administration.md)