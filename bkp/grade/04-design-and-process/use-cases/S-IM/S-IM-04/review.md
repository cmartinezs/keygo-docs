# Apreciación CU-IM-04 — Enviar lote y confirmar recepción

- [Volver](../../README.md#3-ingesta-móvil)

### Qué cubre
- Empaquetado y envío de todas las capturas asociadas a una evaluación.
- Confirmación de recepción por parte del sistema central.
- Manejo de errores de conexión, duplicados o validación fallida.
- Persistencia local de lotes pendientes hasta su envío exitoso.

### Escenario lo justifica
- En S-IM-04, Ernesto como Docente necesita asegurar que las capturas lleguen al sistema central.
- La confirmación de recepción otorga confianza y permite que el flujo de calificación continúe sin intervención adicional.
- Es el cierre natural de la fase de captura y validación (CU-IM-02 y CU-IM-03).

### ¿Es suficiente como CU separado?
✅ Sí. El envío y confirmación es un proceso técnico y funcional independiente de la captura y validación.
- Involucra reglas de negocio propias (hash de integridad, reintentos, duplicados).
- Es crítico para la continuidad del flujo de calificación.

### ¿Harían falta CUs adicionales?
- **No estrictamente en este escenario.**
    - Evolutivos posibles:
        - **CU-IM-XX** para “Envío parcial de lotes” (cuando hay capturas incompletas).
        - **CU-IM-XX** para “Revisión manual de lotes fallidos” (intervención administrativa en servidor).
        - **CU-IM-XX** para “Sincronización en segundo plano” (envío automático sin acción del usuario).

### Apreciación final
El CU-IM-04 está correctamente definido y suficiente para cubrir la **fase de envío y confirmación** dentro del flujo de Ingesta móvil.  
Delimita claramente la responsabilidad del sistema en asegurar la entrega confiable, complementando los CUs previos y preparando los datos para el procesamiento central.  
