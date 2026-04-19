# RF6 — Publicación y consulta de resultados

**Descripción (alto nivel)**  
GRADE debe permitir la **publicación de resultados** de las evaluaciones ya calificadas y ofrecer mecanismos para su **consulta y exportación**, de forma segura y acorde a los permisos de cada rol.

**Alcance incluye**
- Publicación de calificaciones individuales y globales de cada evaluación.
- Visualización de **estadísticas básicas**: promedio, mediana, distribución de notas, desempeño por ítem.
- Exportación de resultados en formatos estándar (CSV, PDF).
- Control de acceso a resultados según **rol**:
    - Docentes → acceso a resultados de sus evaluaciones.
    - Coordinadores → acceso a estadísticas agregadas, no a respuestas individuales.
    - Administradores → acceso global, para auditoría o reportes.
- Registro de publicación y consultas en el historial de auditoría.

**No incluye (MVP)**
- Portales individuales para estudiantes.
- Analítica avanzada (correlaciones, tendencias históricas, dashboards predictivos).
- Comparativas interinstitucionales.

**Dependencias**
- RF1 (Ciclo de evaluación centralizado).
- RF5 (Calificación automática).
- RF7 (Roles y permisos).
- RF8 (Auditoría).
- RF10 (Reportes pedagógicos básicos).

**Criterios de aceptación (CA)**
1. El docente puede **publicar los resultados** de una evaluación ya calificada.
2. Los resultados publicados son **visibles inmediatamente** para usuarios con permiso.
3. El sistema muestra estadísticas básicas de la evaluación (promedio, mediana, etc.).
4. El usuario puede **exportar resultados** en CSV y PDF.
5. Coordinadores visualizan **datos agregados** (no respuestas individuales).
6. Todo evento de publicación/consulta queda **registrado en auditoría**.
7. Los permisos se aplican correctamente: nadie accede a información fuera de su rol.

**Riesgos/mitigaciones**
- Publicación prematura → confirmación obligatoria previa a publicar.
- Exposición indebida → control estricto de permisos + auditoría.
- Pérdida de datos en exportación → validación de formatos y pruebas de integridad.

---

[< Anterior](rf05-objective-items-automatic-grading.md) | [Inicio](../README.md#requerimientos-funcionales) | [Siguiente >](rf07-roles-and-permissions.md)