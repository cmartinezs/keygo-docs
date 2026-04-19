# CU-GE-15 — Manejar errores de ingesta (OCR/CSV)

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-10 | Manejar errores de ingesta (OCR/CSV)

### RF relacionados: RF4, RF8

**Actor principal:** Docente  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Docente detecte, revise y resuelva errores ocurridos durante la carga de respuestas (CSV o Ingesta móvil), para asegurar que los datos sean válidos antes de la calificación automática.

### Precondiciones
- Evaluación en estado **Aplicada** (CU-GE-11).
- Intento de carga de respuestas realizado (CU-GE-12 o CU-GE-13).
- El sistema detectó errores de formato, asociación de alumnos o calidad de captura.

### Postcondiciones
- Los errores quedan registrados en un reporte accesible para el Docente.
- El docente puede corregir y volver a cargar los datos.
- Solo respuestas válidas pasan a la etapa de calificación automática.

### Flujo principal (éxito)
1. El Docente carga respuestas por CSV o la app envía un lote desde Ingesta móvil.
2. El Sistema valida estructura, asociación y calidad de datos.
3. El Sistema detecta errores y genera un reporte detallado (línea, columna, tipo de error).
4. El Sistema bloquea la carga de registros inválidos.
5. El Sistema permite al Docente descargar el reporte de errores.
6. El Docente corrige el archivo CSV o repite captura de imágenes según corresponda.
7. El Docente vuelve a cargar datos corregidos.
8. El Sistema valida nuevamente y confirma carga exitosa.

### Flujos alternativos / Excepciones
- **A1 — Errores menores en CSV (ej.: celdas vacías):** El Sistema importa registros válidos y reporta solo los inválidos.
- **A2 — Errores graves en CSV (estructura incorrecta):** El Sistema rechaza el archivo completo.
- **A3 — Fallo de OCR (baja confianza):** El Sistema marca las imágenes y sugiere repetir captura.
- **A4 — Reintento fallido:** Si el error persiste, el Sistema mantiene el lote en estado **Pendiente de corrección**.

### Reglas de negocio
- **RN-1:** Ningún registro inválido puede pasar a la etapa de calificación automática.
- **RN-2:** Todos los errores deben ser reportados explícitamente al Docente.
- **RN-3:** El sistema debe conservar el historial de intentos de carga y corrección.

### Datos principales
- **Reporte de errores**(ID, fuente [CSV/OCR], detalle por fila/captura, fecha/hora).
- **Respuestas válidas**(ID alumno, ID evaluación, ítem, respuesta).
- **Respuestas inválidas**(detalle error, estado pendiente).

### Consideraciones de seguridad/permiso
- Solo el Docente responsable de la evaluación o un Coordinador autorizado puede corregir y recargar respuestas.
- Los reportes de errores deben proteger datos sensibles de alumnos.

### No funcionales
- **Usabilidad:** el reporte debe ser claro, con referencias exactas a filas/ítems afectados.
- **Rendimiento:** la validación de errores debe completarse en < 2 minutos para lotes de 500 registros.
- **Trazabilidad:** cada intento de carga debe quedar registrado en auditoría.

### Criterios de aceptación (QA)
- **CA-1:** Al detectarse errores, el sistema genera un reporte detallado accesible al Docente.
- **CA-2:** Registros inválidos no avanzan a la calificación.
- **CA-3:** Tras corregir y recargar, las respuestas válidas quedan registradas correctamente.
- **CA-4:** El historial de intentos (errores y correcciones) queda en auditoría.  
