[← Índice](../README.md) | [< Anterior](rf13-verificacion-publica-credenciales.md) | [Siguiente >](rf15-gestion-suscripciones.md)

---

# RF14 — Gestión de sesiones

**Descripción**
El sistema debe mantener el ciclo de vida de las sesiones autenticadas de los usuarios: permitir su creación, seguimiento, expiración natural y revocación explícita por cualquier actor autorizado.

**Alcance incluye**
- Creación de una sesión autenticada tras la autenticación exitosa del usuario.
- Seguimiento del estado de cada sesión activa: activa, expirada, revocada.
- Expiración automática de sesiones por tiempo de inactividad o duración máxima, según las políticas de la organización.
- Revocación de una sesión por parte del usuario (cierre de sesión).
- Revocación de sesiones por parte del administrador de organización para un usuario específico o para todos los usuarios.
- Revocación de todas las sesiones de un usuario cuando se cambia su contraseña, se suspende su cuenta o se le revoca el acceso a una aplicación.
- Consulta de las sesiones activas propias por parte del usuario.

**No incluye (MVP)**
- Sesiones persistentes entre dispositivos con sincronización en tiempo real.
- Notificación al usuario cuando una sesión es revocada por el administrador.
- Gestión de sesiones entre organizaciones.

**Dependencias**
- RF04 (Autenticación de usuarios).
- RF05 (Gestión de credenciales).
- RF08 (Acceso de usuarios a aplicaciones).
- RF11 (Emisión de credenciales de sesión).
- RF18 (Registro de eventos).
- RNF13 (Consistencia de credenciales de sesión).

**Criterios de aceptación**
1. Cada sesión autenticada tiene un identificador único y un estado rastreable.
2. Una sesión expira automáticamente al alcanzar la duración máxima o el período de inactividad configurado por la organización.
3. El usuario puede cerrar su sesión activa; el sistema la invalida de forma inmediata.
4. El administrador puede revocar las sesiones activas de un usuario sin necesidad de que el usuario actúe.
5. Al cambiar la contraseña de un usuario, todas sus sesiones activas son revocadas de forma inmediata.
6. Todos los eventos de creación, expiración y revocación de sesiones quedan registrados en el registro de auditoría (RF18).

**Riesgos y mitigaciones**
- Sesiones huérfanas que permanecen activas tras la suspensión de un usuario → la suspensión desencadena la revocación inmediata de todas las sesiones activas del usuario.
- Acumulación de sesiones no depuradas → expiración automática garantizada por tiempo; las sesiones expiradas no ocupan estado activo.

---

[← Índice](../README.md) | [< Anterior](rf13-verificacion-publica-credenciales.md) | [Siguiente >](rf15-gestion-suscripciones.md)
