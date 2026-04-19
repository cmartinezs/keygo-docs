[← Índice](../README.md) | [< Anterior](rf08-acceso-usuarios-aplicaciones.md) | [Siguiente >](rf10-control-acceso-roles.md)

---

# RF09 — Roles por aplicación

**Descripción**
El sistema debe permitir definir roles específicos dentro de cada aplicación cliente y asignar esos roles a los usuarios que tienen acceso a dicha aplicación, habilitando así un control de acceso diferenciado por aplicación.

**Alcance incluye**
- Definición de roles propios de cada aplicación cliente dentro de la organización.
- Asignación de uno o más roles a un usuario con acceso a una aplicación.
- Revocación o modificación de roles asignados a un usuario en una aplicación.
- Consulta de los roles definidos para una aplicación y de los roles asignados a un usuario en ella.
- Los roles son independientes por aplicación: el mismo usuario puede tener roles distintos en aplicaciones distintas.

**No incluye (MVP)**
- Jerarquía de roles o herencia entre roles.
- Roles globales transversales a múltiples aplicaciones.
- Permisos o recursos asociados directamente a roles en la plataforma; esa lógica reside en cada aplicación.

**Dependencias**
- RF06 (Registro de aplicaciones cliente).
- RF08 (Acceso de usuarios a aplicaciones).
- RF10 (Control de acceso basado en roles).
- RF11 (Emisión de credenciales de sesión).
- RF18 (Registro de eventos).

**Criterios de aceptación**
1. El administrador puede crear, modificar y eliminar roles para cada aplicación cliente.
2. Un rol solo puede ser asignado a usuarios que ya tienen acceso habilitado a esa aplicación.
3. Los roles asignados a un usuario se incluyen en las credenciales de sesión emitidas para esa aplicación.
4. Al eliminar un rol de una aplicación, los usuarios que lo tenían asignado lo pierden automáticamente.
5. Los cambios en asignaciones de roles quedan registrados en el registro de auditoría (RF18).

**Riesgos y mitigaciones**
- Proliferación de roles sin gobierno → el administrador puede consultar y auditar todos los roles y sus asignaciones en cualquier momento.
- Credenciales de sesión desactualizadas con roles obsoletos → los roles se reflejan en las nuevas credenciales emitidas; las sesiones activas no se modifican retroactivamente salvo revocación explícita.

---

[← Índice](../README.md) | [< Anterior](rf08-acceso-usuarios-aplicaciones.md) | [Siguiente >](rf10-control-acceso-roles.md)
