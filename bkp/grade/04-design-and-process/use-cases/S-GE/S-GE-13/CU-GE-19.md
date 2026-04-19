# CU-GE-19 — Enviar notificaciones de hitos

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-13 | Notificar hitos

### RF relacionados: RF11

**Actor principal:** Sistema GRADE  
**Actores secundarios:** Docente, Coordinador, Administrador

---

### Objetivo
Enviar notificaciones oportunas a los usuarios correspondientes cuando ocurren hitos clave del ciclo de evaluación (p. ej., finalización de calificación, publicación de resultados, errores de ingesta).

### Precondiciones
- Existe al menos una evaluación en curso con eventos susceptibles de notificación (calificación, publicación, ingesta).
- El usuario destinatario tiene una cuenta activa y permisos sobre el curso/evaluación.
- Preferencias de notificación por defecto o configuradas (si aplica).

### Postcondiciones
- La notificación queda registrada como enviada (y, si aplica, entregada/leída).
- El usuario destinatario puede acceder al detalle del evento desde la notificación.
- El evento queda auditado (quién/qué/cuándo).

### Flujo principal (éxito)
1. Se produce un hito en el sistema (p. ej., **Calificación automática completada**).
2. El Sistema determina destinatarios según rol y pertenencia (Docente/Coordinador del curso).
3. El Sistema construye el mensaje con contexto (evaluación, curso, fecha, acción posible).
4. El Sistema envía **notificación in-app** (y otros canales si están habilitados en el futuro).
5. El Sistema registra envío (timestamp, canal, destinatarios).
6. El Usuario abre la notificación y accede al detalle del evento.

### Flujos alternativos / Excepciones
- **A1 — Sin destinatarios válidos:** El Sistema registra incidente y no envía la notificación.
- **A2 — Error de envío de canal:** El Sistema reintenta y, si falla, marca como *pendiente* y registra en auditoría.
- **A3 — Preferencias del usuario deshabilitan el canal:** El Sistema omite el canal deshabilitado y utiliza los permitidos.

### Reglas de negocio
- **RN-1:** Solo se notifica a usuarios con permisos sobre la evaluación/curso.
- **RN-2:** Las notificaciones deben incluir un enlace profundo al evento (deep-link).
- **RN-3:** Tipos mínimos de hitos a notificar (MVP):
    - Finalización de **Calificación automática**.
    - **Publicación de resultados**.
    - **Errores de ingesta** (CSV/OCR).

### Datos principales
- **Notificación**(ID, tipo de hito, evaluación, curso, destinatarios, canal, estado envío, timestamps).
- **Preferencias**(usuario, canales permitidos, silenciado sí/no, horario silencioso).
- **Auditoría**(evento origen, envío, reintentos, apertura).

### Consideraciones de seguridad/permiso
- Validar acceso del destinatario al recurso notificado.
- No exponer datos personales de estudiantes en el contenido de la notificación; mostrar solo agregados o IDs internos.

### No funcionales
- **Latencia:** envío en < 10 s desde el hito p95.
- **Disponibilidad:** reintentos automáticos ante fallas de canal.
- **Observabilidad:** métricas de entrega y apertura.

### Criterios de aceptación (QA)
- **CA-1:** Al finalizar la calificación, el Docente recibe notificación in-app con acceso al resultado.
- **CA-2:** Ante error de ingesta, el Docente recibe notificación con resumen y acceso al reporte de errores.
- **CA-3:** Al publicar resultados, los Coordinadores reciben vista agregada (sin datos individuales).
- **CA-4:** Todas las notificaciones quedan registradas en auditoría con estado de envío.
