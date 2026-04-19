# Apreciación CU-IM-01 — Vincular captura con evaluación

- [Volver](../../README.md#3-ingesta-móvil)

### Qué cubre
- Asociación de una sesión de captura con la evaluación correcta.
- Uso de identificadores únicos (QR/ID) para garantizar trazabilidad.
- Validación de estado de la evaluación (**Aplicada**) antes de permitir capturas.
- Manejo de escenarios de error: QR inválido, permisos insuficientes, modo offline.

### Escenario lo justifica
- En S-IM-01, Rodrigo como Docente necesita asegurarse de que las capturas correspondan a la evaluación aplicada en su curso.
- El vínculo previo entre evaluación física y digital es esencial para evitar errores en el proceso de calificación automática.

### ¿Es suficiente como CU separado?
✅ Sí. La vinculación inicial es un paso independiente y crítico antes de iniciar cualquier captura (S-IM-02 en adelante).
- Garantiza que todo el lote de capturas quede en el contexto correcto.
- Permite aplicar reglas de negocio y validaciones de permisos específicas.

### ¿Harían falta CUs adicionales?
- **No dentro de este escenario.**
    - Posibles evolutivos a futuro:
        - **CU-IM-XX** para “Reasociar lote a otra evaluación” (con fuerte restricción de permisos).
        - **CU-IM-XX** para “Validar QR sin conexión con firma digital” (para robustecer el modo offline).

### Apreciación final
El CU-IM-01 está correctamente definido y es suficiente para cubrir el **inicio del flujo de ingesta móvil**.  
Delimita de forma clara la responsabilidad de vinculación con la evaluación, evitando mezclarla con la captura de respuestas.  
Es un CU esencial y bien justificado como pieza independiente del proceso de Ingesta móvil.  
