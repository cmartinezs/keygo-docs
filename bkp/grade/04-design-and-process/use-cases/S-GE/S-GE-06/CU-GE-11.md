# CU-GE-11 — Aplicar evaluación y registrar

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)
## Escenario origen: S-GE-06 | Aplicar evaluación y registrar aplicación

### RF relacionados: RF1, RF3, RF4, RF8

**Actor principal:** Docente  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Docente marque una evaluación como **Aplicada**, registrando la fecha y hora del evento y habilitando la recepción de respuestas (por CSV o Ingesta móvil).

### Precondiciones
- Usuario autenticado con rol de Docente o Coordinador.
- Curso existente y activo en el sistema (CU-GE-01).
- Alumnos asociados al curso (CU-GE-04 / CU-GE-05).
- Evaluación con entregable generado (CU-GE-09).
- Evaluación aún no marcada como aplicada.

### Postcondiciones
- La evaluación cambia a estado **Aplicada**.
- El sistema habilita la carga de respuestas desde distintos canales.
- El evento queda registrado en el historial de auditoría.

### Flujo principal (éxito)
1. El Docente accede a la evaluación en estado **Listo para aplicar**.
2. Selecciona la opción **“Aplicar evaluación”**.
3. El Sistema solicita confirmación.
4. El Docente confirma la acción.
5. El Sistema cambia el estado de la evaluación a **Aplicada**.
6. El Sistema habilita los canales de carga de respuestas (CSV, Ingesta móvil).
7. El Sistema registra fecha, hora y usuario en auditoría.
8. El Sistema confirma la aplicación exitosa.

### Flujos alternativos / Excepciones
- **A1 — Evaluación ya aplicada:** El Sistema informa que la acción no puede repetirse.
- **A2 — Evaluación sin entregable generado:** El Sistema bloquea la acción e informa al usuario.
- **A3 — Cancelación:** Si el Docente cancela, no se realiza ningún cambio.

### Reglas de negocio
- **RN-1:** Solo evaluaciones con entregable generado pueden marcarse como aplicadas.
- **RN-2:** Una evaluación no puede revertir su estado de **Aplicada**.
- **RN-3:** La aplicación debe quedar registrada en auditoría con fecha y usuario.

### Datos principales
- **Evaluación**(ID, curso, estado, entregable asociado, alumnos vinculados, timestamps).
- **Auditoría**(acción, usuario, fecha/hora, estado previo y posterior).

### Consideraciones de seguridad/permiso
- Solo Docentes o Coordinadores responsables pueden aplicar evaluaciones.
- La acción debe quedar registrada como inmutable en la auditoría.

### No funcionales
- **Disponibilidad:** la aplicación debe habilitar de inmediato la carga de respuestas.
- **Seguridad:** la auditoría debe garantizar integridad y no repudio del registro.
- **Rendimiento:** el cambio de estado debe ejecutarse en < 2s p95.

### Criterios de aceptación (QA)
- **CA-1:** Al aplicar evaluación, el estado cambia a **Aplicada** y queda listo para recepción de respuestas.
- **CA-2:** La fecha/hora y usuario quedan registrados en auditoría.
- **CA-3:** El sistema bloquea la acción si no existe entregable generado.
- **CA-4:** No es posible revertir el estado una vez aplicada.  