# CU-GE-04 — Registrar alumno manualmente

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-02 | Gestionar alumnos

### RF relacionados: RF1, RF3, RF13

**Actor principal:** Administrador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Administrador registre manualmente un alumno en el sistema y lo asocie a un curso existente.

### Precondiciones
- Usuario autenticado con rol de Administrador.
- El curso al que se asociará el alumno ya existe.
- El alumno no debe estar previamente registrado con el mismo identificador único (ej.: RUT, ID institucional).

### Postcondiciones
- El alumno queda registrado con un identificador único.
- El alumno queda asociado al curso seleccionado.

### Flujo principal (éxito)
1. El Administrador accede al módulo de gestión de alumnos.
2. Selecciona la opción **“Registrar alumno”**.
3. El Sistema solicita datos: nombre completo, identificador único, correo electrónico, curso asociado.
4. El Administrador completa los datos y confirma.
5. El Sistema valida duplicados y consistencia.
6. El Sistema registra al alumno y lo asocia al curso.
7. El Sistema confirma registro exitoso.

### Flujos alternativos / Excepciones
- **A1 — Alumno duplicado:** El Sistema bloquea creación si el identificador ya existe.
- **A2 — Curso inexistente:** El Sistema bloquea y muestra error.
- **A3 — Datos incompletos:** El Sistema exige completar campos obligatorios.

### Reglas de negocio
- **RN-1:** Cada alumno debe tener un identificador único en el sistema.
- **RN-2:** Un alumno puede estar asociado a uno o más cursos según configuración institucional.

### Datos principales
- **Alumno**(ID, nombre, identificador único, correo, cursos asociados, estado, timestamps).

### Consideraciones de seguridad/permiso
- Solo Administradores pueden registrar alumnos manualmente.

### No funcionales
- **Rendimiento:** creación de un alumno < 2s p95.
- **Disponibilidad:** registro inmediato para uso en evaluaciones.

### Criterios de aceptación (QA)
- **CA-1:** Al registrar un alumno válido, queda disponible en el curso correspondiente.
- **CA-2:** Si el identificador ya existe, el sistema bloquea la acción.
- **CA-3:** El registro queda registrado en auditoría. 