# CU-GE-14 — Calificación automática de evaluación

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-09 | Calificación automática

### RF relacionados: RF5, RF1, RF3, RF4, RF8

**Actor principal:** Sistema (con supervisión del Docente)  
**Actores secundarios:** Docente, Coordinador

---

### Objetivo
Permitir que el Sistema califique automáticamente las respuestas cargadas de los estudiantes, comparándolas con la clave definida en la evaluación, y genere puntajes y notas de manera estandarizada.

### Precondiciones
- Evaluación en estado **Aplicada** (CU-GE-11).
- Respuestas cargadas en el sistema (CU-GE-12 o CU-GE-13).
- Clave de corrección definida en los ítems de la evaluación.

### Postcondiciones
- Cada estudiante recibe puntaje y nota asociada a la evaluación.
- El estado de la evaluación cambia a **Calificada**.
- Los resultados quedan almacenados y disponibles para consulta.
- Se genera registro en auditoría.

### Flujo principal (éxito)
1. El Docente accede a una evaluación en estado **Aplicada**.
2. Selecciona la opción **“Calificar automáticamente”**.
3. El Sistema procesa las respuestas cargadas.
4. El Sistema compara cada respuesta con la clave de corrección del ítem.
5. El Sistema calcula puntajes y notas de cada estudiante según reglas configuradas.
6. El Sistema almacena resultados en la base de datos.
7. El Sistema cambia estado de la evaluación a **Calificada**.
8. El Sistema registra la acción en auditoría.
9. El Sistema confirma finalización del proceso y muestra un resumen al Docente.

### Flujos alternativos / Excepciones
- **A1 — Respuestas incompletas:** El Sistema califica solo ítems respondidos y marca los faltantes como omitidos.
- **A2 — Error en clave de corrección:** El Sistema detiene proceso, alerta al Docente y no guarda resultados.
- **A3 — Inconsistencia en alumnos (no asociados al curso):** El Sistema descarta esas respuestas y las reporta.
- **A4 — Calificación ya realizada:** El Sistema bloquea una nueva ejecución para evitar duplicidad.

### Reglas de negocio
- **RN-1:** Todos los ítems deben tener una clave de corrección válida para ser calificados.
- **RN-2:** El cálculo de notas debe seguir la escala configurada institucionalmente.
- **RN-3:** Una evaluación solo puede pasar a estado **Calificada** una vez.

### Datos principales
- **Evaluación**(ID, curso, estado, ítems, clave de corrección).
- **Respuesta**(ID alumno, ID ítem, respuesta marcada).
- **Resultado**(ID alumno, puntaje obtenido, nota, timestamp).
- **Auditoría**(usuario, acción, fecha/hora, métricas del proceso).

### Consideraciones de seguridad/permiso
- Solo Docentes o Coordinadores con permisos pueden iniciar la calificación.
- El cálculo debe ser verificable y no alterable por terceros.

### No funcionales
- **Rendimiento:** procesar 500 alumnos con 50 ítems en < 2 minutos.
- **Disponibilidad:** resultados accesibles inmediatamente tras calificación.
- **Trazabilidad:** registro de tiempo, errores y resultados debe quedar en auditoría.

### Criterios de aceptación (QA)
- **CA-1:** Al ejecutar calificación automática, todos los alumnos reciben puntaje y nota según clave de corrección.
- **CA-2:** La evaluación cambia a estado **Calificada** automáticamente.
- **CA-3:** El sistema genera log de auditoría con tiempos y errores detectados.
- **CA-4:** Los resultados son visibles inmediatamente para el Docente en la plataforma.  