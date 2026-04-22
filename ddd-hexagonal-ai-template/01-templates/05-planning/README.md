# Phase 5: Planning

## Overview

This phase creates the implementation roadmap, breaking the project into manageable epics, sprints, and user stories. It's where "big picture" becomes "sprint-ready work".

## Key Objectives

- [ ] Create product roadmap with milestones
- [ ] Break requirements into epics and user stories
- [ ] Estimate complexity and story points
- [ ] Plan sprints and iterations
- [ ] Define versioning strategy

## Files to Complete

### 1. **roadmap.md** `[COMPLETABLE BY HUMAN & AI]`
**Purpose**: High-level timeline of features and milestones

**Format**:
```
## Roadmap: Project Name

### Phase 1 / MVP (Target: Q2 2024)
**Goal**: Launch core features to early users

**Features**:
- [ ] User authentication and profiles
- [ ] Create/read/update tasks
- [ ] Task assignment and status tracking
- [ ] Email notifications
- [ ] Basic dashboard

**Milestones**:
- Week 4: Alpha release to internal team
- Week 6: Beta release to select users
- Week 8: Public launch

### Phase 2 (Target: Q3 2024)
**Goal**: Enhanced collaboration

**Features**:
- [ ] Advanced search and filtering
- [ ] Task dependencies
- [ ] Comments and mentions
- [ ] Mobile app (iOS/Android)

### Phase 3 (Target: Q4 2024)
**Goal**: Enterprise features

**Features**:
- [ ] Role-based access control
- [ ] Advanced reporting
- [ ] API and integrations
- [ ] White-label support
```

**Time to complete**: 2-3 hours

### 2. **epics.md** `[COMPLETABLE BY HUMAN & AI]`
**Purpose**: Break features into epics with user stories

**Format per epic**:
```
## Epic: Feature Name

**Description**: What is this epic about?

**Business Value**: Why does it matter?

**User Stories** (with acceptance criteria):
1. As a [user type], I can [action] so that [benefit]
   - [ ] Acceptance criterion 1
   - [ ] Acceptance criterion 2

2. As a [user type], I can [action] so that [benefit]
   - [ ] Acceptance criterion 1

**Acceptance Criteria** (for whole epic):
- [ ] All stories completed
- [ ] Code reviewed and merged
- [ ] Automated tests passing
- [ ] Documentation updated

**Estimated Size**: [story points]

**Priority**: P0 (Critical), P1 (High), P2 (Medium)

**Timeline**: Which sprint(s)?

**Risks/Blockers**: Known issues?

**Dependencies**: Other epics or requirements?
```

**Time to complete**: 3-4 hours

### 3. **versioning-strategy.md** `[COMPLETABLE BY HUMAN]`
**Purpose**: Define how versions are numbered and released

**Topics to cover**:
- Semantic versioning (major.minor.patch)?
- Release schedule (monthly, quarterly)?
- Beta/RC process?
- Breaking changes policy?
- Long-term support (LTS) versions?

**Example**:
```
## Versioning Strategy

**Format**: MAJOR.MINOR.PATCH

**Meaning**:
- MAJOR: Breaking changes, significant new features
- MINOR: New features, backwards compatible
- PATCH: Bug fixes, security updates

**Schedule**:
- Major release: Every 6 months (Feb, Aug)
- Minor releases: Monthly or as needed
- Patch releases: Weekly (security + critical bugs)

**Release Process**:
1. Beta: 2-week testing period
2. RC: 1-week release candidate
3. General Availability (GA)

**Support Policy**:
- Latest version: Full support
- Previous version: 3 months bug fixes only
- Older: Critical security patches only
```

**Time to complete**: 1-2 hours

---

## Completion Checklist

### Planning Phase Deliverables
- [ ] Product roadmap created with timelines
- [ ] Features broken into epics
- [ ] Epics broken into user stories
- [ ] Stories have acceptance criteria
- [ ] Estimates provided (story points)
- [ ] Sprints planned
- [ ] Versioning strategy defined
- [ ] Team committed to roadmap

### Sign-Off
- [ ] **Prepared by**: [Product Manager]
- [ ] **Reviewed by**: [Engineering Lead, Stakeholders]
- [ ] **Approved by**: [Product Lead, Executive Sponsor]

---

## AI Assistance

### What AI Can Do Well
- Break requirements into user stories
- Generate acceptance criteria for stories
- Suggest epic groupings
- Estimate complexity (T-shirt sizes)
- Create roadmap timeline outlines

### What Needs Human Input
- Business priorities and go/no-go decisions
- Resource availability and constraints
- Actual timeline and deadlines
- Risk assessments
- Team velocity (for estimation)

---

## Tips

1. **User story format**: "As a [user], I [action] so that [benefit]"
2. **Keep stories small**: Aim for 1-3 day stories
3. **Acceptance criteria are tests**: Developers should use them to verify completion
4. **Plan for the unknown**: Reserve capacity for bugs, tech debt, support
5. **Review and adjust**: Roadmaps change; update regularly

---

## Example User Story

```
## Story: Create Task

As a team member, I can create a new task 
so that I can document work that needs to be done.

**Acceptance Criteria**:
- [ ] Form has required fields: title, description, assignee, priority
- [ ] Title is required and must be 3+ characters
- [ ] Description is optional, max 2000 characters
- [ ] Can assign to any team member in the project
- [ ] Task saved to database with creator, timestamps
- [ ] Success notification shown
- [ ] New task appears in project's task list
- [ ] Assigned user receives email notification

**Estimate**: 5 points (medium story)
**Sprint**: Sprint 1
```

---

## Next Steps

Once Planning is complete:
1. Share roadmap with team and stakeholders
2. Begin implementation (Phase 6)
3. Run first sprint planning meeting
4. **Move to Phase 6: Development**

---

**Files**:
- `roadmap.md` — Product roadmap with phases/timelines
- `epics.md` — Epics broken into user stories
- `versioning-strategy.md` — Versioning and release process

**Time Estimate**: 6-8 hours total  
**Team**: Product Manager, Engineering Lead, Stakeholders  
**Output**: Sprint-ready backlog with estimates

**Definition of Done**:
- Roadmap created and shared
- Epics defined with user stories
- Stories have acceptance criteria
- Team has estimated stories
- First sprint(s) planned
