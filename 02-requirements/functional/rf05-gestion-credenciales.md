[← Índice](../README.md) | [< Anterior](rf04-autenticacion-usuarios.md) | [Siguiente >](rf06-registro-aplicaciones-cliente.md)

---

# RF05 — Gestión de credenciales

**Descripción**
El sistema debe permitir que los usuarios gestionen sus credenciales de acceso: cambio de contraseña cuando el usuario lo desea y recuperación de contraseña cuando el usuario ha perdido el acceso a su cuenta.

**Alcance incluye**
- Cambio de contraseña por parte del usuario autenticado.
- Solicitud de recuperación de contraseña para usuarios que no pueden autenticarse.
- Verificación de identidad previa a la recuperación, a través del correo electrónico registrado.
- Validación de la nueva contraseña contra las políticas mínimas definidas por la organización.
- Invalidación de las sesiones activas del usuario al cambiar su contraseña, como medida de seguridad.
- Expiración del enlace de recuperación tras un período definido o tras su uso.

**No incluye (MVP)**
- Recuperación de contraseña mediante preguntas de seguridad.
- Cambio de contraseña forzado por política de rotación periódica.
- Soporte a credenciales distintas de contraseña (biometría, passkeys, certificados).

**Dependencias**
- RF03 (Gestión de usuarios).
- RF04 (Autenticación de usuarios).
- RF02 (Configuración de la organización).
- RF14 (Gestión de sesiones).
- RF18 (Registro de eventos).

**Criterios de aceptación**
1. Un usuario autenticado puede cambiar su contraseña proporcionando la contraseña actual y una nueva que cumpla las políticas de la organización.
2. Al cambiar la contraseña, todas las sesiones activas del usuario son invalidadas de forma inmediata.
3. Un usuario no autenticado puede solicitar recuperación de contraseña a través de su correo registrado.
4. El enlace de recuperación es de uso único y expira después de un período definido.
5. La nueva contraseña establecida en la recuperación debe cumplir las políticas mínimas de la organización.
6. Todos los eventos de cambio o recuperación de contraseña quedan registrados en el registro de auditoría (RF18).

**Riesgos y mitigaciones**
- Enlace de recuperación interceptado → enlace de uso único con expiración corta; invalidado al ser utilizado.
- Contraseñas débiles aceptadas → validación obligatoria contra las políticas de la organización antes de aceptar el cambio.

---

[← Índice](../README.md) | [< Anterior](rf04-autenticacion-usuarios.md) | [Siguiente >](rf06-registro-aplicaciones-cliente.md)
