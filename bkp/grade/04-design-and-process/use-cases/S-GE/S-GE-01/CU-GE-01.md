# CU-GE-01 — Crear curso

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-01 | Gestionar cursos

### RF relacionados: RF1, RF3, RF13

**Actor principal:** Coordinador / Administrador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Coordinador o Administrador registre un curso en el sistema para que pueda ser utilizado al asociar evaluaciones.

### Precondiciones
- Usuario autenticado con permisos de gestión académica.
- El curso no existe previamente en el catálogo.

### Postcondiciones
- El curso queda creado con identificador único.
- Aparece disponible en el catálogo para docentes y coordinadores.

### Flujo principal (éxito)
1. El Coordinador accede al módulo de gestión de cursos.
2. Selecciona la opción **“Crear curso”**.
3. El Sistema solicita información: nombre del curso, código, nivel y estado inicial.
4. El Coordinador completa la información y confirma.
5. El Sistema valida duplicados y consistencia.
6. El Sistema guarda el curso con identificador único.
7. El Sistema confirma creación exitosa.

### Flujos alternativos / Excepciones
- **A1 — Curso duplicado:** El Sistema bloquea la creación y muestra advertencia.
- **A2 — Datos incompletos:** El Sistema no permite guardar hasta completar campos obligatorios.

### Reglas de negocio
- **RN-1:** Los códigos de curso deben ser únicos.
- **RN-2:** Todo curso nuevo inicia en estado **Activo** salvo que se indique lo contrario.

### Datos principales
- **Curso**(ID, código, nombre, nivel, estado, timestamps).

### Consideraciones de seguridad/permiso
- Solo Coordinadores y Administradores pueden crear cursos.

### No funcionales
- **Rendimiento:** creación < 2s p95.
- **Usabilidad:** validación inmediata de duplicados.

### Criterios de aceptación (QA)
- **CA-1:** Al crear un curso válido, este aparece disponible en el catálogo.
- **CA-2:** Si el código ya existe, el sistema bloquea la acción.
- **CA-3:** La creación queda registrada en auditoría.