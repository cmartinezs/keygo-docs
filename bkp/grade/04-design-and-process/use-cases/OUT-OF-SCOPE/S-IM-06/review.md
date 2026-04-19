# Apreciación CU-IM-06 — Estado de procesamiento y notificación

- [Volver](../../README.md#3-ingesta-móvil)

### Qué cubre
- Consulta del estado de los lotes enviados desde la app al sistema central.
- Notificación de estados: **Procesado correctamente**, **Procesando**, **Con errores**.
- Detalle de errores específicos (ej. hojas ilegibles) y sugerencia de acciones correctivas.
- Manejo de casos de conexión inestable y sincronización de estados.

### Escenario lo justifica
- En S-IM-06, Carlitos como Asistente de aula necesita confirmar que el sistema procesó correctamente los lotes enviados.
- Permite detectar errores tempranos y dar acciones de corrección sin esperar al cierre del ciclo de calificación.
- Aumenta la confianza del usuario en la digitalización móvil y en la trazabilidad del proceso.

### ¿Es suficiente como CU separado?
✅ Sí. Consultar y notificar el estado es un proceso independiente del envío de capturas (CU-IM-04) y del almacenamiento offline (CU-IM-05).
- Implica lógica de negocio adicional (gestión de estados, detalle de errores, notificaciones).
- Justifica un CU separado para mantener claridad y responsabilidades bien delimitadas.

### ¿Harían falta CUs adicionales?
- **No en este escenario directo.**
    - Evolutivos posibles:
        - **CU-IM-XX** para “Notificaciones en tiempo real” (push al dispositivo en lugar de consulta manual).
        - **CU-IM-XX** para “Gestión de errores avanzada” (flujos automáticos de recaptura o integración con soporte).
        - **CU-IM-XX** para “Dashboard web de seguimiento” (visualización centralizada por coordinadores).

### Apreciación final
El CU-IM-06 está correctamente definido y suficiente para cubrir la **verificación del estado de procesamiento** en Ingesta móvil.  
Complementa al CU-IM-04 y CU-IM-05, aportando transparencia y confianza al ciclo de digitalización y asegurando que los usuarios puedan actuar frente a errores.  
