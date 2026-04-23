[← Index](./README.md)

---

# DDD + Hexagonal Template Architecture

How it is designed internally and why, so you can adapt it to your needs.

---

## Contents

- [Philosophy](#philosophy)
- [The 12 Phases Explained](#the-12-phases-explained)
- [Design Principles](#design-principles)
- [Agnostic vs. Specific](#agnostic-vs-specific)
- [Mind Map](#mind-map)
- [When to Extend or Adapt](#when-to-extend-or-adapt)
- [Template Governance](#template-governance)

---

## Philosophy

### Premise

The best documentation is:

1. **Agnostic first** — describes what before how
2. **Iterable** — allows parallel feature development
3. **Living** — changes with code, doesn't freeze
4. **Traceable** — from requirement to metric
5. **Collaborative** — easy to generate with AI, easy to review with team

### Why DDD + Hexagonal?

**DDD (Domain-Driven Design)**:
- Organizes complexity around the *business domain*
- Forces common convention (ubiquitous language)
- Produces an architecture that reflects the business, not the framework

**Hexagonal (Ports & Adapters)**:
- Separates *domain* from *technical implementation*
- Domain lives at the center (agnostic)
- Technology is implementation detail (interchangeable)

**Together**:
- Agnostic documentation in phases 1-5 (discover and specify the domain)
- Specific documentation in phases 6-12 (implement the domain in code)
- Common language between business and tech

---

## The 12 Phases Explained

### Complete Lifecycle

```
Discovery → Requirements → Design → UI & Data
    ↓
    └─ Planning → Development → Testing
         ↓
    Deployment → Operations → Monitoring → Feedback
         ↓
         └─ (returns to Discovery with learnings)
```

### Phase by Phase

#### 1. **Discovery** — What problem do we solve?

**Central question**: Why does this product exist?

**What it produces**:
- Problem statement (the real problem, not the solution)
- User personas (who uses it, what they need)
- Competitive analysis (why us)
- Stakeholders and impacted parties
- Risks or opportunities

**Agnostic**: ✅ YES — Without mentioning technologies

**Audience**: PM, Founders, Users, Stakeholders

**Typical duration**: 1-2 weeks

---

#### 2. **Requirements** — What must the system do?

**Central question**: What are the expected capabilities?

**What it produces**:
- Functional Requirements (FR): user capabilities
- Non-Functional Requirements (NFR): quality attributes
- Glossary: unified vocabulary
- Scope boundaries: what goes in, what doesn't

**Agnostic**: ✅ YES — "The system must allow..." not "using JWT..."

**Audience**: PM, Product Owners, QA

**Typical duration**: 1-2 weeks

---

#### 3. **Design & Process** — How does the system flow?

**Central question**: What are the processes and domain model?

**What it produces**:
- System flows: main flows with diagrams
- Strategic design (DDD): bounded contexts, ubiquitous language
- Process decisions: alternatives considered
- Context models: aggregates, invariants, events

**Agnostic**: 🟡 PARTIALLY — Architectural (DDD concepts) but not technical

**Audience**: Tech Lead, Architects, Senior Devs

**Typical duration**: 2-3 weeks

---

#### 4. **UI Design** — How does the user interact?

**Central question**: What are the portals, screens, and navigation flows?

**What it produces**:
- Design system: visual principles, components
- Wireframes: main screens
- Navigation flows: how the user moves
- UX decisions: discarded alternatives

**Agnostic**: 🟡 PARTIALLY — Conceptual but not frontend code

**Audience**: Designers, Product Owners, Devs

**Typical duration**: 1-2 weeks (parallel with Design)

---

#### 5. **Data Model** — How is information structured?

**Central question**: What are the entities and their relationships?

**What it produces**:
- Entities: what data we store
- Relationships: how they relate (ERD)
- Data flows: how it transforms and moves
- Constraints: data invariants

**Agnostic**: ✅ YES — "Relational database" not "PostgreSQL"

**Audience**: Architects, DBAs, Backend Devs

**Typical duration**: 1 week (extracted from Design)

---

#### 6. **Planning** — When and how do we deliver?

**Central question**: What are the milestones and roadmap?

**What it produces**:
- Roadmap: 6-12 month vision
- Epics: group requirements by initiative
- Versioning: versioning strategy
- Release plan: timing and dependencies

**Agnostic**: ✅ YES

**Audience**: PM, Tech Lead, Stakeholders

**Typical duration**: 1 week

---

#### 7. **Development** — How do we build it technically?

**Central question**: What are the architecture and code patterns?

**What it produces**:
- Architecture: hexagonal/clean/layered
- API reference: REST/GraphQL/etc. contracts
- Coding standards: conventions, patterns
- ADRs: technical decisions

**Agnostic**: ❌ NO — Specific to your stack (Java, Python, Node, etc.)

**Audience**: Backend Devs, Frontend Devs, Tech Lead

**Typical duration**: 2-3 weeks (parallel with testing)

---

#### 8. **Testing** — How do we validate?

**Central question**: What are the testing criteria and strategies?

**What it produces**:
- Test strategy: pyramid, coverage, philosophy
- Test plans: plans per feature/module
- Security testing: OWASP, compliance
- UAT plan: user acceptance testing

**Agnostic**: 🟡 PARTIALLY — Strategy is agnostic, but implementation is specific

**Audience**: QA, Testers, Devs

**Typical duration**: 1-2 weeks (parallel with development)

---

#### 9. **Deployment** — How do we go to production?

**Central question**: What are the environments and CI/CD pipelines?

**What it produces**:
- Environments: dev, staging, prod
- CI/CD: pipelines, gates, automation
- Release process: steps for a safe release
- Rollback strategy: how to revert

**Agnostic**: ❌ NO — Specific to your infrastructure (Docker, K8s, AWS, etc.)

**Audience**: DevOps, Tech Lead, SREs

**Typical duration**: 1 week

---

#### 10. **Operations** — How do we operate in production?

**Central question**: What are the operational procedures?

**What it produces**:
- Runbooks: step-by-step procedures
- Incident response: incident protocol
- SLAs: service level agreements
- Escalation: when to alert whom

**Agnostic**: 🟡 PARTIALLY — Processes are agnostic, tooling is specific

**Audience**: DevOps, SREs, On-Call Team

**Typical duration**: 1 week

---

#### 11. **Monitoring** — How do we measure health?

**Central question**: What are the key metrics and alerts?

**What it produces**:
- Metrics: what we measure (technical, business)
- Alerts: when to alert, why
- Dashboards: how to visualize
- SLO/SLI: objectives and indicators

**Agnostic**: 🟡 PARTIALLY — What to measure is agnostic, how is specific

**Audience**: DevOps, SREs, PM

**Typical duration**: 1 week

---

#### 12. **Feedback** — What do we learn?

**Central question**: What to improve in the next cycle?

**What it produces**:
- Retrospectives: learnings per cycle
- User feedback: what users ask for
- Metrics analysis: what the numbers say
- Process improvements: process evolution

**Agnostic**: ✅ YES

**Audience**: Everyone

**Typical duration**: 1 week (at the end of each cycle)

---

## Design Principles

### 1. Agnostic-First (Phases 1-5)

**Principle**: Describe the problem and its conceptual solution BEFORE committing to technology.

**Benefit**: 
- If you change stacks, the vision remains valid
- Non-technical people can contribute
- Code can be refactored without re-documenting

**How**: 
- Use domain terms (not technology names)
- Describe "what" and "why", not "how"

### 2. Iterable (Not Waterfall)

**Principle**: Each feature/domain can be in different phases simultaneously.

**Benefit**:
- Don't wait to have all design before starting to code
- Early feedback
- Continuous learning

**How**:
- Label each document with: domain, version, status
- Map features to domain contexts
- Update macro-plan when a phase advances

### 3. Living, Not Frozen

**Principle**: Documents are updated when reality changes.

**Benefit**:
- Documentation remains true
- The team trusts it
- Single point of reference (no conflicts with code)

**How**:
- Clear ownership (who maintains this doc)
- Update trigger (when to update)
- Periodic reviews (quarterly)

### 4. Traceable End-to-End

**Principle**: A requirement must be traceable from discovery to metric.

**Benefit**:
- Validate coverage (does anything fall through?)
- Understand impact (which requirement affects which metric?)
- Debug (where does this bug come from?)

**How**:
- Use consistent IDs (FR-001, T-001, M-001)
- Include cross-references
- Maintain a traceability matrix

### 5. Collaborative-Friendly

**Principle**: Documentation is easy to generate with AI and review with the team.

**Benefit**:
- Doesn't block the team (fast generation)
- Easy to iterate (clear templates)
- Easy to validate (explicit checklists)

**How**:
- Parameterizable templates
- Clear instructions for AI
- Validation checklist

---

## Agnostic vs. Specific

### Decision Matrix

| Phase | Agnostic? | Examples of "YES" | Examples of "NO" |
|------|-----------|------------------|------------------|
| Discovery | ✅ YES | "The user needs to authenticate" | "We use OAuth2" |
| Requirements | ✅ YES | "FR: Allow multi-factor login" | "Implement TOTP" |
| Design | 🟡 PARTIAL | "Bounded Context: Identity" | "Spring Security @PreAuthorize" |
| UI Design | 🟡 PARTIAL | "Screen: Login Modal" | "Use React Modal component" |
| Data Model | ✅ YES | "Entity: User (id, email, name)" | "PostgreSQL SERIAL type" |
| Planning | ✅ YES | "Phase 1: MVP Authentication" | "Sprint 1: 2 developers" |
| Development | ❌ NO | Specific stack is OK | "PostgreSQL, Java 21, React" |
| Testing | 🟡 PARTIAL | "Unit tests for User entity" | "JUnit 5, Mockito" |
| Deployment | ❌ NO | Specific stack is OK | "Docker, K8s, GitHub Actions" |
| Operations | 🟡 PARTIAL | "Runbook: Deploy to staging" | "ssh ec2-user@ip, ansible" |
| Monitoring | 🟡 PARTIAL | "Metric: Login success rate" | "Prometheus, Grafana" |
| Feedback | ✅ YES | "Learning: Users want SSO" | "We will use Okta" |

### Practical Rule

**Ask yourself**: Would a person without knowledge of my stack understand this?

- **YES** → Use agnostic terms
- **NO** → Specify your stack explicitly

---

## Mind Map

```
Product Vision (Discovery)
    ↓
Problem Statement & Actors
    ↓
Functional Requirements (FR-001..N)
    ↓
Non-Functional Requirements (NFR-001..N)
    ├─ Scope Boundaries
    ├─ Priority Matrix (MoSCoW)
    └─ Glossary
         ↓
    System Flows
    (how the business flows)
         ↓
    Strategic Design (DDD)
    ├─ Bounded Contexts
    ├─ Ubiquitous Language
    ├─ Context Maps
    └─ Domain Events
         ├─ UI Design
         │  ├─ Design System
         │  ├─ Wireframes
         │  └─ Navigation Flows
         │
         └─ Data Model
            ├─ Entities
            ├─ Relationships (ERD)
            └─ Data Flows
                  ↓
            Planning & Roadmap
            (when we deliver)
                  ↓
            Development Architecture
            (how we code it)
                  ├─ Hexagonal Ports & Adapters
                  ├─ Module-to-Context Mapping
                  ├─ API Contracts
                  └─ Coding Standards
                  ├─ Test Strategy
                  │  ├─ Unit Tests
                  │  ├─ Integration Tests
                  │  └─ E2E Tests
                  │
                  ├─ Deployment & CI/CD
                  │
                  ├─ Operations (Runbooks)
                  │  ├─ Monitoring
                  │  ├─ Incident Response
                  │  └─ SLAs
                  │
                  └─ Feedback & Learning
                     (returns to Discovery)
```

---

## When to Extend or Adapt

### Common Scenarios

#### 1. "My product is very simple, do I need 12 phases?"

**Answer**: No. Use what you need:

- **Startup MVP** (1-3 months): Discovery + Requirements + Design + Development + Testing
- **Mature product** (iteration): All 12
- **Maintenance**: Operations + Monitoring + Feedback

Always maintain:
- ✅ Discovery (understand the problem)
- ✅ Requirements (specify what)
- ✅ Testing (validate it works)

#### 2. "My organization uses Scrum/Kanban, is it incompatible?"

**Answer**: No, they are complementary:

- **SDLC Framework** (this): Documentation structure (what to produce)
- **Scrum/Kanban**: Execution methodology (how to organize work)

**Mapping**:
```
Scrum Sprint (1-2 weeks)
  ├─ Discovery tasks (explore new feature)
  ├─ Development tasks (code requirements)
  ├─ Testing tasks (validate)
  └─ Documentation (update docs for each phase)
```

#### 3. "I have existing documentation in another format, how do I migrate?"

**Answer**: Gradually:

1. Identify what documentation you have (audit)
2. Map to the 12 phases
3. Migrate phase by phase
4. Fill gaps with AI

Example:
```
Existing: "API Spec" 
  → Goes to: 01-templates/06-development/api-reference.md

Existing: "Product Roadmap" 
  → Goes to: 01-templates/05-planning/roadmap.md

Gap identified: No Discovery document
  → Generate with AI
```

#### 4. "We want more/less detail in some phases"

**Answer**: Customize the templates:

- 📉 **Reduce**: Remove optional sections
- 📈 **Increase**: Add sections to templates

Example (reduce Requirements):
```markdown
# FR-001: User Login

Description: ...
Acceptance Criteria: ...
(remove: Risks, Implementation Notes)
```

---

## Template Governance

### Template Structure

Each `TEMPLATE-*.md` file follows this pattern:

```markdown
[← Index](./README.md) | [< Previous] | [Next >]

---

# [DOCUMENT NAME]

[1-2 sentences of purpose]

## Contents

[Section index]

---

## Section 1

[Content]

[↑ Back to top](#document-name)

---

## Section N

[Content]

[↑ Back to top](#document-name)

---

[← Index] | [< Previous] | [Next >]
```

### When to Update a Template

Update a template when:

- ✏️ You discover a missing section
- ✏️ A section is confusing
- ✏️ The order should change
- ✏️ There is a new requirement

**DO NOT** update when:
- ❌ A concrete document needs tweaks (use that document, not the template)
- ❌ Short-term changes (temporary cycle)

### How to Propose Changes

If you have an improvement to the templates:

1. Document the proposed change in `IMPROVEMENTS.md` (create if it doesn't exist)
2. Explain why (impact, benefit)
3. Provide an example of the improved template
4. Discuss with the team
5. Apply to all templates if approved

---

## Contributing to the Template

### Where to Report Issues

- **Bug** (broken template, incorrect instruction): Repo issues
- **Feature** (new section, new phase): Discussions
- **Enhancement** (make clearer, shorter): Pull Request

### Issue Template

```markdown
**Type**: Bug / Feature / Enhancement

**Location**: [e.g.: 00-guides-and-instructions/INSTRUCTIONS-FOR-AI.md]

**Problem**: [describe in 2-3 sentences]

**Impact**: [who is affected, how many documents]

**Proposed solution**: [what to change]

**Example** (if applicable):
```

### How to Keep the Template Agnostic

When contributing:

1. **Review the 12 phases**: Does your change affect any?
2. **Validate agnostic**: Is it still agnostic in phases 1-5?
3. **Test with example**: Does it work for different products?
4. **Update docs** if what you change affects instructions

---

## Cheat Sheet

### Rename a Document

```bash
# Rename
mv 01-templates/02-requirements/TEMPLATE-glossary.md 01-templates/02-requirements/glossary.md

# Update references in README
nano 01-templates/02-requirements/README.md
# Change the document line

# Update references in other docs
grep -r "TEMPLATE-glossary" .
```

### Add a New Section to a Template

1. Open the template
2. Copy an existing section as reference
3. Adapt for your new section
4. Update the Contents Index at the top
5. Test with AI (ask it to complete the new section)

### Validate That the Template Is Complete

Checklist:

- [ ] 12 phase folders (00 → 11)
- [ ] Each folder has `README.md`
- [ ] Each README points to documents in that folder
- [ ] Each document has `[← Index]` and navigation
- [ ] No unrenamed `TEMPLATE-` files in final phase
- [ ] All links are relative (not absolute paths)
- [ ] Cross-references exist (e.g.: FR references Design)

---

## Next Steps

1. 📖 Read this guide completely
2. 🎯 Decide: Will I adapt all 12 phases or select some?
3. 🔧 Start with structure adaptation (Step 2 of [`TEMPLATE-USAGE-GUIDE.md`](./TEMPLATE-USAGE-GUIDE.md))
4. 🤖 Use [`INSTRUCTIONS-FOR-AI.md`](./INSTRUCTIONS-FOR-AI.md) to generate content

---

[← Index](./README.md)
