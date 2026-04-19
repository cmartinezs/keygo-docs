# CU-GE-12 — Cargar respuestas desde archivo CSV

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-07 | Cargar respuestas por CSV tabulado

### RF relacionados: RF4, RF5, RF8

**Actor principal:** Docente  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Docente cargue las respuestas de los estudiantes a una evaluación en estado **Aplicada**, utilizando un archivo CSV tabulado y validado.

### Precondiciones
- Usuario autenticado con rol de Docente o Coordinador.
- Evaluación en estado **Aplicada** (CU-GE-11).
- Archivo CSV generado a partir de la plantilla institucional.
- Estudiantes registrados y asociados al curso correspondiente (CU-GE-04 / CU-GE-05).

### Postcondiciones
- Las respuestas quedan registradas en el sistema y vinculadas a cada estudiante.
- La evaluación avanza automáticamente a la etapa de **Calificación automática**.
- Se genera un reporte de importación con resultados y errores.

### Flujo principal (éxito)
1. El Docente accede a la evaluación en estado **Aplicada**.
2. Selecciona la opción **“Cargar respuestas (CSV)”**.
3. El Sistema solicita el archivo y muestra la plantilla de referencia.
4. El Docente sube el archivo CSV.
5. El Sistema valida estructura, formato y consistencia de datos.
6. El Sistema registra las respuestas válidas, vinculándolas a los alumnos correspondientes.
7. El Sistema genera reporte de carga con detalle de éxito/errores.
8. El Sistema avanza la evaluación a la etapa de **Calificación automática**.

### Flujos alternativos / Excepciones
- **A1 — Archivo con formato inválido:** El Sistema rechaza el archivo e informa al usuario.
- **A2 — Filas incompletas:** El Sistema importa respuestas válidas y genera reporte con errores.
- **A3 — Alumnos no asociados al curso:** El Sistema descarta esas filas y alerta en el reporte.
- **A4 — Error en carga masiva:** El Sistema permite reintentar sin perder consistencia.

### Reglas de negocio
- **RN-1:** El archivo CSV debe seguir la plantilla definida por la institución.
- **RN-2:** Cada fila debe incluir identificador único de estudiante, identificador de entregable y respuestas.
- **RN-3:** Los registros inválidos deben informarse en un reporte, nunca ignorarse silenciosamente.

### Datos principales
- **Archivo CSV**(nombre, tamaño, fecha de carga).
- **Respuestas**(ID estudiante, ID evaluación, ítem, respuesta seleccionada, timestamp).
- **Reporte de carga**(total filas, válidas, con error, detalle por línea).

### Consideraciones de seguridad/permiso
- Solo Docentes o Coordinadores con permisos sobre el curso pueden cargar respuestas.
- Validación estricta del archivo para evitar inyecciones o datos corruptos.

### No funcionales
- **Rendimiento:** carga de hasta 500 registros en < 1 minuto.
- **Usabilidad:** reporte de errores legible, con referencia a filas específicas.
- **Seguridad:** archivos deben ser procesados en un entorno seguro y aislado.

### Criterios de aceptación (QA)
- **CA-1:** Un archivo CSV válido registra correctamente todas las respuestas en el sistema.
- **CA-2:** El sistema rechaza archivos que no cumplen con la plantilla.
- **CA-3:** El reporte muestra detalle de filas con error.
- **CA-4:** La evaluación avanza automáticamente a la etapa de **Calificación automática** tras la carga exitosa.  