[← Index](./README.md)

---

# Frequently Asked Questions

Answers to the most common doubts about the template.

---

## Contents

- [Time and duration](#time-and-duration)
- [Scope and phases](#scope-and-phases)
- [Agnostic vs. specific](#agnostic-vs-specific)
- [Collaboration with AI](#collaboration-with-ai)
- [Maintenance](#maintenance)
- [Adaptation](#adaptation)

---

## Time and Duration

### How long does it take to complete all the documentation?

**Answer**: 30-40 hours distributed over 5-7 work days (not consecutive).

**Breakdown**:
- Preparation + adaptation: 30 min
- Discovery: 2-3 h
- Requirements: 3-4 h
- Design: 3-4 h
- Data Model: 2 h
- Planning: 2 h
- Development: 4-5 h
- Testing, Deployment, Operations, Monitoring, Feedback: ~15 h
- Cross-phase validation: 1-2 days

**Advice**: Don't try to do it all in 1 day. It's better 1 phase/day so you can review and adjust.

### Can I do it faster?

**Answer**: Yes, but with trade-offs:

- **Express version** (1 day): Only Discovery + Requirements + Design → good MVP
- **Complete version** (5-7 days): All 12 phases
- **Extended version** (2+ weeks): Includes code examples, detailed UML diagrams, etc.

**Recommendation**: Do express version first, then iterate.

---

## Scope and Phases

### Do I need to complete all 12 phases?

**Answer**: It depends on your situation.

| Situation | Required Phases | Optional |
|-----------|----------------|----------|
| Startup MVP (first 4 weeks) | 1-6 (Discovery → Development) | 7-12 |
| Mature product iteration | All | Depends |
| Maintenance of live product | 10, 11, 12 (Operations, Monitoring, Feedback) | 1-9 (if unchanged) |
| Major refactoring | 6, 7, 8 (Development, Testing, Deployment) | 1-5 (if problem remains the same) |

**Golden rule**: Always include:
- ✅ Discovery (why?)
- ✅ Requirements (what?)
- ✅ Testing (do we validate?)

### Can I skip phase X?

**Answer**: Technically yes, but there are risks.

| If you skip... | Risk | Alternative |
|---|---|---|
| Discovery | You build the wrong solution | Do ultra-fast version (30 min) |
| Requirements | Confused RF, dev blocked | Do executive version by epic |
| Design | No domain model, disorganized architecture | Use lightweight strategic DDD |
| Data Model | DB without clear relationships, future refactors | Sketch quick ERD in 30 min |
| Testing | Bugs in prod, breaking changes | At least plan tests |
| Operations | Downtime, confusion in incidents | Simple 1-page runbook |

**Advice**: If you're in a hurry, reduce don't skip. Do executive versions.

### What happens if I change domain midway?

**Answer**: Go back to Discovery.

Example:
```
You started with: Blog System
Now you need: Blog System + E-Commerce

Action:
1. Do NEW Discovery for E-Commerce context
2. Add new Bounded Contexts in Design
3. Merge Data Models
4. Continue with Development for new endpoints
```

It's not waterfall. It's iterative by domain.

---

## Agnostic vs. Specific

### How do I know if a document is agnostic?

**Key question**: Would someone without knowledge of my stack understand it?

**Agnostic examples** (✅):
- "The system must support multiple languages"
- "There must be traceability of user actions"
- "The API must respond in <500ms"

**Specific examples** (❌):
- "We will use PostgreSQL with partitions by tenant"
- "REST API with Spring Boot @RestController"
- "React with Redux for state management"

**Rule**: Phases 1-5 agnostic, phases 6-12 specific.

### Why does being agnostic in early phases matter?

**Reason 1**: Stack change without rewriting documentation.

Example:
```
Scenario A (agnostic):
"RF: User can authenticate"
  → Java + Spring implementation → Years later → Migration to Node.js
  → Same RF remains valid ✅

Scenario B (specific):
"Use Spring Security with @PreAuthorize"
  → Migration to Node.js
  → All documentation is obsolete ❌
```

**Reason 2**: Non-technical people can contribute.

```
PM understands: "The user can filter orders by status"
PM DOES NOT understand: "Implement indexes on (user_id, order_status)"
```

**Reason 3**: Free debate without technological anchor.

```
"How many authorizations do we support?" ← Business debate
vs.
"JWT or Session?" ← Technical debate (comes later)
```

---

## Collaboration with AI

### Why do I need special instructions for AI?

**Answer**: AI works better with:

1. **Clear structure** — knows exactly what to produce
2. **Sufficient context** — doesn't invent, generates based on facts
3. **Explicit validation** — you validate, don't assume it was good
4. **Precise language** — "agnostic" for AI means not mentioning frameworks

**Result**: 80% ready documentation in first iteration. Requires 1-2 rounds of adjustments.

### What information should I provide to AI?

**Minimum**:
- Name + problem in 1 sentence
- Target users
- Expected domain contexts (3-5)
- Key constraints (compliance, scale, etc.)

**Ideal**:
- + Existing documentation
- + Competitors
- + Long-term vision
- + Technical stack (for phases 6+)

Example minimum prompt:

```
Product: TaskFlow
Problem: Small teams spend 5h/day on task synchronization
Users: Startups 5-15 people
Contexts: Auth, Projects, Tasks, Notifications, Billing
Constraint: <500ms response, GDPR

Generate Discovery/context-motivation.md
```

### Can AI generate all 12 phases at once?

**Answer**: Not recommended.

**Why**:
- One phase depends on output of previous
- Errors amplify (garbage in → garbage out)
- It's hard to validate 40 pages at once

**Better**:
```
Day 1: Discovery (2-3h with AI)
Validate with team (30 min)
  ↓
Day 2: Requirements (3-4h with AI)
Validate with PM (30 min)
  ↓
Day 3: Design (3-4h with AI)
Validate with tech lead (1h)
  ↓
...
```

### How good is the quality of AI-generated docs?

**Answer**: 70-80% usable, 20-30% requires adjustments.

**Typically good**:
- Structure and sections ✅
- Basic examples ✅
- Narrative descriptions ✅

**Typically requires adjustment**:
- Domain complexity (AI understands but generalizes)
- Specific details (requires your knowledge)
- Trade-off decisions (AI doesn't decide, documents alternatives)

**Advice**: Treat AI as "first draft" not "final document".

---

## Maintenance

### How frequently do I update the documentation?

**Answer**: It depends on what changed.

| Change | When to update | Affected Phase |
|--------|---------------|---------------|
| Code is refactored | Immediately | Development |
| A new requirement is discovered | Before coding | Requirements |
| Roadmap changes | Next planning | Planning |
| Incident in prod | After, in postmortem | Operations, Feedback |
| Number of users grows 2x | Quarterly review | Monitoring |

**Simple policy**:
- 🟢 **Greenfield** (new product): Document while coding
- 🟡 **Brownfield** (iteration): Update docs with important PRs
- 🔴 **Refactor/Rewrite**: Pause, document changes, continue

### How do I prevent documents from becoming outdated?

**Answer**: Ownership + triggers.

**Ownership**:
```markdown
---
**Owner**: [name]
**Last Updated**: 2026-04-22
**Next Review**: 2026-07-22
---
```

**Triggers** (when to update):
```markdown
**Update Triggers**:
- [ ] If [RF-001] changes, review "Authentication" section
- [ ] If new Bounded Contexts are added, update "Context Map"
- [ ] If versioning strategy changes, update "Roadmap"
```

**Quarterly review**: Each team reviews their docs. 30 min meeting.

### What if I forget to update and the doc is obsolete?

**Answer**: Convert to "Legacy" (deprecated).

```markdown
⚠️ **DEPRECATED** — This document is historical (2026-03)
Check [new document](./new.md) for current information.

[Historical information below...]
```

**Don't delete**, keep for historical reference.

---

## Adaptation

### Can I change the folder names?

**Answer**: Yes, but maintain consistency.

**Not recommended**: `01-templates/01-discovery/`, `req/`, `01-templates/03-design/` (inconsistent)

**Recommended options**:
```
Option A (numbers + names):
  01-discovery, 02-requirements, 03-design, ...

Option B (names only, ordered):
  discovery, requirements, design, data-model, planning, ...

Option C (numbers + acronyms):
  01-disc, 02-req, 03-des, 04-data, ...
```

**Advice**: Use Keygo convention (numbers + names). It's clear.

### Can I remove sections from a document?

**Answer**: Yes, if you don't need that information.

Examples of reduction:

**Original RF**:
```
1. Description
2. Justification
3. Acceptance Criteria
4. Dependencies
5. Risks
6. Implementation Notes
```

**Reduced** (MVP):
```
1. Description
2. Acceptance Criteria
```

**Advice**: Start with complete version. Reduce if too verbose.

### Can I add new sections?

**Answer**: Yes, especially for complex domains.

Example (add to Bounded Context):
```markdown
## Aggregates

[list of aggregates]

## Critical Invariants

[list of rules that MUST always hold]

## Special Patterns

[unique patterns of the context]
```

**Advice**: Add only if it adds value. Avoid info overload.

### How do I integrate existing documentation from Notion/Confluence?

**Answer**: Export to Markdown, map to phases, adjust.

**Steps**:
1. Export existing documents (Notion → Markdown, Confluence → HTML → Markdown)
2. Identify which phase each belongs to
3. Place in corresponding folder
4. Update missing sections
5. Add navigation (previous/next links)

Example:
```
Notion "Product Spec"
  → Analysis: Contains RF + RNF + Design
  → Separate into: 02-requirements + 03-design
  → Create new sections: 01-discovery (missing)
  → Add navigation
```

---

## Common Troubleshooting

### "AI generated everything identical, generic text"

**Cause**: Insufficient context

**Solution**:
```
Add to your next prompt:
- Specific example of the flow (not abstract)
- Real constraints (GDPR, PCI, etc.)
- Expected scale (10k users? 1M?)
- A competitor to compare
```

### "I don't know when one phase ends and another begins"

**Cause**: Ambiguity in boundaries

**Solution**: Use the central question of each phase:

```
Discovery: WHAT PROBLEM do we solve?
Requirements: WHAT MUST IT DO?
Design: HOW DOES IT FLOW?
Development: HOW DO WE CODE IT?
```

If your document answers several questions → Split it

### "My documentation is too long / too short"

**Cause**: Expectation of granularity poorly defined

**Solution**:
```
Too long: Reduce sections, convert to bullet points
Too short: Add examples, use cases, pros/cons
```

Use this heuristic:
- 500-800 words: Executive summary
- 1000-1500 words: Overview
- 2000-3000 words: Full detail
- 3000+ words: Probably should be 2 documents

---

## Contact and Improvements

### Where do I report a bug in the template?

**GitHub Issues**: [Create issue](../../issues)

**Template**:
```
**Title**: [Bug/Feature/Question] [Component]

**Location**: Which affected file

**Problem**: Clear description in 2-3 sentences

**Impact**: Who is affected

**Proposed solution**: What to change
```

### Can I improve a template?

**Yes, via Pull Request**.

**Steps**:
1. Fork repo
2. Create branch: `improve/template-name`
3. Make changes
4. Describe changes in PR
5. Wait for review

---

[← Index](./README.md)
