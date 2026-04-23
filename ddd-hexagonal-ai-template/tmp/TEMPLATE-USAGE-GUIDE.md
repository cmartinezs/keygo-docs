# Complete Guide: Using the DDD + Hexagonal Template

Step by step to adapt this template to your project and generate documentation with AI.

---

## Contents

- [Step 1: Preparation (15 min)](#step-1-preparation-15-min)
- [Step 2: Structure Adaptation (20 min)](#step-2-structure-adaptation-20-min)
- [Step 3: Content Generation with AI (2-3 days)](#step-3-content-generation-with-ai-2-3-days)
- [Step 4: Validation and Adjustments (1-2 days)](#step-4-validation-and-adjustments-1-2-days)
- [Step 5: Keeping Documentation Alive](#step-5-keeping-documentation-alive)
- [Final Checklist](#final-checklist)

---

## Step 1: Preparation (15 min)

### 1.1 Gather information about your product

Before starting, you must have clarity about:

**Business Information:**
- What problem does your product solve? (1-2 sentences)
- For whom? (end users, companies, etc.)
- Why now? (market context)
- What is your competitive advantage?

**Technical Information:**
- What technologies will you use? (backend, frontend, DB stack, etc.) — just for clarity, not part of the template
- What is your expected scale? (users, data, requests/second)
- What technical constraints exist? (latency, compliance, etc.)

**Organizational Information:**
- Who is the product owner? (PM, founder, etc.)
- Who is the tech lead?
- What is your 6-12 month roadmap?

### 1.2 Define initial "Bounded Contexts"

Bounded Contexts are the distinct business domains in your system. Examples:

- **Authentication system**: Identity, Authorization, Sessions
- **Billing system**: Catalog, Subscriptions, Invoicing, Payments, Dunning
- **Marketplace**: Products, Orders, Payments, Shipping, Reviews
- **SaaS**: Organizations, Users, Configuration, Roles

**Identify 3-5 main contexts.** They don't need to be perfect now — they will be refined in Discovery.

---

## Step 2: Structure Adaptation (20 min)

### 2.1 Copy the template

```bash
# In your repo, copy the folder
cp -r ddd-hexagonal-ai-template/ your-project-docs/

# Navigate
cd your-project-docs/
```

### 2.2 Rename TEMPLATE- files

Replace `TEMPLATE-` with real names:

```bash
cd 01-templates/01-discovery/
mv TEMPLATE-context-motivation.md context-motivation.md
mv TEMPLATE-system-vision.md system-vision.md
mv TEMPLATE-system-scope.md system-scope.md
# ... and so on for all TEMPLATE-*.md
```

**Shortcut**: Find all TEMPLATE-*.md in the structure:

```bash
find . -name "TEMPLATE-*.md" -type f
```

### 2.3 Update the README.md of each folder

Each `README.md` has a template. Update:

1. The phase description (3-4 sentences)
2. The list of documents that will go in that folder

**Example for `01-templates/01-discovery/README.md`:**

```markdown
[← HOME](../README.md)

---

# Discovery: [YOUR PRODUCT]

In this phase we explore the problem that [YOUR PRODUCT] solves:
[2-3 sentence description].

We identify users, their needs, market context and
key risks or opportunities.

---

## Contents

* [Context and Motivation](./context-motivation.md)
* [System Vision](./system-vision.md)
* [System Scope](./system-scope.md)
* [Actors](./actors.md)
* [Needs and Expectations](./needs-expectations.md)
* [Final Analysis](./final-analysis.md)

---

[← HOME](../README.md) | [Next >](./context-motivation.md)
```

### 2.4 Update MACRO-PLAN.md

Replace placeholders with your information:

```markdown
# MACRO-PLAN: [YOUR PRODUCT] Documentation — SDLC Framework

## Vision

[Your product vision in 3-4 sentences]

## The Cycle

[Copy cycle diagram]

---

## Phases and Sub-Plans

### [SP-0] SDLC Framework ✅
**Objective**: [describe]
**Deliverable**: [file list]
**Status**: 🔲 (In progress)

### [SP-D1] Discovery 🔲
**Objective**: [describe]
**Folder**: `01-templates/01-discovery/`
**Deliverables**:
- [file list]

**Status**: 🔲 (Not started)

... (repeat for all 12 phases)
```

---

## Step 3: Content Generation with AI (2-3 days)

### 3.1 Read the instructions for AI

Open [`INSTRUCTIONS-FOR-AI.md`](./INSTRUCTIONS-FOR-AI.md) to see:

- How to structure prompts
- What context to provide
- Validation checklist

### 3.2 Generate content phase by phase

**Recommended order:**

1. **01-Discovery** (2-3 hours)
   - Provide problem statement and context
   - AI generates: context-motivation, system-vision, scope, actors, needs
   - Review and adjust

2. **02-Requirements** (3-4 hours)
   - Provide glossary and requirements list (I can help you extract them)
   - AI generates: RF, RNF, prioritization matrix
   - Review and ensure technology agnostic

3. **03-Design** (3-4 hours)
   - Provide validated requirements
   - AI generates: bounded contexts, strategic design, system flows
   - Review domain model coherence

4. **04-Data Model** (2 hours)
   - AI extracts from design: entities, relationships, data flows
   - Validate that ERD is coherent

5. **05-Planning** (2 hours)
   - Define roadmap at feature/epic level
   - AI generates structuring by version

6. **06-Development** (4-5 hours)
   - Here YES you use your specific stack
   - AI generates: architecture, API contracts, coding standards

7. **07-Testing → 11-Feedback** (2-3 hours each)
   - AI generates based on previous phases

### 3.3 Validation after each phase

**For each generated document:**

1. ✅ Read it completely
2. ✅ Validate it answers the central question of the phase
3. ✅ Validate it is technology agnostic (if applicable)
4. ✅ Validate there are cross-references (links to other documents)
5. ✅ If something is missing, ask AI to expand

---

## Step 4: Validation and Adjustments (1-2 days)

### 4.1 Cross-phase coherence validation

After completing all phases:

1. **Discovery ↔ Requirements**: Do the RF respond to Discovery needs?
2. **Requirements ↔ Design**: Does the design cover all RF?
3. **Design ↔ Data Model**: Do entities support the flows?
4. **Data Model ↔ Development**: Do architecture and APIs map the data model?
5. **Development ↔ Testing**: Do test plans cover the requirements?

Create a traceability matrix:

```
RF-001 (Login)
  ↓
  Design (AuthFlow + 3 Bounded Contexts)
  ↓
  Data Model (User, Session entities)
  ↓
  Dev (Spring Security config + API /auth/login)
  ↓
  Testing (unit + integration tests)
  ↓
  Deployment (secrets, environment setup)
```

### 4.2 Team review

- Tech lead: reviews Development + Testing
- PM: reviews Discovery + Requirements + Planning
- DevOps: reviews Deployment + Operations

---

## Step 5: Keeping Documentation Alive

### 5.1 Update policy

Documentation is updated when:

- ✏️ **Code changes** — if you change an API, update `01-templates/06-development/api-reference.md`
- ✏️ **Requirements change** — if you discover a new requirement, update `01-templates/02-requirements/`
- ✏️ **Processes change** — if the team changes how they work, update `CLAUDE.md` or `01-templates/08-deployment/`

### 5.2 Ownership

Each document must have an owner:

```markdown
---
**Owner**: [name]
**Last Updated**: YYYY-MM-DD
**Next Review**: YYYY-MM-DD
---
```

### 5.3 Feedback loops

Each quarter:
- The team reviews the documents
- Are they updated? Is something missing?
- Record in `01-templates/11-feedback/retrospectives.md`

---

## Final Checklist

Before considering documentation complete:

### Structure
- [ ] All 12 phases have folders
- [ ] Each folder has `README.md`
- [ ] No `TEMPLATE-*` files in final structure (all renamed)
- [ ] `MACRO-PLAN.md` is updated

### Content
- [ ] Discovery answers: What problem do we solve?
- [ ] Requirements answers: What must the system do?
- [ ] Design answers: How does the system flow?
- [ ] Data Model answers: How is data stored?
- [ ] Planning answers: When and how do we deliver?
- [ ] Development answers: How do we build it technically?
- [ ] Testing answers: How do we validate?
- [ ] Deployment answers: How do we go to production?
- [ ] Operations answers: How do we operate?
- [ ] Monitoring answers: How do we measure health?
- [ ] Feedback answers: What do we learn?

### Cross-references
- [ ] Each RF in Requirements has traceability to Design + Development
- [ ] Each Design decision has justification (alternatives considered)
- [ ] Each API in Development references the requirement it implements

### Agnostic/Specific
- [ ] Discovery-Requirements are **technology agnostic**
- [ ] Design is **agnostic or agnostic-with-principles** (ex: "REST API" is architectural, not specific)
- [ ] Development-Deployment-Operations are **specific to your stack**

### Navigation
- [ ] Each document has Previous/Next links
- [ ] Each document has link to folder Index
- [ ] Each section has return link to top
- [ ] No broken links (manual review)

---

## Total Estimated Time

| Phase | Time | Notes |
|------|--------|-------|
| Preparation | 15 min | Business information + contexts |
| Adaptation | 20 min | Copy, rename, update READMEs |
| Discovery (with AI) | 2-3 h | More time if you need to refine a lot |
| Requirements | 3-4 h | Important to validate agnostic |
| Design | 3-4 h | Center of documentation |
| Data Model | 2 h | Extracted from design |
| Planning | 2 h | |
| Development | 4-5 h | Here you use your stack |
| Testing → Feedback | 2-3 h each | Total ~12-15 h |
| **Validation and adjustments** | **1-2 days** | Cross-checking |
| **TOTAL** | **~30-40 h** | Work distributed over 5-7 days |

---

## Next Steps

1. ✅ Complete preparation (Step 1)
2. 📁 Adapt the structure (Step 2)
3. 🤖 Use `INSTRUCTIONS-FOR-AI.md` to generate content
4. 🔍 Validate cross-phase coherence (Step 4)
5. 📈 Set up ownership and feedback loops (Step 5)

---

[← Index](./README.md)
