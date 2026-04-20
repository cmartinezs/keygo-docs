[← Índice](./README.md)

---

# User Feedback Loops: De Feedback a Acción

El feedback de usuarios (NPS, bugs, features) no es útil si no se canaliza de vuelta al sistema. Este documento describe cómo feedback técnico se mapea a **Bounded Contexts**, cómo patterns revelan problemas de diseño, y cómo decisiones futuras emergen del input de usuarios.

---

## Contenido

- [The Feedback Loop](#the-feedback-loop)
- [NPS by Bounded Context](#nps-by-bounded-context)
- [Bug Patterns and Design Signals](#bug-patterns-and-design-signals)
- [Feature Requests as Domain Evolution](#feature-requests-as-domain-evolution)
- [Multi-Tenant Feedback Differentiation](#multi-tenant-feedback-differentiation)
- [From Feedback to Requirements](#from-feedback-to-requirements)
- [Feedback Metrics and Health Checks](#feedback-metrics-and-health-checks)

---

## The Feedback Loop

```
┌─────────────────────────────────────────────────────────────────┐
│                    Closed Feedback Loop                          │
└─────────────────────────────────────────────────────────────────┘

  [User Action]
       │
       ▼
  [Collect: NPS, Bug, Feature]
       │
       ▼
  [Analyze by Bounded Context]
       │
       ├─► [NPS] ──► "Identity auth too slow?" → Latency investigation
       │
       ├─► [Bug] ──► "Permission denied on valid role" → Access Control bug
       │
       └─► [Feature] ──► "Want SSO" → New Identity capability
       │
       ▼
  [Root Cause Analysis]
       │
       ├─► Design problem? (aggregate too strict)
       ├─► Implementation bug? (concurrency issue)
       └─► Missing requirement? (new capability)
       │
       ▼
  [Decision: Fix, Refactor, or Build]
       │
       ▼
  [Implement in context]
       │
       ▼
  [Release and observe NPS change]
       │
       └─────────► [Loop again]
```

**Key Principle**: Feedback is data about how users experience the domain. If NPS drops after a release, ask "what changed in the model?" not just "what code did we change?"

---

## NPS by Bounded Context

NPS surveys can be targetted to specific features to understand satisfaction per context. Example results:

### Identity Context

```json
{
  "context": "Identity",
  "periods": {
    "q1_2024": {
      "nps": 7.8,
      "promoters": "Easy SSO setup",
      "detractors": "Password reset emails slow",
      "gap": "Forgot password UX"
    },
    "q2_2024": {
      "nps": 8.1,
      "change": "+0.3",
      "reason": "Reduced email latency, improved reset flow"
    }
  }
}
```

**Interpretation**: 
- Detractors cited "slow" → investigated email service latency → discovered queuing backlog → fixed: NPS +0.3
- Promoters value "easy setup" → confirms SSO ACL design is working
- **Next action**: Monitor email latency as context-specific SLI

### Access Control Context

```json
{
  "context": "Access Control",
  "periods": {
    "q1_2024": {
      "nps": 6.9,
      "promoters": "Role management is straightforward",
      "detractors": "Permission denied errors are cryptic",
      "comments": "Why can't I grant read access to this resource?"
    }
  },
  "root_cause": {
    "finding": "Policy language (Rego-like) is not translatable to domain language",
    "design_issue": "Policy is technical config, not domain model",
    "user_impact": "Users don't understand why action failed"
  }
}
```

**Interpretation**:
- Detractors frustrated by opaque denials → root cause is design: policies live in YAML, not ubiquitous language
- **Next action**: Refactor policies as domain objects (aggregate `AccessPolicy` with clear violation reasons)

### Billing Context

```json
{
  "context": "Billing",
  "enterprise_nps": 8.2,
  "standard_nps": 7.1,
  "community_nps": 5.8,
  "enterprise_feedback": "Invoicing is clear, integrates with accounting",
  "standard_feedback": "Happy, but feature entitlements confusing",
  "community_feedback": "Confused why my feature limit reset mid-month"
}
```

**Interpretation**:
- 2.4 point gap between Enterprise and Community → likely tied to support, clarity
- Community: "feature limit reset" suggests metering or renewal edge case
- Standard: "feature entitlements confusing" → may be separate `FeatureEntitlement` not clear enough in UI
- **Next action**: 
  - Billing aggregate: clearer entitlements communication
  - Fix metering/renewal edge cases
  - Consider feature flags to gate availability messaging per plan

### Audit Context

```json
{
  "context": "Audit",
  "nps": 9.1,
  "promoters": "Complete audit trail is invaluable for compliance",
  "detractors": "Query for specific events can be slow"
}
```

**Interpretation**:
- High NPS reflects sound model (event-sourced audit is exactly what users need)
- Detractor = performance issue, not design → optimize queries, add indexes
- **Next action**: Audit query performance SLO

---

## Bug Patterns and Design Signals

Bugs are often **design signals**. Recurring bugs in the same area suggest an aggregate is too strict, a Value Object is mutable when it shouldn't be, or a boundary is wrong.

### Example: Access Control Bugs

**Pattern**: "Permission denied on valid role"
- Bug frequency: 3-5 tickets/month
- Instances: User has role, but permission check fails

**Investigation**:
```
Hypotheses:
1. Concurrency: Role granted, but check runs before cache invalidates
   → Aggregate invariant is too tight, doesn't account for eventually consistent state
   
2. Aggregate boundary: Role grants permission, but check doesn't see it
   → Data model has role grants in different table, ACL not translating
   
3. Value Object mutation: Role was created, modified externally, aggregate state stale
   → Role Value Object not enforced as immutable

Finding: #1 (concurrency) + #3 (partial mutability)
```

**Design Refactor**:
- `Role` becomes immutable Value Object (was mutable entity)
- `RoleAssignment` tracks when role granted, with version field
- Permission check: allow "recently granted" if within TTL

**Result**: Bug disappears, NPS for Access Control stabilizes at 7.2+

---

### Example: Billing Bugs

**Pattern**: "Invoice total doesn't match what I paid"
- Bug frequency: 2-3 tickets/month
- Instances: Invoice shows $X, but credit card charged $Y

**Investigation**:
```
Root cause: `Subscription` aggregate and `FeatureEntitlement` not synchronized
- When feature is added mid-month, entitlement changes
- But subscription invoice calculated from stale entitlements
- Two aggregates out of sync → no event to reconcile them

Design issue: Aggregate boundary is wrong
- Subscription handles billing (payment, renewal)
- Entitlements handle feature access (grants, limits)
- When entitlements change, should emit event → Billing reacts

Current: No communication between them
```

**Design Refactor**:
- Split: `BillingSubscription` (invoicing) and `TenantEntitlements` (features) as separate aggregates
- Domain event: `EntitlementChanged` published by Entitlements context
- Billing listens: "Oh, entitlements changed, recalculate prorated invoice"

**Result**: Invoices always match reality. NPS for Billing +0.5

---

## Feature Requests as Domain Evolution

Feature requests are **new capabilities**, often requiring new aggregates or context boundaries.

### Example: "Add SSO Support"

**Raw request**: "I want to use Google/Microsoft to log in instead of passwords"

**Domain analysis**:
- Currently: `Identity` context handles `User` + `Password`
- Request implies: `ExternalIdentityProvider` (Google, Azure AD)
- Question: Is this new aggregate? New context? Expansion of Identity?
- Answer: New aggregate `ExternalIdentity` within Identity context + ACL to Google/Microsoft APIs

**Domain modeling**:
```
Identity Context (existing):
  - User (entity)
  - Password (value object)
  + ExternalIdentity (NEW aggregate)
    - provider: "google" | "microsoft"
    - provider_id: string
    - email: Email (value object)
    - profile: Profile (value object)
  + Event: ExternalIdentityLinked
  + ACL: GoogleIdentityAdapter, MicrosoftIdentityAdapter
```

**Why this works**:
- SSO is still identity; doesn't need new context
- `ExternalIdentity` is separate from Password (users can have both)
- ACL isolates external provider schema
- Events allow other contexts to react (Audit logs external logins, Billing tracks SSO usage)

**Result**: SSO emerges naturally from domain, not as a bolt-on feature.

---

### Example: "Add Webhook Support"

**Raw request**: "I want webhooks to notify my system when roles change"

**Domain analysis**:
- Currently: Integration is synchronous (clients poll, or we send emails)
- Request: Async push notifications
- Observation: This is integration, not core domain

**Decision**:
- Not a new Bounded Context (Platform handles webhooks)
- Mechanism: Domain events → webhook dispatcher
- When `RoleAssigned` event fires in Access Control, Platform context listens and dispatches webhooks

**Integration**:
```
Access Control Context:
  - Publish: RoleAssigned, RoleRemoved, PermissionChanged (events)

Platform Context:
  - Subscribe to events from other contexts
  - Webhook registry: "When RoleAssigned, call https://client.com/webhooks/role"
  - Delivery logic: retry, exponential backoff, logging
  
Client:
  - Receives HTTP POST with RoleAssigned event
  - Can now sync their own system
```

**Why this works**:
- Webhook is transport, not domain logic
- Events are the contract (client receives same event structure as internal handlers)
- New contexts can hook without modifying existing ones

**Result**: Multi-tenant webhook support, no changes to core contexts.

---

## Multi-Tenant Feedback Differentiation

Different tenant plans have different feedback:

### Tenant Plan Feedback Matrix

```
                    | Enterprise | Standard  | Community
--------------------|------------|-----------|----------
NPS Average         | 8.2        | 7.1       | 5.8
Top Feature Request | Webhooks   | API Logs  | Basic Docs
Top Bug Report      | —          | Bulk ops  | Permission errors
Support Expectation | 15min SEV1 | 1hr SLA   | 4hr SLA
Feature Usage       | All (100%) | 70%       | 20%
```

**Insights**:

1. **Enterprise wants integrations**: "Give me webhooks, API logs, Slack integration"
   - → Feature flag: Enterprise gets webhooks day 1
   - → Standard day 3 (after testing)
   - → Community never (resource-intensive)

2. **Community wants clarity**: Top request is "better docs" and "why did access deny?"
   - → Fix: Better error messages (low cost, high impact)
   - → Fix: Permission denial reasons in events and UI
   - → Result: NPS can rise without new features

3. **Standard wants operability**: "Bulk delete roles? Bulk import users?"
   - → Likely need `BulkOperation` aggregate in Access Control
   - → Async job handling, progress tracking
   - → Even small tenant has large user base

4. **Enterprise reports fewer bugs**: Higher support, faster onboarding
   - → Quality perception tied to support, not code quality
   - → implication: Invest in Community/Standard support, NPS rises

---

## From Feedback to Requirements

How does feedback become part of the next cycle?

### Process: Feedback → Retrospective → Requirements → Sprint

```
┌────────────────────────────────────┐
│ 1. Collect Feedback (4 weeks)      │
│ ├─ NPS surveys: 200 responses      │
│ ├─ Bugs: 15 tickets                │
│ └─ Features: 8 requests            │
└────────────────────────────────────┘
           │
           ▼
┌────────────────────────────────────┐
│ 2. Analyze by Context (1 week)     │
│ ├─ Identity NPS: 7.8               │
│ ├─ Access NPS: 6.9 (gap?)          │
│ ├─ Bugs cluster: Access denials    │
│ └─ Features: SSO (1), Webhooks (3) │
└────────────────────────────────────┘
           │
           ▼
┌────────────────────────────────────┐
│ 3. Root Cause (1 week)             │
│ ├─ Low Access NPS: Policy language │
│ ├─ Denial bugs: Concurrency        │
│ └─ SSO request: New aggregate      │
└────────────────────────────────────┘
           │
           ▼
┌────────────────────────────────────┐
│ 4. Write Requirement (1 week)      │
│ ├─ RF-AC-001: Refactor policies    │
│ ├─ RF-AC-002: Fix role concurrency │
│ └─ RF-ID-001: Add SSO support      │
└────────────────────────────────────┘
           │
           ▼
┌────────────────────────────────────┐
│ 5. Plan Sprint (1 week)            │
│ ├─ Priority: RF-AC-002 (P0 bug)    │
│ ├─ Priority: RF-AC-001 (design)    │
│ └─ Priority: RF-ID-001 (feature)   │
└────────────────────────────────────┘
           │
           ▼
┌────────────────────────────────────┐
│ 6. Develop (2-4 weeks per RF)      │
│ ├─ Code changes per context        │
│ ├─ Tests pass                      │
│ └─ Multi-tenant validated          │
└────────────────────────────────────┘
           │
           ▼
┌────────────────────────────────────┐
│ 7. Deploy & Measure (2 weeks)      │
│ ├─ Monitor NPS change              │
│ ├─ Bug recurrence: Should drop     │
│ └─ Feedback loop closes            │
└────────────────────────────────────┘
```

**Key Gates**:
- "Root Cause Analysis" must identify if root is design (RF needed) or implementation (bug fix only)
- "Write Requirement" must include the domain context (RF-AC not just "fix concurrency")
- "Plan Sprint" must prioritize: P0=bugs breaking SLA, P1=design issues, P2=nice-to-haves

---

## Feedback Metrics and Health Checks

Monitor feedback metrics to detect problems early:

### Health Checks

| Metric | Target | Trigger | Action |
|--------|--------|---------|--------|
| NPS trend | +0.1 to +0.5/quarter | Drop > 1 point | Root cause retrospective |
| Bug close rate | > 85% within 2 weeks | < 70% | Team capacity review |
| Feature request analysis | 100% analyzed within 1 week | > 1 week backlog | Product planning review |
| Context-specific NPS | Identity 8+, Access 7.5+, Billing 7.5+ | Below target | Context-specific design review |
| Multi-tenant NPS delta | < 1 point difference | > 1.5 point gap | Investigate plan differentiation |

### Sample Dashboard

```
┌─────────────────────────────────────────────────────┐
│         Keygo Feedback Dashboard (Last 30 Days)     │
├─────────────────────────────────────────────────────┤
│                                                     │
│  Overall NPS: 7.2  (↗ +0.2 from prev month)        │
│                                                     │
│  By Context:                                        │
│  ├─ Identity:          8.1 ↗                        │
│  ├─ Access Control:    6.9 ↘  ⚠️ (investigate)    │
│  ├─ Billing:           7.5 →                        │
│  ├─ Audit:             9.1 ↗                        │
│  └─ Organization:      7.3 →                        │
│                                                     │
│  By Tenant Plan:                                    │
│  ├─ Enterprise: 8.2                                 │
│  ├─ Standard:   7.1                                 │
│  └─ Community:  5.8  ⚠️ (support gap?)             │
│                                                     │
│  Recent Themes:                                     │
│  ├─ [Top] "Easy SSO setup" (20 mentions)           │
│  ├─ [Issue] "Permissions deny unclear" (8 tickets) │
│  └─ [Request] "Webhooks" (12 feature votes)        │
│                                                     │
│  Open Requirements (from feedback):                 │
│  ├─ RF-AC-002: Permission denial reason (P0)       │
│  ├─ RF-ID-001: SSO support (P1)                    │
│  └─ RF-Platform-001: Webhook support (P1)          │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

↑ [Volver al inicio](#user-feedback-loops-de-feedback-a-acción)

---

[← Volver a Feedback](./README.md)
