# Apreciación CU-GE-19 — Enviar notificaciones de hitos

- [Volver](../../README.md#2-gestión-de-evaluación)

### Qué cubre
- Envío de notificaciones in-app (y futuros canales) sobre eventos clave.
- Tipos mínimos de hitos: finalización de calificación automática, publicación de resultados y errores de ingesta.
- Registro de notificaciones en auditoría con trazabilidad de envío y apertura.

### Escenario lo justifica
- En S-GE-13, Rodrigo necesita estar al tanto de eventos sin revisar manualmente el sistema.
- El sistema envía notificaciones cuando ocurren hitos clave, facilitando la reacción oportuna del docente.

### ¿Es suficiente como CU separado?
✅ Sí. El envío de notificaciones es un proceso independiente, automatizado y con reglas específicas.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Posibles evolutivos: envío por correo electrónico, integración con LMS externos, notificaciones push móviles.

### Apreciación final
El CU-GE-19 está correctamente definido y suficiente para cubrir la necesidad de **notificaciones de hitos clave** en S-GE-13.

---

# Apreciación CU-GE-20 — Configurar preferencias de notificación

### Qué cubre
- Configuración por usuario de hitos que desea recibir.
- Selección de canales (in-app, futuros: email, integraciones).
- Posibilidad de establecer horarios silenciosos y reglas de prioridad.

### Escenario lo justifica
- En S-GE-13 se plantea la necesidad de flexibilidad: no todos los docentes querrán la misma cantidad de notificaciones.
- Permitir que el usuario gestione preferencias mejora la experiencia y evita sobrecarga informativa.

### ¿Es suficiente como CU separado?
✅ Sí. La configuración de notificaciones es un proceso distinto del envío y requiere su propio flujo y reglas de negocio.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Evolutivos posibles: perfiles predefinidos por institución, herencia de configuraciones, sincronización con sistemas externos.

### Apreciación final
El CU-GE-20 está bien definido y suficiente para cubrir la **personalización de notificaciones** en S-GE-13.  
