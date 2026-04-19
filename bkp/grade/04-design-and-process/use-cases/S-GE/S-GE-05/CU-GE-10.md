# CU-GE-10 — Asociar evaluación a curso

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-05 | Asociar evaluación a curs (alumnos)

### RF relacionados: RF1, RF3, RF6, RF8

**Actor principal:** Docente  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Docente vincule una evaluación en estado **Borrador** a un curso y su lista de alumnos, asegurando trazabilidad de resultados por estudiante.

### Precondiciones
- Usuario autenticado con rol de Docente o Coordinador.
- Curso existente y activo en el sistema (CU-GE-01).
- Alumnos registrados y asociados al curso (CU-GE-04 / CU-GE-05).
- Evaluación creada en estado **Borrador** (CU-GE-07).

### Postcondiciones
- La evaluación queda asociada al curso seleccionado.
- Los alumnos del curso quedan vinculados a la evaluación.
- El sistema actualiza auditoría y trazabilidad académica.

### Flujo principal (éxito)
1. El Docente accede a una evaluación en estado **Borrador**.
2. Selecciona la opción **“Asociar curso”**.
3. El Sistema muestra listado de cursos disponibles para el usuario.
4. El Docente selecciona el curso y confirma.
5. El Sistema carga la lista de alumnos registrados en el curso.
6. El Sistema vincula la evaluación con el curso y todos sus alumnos.
7. El Sistema registra la acción en auditoría.
8. El Sistema confirma la asociación exitosa.

### Flujos alternativos / Excepciones
- **A1 — Curso inexistente o inactivo:** El Sistema bloquea la acción y muestra error.
- **A2 — Evaluación ya asociada:** El Sistema informa que la evaluación ya está vinculada a otro curso.
- **A3 — Curso sin alumnos registrados:** El Sistema permite la asociación pero muestra advertencia.
- **A4 — Cancelación:** El Docente cancela la acción y no se realizan cambios.

### Reglas de negocio
- **RN-1:** Una evaluación solo puede estar asociada a un curso/sección a la vez.
- **RN-2:** Los alumnos asociados al curso deben quedar vinculados automáticamente a la evaluación.
- **RN-3:** La asociación debe quedar registrada en el historial de auditoría.

### Datos principales
- **Evaluación**(ID, curso asociado, estado, alumnos vinculados, timestamps).
- **Curso**(ID, nombre, nivel, estado).
- **Alumno**(ID, nombre, identificador único, estado).

### Consideraciones de seguridad/permiso
- Solo Docentes o Coordinadores con permisos sobre el curso pueden asociar evaluaciones.

### No funcionales
- **Disponibilidad:** asociación inmediata reflejada en catálogos de evaluaciones.
- **Rendimiento:** asociación de evaluación a curso con hasta 200 alumnos < 5s p95.
- **Trazabilidad:** todas las acciones deben registrarse en auditoría.

### Criterios de aceptación (QA)
- **CA-1:** Al asociar una evaluación, esta queda vinculada al curso y todos sus alumnos.
- **CA-2:** El sistema bloquea asociación si el curso no existe o está inactivo.
- **CA-3:** La acción queda registrada en auditoría con usuario, fecha y hora.
- **CA-4:** Evaluaciones ya asociadas no pueden volver a vincularse a otro curso.  
