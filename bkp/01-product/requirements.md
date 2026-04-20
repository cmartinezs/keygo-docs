# Requerimientos del Producto — KeyGo

> **Propósito**: Especificación funcional agnóstica de tecnología que define QUÉ debe hacer el sistema, sin prescribir CÓMO implementarlo.  
> Esta especificación se escribe como si fuera una solicitud nueva, sin asumir que nada existe aún.

**Última actualización:** 2026-04-19

---

## Introducción

KeyGo es una plataforma de autenticación, autorización y gestión de identidad para organizaciones multi-tenant. Esta sección especifica los requisitos funcionales (RF) que el sistema debe cumplir y los requisitos no-funcionales (RNF) que definen cómo debe comportarse en términos de calidad, rendimiento, seguridad y confiabilidad.

---

## SECCIÓN 1: REQUISITOS FUNCIONALES (RF)

Los Requisitos Funcionales describen las capacidades que el sistema debe proporcionar desde la perspectiva del usuario. Responden a la pregunta: ¿Qué debe hacer el sistema?

### **A. AUTENTICACIÓN & AUTORIZACIÓN**

**Contexto**: Los usuarios necesitan acceder de forma segura. Las aplicaciones cliente necesitan solicitar acceso controlado a información del usuario. Las organizaciones necesitan aislar completamente los datos de un usuario según su afiliación organizacional.

#### Flujo Inicial: Ciclo de Vida de Autenticación

```
[Usuario Nuevo] 
   ↓
[Registro: Email + Contraseña] 
   ↓
[Sistema envía verificación por email]
   ↓
[Usuario verifica email]
   ↓
[Usuario logueado: Sesión activa]
   ↓
[Usuario solicita renovación o cierre de sesión]
   ↓
[Sesión termina]

---

Flujo alternativo (usuario olvida contraseña):
[Usuario visita "Contraseña Olvidada"]
   ↓
[Ingresa email]
   ↓
[Sistema envía link de recuperación]
   ↓
[Usuario hace clic y establece nueva contraseña]
   ↓
[Sesiones previas se invalidan]
   ↓
[Usuario puede loguearse con nueva contraseña]
```

#### RF-A1: Registro de Nuevos Usuarios

**Descripción**: Un usuario que no existe en el sistema debe poder crear una cuenta nueva.

**Qué sucede**:
- El usuario proporciona: email, contraseña, nombre completo
- El sistema valida que el email no esté registrado previamente
- El sistema valida que la contraseña cumpla criterios mínimos de seguridad (longitud, complejidad)
- El sistema registra al usuario en estado "pendiente de verificación de email"
- El sistema genera un enlace único de verificación y lo envía al email proporcionado
- El usuario recibe el email y debe hacer clic en el enlace para verificar que es propietario del email
- El usuario debe completar la verificación dentro de un período específico (ej: 24 horas)
- Una vez verificado, el usuario pasa a estado "activo" y puede iniciar sesión
- Si el enlace de verificación expira, el usuario puede solicitar uno nuevo

**Restricciones**:
- Cada email puede estar registrado solo una vez en el sistema
- La verificación de email es obligatoria antes de poder iniciar sesión
- El usuario no puede iniciar sesión hasta verificación completada
- El registro debe ser resistente a enumeración (no revelar si un email ya existe)

---

#### RF-A2: Inicio de Sesión (Autenticación con Credenciales)

**Descripción**: Un usuario registrado debe poder iniciar sesión usando email y contraseña.

**Qué sucede**:
- El usuario accede a la pantalla de login
- El usuario proporciona: email y contraseña
- El sistema verifica que exista un usuario con ese email
- El sistema verifica que la contraseña es correcta
- Si ambas son válidas:
  - El sistema crea una sesión activa para el usuario
  - El usuario recibe un identificador de sesión (válido por un período específico)
  - El usuario es autenticado y puede acceder a recursos protegidos
- Si el email o contraseña son incorrectos:
  - El sistema rechaza la solicitud
  - El sistema NO revela cuál es incorrecto (email o contraseña) — protección anti-enumeración
  - El usuario ve un mensaje genérico: "Email o contraseña incorrectos"
- El sistema puede limitar intentos fallidos consecutivos:
  - Después de N intentos fallidos (ej: 5), la cuenta se bloquea temporalmente
  - El bloqueo es temporal (ej: 15 minutos)
  - Se notifica al usuario por email si su cuenta fue bloqueada

**Restricciones**:
- Solo usuarios en estado "activo" pueden iniciar sesión
- Usuarios suspendidos, eliminados, o no verificados no pueden iniciar sesión
- La contraseña es específica a cada usuario
- Múltiples intentos fallidos resultan en protección adicional contra ataques de fuerza bruta

---

#### RF-A3: Gestión de Sesiones Activas

**Descripción**: Una sesión iniciada debe poder mantenerse, renovarse, y monitorearse sin re-autenticación.

**Qué sucede**:
- Cuando un usuario inicia sesión, recibe un identificador de sesión válido por un período específico (ej: 15 minutos para sesión corta, 30 días para sesión renovable)
- El usuario puede usar este identificador para acceder a recursos protegidos durante ese período
- El usuario puede ver una lista de todas sus sesiones activas:
  - Información: dispositivo, navegador, ubicación geográfica, fecha/hora de inicio
  - El usuario puede identificar si hay sesiones que no reconoce (indicativo de acceso no autorizado)
- El usuario puede terminar una sesión específica manualmente
- El usuario puede terminar todas sus sesiones simultáneamente
- Las sesiones expiran automáticamente después de:
  - Un período de validez absoluta (ej: 30 días máximo)
  - Un período de inactividad (ej: 1 hora sin actividad)
- Cuando una sesión está por vencer, el usuario puede solicitar una renovación:
  - La renovación extiende la validez de la sesión sin que el usuario deba proporcionar credenciales nuevamente
  - Solo es posible renovar dentro de una ventana de tiempo específica (ej: últimos 3 días antes de expiración)
  - Si la renovación es exitosa, la sesión anterior se invalida automáticamente
- Si una sesión es invalidada (usuario la termina, expira, o se renueva), accesos posteriores con esa sesión son rechazados

**Restricciones**:
- Una sesión no puede extender su validez indefinidamente; hay un máximo absoluto
- Una sesión expirada no puede ser reutilizada
- La renovación solo es posible dentro de una ventana específica para evitar uso indebido
- Un usuario no puede ver sesiones de otros usuarios

---

#### RF-A4: Cierre de Sesión (Logout)

**Descripción**: Un usuario debe poder terminar su sesión voluntariamente.

**Qué sucede**:
- El usuario solicita cerrar sesión (ej: hace clic en botón "Logout")
- El sistema invalida inmediatamente el identificador de sesión del usuario
- Si el usuario había solicitud una renovación de sesión pendiente, esta se cancela
- El usuario es redirigido a una página pública o de login
- El usuario ya no puede usar ese identificador de sesión para acceder a recursos protegidos
- La actividad de cierre de sesión es registrada para auditoría:
  - Hora exacta de cierre
  - Duración de la sesión
  - Dispositivo/navegador usado
  - Actividad realizada durante la sesión (acciones)

**Restricciones**:
- El cierre de sesión es irreversible; no puede "re-activarse" una sesión cerrada
- El sistema debe garantizar que la invalidación sea inmediata

---

#### RF-A5: Recuperación de Acceso (Contraseña Olvidada)

**Descripción**: Un usuario que olvida su contraseña debe poder restablecerla sin perder su cuenta.

**Qué sucede**:
- El usuario hace clic en "¿Olvidaste tu contraseña?" en la pantalla de login
- El usuario proporciona su email
- El sistema verifica internamente si existe un usuario con ese email
- **Independientemente de si el usuario existe o no**, el sistema muestra un mensaje genérico:
  - "Si ese email existe en el sistema, recibirás instrucciones de recuperación en unos minutos"
  - Protección anti-enumeración: un atacante no puede saber qué emails están registrados
- Si el usuario existe:
  - El sistema genera un enlace único y temporalmente válido para restablecimiento
  - El enlace es válido por un período específico (ej: 1 hora)
  - El sistema envía el enlace por email
  - Solo puede haber un enlace activo por usuario a la vez; generar uno nuevo invalida los anteriores
- Cuando el usuario hace clic en el enlace:
  - El sistema verifica que el enlace sea válido y no haya expirado
  - El usuario es llevado a una página segura para establecer nueva contraseña
  - El usuario proporciona una nueva contraseña
  - El sistema valida que cumpla criterios de seguridad
  - El sistema valida que la nueva contraseña no sea idéntica a las últimas N contraseñas (no reutilizar)
  - Si es válida, se actualiza la contraseña
  - **Todas las sesiones activas del usuario son invalidadas** (debe iniciar sesión nuevamente con nueva contraseña)
- El usuario recibe un email de confirmación del cambio exitoso

**Restricciones**:
- Solo un enlace de recuperación puede estar activo a la vez
- El enlace expira después del período especificado
- No se puede reutilizar un enlace ya utilizado
- La nueva contraseña no puede ser idéntica a contraseñas anteriores
- Usuarios suspendidos no pueden recuperar acceso

---

#### RF-A6: Cambio de Contraseña (Usuario Autenticado)

**Descripción**: Un usuario autenticado debe poder cambiar su contraseña en cualquier momento.

**Qué sucede**:
- El usuario accede a su configuración/perfil de cuenta
- El usuario navega a la sección "Cambiar contraseña"
- El usuario proporciona:
  - Contraseña actual (verificación de identidad)
  - Nueva contraseña (deseada)
  - Confirmación de nueva contraseña
- El sistema valida:
  - Que la contraseña actual sea correcta (protección contra acceso no autorizado a la cuenta)
  - Que la nueva contraseña cumple criterios mínimos de seguridad
  - Que la nueva contraseña no es idéntica a las últimas N contraseñas
  - Que nueva contraseña ≠ nueva confirmación iguales
- Si todo es válido:
  - La contraseña se actualiza
  - **La sesión actual del usuario permanece válida** (no es desconectado)
  - El usuario recibe confirmación por email
- Si hay error:
  - El sistema muestra mensaje de error específico (ej: "Contraseña actual es incorrecta")

**Restricciones**:
- Requiere que el usuario esté autenticado
- La contraseña anterior no puede reutilizarse inmediatamente (ventana de espera ej: 24 horas o N cambios posteriores)
- El cambio es inmediato; no requiere confirmación adicional por email

---

#### RF-A7: Políticas de Fortaleza de Contraseña

**Descripción**: El sistema debe garantizar que las contraseñas sean lo suficientemente fuertes.

**Qué sucede**:
- El sistema define requisitos mínimos de contraseña:
  - Longitud mínima (ej: 12 caracteres)
  - Debe contener mayúsculas (A-Z)
  - Debe contener minúsculas (a-z)
  - Debe contener números (0-9)
  - Debe contener caracteres especiales (!@#$%^&*)
- Durante registro o cambio de contraseña:
  - El usuario recibe retroalimentación en tiempo real sobre fortaleza de su contraseña (indicador visual: débil, regular, fuerte)
  - El sistema rechaza contraseñas que no cumplen requisitos mínimos
  - El sistema rechaza contraseñas en listas de contraseñas comúnmente usadas (top 10,000 contraseñas)
- Las contraseñas:
  - Se almacenan de forma irreversible (no pueden ser recuperadas ni por administradores)
  - Si se detecta que una contraseña fue comprometida en una filtración pública conocida, el usuario es notificado
  - El usuario puede ser requerido a cambiar su contraseña si fue comprometida
- El sistema puede implementar rotación de contraseña:
  - Políticas configurables por organización (ej: cambio obligatorio cada 90 días)
  - Si está habilitado, el usuario es notificado y requerido a cambiar antes de fecha límite
  - La sesión actual permanece válida incluso si contraseña cambió

**Restricciones**:
- No se puede revelar al usuario qué contraseñas anteriores tenía
- Requisitos de fortaleza deben ser suficientemente fuertes pero prácticos (no imposibles)
- Las notificaciones de compromiso no deben revelar contraseña actual

---

#### RF-A8: Verificación de Email

**Descripción**: Un usuario debe verificar que es propietario del email que proporcionó.

**Qué sucede**:
- Durante el registro, después de proporcionar datos básicos:
  - El sistema envía un email de verificación con un enlace único
  - El enlace es válido por un período específico (ej: 24 horas)
  - El usuario está en estado "pendiente de verificación"
- Cuando el usuario hace clic en el enlace:
  - El sistema verifica que el enlace sea válido y no haya expirado
  - El email es marcado como "verificado"
  - El usuario pasa a estado "activo"
  - El usuario puede ahora iniciar sesión
- Si el enlace expira sin ser usado:
  - El usuario puede solicitar un nuevo email de verificación
  - El sistema genera un nuevo enlace y lo envía
  - El enlace anterior se invalida automáticamente
- Si el usuario proporciona un email diferente antes de verificar:
  - El email anterior es descartado
  - Se envía un nuevo email de verificación para el nuevo email
  - El usuario debe verificar el nuevo email antes de poder usar la cuenta
- El usuario no puede cambiar su email a un email que:
  - Ya está verificado y en uso en el sistema
  - Está pendiente de verificación por otro usuario

**Restricciones**:
- Verificación es obligatoria antes de poder usar la plataforma
- Cada email tiene solo una sesión de verificación pendiente activa
- El usuario puede no estar registrado en la aplicación (sesión no iniciada) pero aún hacer clic en el enlace de verificación

---

#### RF-A9: Autorización Granular por Scopes

**Descripción**: Una aplicación cliente debe poder solicitar acceso específico a información del usuario, y el usuario debe controlar qué información comparte.

**Qué sucede**:
- Una aplicación cliente integrada con KeyGo define scopes (permisos) que necesita:
  - Lectura de perfil básico (nombre, email)
  - Lectura de información de organización
  - Escritura de datos
  - Acceso a rol del usuario
  - Etc.
- Cuando un usuario intenta usar una aplicación cliente:
  - La aplicación redirige al usuario al servidor de autorización
  - El usuario ve una pantalla de consentimiento listando explícitamente:
    - Nombre de la aplicación solicitante
    - Qué información la aplicación desea acceder (scopes)
    - Una descripción clara de cada scope
    - Opción para aceptar todo, rechazar todo, o aceptar selectivamente
- El usuario puede:
  - Aceptar todos los scopes solicitados
  - Rechazar toda la solicitud
  - Aceptar solo algunos scopes y rechazar otros
- Si acepta (total o parcialmente):
  - El sistema registra la autorización
  - La aplicación recibe credenciales que le permiten acceder solo a información autorizada
  - La aplicación NO puede acceder a información que el usuario rechazó
- El usuario puede ver en cualquier momento en su perfil:
  - Qué aplicaciones ha autorizado
  - Qué scopes autorizó para cada aplicación
  - Cuándo fue autorizada
  - Última fecha de acceso
- El usuario puede revocar autorización:
  - Revocación es inmediata; la aplicación pierde acceso instantáneamente
  - Requests posteriores de la aplicación son rechazados
- Una aplicación puede solicitar scopes adicionales en el futuro:
  - Esto requiere autorización adicional del usuario (aparece nueva pantalla de consentimiento)
  - El usuario puede autorizar los nuevos scopes, rechazarlos, o autorizar solo algunos

**Restricciones**:
- Una aplicación no puede acceder a información que el usuario no autorizó explícitamente
- La autorización es granular por scope; no es un "todo o nada" por aplicación
- Una aplicación no puede cambiar los scopes que solicitó sin intervención del usuario

---

#### RF-A10: Autenticación de Aplicaciones (Client Credentials - Servicio a Servicio)

**Descripción**: Una aplicación cliente puede autenticarse en su propio nombre (sin usuario final) para realizar operaciones en nombre de la organización.

**Qué sucede**:
- Un administrador de la organización accede a la sección de "Aplicaciones"
- El administrador registra una nueva aplicación cliente proporcionando:
  - Nombre de la aplicación
  - Descripción
  - URLs de redirección permitidas (si es relevante)
- El sistema genera y proporciona:
  - Client ID (identificador público de la aplicación)
  - Client Secret (credencial confidencial, mostrada solo una vez)
  - El administrador debe guardar el secret de forma segura (ej: variable de entorno, vault)
- La aplicación almacena estas credenciales de forma segura en su infraestructura
- Cuando la aplicación necesita acceso a recursos:
  - La aplicación proporciona: client_id y client_secret
  - El sistema verifica ambas credenciales
  - Si son válidas, el sistema emite un token de acceso válido por un período específico (ej: 1 hora)
  - Este token permite a la aplicación acceder a recursos permitidos para aplicaciones (no datos de usuario final)
- Client Secret:
  - Es confidencial como una contraseña
  - Si se compromete, debe ser rotado inmediatamente
  - Se pueden generar múltiples secrets simultáneamente para facilitar rotación sin downtime
  - Secrets viejos pueden ser revocados en cualquier momento
- La aplicación puede solicitar acceso a diferentes alcances (scopes) según su función

**Restricciones**:
- Solo aplicaciones registradas pueden usar este flujo
- El secret debe protegerse como una credencial de máquina
- No hay usuario final involucrado; el acceso es "de aplicación a plataforma"
- La aplicación heredará permisos de su rol (si aplica)

---

#### RF-A11: Autorización Basada en Roles (RBAC)

**Descripción**: Los permisos de un usuario dentro de su organización deben basarse en los roles asignados.

**Qué sucede**:
- Cada usuario tiene uno o más roles asignados dentro de su organización
- El sistema define roles estándar:
  - **USER**: Usuario estándar, sin derechos administrativos
    - Puede ver su propio perfil
    - Puede cambiar su contraseña
    - Puede gestionar sus sesiones activas
    - Puede autorizar/revocar aplicaciones
    - Puede ver sus propios logs de actividad
  - **ADMIN**: Administrador de la organización, derechos completos
    - Hereda todos los permisos de USER
    - Puede crear y eliminar usuarios
    - Puede asignar roles a usuarios
    - Puede suspender/reactivar usuarios
    - Puede ver reportes de la organización
    - Puede registrar/eliminar aplicaciones cliente
    - Puede ver logs de actividad de toda la organización
    - Puede cambiar configuración de la organización
    - Puede ver billing e historial de pagos
    - Puede cambiar plan de suscripción
- La asignación de rol es:
  - Específica por usuario y por organización
  - Un usuario puede tener roles diferentes en diferentes organizaciones
  - Un usuario no puede cambiar su propio rol (requiere otro ADMIN)
  - Los cambios de rol son inmediatos; afectan solicitudes posteriores
- El sistema evalúa permisos en cada solicitud:
  - Si un usuario intenta una acción que requiere un permiso que no tiene, es rechazado con error "No autorizado"
  - El error no revela qué permiso específico le falta

**Restricciones**:
- Cada usuario debe tener al menos un rol; no puede estar sin rol
- Un usuario no puede ser demotido a sí mismo
- Los roles y permisos asociados son predefinidos; no se pueden crear roles personalizados (por ahora)

---

#### RF-A12: Aislamiento Completo de Datos por Organización (Multi-Tenancy)

**Descripción**: Los datos de un usuario/organización deben estar completamente aislados de otros usuarios/organizaciones.

**Qué sucede**:
- El sistema soporta múltiples organizaciones (tenants) operando simultáneamente
- Cada organización tiene aislada:
  - Sus usuarios y sus datos
  - Sus aplicaciones cliente registradas
  - Sus roles, permisos, configuración
  - Sus datos de billing, facturas, pagos
  - Sus logs y auditoría
- Un usuario puede ser miembro de múltiples organizaciones, pero:
  - Cada afiliación es una identidad separada
  - Un email puede estar registrado en múltiples organizaciones (con identidades separadas)
  - Si un usuario es miembro de organización A y organización B, NO puede acceder a datos de A desde organización B
  - El usuario debe "cambiar de contexto organizacional" (logout y login en la otra organización)
- Las credenciales (tokens de sesión) de una organización:
  - NO funcionan en otra organización
  - Incluyen identificador de organización internamente
- La verificación de aislamiento ocurre en cada operación:
  - Es imposible acceder a datos de otra organización incluso con token válido
  - Si se intenta, la solicitud es rechazada
- Reportes, logs y auditoría están separados por organización:
  - Un usuario no puede ver logs de otras organizaciones
  - Administrador de organización A no puede ver actividad de organización B
- Las claves criptográficas usadas son diferentes por organización:
  - Tokens de diferentes organizaciones no pueden ser reutilizados entre sí

**Restricciones**:
- No hay operación que exponga datos de múltiples organizaciones en una sola solicitud
- Un usuario no puede ser ADMIN de dos organizaciones simultáneamente (conflicto de intereses)
- La organización es el límite superior de aislamiento (no hay sub-organizaciones)

---

### **B. GESTIÓN DE ORGANIZACIONES (TENANTS)**

**Contexto**: Administradores de plataforma necesitan crear y gestionar organizaciones. Administradores de organización necesitan gestionar sus usuarios y aplicaciones internas.

#### Flujo Inicial: Ciclo de Vida de una Organización

```
[Administrador de Plataforma crea Organización]
   ↓
[Sistema genera ID único, asigna administrador inicial]
   ↓
[Organización en estado "activa"]
   ↓
[Administrador Org: gestiona usuarios, aplicaciones, billing]
   ↓
[Organización crece: más usuarios, más aplicaciones]
   ↓
[Administrador Plataforma: puede suspender/eliminar la Org]
   ↓
[Organización en estado "suspendida" o "eliminada"]
```

#### RF-B1: Creación de Organizaciones

**Descripción**: Un administrador de plataforma debe poder crear nuevas organizaciones.

**Qué sucede**:
- Un administrador de plataforma accede a la sección de administración de organizaciones
- El administrador proporciona información básica:
  - Nombre de la organización
  - Email de contacto principal
  - Ubicación/país
  - Tipo de industria (opcional)
- El sistema genera:
  - Identificador único para la organización (slug, UUID)
  - Configuración por defecto (idioma, zona horaria, plan)
- El sistema crea la organización en estado "activa"
- El administrador puede asignar un usuario existente como administrador inicial de la organización
  - O crear un nuevo usuario asignándole rol ADMIN en la organización
- La organización es creada con datos completamente aislados

**Restricciones**:
- El nombre de la organización debe ser único
- La organización debe tener al menos un administrador
- Solo administradores de plataforma pueden crear organizaciones

---

#### RF-B2: Gestión de Usuarios por Administrador de Organización

**Descripción**: Un administrador de organización debe poder gestionar los usuarios de su organización.

**Qué sucede**:
- El administrador accede a la sección "Usuarios" de su organización
- El administrador puede ver una lista de todos los usuarios con:
  - Nombre, email
  - Rol asignado
  - Fecha de creación
  - Último login
  - Estado (activo, suspendido, no verificado)
- El administrador puede agregar nuevos usuarios:
  - Proporciona email del usuario
  - El sistema envía una invitación al email
  - El usuario recibe el link de invitación (válido por 7 días)
  - El usuario hace clic, completa registro, verifica email
  - El usuario queda activo en la organización
- El administrador puede eliminar usuarios:
  - El usuario es eliminado permanentemente
  - Si el usuario estaba logueado, sus sesiones se invalidan
  - El usuario puede volver a registrarse después
- El administrador puede suspender usuarios:
  - El usuario suspendido no puede iniciar sesión
  - Las sesiones activas se invalidan inmediatamente
  - El usuario puede ser reactivado después
- El administrador puede asignar/cambiar roles a usuarios:
  - Selecciona el usuario
  - Cambia su rol (USER o ADMIN)
  - El cambio es inmediato; afecta solicitudes posteriores del usuario
  - El administrador no puede cambiar su propio rol

**Restricciones**:
- Un administrador no puede cambiar su propio rol (requiere otro ADMIN)
- Una organización debe tener al menos un ADMIN
- El administrador no puede ejecutar acciones en usuarios de otras organizaciones

---

#### RF-B3: Roles Diferenciados dentro de una Organización

**Descripción**: Existen roles predefinidos con permisos diferentes dentro de cada organización.

**Qué sucede** (ver RF-A11 para detalles de permisos):
- El sistema define dos roles estándar:
  - **USER**: Acceso limitado, solo autoservicio
  - **ADMIN**: Acceso completo de administración
- Cada rol tiene asociado un conjunto de permisos
- Los permisos se evalúan en tiempo de solicitud
- No se pueden crear roles personalizados (scope actual)

**Restricciones**:
- Los roles son predefinidos; no hay flexibilidad por ahora
- Un usuario debe tener al menos un rol

---

#### RF-B4: Registro de Aplicaciones Cliente

**Descripción**: Un administrador de organización debe poder registrar aplicaciones cliente que usan OAuth2.

**Qué sucede**:
- El administrador accede a la sección "Aplicaciones" de su organización
- El administrador puede ver una lista de aplicaciones registradas con:
  - Nombre de la aplicación
  - Client ID
  - URLs de redirección configuradas
  - Fecha de creación
  - Última actividad
  - Estado (activa, deshabilitada)
- Para registrar una nueva aplicación:
  - El administrador proporciona:
    - Nombre de la aplicación
    - Descripción
    - URLs de redirección permitidas (para OAuth2)
    - Tipo de aplicación (web, mobile, desktop, etc.)
  - El sistema genera:
    - Client ID (público)
    - Client Secret (confidencial, mostrado solo una vez)
  - El administrador guarda el secret de forma segura
- Para Client Credentials (servicio a servicio):
  - El administrador puede generar múltiples secrets para la misma aplicación
  - Esto facilita rotación sin downtime
  - Los secrets viejos se pueden revocar
- El administrador puede:
  - Editar configuración de la aplicación (nombre, URLs)
  - Deshabilitar una aplicación (usuarios no pueden autorizarla)
  - Eliminar una aplicación (revocar todos los accesos)
  - Ver estadísticas de uso (cuántos usuarios la usan, actividad reciente)
  - Ver logs de autorización

**Restricciones**:
- Solo ADMIN puede registrar aplicaciones
- El Client Secret es confidencial; debe guardarse seguro
- Las URLs de redirección deben ser HTTPS (excluir localhost para desarrollo)
- Una aplicación debe tener al menos una URL de redirección válida

---

#### RF-B5: Estadísticas y Reportes de Uso

**Descripción**: Administradores deben poder ver estadísticas de uso de su organización.

**Qué sucede**:
- El administrador accede al dashboard de su organización
- Puede ver:
  - **Usuarios activos**: Cantidad de usuarios, desglose por rol
  - **Actividad reciente**: Últimos logins, cambios de configuración, etc.
  - **Aplicaciones**: Cantidad de aplicaciones registradas, accesos por aplicación
  - **Sessions**: Cantidad de sesiones activas, dispositivos únicos
  - **Billing**: Plan actual, próxima fecha de renovación, uso de cuota (si aplica)
  - **Logs**: Historial de actividades filtrables por tipo (login, cambios, etc.)
- Los reportes pueden ser:
  - En tiempo real (dashboard)
  - Históricos (últimos 7, 30, 90 días)
  - Exportables (CSV)
- El administrador puede ver:
  - Quién se logueó y cuándo
  - Quién cambió configuración y qué cambió
  - Qué aplicaciones fueron autorizadas
  - Si hay accesos sospechosos

**Restricciones**:
- Solo ADMIN puede ver reportes
- Los reportes son específicos a su organización
- Los datos históricos se retienen por un período mínimo (ej: 90 días)

---

#### RF-B6: Suspensión y Eliminación de Organizaciones

**Descripción**: Un administrador de plataforma debe poder suspender o eliminar organizaciones.

**Qué sucede**:
- El administrador de plataforma puede:
  - **Suspender una organización**:
    - Todos los usuarios de la organización son automáticamente suspendidos
    - Todas las sesiones activas se invalidan
    - Ningún usuario puede iniciar sesión
    - Las aplicaciones cliente no pueden usar OAuth2
    - Los datos se conservan
    - Puede ser reactivada
  - **Eliminar una organización**:
    - Todos los datos de la organización se eliminan permanentemente (usuarios, aplicaciones, logs)
    - No puede ser reversible
    - Se requiere confirmación adicional

**Restricciones**:
- Solo administradores de plataforma pueden suspender/eliminar
- La suspensión de una organización afecta a todos sus usuarios inmediatamente

---

### **C. BILLING & SUSCRIPCIONES**

**Contexto**: Las organizaciones necesitan suscribirse a planes para usar la plataforma. La plataforma necesita generar facturas y procesar pagos.

#### Flujo Inicial: Ciclo de Vida de Suscripción

```
[Organización nueva sin plan]
   ↓
[Administrador selecciona plan (Free/Pro/Enterprise)]
   ↓
[Sistema registra suscripción, genera factura]
   ↓
[Plan de pago: requiere pago válido]
   ↓
[Procesamiento de pago]
   ↓
[Pago exitoso: Organización accede a características del plan]
   ↓
[Período de suscripción vence]
   ↓
[Renovación automática (si está habilitada)]
   ↓
[Suscripción se extiende, nueva factura]
```

#### RF-C1: Catálogo de Planes de Suscripción

**Descripción**: El sistema debe mantener un catálogo de planes disponibles.

**Qué sucede**:
- El sistema define planes de suscripción con características:
  - **Free**:
    - Hasta 5 usuarios
    - Hasta 2 aplicaciones cliente
    - Funcionalidad básica de OAuth2
    - Sin soporte premium
  - **Pro**:
    - Hasta 50 usuarios
    - Hasta 10 aplicaciones cliente
    - Funcionalidad completa de OAuth2
    - Soporte email
    - Estadísticas y reportes
    - Precio: $X/mes
  - **Enterprise**:
    - Usuarios ilimitados
    - Aplicaciones cliente ilimitadas
    - Funcionalidad completa + características avanzadas
    - Soporte prioritario
    - SLA garantizado
    - Precio: $X/mes (o custom)
- Cada plan define:
  - Nombre, descripción
  - Cuota de usuarios, aplicaciones, etc.
  - Características incluidas
  - Precio
  - Período de facturación (mensual, anual)
- El catálogo es públicamente accesible:
  - Usuarios no autenticados pueden ver planes y precios
  - No requiere login para ver el catálogo

**Restricciones**:
- El catálogo debe ser consistente
- Los planes no pueden cambiar arbitrariamente (versioning)
- El precio debe estar en una moneda base (USD por ahora)

---

#### RF-C2: Suscripción a Planes

**Descripción**: Una organización debe poder suscribirse a un plan.

**Qué sucede**:
- El administrador de organización accede a la sección "Billing" o "Plan"
- Si la organización está sin plan o en Free, puede ver el catálogo
- El administrador selecciona un plan
- El sistema muestra:
  - Resumen del plan (características, precio, período)
  - Período de facturación (mensual o anual)
  - Total a pagar
- El administrador confirma la suscripción
- El sistema registra la suscripción con:
  - Fecha de inicio (hoy)
  - Fecha de fin (ej: 30 días después)
  - Plan seleccionado
  - Estado: "pendiente de pago" (si requiere pago) o "activo" (si es Free)
- Una factura es generada automáticamente
- Si el plan requiere pago, se inicia el proceso de pago

**Restricciones**:
- Una organización solo puede tener una suscripción activa a la vez
- No se puede cambiar de plan hasta que finalice el período actual
- El cambio de plan entra en efecto en la próxima renovación (o se prorratea)

---

#### RF-C3: Generación y Emisión de Facturas

**Descripción**: El sistema debe generar facturas para cada suscripción.

**Qué sucede**:
- Cuando una organización se suscribe a un plan, el sistema genera una factura
- La factura contiene:
  - Número de factura único (correlativo)
  - Fecha de emisión
  - Período de facturación (ej: 2026-04-19 a 2026-05-19)
  - Plan suscrito
  - Descripción del servicio
  - Cantidad (1 período)
  - Precio unitario
  - Total a pagar
  - Organización (nombre, email, dirección)
  - Fecha de vencimiento (ej: 15 días después)
  - Estado de pago (pendiente, pagado, vencido)
- La factura es:
  - Visible para el administrador en su sección de Billing
  - Enviada por email a la organización
  - Almacenada para auditoría y cumplimiento fiscal
- El administrador puede:
  - Descargar la factura como PDF
  - Ver historial de todas las facturas
  - Registrar métodos de pago

**Restricciones**:
- Una factura es generada al inicio de cada período de suscripción
- Las facturas son inmutables (no se pueden editar después de generadas)
- El número de factura debe ser único

---

#### RF-C4: Procesamiento de Pagos

**Descripción**: El sistema debe aceptar y procesar pagos para suscripciones.

**Qué sucede**:
- Cuando una factura requiere pago:
  - El administrador es notificado
  - El sistema proporciona una forma de pago (ej: enlace a gateway de pago)
- El administrador proporciona información de pago:
  - Método: Tarjeta de crédito, transferencia bancaria, etc.
  - Detalles según el método
- El sistema:
  - Valida la información de pago
  - Procesa la transacción con el gateway de pago externo
  - Recibe confirmación de éxito o fallo
- Si el pago es exitoso:
  - La factura cambia a estado "pagada"
  - La suscripción se activa (si estaba pendiente)
  - El administrador recibe confirmación por email
- Si el pago falla:
  - El administrador es notificado
  - Se le pide reintentar

**Restricciones**:
- El pago debe ser validado como exitoso antes de activar servicio
- El sistema no almacena datos sensibles de pago (delegar a gateway)
- Debe haber auditoría de todas las transacciones

---

#### RF-C5: Renovación Automática de Suscripciones

**Descripción**: Las suscripciones deben renovarse automáticamente al final de su período.

**Qué sucede**:
- Cuando se acerca la fecha de vencimiento de una suscripción:
  - El sistema genera una nueva factura para el próximo período
  - Se intenta procesar el pago automáticamente usando el método guardado
  - Si el pago es exitoso:
    - La suscripción se extiende
    - El período nuevo comienza
    - El administrador recibe confirmación
  - Si el pago falla:
    - Se intenta reintentar (ej: 3 veces en 3 días)
    - Si sigue fallando, se notifica al administrador
    - Puede haber un período de gracia (ej: 7 días sin acceso)
- La organización puede deshabilitar la renovación automática

**Restricciones**:
- Renovación automática requiere método de pago guardado
- Requiere confirmación inicial de la organización

---

#### RF-C6: Soporte de Múltiples Monedas

**Descripción**: El sistema debe soportar precios y facturación en diferentes monedas.

**Qué sucede**:
- El sistema mantiene precios en múltiples monedas:
  - USD (moneda base)
  - EUR, MXN, JPY, etc.
- Cuando una organización ve el catálogo:
  - El sistema detecta la ubicación/preferencia del usuario
  - Muestra precios en la moneda local
  - Los precios son convertidos automáticamente (tasa actual)
- Las facturas se emiten en la moneda seleccionada
- Los tipos de cambio se actualizan diariamente (o se fijan manualmente)

**Restricciones**:
- Requiere integración con proveedor de tipos de cambio (Fixer, OpenExchangeRates, etc.)
- Los precios deben ser justos en cada moneda

---

#### RF-C7: Catálogo Públicamente Accesible

**Descripción**: Posibles clientes pueden ver planes y precios sin necesidad de autenticación.

**Qué sucede**:
- Hay una página pública (landing) que muestra:
  - El catálogo de planes
  - Características de cada plan
  - Precios
  - Testimonios, casos de uso
  - CTA ("Crear Cuenta", "Contactar")
- No requiere autenticación
- Pueden copiar el enlace de planes y compartir
- Los precios son actuales y consistentes

**Restricciones**:
- No se requiere login para ver
- SEO debe estar optimizado (meta tags, schemas)

---

### **D. ACCOUNT & AUTOSERVICIO**

**Contexto**: Los usuarios necesitan gestionar su propia cuenta, preferencias y sesiones.

#### Flujo Inicial: Gestión de Cuenta de Usuario

```
[Usuario Autenticado accede a "Mi Perfil"]
   ↓
[Puede ver: nombre, email, rol, organización]
   ↓
[Usuario puede: cambiar contraseña, cambiar preferencias, gestionar sesiones]
   ↓
[Usuario ve aplicaciones autorizadas]
   ↓
[Usuario puede revocar acceso a cualquier aplicación]
```

#### RF-D1: Visualización de Perfil de Usuario

**Descripción**: Un usuario debe poder ver su información de perfil.

**Qué sucede**:
- El usuario accede a su perfil ("Mi Cuenta", "Perfil", etc.)
- El usuario ve:
  - Nombre completo
  - Email (verificado)
  - Rol(es) en su(s) organización(es)
  - Organizaciones de las cuales es miembro
  - Fecha de creación de cuenta
  - Último login
- El usuario puede:
  - Actualizar nombre
  - Cambiar email (requiere reverificación)

**Restricciones**:
- El usuario solo ve su propio perfil
- No puede ver perfiles de otros usuarios (excepto ADMIN)

---

#### RF-D2: Gestión de Sesiones Activas

**Descripción**: Un usuario debe poder ver y gestionar sus sesiones activas.

**Qué sucede**:
- El usuario accede a la sección "Sesiones" o "Dispositivos"
- Puede ver una lista de sesiones activas con:
  - Dispositivo/navegador (ej: "Chrome en Windows")
  - Ubicación aproximada (ciudad, país)
  - Dirección IP (parcialmente ocultada por privacidad)
  - Fecha/hora de inicio
  - Última actividad
  - Si es la sesión actual (marcada)
- Para cada sesión, el usuario puede:
  - Cerrar esa sesión específica manualmente
  - Las otras sesiones permanecen activas
- El usuario puede:
  - Cerrar todas las sesiones excepto la actual
  - Cerrar todas las sesiones incluyendo la actual (requiere confirmación)

**Restricciones**:
- El usuario no puede cerrar sesiones de otros usuarios
- La sesión actual siempre está disponible
- Solo el usuario y administradores ven esta información

---

#### RF-D3: Cambio de Contraseña

**Descripción** (ver RF-A6 para detalles técnicos):
Un usuario autenticado puede cambiar su contraseña.

**Resumen**:
- Requiere contraseña actual como verificación
- Proporciona nueva contraseña y confirmación
- Cambio es inmediato; sesión actual permanece válida

---

#### RF-D4: Visualización y Revocación de Permisos

**Descripción**: Un usuario debe poder ver qué aplicaciones ha autorizado y revocar acceso.

**Qué sucede**:
- El usuario accede a la sección "Aplicaciones Autorizadas" o "Permisos"
- Ve una lista de todas las aplicaciones que ha autorizado con:
  - Nombre de la aplicación
  - Descripción
  - Scopes autorizados (en lenguaje legible: "Acceso a tu email", "Acceso a tu rol")
  - Fecha de autorización
  - Última fecha de acceso
  - Icono/logo (si disponible)
- Para cada aplicación, el usuario puede:
  - Ver detalles de qué información tiene acceso
  - Revocar autorización inmediatamente
    - La aplicación pierde acceso instantáneamente
    - Requests posteriores de la aplicación son rechazados
    - El usuario recibe confirmación
  - Re-autorizar más tarde si es necesario

**Restricciones**:
- El usuario solo ve sus propias autorizaciones
- La revocación es inmediata

---

#### RF-D5: Configuración de Preferencias de Usuario

**Descripción**: Un usuario debe poder configurar preferencias personales.

**Qué sucede**:
- El usuario accede a la sección "Preferencias" o "Configuración"
- Puede configurar:
  - **Idioma preferido**: Español, Inglés, etc. (interfaz se adapta)
  - **Zona horaria**: Para mostrar fechas/horas correctamente
  - **Formato de fecha**: DD/MM/YYYY, MM/DD/YYYY, etc.
  - **Notificaciones**: Email para ciertos eventos (login desde nuevo dispositivo, cambio de contraseña, etc.)
  - **Privacidad**: Qué información es visible en perfil
- Los cambios se guardan inmediatamente
- Las preferencias se aplican en todas las sesiones del usuario

**Restricciones**:
- Las preferencias son por usuario, no por sesión
- La zona horaria afecta solo la visualización, no el almacenamiento (UTC internamente)

---

## SECCIÓN 2: REQUISITOS NO-FUNCIONALES (RNF)

Los Requisitos No-Funcionales describen atributos de calidad, rendimiento, seguridad, disponibilidad, y escalabilidad del sistema. Responden a la pregunta: ¿Cómo debe comportarse el sistema?

---

### **Seguridad (RNF-SEC)**

- **RNF-SEC-1**: Las contraseñas no se transmiten en texto plano en ningún punto (siempre HTTPS, nunca HTTP)
- **RNF-SEC-2**: Las contraseñas se almacenan de forma irreversible (hashing con salt, no encriptadas)
- **RNF-SEC-3**: Aislamiento multi-tenant: datos de una organización NO son accesibles a otra
- **RNF-SEC-4**: Tokens de sesión no pueden reutilizarse después de expirar
- **RNF-SEC-5**: Protección anti-enumeración: las respuestas de login y recuperación de contraseña no revelan si un email existe
- **RNF-SEC-6**: Rate limiting en endpoints sensibles (login, recuperación de contraseña) para mitigar ataques de fuerza bruta
- **RNF-SEC-7**: HTTPS requerido en todas las comunicaciones; HSTS headers para prevenir downgrade attacks
- **RNF-SEC-8**: CSRF tokens o mecanismos equivalentes para formularios que cambian estado
- **RNF-SEC-9**: XSS protection: entrada sanitizada, salida escapada
- **RNF-SEC-10**: SQL injection protection: queries parametrizadas, no concatenación de strings
- **RNF-SEC-11**: Sesiones no persisten en storage del navegador (localStorage, sessionStorage); solo en memoria o cookies httpOnly
- **RNF-SEC-12**: Datos sensibles (client_secret, payment info) no se loguean en plaintext
- **RNF-SEC-13**: Rotación de secretos: mecanismo para generar múltiples secrets y revocar antiguos sin downtime
- **RNF-SEC-14**: Auditoría de accesos administrativos: logs de quién accedió qué y cuándo
- **RNF-SEC-15**: Validación de integridad de tokens: no pueden ser modificados sin invalidarse

---

### **Disponibilidad & Rendimiento (RNF-PERF)**

- **RNF-PERF-1**: El sistema está disponible 24/7 (objetivo 99.9% uptime)
- **RNF-PERF-2**: Autenticación (login) completa en < 500ms (percentil 95)
- **RNF-PERF-3**: Generación de tokens en < 100ms
- **RNF-PERF-4**: El sistema soporta miles de usuarios autenticados simultáneamente (escalabilidad horizontal)
- **RNF-PERF-5**: Renovación de sesión completa en < 200ms
- **RNF-PERF-6**: Dashboard/reportes responden en < 2000ms (con caching)
- **RNF-PERF-7**: Caché de datos frecuentes (catálogo de planes, configuración de organización) para reducir latencia
- **RNF-PERF-8**: CDN para contenido estático (logos, estilos, scripts)
- **RNF-PERF-9**: Compresión de respuestas (gzip, brotli)
- **RNF-PERF-10**: Connection pooling para base de datos para evitar agotamiento de conexiones
- **RNF-PERF-11**: Timeouts en operaciones remotas (ej: llamadas a payment gateway) para evitar bloqueos

---

### **Confiabilidad & Recuperación (RNF-RELIABILITY)**

- **RNF-RELIABILITY-1**: Datos persistidos en base de datos durable con replicación
- **RNF-RELIABILITY-2**: Backups automáticos diarios (retención: 30 días)
- **RNF-RELIABILITY-3**: RTO (Recovery Time Objective): < 4 horas
- **RNF-RELIABILITY-4**: RPO (Recovery Point Objective): < 1 hora (pérdida máxima de datos)
- **RNF-RELIABILITY-5**: Health checks disponibles para monitoreo
- **RNF-RELIABILITY-6**: Alertas automáticas cuando el sistema está degradado
- **RNF-RELIABILITY-7**: Plan de disaster recovery documentado y probado trimestralmente

---

### **Observabilidad (RNF-OBS)**

- **RNF-OBS-1**: Health checks disponibles (endpoint `/health`)
- **RNF-OBS-2**: Logs estructurados de todas las actividades para auditoría
- **RNF-OBS-3**: Request IDs para rastrear solicitudes a través de logs
- **RNF-OBS-4**: Métricas de negocio: cantidad de logins, autorizaciones, pagos procesados (futuro)
- **RNF-OBS-5**: Alertas en caso de anomalías (ej: tasa de login anormalmente alta)
- **RNF-OBS-6**: Tracing distribuido para solicitudes complejas (futuro)
- **RNF-OBS-7**: Dashboards públicos de estado del servicio

---

### **Internacionalización (RNF-I18N)**

- **RNF-I18N-1**: Mensajes de error localizados (español, inglés)
- **RNF-I18N-2**: El usuario puede elegir idioma preferido
- **RNF-I18N-3**: Fechas y horas formateadas según locale del usuario
- **RNF-I18N-4**: Textos en UI traducidos

---

### **Escalabilidad (RNF-SCALE)**

- **RNF-SCALE-1**: Arquitectura capaz de escalar a decenas de miles de usuarios
- **RNF-SCALE-2**: Capacidad de ejecutar en múltiples instancias (load balancing)
- **RNF-SCALE-3**: Base de datos escalable (sharding, partitioning si es necesario)
- **RNF-SCALE-4**: Caché distribuido para sesiones y datos frecuentes

---

### **Compliance & Regulación (RNF-COMPLIANCE)**

- **RNF-COMPLIANCE-1**: Cumplimiento con GDPR: derecho al olvido, portabilidad de datos
- **RNF-COMPLIANCE-2**: Logs para auditoría de acceso (quién accedió qué, cuándo)
- **RNF-COMPLIANCE-3**: PII (Personally Identifiable Information) protegida según estándares
- **RNF-COMPLIANCE-4**: Cumplimiento con estándares OAuth2 y OIDC

---

## SECCIÓN 3: LO QUE KEYGO NO HACE (SCOPE BOUNDARIES)

Para claridad sobre qué está fuera del alcance:

- ❌ **2FA/MFA**: Autenticación de dos factores (SMS, TOTP, U2F) — futuro
- ❌ **SAML 2.0**: Solo OAuth2/OIDC por ahora
- ❌ **SCIM 2.0**: Aprovisionamiento automático de usuarios desde HR systems
- ❌ **Webhooks**: Notificaciones de eventos a aplicaciones externas — futuro
- ❌ **Audit Trail Persistente**: Tabla específica de auditoría queryable; solo logs actualmente
- ❌ **Rate Limiting**: Protección contra ataques de fuerza bruta (implementación con limitaciones)
- ❌ **Certificados SSL/TLS Personalizados**: HTTPS provista por plataforma, no custom domains
- ❌ **LDAP**: Integración con directorio LDAP corporativo
- ❌ **Single Sign-On (SSO) con Google/GitHub**: Actualmente no soportado
- ❌ **Precios Dinámicos**: Los planes tienen precios fijos
- ❌ **White-label**: Customización de branding por cliente

---

## SECCIÓN 4: MATRIZ DE TRAZABILIDAD (TRACKING MATRIX)

**Nota**: Esta sección registra el estado de implementación de requisitos. No es parte de la especificación funcional, sino una referencia de tracking.

| RF/RNF | Nombre | Implementado | Notas | Roadmap |
|--------|--------|--------------|-------|---------|
| RF-A1 | Registro de Usuarios | ✅ | | |
| RF-A2 | Login | ✅ | | |
| RF-A3 | Gestión de Sesiones | ✅ | | |
| RF-A4 | Logout | ✅ | | |
| RF-A5 | Recuperación de Contraseña | ✅ | | |
| RF-A6 | Cambio de Contraseña | ✅ | | |
| RF-A7 | Políticas de Contraseña | ✅ | | |
| RF-A8 | Verificación de Email | ✅ | | |
| RF-A9 | Scopes | ✅ | | |
| RF-A10 | Client Credentials | ✅ | | |
| RF-A11 | RBAC | ✅ | | |
| RF-A12 | Multi-Tenancy | ✅ | | |
| RF-B1 | Crear Organizaciones | ✅ | | |
| RF-B2 | Gestionar Usuarios | ✅ | | |
| RF-B3 | Roles | ✅ | | |
| RF-B4 | Registrar Aplicaciones | ✅ | | |
| RF-B5 | Reportes | ✅ | | |
| RF-B6 | Suspender Org | ✅ | | |
| RF-C1 | Catálogo de Planes | ✅ | | |
| RF-C2 | Suscribirse | ✅ | | |
| RF-C3 | Facturas | ✅ | | |
| RF-C4 | Pagos | 🟡 | Mock gateway | T-084 |
| RF-C5 | Auto-Renewal | 🔲 | | T-085 |
| RF-C6 | Multi-Moneda | 🔲 | | T-089 |
| RF-C7 | Catálogo Público | ✅ | | |
| RF-D1 | Perfil Usuario | ✅ | | |
| RF-D2 | Sesiones | ✅ | | |
| RF-D3 | Cambiar Contraseña | ✅ | | |
| RF-D4 | Revocar Permisos | ✅ | | |
| RF-D5 | Preferencias | ✅ | | |
| RNF-SEC-6 | Rate Limiting | 🟡 | Limited | Future |
| RNF-PERF-6 | Dashboard Latencia | 🟡 | ~2000ms | T-074 |

---

**Última actualización:** 2026-04-19  
**Próxima revisión:** 2026-07-19  
**Responsable:** Product Team
