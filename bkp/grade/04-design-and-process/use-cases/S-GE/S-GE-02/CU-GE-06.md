# CU-GE-06 — Editar / dar de baja alumno

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-02 | Gestionar alumnos

### RF relacionados: RF1, RF3, RF13

**Actor principal:** Administrador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Administrador edite datos de un alumno o lo dé de baja para que no pueda vincularse a nuevas evaluaciones.

### Precondiciones
- Usuario autenticado con rol de Administrador.
- El alumno existe en el sistema.

### Postcondiciones
- Los datos del alumno quedan actualizados, o el alumno queda en estado **Inactivo**.
- Las evaluaciones pasadas mantienen la referencia al alumno.

### Flujo principal (éxito)
1. El Administrador accede al módulo de gestión de alumnos.
2. Selecciona un alumno existente.
3. El Sistema muestra sus datos.
4. El Administrador edita información (nombre, correo, curso asociado) o selecciona **“Dar de baja”**.
5. El Sistema valida la información o solicita confirmación para la baja.
6. El Sistema guarda los cambios o actualiza el estado del alumno.
7. El Sistema registra la acción en auditoría.
8. El Sistema confirma la operación.

### Flujos alternativos / Excepciones
- **A1 — Alumno inexistente:** El Sistema muestra error.
- **A2 — Datos inválidos:** El Sistema bloquea edición hasta corregir.
- **A3 — Alumno ya inactivo:** El Sistema informa que no puede darse de baja nuevamente.

### Reglas de negocio
- **RN-1:** Los identificadores únicos no pueden modificarse.
- **RN-2:** Evaluaciones históricas deben conservar referencia al alumno dado de baja.

### Datos principales
- **Alumno**(ID, identificador, nombre, correo, cursos asociados, estado, timestamps).
- **Auditoría**(usuario, acción, fecha/hora, motivo).

### Consideraciones de seguridad/permiso
- Solo Administradores pueden editar o dar de baja alumnos.

### No funcionales
- **Disponibilidad:** cambios deben reflejarse inmediatamente en reportes y asociaciones.
- **Trazabilidad:** todas las acciones deben quedar registradas en auditoría.

### Criterios de aceptación (QA)
- **CA-1:** Al editar un alumno, los cambios se reflejan inmediatamente en el sistema.
- **CA-2:** Al dar de baja, el alumno cambia a estado **Inactivo** y ya no puede asociarse a nuevas evaluaciones.
- **CA-3:** Evaluaciones pasadas mantienen la referencia al alumno.
- **CA-4:** Toda acción queda registrada en auditoría.  
