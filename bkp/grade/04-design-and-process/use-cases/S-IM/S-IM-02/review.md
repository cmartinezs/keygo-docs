# Apreciación CU-IM-02 — Capturar hoja de respuestas

- [Volver](../../README.md#3-ingesta-móvil)

### Qué cubre
- Captura de hojas de respuesta mediante la cámara de la app.
- Asistencia visual con guías de encuadre para garantizar legibilidad.
- Almacenamiento en un lote temporal vinculado a la evaluación.
- Validación básica de condiciones de captura (encuadre, luminosidad, movimiento).

### Escenario lo justifica
- En S-IM-02, María Fernanda como Docente necesita digitalizar rápidamente las respuestas de sus estudiantes.
- La captura con asistencia visual reduce el riesgo de errores y asegura calidad suficiente para el OCR.
- Es un paso operativo independiente, pero indispensable en el flujo de ingesta móvil.

### ¿Es suficiente como CU separado?
✅ Sí. La captura de hojas es un proceso central y con reglas propias, distinto de la vinculación inicial (CU-IM-01) y del envío posterior (CU-IM-04).
- Justifica un CU independiente ya que requiere validaciones específicas de calidad y usabilidad.

### ¿Harían falta CUs adicionales?
- **No en este escenario directo.**
    - Evolutivos posibles:
        - **CU-IM-XX** para “Captura asistida con inteligencia artificial” (detectar automáticamente malas capturas).
        - **CU-IM-XX** para “Gestión avanzada de lotes” (editar/eliminar capturas antes de enviar).
        - **CU-IM-XX** para “Integración con hardware especializado” (escáner dedicado).

### Apreciación final
El CU-IM-02 está correctamente definido y suficiente para cubrir el **proceso de captura de hojas** dentro del flujo de Ingesta móvil.  
Su alcance es claro, se enfoca en la calidad y la usabilidad, y deja espacio para evoluciones futuras sin perder independencia de otros CUs.  
