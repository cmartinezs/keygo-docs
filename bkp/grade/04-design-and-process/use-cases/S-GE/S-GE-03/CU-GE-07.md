# CU-GE-07 — Crear evaluación en borrador

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-03 | Crear evaluación desde el banco

### RF relacionados: RF1, RF2, RF3, RF7, RF8

**Actor principal:** Docente / Coordinador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Docente o Coordinador cree una nueva evaluación en estado **Borrador**, asociada a un curso y con metadatos básicos, para luego completarla con ítems seleccionados.

### Precondiciones
- Curso existente en el sistema (CU-GE-01).
- Alumnos asociados al curso (CU-GE-04 / CU-GE-05).
- Usuario autenticado con permisos de creación de evaluaciones.

### Postcondiciones
- La evaluación queda creada en estado **Borrador**.
- Se le asigna un identificador único.
- Queda disponible para edición o publicación posterior.

### Flujo principal (éxito)
1. El Docente accede al módulo de Gestión de evaluaciones.
2. Selecciona la opción **“Nueva evaluación”**.
3. El Sistema solicita metadatos: nombre de evaluación, curso, fecha, duración.
4. El Docente completa la información y confirma.
5. El Sistema valida que el curso existe y está activo.
6. El Sistema crea la evaluación en estado **Borrador**.
7. El Sistema asigna identificador único.
8. El Sistema confirma la creación.

### Flujos alternativos / Excepciones
- **A1 — Curso inexistente/inactivo:** El Sistema bloquea la creación.
- **A2 — Datos incompletos:** El Sistema impide guardar hasta completarlos.
- **A3 — Error de validación en fecha/duración:** El Sistema informa y permite corregir.

### Reglas de negocio
- **RN-1:** Cada evaluación debe asociarse a un curso válido.
- **RN-2:** El estado inicial siempre será **Borrador**.
- **RN-3:** La evaluación debe contar con identificador único para trazabilidad.

### Datos principales
- **Evaluación**(ID, nombre, curso, fecha, duración, estado, creador, timestamps).

### Consideraciones de seguridad/permiso
- Solo Docentes y Coordinadores pueden crear evaluaciones.
- El sistema debe registrar en auditoría quién la creó.

### No funcionales
- **Disponibilidad:** la creación debe reflejarse inmediatamente en listados.
- **Rendimiento:** operación < 2s p95.

### Criterios de aceptación (QA)
- **CA-1:** Una nueva evaluación queda en estado **Borrador** tras guardarse.
- **CA-2:** Si el curso no existe, la acción se bloquea.
- **CA-3:** El sistema asigna un ID único.
- **CA-4:** La creación queda registrada en auditoría.  