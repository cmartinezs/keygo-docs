# RF7 — Roles y permisos

**Descripción (alto nivel)**  
GRADE debe soportar un modelo de **roles y permisos diferenciados** para garantizar la seguridad, gobernanza y claridad de responsabilidades en el uso del sistema.

**Alcance incluye**
- Definición de **roles principales**:
    - **Administrador**: gestión global del sistema, usuarios, parámetros y banco de preguntas.
    - **Coordinador**: creación de evaluaciones estandarizadas y acceso a estadísticas agregadas.
    - **Docente**: creación, gestión y calificación de sus propias evaluaciones.
- Control de accesos a funcionalidades según rol asignado.
- Prevención de conflictos de permisos (ej. un docente no puede modificar parámetros globales, un coordinador no accede a respuestas individuales).
- Posibilidad de que el Administrador gestione **altas, bajas y cambios de rol** de usuarios.
- Registro de toda acción de gestión de permisos en la auditoría.

**No incluye (MVP)**
- Roles adicionales como Soporte Técnico, Estudiantes o Padres (quedan fuera de esta fase).
- Personalización avanzada de permisos por usuario (se aplican permisos a nivel de rol).

**Dependencias**
- RF1 (Ciclo centralizado de evaluación).
- RF2 (Banco de preguntas).
- RF6 (Publicación de resultados).
- RF8 (Auditoría).

**Criterios de aceptación (CA)**
1. El sistema permite **asignar un rol** (Administrador, Coordinador, Docente) al crear un usuario.
2. Cada rol tiene **acceso restringido** a funcionalidades específicas.
3. El sistema impide realizar acciones fuera del rol (ej. docente no edita banco centralizado).
4. Los coordinadores pueden acceder solo a **estadísticas agregadas**, no a respuestas individuales.
5. Los administradores pueden **gestionar roles de usuarios** (crear, editar, desactivar).
6. Todas las acciones sobre roles y permisos se registran en la **auditoría**.

**Riesgos/mitigaciones**
- Accesos indebidos → validaciones de rol en cada acción crítica.
- Roles insuficientes → planificación para expansión futura de roles adicionales.
- Errores en gestión de permisos → auditoría + revisiones periódicas.

---

[< Anterior](rf06-results-publication-and-consulting.md) | [Inicio](../README.md#requerimientos-funcionales) | [Siguiente >](rf08-audit-and-traceability.md)