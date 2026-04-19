# Apreciación CU-GE-04 — Registrar alumno manualmente

- [Volver](../../README.md#2-gestión-de-evaluación)

### Qué cubre
- Registro de un alumno en el sistema de forma manual.
- Asociación inmediata del alumno a un curso existente.
- Garantiza que cada alumno tenga un identificador único.

### Escenario lo justifica
- En S-GE-02, María Fernanda necesita asegurar que los resultados de evaluaciones se vinculen correctamente a los estudiantes.
- Registrar manualmente es útil en casos puntuales, como agregar un alumno nuevo o regularizar información.

### ¿Es suficiente como CU separado?
✅ Sí. El registro manual es una acción independiente y no debe mezclarse con importaciones en bloque.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Mejoras como **registro con datos biométricos** o **integración automática con sistemas externos** podrían evaluarse a futuro, pero no forman parte del alcance actual.

### Apreciación final
El CU-GE-04 está bien definido y suficiente para cubrir la acción de registro manual de alumnos.

---

# Apreciación CU-GE-05 — Importar alumnos desde CSV

### Qué cubre
- Importación en bloque de múltiples alumnos a través de un archivo CSV.
- Asociación automática de cada alumno a su curso.
- Generación de reporte con filas válidas y con error.

### Escenario lo justifica
- En S-GE-02, María Fernanda necesita cargar decenas de estudiantes de una sola vez.
- La importación evita trabajo manual repetitivo y asegura consistencia en el registro.

### ¿Es suficiente como CU separado?
✅ Sí. La importación requiere reglas de validación específicas y un flujo propio distinto al registro manual.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Extensiones como **importar desde sistemas externos de gestión académica** o **programar importaciones periódicas** pueden añadirse en fases futuras.

### Apreciación final
El CU-GE-05 está correctamente definido y suficiente para cubrir la importación de alumnos en bloque.

---

# Apreciación CU-GE-06 — Editar / dar de baja alumno

### Qué cubre
- Modificación de datos básicos de un alumno.
- Dar de baja alumnos para que no participen en nuevas evaluaciones.
- Mantener trazabilidad en evaluaciones históricas.

### Escenario lo justifica
- En S-GE-02, María Fernanda debe mantener actualizado el listado de estudiantes y poder dar de baja a quienes egresen o se retiren.
- El sistema asegura que evaluaciones pasadas conserven la referencia al alumno.

### ¿Es suficiente como CU separado?
✅ Sí. Editar o dar de baja alumnos son operaciones distintas a registrar o importar, y afectan directamente la trazabilidad académica.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Posibles evolutivos serían **reasignar alumnos entre cursos en lote** o **restaurar alumnos dados de baja**, pero no aplican aquí.

### Apreciación final
El CU-GE-06 está bien definido y suficiente para cubrir la edición y baja de alumnos en S-GE-02.  
