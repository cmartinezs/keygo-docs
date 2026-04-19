# Apreciación CU-GE-01 — Crear curso

- [Volver](../../README.md#2-gestión-de-evaluación)

### Qué cubre
- Registro de un nuevo curso en el sistema.
- Incluye datos clave: nombre, código, nivel y estado.
- Define la base para que las evaluaciones puedan vincularse a cursos válidos.

### Escenario lo justifica
- En S-GE-01, Rodrigo necesita crear cursos para que los docentes asocien evaluaciones.
- La creación asegura consistencia y evita duplicados en el catálogo.

### ¿Es suficiente como CU separado?
✅ Sí. La creación de cursos es una acción central y diferenciada de edición o baja.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Extensiones como **importación masiva de cursos** o **sincronización con sistemas académicos externos** podrían evaluarse en el futuro, pero no son parte de este alcance.

### Apreciación final
El CU-GE-01 está bien definido y suficiente para cubrir la creación de cursos en S-GE-01.

---

# Apreciación CU-GE-02 — Editar curso

### Qué cubre
- Modificación de información de cursos existentes (nombre, nivel, estado).
- Mantiene trazabilidad y control mediante auditoría.
- Asegura que el catálogo esté actualizado y alineado a la institución.

### Escenario lo justifica
- En S-GE-01, Rodrigo corrige datos de cursos ya creados.
- El sistema valida cambios y conserva historial para evitar inconsistencias.

### ¿Es suficiente como CU separado?
✅ Sí. La edición tiene reglas propias (ej.: no cambiar código con evaluaciones asociadas) y no debe mezclarse con creación o baja.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Mejoras como **gestión de versiones de cursos** o **comparación de historial de ediciones** pueden ser evolutivas, pero no forman parte del escenario actual.

### Apreciación final
El CU-GE-02 está correctamente planteado y suficiente para cubrir la edición de cursos en S-GE-01.

---

# Apreciación CU-GE-03 — Dar de baja curso

### Qué cubre
- Cambio de estado de un curso a **Inactivo**.
- Evita su uso en nuevas evaluaciones, manteniendo trazabilidad de las evaluaciones pasadas.

### Escenario lo justifica
- En S-GE-01, Rodrigo puede dar de baja un curso que ya no está vigente.
- El sistema conserva el vínculo con evaluaciones históricas y registra la acción en auditoría.

### ¿Es suficiente como CU separado?
✅ Sí. La baja es una operación distinta de crear o editar, con impacto directo en la vigencia de los cursos.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Extensiones como **baja programada por fecha** o **baja masiva** pueden considerarse evolutivas, pero no aplican en este caso.

### Apreciación final
El CU-GE-03 está bien delimitado y suficiente para cubrir la baja de cursos en S-GE-01.  
