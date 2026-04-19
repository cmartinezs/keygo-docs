# Apreciación CU-GE-16 — Publicar resultados de evaluación

- [Volver](../../README.md#2-gestión-de-evaluación)

### Qué cubre
- Cambio de estado de la evaluación a **Publicado**.
- Habilitación de resultados individuales y agregados para los usuarios correspondientes.
- Registro del evento de publicación en auditoría.

### Escenario lo justifica
- En S-GE-11, Ernesto necesita liberar resultados de su evaluación ya calificada.
- El sistema asegura que la publicación sea controlada y registrada, habilitando estadísticas básicas.
- Responde a la necesidad de dar retroalimentación oportuna y trazable a los estudiantes.

### ¿Es suficiente como CU separado?
✅ Sí. Publicar resultados es un proceso crítico, distinto de calificar (CU-GE-14) o consultar (CU-GE-17), y con impacto en la disponibilidad de información.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Evolutivos posibles serían **rectificaciones posteriores a la publicación** o **publicación parcial por grupo de alumnos**, pero no forman parte del alcance actual.

### Apreciación final
El CU-GE-16 está correctamente definido y suficiente para cubrir la **publicación de resultados** en S-GE-11.

---

# Apreciación CU-GE-17 — Consultar resultados y estadísticas

### Qué cubre
- Acceso diferenciado a resultados y estadísticas según rol (Docente, Coordinador, Estudiante).
- Visualización de notas, promedios, medianas y desempeño por ítem.
- Registro de accesos en auditoría para trazabilidad.

### Escenario lo justifica
- En S-GE-11, Ernesto consulta estadísticas básicas tras publicar, mientras que los estudiantes acceden a sus notas y los Coordinadores a vistas agregadas.
- El sistema aplica reglas de acceso estrictas para garantizar privacidad y seguridad.

### ¿Es suficiente como CU separado?
✅ Sí. La consulta de resultados es una acción distinta de la publicación, con flujos y reglas de acceso propios.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Evolutivos posibles serían **exportación avanzada de estadísticas**, **dashboards interactivos** o **comparación histórica de evaluaciones**, pero exceden el alcance definido.

### Apreciación final
El CU-GE-17 está correctamente definido y suficiente para cubrir la **consulta de resultados y estadísticas** en S-GE-11.  
