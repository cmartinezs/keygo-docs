[← Índice](../README.md) | [< Anterior](rf10-control-acceso-roles.md) | [Siguiente >](rf12-verificacion-credenciales-sesion.md)

---

# RF11 — Emisión de credenciales de sesión

**Descripción**
El sistema debe emitir credenciales de sesión al usuario o a la aplicación cliente tras una autenticación exitosa, de forma que la identidad, los roles y los ámbitos de acceso del usuario queden representados de manera verificable.

**Alcance incluye**
- Emisión de credenciales de acceso de corta duración tras la autenticación exitosa del usuario.
- Emisión de credenciales de renovación de mayor duración que permiten obtener nuevas credenciales de acceso sin requerir autenticación interactiva.
- Inclusión en las credenciales de acceso de la información relevante del usuario: organización, aplicación, roles asignados, ámbitos de acceso otorgados.
- Soporte a flujos de autenticación iniciados por aplicaciones de servidor, aplicaciones de navegador y servicios sin usuario interactivo.
- Emisión de credenciales de identidad que las aplicaciones pueden usar para conocer los atributos básicos del usuario autenticado.

**No incluye (MVP)**
- Emisión de credenciales con ámbitos de acceso personalizados por el usuario final en tiempo real (pantalla de consentimiento).
- Emisión de credenciales para aplicaciones de terceros no registradas en la organización.

**Dependencias**
- RF04 (Autenticación de usuarios).
- RF07 (Configuración de aplicaciones cliente).
- RF09 (Roles por aplicación).
- RF10 (Control de acceso basado en roles).
- RF14 (Gestión de sesiones).
- RNF12 (Gestión del ciclo de vida de claves).
- RNF13 (Consistencia de credenciales de sesión).

**Criterios de aceptación**
1. Tras una autenticación exitosa, el sistema emite credenciales de acceso y de renovación con los atributos correctos del usuario y la aplicación.
2. Las credenciales de acceso tienen una duración limitada, configurable según la aplicación cliente.
3. Las credenciales incluyen los roles vigentes del usuario en el momento de la emisión.
4. Las credenciales solo incluyen los ámbitos de acceso habilitados para la aplicación cliente.
5. Las credenciales de renovación solo pueden utilizarse una vez; cada uso genera un nuevo par de credenciales.
6. Las credenciales están firmadas de forma que cualquier verificador autorizado puede comprobar su autenticidad sin contactar a la plataforma.

**Riesgos y mitigaciones**
- Credenciales de renovación robadas → uso único y expiración; la detección de reutilización invalida la sesión completa.
- Credenciales con información excesiva → solo se incluyen los atributos estrictamente necesarios según la configuración de la aplicación y los ámbitos solicitados.

---

[← Índice](../README.md) | [< Anterior](rf10-control-acceso-roles.md) | [Siguiente >](rf12-verificacion-credenciales-sesion.md)
