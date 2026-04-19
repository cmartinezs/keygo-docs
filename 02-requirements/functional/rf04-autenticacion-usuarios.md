[← Índice](../README.md) | [< Anterior](rf03-gestion-usuarios.md) | [Siguiente >](rf05-gestion-credenciales.md)

---

# RF04 — Autenticación de usuarios

**Descripción**
El sistema debe verificar la identidad de los usuarios y permitirles iniciar una sesión autenticada en la plataforma, respetando las políticas de autenticación configuradas por la organización a la que pertenecen.

**Alcance incluye**
- Verificación de identidad mediante correo electrónico y contraseña.
- Aplicación de las políticas de autenticación de la organización del usuario: duración máxima de sesión, períodos de inactividad, requisitos mínimos de contraseña.
- Aplicación de las políticas de bloqueo configuradas por la organización: bloqueo temporal tras intentos fallidos consecutivos.
- Soporte a flujos de autenticación delegada: una aplicación cliente puede iniciar el flujo de autenticación en nombre del usuario.
- Notificación al usuario sobre intentos fallidos o bloqueos de su cuenta.
- Redirección al destino correcto tras la autenticación exitosa.

**No incluye (MVP)**
- Autenticación multifactor.
- Autenticación biométrica.
- Inicio de sesión con proveedores de identidad externos (federación).
- Autenticación sin contraseña (enlace mágico, passkeys).

**Dependencias**
- RF02 (Configuración de la organización).
- RF03 (Gestión de usuarios).
- RF05 (Gestión de credenciales).
- RF11 (Emisión de credenciales de sesión).
- RF14 (Gestión de sesiones).
- RF18 (Registro de eventos).

**Criterios de aceptación**
1. Un usuario activo puede autenticarse con sus credenciales correctas y obtiene acceso a la sesión.
2. Un usuario con credenciales incorrectas recibe un mensaje de error; tras el número de intentos configurados, su cuenta queda bloqueada temporalmente.
3. Un usuario suspendido no puede autenticarse, aunque sus credenciales sean correctas.
4. Las políticas de sesión de la organización (duración, inactividad) se aplican desde el momento en que la sesión es creada.
5. El sistema registra cada intento de autenticación (exitoso o fallido) en el registro de auditoría (RF18).
6. Un usuario cuya organización está suspendida no puede autenticarse.

**Riesgos y mitigaciones**
- Fuerza bruta sobre credenciales → política de bloqueo por intentos fallidos configurable por organización.
- Sesiones sin expiración → duración máxima y período de inactividad configurables y aplicados en todo momento.

---

[← Índice](../README.md) | [< Anterior](rf03-gestion-usuarios.md) | [Siguiente >](rf05-gestion-credenciales.md)
