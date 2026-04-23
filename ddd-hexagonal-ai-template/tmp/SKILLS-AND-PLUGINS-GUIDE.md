# Skills & Plugins: Complete Guide for DDD + Hexagonal

How to use Claude Code skills and plugins to accelerate each phase of documentation and development.

---

## Table of Contents

- [General: All Useful Skills](#general-all-useful-skills)
- [By Phase](#by-phase)
  - [Discovery & Requirements](#discovery--requirements)
  - [Design](#design)
  - [Development](#development)
  - [Testing](#testing)
  - [Deployment & CI/CD](#deployment--cicd)
  - [Operations](#operations)
  - [Monitoring](#monitoring)
  - [Feedback & Learning](#feedback--learning)
- [How to Install/Activate](#how-to-installactivate)
- [Usage Recommendations](#usage-recommendations)

---

## General: All Useful Skills

### 🎯 Core Skills (Use in ALL phases)

#### 1. **domain-driven-design**
- **What it does**: Guides software modeling around the business domain
- **When to use it**: Before designing anything
- **For DDD Template**: CRITICAL — ensures your model reflects the real business
- **How to use**:
  ```
  /domain-driven-design
  
  [Describe your model/aggregate/context here]
  ```
- **Auto-triggers**: When you mention "bounded context", "ubiquitous language", "aggregate", "context mapping"

**Key**: Verify that your design strategy fully aligns with this guide before moving to code.

---

#### 2. **code-craftsmanship:clean-code**
- **What it does**: Code review for readability, maintainability, efficiency
- **When to use it**: After writing code (testing, development)
- **For DDD Template**: Ensures code reflects the domain (names, structure)
- **How to use**:
  ```
  /code-craftsmanship:clean-code
  
  [Paste your code for review]
  ```

---

#### 3. **code-craftsmanship:software-design-philosophy**
- **What it does**: Design principles (SOLID, complexity management)
- **When to use it**: Architecture planning, design decisions
- **For DDD Template**: Complements DDD with architectural principles

---

#### 4. **functional-requirements**
- **What it does**: Writing and reviewing functional requirements
- **When to use it**: Phase 2 (Requirements)
- **For DDD Template**: Ensures correct FRs (no technology, clear, verifiable)

---

#### 5. **security-review**
- **What it does**: Security audit in code and design
- **When to use it**: After design and before implementing
- **For DDD Template**: Identifies security risks in your model

---

### 🛠️ Dev Tools (General use)

#### **dev-tools:project-docs**
- **What it does**: Generates complete project documentation
- **When to use it**: To complement template documentation
- **How to use**:
  ```
  /dev-tools:project-docs
  
  [Describe your project, structure, how to start]
  ```

---

#### **dev-tools:project-health**
- **What it does**: Configuration and project health audit
- **When to use it**: At the end to validate everything is in order
- **How to use**:
  ```
  /dev-tools:project-health
  
  [Describe your setup: CI/CD, testing, docs, etc.]
  ```

---

#### **dev-tools:deep-research**
- **What it does**: Deep research on a topic
- **When to use it**: To validate design or architecture decisions
- **How to use**:
  ```
  /dev-tools:deep-research
  
  Should I use Event Sourcing for my audit trail?
  ```

---

#### **dev-tools:brains-trust**
- **What it does**: Second opinion from experts
- **When to use it**: To validate complex architecture decisions
- **How to use**:
  ```
  /dev-tools:brains-trust
  
  Is my strategic design correct with these 3 bounded contexts?
  ```

---

---

## By Phase

### Discovery & Requirements

#### **01-templates/01-discovery/ & 01-templates/02-requirements/**

| Skill | Usage | Command | Result |
|-------|-------|---------|--------|
| **functional-requirements** | Review written FRs | `/functional-requirements` + [FR text] | Clarity, verifiability, agnostic validation |
| **dev-tools:deep-research** | Validate assumptions | `/dev-tools:deep-research` | Market, competition research |
| **domain-driven-design** | Identify ubiquitous language | `/domain-driven-design` + [glossary] | Term validation, concept clarity |

**Typical workflow**:
```
1. Generate Discovery/Requirements with AI (see AI-WORKFLOW-GUIDE.md)
2. Then, pass documents to /functional-requirements
3. If you have doubts about a requirement, use /dev-tools:deep-research
4. For glossary: /domain-driven-design (validate ubiquitous language)
```

---

### Design

#### **01-templates/03-design/ (Strategic Design + Bounded Contexts)**

| Skill | Usage | Command | Result |
|-------|-------|---------|--------|
| **domain-driven-design** ⭐ | CRITICAL: Validate bounded contexts | `/domain-driven-design` + [strategic-design.md] | Score 0-10 for domain model |
| **code-craftsmanship:software-design-philosophy** | Validate architectural decisions | `/code-craftsmanship:software-design-philosophy` | Principles analysis (SOLID, etc.) |
| **dev-tools:brains-trust** | Second opinion on contexts | `/dev-tools:brains-trust` | Boundary and context mapping validation |

**Typical workflow**:
```
1. Generate Strategic Design + Bounded Contexts with AI
2. Pass to /domain-driven-design for DDD validation
   → Wait for score, improve until 10/10
3. Pass to /code-craftsmanship:software-design-philosophy
   → Validate that architecture follows principles
4. If contexts are complex: /dev-tools:brains-trust
```

**Example**: 
```
/domain-driven-design

# My Domain Model

Bounded Contexts:
1. Identity: authentication, sessions
2. Authorization: roles, permissions
3. Audit: access logs

Ubiquitous Language (Identity):
- Session: authenticated user state
- Token: temporary credential
- User: unique identity

[Complete strategic design]

→ Claude reviews and gives DDD score
```

---

### Development

#### **01-templates/06-development/ (Architecture + API + Coding Standards)**

| Skill | Usage | Command | Result |
|-------|-------|---------|--------|
| **domain-driven-design** | Validate that architecture reflects domain | `/domain-driven-design` | Aggregate → module mapping, names in code |
| **code-craftsmanship:clean-code** ⭐ | Review written code | `/code-craftsmanship:clean-code` | Feedback on readability, naming, structure |
| **code-craftsmanship:refactoring-patterns** | Improve existing code | `/code-craftsmanship:refactoring-patterns` | Refactor suggestions (Extract Method, etc.) |
| **dev-tools:fork-discipline** | If you have a monolithic repo | `/dev-tools:fork-discipline` | Core/client separation audit |
| **security-review** | Review security in APIs | `/security-review` + [architecture.md + api-reference.md] | Identify vulnerabilities, security improvements |

**Typical workflow**:
```
1. Generate architecture.md, api-reference.md, coding-standards.md with AI
2. For each important module/component:
   a) /domain-driven-design → Validate that names reflect domain
   b) /code-craftsmanship:clean-code → Review code
   c) /code-craftsmanship:refactoring-patterns → If there is technical debt
3. /security-review → Security audit
4. If monolithic: /dev-tools:fork-discipline → Detect boundary violations
```

**Example**:
```
/code-craftsmanship:clean-code

# My Hexagonal Architecture

Here is my Identity Context code:

[Paste identityController.go, userRepository.go, etc.]

→ Claude reviews and gives feedback on:
  - Names (do they reflect domain?)
  - Readability
  - DDD violations (anemic model, etc.)
```

---

#### **Frontend (if applicable)**

| Skill | Usage | Command | Result |
|-------|-------|---------|--------|
| **frontend:react-patterns** | Review React components | `/frontend:react-patterns` | Performance patterns, structure |
| **frontend:shadcn-ui** | Install/use shadcn components | `/frontend:shadcn-ui` | Initial setup + patterns |
| **frontend:tailwind-theme-builder** | Tailwind v4 setup | `/frontend:tailwind-theme-builder` | Configured theme, design system |
| **dev-tools:responsiveness-check** | Test responsive design | `/dev-tools:responsiveness-check` | Validate on desktop/tablet/mobile |
| **dev-tools:ux-audit** | Complete UX audit | `/dev-tools:ux-audit` | Flow review, usability |

---

### Testing

#### **01-templates/07-testing/ (Test Strategy + Test Plans)**

| Skill | Usage | Command | Result |
|-------|-------|---------|--------|
| **dev-tools:vitest** | Setup testing framework | `/dev-tools:vitest` | Vitest + composables setup |
| **code-craftsmanship:clean-code** | Review written tests | `/code-craftsmanship:clean-code` | Tests must be readable |
| **security-review** | Security tests | `/security-review` | Security tests checklist |

**Typical workflow**:
```
1. Generate test-strategy.md with AI
2. For specific tests:
   a) /dev-tools:vitest → Correct setup
   b) /code-craftsmanship:clean-code → Tests are readable
3. /security-review → Security coverage
```

---

### Deployment & CI/CD

#### **01-templates/08-deployment/ (CI/CD + Environments + Release Process)**

| Skill | Usage | Command | Result |
|-------|-------|---------|--------|
| **dev-tools:git-workflow** | Git processes, PR workflow | `/dev-tools:git-workflow` | Branching guide, PR standards |
| **dev-tools:release** | Release process, versioning | `/dev-tools:release` | Release plan, changelog, tagging |
| **cloudflare:wrangler** | If you use Cloudflare Workers | `/cloudflare:wrangler` | Wrangler CLI setup |
| **cloudflare:cloudflare** | Deploy on Cloudflare | `/cloudflare:cloudflare` | Complete infrastructure setup |

**Typical workflow**:
```
1. Generate CI/CD pipeline config with AI
2. /dev-tools:git-workflow → Validate branching/PR process
3. /dev-tools:release → Release planning
4. If you use Cloudflare: /cloudflare:cloudflare → Infra setup
```

---

### Operations

#### **01-templates/09-operations/ (Runbooks + Incident Response + SLAs)**

| Skill | Usage | Command | Result |
|-------|-------|---------|--------|
| **dev-tools:project-health** | Validate health checks | `/dev-tools:project-health` | Project health audit |
| **security-review** | Operational security audit | `/security-review` | Ops security checklist |

**Typical workflow**:
```
1. Generate runbooks.md, incident-response.md with AI
2. /dev-tools:project-health → Validate health checks
3. /security-review → Security coverage in incidents
```

---

### Monitoring

#### **01-templates/10-monitoring/ (Metrics + Alerts + Dashboards)**

| Skill | Usage | Command | Result |
|-------|-------|---------|--------|
| **cloudflare:web-perf** | If you use Cloudflare | `/cloudflare:web-perf` | Performance analysis |

**Typical workflow**:
```
1. Generate metrics.md, alerts.md, dashboards.md with AI
2. If you use Cloudflare: /cloudflare:web-perf → Perf analysis
```

---

### Feedback & Learning

#### **01-templates/11-feedback/ (Retrospectives + User Feedback + Improvements)**

| Skill | Usage | Command | Result |
|-------|-------|---------|--------|
| **dev-tools:team-update** | Share updates with the team | `/dev-tools:team-update` | Update format for Slack/email |
| **dev-tools:deep-research** | Investigate feedback | `/dev-tools:deep-research` | Deep analysis of learnings |

**Typical workflow**:
```
1. Generate retrospectives.md, user-feedback.md with AI
2. /dev-tools:team-update → Format updates for team
3. /dev-tools:deep-research → Analyze feedback trends
```

---

---

## How to Install/Activate

### Option 1: Skills (Inside Claude Code)

**Skills are already active by default.** To use them:

```
In any conversation with Claude, type:

/domain-driven-design

or any other skill from the list.

Claude automatically activates the skill and applies its context.
```

**Available without installation**:
- All skills listed above are already in your Claude Code
- You just need to type `/skill-name`

---

### Option 2: MCP Servers (Cloudflare, Google Drive, etc.)

Some skills require MCP plugins (Model Context Protocol):

**Cloudflare**:
```
Requires OAuth authentication

1. In conversation, type: /cloudflare:cloudflare
2. Claude asks: "Authorize with Cloudflare"
3. Choose OAuth flow
4. Complete authentication in browser
5. Done — you can use Cloudflare skills
```

**Google Drive** (to share/save docs):
```
Claude Code system already has integration.

If you need:
- Upload documents: Use /mcp__claude_ai_Google_Drive__create_file
- Download: Use /mcp__claude_ai_Google_Drive__download_file_content
- Search: Use /mcp__claude_ai_Google_Drive__search_files
```

---

### Option 3: Configure Skills in `settings.json`

To use specific skills **by default** in certain folders:

```json
{
  "skills": {
    "domains": [
      {
        "path": "ddd-hexagonal-ai-template/01-templates/03-design/",
        "skills": ["domain-driven-design", "code-craftsmanship:software-design-philosophy"]
      },
      {
        "path": "ddd-hexagonal-ai-template/01-templates/06-development/",
        "skills": ["code-craftsmanship:clean-code", "domain-driven-design", "security-review"]
      },
      {
        "path": "ddd-hexagonal-ai-template/01-templates/07-testing/",
        "skills": ["dev-tools:vitest", "code-craftsmanship:clean-code"]
      }
    ]
  }
}
```

Thus, when you work in `01-templates/03-design/`, DDD skills activate automatically.

---

---

## Usage Recommendations

### 🎯 Minimal Setup (To get started)

If you have little time, prioritize these 3:

```
1. /domain-driven-design
   → Use it BEFORE any design
   → Validate model at each design phase
   
2. /code-craftsmanship:clean-code
   → Use it AFTER writing code
   → Review each important module/component
   
3. /security-review
   → Use it in DESIGN and DEVELOPMENT
   → Don't leave security for the end
```

---

### 📊 Full Stack Setup (To do it right)

If you have time, use:

```
Discovery & Requirements:
├─ /functional-requirements
├─ /dev-tools:deep-research
└─ /domain-driven-design (for glossary)

Design:
├─ /domain-driven-design ⭐⭐⭐
├─ /code-craftsmanship:software-design-philosophy
└─ /dev-tools:brains-trust

Development:
├─ /domain-driven-design (validate modules)
├─ /code-craftsmanship:clean-code ⭐⭐
├─ /code-craftsmanship:refactoring-patterns
├─ /security-review ⭐⭐
└─ /dev-tools:fork-discipline (if monolithic)

Testing:
├─ /dev-tools:vitest
├─ /code-craftsmanship:clean-code
└─ /security-review

Deployment:
├─ /dev-tools:git-workflow
├─ /dev-tools:release
└─ /cloudflare:cloudflare (if applicable)

Operations & Monitoring:
├─ /dev-tools:project-health
├─ /security-review
└─ /cloudflare:web-perf (if applicable)

Feedback:
├─ /dev-tools:team-update
└─ /dev-tools:deep-research
```

---

### 🔄 Recommended Daily Workflow

**AI doc generation day**:
```
1. AI generates document
2. You validate manually
3. Pass to corresponding skill:
   - Design → /domain-driven-design
   - Code → /code-craftsmanship:clean-code
   - Security → /security-review
4. Adjust according to skill feedback
5. Commit
```

**Code writing day**:
```
1. Write module/component
2. /code-craftsmanship:clean-code → validate
3. /domain-driven-design (if domain logic) → validate names
4. /security-review (if auth/sensitive data) → validate
5. Tests
6. Commit
```

---

### ⚠️ Anti-Patterns (WHAT NOT TO DO)

```
❌ Generate ALL documentation without validating with skills
✅ Generate phase, validate with corresponding skill, adjust, next phase

❌ Use /domain-driven-design for infrastructure logic
✅ Use it for: contexts, aggregates, entities, value objects, events

❌ Ignore /security-review until "later"
✅ Review security in DESIGN (decisions) and DEVELOPMENT (implementation)

❌ Assume /code-craftsmanship:clean-code fixes everything
✅ Use it for readability/structure, not business logic (use /domain-driven-design)
```

---

### 📋 Checklist: Before Production

Before shipping, run these skills:

```
[ ] /domain-driven-design
    → Load architecture.md + bounded contexts
    → Score must be 8+/10

[ ] /code-craftsmanship:clean-code
    → Pass most critical code (Domain logic, APIs)
    → Review naming, structure

[ ] /security-review
    → Pass architecture.md + api-reference.md + auth code
    → Identify and mitigate risks

[ ] /dev-tools:project-health
    → Validate: CI/CD, tests, docs, security
    → Everything must be green

[ ] /cloudflare:web-perf (if applicable)
    → Performance OK for production
```

---

## Quick Summary

| Phase | Primary Skill | Command | When |
|------|---|---|---|
| **Discovery/Req** | functional-requirements | `/functional-requirements` | After generating FRs |
| **Design** | domain-driven-design | `/domain-driven-design` | After strategic design |
| **Code (Backend)** | clean-code + DDD | `/code-craftsmanship:clean-code` | After writing module |
| **Security** | security-review | `/security-review` | Design + Development |
| **Testing** | vitest | `/dev-tools:vitest` | Testing setup |
| **Deploy** | git-workflow | `/dev-tools:git-workflow` | Release planning |
| **Prod** | project-health | `/dev-tools:project-health` | Before shipping |

---

[← HOME](../README.md)
