# CU-GE-02 — Editar curso

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-01 | Gestionar cursos

### RF relacionados: RF1, RF3, RF13

**Actor principal:** Coordinador / Administrador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Coordinador o Administrador modifique la información de un curso existente manteniendo trazabilidad.

### Precondiciones
- Usuario autenticado con permisos de gestión académica.
- El curso existe en el catálogo y está activo.

### Postcondiciones
- El curso queda actualizado.
- Los cambios se registran en el historial de auditoría.

### Flujo principal (éxito)
1. El Coordinador accede al módulo de gestión de cursos.
2. Selecciona un curso existente.
3. El Sistema muestra los datos actuales.
4. El Coordinador edita información (nombre, nivel, estado).
5. El Coordinador confirma la edición.
6. El Sistema valida la consistencia de los datos.
7. El Sistema guarda los cambios y actualiza el curso.
8. El Sistema confirma edición exitosa.

### Flujos alternativos / Excepciones
- **A1 — Curso inexistente:** El Sistema informa que el curso no existe.
- **A2 — Datos inválidos:** El Sistema bloquea la edición hasta corregir.

### Reglas de negocio
- **RN-1:** No se puede cambiar el código de un curso si ya tiene evaluaciones asociadas.
- **RN-2:** Las ediciones deben quedar registradas en historial de auditoría.

### Datos principales
- **Curso**(ID, código, nombre, nivel, estado, historial de cambios, timestamps).

### Consideraciones de seguridad/permiso
- Solo Coordinadores y Administradores pueden editar cursos.

### No funcionales
- **Trazabilidad:** cambios deben reflejarse en auditoría.
- **Disponibilidad:** edición no debe afectar evaluaciones ya asociadas.

### Criterios de aceptación (QA)
- **CA-1:** Al editar un curso, los cambios quedan reflejados inmediatamente en el catálogo.
- **CA-2:** Si los datos son inválidos, el sistema bloquea la acción.
- **CA-3:** La edición queda registrada en auditoría.

---