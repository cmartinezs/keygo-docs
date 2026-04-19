[← Índice](../README.md) | [Siguiente >](rf02-configuracion-organizacion.md)

---

# RF01 — Gestión de organizaciones

**Descripción**
El sistema debe permitir registrar, activar, suspender y eliminar organizaciones en la plataforma. Cada organización opera en un espacio completamente aislado desde su creación.

**Alcance incluye**
- Registro de una nueva organización con sus datos básicos de identificación.
- Activación de una organización recién registrada para que pueda comenzar a operar.
- Suspensión de una organización activa, lo que impide el acceso de sus usuarios y aplicaciones cliente sin eliminar sus datos.
- Eliminación definitiva de una organización y sus recursos asociados, sujeta a políticas de retención de datos.
- Gestión de un identificador único e inmutable por organización.
- Visibilidad del estado actual de cada organización (activa, suspendida, eliminada) para el administrador de la plataforma.

**No incluye (MVP)**
- Migración de datos entre organizaciones.
- Fusión o división de organizaciones.
- Aprovisionamiento automático de organizaciones desde sistemas externos.

**Dependencias**
- RF02 (Configuración de la organización).
- RF20 (Administración global de la plataforma).
- RNF02 (Aislamiento entre organizaciones).

**Criterios de aceptación**
1. El administrador de la plataforma puede registrar una organización nueva con los datos mínimos requeridos.
2. Una organización recién registrada queda en estado inactivo hasta que sea activada explícitamente.
3. Al activar una organización, su administrador puede comenzar a gestionar usuarios y aplicaciones cliente.
4. Al suspender una organización, todos sus usuarios y aplicaciones cliente quedan sin acceso de forma inmediata.
5. Los datos de una organización suspendida se conservan íntegramente y pueden restaurarse al reactivarla.
6. El identificador único de una organización no cambia ni se reasigna durante su ciclo de vida.
7. Cada acción sobre el ciclo de vida de una organización queda registrada en el registro de auditoría (RF18).

**Riesgos y mitigaciones**
- Eliminación accidental de organización con datos activos → confirmación explícita requerida y período de gracia antes de eliminación definitiva.
- Pérdida de datos al eliminar → política de retención configurable que preserve datos durante un período antes de la eliminación permanente.

---

[← Índice](../README.md) | [Siguiente >](rf02-configuracion-organizacion.md)
