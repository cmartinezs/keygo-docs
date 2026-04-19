# CU-GE-08 — Seleccionar ítems del Banco para evaluación

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-03 | Crear evaluación desde el banco

### RF relacionados: RF1, RF2, RF3, RF7, RF8

**Actor principal:** Docente / Coordinador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Docente o Coordinador seleccione ítems del Banco de preguntas y los asocie a una evaluación en estado **Borrador**.

### Precondiciones
- Evaluación existente en estado **Borrador** (CU-GE-07).
- Ítems vigentes disponibles en el Banco de preguntas.

### Postcondiciones
- Los ítems seleccionados quedan asociados a la evaluación.
- La evaluación mantiene estado **Borrador**.

### Flujo principal (éxito)
1. El Docente accede a la evaluación en estado **Borrador**.
2. Selecciona la opción **“Agregar ítems del Banco”**.
3. El Sistema abre búsqueda con filtros (tema, dificultad, unidad).
4. El Docente aplica filtros y obtiene resultados.
5. El Docente selecciona uno o más ítems.
6. El Sistema asocia los ítems a la evaluación.
7. El Sistema confirma la operación.

### Flujos alternativos / Excepciones
- **A1 — Sin resultados en búsqueda:** El Sistema informa y permite refinar filtros.
- **A2 — Ítem inactivo:** El Sistema lo bloquea y no permite asociarlo.
- **A3 — Duplicados:** El Sistema impide añadir el mismo ítem más de una vez.

### Reglas de negocio
- **RN-1:** Solo ítems activos y vigentes pueden seleccionarse.
- **RN-2:** Una evaluación puede tener un mínimo y máximo de ítems definidos por configuración.
- **RN-3:** No se deben duplicar ítems dentro de la misma evaluación.

### Datos principales
- **Evaluación**(ID, curso, estado, ítems asociados, timestamps).
- **Ítems**(ID, enunciado, metadatos, estado).

### Consideraciones de seguridad/permiso
- Solo Docentes y Coordinadores con permisos pueden agregar ítems.

### No funcionales
- **Rendimiento:** búsqueda y asociación de ítems < 3s p95.
- **Usabilidad:** interfaz clara con filtros de búsqueda y selección múltiple.

### Criterios de aceptación (QA)
- **CA-1:** El usuario puede seleccionar ítems activos y asociarlos a una evaluación en borrador.
- **CA-2:** Ítems inactivos no pueden asociarse.
- **CA-3:** El sistema evita duplicados.
- **CA-4:** Los ítems asociados quedan listados en la evaluación.  