[← Índice](./README.md) | [< Anterior](./system-vision.md) | [Siguiente >](./actors.md)

---

# Alcance del Sistema

> [!IMPORTANT]
> Este documento fue reconciliado el **2026-09-07** por `DEC-KEYGO-SCOPE-001`. KeyGo target ownership se limita a `CAP-IAM-001 — Identity, Tenancy & Access Management`. El Billing actualmente implementado se conserva como estado legacy/current y como fuente para migración, pero **subscription/entitlement** pasa a `INIT-SUB-001 / CAP-SUB-001` y **payment execution** a `INIT-PAY-001 / CAP-PAY-001`. Ver [Scope Reconciliation](scope-reconciliation-2026-09-07.md).

## Contenido

- [Propósito](#propósito)
- [Alcance funcional](#alcance-funcional)
- [Alcance del MVP](#alcance-del-mvp)
- [Capacidades externas relacionadas](#capacidades-externas-relacionadas)
- [Fuera de alcance de KeyGo](#fuera-de-alcance-de-keygo)
- [Otras consideraciones](#otras-consideraciones)

---

## Propósito

Keygo se establece como el punto central de **identidad, autenticación, autorización y contexto de acceso** para ecosistemas SaaS multi-organización. Su propósito es proveer a las aplicaciones cliente contratos estables para resolver quién es el principal, cómo se autenticó, bajo qué tenant/aplicación opera y qué autorizaciones tiene, evitando que cada aplicación implemente estas responsabilidades independientemente.

El alcance objetivo comprende el ciclo de vida de identidad y acceso: identidades, credenciales/federación cuando corresponda, sesiones/tokens, tenants, memberships, aplicaciones cliente, scopes/roles/grants, revocación, claves y trazabilidad de seguridad.

**KeyGo no es el sistema comercial universal de los consumidores que autentica.** Que una aplicación use KeyGo como IAM no implica que deba usar KeyGo para suscripciones, entitlements, payments, invoicing o accounting.

---

## Alcance funcional

| # | Capacidad | Descripción | Valor estratégico |
|---|-----------|-------------|-------------------|
| **1** | **Gestión de tenants / organizaciones IAM** | Registro, configuración, aislamiento y ciclo de vida del boundary IAM multi-tenant. | Base del aislamiento y del contexto de acceso. |
| **2** | **Identidad y autenticación** | Identidad global, credenciales, inicio/cierre de sesión, renovación/revocación, recuperación y métodos de autenticación soportados. | Elimina duplicación de autenticación en cada aplicación. |
| **3** | **Memberships por tenant** | Incorporación/invitación, activación, suspensión y baja de una identidad en uno o más tenants. | Separa identidad global de pertenencia organizacional. |
| **4** | **Autorización** | Roles, permisos, grants/scopes y evaluación con límites explícitos platform/tenant/application. | Evita privilegios ambiguos y centraliza controles de acceso reutilizables. |
| **5** | **Registro y gestión de aplicaciones cliente** | OAuth/OIDC clients, redirect URIs, scopes, consentimiento/políticas y ciclo de vida de aplicaciones integradas. | Permite integración segura y protocol-oriented. |
| **6** | **Sesiones, tokens y claves** | Platform/OAuth sessions, authorization codes, refresh tokens, revocación, signing keys/JWKS y rotación. | Hace explícito y testeable el trust boundary. |
| **7** | **Federación y account linking** | Integración con IdP externos/sociales, verified identifiers y vinculación segura de identidades, cuando sea validado/implementado. | Mantiene una identidad durable independientemente del método de login. |
| **8** | **Auditoría y actor context** | Eventos de seguridad, actor/session/client context, cambios de roles/access y trazabilidad IAM. | Soporte, investigación y gobernanza de seguridad. |
| **9** | **Integración con ecosistema** | Contratos/protocolos estables, claims/context y eventos IAM necesarios para consumidores. | Multiplica reuse sin compartir tablas internas. |
| **10** | **Workload/service identities** | Identidades no-humanas y grants acotados para servicios/jobs cuando el riesgo y consumidores lo justifiquen. | Evita credenciales humanas compartidas en automatización. |

### Regla de alcance

Las capacidades anteriores responden a IAM/trust. Los consumidores son dueños de sus conceptos de negocio. Un `Tenant` de KeyGo es un boundary IAM; no sustituye automáticamente a `ProviderOrganization`, `Customer`, `Workspace`, `BusinessUnit` u otra entidad de dominio.

---

## Alcance del MVP

El MVP objetivo de KeyGo debe validar **identidad y acceso**, no monetización comercial.

Capacidades mínimas a considerar, sujetas a la reconciliación real del estado existente:

1. Identidad y autenticación básica.
2. Registro/configuración de tenant.
3. Memberships y estado del miembro.
4. Registro/configuración de aplicaciones cliente.
5. Autorización básica y separación de scopes platform/tenant/application.
6. Sesión/token/revocación con contratos explícitos.
7. Eventos/auditoría de seguridad esenciales.
8. Integración protocol-oriented para al menos un consumidor acotado.

**Facturación, plan y suscripción ya no forman parte del target MVP de KeyGo.** La funcionalidad que existe actualmente debe inventariarse y migrarse sin big-bang, de acuerdo con [Capability Extraction Boundaries](../03-design/capability-extraction-boundaries.md).

---

## Capacidades externas relacionadas

### CAP-SUB-001 — Subscription & Entitlement Management

Produce `INIT-SUB-001`. Es dueño candidato de product/plan/version, subscription lifecycle, commercial entitlements/quotas, usage/metering asociado y adapters de subscription providers.

KeyGo puede aportar `IdentityRef`, `TenantRef`, `ApplicationRef` y `ActorContext`; no comparte tablas ni se convierte en source of truth comercial.

### CAP-PAY-001 — Payment Orchestration

Produce `INIT-PAY-001`. Es dueño candidato de payment request/transaction state, provider execution, idempotency, callbacks/webhooks, refunds/disputes y reconciliation.

KeyGo puede autenticar/autorizar actores o workloads; no determina éxito de pago ni transforma payment state en user/account state.

### Invoicing / Tax / Accounting

Permanece `BOUNDARY_UNRESOLVED` donde el código legacy de Billing mezcla invoices, fiscal profiles u otros conceptos. No se asigna automáticamente a CAP-PAY.

---

## Fuera de alcance de KeyGo

- producto/plan comercial del consumidor;
- subscription lifecycle del consumidor;
- entitlements, feature flags comerciales y quotas adquiridas;
- usage billing comercial como source of truth;
- payment transactions/provider orchestration;
- refunds, chargebacks y payment reconciliation;
- invoices/receipts/tax/accounting como responsabilidad IAM;
- reglas de negocio del producto consumidor;
- utilizar IAM roles como sustituto de commercial entitlement.

### Regla Authorization ≠ Entitlement

KeyGo responde **si el actor está autorizado**. CAP-SUB responde **si el cliente tiene derecho comercial/cuota**. El producto combina ambas decisiones según su dominio.

---

## Otras consideraciones

### Dependencias y supuestos

- Las aplicaciones consumidoras integran KeyGo mediante protocolos/contratos estables, no tablas internas.
- Federation/social login, passkeys/MFA u otros métodos se incorporan con requisitos de seguridad explícitos.
- Commercial capabilities pueden usar KeyGo para IAM, pero sus lifecycles y fuentes de verdad permanecen independientes.
- Los consumidores no deben quedar bloqueados indefinidamente por madurez insuficiente de KeyGo; una solución gestionada compatible puede utilizarse detrás de una abstracción cuando la etapa de solución lo justifique.
- Cualquier claim comercial derivado en un token es snapshot/cache con freshness explícita, nunca entitlement authority permanente.

### Límites operativos

Los límites de usuarios, apps, sesiones, retención y disponibilidad deben definirse mediante evidencia/operación y no confundirse con límites de un plan comercial. Los límites comerciales son CAP-SUB; los límites técnicos/seguridad de KeyGo son IAM/operability.

---

## Estado de transición

- Target scope: **RECONCILED**.
- Current implementation: aún contiene Billing/subscription/payment concerns.
- Code/data/UI extraction: **NOT COMPLETE**.
- Initiative Lifecycle: `INIT-KEYGO-001` continúa `RECONCILIATION_REQUIRED` hasta una reconstrucción explícita bajo ADÜMÜN ILS.
- Destructive refactor/deletion: **NOT AUTHORIZED** por esta decisión.

Referencias:

- [Scope Reconciliation 2026-09-07](scope-reconciliation-2026-09-07.md)
- [Capability Extraction Boundaries](../03-design/capability-extraction-boundaries.md)

---

[← Índice](./README.md) | [< Anterior](./system-vision.md) | [Siguiente >](./actors.md)
