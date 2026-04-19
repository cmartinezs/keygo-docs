# Apreciación CU-GE-07 — Crear evaluación en borrador

- [Volver](../../README.md#2-gestión-de-evaluación)

### Qué cubre
- Creación de una evaluación en estado **Borrador**, asociada a un curso válido.
- Registro de metadatos básicos como nombre, fecha y duración.
- Asignación automática de un identificador único para trazabilidad.

### Escenario lo justifica
- En S-GE-03, María Fernanda inicia la creación de una evaluación indicando curso, fecha y duración.
- El sistema guarda la evaluación en estado **Borrador**, lista para ser completada.
- Responde directamente a la necesidad de organizar evaluaciones con datos estructurados y reutilizables.

### ¿Es suficiente como CU separado?
✅ Sí. La creación de evaluaciones es un proceso inicial y diferenciado de la asociación de ítems.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Extensiones como **duplicar evaluaciones** o **importar evaluaciones de otra fuente** podrían considerarse en fases futuras, pero no forman parte de este alcance.

### Apreciación final
El CU-GE-07 está bien definido y suficiente para cubrir la creación de evaluaciones en borrador en S-GE-03.

---

# Apreciación CU-GE-08 — Seleccionar ítems del Banco para evaluación

### Qué cubre
- Asociación de ítems vigentes del Banco a una evaluación en estado **Borrador**.
- Incluye búsqueda por filtros, validación de vigencia y control de duplicados.
- Garantiza que las evaluaciones se construyan con ítems pedagógicamente válidos.

### Escenario lo justifica
- En S-GE-03, tras crear una evaluación, María Fernanda selecciona preguntas filtrando por tema y dificultad.
- El sistema asegura que solo ítems activos se puedan asociar.
- Responde a la necesidad de armar evaluaciones coherentes reutilizando preguntas validadas.

### ¿Es suficiente como CU separado?
✅ Sí. La selección de ítems involucra reglas propias distintas a la creación de la evaluación.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Posibles evolutivos serían **sugerencias automáticas de ítems** o **equilibrio de dificultad automático**, pero exceden el alcance actual.

### Apreciación final
El CU-GE-08 está correctamente definido y suficiente para cubrir la selección de ítems en S-GE-03.  
