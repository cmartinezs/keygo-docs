# CU-GE-13 — Recibir y procesar lotes desde Ingesta móvil

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-08 | Recibir lotes desde Ingesta móvil

### RF relacionados: RF4, RF8

**Actor principal:** Sistema (backend de Gestión de evaluación)  
**Actores secundarios:** Docente (observa resultados), Aplicación Ingesta móvil

---

### Objetivo
Permitir que el backend de Gestión de evaluación reciba lotes de respuestas enviados por la aplicación de Ingesta móvil, los valide, procese mediante OCR y los asocie automáticamente a la evaluación correspondiente.

### Precondiciones
- Evaluación previamente aplicada y con entregable generado (CU-GE-09, CU-GE-11).
- La aplicación móvil capturó y envió las hojas de respuesta con identificador único (QR/ID).
- Conectividad entre la app móvil y el backend.

### Postcondiciones
- Las respuestas extraídas quedan registradas y vinculadas a los alumnos del curso.
- El lote queda marcado como procesado en el sistema.
- Se genera registro en auditoría con detalles del lote.

### Flujo principal (éxito)
1. La app Ingesta móvil envía lote de imágenes al backend junto con ID de evaluación.
2. El Sistema recibe el lote y valida el ID de la evaluación.
3. El Sistema procesa cada imagen mediante OCR.
4. El Sistema normaliza las respuestas y las asocia a los alumnos correspondientes.
5. El Sistema genera un resumen del lote (total capturas, válidas, con error).
6. El Sistema registra el evento en auditoría.
7. El Sistema confirma recepción exitosa y habilita la etapa de **Calificación automática**.

### Flujos alternativos / Excepciones
- **A1 — ID de evaluación inválido:** El Sistema rechaza el lote y notifica a la app móvil.
- **A2 — OCR fallido en capturas:** El Sistema marca las respuestas como inválidas y las reporta en el resumen.
- **A3 — Alumno no encontrado:** El Sistema descarta la respuesta y lo detalla en el reporte.
- **A4 — Error en transmisión del lote:** El Sistema notifica fallo de carga y permite reintento desde la app.

### Reglas de negocio
- **RN-1:** Todo lote debe estar asociado a una evaluación válida y en estado **Aplicada**.
- **RN-2:** Cada captura debe contener un identificador de entregable único (QR/ID).
- **RN-3:** El OCR debe ser lo suficientemente preciso para garantizar legibilidad mínima.

### Datos principales
- **Lote de respuestas**(ID lote, ID evaluación, imágenes, estado, fecha/hora).
- **Respuestas**(ID alumno, ID evaluación, ítem, respuesta reconocida, timestamp).
- **Resumen de lote**(total capturas, válidas, con error, estado final).
- **Auditoría**(usuario/app origen, acción, fecha/hora).

### Consideraciones de seguridad/permiso
- Los datos transmitidos desde la app deben estar cifrados en tránsito.
- Solo la app autenticada puede enviar lotes válidos.
- El backend debe validar permisos antes de registrar respuestas.

### No funcionales
- **Rendimiento:** procesar hasta 200 capturas por lote en < 2 minutos.
- **Disponibilidad:** alta tolerancia a fallos en transmisión (reintentos automáticos desde la app).
- **Seguridad:** cifrado TLS y validación de origen en cada transmisión.

### Criterios de aceptación (QA)
- **CA-1:** Al recibir lote válido, todas las respuestas extraídas se registran y asocian correctamente.
- **CA-2:** Si el ID de evaluación es inválido, el lote se rechaza y se notifica a la app.
- **CA-3:** Los fallos de OCR se reportan en el resumen del lote.
- **CA-4:** El evento queda registrado en auditoría con detalle de capturas procesadas.  