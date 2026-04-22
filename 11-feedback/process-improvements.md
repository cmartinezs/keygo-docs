[← Índice](./README.md)

---

# Process Improvements: Evolución del SDLC Framework

Este documento captura mejoras al SDLC framework mismo, basadas en aprendizajes de ciclos anteriores. No es sobre optimizar features; es sobre hacer que el proceso de documentar y construir el producto sea mejor.

---

## Contenido

- [Why Improve the Process](#why-improve-the-process)
- [Lessons from Cycles N → N+2](#lessons-from-cycles-n--n2)
- [Framework Improvements](#framework-improvements)
- [Governance Improvements](#governance-improvements)
- [Tooling and Automation](#tooling-and-automation)
- [Team Collaboration Improvements](#team-collaboration-improvements)
- [Next Cycle Roadmap](#next-cycle-roadmap)

---

## Why Improve the Process

Process improvements compound. A 10% improvement in each cycle means:
- Faster iteration
- Clearer documentation
- Fewer handoff errors
- Better DDD alignment
- Fewer operational surprises

This document ensures learning is not lost: we capture what worked and what didn't, then bake improvements into the next cycle.

---

## Lessons from Cycles N → N+2

### Cycle N: Discovery → Requirements

**What worked**:
✅ Early collaboration with domain experts shaped clear ubiquitous language
✅ 7 Bounded Contexts identified with clear names (not "modules" but "contexts")
✅ Stakeholder alignment before requirements meant zero interpretation conflicts

**What didn't**:
❌ Multi-tenant implications were afterthought, not discovery artifact
❌ No formal "Definition of Done" for discovery — ended when we "felt done"
❌ No traceability from discovery stakeholder statements → requirements

**Improvement**:
```
Discovery "Definition of Done" Checklist:

□ Bounded Contexts identified (name + brief purpose)
□ Ubiquitous Language glossary drafted (key terms, per context)
□ Stakeholder personas updated (including tenant types: Enterprise, SMB, etc.)
□ Multi-Tenancy implications documented:
    □ What data is shared across tenants?
    □ What is per-tenant?
    □ Any tenant-specific requirements? (SLA, isolation level)
□ Domain experts have signed off: "Yes, this is how the business works"
□ Needs → Contexts mapping documented (traceability)
□ Risk register: What assumptions are risky?
```

---

### Cycle N+1: Design & Data Model

**What worked**:
✅ Aggregate design per context prevented cross-cutting entanglement
✅ ACL concept stopped external model pollution
✅ Forward-compatible migrations designed upfront

**What didn't**:
❌ Value Object immutability not enforced at design time — discovered at code review
❌ Domain events strategy was ambiguous (stored? just notifications?)
❌ ERD didn't show RLS (Row-Level Security) requirements
❌ No "design review" checklist for DDD principles

**Improvement**:
```
Design Review Checklist (DDD-focused):

Aggregates:
□ Each aggregate has single root entity?
□ Roots are small (< 5 entities/VOs per root)?
□ Cross-aggregate references by ID, not object reference?
□ Each aggregate can evolve independently without affecting others?

Value Objects:
□ Immutable? (mark final/frozen)
□ Equality by value, not identity?
□ Validation rules embedded in VO constructor?

Domain Events:
□ Events named in past tense (UserCreated, not CreateUser)?
□ Events define integration contract (consumers depend on event, not request)?
□ Who publishes? Who consumes? (mapped explicitly)
□ Event sourcing strategy clear: persist all events, or just publish?

Bounded Contexts:
□ Ubiquitous language consistent with discovery?
□ Clear, one-sentence definition of context boundary?
□ All entities/aggregates mapped to context?
□ External dependencies wrapped in ACL?

Multi-Tenancy:
□ Tenant isolation strategy defined (query filters, schema separation)?
□ RLS (Row-Level Security) requirements in ERD?
□ Shared vs per-tenant data clearly marked in model?
□ Tenant ID flows through all aggregates?

Security & Compliance:
□ PII data handling defined (encryption, access)?
□ Audit events defined for regulatory requirements?
□ Secret management strategy (passwords, API keys)?
```

---

### Cycle N+2: Development → Operations

**What worked**:
✅ Repository abstraction made business logic database-agnostic
✅ Ubiquitous language in code was enforceable (code review checklist)
✅ DDD-driven testing caught issues synchronous API testing missed
✅ Feature flags enabled per-tenant rollout

**What didn't**:
❌ No incident classification for "is this single-tenant or multi-tenant?" — lost time diagnosing
❌ Monitoring was generic (CPU, memory) not domain-aware
❌ SLA definitions were not tenant-plan aware
❌ Billing aggregate did too much — refactoring required mid-cycle
❌ No runbook for "Context-specific failures" (e.g., "what if Identity context is down?")

**Improvement**:
```
Incident Response Improvements:

Incident Triage (first 5 minutes):

□ Scope diagnosis:
  □ Single tenant affected? → SEV2 (for that tenant, but SEV1 if Enterprise)
  □ Multiple tenants? → SEV1 (multi-tenant incident)
  □ Platform down? → SEV0

□ Context identification:
  □ Which bounded context? (Identity, Access, Billing, etc.)
  □ Clues: error patterns, latency spike in specific API, etc.

□ Tenant plan awareness:
  □ Enterprise → 15 min response, 99.99% SLA
  □ Standard → 1 hour response, 99.5% SLA
  □ Community → 4 hour response, 95% SLA

□ Run context-specific runbook:
  Example: "Identity Context Down"
  ├─ Check auth provider (SSO, LDAP, local password DB)
  ├─ Check email service (password reset requires email)
  ├─ Revert recent change to Identity module?
  ├─ Escalate to Identity on-call engineer
  └─ Notify downstream: Access Control (needs Identity), Billing (needs user info)

Feature Flag Impact:
□ Is this feature flag-related?
□ If yes: did flag drift per tenant? Example: "Enterprise has SSO=true, Standard=false"
□ Can roll back by flipping flag? (instant rollback, no deployment)
```

---

## Framework Improvements

### Improvement 1: Multi-Tenancy Checkpoints

**Status**: Implement in next cycle

**Rationale**: Multi-tenancy affects *every* phase of SDLC. Currently, it's an afterthought.

**Change**: Add "Multi-Tenancy Implications" section to each phase template:

```
### Multi-Tenancy Implications (new template section)

For each artifact (requirements, design, tests, operational procedure):

□ Data isolation: What data must be tenant-isolated?
  Example: "User data in Identity context is per-tenant"

□ Behavior variation: Does behavior differ by tenant plan?
  Example: "SSO enabled for Enterprise only, via feature flag"

□ Operations: Does incident response change by tenant scope?
  Example: "Access Control failure: all tenants affected → SEV1"

□ Monitoring: Are there tenant-specific SLOs?
  Example: "Enterprise auth latency p99 < 200ms; Community p99 < 500ms"
```

---

### Improvement 2: DDD Maturity Scorecard

**Status**: Implement in next cycle

**Rationale**: We need to measure how well DDD principles are applied.

**Scorecard** (10-point scale per context):

```
DDD Maturity Scorecard

Context: [Identity, Access Control, Billing, ...]

1. Ubiquitous Language (0-10)
   □ 0: No shared language, technical jargon only
   □ 5: Language defined in glossary, but code still uses technical names
   □ 10: Language is code; domain experts can read classes without explanation
   
   Current score: ___ / 10
   Evidence: [code samples]
   Gap: [what's missing]

2. Aggregate Design (0-10)
   □ 0: No aggregates defined; everything is flat DAO
   □ 5: Aggregates exist but boundaries are loose (giant root)
   □ 10: Aggregates are small, cohesive, reference by ID only
   
   Current score: ___ / 10
   Evidence: [code structure]

3. Domain Events (0-10)
   □ 0: No events, synchronous calls only
   □ 5: Events exist, but inconsistently published
   □ 10: Events are backbone; published reliably, consumed by other contexts
   
   Current score: ___ / 10

4. Anti-Corruption Layer (0-10)
   □ 0: External models leak directly into domain
   □ 5: ACL exists, but partial (some translations, some leakage)
   □ 10: All external systems behind complete ACL
   
   Current score: ___ / 10

5. Multi-Tenant Awareness (0-10)
   □ 0: No multi-tenant concepts in model
   □ 5: tenant_id field exists, but isolation not enforced in aggregates
   □ 10: Aggregates are tenant-aware; queries include tenant filter; RLS in DB
   
   Current score: ___ / 10

Overall DDD Maturity: ___ / 50 = ___ %
Target: 40 / 50 (80%) by end of next cycle
```

---

### Improvement 3: Navigation Conventions Enforcement

**Status**: Already started, enforce more consistently

**Current**: `00-documental-planning/navigation-conventions.md` exists
**Problem**: Not always followed (missing back-to-top, inconsistent header format)
**Solution**: Automated linting check

```
Navigation Linting (to run before merging docs):

For each .md file in 01-discovery/ through 11-feedback/:

□ Header format: [← Index](./README.md) | [macro-plan](../macro-plan.md)
  Regex: ^\[← Índice\]\(.*README\.md\) \| \[macro-plan\].*macro-plan\.md\)

□ Horizontal rule before content: ---

□ H1 title matching file purpose

□ H2 or H3 "Contenido" or "Contents" section with links

□ Back-to-top links after each section: ↑ [Volver al inicio](#section-name)

□ Footer: [← Volver a X](./path-to-parent) at end

Execute in CI/CD: ./scripts/lint-docs.sh
```

---

## Governance Improvements

### Improvement 1: Roles and Responsibilities

**Status**: Clarify in next cycle

**Current issue**: When should Product vs Engineering vs Architecture make decisions?

**Proposed RACI**:

```
RACI: Discovery Phase

Task                         | Product | Arch | Engineering | Domain Expert
-----------------------------|---------|------|-------------|---------------
Define problem statement     | A/R     | —    | C           | R
Identify bounded contexts    | R       | A    | C           | R
Draft ubiquitous language    | C       | —    | —           | A/R
Validate with stakeholders   | A/R     | —    | C           | —
Document personas/tenants    | A/R     | —    | C           | —
Identify risks               | R       | A    | C           | R

Legend: A=Accountable (decision maker), R=Responsible (does work), C=Consulted, I=Informed

Apply same RACI to Design, Development, Testing phases.
```

---

### Improvement 2: Definition of Done (all phases)

**Current**: "Done when we think it's done" (vague)

**Proposed**: Explicit DoD per phase

```
Phase: Discovery
DoD Checklist:

□ Problem statement written (1 page)
□ System vision documented (what is it, what isn't it)
□ 5+ stakeholder personas defined
□ 4-7 bounded contexts identified and named
□ Ubiquitous language glossary (min 20 key terms)
□ Multi-tenant implications identified
□ Open questions/risks documented
□ Domain experts sign-off: "This is how the business works"
□ Deliverables peer-reviewed by Architecture lead
□ Traceability: needs → contexts mapped

Transition criteria:
- All checklist items ✅
- Review complete, approved
- Kickoff meeting with Requirements team

---

Phase: Design & Data Model
DoD Checklist:

□ Architecture diagram (contexts, boundaries, integrations)
□ Aggregates designed per context
□ Value Objects identified and marked immutable
□ Domain events mapped (publisher → subscriber)
□ ACL defined for external systems
□ ERD with multi-tenant schema, RLS requirements
□ API contracts defined (request/response models)
□ Non-functional requirements mapped (latency, throughput, reliability)
□ Security/compliance requirements addressed
□ Test strategy per context outlined

[... and so on for each phase]
```

---

## Tooling and Automation

### Improvement 1: Documentation Linting

**Status**: Build in next cycle

**Tool**: Custom linter (Python/JavaScript) to enforce navigation, format, DDD terminology

```yaml
# .docslintrc.yaml

navigation:
  - header_format: "✅"
    pattern: "^\\[← Índice\\].*\\| \\[macro-plan\\]"
  - back_to_top: "required"
    pattern: "↑ \\[Volver al inicio\\]"
  - footer: "required"

ddd_terminology:
  contexts:
    - patterns: ["Process", "Handler", "Service"]
      severity: "warn"
      message: "Use domain term instead of technical term"
  aggregates:
    - patterns: ["Manager", "Helper", "Processor"]
      severity: "warn"

multi_tenancy:
  - patterns: ["WHERE tenant_id"]
    check: "Must use Row-Level Security, not application-side filter"
    severity: "error"

structure:
  - path: "0[1-9]-*"
    required_files: ["README.md", "macro-plan.md link"]
    max_nesting: 2
```

### Improvement 2: Feedback Analytics Dashboard

**Status**: Implement UI for NPS, bugs, features by context

```
Weekly Digest (auto-generated, sent to Slack):

📊 Keygo Feedback Summary (Week of Jan 15)

Overall NPS: 7.2 (↗ +0.1)

🎯 By Context:
├─ Identity: 8.1 (no change)
├─ Access: 6.9 (↘ -0.2) ⚠️
├─ Billing: 7.5 (↗ +0.3)
└─ Audit: 9.1 (↗ +0.2)

🐛 Top Bugs:
├─ [P0] Access Control: Permission denied on valid role (3 new)
├─ [P1] Identity: Password reset email slow (2 new)
└─ [P2] Billing: Invoice rounding error (1 new)

💡 Top Feature Requests:
├─ [12 votes] Webhooks for role changes
├─ [8 votes] API audit log export
└─ [5 votes] Bulk user import

📈 Trends:
├─ Enterprise: Stable at 8.2 (support = quality)
├─ Standard: Up to 7.1 from 7.0 (onboarding help working)
└─ Community: Down to 5.8 from 6.1 (permission docs need work)

🚀 Actions This Week:
├─ RF-AC-002: Fix permission denial concurrency (starting)
├─ RF-DOC-001: Improve permission error messages (approved)
└─ Escalation: Review Access Context design (next retro)
```

---

## Team Collaboration Improvements

### Improvement 1: Sync Points (fewer, more focused)

**Status**: Adjust meeting cadence in next cycle

**Current issue**: Too many syncs, unclear decision gates

**Proposed**:

```
Weekly Cadence:

Monday 9am:  Sprint Planning (1h)
  Agenda: What are we building this week?
  Attendees: Product, Tech Lead, Architects

Tuesday 2pm: Design Sync (1h)
  Agenda: Design questions, DDD deep dives
  Attendees: Architects, Engineers with DDD focus

Thursday 10am: Operations Sync (30m)
  Agenda: Incidents, SLA health, runbook updates
  Attendees: On-call, DevOps, Service owners

Friday 3pm: Feedback Retrospective (1h)
  Agenda: NPS trends, bugs, user needs for next cycle
  Attendees: Product, Engineering, Domain Experts
```

---

## Next Cycle Roadmap

### Q2 2024 Process Improvements

| Improvement | Owner | Timeline | Impact |
|-------------|-------|----------|--------|
| Multi-Tenancy Checkpoints in all phases | Architecture | Weeks 1-2 | Medium (prevents surprises) |
| DDD Maturity Scorecard | Engineering Lead | Week 1 | Low (measurement, not change) |
| Incident Triage Runbook | DevOps | Weeks 2-3 | High (faster MTTR) |
| Documentation Linting Tool | Platform | Weeks 3-4 | Low (quality, not features) |
| Feedback Analytics Dashboard | Product | Weeks 1-4 | Medium (visibility) |
| "Definition of Done" per phase | All | Week 1 (pilot), Week 2 (rollout) | High (clarity) |
| RACI Matrix clarity | Product Lead | Week 1 | Medium (decision clarity) |

---

↑ [Volver al inicio](#process-improvements-evolución-del-sdlc-framework)

---

[← Volver a Feedback](./README.md)
