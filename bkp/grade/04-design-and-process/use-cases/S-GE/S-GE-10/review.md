# Apreciación CU-GE-15 — Manejar errores de ingesta (OCR/CSV)

- [Volver](../../README.md#2-gestión-de-evaluación)

### Qué cubre
- Validación de datos provenientes de cargas de respuestas (CSV o Ingesta móvil).
- Identificación de errores de estructura, asociación de alumnos y calidad de captura OCR.
- Generación de reportes detallados con indicación de errores por fila o imagen.
- Posibilidad de corregir y recargar datos hasta lograr una carga válida.

### Escenario lo justifica
- En S-GE-10, Carlitos enfrenta errores al cargar respuestas tanto por CSV como por Ingesta móvil.
- El sistema debe impedir que registros inválidos pasen a la calificación y proporcionar al Docente herramientas claras para corregirlos.
- Esto asegura la integridad de la información y evita que errores contaminen los resultados de los estudiantes.

### ¿Es suficiente como CU separado?
✅ Sí. El manejo de errores es un proceso específico que se activa cuando falla la ingesta de datos, y requiere reglas y validaciones propias distintas de la carga normal (CU-GE-12, CU-GE-13).

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Posibles evolutivos serían **notificaciones automáticas al Docente sobre errores detectados**, **interfaces de corrección en línea sin necesidad de recargar archivos** o **integración con algoritmos de autocorrección en OCR**, pero no forman parte del alcance actual.

### Apreciación final
El CU-GE-15 está correctamente definido y suficiente para cubrir la acción de **gestionar errores en la ingesta de respuestas** en S-GE-10.  
No requiere CUs adicionales en este escenario.  
