[← Índice](../README.md) | [< Anterior](rf06-registro-aplicaciones-cliente.md) | [Siguiente >](rf08-acceso-usuarios-aplicaciones.md)

---

# RF07 — Configuración de aplicaciones cliente

**Descripción**
El sistema debe permitir que el administrador de organización configure los parámetros operativos de cada aplicación cliente registrada, definiendo qué puede hacer la aplicación y cómo puede interactuar con la plataforma.

**Alcance incluye**
- Configuración de las direcciones de retorno autorizadas para la aplicación, a las que la plataforma puede redirigir al usuario tras la autenticación.
- Definición de los ámbitos de acceso que la aplicación puede solicitar.
- Configuración del tipo de flujo de autenticación que la aplicación puede iniciar, según su naturaleza (aplicación de servidor, aplicación de navegador, aplicación de servicio).
- Configuración de la duración de las credenciales de sesión emitidas para la aplicación.
- Activación o desactivación de características opcionales por aplicación.

**No incluye (MVP)**
- Configuración de pantallas de consentimiento personalizadas por aplicación.
- Definición de políticas de acceso condicional por aplicación.
- Configuración de dominios personalizados por aplicación.

**Dependencias**
- RF06 (Registro de aplicaciones cliente).
- RF11 (Emisión de credenciales de sesión).
- RF18 (Registro de eventos).

**Criterios de aceptación**
1. El administrador puede actualizar la configuración de una aplicación cliente en cualquier momento.
2. Solo las direcciones de retorno explícitamente registradas son aceptadas durante los flujos de autenticación.
3. La aplicación solo puede solicitar ámbitos de acceso que le hayan sido habilitados en su configuración.
4. Cambios en la configuración no afectan sesiones activas; aplican a los flujos nuevos.
5. Los cambios de configuración quedan registrados en el registro de auditoría (RF18).

**Riesgos y mitigaciones**
- Redirección a destinos no autorizados → solo se permiten las direcciones de retorno registradas explícitamente.
- Aplicación con ámbitos excesivos → el administrador debe declarar explícitamente cada ámbito habilitado; no hay habilitación implícita.

---

[← Índice](../README.md) | [< Anterior](rf06-registro-aplicaciones-cliente.md) | [Siguiente >](rf08-acceso-usuarios-aplicaciones.md)
