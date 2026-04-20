[← Índice](./README.md) | [< Anterior](./wireframes.md)

---

# Decisiones UX

Decisiones de experiencia de usuario tomadas para Keygo, con la alternativa considerada y la justificación de la elección. El diseño técnico de implementación que soporta estas decisiones se documenta en `06-development/`.

## Contenido

- [UX-01: Dos portales separados](#ux-01-dos-portales-separados)
- [UX-02: Tres capas de acceso a la interfaz](#ux-02-tres-capas-de-acceso-a-la-interfaz)
- [UX-03: Navegación organizada por dominio](#ux-03-navegación-organizada-por-dominio)
- [UX-04: Secretos visibles una sola vez](#ux-04-secretos-visibles-una-sola-vez)
- [UX-05: Confirmación explícita para acciones destructivas](#ux-05-confirmación-explícita-para-acciones-destructivas)
- [UX-06: Contexto activo siempre visible](#ux-06-contexto-activo-siempre-visible)
- [UX-07: Trazabilidad visible para el administrador de plataforma](#ux-07-trazabilidad-visible-para-el-administrador-de-plataforma)
- [UX-08: Pantalla de incorporación adaptada a la política](#ux-08-pantalla-de-incorporación-adaptada-a-la-política)
- [Comentarios de los Revisores](#comentarios-de-los-revisores)

---

## UX-01: Contextos de interfaz separados, seleccionables mediante el rol activo

| Campo | Detalle |
|-------|---------|
| **Decisión** | Los roles de plataforma son jerárquicos (`KEYGO_ADMIN` ⊇ `KEYGO_ACCOUNT_ADMIN` ⊇ `KEYGO_USER`). La interfaz de Keygo expone un selector de rol activo que determina qué contexto carga: Autogestión de cuenta (KEYGO_USER), Consola de Organización (KEYGO_ACCOUNT_ADMIN) o Consola de Plataforma (KEYGO_ADMIN). El usuario puede cambiar el rol activo en cualquier momento sin cerrar sesión. |
| **Alternativa descartada** | Una sesión por rol: el usuario con `KEYGO_ADMIN` debe autenticarse de nuevo para acceder al contexto de `KEYGO_USER`. |
| **Justificación** | La jerarquía de roles refleja la realidad: un operador de Keygo es también un usuario del sistema y puede necesitar verificar la experiencia de usuario sin crear cuentas adicionales. El selector de rol activo hace explícito el contexto de operación en cada momento — no hay ambigüedad sobre qué alcance tienen las acciones — mientras permite la transición sin fricción entre contextos. |
| **Consecuencia** | Los eventos de auditoría registran el rol activo en el momento de cada acción. Un `KEYGO_ADMIN` operando con rol activo `KEYGO_USER` no tiene más capacidades que un `KEYGO_USER` real — el contexto seleccionado limita las acciones disponibles. |

[↑ Volver al inicio](#decisiones-ux)

---

## UX-02: Tres capas de acceso a la interfaz

| Campo | Detalle |
|-------|---------|
| **Decisión** | El acceso a cualquier pantalla protegida pasa por tres verificaciones ordenadas: (1) autenticación válida, (2) contexto de organización válido (para la Consola de Organización), (3) permiso específico para la sección. |
| **Alternativa descartada** | Un único punto de verificación que evalúe todo en una sola comprobación al cargar la pantalla. |
| **Justificación** | Las tres capas corresponden a tres preguntas distintas del dominio: ¿eres quien dices ser? (Identity), ¿tienes una organización activa? (Organization), ¿puedes hacer esto en esta organización? (Access Control). Colapsarlas en una sola verificación mezcla responsabilidades y hace difícil comunicar al usuario por qué no puede acceder. Cada capa produce un mensaje de error diferente y útil. |
| **Consecuencia** | Si la sesión expira, el usuario ve la pantalla de sesión expirada (capa 1). Si la organización está suspendida, ve la pantalla de organización suspendida (capa 2). Si no tiene permiso para una sección, ve la pantalla de sin acceso (capa 3). Cada caso tiene una respuesta específica. |

[↑ Volver al inicio](#decisiones-ux)

---

## UX-03: Navegación organizada por dominio

| Campo | Detalle |
|-------|---------|
| **Decisión** | La navegación principal de la Consola de Organización se organiza por concepto de dominio: Usuarios, Aplicaciones, Roles y permisos, Membresías, Suscripción, Configuración. |
| **Alternativa descartada** | Organizar por tipo de acción (Gestionar, Configurar, Ver reportes) o por perfil de usuario (Administrador, Usuario). |
| **Justificación** | El Administrador de Organización piensa en términos de su dominio operativo: "quiero gestionar los usuarios de mi organización", "quiero ver las aplicaciones registradas". Organizar la navegación alrededor de los conceptos del dominio elimina la traducción mental entre lo que quiere hacer y dónde encontrarlo. Además, está alineado con el [Lenguaje Ubicuo](../ubiquitous-language.md) definido para el sistema. |
| **Consecuencia** | Las secciones de la interfaz usan exactamente los términos del lenguaje ubicuo: no "People" sino "Usuarios"; no "Apps" sino "Aplicaciones"; no "Subscriptions" sino "Suscripción". |

[↑ Volver al inicio](#decisiones-ux)

---

## UX-04: Secretos visibles una sola vez

| Campo | Detalle |
|-------|---------|
| **Decisión** | El secreto de una credencial de aplicación (y la credencial de renovación, cuando es relevante para el usuario) se muestra en pantalla una única vez: en el momento de su generación. No hay forma de recuperarlo después. |
| **Alternativa descartada** | Permitir que el administrador vea el secreto de una aplicación en cualquier momento desde el panel de detalle. |
| **Justificación** | El secreto no puede almacenarse en claro (solo su hash). Mostrar el secreto "cuando se necesite" requeriría almacenarlo de forma recuperable, lo que compromete la seguridad. La restricción es de dominio, no de UX: el sistema simplemente no tiene el valor original después del momento de emisión. |
| **Consecuencia** | La pantalla de registro de aplicación y la de rotación de credencial incluyen una advertencia visible y un paso de confirmación de que el usuario ha copiado el secreto antes de continuar. Si el secreto se pierde, la única opción es rotarlo. |

[↑ Volver al inicio](#decisiones-ux)

---

## UX-05: Confirmación explícita para acciones destructivas

| Campo | Detalle |
|-------|---------|
| **Decisión** | Toda acción que cambie irreversiblemente el estado de una entidad (suspender usuario, revocar membresía, eliminar aplicación, cancelar suscripción) requiere un diálogo de confirmación que describe el efecto antes de proceder. |
| **Alternativa descartada** | Acción directa sin confirmación, con capacidad de deshacer posterior (undo). |
| **Justificación** | Keygo gestiona accesos activos a sistemas reales. "Suspender usuario" tiene efecto inmediato: todas las sesiones activas se revocan. El usuario debe entender el impacto antes de actuar, no después. La mayoría de las acciones en Keygo no son reversibles de forma trivial (una sesión revocada no puede "desrevocarse"). El patrón de confirmación es más honesto con las consecuencias. |
| **Consecuencia** | El diálogo de confirmación describe el efecto específico de la acción ("Al suspender este usuario, sus 3 sesiones activas serán revocadas de forma inmediata") y requiere una acción activa del usuario (no solo presionar Enter). |

[↑ Volver al inicio](#decisiones-ux)

---

## UX-06: Contexto activo siempre visible

| Campo | Detalle |
|-------|---------|
| **Decisión** | La organización activa y el rol del usuario en sesión son visibles en todo momento en la Consola de Organización. |
| **Alternativa descartada** | Mostrar el contexto solo en la pantalla de inicio o en la configuración de perfil. |
| **Justificación** | Un administrador puede gestionar varias organizaciones (una identidad puede ser miembro de varias organizaciones). Si el contexto activo no es visible, es fácil ejecutar acciones en la organización equivocada. La visibilidad permanente del contexto es la primera línea de defensa contra errores operativos. |
| **Consecuencia** | El encabezado de la consola incluye el nombre de la organización activa y el nombre del usuario en sesión, en todas las pantallas. Si el usuario pertenece a múltiples organizaciones, puede cambiar de organización activa desde ese encabezado. |

[↑ Volver al inicio](#decisiones-ux)

---

## UX-07: Trazabilidad visible para el administrador de plataforma

| Campo | Detalle |
|-------|---------|
| **Decisión** | Antes de ejecutar cualquier operación de soporte sobre una organización, la Consola de Plataforma informa explícitamente al `KEYGO_ADMIN` que la acción quedará registrada y solicita un motivo. |
| **Alternativa descartada** | Registrar la acción en segundo plano sin que el `KEYGO_ADMIN` sea consciente del registro, o no requerir motivo. |
| **Justificación** | El acceso de un `KEYGO_ADMIN` a los datos de una organización es una acción de soporte excepcional, no una operación rutinaria. Hacer visible que la acción queda registrada refuerza el comportamiento responsable y deja constancia del motivo para futuros auditores. Es coherente con el principio del dominio: toda operación de soporte tiene trazabilidad explícita. |
| **Consecuencia** | El diálogo de confirmación de operaciones de soporte incluye un campo de motivo obligatorio. La acción no puede ejecutarse sin él. El motivo queda incluido en el evento de auditoría. |

[↑ Volver al inicio](#decisiones-ux)

---

## UX-08: Pantalla de incorporación adaptada a la política

| Campo | Detalle |
|-------|---------|
| **Decisión** | El flujo que ve un usuario al intentar acceder a una aplicación varía según la política de incorporación configurada en esa aplicación: puede ver un formulario de solicitud, una pantalla de espera de aprobación, una pantalla de aceptación de invitación o un acceso inmediato. |
| **Alternativa descartada** | Un único flujo genérico de "solicitar acceso" que el administrador aprueba o rechaza en todos los casos. |
| **Justificación** | Las cuatro políticas de incorporación son comportamientos de dominio distintos con significados distintos para el usuario. Una aplicación de autoregistro da acceso inmediato; una aplicación sin autoregistro no debe ni mostrar un botón de "solicitar acceso". Mostrar el flujo incorrecto crea confusión y expectativas incorrectas. La interfaz debe ser fiel a la política real de la aplicación. |
| **Consecuencia** | La pantalla que el usuario ve al iniciar el flujo de incorporación a una aplicación depende de la política configurada. Una aplicación sin autoregistro muestra "Para obtener acceso, contacta al administrador de tu organización". Una aplicación de autoregistro autovalidado muestra el acceso completado directamente. |

[↑ Volver al inicio](#decisiones-ux)

---

## UX-09: Selector de rol activo como elemento de navegación global

| Campo | Detalle |
|-------|---------|
| **Decisión** | El selector de rol activo es un elemento persistente en la cabecera de la interfaz, visible en todo momento para las identidades con más de un rol. Muestra el rol activo actual y permite cambiarlo. Una identidad con un único rol (`KEYGO_USER` puro) no ve el selector. |
| **Alternativa descartada** | Acceder al cambio de rol desde la configuración de perfil o desde un menú secundario. |
| **Justificación** | El rol activo es el contexto de operación más importante: determina qué secciones existen, qué acciones están disponibles y con qué alcance se ejecutan. Enterrarlo en un menú secundario lo convierte en algo que el usuario "olvidaría" revisar, con riesgo de ejecutar acciones bajo el rol equivocado. La posición global y visible hace el contexto activo imposible de ignorar, alineándose con el principio de [contexto activo siempre visible](#ux-06-contexto-activo-siempre-visible). |
| **Consecuencia** | Al cambiar el rol activo, la interfaz recarga el contexto completo del nuevo rol. Si el usuario estaba en una pantalla que no existe en el nuevo contexto (por ejemplo, venía de Consola de Plataforma y cambia a KEYGO_USER), navega al inicio del nuevo contexto. |

[↑ Volver al inicio](#decisiones-ux)

---

## Comentarios de los Revisores

| Revisor | Tipo | Contenido |
|---------|------|-----------|
| — | — | Pendiente de revisión |

[↑ Volver al inicio](#decisiones-ux)

---

[← Índice](./README.md) | [< Anterior](./wireframes.md)
