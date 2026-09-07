# Capability Extraction Boundaries

**Applies from:** 2026-09-07  
**Decision:** `DEC-KEYGO-SCOPE-001`  
**KeyGo initiative:** `INIT-KEYGO-001`  
**Target capability:** `CAP-IAM-001`

This document describes the target ownership boundary and transition classification for commercial concerns currently embedded in KeyGo. It is a **target architecture/governance map**, not evidence that migration is complete.

## Classification vocabulary

| Classification | Meaning |
|---|---|
| `KEEP_KEYGO` | Remains owned by KeyGo / CAP-IAM-001. |
| `EXTRACT_SUBSCRIPTION` | Target ownership moves to INIT-SUB-001 / CAP-SUB-001. |
| `EXTRACT_PAYMENT` | Target ownership moves to INIT-PAY-001 / CAP-PAY-001. |
| `SHARED_CONTRACT` | Cross-capability reference/contract; no shared table ownership. |
| `BOUNDARY_UNRESOLVED` | Target ownership is intentionally open pending evidence. |
| `DEPRECATE` | Candidate obsolete behavior; requires explicit later retirement decision. |

## Entity/data classification

### KEEP_KEYGO

- `platform_users`
- email-verification / credential-recovery artifacts
- `platform_sessions`
- `oauth_sessions`
- `authorization_codes`
- `refresh_tokens`
- `signing_keys`
- `tenants`
- `tenant_users`
- tenant invitations where present
- tenant/platform role definitions, hierarchies and assignments
- `client_apps`
- application roles, memberships, grants/scopes and authorization data
- identity/security audit records and actor/session provenance

### EXTRACT_SUBSCRIPTION

- `app_plans`
- `app_plan_versions`
- `app_plan_billing_options`
- `app_plan_entitlements`
- `app_contracts` where they represent subscription/commercial contracting
- `app_subscriptions`
- `usage_counters` where their purpose is plan entitlement/quota evaluation
- subscription renewal/trial/grace/pause/cancel jobs and policies

### EXTRACT_PAYMENT

- `payment_transactions`
- `payment_methods` limited to safe provider references/display metadata
- provider payment gateway/adapters
- provider webhook/payment callback handling
- payment idempotency/correlation/reconciliation logic
- refund/dispute logic when present or later added

### BOUNDARY_UNRESOLVED

- `invoices`
- `tenant_billing_profiles`
- fiscal/tax identifiers and tax-document semantics
- accounting ledger effects
- settlement/payout semantics
- contractor/payer constructs that mix commercial, identity and fiscal responsibilities

## Why invoices are not automatically “Payment”

Payment execution, commercial subscription, invoicing, taxation and accounting have different invariants. The historic KeyGo `Billing` context grouped several of them for implementation convenience. Extraction must not repeat that mistake by moving the entire group wholesale into CAP-PAY.

## Target capability contracts

The following are conceptual contract families, not final API/schema commitments.

### CAP-IAM-001

- `IdentityRef`
- `TenantRef`
- `ApplicationRef`
- `MembershipContext`
- `AuthorizationDecision`
- `ActorContext`
- session/token/key protocol contracts

### CAP-SUB-001

- `CommercialProductRef`
- `PlanRef` / `PlanVersionRef`
- `SubscriptionRef`
- `SubscriptionState`
- `EntitlementDecision`
- `QuotaState`
- `UsageMeasure`
- provider subscription binding/reference

### CAP-PAY-001

- `PaymentRequest`
- `PaymentTransactionRef`
- `PaymentState`
- `PaymentMethodRef`
- `ProviderExecutionRef`
- `RefundRef`
- `ReconciliationResult`

Consumers must not couple to internal tables or provider SDK types when a stable capability contract exists.

## Key invariants

1. IAM authorization and commercial entitlement are independent decisions.
2. Payment state is not subscription state.
3. Subscription state is not user/account state.
4. A KeyGo Tenant is an IAM concept; a consumer business Organization is a product-domain concept.
5. A KeyGo ClientApplication is a security/protocol concept; a commercial Product is not the same object.
6. Commercial entitlement claims in IAM tokens, if ever used, are derived/cache snapshots with explicit freshness—not authority.
7. Cross-capability target integration does not use shared database tables.
8. Current physical implementation location is not permanent semantic ownership.

## Provider adapter models

### Subscription

CAP-SUB must leave open three strategies:

- **Native:** ADÜMÜN owns subscription lifecycle and uses CAP-PAY for collection.
- **Delegated:** external subscription provider performs substantial lifecycle mechanics; CAP-SUB normalizes state.
- **Hybrid:** ADÜMÜN owns product/entitlement semantics while an external provider owns selected billing-cycle/collection functions.

### Payment

CAP-PAY is expected to orchestrate provider adapters rather than become a payment network. It must normalize common state while preserving provider capability/constraint differences.

## Cross-capability flow example: subscription renewal

1. CAP-SUB determines renewal is due.
2. CAP-SUB requests collection via the payment contract.
3. CAP-PAY executes using a provider adapter.
4. CAP-PAY reconciles and returns authoritative normalized payment result.
5. CAP-SUB applies commercial policy and transitions subscription state.
6. CAP-IAM authenticates/authorizes human/workload actors where required but does not determine renewal or payment state.

## Cross-capability flow example: reservation payment

1. INIT-RES-001 owns reservation/payment policy.
2. For `PAY_ON_SITE`, CAP-PAY may not be involved at all.
3. For prepayment/deposit, INIT-RES requests a transaction through CAP-PAY.
4. CAP-PAY executes/reconciles money movement.
5. INIT-RES applies the payment result to reservation confirmation/expiry/capacity rules.
6. This is independent from the provider organization's SaaS subscription managed through CAP-SUB.

## Transition plan

### M0 — Boundary freeze

- Accept target boundary.
- Avoid adding new commercial responsibilities to KeyGo by default.

### M1 — Complete inventory

Inventory:

- database entities/migrations;
- domain entities/services;
- REST/API endpoints;
- scheduled jobs;
- provider adapters;
- webhooks/events;
- console/platform UI routes/components;
- tests/fixtures;
- consumers and external data contracts.

Every item receives one classification from this document.

### M2 — Define capability contracts

Create machine-readable contracts only after INIT-SUB/INIT-PAY lifecycle evidence justifies them. Validate identity/reference, tenancy, idempotency, audit and provider portability semantics.

### M3 — Insert anti-corruption ports/adapters

Consumers stop depending on KeyGo Billing internals. The existing KeyGo implementation may temporarily implement CAP-SUB/CAP-PAY contracts through explicitly named legacy adapters.

### M4 — Authority/data migration

When a target implementation is authorized:

- preserve source IDs/correlation/provenance;
- validate data mapping and plan-version/subscription/payment lineage;
- use safe dual-read/verification or equivalent migration evidence when required;
- retain rollback.

### M5 — Consumer cutover

Cut over consumers independently, starting with bounded/non-critical integrations. Do not retire legacy endpoints before all authoritative consumers have moved.

### M6 — Legacy retirement

Retire KeyGo commercial code only after explicit evidence/decision. Historical migrations/docs remain preserved for provenance.

## Repository posture

- `cmartinezs/keygo-docs` remains the canonical documentation source for current KeyGo implementation and scope transition.
- `cmartinezs/keygo-server` and `cmartinezs/keygo-web-ui` remain current implementation sources.
- INIT-SUB-001 and INIT-PAY-001 do not receive repositories merely because their governed identities now exist; repository creation is deferred until machine-contract, experiment or implementation authority exists.

## Related records

- [Scope reconciliation](../01-discovery/scope-reconciliation-2026-09-07.md)
- [Current bounded-context index](./bounded-contexts/README.md)
- [ADÜMÜN KeyGo scope decision](https://docs.google.com/document/d/1dq48YayQh2gEZehqHG4P05DwIHWrtDB79njczs7loW8/edit)
- [ADÜMÜN extraction map](https://docs.google.com/document/d/1FL6QlS755y3tmQROEM3ekmq7Yz7EXijm9ujq8bV64VQ/edit)
