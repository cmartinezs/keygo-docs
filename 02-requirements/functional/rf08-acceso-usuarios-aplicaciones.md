[← Índice](../README.md) | [< Anterior](rf07-configuracion-aplicaciones-cliente.md) | [Siguiente >](rf09-roles-por-aplicacion.md)

---

# RF08 — Acceso de usuarios a aplicaciones

**Descripción**
El sistema debe permitir que el administrador de organización gestione qué usuarios tienen acceso a qué aplicaciones cliente, estableciendo la relación explícita entre un usuario y una aplicación dentro de la organización.

**Alcance incluye**
- Habilitación del acceso de un usuario a una aplicación cliente.
- Revocación del acceso de un usuario a una aplicación cliente.
- Consulta del listado de aplicaciones a las que tiene acceso un usuario.
- Consulta del listado de usuarios con acceso a una aplicación específica.
- Estado del acceso: activo, suspendido o invitado pendiente de aceptación.
- Propagación inmediata de la revocación: el usuario pierde acceso en sesiones activas de esa aplicación.

**No incluye (MVP)**
- Solicitud de acceso por parte del propio usuario.
- Aprobación de acceso mediante flujo de autorización entre partes.
- Acceso temporal con fecha de expiración automática.

**Dependencias**
- RF03 (Gestión de usuarios).
- RF06 (Registro de aplicaciones cliente).
- RF09 (Roles por aplicación).
- RF10 (Control de acceso basado en roles).
- RF14 (Gestión de sesiones).
- RF18 (Registro de eventos).
- RNF02 (Aislamiento entre organizaciones).

**Criterios de aceptación**
1. Un usuario sin acceso habilitado a una aplicación no puede autenticarse en ella aunque tenga credenciales válidas en la organización.
2. Al habilitar el acceso de un usuario a una aplicación, el cambio es efectivo para los flujos de autenticación subsiguientes.
3. Al revocar el acceso, las sesiones activas del usuario en esa aplicación son invalidadas de forma inmediata.
4. Un usuario solo puede tener acceso a aplicaciones de su propia organización.
5. El administrador puede consultar en todo momento el estado de acceso de cada usuario a cada aplicación.
6. Todas las modificaciones de acceso quedan registradas en el registro de auditoría (RF18).

**Riesgos y mitigaciones**
- Acceso residual tras revocación → la revocación invalida sesiones activas de forma inmediata, no solo al próximo intento de autenticación.
- Acceso cruzado entre organizaciones → el aislamiento de la organización (RNF02) garantiza que la relación usuario-aplicación es siempre dentro de la misma organización.

---

[← Índice](../README.md) | [< Anterior](rf07-configuracion-aplicaciones-cliente.md) | [Siguiente >](rf09-roles-por-aplicacion.md)
