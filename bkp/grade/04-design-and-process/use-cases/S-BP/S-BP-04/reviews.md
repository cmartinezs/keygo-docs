# Apreciación CU-BP-07 — Buscar Ítems

- [Volver](../../README.md#1-banco-de-preguntas)

### Qué cubre
- Proceso de localizar ítems en el Banco aplicando filtros como tema, dificultad, unidad o etiquetas.
- Presenta resultados con metadatos relevantes para su evaluación pedagógica.
- Es la base para que los usuarios seleccionen preguntas reutilizables.

### Escenario lo justifica
- En S-BP-04, María Fernanda necesita encontrar preguntas relacionadas con la independencia de Chile.
- El sistema permite ingresar filtros, mostrar resultados y metadatos asociados.
- Responde directamente al objetivo de ahorrar tiempo y asegurar coherencia curricular.

### ¿Es suficiente como CU separado?
✅ Sí. La búsqueda es un proceso autónomo que no necesariamente implica selección posterior.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Funciones como **guardar búsquedas frecuentes**, **consultar historial de búsqueda** o **búsqueda masiva** podrían considerarse mejoras futuras, pero no son parte del MVP ni del escenario descrito.
    - **Persistencia de workspace / carpetas de trabajo (Opción 3):** la posibilidad de guardar y compartir carpetas temporales en la base de datos (tablas `workspaces` / `workspace_items`) es una mejora deseable para una fase posterior; mejora la reutilización y colaboración, pero introduce cambios en el DDL y políticas de retención, por lo que queda fuera del alcance inmediato y se recomienda planificarla en una iteración futura.

### Apreciación final
El CU-BP-07 está bien definido y suficiente para cubrir la acción de **buscar ítems** en S-BP-04.  
No requiere más CUs en este punto.

---

# Apreciación CU-BP-08 — Seleccionar Ítems

### Qué cubre
- Proceso de elegir ítems desde resultados de búsqueda y almacenarlos en una carpeta temporal de trabajo.
- Facilita la preparación de evaluaciones sin modificar el Banco original.

### Escenario lo justifica
- En S-BP-04, tras aplicar filtros y obtener resultados, María Fernanda selecciona varias preguntas y las añade a una carpeta de trabajo para componer su evaluación.
- El sistema confirma que los ítems seleccionados quedan listos para ser usados.

### ¿Es suficiente como CU separado?
✅ Sí. La selección es distinta de la búsqueda y merece un CU propio, pues involucra almacenamiento temporal y validaciones (ej.: evitar duplicados).

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Extensiones como **gestionar carpetas múltiples** o **compartir carpetas con otros usuarios** podrían aparecer como funcionalidades futuras, pero no forman parte de S-BP-04.

### Apreciación final
El CU-BP-08 refleja correctamente el proceso de **seleccionar ítems** tras la búsqueda.  
Es suficiente para este escenario y no requiere CUs adicionales.  
Se recomienda planificar la persistencia de workspaces como mejora futura (ver anexo técnico en CU-BP-08 para propuesta DDL).
