# CU-GE-03 — Dar de baja curso

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-01 | Gestionar cursos

### RF relacionados: RF1, RF3, RF13

**Actor principal:** Coordinador / Administrador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Coordinador o Administrador dé de baja un curso para que ya no se use en nuevas evaluaciones, manteniendo trazabilidad de las evaluaciones pasadas.

### Precondiciones
- Usuario autenticado con permisos de gestión académica.
- El curso existe en el catálogo y está activo.

### Postcondiciones
- El curso queda en estado **Inactivo**.
- No se puede asociar a nuevas evaluaciones.
- Las evaluaciones históricas mantienen la referencia al curso.

### Flujo principal (éxito)
1. El Coordinador accede al módulo de gestión de cursos.
2. Selecciona un curso existente.
3. Elige la opción **“Dar de baja”**.
4. El Sistema solicita confirmación.
5. El Coordinador confirma la acción.
6. El Sistema cambia el estado del curso a **Inactivo**.
7. El Sistema registra la acción en auditoría.
8. El Sistema confirma la baja exitosa.

### Flujos alternativos / Excepciones
- **A1 — Curso ya inactivo:** El Sistema informa que no puede volver a darse de baja.
- **A2 — Cancelación:** El Coordinador cancela y no se modifica el estado.

### Reglas de negocio
- **RN-1:** Los cursos inactivos no pueden usarse en nuevas evaluaciones.
- **RN-2:** La baja debe quedar registrada en auditoría.
- **RN-3:** Evaluaciones históricas mantienen vínculo con el curso.

### Datos principales
- **Curso**(ID, código, nombre, nivel, estado, timestamps).
- **Auditoría**(usuario, acción, fecha/hora, motivo).

### Consideraciones de seguridad/permiso
- Solo Coordinadores y Administradores pueden dar de baja cursos.

### No funcionales
- **Disponibilidad:** la baja debe reflejarse inmediatamente en catálogos de selección.
- **Trazabilidad:** cursos dados de baja deben seguir visibles en evaluaciones históricas.

### Criterios de aceptación (QA)
- **CA-1:** Al dar de baja un curso, este cambia a estado **Inactivo** y deja de estar disponible en catálogos.
- **CA-2:** Evaluaciones antiguas siguen mostrando el curso asociado.
- **CA-3:** La baja queda registrada en auditoría.  