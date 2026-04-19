# CU-GE-16 — Publicar resultados de evaluación

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-11 | Publicar y consultar resultados

### RF relacionados: RF6, RF10, RF7, RF8

**Actor principal:** Docente  
**Actores secundarios:** Sistema GRADE, Estudiantes, Coordinador

---

### Objetivo
Permitir que un Docente publique los resultados de una evaluación en estado **Calificada**, para que los estudiantes puedan consultarlos y se habiliten estadísticas de desempeño.

### Precondiciones
- Evaluación en estado **Calificada** (CU-GE-14).
- Usuario autenticado con rol de Docente o Coordinador autorizado.

### Postcondiciones
- La evaluación pasa a estado **Publicado**.
- Los estudiantes pueden consultar sus resultados individuales.
- El sistema habilita estadísticas básicas de desempeño.
- El evento queda registrado en auditoría.

### Flujo principal (éxito)
1. El Docente accede a la evaluación en estado **Calificada**.
2. Selecciona la opción **“Publicar resultados”**.
3. El Sistema solicita confirmación.
4. El Docente confirma la acción.
5. El Sistema cambia el estado de la evaluación a **Publicado**.
6. El Sistema habilita la consulta de resultados por estudiantes y coordinadores.
7. El Sistema registra la acción en auditoría.
8. El Sistema confirma la publicación exitosa.

### Flujos alternativos / Excepciones
- **A1 — Evaluación ya publicada:** El Sistema informa que no puede volver a publicarse.
- **A2 — Evaluación no calificada:** El Sistema bloquea la acción y muestra advertencia.
- **A3 — Cancelación:** El Docente cancela y no se realizan cambios.

### Reglas de negocio
- **RN-1:** Solo evaluaciones en estado **Calificada** pueden publicarse.
- **RN-2:** Una vez publicada, no se puede revertir a estado anterior (solo posibles “rectificaciones” posteriores).
- **RN-3:** Los resultados deben estar disponibles únicamente para usuarios autorizados.

### Datos principales
- **Evaluación**(ID, curso, estado, resultados, estadísticas).
- **Auditoría**(usuario, acción, fecha/hora).

### Consideraciones de seguridad/permiso
- Solo Docentes responsables o Coordinadores autorizados pueden publicar resultados.
- Los estudiantes solo pueden acceder a sus propios resultados.

### No funcionales
- **Disponibilidad:** publicación inmediata tras la confirmación.
- **Seguridad:** protección de resultados para evitar accesos no autorizados.
- **Trazabilidad:** registro en auditoría de la publicación y accesos posteriores.

### Criterios de aceptación (QA)
- **CA-1:** Al publicar, el estado de la evaluación cambia a **Publicado**.
- **CA-2:** Los estudiantes pueden acceder únicamente a sus resultados.
- **CA-3:** El sistema genera estadísticas básicas automáticamente.
- **CA-4:** La acción queda registrada en auditoría.  