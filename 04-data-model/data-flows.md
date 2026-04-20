[← Índice](./README.md) | [< Anterior](./relationships.md)

---

# Flujos de Datos

Descripción de cómo la información se crea, transforma y mueve a través del sistema durante las operaciones principales. Cada flujo muestra qué entidades participan, en qué orden, y qué produce como resultado.

## Contenido

- [Flujo 1: Contratación y activación de organización](#flujo-1-contratación-y-activación-de-organización)
- [Flujo 2: Autenticación](#flujo-2-autenticación)
- [Flujo 3: Renovación de sesión](#flujo-3-renovación-de-sesión)
- [Flujo 4: Revocación por detección de replay attack](#flujo-4-revocación-por-detección-de-replay-attack)
- [Flujo 5: Incorporación de miembro al tenant](#flujo-5-incorporación-de-miembro-al-tenant)
- [Flujo 6: Incorporación de usuario a una aplicación](#flujo-6-incorporación-de-usuario-a-una-aplicación)
- [Flujo 7: Suspensión de organización por impago](#flujo-7-suspensión-de-organización-por-impago)
- [Flujo 8: Registro de auditoría](#flujo-8-registro-de-auditoría)
- [Flujo 9: Contratación de plan por usuario de una app](#flujo-9-contratación-de-plan-por-usuario-de-una-app)

---

## Flujo 1: Contratación y activación de organización

Describe cómo se crea un contratante, un tenant operativo y su suscripción activa a partir del proceso de contratación. El flujo se inicia antes de que exista una cuenta de plataforma.

```mermaid
sequenceDiagram
    actor Interesado
    participant Billing
    participant PagoExterno as Proveedor de Pago
    participant Identity
    participant Organization as Organization (tenants)

    Interesado->>Billing: seleccionar plan y enviar datos de contacto
    Billing->>Billing: crear app_contract (estado: DRAFT)
    Billing->>Billing: emitir contract_email_verification
    Billing-->>Interesado: código de verificación de email

    Interesado->>Billing: confirmar código de verificación
    Billing->>Billing: registrar contractor_email_verified_at en app_contract
    Billing->>Billing: app_contract → PENDING_PAYMENT

    Billing->>PagoExterno: solicitar cobro inicial
    PagoExterno-->>Billing: pago confirmado (evento del proveedor traducido a dominio)
    Billing->>Billing: crear payment_transaction (APPROVED)
    Billing->>Billing: app_contract → READY_TO_ACTIVATE

    Billing->>Billing: crear contractor (si no existía)
    Billing->>Billing: app_contract → ACTIVE
    Billing->>Billing: crear app_subscription (ACTIVE)
    Billing->>Billing: inicializar usage_counters en cero

    Billing-->>Organization: señal: suscripción activa
    Organization->>Organization: crear tenant (ACTIVE)

    Identity->>Identity: crear platform_user para el contratante (si no existía)
    Identity->>Identity: asignar rol KEYGO_ACCOUNT_ADMIN (scope TENANT)
    Organization->>Organization: crear tenant_user (ACTIVE) para el contratante

    Billing-->>Audit: ContratoActivado, SuscripciónActivada, PagoConfirmado
    Organization-->>Audit: OrganizaciónCreada, UsuarioDadoDeAlta
```

**Entidades creadas:** `app_contract`, `contract_email_verification`, `contractor`, `payment_transaction`, `app_subscription`, `usage_counters`, `tenant`, `platform_user` (si nuevo), `platform_user_roles`, `tenant_user`.

**Estado final:** El tenant está operativo. El contratante tiene una suscripción activa y es el Administrador de Organización de ese tenant.

[↑ Volver al inicio](#flujos-de-datos)

---

## Flujo 2: Autenticación

Describe cómo una identidad obtiene sus credenciales de acceso a través de una aplicación cliente registrada. El flujo produce una `platform_session`, una `oauth_session` y un `refresh_token`. El acceso token (credencial de sesión) se emite firmado y no se persiste en la base de datos.

```mermaid
sequenceDiagram
    actor Usuario
    participant App as Aplicación Cliente
    participant Identity
    participant AccessControl as Access Control
    participant Audit

    Usuario->>App: iniciar sesión
    App->>Identity: solicitar flujo de autenticación (con desafío PKCE)
    Identity->>Identity: verificar que client_app está ACTIVE
    Identity->>Identity: verificar credenciales del usuario (platform_users)
    Identity->>Identity: crear platform_session (ACTIVE)
    Identity->>Identity: crear authorization_code (hash, estado: ACTIVE)
    Identity-->>App: código de autorización (valor en texto plano, una sola vez)

    App->>Identity: canjear código (con verificador PKCE)
    Identity->>Identity: verificar hash del código y verificador PKCE
    Identity->>Identity: authorization_code → USED
    Identity->>AccessControl: consultar roles efectivos del tenant_user en la app
    AccessControl-->>Identity: roles efectivos resueltos (aplicando jerarquía)
    Identity->>Identity: crear oauth_session (ACTIVE, ámbitos concedidos)
    Identity->>Identity: emitir access token firmado (no persiste en DB)
    Identity->>Identity: crear refresh_token (hash, estado: ACTIVE)
    Identity-->>App: access token + refresh token (valores en texto plano, una sola vez)

    Identity-->>Audit: SesiónIniciada
```

**Entidades creadas:** `platform_session`, `authorization_code`, `oauth_session`, `refresh_token`.

**Estado final:** El usuario tiene una sesión de plataforma y una sesión OAuth activas. El access token embebe los roles efectivos fijados en el momento de emisión. El refresh token se almacena como hash.

[↑ Volver al inicio](#flujos-de-datos)

---

## Flujo 3: Renovación de sesión

Describe cómo se obtiene un nuevo access token sin que el usuario deba autenticarse nuevamente. La Credencial de Renovación se rota en cada uso.

```mermaid
sequenceDiagram
    actor Usuario
    participant App as Aplicación Cliente
    participant Identity
    participant Audit

    Usuario->>App: access token expirado
    App->>Identity: renovar sesión (refresh token en texto plano)
    Identity->>Identity: calcular hash del refresh token recibido
    Identity->>Identity: buscar refresh_token por hash
    Identity->>Identity: verificar que está ACTIVE y no expirado
    Identity->>Identity: verificar que oauth_session está ACTIVE
    Identity->>Identity: verificar que platform_user está ACTIVE
    Identity->>Identity: refresh_token anterior → USED, registrar replaced_by_id
    Identity->>Identity: crear nuevo refresh_token (nuevo hash, referencia al anterior)
    Identity->>Identity: emitir nuevo access token firmado (no persiste en DB)
    Identity-->>App: nuevo access token + nuevo refresh token
    Identity-->>Audit: CredencialDeRenovaciónRotada
```

**Entidades afectadas:** `refresh_token` anterior (→ USED, `replaced_by_id` apunta al nuevo), nuevo `refresh_token` (ACTIVE).

**Estado final:** La sesión OAuth sigue activa con un nuevo par de tokens. El refresh token anterior queda invalidado y encadenado al nuevo mediante `replaced_by_id`.

[↑ Volver al inicio](#flujos-de-datos)

---

## Flujo 4: Revocación por detección de replay attack

Describe la respuesta del sistema cuando se detecta el uso de un refresh token que ya había sido rotado. La cadena `replaced_by_id` permite reconstruir la familia de tokens comprometida.

```mermaid
sequenceDiagram
    actor Atacante
    participant Identity
    participant Audit

    Atacante->>Identity: usar refresh token ya rotado
    Identity->>Identity: calcular hash del token recibido
    Identity->>Identity: encontrar refresh_token con ese hash
    Identity->>Identity: detectar que el estado es USED (ya fue rotado)
    Identity->>Identity: revocar toda la familia de refresh_tokens de la oauth_session
    Identity->>Identity: oauth_session → TERMINATED
    Identity->>Identity: platform_session → TERMINATED (si corresponde)
    Identity-->>Audit: AtaqueDeReproducciónDetectado (prioridad CRITICAL)
    Identity-->>Audit: SesiónRevocada (prioridad CRITICAL)
```

**Entidades afectadas:** Todos los `refresh_token` de la `oauth_session` afectada (→ REVOKED), `oauth_session` (→ TERMINATED).

**Estado final:** La identidad pierde la sesión afectada. Debe re-autenticarse. El evento queda registrado con severidad crítica. La cadena de `replaced_by_id` permite al equipo de seguridad reconstruir la secuencia del ataque.

[↑ Volver al inicio](#flujos-de-datos)

---

## Flujo 5: Incorporación de miembro al tenant

Describe cómo el Administrador de Organización da de alta a una identidad de plataforma existente como miembro del tenant.

```mermaid
sequenceDiagram
    actor Admin as Administrador de Organización
    participant Organization
    participant Identity
    participant Billing
    participant Audit

    Admin->>Organization: dar de alta a identidad (por platform_user_id)
    Organization->>Identity: verificar que platform_user existe y está ACTIVE
    Organization->>Billing: verificar que no se ha alcanzado el límite de usuarios
    Billing-->>Organization: límite no alcanzado

    Organization->>Organization: crear tenant_user (ACTIVE)
    Organization->>Billing: señal: nuevo miembro dado de alta
    Billing->>Billing: incrementar usage_counter (metric_code = MAX_USERS)
    Billing->>Billing: evaluar si se alcanza el límite del plan

    Organization-->>Audit: UsuarioDadoDeAlta

    Note over Billing, Audit: Si el alta supera el límite del plan

    Billing->>Billing: emitir señal: LímiteDeUsuariosAlcanzado
    Billing-->>Audit: LímiteDeUsuariosAlcanzado
    Organization->>Organization: bloquear nuevas incorporaciones hasta que el límite se amplíe
```

**Entidades creadas:** `tenant_user`.
**Entidades afectadas:** `usage_counters` (incremento de `MAX_USERS`).

**Estado final:** La identidad es miembro activo del tenant. Si el alta supera el límite del plan, las nuevas incorporaciones quedan bloqueadas.

[↑ Volver al inicio](#flujos-de-datos)

---

## Flujo 6: Incorporación de usuario a una aplicación

Describe cómo un miembro del tenant obtiene acceso a una aplicación cliente. El camino depende de la `registration_policy` de la app.

```mermaid
sequenceDiagram
    actor Admin as Administrador de Organización
    actor Usuario
    participant AccessControl as Access Control
    participant ClientApps as Client Applications
    participant Audit

    Note over Admin, Audit: Política: INVITE_ONLY

    Admin->>AccessControl: crear membresía para tenant_user en app
    AccessControl->>ClientApps: verificar que client_app está ACTIVE
    AccessControl->>AccessControl: crear app_membership (estado: INVITED)
    AccessControl->>AccessControl: asignar app_roles predeterminados a la membresía
    AccessControl-->>Usuario: notificación de invitación
    AccessControl-->>Audit: InvitaciónEnviada (membresía INVITED)

    Usuario->>AccessControl: aceptar invitación
    AccessControl->>AccessControl: app_membership → ACTIVE
    AccessControl-->>Audit: MembresíaActivada

    Note over Admin, Audit: Política: OPEN_AUTO_ACTIVE

    Usuario->>AccessControl: solicitar acceso a la app
    AccessControl->>ClientApps: verificar registration_policy = OPEN_AUTO_ACTIVE
    AccessControl->>AccessControl: crear app_membership (ACTIVE)
    AccessControl->>AccessControl: asignar app_roles predeterminados
    AccessControl-->>Audit: MembresíaCreada

    Note over Admin, Audit: Política: OPEN_AUTO_PENDING

    Usuario->>AccessControl: solicitar acceso a la app
    AccessControl->>ClientApps: verificar registration_policy = OPEN_AUTO_PENDING
    AccessControl->>AccessControl: crear app_membership (PENDING)
    AccessControl-->>Audit: SolicitudDeAccesoPendiente
    Admin->>AccessControl: aprobar solicitud
    AccessControl->>AccessControl: app_membership → ACTIVE
    AccessControl-->>Audit: MembresíaActivada
```

**Entidades creadas:** `app_membership`, `app_membership_roles` (con roles predeterminados).

**Estado final:** El usuario tiene una membresía activa en la aplicación. En la próxima autenticación, sus roles efectivos incluirán los de esta membresía.

[↑ Volver al inicio](#flujos-de-datos)

---

## Flujo 7: Suspensión de organización por impago

Describe cómo se propaga la suspensión de una organización a través del sistema cuando la suscripción entra en impago definitivo.

```mermaid
sequenceDiagram
    participant PagoExterno as Proveedor de Pago
    participant Billing
    participant Organization
    participant AccessControl as Access Control
    participant Identity
    participant Audit

    PagoExterno-->>Billing: pago rechazado (evento del proveedor traducido)
    Billing->>Billing: crear payment_transaction (FAILED)
    Billing->>Billing: app_subscription → PAST_DUE (período de gracia activo)
    Billing-->>Audit: SuscripciónEnRiesgo, PagoRechazado

    Note over Billing, Audit: Período de gracia vencido sin pago

    Billing->>Billing: app_subscription → SUSPENDED
    Billing-->>Organization: señal: SuscripciónSuspendida
    Organization->>Organization: tenant → SUSPENDED
    Organization->>Organization: todos los tenant_users quedan operativamente inhabilitados

    Organization-->>AccessControl: señal: OrganizaciónSuspendida
    AccessControl->>AccessControl: app_memberships del tenant → SUSPENDED

    Organization-->>Identity: señal: OrganizaciónSuspendida
    Identity->>Identity: oauth_sessions activas del tenant → TERMINATED
    Identity->>Identity: refresh_tokens asociados → REVOKED

    Billing-->>Audit: SuscripciónSuspendida
    Organization-->>Audit: OrganizaciónSuspendida
    AccessControl-->>Audit: MembresíasSuspendidas
    Identity-->>Audit: SesionesRevocadas (por cada sesión afectada)
```

**Entidades afectadas:** `app_subscription` (→ SUSPENDED), `tenant` (→ SUSPENDED), `app_memberships` del tenant (→ SUSPENDED), `oauth_sessions` activas (→ TERMINATED), `refresh_tokens` (→ REVOKED).

**Estado final:** El tenant está inhabilitado. Ningún miembro puede autenticarse ni usar las aplicaciones de ese tenant. Todos los eventos quedan registrados en Audit con severidad CRITICAL.

[↑ Volver al inicio](#flujos-de-datos)

---

## Flujo 8: Registro de auditoría

Describe cómo cada operación del sistema produce un evento inmutable en el registro de auditoría.

```mermaid
sequenceDiagram
    participant ContextoOrigen as Contexto origen (cualquiera)
    participant Audit
    participant Admin as Administrador de Organización
    participant KeygoAdmin as KEYGO_ADMIN (Platform)

    ContextoOrigen->>ContextoOrigen: ejecutar operación de dominio
    ContextoOrigen->>Audit: emitir audit_event (append-only)
    Audit->>Audit: persistir audit_event
    Audit->>Audit: persistir audit_event_payload (si tiene estado antes/después)
    Audit->>Audit: persistir audit_event_tags (si aplica)
    Audit->>Audit: persistir audit_entity_links (entidades afectadas)

    Note over Admin, Audit: Consulta por Administrador de Organización

    Admin->>Audit: consultar audit_events (filtrado por su tenant_id)
    Audit-->>Admin: eventos de su organización solamente

    Note over KeygoAdmin, Audit: Consulta por KEYGO_ADMIN

    KeygoAdmin->>Audit: consultar audit_events de tenant X
    Audit->>Audit: crear audit_event: AccesoDeAdminAlRegistroDeAuditoría
    Audit-->>KeygoAdmin: eventos del tenant X
```

**Entidades creadas por cada operación:** `audit_event`, opcionalmente `audit_event_payload`, `audit_event_tags`, `audit_entity_links`.

**Invariantes del flujo:**
- `audit_events`, `audit_event_payloads`, `audit_event_tags` y `audit_entity_links` son append-only: ninguna fila puede ser modificada o eliminada, por ningún actor, bajo ninguna circunstancia.
- El aislamiento es obligatorio: el Administrador de Organización solo accede a los eventos de su tenant.
- Todo acceso de un `KEYGO_ADMIN` al registro de un tenant genera automáticamente un nuevo `audit_event` dentro del registro de ese tenant.
- El orden cronológico se determina por `occurred_at` (cuándo ocurrió), no por `created_at` (cuándo se persistió).

[↑ Volver al inicio](#flujos-de-datos)

---

## Flujo 9: Contratación de plan por usuario de una app

Describe cómo un usuario final contrata un plan ofrecido por una aplicación cliente. El flujo produce una `app_billing_account` (si no existía), un `app_contract` y una `app_subscription` activa, y vincula la membresía existente del usuario con su cuenta de billing.

```mermaid
sequenceDiagram
    actor Usuario
    participant AccessControl as Access Control
    participant Billing
    participant Audit

    Usuario->>AccessControl: iniciar flujo de contratación de plan
    AccessControl->>AccessControl: verificar que app_membership del usuario está ACTIVE
    AccessControl->>Billing: consultar catálogo de planes activos de la app

    Billing-->>AccessControl: versiones de plan disponibles con opciones de facturación
    AccessControl-->>Usuario: presentar catálogo de planes

    Usuario->>Billing: seleccionar versión de plan y cadencia de facturación
    Billing->>Billing: crear app_billing_account (si no existe; máximo una por usuario+app)
    Billing->>Billing: crear app_contract (estado: DRAFT)
    Billing->>Billing: emitir contract_email_verification
    Billing-->>Usuario: código de verificación de email de contacto

    Usuario->>Billing: confirmar código de verificación
    Billing->>Billing: app_contract → PENDING_PAYMENT

    Note over Billing, Audit: La app cliente gestiona el cobro externamente y notifica al sistema

    Billing->>Billing: crear payment_transaction (APPROVED)
    Billing->>Billing: app_contract → ACTIVE
    Billing->>Billing: crear app_subscription (ACTIVE)

    Billing-->>AccessControl: señal: suscripción activada
    AccessControl->>AccessControl: app_membership.app_billing_account_id → id de la cuenta
    AccessControl-->>Audit: MembresíaVinculadaACuentaDeBilling

    Note over Billing, Audit: Derechos disponibles en la próxima emisión de sesión OAuth

    Billing-->>Audit: ContratoActivado, SuscripciónActivada
```

**Entidades creadas:** `app_billing_account` (si es primera contratación del usuario en esa app), `contract_email_verification`, `app_contract`, `payment_transaction`, `app_subscription`.

**Entidades afectadas:** `app_membership.app_billing_account_id` (vinculado al activarse la suscripción).

**Estado final:** El usuario tiene una suscripción activa al plan seleccionado. La membresía queda vinculada a su cuenta de billing de app. En la próxima autenticación (o renovación de sesión OAuth), los derechos del plan quedan embebidos en el contexto de sesión según RF24.

[↑ Volver al inicio](#flujos-de-datos)

---

[← Índice](./README.md) | [< Anterior](./relationships.md)
