# Apreciación CU-GE-09 — Generar entregable con identificador único

- [Volver](../../README.md#2-gestión-de-evaluación)

### Qué cubre
- Generación de un archivo PDF con la evaluación preparada.
- Inclusión de un identificador único en cada copia (QR, folio o marca de agua).
- Cambio automático del estado de la evaluación a **Listo para aplicar**.
- Registro del evento en auditoría para trazabilidad.

### Escenario lo justifica
- En S-GE-04, Rodrigo necesita un entregable con trazabilidad para aplicar la evaluación a sus estudiantes.
- El sistema asegura que cada copia quede identificada de manera única y vinculable a respuestas posteriores.
- Responde a la necesidad de control y trazabilidad en el ciclo de evaluaciones.

### ¿Es suficiente como CU separado?
✅ Sí. La generación de entregables es un proceso clave, independiente de la creación o selección de ítems, y con reglas específicas sobre identificadores y estado de la evaluación.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Posibles evolutivos serían **generar entregables personalizados por alumno** o **programar entregables para varias secciones**, pero no forman parte del alcance actual.

### Apreciación final
El CU-GE-09 está correctamente definido y suficiente para cubrir la generación de entregables con identificador único en S-GE-04.  
No requiere CUs adicionales en este escenario.  
