[← Índice](../README.md) | [< Anterior](rf02-configuracion-organizacion.md) | [Siguiente >](rf04-autenticacion-usuarios.md)

---

# RF03 — Gestión de usuarios

**Descripción**
El sistema debe permitir que el administrador de organización gestione de forma autónoma el ciclo de vida completo de los usuarios dentro de su organización: alta, modificación, suspensión, reactivación y baja.

**Alcance incluye**
- Creación de un nuevo usuario dentro de la organización con sus atributos básicos: correo electrónico, nombre, estado inicial.
- Invitación de usuarios: el sistema envía una notificación al correo del usuario invitado para que complete su registro.
- Modificación de atributos de un usuario existente (nombre, correo, estado).
- Suspensión de un usuario: el usuario pierde acceso de forma inmediata sin eliminar su información ni su historial.
- Reactivación de un usuario suspendido.
- Eliminación definitiva de un usuario, sujeta a políticas de retención de datos.
- Consulta del directorio de usuarios de la organización con filtros básicos (estado, nombre, correo).
- Un usuario pertenece siempre a exactamente una organización; no puede pertenecer a varias simultáneamente.

**No incluye (MVP)**
- Aprovisionamiento masivo de usuarios desde archivos externos o integraciones con directorios corporativos.
- Fusión de cuentas de usuario.
- Gestión de atributos extendidos o campos personalizados por organización.

**Dependencias**
- RF01 (Gestión de organizaciones).
- RF04 (Autenticación de usuarios).
- RF08 (Acceso de usuarios a aplicaciones).
- RF18 (Registro de eventos).
- RNF02 (Aislamiento entre organizaciones).

**Criterios de aceptación**
1. El administrador de organización puede crear un usuario nuevo con los atributos mínimos requeridos.
2. El usuario invitado recibe una notificación y debe completar su registro antes de poder autenticarse.
3. Al suspender un usuario, su acceso se revoca de forma inmediata en todas las sesiones activas.
4. Los datos de un usuario suspendido se conservan; al reactivarlo recupera sus roles y membresías previos.
5. El administrador no puede ver ni gestionar usuarios de otras organizaciones.
6. La eliminación de un usuario requiere confirmación explícita y no es reversible pasado el período de retención.
7. Todas las acciones sobre usuarios quedan registradas en el registro de auditoría (RF18).

**Riesgos y mitigaciones**
- Eliminación accidental de usuario activo → confirmación requerida y período de retención configurable antes de la eliminación permanente.
- Correo duplicado entre organizaciones → el correo electrónico es único dentro de una organización; puede existir en otras sin conflicto.

---

[← Índice](../README.md) | [< Anterior](rf02-configuracion-organizacion.md) | [Siguiente >](rf04-autenticacion-usuarios.md)
