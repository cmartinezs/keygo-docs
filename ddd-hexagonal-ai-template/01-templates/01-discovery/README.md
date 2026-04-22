# Phase 1: Discovery

## Overview

Discovery is about understanding the **WHAT** and **WHY** — the business context, problems, actors, and needs that drive the project. No implementation details yet.

## Key Principle: Focus on "WHAT", NOT "HOW"

✅ **INCLUDE**: Business needs, constraints, actors, workflows, problems  
❌ **EXCLUDE**: Technology names, frameworks, implementation patterns, protocols

## Key Objectives

- [ ] Understand project context and motivation
- [ ] Identify key actors and their goals
- [ ] Define scope and boundaries
- [ ] Document assumptions and constraints
- [ ] Get stakeholder alignment

## Files to Complete

### 1. **TEMPLATE-context-motivation.md** `[COMPLETABLE BY HUMAN & AI]`
**Purpose**: Establish shared understanding of why the project exists

**Sections**:
- Vision: 1-2 sentence vision statement
- Mission: Purpose of the project
- Problem Statement: What problem are we solving?
- Success Criteria: How will we know it's successful?
- Timeline: Expected timeline and phases
- Constraints: Legal, compliance, business constraints

**Example** (auto-generated, human-refined):
```
## Vision
Enable distributed teams to collaborate on work in one unified platform.

## Problem
Teams juggle tasks across email, Slack, and spreadsheets, losing context and accountability.

## Success
Teams adopt our platform as their single source of truth for project management.

## Constraints
- Must be GDPR compliant (users are EU-based)
- Must integrate with Slack (team communication hub)
- Launch by Q3 2024 (business requirement)
```

**Time to complete**: 1-2 hours

### 2. **actors-and-personas.md** `[COMPLETABLE BY AI with human validation]`
**Purpose**: Identify who will use the system and their needs

**Sections per actor**:
- Who: Role and description
- Goals: What do they want to achieve?
- Pain points: Current frustrations
- Needs: What will make their life better?
- Technical savviness: How tech-comfortable?
- Volume: How many of this type?

**Example**:
```
## Actor: Project Manager

**Who**: Responsible for project timeline, resource allocation, and team coordination

**Goals**:
- Track all team work in one place
- Identify bottlenecks and risks early
- Keep team focused on priorities

**Pain Points**:
- Info scattered across email, Slack, spreadsheets
- No visibility into who's working on what
- Hard to update status and spot blocked work

**Needs**:
- Single source of truth for project work
- Easy status reporting
- Visibility into team capacity and blockers
```

**Time to complete**: 2-3 hours

### 3. **scope-and-boundaries.md** `[COMPLETABLE BY HUMAN]`
**Purpose**: Define what's in scope, what's out, and rationale

**Sections**:
- In Scope: What will the system do? (MVP)
- Out of Scope: What it won't do (with rationale)
- Assumptions: What we assume to be true
- Dependencies: External systems or constraints
- Phase 1 vs Later: Timeline for features

**Example**:
```
## In Scope (Phase 1 / MVP)
- User registration and authentication
- Create/read/update tasks
- Assign tasks to team members
- Track task status (To-Do → In Progress → Done)
- Basic email notifications

## Out of Scope (Future Phases)
- Mobile native apps (web only, v1)
- Advanced reporting and analytics
- Integration with external tools
- Role-based permissions (all users are equal in MVP)

## Assumptions
- Users have email and can receive notifications
- Teams have 3-20 members (not enterprises yet)
- Users have modern browsers (Chrome, Firefox, Safari)

## Dependencies
- Email service provider (for notifications)
- Cloud hosting provider (AWS, GCP, etc.)
- (No external integrations in MVP)
```

**Time to complete**: 1-2 hours

---

## Completion Checklist

### Discovery Phase Deliverables
- [ ] Vision and mission statement documented
- [ ] Key actors identified and personas created
- [ ] Scope and boundaries clearly defined
- [ ] Assumptions explicitly listed
- [ ] Constraints documented
- [ ] Stakeholder consensus achieved

### Sign-Off
- [ ] **Prepared by**: [Name, Date]
- [ ] **Reviewed by**: [Stakeholders, Date]
- [ ] **Approved by**: [Product Manager, Date]

---

## Phase Discipline Rules

**Before moving to Requirements, verify**:
1. ✅ No technology mentions (JWT, OAuth, PostgreSQL, React, etc.)
2. ✅ No implementation patterns (REST, microservices, MVC, etc.)
3. ✅ No protocol names (HTTP, gRPC, MQTT, etc.)
4. ✅ All actors and their needs documented
5. ✅ Scope is clear (in/out/assumptions)

---

## AI Assistance

### What AI Can Do Well
- Brainstorm additional actors and use cases
- Draft persona templates
- Suggest scope boundaries based on requirements
- Research similar products for inspiration

### What Needs Human Input
- Real business context and constraints
- Strategic decisions (go/no-go)
- Competitive positioning
- Timeline and resource reality

### Suggested Workflow
```
1. Human: Describe the project in 1-2 paragraphs
2. AI: Generate actor list and suggested personas
3. Human: Review and refine with actual context
4. AI: Suggest scope boundaries and assumptions
5. Human: Finalize scope and get stakeholder buy-in
```

---

## Tips

1. **Start with WHY**: Before features, understand the business need
2. **Interview stakeholders**: Don't guess actor goals, ask them
3. **Document assumptions**: Anything you're assuming, write it down
4. **Get buy-in**: Stakeholder sign-off prevents rework later
5. **Keep it concise**: 1-2 pages per actor, focus on what matters

---

## Next Steps

Once Discovery is complete and signed off:
1. Share context with full team
2. Use findings to drive Requirements phase
3. **Move to Phase 2: Requirements**

---

**Files**:
- `TEMPLATE-context-motivation.md` — Vision, problem, success criteria
- `actors-and-personas.md` — Actors and their needs
- `scope-and-boundaries.md` — In scope, out of scope, assumptions

**Time Estimate**: 4-6 hours total  
**Team**: Product Manager, Business Stakeholders, 1-2 Engineers  
**Output**: Shared understanding of project context and goals

**Definition of Done**: All actors understood, scope agreed, stakeholders aligned
