[← Índice](../README.md) | [< Anterior](rf01-gestion-organizaciones.md) | [Siguiente >](rf03-gestion-usuarios.md)

---

# RF02 — Configuración de la organización

**Descripción**
El sistema debe permitir que cada organización configure sus parámetros operativos propios, incluyendo políticas de autenticación y opciones de personalización básica.

**Alcance incluye**
- Configuración de parámetros básicos de la organización: nombre, descripción, zona horaria y datos de contacto.
- Definición de políticas de autenticación propias de la organización: duración máxima de sesión, períodos de inactividad, requisitos mínimos de contraseña.
- Configuración de políticas de bloqueo de cuenta: número de intentos fallidos permitidos y duración del bloqueo.
- Gestión del estado de la configuración: la organización puede actualizar su configuración sin afectar sesiones activas en curso.

**No incluye (MVP)**
- Personalización visual (branding) de la experiencia de autenticación.
- Políticas de autenticación avanzadas más allá de contraseñas (factores adicionales, biometría).
- Configuración de dominios personalizados para la organización.

**Dependencias**
- RF01 (Gestión de organizaciones).
- RF04 (Autenticación de usuarios).
- RF05 (Gestión de credenciales).

**Criterios de aceptación**
1. El administrador de organización puede actualizar los parámetros básicos de su organización en cualquier momento.
2. Las políticas de autenticación configuradas se aplican a todos los usuarios de la organización en los flujos subsiguientes.
3. Un cambio en la política de duración de sesión no invalida sesiones activas existentes; aplica a las sesiones nuevas.
4. La configuración de cada organización es completamente independiente de la configuración de otras organizaciones.
5. Los cambios de configuración quedan registrados en el registro de auditoría (RF18) con el actor y el momento del cambio.

**Riesgos y mitigaciones**
- Configuración de políticas demasiado restrictivas que bloqueen a los propios usuarios → validación de rangos aceptables con advertencia antes de guardar.
- Inconsistencia entre política configurada y sesiones activas → aplicación prospectiva de cambios, sin efecto retroactivo.

---

[← Índice](../README.md) | [< Anterior](rf01-gestion-organizaciones.md) | [Siguiente >](rf03-gestion-usuarios.md)
