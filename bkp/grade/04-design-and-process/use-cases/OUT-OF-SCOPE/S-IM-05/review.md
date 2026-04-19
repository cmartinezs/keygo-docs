# Apreciación CU-IM-05 — Modo sin conexión y reintentos

- [Volver](../../README.md#3-ingesta-móvil)

### Qué cubre
- Captura y almacenamiento local de hojas de respuesta cuando no hay conexión.
- Gestión de lotes en estado “pendiente de envío”.
- Reenvío automático al detectar conectividad estable.
- Reintentos manuales en caso de fallo.
- Manejo de excepciones como almacenamiento insuficiente o desconexión intermitente.

### Escenario lo justifica
- En S-IM-05, María Fernanda como Docente necesita seguir trabajando incluso sin internet disponible.
- Evita la pérdida de datos en entornos con conectividad limitada.
- Brinda tranquilidad al docente, ya que el sistema garantiza que los datos se enviarán apenas haya red.

### ¿Es suficiente como CU separado?
✅ Sí. El manejo offline implica reglas de negocio, seguridad y confiabilidad propias.
- Requiere persistencia local, cifrado, políticas de reintento y validación de integridad.
- Se diferencia claramente del CU-IM-04, que se enfoca en el envío con conexión activa.

### ¿Harían falta CUs adicionales?
- **No en este escenario directo.**
    - Evolutivos posibles:
        - **CU-IM-XX** para “Gestión de lotes pendientes” (visualizar, eliminar o reenviar manualmente desde un panel).
        - **CU-IM-XX** para “Notificaciones avanzadas” (alertas push cuando un lote pendiente se envía con éxito).
        - **CU-IM-XX** para “Respaldo en nube local/institucional” en caso de pérdida de dispositivo.

### Apreciación final
El CU-IM-05 está bien definido y suficiente para cubrir la **continuidad operativa en modo offline**.  
Aporta robustez al flujo de Ingesta móvil, asegurando que ninguna captura se pierda y que el docente no deba preocuparse por la conectividad.  
