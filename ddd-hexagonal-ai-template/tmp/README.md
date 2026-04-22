
# DDD + Hexagonal Architecture Documentation Template

A reusable, AI-friendly template for generating complete product documentation using Domain-Driven Design (DDD) strategic design + Hexagonal Architecture principles.

## ✨ Features

- **12-Phase SDLC Framework**: Discovery → Development → Operations → Feedback
- **Technology-Agnostic**: Describes "what" before "how" (phases 1-5)
- **AI-Ready**: Built for AI collaboration (Claude, ChatGPT, etc.)
- **Iterable**: Each feature/domain progresses at its own pace
- **Trazable**: Requirements → Design → Code → Tests → Metrics
- **Living Documentation**: Stays in sync with code and decisions

## 🎯 Generate Documentation in 10-15 Days

1. **Prepare** your product information (30 min)
2. **Follow** daily workflow (Day 1-10)
3. **Validate** with AI prompts and Claude Code skills
4. **Deploy** complete documentation

## 📚 What You Get

- ✅ Discovery & Requirements (agnostic)
- ✅ Strategic Design & Bounded Contexts (DDD)
- ✅ System Flows & Data Model
- ✅ Planning & Roadmap
- ✅ Architecture & APIs (specific to your stack)
- ✅ Testing Strategy & Deployment
- ✅ Operations, Monitoring, Feedback

## 🚀 Quick Start
```bash
# Copy template to your project
cp -r ddd-hexagonal-ai-template/ your-project/docs

# Read the guides
open ddd-hexagonal-ai-template/00-guides-and-instructions/README.md

# Choose your path
# - With AI: AI-WORKFLOW-GUIDE.md
# - Without AI: TEMPLATE-USAGE-GUIDE.md
```

## 📖 Guides Included

| Guide | Duration | For Whom | Purpose |
|-------|----------|----------|---------|
| **AI-WORKFLOW-GUIDE.md** | 30 min | With AI | Day-by-day workflow |
| **EXAMPLE-IMPLEMENTATION.md** | 20 min | Real case | Keygo (actual product) example |
| **SKILLS-AND-PLUGINS-GUIDE.md** | 20 min | Claude Code | Skills per phase + setup |
| **INSTRUCTIONS-FOR-AI.md** | 20 min | Prompts | Ready-to-use prompts for each phase |
| **TEMPLATE-USAGE-GUIDE.md** | 20 min | Manual | Without AI workflow |

## 🎓 Philosophy

### Why 12 Phases?

Natural lifecycle of any product:
1. Discovery (understand problem)
2. Requirements (specify what)
3. Design (design flows)
4. UI Design (user interaction)
5. Data Model (storage)
6. Planning (delivery timeline)
7. Development (build)
8. Testing (validate)
9. Deployment (production)
10. Operations (run)
11. Monitoring (measure)
12. Feedback (learn)

### Why DDD + Hexagonal?

- **DDD**: Model around business language (bounded contexts, ubiquitous language)
- **Hexagonal**: Separate domain from infrastructure concerns

Together they guarantee:
- Documentation is technology-agnostic in early phases
- Code reflects business domain, not framework
- Decisions are traceable and justified

## 🤖 AI-Friendly

Built specifically for collaboration with AI:
- Clear templates with examples
- Structured prompts (context → task → template → requirements)
- Validation checklists after each generation
- Cross-phase coherence checks

Works with:
- Claude (recommended)
- ChatGPT
- Any LLM with prompt capability

## ⚡ Claude Code Skills Integration

Validate your work with Claude Code skills:

| Phase | Skill | Command |
|-------|-------|---------|
| Design | domain-driven-design | `/domain-driven-design` |
| Code | clean-code | `/code-craftsmanship:clean-code` |
| Security | security-review | `/security-review` |
| Tests | vitest | `/dev-tools:vitest` |
| Deploy | git-workflow | `/dev-tools:git-workflow` |
| Production | project-health | `/dev-tools:project-health` |

## 📊 Results

After 10-15 days:
- ~30,000 words of documentation
- 12 interconnected phases
- Clear traceability from requirement to metric
- Living documentation framework
- Ready for architecture, development, and operations

## 📝 Example Use Case

**Keygo** (real product: session and permission management)
- Day 1: Prepare product information
- Day 2-3: Discovery (3 documents)
- Day 4-5: Requirements (5+ documents)
- Day 6-7: Design (3 documents)
- Day 8: Data Model (2 documents)
- Day 9: Planning (2 documents)
- Day 10+: Development & post-production (6+ documents)

See `EXAMPLE-IMPLEMENTATION.md` for complete walkthrough.

## 🏗️ Structure

```
ddd-hexagonal-ai-template/
├── 00-guides-and-instructions/    # Guides and instructions
│   ├── AI-WORKFLOW-GUIDE.md
│   ├── EXAMPLE-IMPLEMENTATION.md
│   ├── SKILLS-AND-PLUGINS-GUIDE.md
│   ├── INSTRUCTIONS-FOR-AI.md
│   ├── TEMPLATE-USAGE-GUIDE.md
│   ├── TEMPLATE-ARCHITECTURE.md
│   ├── FAQ.md
│   └── README.md
│
└── 01-templates/
    ├── 00-documentation-planning/ # Framework + Conventions
    ├── 01-discovery/              # What problem do we solve?
    ├── 02-requirements/           # What must the system do?
    ├── 03-design/                 # How does it flow?
    ├── 04-data-model/             # How is data stored?
    ├── 05-planning/               # When & how do we deliver?
    ├── 06-development/            # How do we build it?
    ├── 07-testing/                # How do we validate?
    ├── 08-deployment/             # How do we go to production?
    ├── 09-operations/             # How do we operate?
    ├── 10-monitoring/             # How do we measure?
    └── 11-feedback/               # What do we learn?
```

## 🚀 Getting Started

1. **Copy** the template to your project
2. **Read** `00-guides-and-instructions/README.md`
3. **Choose**:
   - With AI: Follow `AI-WORKFLOW-GUIDE.md` (10-15 days)
   - Without AI: Follow `TEMPLATE-USAGE-GUIDE.md` (3-4 weeks)
4. **Generate** phase by phase
5. **Validate** using Claude Code skills

## 📚 Learn More

- **DDD Patterns**: See `domain-driven-design` skill
- **Clean Code**: See `code-craftsmanship:clean-code` skill
- **Architecture**: See `TEMPLATE-ARCHITECTURE.md`
- **FAQ**: See `FAQ.md`

## 🤝 Who This Is For

- Teams starting a new product
- Teams with scattered documentation
- Teams wanting AI-assisted documentation
- Teams practicing Domain-Driven Design
- Teams learning Hexagonal Architecture

## 📄 License

MIT

## 🙏 Based On

- Eric Evans' Domain-Driven Design patterns
- Alistair Cockburn's Hexagonal Architecture
- SDLC best practices
- Claude Code framework

---

**Ready to document your product?**

→ Start with `START-HERE.txt` or `00-guides-and-instructions/README.md`

---