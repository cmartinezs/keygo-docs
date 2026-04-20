[← Índice](../README.md) | [< Anterior](rf23-suscripciones-usuarios-app.md)

---

# RF24 — Evaluación de derechos de membresía

**Descripción**
El sistema debe evaluar los derechos del plan activo de un usuario en una aplicación en el momento de emitir la credencial de sesión, e incluir esa información como parte del contexto de la sesión OAuth. Las aplicaciones cliente pueden usar estos derechos para controlar el acceso a funcionalidades sin necesidad de consultar a Keygo en cada petición.

Los derechos (`app_plan_entitlements`) son de tres tipos: cuotas (límites numéricos), habilitaciones booleanas (feature flags) y límites de tasa. El modo de aplicación de cada derecho puede ser estricto (bloquea al alcanzar el límite) o flexible (permite pero notifica).

**Alcance incluye**
- Resolución del plan activo del usuario en el momento de emitir la sesión OAuth: `app_membership` → `AppBillingAccount` → `app_subscription` activa → `app_plan_version` → `app_plan_entitlements`.
- Inclusión del identificador de la versión de plan activa y un resumen de derechos habilitados en los metadatos de la sesión OAuth.
- Exposición de los derechos del plan activo del usuario como endpoint consultable por la aplicación cliente, autenticado con la credencial de sesión del usuario.
- Aplicación de derechos estrictos (HARD) por parte del sistema: cuando un usuario intenta una operación que supera un límite HARD de su plan, la operación se rechaza antes de ejecutarse.
- Aplicación de derechos flexibles (SOFT): la operación se permite pero se registra el exceso y se notifica al usuario y al administrador de organización.
- Actualización de los derechos en la siguiente emisión de credencial de sesión (renovación o nueva autenticación) cuando el plan del usuario cambia. La ventana de inconsistencia máxima es el TTL de la credencial de sesión (1 hora).
- Acceso del administrador de organización al estado de derechos y consumo actual de cada miembro en cada app.

**No incluye (MVP)**
- Evaluación de derechos en tiempo real por petición (cada evaluación usa los derechos embebidos en la sesión activa).
- Enforcement automático de límites de tasa (`RATE`) a nivel de gateway; los límites de tasa son informativos en el MVP y los hace cumplir la lógica de la aplicación cliente.
- Notificaciones proactivas cuando el consumo se aproxima a un límite HARD.

**Dependencias**
- RF11 (Emisión de credenciales de sesión).
- RF22 (Planes comerciales por aplicación cliente).
- RF23 (Suscripciones de usuarios de app).
- RF10 (Control de acceso basado en roles).
- RF18 (Registro de eventos).
- DD-15 (App Billing Account como entidad de billing para usuarios finales de una app).
- DD-06 (Roles embebidos en la credencial de sesión al momento de emisión).

**Criterios de aceptación**
1. Al emitir una sesión OAuth para una app con planes, la sesión incluye el identificador de la versión de plan activa del usuario y el conjunto de derechos habilitados en ese plan.
2. Si la app no tiene planes o el usuario no tiene suscripción activa, la sesión se emite sin información de derechos; el acceso no se ve afectado por ausencia de plan.
3. Una operación rechazada por un límite HARD genera un evento de auditoría que identifica el derecho violado y el plan del usuario.
4. El endpoint de consulta de derechos de un usuario en una app devuelve el estado actualizado en el momento de la consulta (no el embebido en la sesión).
5. Un cambio de plan del usuario tiene efecto sobre los derechos embebidos en la siguiente renovación o nueva autenticación, dentro del TTL de la credencial de sesión (máximo 1 hora de desfase).
6. Los derechos de tipo BOOLEAN (`is_enabled = FALSE`) en el plan activo del usuario bloquean el acceso a la funcionalidad correspondiente con el mismo tratamiento que un límite HARD.

**Riesgos y mitigaciones**
- Ventana de inconsistencia de derechos → aceptada en diseño (análoga a la inconsistencia de roles, DD-06); para revocaciones urgentes de acceso, el administrador puede revocar la membresía o suspender la suscripción, lo que invalida la sesión.
- App que ignora los derechos embebidos → la aplicación cliente es responsable de respetar los derechos; Keygo expone la información pero no puede forzar el comportamiento interno de la app.

---

[← Índice](../README.md) | [< Anterior](rf23-suscripciones-usuarios-app.md)
