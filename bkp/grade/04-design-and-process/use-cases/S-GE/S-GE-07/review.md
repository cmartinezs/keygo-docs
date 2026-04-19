# Apreciación CU-GE-12 — Cargar respuestas desde archivo CSV

- [Volver](../../README.md#2-gestión-de-evaluación)

### Qué cubre
- Proceso de carga de respuestas de estudiantes en bloque mediante archivo CSV tabulado.
- Validación de estructura, formato y consistencia de datos.
- Registro de respuestas correctas y generación de reporte con errores.
- Avance automático de la evaluación hacia la etapa de **Calificación automática**.

### Escenario lo justifica
- En S-GE-07, Ernesto necesita subir respuestas ya digitalizadas desde hojas de papel.
- El sistema valida el archivo, importa las respuestas correctas y alerta sobre inconsistencias.
- Responde a la necesidad de eficiencia y reducción de errores en la carga de resultados.

### ¿Es suficiente como CU separado?
✅ Sí. La carga masiva de respuestas es un proceso especializado, diferente de la aplicación de la evaluación o la ingesta móvil, y requiere validaciones y reglas de negocio propias.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Extensiones como **importar en otros formatos (XLSX, JSON)**, **validaciones avanzadas en tiempo real** o **integración automática con sistemas externos de digitalización** pueden evaluarse en fases futuras, pero no forman parte del alcance actual.

### Apreciación final
El CU-GE-12 está correctamente definido y suficiente para cubrir la acción de **cargar respuestas desde CSV** en S-GE-07.  
No requiere CUs adicionales en este escenario.  
