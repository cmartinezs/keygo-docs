# Apreciación CU-GE-13 — Recibir y procesar lotes desde Ingesta móvil

- [Volver](../../README.md#2-gestión-de-evaluación)

### Qué cubre
- Recepción de lotes enviados por la aplicación Ingesta móvil.
- Validación del ID de la evaluación y de cada captura.
- Procesamiento de imágenes mediante OCR para extraer respuestas.
- Asociación automática de respuestas a los alumnos del curso.
- Generación de resumen y registro de auditoría.

### Escenario lo justifica
- En S-GE-08, Rodrigo utiliza la app de Ingesta móvil para capturar hojas de respuesta.
- El backend de Gestión de evaluación recibe el lote, valida los datos, procesa las respuestas y genera un resumen.
- Se asegura trazabilidad entre el entregable físico y las respuestas digitalizadas.

### ¿Es suficiente como CU separado?
✅ Sí. La ingesta móvil tiene un flujo técnico y funcional distinto de la carga manual por CSV (CU-GE-12), con validaciones, OCR y transmisión de datos desde un canal móvil.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Posibles evolutivos serían **procesamiento distribuido de lotes**, **detección avanzada de errores de OCR** o **notificaciones automáticas al docente sobre estado del lote**, pero no forman parte del alcance actual.

### Apreciación final
El CU-GE-13 está correctamente definido y suficiente para cubrir la **recepción y procesamiento de lotes desde Ingesta móvil** en S-GE-08.  
No requiere CUs adicionales en este escenario.  
