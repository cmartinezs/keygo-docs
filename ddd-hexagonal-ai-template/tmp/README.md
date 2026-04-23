[← HOME](../README.md)

---

# Guides and Instructions

Control center for understanding and using the DDD + Hexagonal template.

---

## 📚 Documentation

### Getting Started

1. **[TEMPLATE-USAGE-GUIDE.md](./TEMPLATE-USAGE-GUIDE.md)** — Complete step-by-step
   - Preparation (15 min)
   - Adaptation (20 min)
   - Generation (2-3 days)
   - Validation
   - Keeping documentation alive

2. **[INSTRUCTIONS-FOR-AI.md](./INSTRUCTIONS-FOR-AI.md)** — Quick reference: principles and structure
   - General principles
   - Prompt structure
   - Prompts by phase (discovery, requirements, design, etc.)
   - Validation checklist
   - Troubleshooting

3. **[AI-WORKFLOW-GUIDE.md](./AI-WORKFLOW-GUIDE.md)** ⭐ **← START HERE if you work with AI**
   - General step-by-step flow
   - Detailed preparation (Day 1)
   - Discovery with practical examples (Day 2-3)
   - Requirements with ready templates (Day 4-5)
   - Design with DDD patterns (Day 6-7)
   - Data Model, Planning, Development (Day 8-10+)
   - Integral validation
   - Advanced troubleshooting

### Examples and Reference

4. **[EXAMPLE-IMPLEMENTATION.md](./EXAMPLE-IMPLEMENTATION.md)** — Complete day-by-day example
   - Real case: Keygo documentation
   - What to do each day (Day 1-10)
   - Specific prompts and validation
   - Cross-phase coherence checklist

5. **[SKILLS-AND-PLUGINS-GUIDE.md](./SKILLS-AND-PLUGINS-GUIDE.md)** — Using Claude Code skills
   - Skills by phase (Discovery, Design, Development, Testing, Deployment, Ops, Monitoring)
   - Which skill to use when and for what
   - How to install/activate (MCP, OAuth)
   - Recommended workflow with skills
   - Pre-production checklist

### To Understand the Architecture

5. **[TEMPLATE-ARCHITECTURE.md](./TEMPLATE-ARCHITECTURE.md)** — How the template is designed
   - Philosophy (why 12 phases)
   - Principles (agnostic, iterable, alive)
   - Mind map
   - When to adapt/extend

### Help

6. **[FAQ.md](./FAQ.md)** — Frequently Asked Questions
   - "How long does it take to complete everything?"
   - "Can I skip phases?"
   - "How do I update documents when code changes?"
   - And more...

---

## 🚀 Quick Start (30 minutes)

**If you work with AI:**
1. Read this README (5 min)
2. Open [`AI-WORKFLOW-GUIDE.md`](./AI-WORKFLOW-GUIDE.md) and start with "Preparation (Day 1)"
3. Follow the day-by-day flow
4. Check [`INSTRUCTIONS-FOR-AI.md`](./INSTRUCTIONS-FOR-AI.md) for specific prompts

**If you work without AI:**
1. Read this README (5 min)
2. Open [`TEMPLATE-USAGE-GUIDE.md`](./TEMPLATE-USAGE-GUIDE.md) and complete "Step 1: Preparation"
3. Complete "Step 2: Structure Adaptation"
4. Document manually or use your own tools

---

## 📁 Template Structure

```
01-templates/00-documentation-planning/
├── sdlc-framework.md
└── navigation-conventions.md

01-templates/01-discovery/  ← What problem we solve
01-templates/02-requirements/  ← What the system must do
01-templates/03-design/  ← How the system flows
01-templates/04-data-model/  ← How data is stored
01-templates/05-planning/  ← When and how we deliver
01-templates/06-development/  ← How we build it technically
01-templates/07-testing/  ← How we validate
01-templates/08-deployment/  ← How we go to production
01-templates/09-operations/  ← How we operate
01-templates/10-monitoring/  ← How we measure
01-templates/11-feedback/  ← What we learn
```

---

## 📖 Document Index (by reading order)

| Order | Document | Duration | For Whom | Purpose |
|-------|----------|----------|----------|---------|
| 1 | [`TEMPLATE-USAGE-GUIDE.md`](./TEMPLATE-USAGE-GUIDE.md) | 20 min | Everyone | Understand complete process |
| 2 | [`AI-WORKFLOW-GUIDE.md`](./AI-WORKFLOW-GUIDE.md) ⭐ | 30 min | **With AI** | Practical day-by-day flow |
| 3 | [`EXAMPLE-IMPLEMENTATION.md`](./EXAMPLE-IMPLEMENTATION.md) | 20 min | **With AI** | Real case (Keygo) Day 1-10 |
| 4 | [`SKILLS-AND-PLUGINS-GUIDE.md`](./SKILLS-AND-PLUGINS-GUIDE.md) ⭐ | 20 min | **Everyone** | Skills by phase, how to use, setup |
| 5 | [`INSTRUCTIONS-FOR-AI.md`](./INSTRUCTIONS-FOR-AI.md) | 20 min | References | Specific prompts by phase |
| 6 | [`TEMPLATE-ARCHITECTURE.md`](./TEMPLATE-ARCHITECTURE.md) | 15 min | Curious | Internal template design |
| 7 | [`FAQ.md`](./FAQ.md) | 10 min | Skeptical | Common problems |

---

## 🎯 Learning Paths

### "I want to generate documentation FAST with AI" ⭐

1. Open [`AI-WORKFLOW-GUIDE.md`](./AI-WORKFLOW-GUIDE.md) — "General Flow" section
2. Prepare your product information (20 min)
3. Follow "Day 1: Preparation"
4. Then Day 2-3: Discovery, Day 4-5: Requirements, etc.
5. Check [`INSTRUCTIONS-FOR-AI.md`](./INSTRUCTIONS-FOR-AI.md) if you need specific prompts
6. **Result**: Complete documentation in 10-15 days

### "I want to validate my work with Claude Code Skills" ⭐⭐

1. Read [`SKILLS-AND-PLUGINS-GUIDE.md`](./SKILLS-AND-PLUGINS-GUIDE.md) — "General: All useful skills"
2. Identify skill by phase (Design → `/domain-driven-design`, Code → `/code-craftsmanship:clean-code`, etc.)
3. Follow "Recommended Workflow by Day"
4. Run "Checklist: Before Production"
5. **Result**: Code and docs validated by experts

### "I want to see a real example step by step"

1. Read [`EXAMPLE-IMPLEMENTATION.md`](./EXAMPLE-IMPLEMENTATION.md)
2. Case: Generating docs for Keygo (real product)
3. Day 1: Prepare information
4. Day 2-3: Generate Discovery (3 documents)
5. Follow the pattern for the remaining days
6. Adapt examples to your product

### "I have disorganized documentation and want to centralize it"

1. Read this folder to understand structure
2. Map your existing documentation to the 12 phases
3. Fill gaps with AI
4. Centralize in this structure

### "I want to understand if the DDD + Hexagonal approach is for me"

1. Read [`TEMPLATE-ARCHITECTURE.md`](./TEMPLATE-ARCHITECTURE.md)
2. Read `../01-templates/00-documentation-planning/sdlc-framework.md`
3. Decide whether to adapt or create your own structure

### "I have problems generating documentation with AI"

1. Go to [`INSTRUCTIONS-FOR-AI.md`](./INSTRUCTIONS-FOR-AI.md) → "Troubleshooting"
2. Read the case that resembles yours
3. Or check [`AI-WORKFLOW-GUIDE.md`](./AI-WORKFLOW-GUIDE.md) → "Advanced Troubleshooting"
4. Adjust your prompt according to the suggested solution

---

## 🔑 Key Concepts

### 1. Agnostic vs. Specific

- **Phases 1-5** (Discovery → Planning): **Technology agnostic**
  - Describes "what", not "how"
  - No framework names, languages, DB
  - Focus on business and user

- **Phases 6-12** (Development → Feedback): **Specific to your stack**
  - Here you mention your technology
  - Real architecture, APIs, code
  - Technical focus

### 2. Iterative, not Waterfall

Each feature/domain can be in different phases:

```
Auth Phase:     Discovery ✅ → Requirements ✅ → Design → Development
Billing Phase:  Discovery ✅ → Requirements → Design (upcoming weeks)
Admin Phase:    Backlog (not started)
```

### 3. Traceability

A requirement must be traceable from Discovery to Monitoring:

```
RF-001 (user can log in)
  ↓ referenced in
Discovery (user need)
  ↓ implemented in
Design (login flow)
  ↓ reflected in
Data Model (user entity)
  ↓ coded in
Development (LoginController + API)
  ↓ tested in
Testing (unit + integration)
  ↓ measured in
Monitoring (login success rate)
```

---

## ⚠️ Common Mistakes

1. **Skipping phases** ← Tempting but causes incoherence
   - Solution: Make quick versions (1 page) if you're in a hurry, but don't skip

2. **Mixing agnostic with specific in phases 1-5**
   - Solution: Use [`INSTRUCTIONS-FOR-AI.md`](./INSTRUCTIONS-FOR-AI.md) as checklist

3. **Not validating documents/code with skills**
   - Solution: Read [`SKILLS-AND-PLUGINS-GUIDE.md`](./SKILLS-AND-PLUGINS-GUIDE.md), use skill by phase
   - Ex: Design → `/domain-driven-design`, Code → `/code-craftsmanship:clean-code`

4. **Generating everything at once without validating**
   - Solution: Generate phase by phase, validate with corresponding skill, adjust

5. **Not providing enough context to AI**
   - Solution: See ["Provide context, don't ask it to invent"](./INSTRUCTIONS-FOR-AI.md#2-provide-context-dont-ask-it-to-invent)

6. **Not updating documents when code changes**
   - Solution: Set up ownership + alerts (see TEMPLATE-USAGE-GUIDE.md)

---

## 🤝 Contribution and Improvements

This template is designed to be **agnostic and reusable**. If you find:

- ✅ A format improvement
- ✅ A template that doesn't work well
- ✅ A use case not covered
- ✅ An error in the instructions

**Document it** and improve the template. Use the issue template in [`TEMPLATE-ARCHITECTURE.md`](./TEMPLATE-ARCHITECTURE.md#contributing-to-the-template).

---

## 📞 Help

- **How do I start without AI?** → Read [`TEMPLATE-USAGE-GUIDE.md`](./TEMPLATE-USAGE-GUIDE.md)
- **How do I work WITH AI?** → Read [`AI-WORKFLOW-GUIDE.md`](./AI-WORKFLOW-GUIDE.md) ⭐
- **Do I need specific prompts?** → Check [`INSTRUCTIONS-FOR-AI.md`](./INSTRUCTIONS-FOR-AI.md) by phase
- **Do I have a question?** → Look in [`FAQ.md`](./FAQ.md)
- **Do I want to understand the architecture?** → Read [`TEMPLATE-ARCHITECTURE.md`](./TEMPLATE-ARCHITECTURE.md)

---

[← HOME](../README.md)
