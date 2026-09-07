# KeyGo Scope Reconciliation — 2026-09-07

**Governed initiative:** `INIT-KEYGO-001`  
**Target capability:** `CAP-IAM-001 — Identity, Tenancy & Access Management`  
**Decision:** `DEC-KEYGO-SCOPE-001`  
**Status:** ACCEPTED target-scope reconciliation; lifecycle remains `RECONCILIATION_REQUIRED`  
**Date:** 2026-09-07

## 1. Why this reconciliation exists

KeyGo's strongest and most durable proposition is IAM: identity, authentication, tenant/workspace isolation and membership, application/client registration, authorization and security/audit context.

Over time, KeyGo also accumulated a substantial commercial `Billing` domain: plan catalog, subscriptions, entitlements, usage counters, invoices, payment transactions/method references, contract flows and billing UIs. Those features are real implementation assets, but their physical location in KeyGo does not make them permanent IAM responsibilities.

A concrete consumer, `INIT-RES-001 — Agnostic Reservations & Capacity Platform`, made the boundary problem explicit. That product needs all of the following, independently:

1. IAM for customers, provider organizations, memberships, applications and platform/tenant authorization.
2. SaaS subscription/entitlement management for provider organizations paying to use the product.
3. Payment execution for individual reservation charges and, potentially, subscription collection.

Treating all three as “KeyGo” would turn an IAM platform into a general SaaS commercial platform and make consumer boundaries harder rather than easier.

## 2. Accepted target KeyGo boundary

KeyGo / `CAP-IAM-001` owns the answer to:

- Who is this principal?
- How was it authenticated?
- Under which tenant/application context is it acting?
- Which memberships, roles, grants, permissions or scopes apply?
- Is this principal authorized to perform the requested security-scoped action?
- Which session/client/workload context produced the action?
- How are sessions, credentials, tokens, keys and access revoked/recovered/audited?

### KEEP in KeyGo target ownership

- durable identities and verified identifiers;
- local credentials/recovery where supported;
- federation/social identities and account linking;
- platform sessions and OAuth/OIDC sessions;
- authorization codes, refresh-token lifecycle, revocation;
- signing keys / JWKS / rotation;
- tenants as IAM isolation boundaries;
- tenant memberships and invitations;
- tenant/application/platform roles, permissions, grants and scopes;
- client/application registration and protocol metadata;
- platform-vs-tenant authorization boundaries;
- machine/workload identities when later justified;
- identity/security actor context and audit.

## 3. Responsibilities extracted from KeyGo target ownership

### `INIT-SUB-001 / CAP-SUB-001 — Subscription & Entitlement Management`

Target ownership:

- commercial products/plans and plan versions;
- pricing/cadence normalization where needed;
- subscription lifecycle;
- renewal/trial/grace/pause/cancel/expire policy;
- commercial contracts associated with subscriptions;
- commercial entitlements, quotas and usage allowances;
- usage/metering needed for entitlement evaluation;
- provider-neutral subscription-provider adapters;
- native/delegated/hybrid subscription execution strategies.

### `INIT-PAY-001 / CAP-PAY-001 — Payment Orchestration`

Target ownership:

- normalized payment request/transaction state;
- provider transaction references;
- safe payment-method provider references;
- idempotency/correlation;
- verified webhook ingestion and deduplication;
- uncertain-outcome handling and reconciliation;
- refunds/partial refunds;
- disputes/chargebacks where required;
- payment-provider adapters and execution provenance.

## 4. Boundaries intentionally not assigned yet

The former broad `Billing` context contains concerns that should **not** be forced into Payment merely because they sit next to payment tables today:

- invoices;
- receipts/fiscal documents;
- tenant fiscal/billing profiles;
- tax identifiers;
- accounting ledger effects;
- settlements/payouts;
- merchant-of-record responsibilities;
- contractor/payer constructs that mix identity, contracting and fiscal responsibility.

These remain `BOUNDARY_UNRESOLVED` until a later governed decision has sufficient evidence.

## 5. Authorization is not commercial entitlement

This is a required semantic invariant.

KeyGo / CAP-IAM answers:

> **WHO ARE YOU, IN WHICH CONTEXT, AND ARE YOU AUTHORIZED?**

CAP-SUB answers:

> **WHAT COMMERCIAL PRODUCT/PLAN HAS BEEN ACQUIRED, AND WHICH FEATURES/QUOTAS ARE CURRENTLY ENTITLED?**

CAP-PAY answers:

> **WHAT MONEY-MOVEMENT OPERATION WAS REQUESTED/EXECUTED, AND WHAT IS ITS PROVIDER/TRANSACTION STATE?**

The consuming product answers:

> **WHAT DOES THAT MEAN FOR THIS DOMAIN OPERATION?**

Example: a user may be authorized as `OWNER` to create a location while the tenant has reached a commercial `locations.max = 1` quota. IAM passes; entitlement fails. Encoding the plan as an IAM role would destroy that distinction.

## 6. Token/JWT rule

Commercial plan/entitlement state must not become authoritative simply because it is copied into an IAM token.

Subscription state can change asynchronously because of cancellation, expiration, grace periods, plan changes, overrides, quota consumption or provider reconciliation. A short-lived derived claim may later be useful for performance, but its version/as-of/TTL semantics must be explicit and CAP-SUB remains the commercial source of truth.

## 7. Tenant and product identity rules

A KeyGo `Tenant` is an IAM isolation/membership boundary. A consumer product may have its own business `Organization`, `ProviderOrganization` or `Workspace`. They may map 1:1 in a first implementation but remain separate semantic identities.

A KeyGo `ClientApplication` is an OAuth/security concept. A commercial product can expose several clients—customer web, provider console, mobile, platform backoffice, machine clients—so CAP-SUB must not assume one OAuth client equals one commercial product.

## 8. Migration posture

This decision changes **target semantic ownership**, not current runtime truth.

Current KeyGo billing/subscription/payment code remains valid legacy/current implementation evidence until migration is separately executed.

### Migration sequence

1. Freeze further commercial-scope expansion inside KeyGo by default.
2. Inventory entities, endpoints, jobs, migrations, UI routes and events.
3. Classify each as `KEEP_KEYGO`, `EXTRACT_SUBSCRIPTION`, `EXTRACT_PAYMENT`, `SHARED_CONTRACT`, `BOUNDARY_UNRESOLVED` or `DEPRECATE`.
4. Define CAP-SUB and CAP-PAY contracts before moving consumers.
5. Insert ports/anti-corruption adapters so consumers stop depending on KeyGo internals.
6. Support the existing KeyGo implementation temporarily as a legacy adapter if that reduces migration risk.
7. Migrate authority/data incrementally with stable lineage/correlation and rollback.
8. Cut consumers over one by one.
9. Deprecate/remove legacy APIs/UI/data only after consumers no longer depend on them and evidence confirms safe cutover.

There is **no target shared database** among KeyGo, Subscription and Payment.

## 9. Relationship with INIT-RES-001

`INIT-RES-001` becomes a demanding but bounded consumer of three separate capabilities:

- `CAP-IAM-001` — identity/authentication/tenant memberships/applications/authorization.
- `CAP-SUB-001` — provider-side SaaS subscription and commercial entitlements.
- `CAP-PAY-001` — reservation payment execution/reconciliation.

Two money flows remain distinct:

1. **Provider pays the SaaS**: product commercial policy → CAP-SUB → CAP-PAY only when collection is required.
2. **Customer pays for a reservation**: reservation payment policy → CAP-PAY. This is not a SaaS subscription.

## 10. Lifecycle and repository consequences

- `INIT-KEYGO-001` remains `RECONCILIATION_REQUIRED`; implemented code does not prove an ILS stage/gate.
- `INIT-SUB-001` and `INIT-PAY-001` enter S1 only through accepted G0 `EXPLORE` decisions.
- `CAP-IAM-001`, `CAP-SUB-001`, `CAP-PAY-001` are governance/capability identities, not automatic production-readiness claims.
- No new implementation repository is required merely because the capabilities were separated.
- No destructive backend/UI/database refactor is authorized by this documentation change.

## 11. Canonical ADÜMÜN references

- KeyGo scope decision: [Drive](https://docs.google.com/document/d/1dq48YayQh2gEZehqHG4P05DwIHWrtDB79njczs7loW8/edit)
- Extraction map: [Drive](https://docs.google.com/document/d/1FL6QlS755y3tmQROEM3ekmq7Yz7EXijm9ujq8bV64VQ/edit)
- Cross-initiative relationships: [Drive](https://docs.google.com/document/d/1NUvQQWnU1EXcdEjHDq2hPUoDw8zT5DXRtK2r-SzL3Dg/edit)
- `CAP-IAM-001`: [Drive](https://docs.google.com/document/d/1IBmvqlLA2gUaFvzup73y2ajdE8KMf7qPgfY8sdXwOdI/edit)
- `CAP-SUB-001`: [Drive](https://docs.google.com/document/d/1gIcsdWc5zyrJUeS2uV6F00YUkDvVYZppR_oIhikNiM8/edit)
- `CAP-PAY-001`: [Drive](https://docs.google.com/document/d/1WXi-o6UpDw8CZaFHRyckboNSprHqFEMtGyrUxk7aCik/edit)
- `INIT-RES-001` relationship record: [Drive](https://docs.google.com/document/d/1YxRl9v48b5Lt9FHX8CFIjB-mTabB9wmZcknJXREZbKc/edit)

## 12. Decision

`DEC-KEYGO-SCOPE-001` is accepted: **KeyGo target scope is IAM; subscription/entitlement and payment execution are separate governed capabilities.**

Implementation extraction remains a future governed migration, not an implicit side effect of this decision.
