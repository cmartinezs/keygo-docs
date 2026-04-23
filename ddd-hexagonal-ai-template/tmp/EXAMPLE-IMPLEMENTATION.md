# Practical Example: Generating Documentation with AI

Complete use case: generating documentation for **Keygo** (real product for session and permission management).

---

## Context: Keygo

```
Name: Keygo
Problem: Development teams lose 2+ hours/day managing
         sessions and permissions — no single source of truth
Users:
  - Developers (build features, need quick access)
  - DevOps/Platform Engineers (maintain infra, audit)
  - PM/Managers (control, compliance, reports)
Market: Competes with Vault (too complex), homegrown solutions
Stack: Go + gRPC backend, React frontend, PostgreSQL, Kubernetes
Timeline: MVP in 8 weeks (Q2 2026)
```

---

## Day 1: Preparation (30 min)

### Information Gathered

```markdown
# Keygo - Product Information

## Vision in 3 lines
Keygo is the single source of truth for identity and authorization.
Teams spend hours synchronizing sessions and permissions.
Keygo centralizes, audits, and automates — reducing Time to Access from hours to minutes.

## Specific Problem
Today:
- Developer needs access → email to Platform → waits 4-24 hours
- PM cannot audit who has what → requires manual audit
- No auto-revocation of sessions → security risk

With Keygo:
- Dev requests access → approved in minutes → immediate access
- Automatic audit of who/what/when
- Sessions are automatically revoked

## Users
1. **Developer** (technical)
   - Needs to access services (dev, staging, prod)
   - Urgency: high (needs access now)
   - Frustration: waiting, multiple systems

2. **DevOps Engineer** (technical)
   - Maintains infrastructure and policies
   - Needs audit and control
   - Frustration: inconsistency, lack of visibility

3. **Manager** (non-technical)
   - Needs compliance reports
   - Supervision of who accesses what
   - Frustration: lack of traceability

## Constraints
- Must integrate with existing K8s
- Must comply with internal security regulations
- Must support multiple cloud providers (AWS, GCP)
- Decision latency <500ms (critical)

## Technical Stack
- Backend: Go 1.21, gRPC, goreleaser
- Frontend: React 19, TypeScript
- Database: PostgreSQL 15+
- Infrastructure: Kubernetes 1.24+, Docker
- CI/CD: GitHub Actions
```

### Local Preparation

```bash
# 1. Copy template
cp -r ddd-hexagonal-ai-template/ docs/

# 2. Create documentation branch
git checkout -b docs/initialize-keygo-docs

# 3. Rename TEMPLATE-* files
cd docs/
find . -name "TEMPLATE-*.md" -type f | while read f; do
  newname=$(echo "$f" | sed 's/TEMPLATE-//')
  mv "$f" "$newname"
done

# 4. Update MACRO-PLAN.md and README.md
# [edit manually]

# 5. Commit
git add .
git commit -m "docs: initialize DDD+Hexagonal documentation for Keygo"
```

---

## Day 2: Discovery 1.1 — Context & Motivation

### You (20 min):

Prepare the prompt by copying from `AI-WORKFLOW-GUIDE.md` — "Discovery 1.1" section:

```markdown
# Product Context

My product is: Keygo — single source of truth for identity and authorization.

Problem: Development teams lose 2+ hours/day managing sessions
and permissions. There is no visibility or centralized control.

Users:
  - Developers (quick access to services)
  - DevOps/Platform Engineers (control, audit)
  - Managers (compliance, reports)

Market: Competes with Vault (too complex), homegrown solutions,
generic tools not adapted to agile teams.

---

# Task

Generate "01-templates/01-discovery/context-motivation.md" based on the attached template.

---

# Template

[COPY COMPLETE from TEMPLATE-context-motivation.md]

---

# Specific Requirements

## Content
- Length: 2000-2500 words
- Mandatory sections:
  1. Concrete Problem
  2. Market Context
  3. Strategic Motivation
  4. Actors and Impacted
  5. Initial Risks
  6. Opportunities
  7. Key Assumptions

## Style
- Agnostic: DO NOT mention Kubernetes, Go, React, PostgreSQL
- Accessible to executives and PM (some non-technical)
- Narrative but professional

## Concrete Data
- Teams lose 2+ hours/day (concrete data)
- Access time today: 4-24 hours, with Keygo: <5 minutes
- Market: startups of 20-500 people
- Competition: Vault, 1Password, homegrown solutions

---

# Validation

After writing:
- [ ] Clearly answers: "What is the problem?"
- [ ] Differentiates problem (what's wrong) vs vision (solution)
- [ ] Does not prescribe technology
- [ ] Risks documented (security, adoption, integration)
- [ ] Paragraphs <4 lines
- [ ] Clear language (no jargon)
```

### AI (2-5 min):

Paste the prompt in Claude and wait.

AI generates document (~2000 words) similar to:

```markdown
# Context & Motivation: Keygo

## The Real Problem

Modern engineering teams don't have a centralized solution
for managing identity and authorization...

[AI-generated document — long, structured, agnostic]
```

### You (5-10 min):

```markdown
# Validation of generated document

✅ "Problem" Section: Clear. Specifies hours/day, competition, urgency.
✅ "Market" Section: Mentions Vault, homegrown solutions. Without prescribing how.
✅ No technology: No "Kubernetes", "gRPC", "PostgreSQL".
✅ Numbers: 2+ hours/day, 4-24 hours access time, startups 20-500 people.
✅ Risks: Security, adoption, integration — with explanation.
✅ Tone: Professional, narrative, not salesy.
✅ Length: 2100 words.

Result: ✅ APPROVED
```

**Save document**:

```bash
mv 01-templates/01-discovery/TEMPLATE-context-motivation.md 01-templates/01-discovery/context-motivation.md
git add 01-templates/01-discovery/context-motivation.md
git commit -m "docs(discovery): add context and motivation"
```

---

## Day 2 (afternoon): Discovery 1.2 — System Vision

### You (5 min):

Summarize the previous document and request the next:

```markdown
# Context

Discovery completed: Keygo loses teams 2+ hours/day in management
of sessions. Market opportunity: centralize identity without complexity
of generic solutions.

---

# Task

Generate "01-templates/01-discovery/system-vision.md" based on the template.

---

# Template

[COPY TEMPLATE-system-vision.md]

---

# Requirements

## Content (1500-2000 words)
- 5-year vision
- What is Keygo (clear definition)
- What it is NOT (explicit limits)
- 3-5 guiding principles
- Expected benefits (users + business)
- Differentiation vs Vault, 1Password
- Success metrics (measurable)

## Important
- Inspirational but realistic
- Agnostic
- Tangible (numbers, not just aspiration)
```

### AI (2 min):

Generates document with vision, principles, benefits.

### You (5 min):

Validate:
- ✅ Different from context-motivation (problem vs vision)
- ✅ Clear limits ("Keygo is X", "NOT Y")
- ✅ Quantitative success metrics (ex: "reduce access time to <5 min")

---

## Day 3: Discovery 1.3 — Actors & Needs

### You (5 min):

```markdown
# Context

[Vision + Context-Motivation]

---

# Task

Generate two documents:
1. "01-templates/01-discovery/actors.md"
2. "01-templates/01-discovery/needs-expectations.md"

---

# Document 1: Actors (1500 words)

Actors to document:
1. Developer (who, what they do, pain, incentives, constraints)
2. DevOps Engineer
3. Manager/PM
4. [External system: Cloud Provider]

---

# Document 2: Needs (2000 words)

Per actor: what they need, why, alternatives, problems with them.

Include MoSCoW table: Must / Should / Could.
```

### AI (3 min):

Generates both documents.

### You (10 min):

Validate coherence with previous discovery.

---

## Day 4-5: Requirements (3 documents)

### Task 1: Glossary

**You**: Prepare list of domain terms (30-50):
- Session, User, Role, Permission, Token, etc.

**AI**: Generates with definitions, context, examples.

**You**: Validate that every term is understandable without external references.

---

### Task 2: RF/RNF

**You**: Make base list:
```
RF-001: User can log in
RF-002: Admin can create new session
RF-003: User can view their active sessions
RF-004: System auto-revokes expired session
RNF-001: Latency <500ms at 99th percentile
RNF-002: Availability 99.9%
RNF-003: Support 10k simultaneous users
```

**AI**: For each RF/RNF, generates document with:
- Description
- Justification
- Acceptance Criteria (Gherkin)
- Dependencies
- Risks

**You**: Validate that each one is independent and verifiable.

---

### Task 3: Priority Matrix & Scope

**AI**: Generates MoSCoW table with all RF.

**Expected result**:

| ID | Name | Category | Justification |
|----|--------|-----------|---------------|
| RF-001 | User Login | Must | Core of MVP |
| RF-004 | Auto Revoke | Should | Security, v1.1 |
| RF-010 | ML Anomaly | Won't | Requires data, v2.0 |

---

## Day 6-7: Design (3 documents)

### Task 1: Strategic Design (Bounded Contexts)

**You**: Identify domains:
- Identity Context: authentication, sessions
- Authorization Context: roles, permissions
- Audit Context: logs, traceability

**AI**: Generates with:
- Domain Vision Statement
- Subdomain Classification (Core/Supporting/Generic)
- Ubiquitous language per context
- Root aggregates

---

### Task 2: System Flows

**AI**: Generates 5-8 flows:
1. User Login
2. Grant Permission
3. Revoke Session (expiry)
4. Audit Retrieval (admin)
5. Incident: Unauthorized Access

Each flow: steps, decisions, Mermaid sequence diagram.

---

### Task 3: Bounded Context Models

**AI**: Generates models for each context:

**Identity Context**:
- Aggregates: User (root), Session, Credential
- Events: UserAuthenticated, SessionCreated, SessionExpired
- Invariants: User → multiple sessions, but single active

---

## Day 8: Data Model (2 documents)

**AI**: Generates:

1. **Entities**: User, Session, Role, Permission, with attributes
2. **Relationships**:
   - User 1:N Session
   - User M:N Role
   - Role M:N Permission
   - ERD Mermaid

---

## Day 9: Planning (2 documents)

**AI**: Generates:

1. **Roadmap** (6 months):
   - Phase 1 MVP (RF-001-004): 8 weeks
   - Phase 2 Advanced Auth (SSO): 6 weeks
   - Phase 3 Analytics: Q4

2. **Epics** (decomposition of RF):
   - Epic 1: User Authentication (RF-001, 002)
   - Epic 2: Session Management (RF-003, 004)
   - Epic 3: Audit & Compliance (RF-005+)

---

## Day 10+: Development (Technical Stack Specific)

Here you include specific technology:

```markdown
# Technical Stack
Backend: Go 1.21, gRPC
Frontend: React 19, TypeScript
Database: PostgreSQL 15
Infrastructure: Kubernetes 1.24+

---

# Task

Generate "01-templates/06-development/architecture.md" with:
- Hexagonal architecture diagram
- Bounded Contexts → modules
- gRPC services mapping
- Repository pattern for persistence
```

---

## Final Result

After 10 days:

```
✅ 01-templates/01-discovery/
   ├── context-motivation.md (2100 words)
   ├── system-vision.md (1800 words)
   ├── actors.md (1500 words)
   └── needs-expectations.md (2000 words)

✅ 01-templates/02-requirements/
   ├── glossary.md (40 terms)
   ├── functional/ (8 RF documented)
   ├── non-functional/ (3 RNF documented)
   ├── priority-matrix.md
   └── scope-boundaries.md

✅ 01-templates/03-design/
   ├── strategic-design.md (3 contexts)
   ├── system-flows.md (8 flows + diagrams)
   └── bounded-contexts/ (3 models)

✅ 01-templates/04-data-model/
   ├── entities.md (12 entities)
   ├── relationships.md (ERD)

✅ 01-templates/05-planning/
   ├── roadmap.md (6 months)
   └── epics.md (10 epics)

✅ 01-templates/06-development/ [technical — requires specific stack]
   ├── architecture.md
   ├── api-reference.md
   └── coding-standards.md
```

**Complete documentation**: ~30,000 words
**Human work**: ~25-30 hours of reading, validation, adjustments
**AI effort**: ~15 minutes of generation (time elapsed)
**Total time**: 10-12 calendar days

---

## Cross-Phase Validation Checklist

```markdown
# Post-Documentation: Integral Coherence

After completing all phases:

✅ Discovery → Requirements
   - Does each Need → at least 1 RF?
   - Is each RF a consequence of identified Need?

✅ Requirements → Design
   - Is each RF → implementable in system flow?
   - Do Design flows → cover all Must RF?

✅ Design → Data Model
   - Is each aggregate → present in data model?
   - Do Relationships → support design flows?

✅ Data Model → Planning
   - Does each epic → cover one or more design contexts?
   - Does MVP → complete an end-to-end flow?

✅ Planning → Development
   - Does Architecture → reflect design contexts?
   - Do APIs → cover system flows?

✅ Complete Traceability
   - Select 1 RF (ex: RF-001 "User Login")
   - Trace: Discovery need → System flow → Bounded context → Entities → Epic → API endpoint
   - Everything connected? ✅
```

---

## Conclusion

This example shows:
- **Day-by-day flow**: what to do each workday
- **Inputs/Outputs**: what you pass to AI, what to validate
- **Real times**: it's not magic, takes ~30 minutes per document
- **Real-time validation**: don't wait until everything is complete
- **Result**: documentation ready for architects, engineers, PMs

---

[← HOME](../README.md)
