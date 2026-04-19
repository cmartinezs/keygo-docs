# Apreciación CU-GE-14 — Calificación automática de evaluación

- [Volver](../../README.md#2-gestión-de-evaluación)

### Qué cubre
- Comparación automática de respuestas de estudiantes con la clave de corrección.
- Cálculo de puntajes y notas según reglas institucionales.
- Cambio automático del estado de la evaluación a **Calificada**.
- Registro del proceso completo en auditoría con métricas de tiempo y errores.

### Escenario lo justifica
- En S-GE-09, María Fernanda necesita que el sistema corrija automáticamente las respuestas cargadas.
- El sistema procesa respuestas, aplica la clave de corrección y entrega notas de inmediato.
- Esto responde directamente a la necesidad de ahorrar tiempo, estandarizar la corrección y minimizar errores humanos.

### ¿Es suficiente como CU separado?
✅ Sí. La calificación automática es un proceso crítico, independiente de la carga de respuestas o la publicación de resultados, y requiere reglas de negocio propias.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Posibles evolutivos serían **ajustar parámetros de calificación (curva, ponderaciones)**, **permitir recalificaciones** o **validaciones pedagógicas avanzadas**, pero no forman parte del alcance actual.

### Apreciación final
El CU-GE-14 está correctamente definido y suficiente para cubrir la acción de **calificación automática** en S-GE-09.  
No requiere CUs adicionales en este escenario.  
