# CU-GE-17 — Consultar resultados y estadísticas

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-11 | Publicar y consultar resultados

### RF relacionados: RF6, RF10, RF7, RF8

**Actor principal:** Docente / Coordinador / Estudiante  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que Docentes, Coordinadores y Estudiantes consulten resultados de la evaluación publicada, con vistas diferenciadas según rol.

### Precondiciones
- Evaluación en estado **Publicado** (CU-GE-16).
- Usuario autenticado con rol válido (Docente, Coordinador o Estudiante).

### Postcondiciones
- El usuario visualiza resultados y estadísticas según su rol.
- El acceso queda registrado en auditoría.

### Flujo principal (éxito)
1. El Usuario accede al módulo de resultados.
2. El Sistema valida rol y permisos.
3. El Sistema muestra información según perfil:
    - **Docente:** resultados individuales y agregados, estadísticas detalladas.
    - **Coordinador:** resultados agregados y estadísticas generales, sin acceso a datos individuales.
    - **Estudiante:** su nota y desglose personal.
4. El Usuario consulta estadísticas y resultados.
5. El Sistema registra acceso en auditoría.

### Flujos alternativos / Excepciones
- **A1 — Usuario sin permisos:** El Sistema bloquea acceso e informa error.
- **A2 — Evaluación no publicada:** El Sistema informa que los resultados aún no están disponibles.

### Reglas de negocio
- **RN-1:** Cada rol tiene acceso diferenciado a resultados y estadísticas.
- **RN-2:** Los estudiantes solo pueden visualizar sus propios resultados.
- **RN-3:** Los accesos deben registrarse en auditoría para trazabilidad.

### Datos principales
- **Resultados**(ID alumno, nota, puntaje, desglose).
- **Estadísticas**(promedio, mediana, distribución de notas, desempeño por ítem).
- **Auditoría**(usuario, acción, fecha/hora).

### Consideraciones de seguridad/permiso
- Control de acceso basado en rol.
- Protección de información sensible de alumnos.

### No funcionales
- **Disponibilidad:** resultados accesibles inmediatamente tras publicación.
- **Rendimiento:** consulta de resultados < 3s p95 para hasta 200 alumnos.
- **Usabilidad:** interfaz clara con gráficos básicos y exportación.

### Criterios de aceptación (QA)
- **CA-1:** Los Docentes pueden ver resultados individuales y agregados.
- **CA-2:** Los Coordinadores acceden solo a estadísticas generales.
- **CA-3:** Cada Estudiante solo visualiza sus propios resultados.
- **CA-4:** Cada acceso queda registrado en auditoría.  