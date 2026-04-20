[← Índice](./README.md) | [Siguiente >](./relationships.md)

---

# Entidades

Catálogo completo de entidades del dominio de Keygo derivado del esquema de datos vigente, organizado por bounded context. Cada entidad tiene identidad propia, atributos definidos y un ciclo de vida explícito.

## Contenido

- [Identity](#identity)
- [Platform RBAC](#platform-rbac)
- [Organization](#organization)
- [Client Applications](#client-applications)
- [Access Control](#access-control)
- [Billing](#billing)
- [Audit](#audit)

---

## Identity

El contexto Identity gestiona las entidades que representan quién es alguien dentro de la plataforma y cómo se autentica. Existe una separación explícita entre la sesión de plataforma (identidad global) y la sesión OAuth (contexto de aplicación).

### Identidad de Plataforma (`platform_users`)

Entidad raíz del sistema. Representa a una persona en Keygo a nivel global, independiente de a qué organizaciones pertenezca o qué aplicaciones use.

| Atributo | Descripción |
|----------|-------------|
| Identificador | UUID único e inmutable. |
| Correo electrónico | Único en la plataforma; insensible a mayúsculas. |
| Hash de contraseña | Representación irreversible; el valor original nunca se persiste. |
| Nombre, apellido | Datos de perfil opcionales. |
| Nombre para mostrar | Alias de perfil preferido. |
| Teléfono, locale, zona horaria | Datos de contacto y localización opcionales. |
| Estado | `PENDING` → `ACTIVE` → `SUSPENDED` / `RESET_PASSWORD` → `DELETED` |
| Email verificado en | Nulo hasta que el usuario confirma su correo. |
| Último inicio de sesión | Marca de tiempo del acceso más reciente. |

> `RESET_PASSWORD` es un estado especial que representa que el sistema forzó un flujo de recuperación de contraseña sobre esta identidad.

### Verificación de Email de Plataforma (`email_verifications`)

Código de verificación de corta duración emitido cuando una identidad registra o cambia su correo. Solo puede existir un código activo por identidad simultáneamente.

| Atributo | Descripción |
|----------|-------------|
| Identidad | La identidad que debe verificar su email. |
| Código | Valor alfanumérico de un solo uso. |
| Expira en | Tiempo de vida corto. |
| Usado en | Nulo hasta que el código es canjeado. |

### Token de Recuperación de Contraseña (`password_reset_tokens`)

Artefacto de un solo uso que permite restablecer la contraseña de una identidad sin autenticación. Se almacena únicamente como hash.

| Atributo | Descripción |
|----------|-------------|
| Identidad | La identidad que inició el flujo de recuperación. |
| Hash del token | Representación irreversible; el valor original se entrega una sola vez. |
| Expira en | Tiempo de vida corto. |
| Usado en | Nulo hasta que el token es canjeado. |

### Preferencias de Notificación (`platform_user_notification_preferences`)

Configuración personal de comunicaciones de una identidad. Una identidad tiene exactamente un registro de preferencias.

| Atributo | Descripción |
|----------|-------------|
| Identidad | La identidad propietaria de estas preferencias. |
| Alertas de seguridad por email | Activo por defecto. |
| Alertas de seguridad en app | Activo por defecto. |
| Alertas de billing por email | Activo por defecto. |
| Actualizaciones de producto por email | Inactivo por defecto. |
| Resumen semanal por email | Inactivo por defecto. |

### Feed de Actividad de Plataforma (`platform_activity_events`)

Registro cronológico de eventos relevantes para la propia identidad, orientado a la experiencia de autoservicio. Distinto del registro de auditoría, que está orientado a seguridad y gobernanza.

| Atributo | Descripción |
|----------|-------------|
| Identidad | La identidad cuya actividad se registra. |
| Organización (opcional) | El tenant en el que ocurrió el evento. |
| Aplicación cliente (opcional) | La app involucrada en el evento. |
| Sesión de plataforma (opcional) | La sesión en la que ocurrió. |
| Sesión OAuth (opcional) | La sesión OAuth involucrada. |
| Tipo de evento | Qué ocurrió. |
| Categoría del evento | Agrupación temática del tipo de evento. |
| Metadatos | Datos contextuales del evento en formato estructurado. |
| Ocurrió en | Marca de tiempo del evento. |

### Sesión de Plataforma (`platform_sessions`)

Sesión de nivel global que representa el acceso activo de una identidad a la plataforma Keygo, independientemente de la aplicación o tenant. Es el contenedor raíz de todas las sesiones OAuth que se deriven de ella.

| Atributo | Descripción |
|----------|-------------|
| Identificador | UUID único. |
| Identidad | La identidad autenticada. |
| Estado | `ACTIVE` → `TERMINATED` / `EXPIRED` |
| Expira en | Cuándo vence la sesión. |
| Método de inicio de sesión | `PASSWORD`, `MAGIC_LINK`, `MFA`, `SOCIAL`, `API_BOOTSTRAP`, `SYSTEM` |
| Fortaleza de autenticación | `LOW`, `MEDIUM`, `HIGH` |
| Información de dispositivo | Agente de usuario, nombre de navegador, SO, tipo de dispositivo. |
| Información de red | Dirección IP, país, región, ciudad, zona horaria detectada. |
| Iniciada en / Terminada en | Ciclo de vida temporal. |
| Razón de terminación | Por qué fue cerrada o expirada. |

### Sesión OAuth (`oauth_sessions`)

Sesión de nivel tenant/aplicación derivada de una Sesión de Plataforma. Representa el contexto OAuth activo entre una identidad, una organización y una aplicación cliente específica.

| Atributo | Descripción |
|----------|-------------|
| Identificador | UUID único. |
| Sesión de plataforma | La sesión global que la originó. |
| Identidad | La identidad autenticada. |
| Organización | El tenant en el que opera esta sesión. |
| Miembro | El `tenant_user` correspondiente (nulo solo para apps internas en tenants reservados). |
| Aplicación cliente | La app para la que se emitió esta sesión. |
| Clave de firma | La clave usada para firmar los tokens emitidos. |
| Estado | `ACTIVE` → `TERMINATED` / `EXPIRED` |
| Ámbitos concedidos | Los ámbitos autorizados en esta sesión. |
| Consentimiento requerido / concedido | Si la app requirió consentimiento explícito y si fue otorgado. |
| Expira en | Cuándo vence. |

### Código de Autorización (`authorization_codes`)

Artefacto efímero de un solo uso que actúa como puente entre el inicio del flujo de autenticación y la emisión de credenciales. Se almacena únicamente como hash.

| Atributo | Descripción |
|----------|-------------|
| Hash del código | Representación irreversible; el código en texto plano se entrega una sola vez. |
| Sesión de plataforma | La sesión global activa al momento de emisión. |
| Identidad | La identidad que inició el flujo. |
| Organización | El tenant del flujo. |
| Miembro | El `tenant_user` del flujo (opcional para apps internas). |
| Aplicación cliente | La app solicitante. |
| URI de redirección | La URI exacta registrada a la que se enviará el código. |
| Ámbitos solicitados | Los ámbitos pedidos en el flujo. |
| Desafío PKCE | Hash del verificador del flujo; nulo si no se usa PKCE. |
| Método PKCE | `plain` o `S256` |
| Estado | `ACTIVE` → `USED` / `EXPIRED` / `REVOKED` |
| Expira en | Tiempo de vida muy corto. |

### Credencial de Renovación (`refresh_tokens`)

Artefacto de larga duración que permite obtener nuevas credenciales de acceso sin re-autenticación. Se almacena únicamente como hash. La rotación crea una cadena de referencias.

| Atributo | Descripción |
|----------|-------------|
| Hash del token | Representación irreversible; SHA-256 de 64 caracteres. |
| Sesión OAuth | La sesión a la que pertenece. |
| Identidad | La identidad propietaria. |
| Organización | El tenant del contexto. |
| Miembro | El `tenant_user` del contexto. |
| Aplicación cliente | La app del contexto. |
| Clave de firma | La clave usada al momento de emisión. |
| Estado | `ACTIVE` → `USED` / `EXPIRED` / `REVOKED` |
| Expira en | Duración estándar: 30 días. |
| Reemplazado por | Referencia al token que lo sustituyó tras rotación (nulo si no fue rotado). |

### Clave de Firma (`signing_keys`)

Clave criptográfica usada para firmar las credenciales de acceso. Una clave con `tenant_id` nulo es la clave global de la plataforma; las demás son claves específicas de un tenant.

| Atributo | Descripción |
|----------|-------------|
| Identificador de clave pública | Identificador usado en el protocolo para validación sin consultar a Keygo. |
| Organización | El tenant propietario; nulo indica clave global de plataforma. |
| Estado | `ACTIVE` → `RETIRED` |
| Activada en | Cuándo comenzó a usarse. |
| Retirada en | Cuándo dejó de estar activa. |

[↑ Volver al inicio](#entidades)

---

## Platform RBAC

El RBAC de plataforma es independiente del RBAC de organización y del RBAC de aplicación. Gestiona qué puede hacer una identidad a nivel global, en el contexto de un contratante o en el contexto de un tenant.

### Rol de Plataforma (`platform_roles`)

Rol global definido y gestionado exclusivamente por el equipo de Keygo.

| Atributo | Descripción |
|----------|-------------|
| Identificador | UUID único. |
| Código | Nombre técnico del rol; solo mayúsculas, dígitos y guiones bajos. |
| Nombre para mostrar | Nombre legible. |
| Descripción | Propósito del rol. |

### Jerarquía de Roles de Plataforma (`platform_role_hierarchy`)

Árbol de herencia de roles de plataforma. Cada rol hijo tiene exactamente un rol padre. La profundidad máxima es 5. Se valida en tiempo de escritura para prevenir ciclos.

| Atributo | Descripción |
|----------|-------------|
| Rol hijo | El rol que hereda del rol padre. |
| Rol padre | El rol del que hereda. |

### Asignación de Rol de Plataforma (`platform_user_roles`)

Asignación de un rol de plataforma a una identidad, con ámbito explícito.

| Atributo | Descripción |
|----------|-------------|
| Identidad | La identidad a quien se asigna el rol. |
| Rol | El rol asignado. |
| Tipo de ámbito | `GLOBAL` (transversal), `CONTRACTOR` (en el contexto de un contratante), `TENANT` (en el contexto de un tenant). |
| Contratante | Solo cuando el ámbito es `CONTRACTOR`. |
| Organización | Solo cuando el ámbito es `TENANT`. |
| Asignado en | Cuándo se realizó la asignación. |

[↑ Volver al inicio](#entidades)

---

## Organization

El contexto Organization gestiona los tenants y la pertenencia de identidades a ellos, incluyendo su propio RBAC interno.

### Organización — Tenant (`tenants`)

Unidad de aislamiento operativo de Keygo. Todo dato de usuarios, aplicaciones y sesiones pertenece a exactamente un tenant.

| Atributo | Descripción |
|----------|-------------|
| Identificador | UUID único e inmutable. |
| Slug | Identificador de URL único; solo minúsculas, dígitos y guiones. |
| Nombre | Nombre comercial. |
| Estado | `PENDING` → `ACTIVE` → `SUSPENDED` → `DELETED` |
| Contratante | Referencia al contratante propietario; nulo para tenants internos reservados. |
| Reservado interno | `true` para tenants gestionados por la propia plataforma (ej.: el tenant interno de Keygo). |

### Miembro del Tenant (`tenant_users`)

Participación de una identidad de plataforma dentro de un tenant. Una misma identidad puede ser miembro de múltiples tenants; su estado en cada uno es independiente.

| Atributo | Descripción |
|----------|-------------|
| Identificador | UUID único. |
| Organización | El tenant al que pertenece. |
| Identidad | La identidad de plataforma incorporada. |
| Nombre local | Alias opcional dentro del tenant; único por tenant cuando está presente. |
| Nombre para mostrar local | Sobreescritura opcional del nombre de perfil para este tenant. |
| Estado | `INVITED` → `PENDING` → `ACTIVE` → `SUSPENDED` → `DELETED` |

### Rol de Organización (`tenant_roles`)

Rol definido dentro del alcance de un tenant. Aislado del RBAC de plataforma y del RBAC de aplicación.

| Atributo | Descripción |
|----------|-------------|
| Identificador | UUID único dentro del sistema. |
| Organización | El tenant al que pertenece; inmutable por diseño. |
| Código | Nombre técnico único dentro del tenant. |
| Nombre para mostrar | Nombre legible. |

### Jerarquía de Roles de Organización (`tenant_role_hierarchy`)

Árbol de herencia de roles dentro de un tenant. Profundidad máxima de 5. Valida ciclos en tiempo de escritura.

| Atributo | Descripción |
|----------|-------------|
| Rol hijo | El rol que hereda. |
| Rol padre | El rol del que hereda; debe pertenecer al mismo tenant. |
| Organización | El tenant que delimita la jerarquía. |

### Asignación de Rol de Organización (`tenant_user_roles`)

Asignación de un rol de organización a un miembro del tenant.

| Atributo | Descripción |
|----------|-------------|
| Miembro del tenant | La membresía tenant a quien se asigna. |
| Organización | El tenant del contexto. |
| Rol | El rol asignado; debe pertenecer al mismo tenant. |
| Asignado en | Cuándo se realizó la asignación. |

### Perfil de Facturación del Tenant (`tenant_billing_profiles`)

Datos fiscales y de facturación registrados por un tenant. Un tenant puede tener múltiples perfiles, pero solo uno puede ser el predeterminado.

| Atributo | Descripción |
|----------|-------------|
| Organización | El tenant propietario. |
| Tipo | `PERSONAL` o `COMPANY`. |
| Nombre para mostrar | Nombre del perfil. |
| Nombre legal | Razón social (opcional). |
| ID fiscal | NIT, RUT, RFC u equivalente (opcional). |
| Email de facturación | Dirección de contacto para facturas. |
| Dirección | Dirección fiscal completa (opcional). |
| Es predeterminado | Solo un perfil puede ser el predeterminado por tenant. |

[↑ Volver al inicio](#entidades)

---

## Client Applications

El contexto Client Applications gestiona las aplicaciones externas que un tenant registra en Keygo para delegar la autenticación de sus usuarios.

### Aplicación Cliente (`client_apps`)

Sistema externo registrado dentro de un tenant que delega en Keygo la autenticación y verificación de identidad.

| Atributo | Descripción |
|----------|-------------|
| Identificador interno | UUID técnico usado en relaciones internas. |
| Identificador de cliente | Identificador público del protocolo de autenticación; único globalmente. |
| Organización | El tenant propietario; inmutable. |
| Nombre | Nombre legible de la aplicación. |
| Tipo | `PUBLIC` (sin secreto) o `CONFIDENTIAL` (con secreto). |
| Secreto hash | Hash del secreto de la app; solo en apps de tipo `CONFIDENTIAL`. El valor original se entrega una sola vez. |
| Estado | `PENDING` → `ACTIVE` → `SUSPENDED` |
| Es interna | `true` para aplicaciones técnicas de la propia plataforma. |
| Política de registro | Cómo los usuarios pueden obtener acceso: `OPEN_AUTO_ACTIVE`, `OPEN_AUTO_PENDING`, `OPEN_NO_MEMBERSHIP`, `INVITE_ONLY`. |

### URI de Redirección (`client_redirect_uris`)

URIs exactas a las que Keygo puede redirigir tras completar un flujo de autenticación. No se admiten wildcards. Una app puede tener múltiples URIs registradas.

| Atributo | Descripción |
|----------|-------------|
| Aplicación cliente | La app propietaria. |
| URI | Dirección de redirección exacta; sin comodines. |

### Tipo de Flujo Autorizado (`client_allowed_grants`)

Flujos de autenticación que una aplicación tiene permitido utilizar.

| Atributo | Descripción |
|----------|-------------|
| Aplicación cliente | La app propietaria. |
| Tipo de flujo | El tipo de flujo autorizado para esta app. |

### Ámbito Autorizado de App (`client_allowed_scopes`)

Subconjunto de ámbitos que la plataforma permite a una aplicación solicitar en nombre de sus usuarios.

| Atributo | Descripción |
|----------|-------------|
| Aplicación cliente | La app propietaria. |
| Ámbito | Identificación del ámbito autorizado. |

[↑ Volver al inicio](#entidades)

---

## Access Control

El contexto Access Control gestiona roles y membresías dentro del alcance de cada aplicación cliente.

### Rol de Aplicación (`app_roles`)

Rol definido dentro del alcance de una aplicación cliente específica. Aislado del RBAC de plataforma y del RBAC de organización.

| Atributo | Descripción |
|----------|-------------|
| Identificador | UUID único. |
| Organización | El tenant al que pertenece la app. |
| Aplicación cliente | La app en la que existe este rol. |
| Código | Nombre técnico único dentro de la app; solo minúsculas, dígitos y guiones. |
| Nombre para mostrar | Nombre legible. |
| Es predeterminado | Como máximo un rol por app puede ser el predeterminado. |

### Jerarquía de Roles de Aplicación (`app_role_hierarchy`)

Árbol de herencia de roles dentro de una aplicación. Profundidad máxima de 5. Valida ciclos en tiempo de escritura.

| Atributo | Descripción |
|----------|-------------|
| Rol hijo | El rol que hereda. |
| Rol padre | El rol del que hereda; debe pertenecer a la misma app. |
| Aplicación cliente | La app que delimita la jerarquía. |

### Membresía de Aplicación (`app_memberships`)

Relación entre un miembro del tenant y una aplicación cliente dentro del mismo tenant. Representa que el miembro tiene acceso habilitado a esa app. Cuando la app tiene planes comerciales (RF22), la membresía se vincula a la cuenta de billing del usuario en esa app.

| Atributo | Descripción |
|----------|-------------|
| Identificador | UUID único. |
| Organización | El tenant del contexto. |
| Miembro del tenant | El `tenant_user` que tiene el acceso. |
| Aplicación cliente | La app a la que da acceso. |
| Cuenta de billing de app | Referencia a la `AppBillingAccount` del usuario en esta app; nulo cuando la app no tiene planes. |
| Estado | `INVITED` → `PENDING` → `ACTIVE` → `SUSPENDED` → `DELETED` |

> Las invitaciones a una app se modelan como membresías en estado `INVITED` o `PENDING`, sin una tabla separada.

### Asignación de Rol de Membresía (`app_membership_roles`)

Roles asignados a una membresía de aplicación. Las claves compuestas garantizan que los roles no puedan asignarse a membresías de otras apps.

| Atributo | Descripción |
|----------|-------------|
| Membresía | La membresía a la que se asigna el rol. |
| Aplicación cliente | La app del contexto; delimita la integridad de la asignación. |
| Rol | El rol asignado; debe pertenecer a la misma app. |
| Asignado en | Cuándo se realizó la asignación. |

[↑ Volver al inicio](#entidades)

---

## Billing

El contexto Billing gestiona la relación comercial entre Keygo y los contratantes. El **Contratante** es la entidad de facturación — puede ser una persona o empresa — y es el ancla de contratos, suscripciones y pagos. Un contratante puede poseer múltiples tenants.

### Cuenta de Billing de App (`app_billing_accounts`)

Entidad de billing ligera que representa la relación comercial entre un usuario final y una aplicación cliente específica. Existe como máximo una por usuario por aplicación. Es el ancla de las suscripciones de billing de app — análoga al `Contractor` en el billing de plataforma, pero scoped al contexto de una app concreta.

Se crea al iniciarse el primer proceso de contratación de un usuario en esa app y persiste a lo largo de todos los planes que ese usuario pueda contratar en el futuro dentro de la misma app.

| Atributo | Descripción |
|----------|-------------|
| Identificador | UUID único. |
| Aplicación cliente | La app a la que pertenece esta cuenta; inmutable. |
| Organización | El tenant de la app; para integridad referencial. |
| Miembro del tenant | El `tenant_user` propietario de esta cuenta. |
| Estado | `ACTIVE` → `SUSPENDED` → `CLOSED` |
| Fecha de creación | Cuándo fue abierta la cuenta. |

---

### Contratante (`contractors`)

Persona o empresa que firma contratos con Keygo y es responsable de los pagos. Es el ancla de toda la relación comercial. Distinto de la identidad de plataforma y del tenant.

| Atributo | Descripción |
|----------|-------------|
| Identificador | UUID único. |
| Tipo | `PERSON` o `COMPANY`. |
| Nombre para mostrar | Nombre comercial o personal del contratante. |
| Nombre legal | Razón social (opcional). |
| ID fiscal | NIT, RUT, RFC u equivalente (opcional). |
| Email de facturación | Dirección de contacto principal para cobros. |
| Contacto principal | La identidad de plataforma responsable de la cuenta (opcional). |
| Estado | `PENDING` → `ACTIVE` → `SUSPENDED` → `DELETED` |

### Usuario de Contratante (`contractor_users`)

Identidades de plataforma con acceso administrativo a la cuenta de un contratante. Permite que múltiples personas administren una misma cuenta de facturación.

| Atributo | Descripción |
|----------|-------------|
| Contratante | La cuenta de contratante. |
| Identidad | La identidad de plataforma con acceso. |
| Rol en la cuenta | `OWNER`, `BILLING_ADMIN` o `VIEWER`. |

### Plan (`app_plans`)

Definición comercial que Keygo expone a los contratantes. Cuando `client_app_id` es nulo, es un plan de plataforma (gestionado por Keygo). Cuando referencia una app, es un plan ofrecido por esa app.

| Atributo | Descripción |
|----------|-------------|
| Identificador | UUID único. |
| Aplicación cliente | La app que ofrece el plan; nulo para planes de plataforma. |
| Código | `FREE`, `PERSONAL`, `TEAM`, `BUSINESS`, `FLEX`, `ENTERPRISE`. |
| Nombre | Nombre comercial. |
| Estado | `ACTIVE` / `INACTIVE` |
| Es público | Si el plan aparece en el catálogo visible por contratantes. |

### Versión de Plan (`app_plan_versions`)

Snapshot inmutable de la configuración de un plan en un momento dado. Los contratos y suscripciones referencian siempre una versión específica, lo que garantiza estabilidad ante cambios futuros del plan.

| Atributo | Descripción |
|----------|-------------|
| Plan | El plan del que es versión. |
| Versión | Etiqueta de versión (ej. `v1.0`). |
| Moneda | ISO 4217 (ej. `USD`). |
| Cargo de activación | Monto único al contratar. |
| Días de prueba gratuita | Período de evaluación sin cargo. |
| Vigente desde / hasta | Rango de fechas en que esta versión era o es aplicable. |
| Estado | `ACTIVE` / `DEPRECATED` / `INACTIVE` |

### Opción de Facturación (`app_plan_billing_options`)

Cadencia de cobro disponible para una versión de plan. Una versión puede ofrecer múltiples cadencias; una de ellas puede ser la predeterminada.

| Atributo | Descripción |
|----------|-------------|
| Versión de plan | La versión a la que aplica. |
| Período de facturación | `MONTHLY`, `YEARLY` o `ONE_TIME`. |
| Precio base | Monto en la moneda de la versión. |
| Descuento | Porcentaje de descuento (0-100). |
| Es predeterminada | Si esta cadencia es la sugerida al contratar. |

### Derecho del Plan (`app_plan_entitlements`)

Límite o capacidad específica incluida en una versión de plan. Permite definir cuotas, habilitaciones booleanas o límites de tasa por métrica.

| Atributo | Descripción |
|----------|-------------|
| Versión de plan | La versión a la que pertenece. |
| Código de métrica | Identificador de qué se limita (ej. `MAX_TENANTS`, `MAX_USERS`). |
| Tipo de métrica | `QUOTA` (cantidad máxima), `BOOLEAN` (habilitado/no) o `RATE` (velocidad). |
| Valor límite | La cantidad máxima; nulo significa ilimitado. |
| Período | `NONE`, `DAY`, `MONTH` o `YEAR`. |
| Modo de aplicación | `HARD` (bloquea) o `SOFT` (advierte pero permite). |
| Habilitado | Si este derecho está activo en la versión. |

### Contrato (`app_contracts`)

Acuerdo entre un contratante y una versión de plan para acceder a una aplicación. Es el punto de inicio del proceso de contratación y registra el estado del flujo de activación.

| Atributo | Descripción |
|----------|-------------|
| Identificador | UUID único. |
| Contratante | El contratante que contrata; puede estar en nulo durante el flujo de onboarding previo a la creación de cuenta. |
| Aplicación cliente | La app que se contrata; puede ser nulo para planes de plataforma. |
| Versión de plan | La versión del plan acordada; inmutable una vez firmado. |
| Creado por | La identidad que inició el contrato (opcional). |
| Período de facturación | `MONTHLY`, `YEARLY` o `ONE_TIME`. |
| Estado | `DRAFT` → `PENDING_EMAIL_VERIFICATION` → `PENDING_PAYMENT` → `READY_TO_ACTIVATE` → `ACTIVE` → `SUPERSEDED` / `FINALIZED` / `CANCELLED` / `EXPIRED` / `FAILED` |
| Email de contacto de facturación | Dirección para notificaciones del contrato. |
| Email verificado en | Cuándo el email de contacto fue confirmado. |
| Pago verificado en | Cuándo el pago inicial fue confirmado. |
| Expira en | Hasta cuándo es válido el contrato en su estado actual. |
| Snapshot de contacto | Nombre, apellido, nombre de empresa, ID fiscal y dirección capturados durante el onboarding. |

### Verificación de Email de Contrato (`contract_email_verifications`)

Código de verificación del email de contacto del contrato durante el flujo de onboarding, previo a la creación de la cuenta del contratante. Solo puede existir un código activo por contrato.

| Atributo | Descripción |
|----------|-------------|
| Contrato | El contrato cuyo email se está verificando. |
| Código | Valor alfanumérico de un solo uso. |
| Expira en | Tiempo de vida corto. |
| Usado en | Nulo hasta que el código es canjeado. |

### Suscripción (`app_subscriptions`)

Estado activo de una entidad de billing sobre una aplicación bajo una versión de plan específica. Determina qué capacidades están habilitadas. Existe como máximo una suscripción activa por entidad de billing por aplicación.

El campo de entidad de billing es mutuamente excluyente: o bien es un `Contratante` (billing de plataforma: tenant contrata un plan de Keygo para usar la plataforma) o bien es una `AppBillingAccount` (billing de app: usuario final contrata un plan ofrecido por la app de un tenant). Exactamente uno de los dos debe estar presente.

| Atributo | Descripción |
|----------|-------------|
| Identificador | UUID único. |
| Contratante | El contratante suscrito; presente en billing de plataforma. Mutuamente excluyente con `AppBillingAccount`. |
| Cuenta de billing de app | La cuenta del usuario en la app; presente en billing de app. Mutuamente excluyente con `Contratante`. |
| Aplicación cliente | La app a la que aplica. |
| Versión de plan | La versión vigente. |
| Contrato | El contrato que originó la suscripción (opcional). |
| Estado | `PENDING` → `ACTIVE` → `PAST_DUE` → `SUSPENDED` → `CANCELLED` / `EXPIRED` |
| Inicio del período actual | Comienzo del ciclo de facturación vigente. |
| Fin del período actual | Cierre del ciclo de facturación vigente. |
| Próxima fecha de cobro | Cuándo se ejecutará el siguiente cobro. |
| Renovación automática | Si la suscripción se renueva al final del período. |
| Cancelar al final del período | Si se cancelará al cierre del ciclo sin renovación. |

### Contador de Uso (`usage_counters`)

Registro del consumo de recursos de un contratante en una aplicación, por métrica y período. Se actualiza en respuesta a eventos de uso.

| Atributo | Descripción |
|----------|-------------|
| Contratante | El contratante cuyo uso se mide. |
| Aplicación cliente | La app en la que se mide el consumo. |
| Código de métrica | Qué recurso se está midiendo (ej. `MAX_USERS`). |
| Inicio del período | Comienzo del período de medición. |
| Fin del período | Cierre del período de medición. |
| Valor usado | Cantidad consumida en el período. |

### Factura (`invoices`)

Documento de cobro generado al cierre de cada ciclo de facturación. Incluye un snapshot de los datos de facturación vigentes al momento de la emisión.

| Atributo | Descripción |
|----------|-------------|
| Identificador | UUID único. |
| Número de factura | Identificador legible y único. |
| Contratante | El contratante facturado. |
| Aplicación cliente | La app facturada. |
| Suscripción | La suscripción que origina esta factura. |
| Estado | `DRAFT` → `ISSUED` → `PAID` / `VOID` / `OVERDUE` |
| Período | Rango de fechas que cubre la factura. |
| Fecha de emisión / vencimiento | Cuándo se emitió y hasta cuándo debe pagarse. |
| Moneda | ISO 4217. |
| Subtotal, impuesto, total | Importes en la moneda. |
| Pagada en | Cuándo fue cobrada. |
| Snapshot de datos | Nombre, ID fiscal, dirección, nombre del plan y versión al momento de la emisión; inmutable. |

### Transacción de Pago (`payment_transactions`)

Evento de pago vinculado a un contrato y/o suscripción. Registra el resultado de cada intento de cobro.

| Atributo | Descripción |
|----------|-------------|
| Contratante | El contratante cobrado. |
| Aplicación cliente | La app del contexto. |
| Contrato | El contrato asociado (opcional). |
| Suscripción | La suscripción asociada (opcional). |
| Monto / Moneda | Importe del cobro. |
| Estado | `PENDING` → `APPROVED` / `FAILED` / `REFUNDED` / `CANCELLED` |
| Pagado en / Reembolsado en | Marcas de tiempo del ciclo de pago. |
| Payload del proveedor | Respuesta del proveedor externo en formato estructurado. |

> El proveedor de pago externo opera con su propio modelo. Billing nunca depende directamente de ese modelo; una capa de traducción convierte sus eventos a eventos del dominio de Billing.

### Método de Pago (`payment_methods`)

Referencia externa a un instrumento de pago registrado por un contratante. No se persiste ningún dato sensible del instrumento (número de tarjeta, CVV); esa responsabilidad es exclusiva del proveedor de pago externo.

| Atributo | Descripción |
|----------|-------------|
| Contratante | El contratante propietario. |
| Referencia externa | Identificador del instrumento en el proveedor de pago. |
| Etiqueta para mostrar | Descripción legible del instrumento (ej. `Visa •••• 4242`). |
| Marca, últimos 4 dígitos | Datos de presentación para la interfaz. |
| Vencimiento | Mes y año de vencimiento. |
| Estado | `ACTIVE` / `INACTIVE` / `EXPIRED` |
| Es predeterminado | Solo un método puede ser el predeterminado por contratante. |

[↑ Volver al inicio](#entidades)

---

## Audit

El contexto Audit mantiene el registro inmutable de todo lo que ocurre en el sistema. Es un receptor puro: no reacciona a los eventos que persiste ni genera eventos propios.

### Evento de Auditoría (`audit_events`)

Registro principal de cualquier acción relevante para la seguridad o gobernanza. Append-only: ningún registro puede ser modificado o eliminado bajo ninguna circunstancia.

| Atributo | Descripción |
|----------|-------------|
| Ocurrió en | Marca de tiempo del evento; determina el orden cronológico. |
| Tipo de actor | `USER`, `SYSTEM`, `SERVICE` o `ANONYMOUS`. |
| Identidad de plataforma | La identidad que originó el evento (si aplica). |
| Miembro del tenant | El `tenant_user` que actuó (si aplica). |
| Contratante | El contratante del contexto (si aplica). |
| Organización | El tenant del contexto (si aplica). |
| Aplicación cliente | La app del contexto (si aplica). |
| Sesión de plataforma / OAuth | Las sesiones activas al momento del evento. |
| Capa de origen | `UI`, `BACKEND`, `SYSTEM`, `JOB`, `SECURITY` o `BILLING`. |
| Canal de origen | `WEB`, `API`, `WORKER`, `INTERNAL` o `SCHEDULED`. |
| Módulo / funcionalidad / pantalla / ruta | Ubicación en el sistema donde ocurrió el evento. |
| IDs de correlación | `request_id`, `correlation_id`, `trace_id`, `span_id` para trazabilidad distribuida. |
| Categoría / tipo / acción del evento | Clasificación jerárquica de qué ocurrió. |
| Resultado del evento | `SUCCESS`, `FAILURE`, `DENIED`, `ERROR` o `PARTIAL`. |
| Severidad | `DEBUG`, `INFO`, `WARNING`, `ERROR` o `CRITICAL`. |
| Entidad objetivo | Tipo e identificador de la entidad afectada. |
| Resumen | Descripción legible del evento. |
| Metadatos | Datos contextuales adicionales en formato estructurado. |
| Duración | Milisegundos que tomó la operación. |
| Puntaje de riesgo | Valoración de riesgo del evento (0-100). |

### Payload del Evento de Auditoría (`audit_event_payloads`)

Datos pesados del evento almacenados separadamente para mantener las consultas sobre `audit_events` eficientes. Append-only.

| Atributo | Descripción |
|----------|-------------|
| Evento de auditoría | El evento al que pertenece. |
| Payload de solicitud | Datos de la petición original. |
| Payload de respuesta | Datos de la respuesta. |
| Estado anterior | Estado de la entidad antes del cambio. |
| Estado posterior | Estado de la entidad después del cambio. |
| Diff | Diferencia entre estado anterior y posterior. |
| Contexto extra | Datos adicionales del contexto de ejecución. |

### Etiqueta del Evento de Auditoría (`audit_event_tags`)

Etiquetas de búsqueda asociadas a un evento de auditoría. Permiten clasificar y filtrar eventos por criterios transversales. Append-only.

| Atributo | Descripción |
|----------|-------------|
| Evento de auditoría | El evento etiquetado. |
| Etiqueta | Texto de clasificación. |

### Enlace de Entidad de Auditoría (`audit_entity_links`)

Vínculos desde un evento de auditoría hacia múltiples entidades afectadas. Permite reconstruir el impacto de una acción sobre varios objetos del sistema. Append-only.

| Atributo | Descripción |
|----------|-------------|
| Evento de auditoría | El evento que originó el impacto. |
| Tipo de entidad vinculada | Qué tipo de entidad fue afectada. |
| Identificador de entidad vinculada | El UUID de la entidad afectada. |
| Tipo de relación | Cómo se relaciona la entidad con el evento (ej. `SUBJECT`, `TARGET`, `CONTEXT`). |

[↑ Volver al inicio](#entidades)

---

[← Índice](./README.md) | [Siguiente >](./relationships.md)
