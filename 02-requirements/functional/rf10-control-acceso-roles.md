[← Índice](../README.md) | [< Anterior](rf09-roles-por-aplicacion.md) | [Siguiente >](rf11-emision-credenciales-sesion.md)

---

# RF10 — Control de acceso basado en roles

**Descripción**
El sistema debe evaluar los roles asignados a un usuario en una aplicación cliente para determinar si tiene permiso de acceder a los recursos o ejecutar las acciones que solicita, garantizando que la autorización granular esté fundamentada en los roles declarados.

**Alcance incluye**
- Evaluación del acceso de un usuario a una aplicación en función de sus roles asignados.
- Inclusión de los roles del usuario en las credenciales de sesión emitidas para que la aplicación cliente pueda aplicar su propia lógica de autorización.
- Rechazo de solicitudes de acceso a aplicaciones en las que el usuario no tiene roles asignados o su acceso está revocado.
- Soporte para que aplicaciones cliente puedan consultar los roles vigentes de un usuario en tiempo de ejecución.

**No incluye (MVP)**
- Evaluación de permisos a nivel de recurso o acción específica dentro de la plataforma; esa lógica reside en cada aplicación cliente.
- Políticas de acceso condicional basadas en atributos del contexto (hora, ubicación, dispositivo).
- Delegación de autorización entre aplicaciones.

**Dependencias**
- RF08 (Acceso de usuarios a aplicaciones).
- RF09 (Roles por aplicación).
- RF11 (Emisión de credenciales de sesión).
- RF12 (Verificación de credenciales de sesión).

**Criterios de aceptación**
1. Un usuario sin roles asignados en una aplicación puede autenticarse, pero las credenciales de sesión reflejan la ausencia de roles.
2. Los roles asignados al usuario en el momento de la autenticación se incluyen en las credenciales de sesión emitidas para esa aplicación.
3. Si el acceso del usuario a la aplicación es revocado, las credenciales de sesión vigentes son invalidadas.
4. Una aplicación cliente puede verificar los roles de un usuario consultando sus credenciales de sesión sin necesidad de llamadas adicionales a la plataforma para el caso habitual.
5. Los roles reflejados en las credenciales corresponden al estado de asignación en el momento de su emisión.

**Riesgos y mitigaciones**
- Credenciales con roles desactualizados → la duración de las credenciales de sesión debe ser corta; la renovación refleja el estado actual de roles.
- Aplicación cliente que confía ciegamente en roles sin validar la vigencia de las credenciales → la plataforma provee mecanismos de verificación de vigencia que las aplicaciones deben utilizar (RF12).

---

[← Índice](../README.md) | [< Anterior](rf09-roles-por-aplicacion.md) | [Siguiente >](rf11-emision-credenciales-sesion.md)
