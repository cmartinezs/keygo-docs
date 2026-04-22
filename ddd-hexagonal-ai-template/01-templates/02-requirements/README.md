# Phase 2: Requirements

## Overview

Requirements translate business needs from Discovery into specific, measurable capabilities the system must provide. Still focuses on "WHAT", not "HOW".

## Key Principle: WHAT the System Must Do

✅ **INCLUDE**: Functional requirements, user stories, acceptance criteria, non-functional targets  
❌ **EXCLUDE**: Technology choices, implementation approaches, code patterns

## Key Objectives

- [ ] Define all functional requirements with acceptance criteria
- [ ] Document non-functional requirements (performance, security, scalability)
- [ ] Create requirements traceability (link to discovery)
- [ ] Get stakeholder validation
- [ ] Establish requirements prioritization

## Files to Complete

### 1. **functional-requirements.md** `[COMPLETABLE BY AI with human validation]`
**Purpose**: Define what the system must do from user perspective

**Format for each requirement**:
```
## [FR-XXX] Requirement Title

**Description**: What the system must do

**Actor**: Who performs this?
**Trigger**: When does it happen?
**Preconditions**: What must be true before?

**Main Flow**:
1. User does X
2. System responds with Y
3. Outcome: Z

**Exception Flows**:
- If [condition]: [alternative flow]

**Acceptance Criteria**:
- [ ] Specific, testable criterion 1
- [ ] Specific, testable criterion 2
- [ ] Specific, testable criterion 3

**Assumptions**: What are we assuming?
**Dependencies**: Other requirements this depends on?
**Priority**: Must/Should/Could/Won't (MoSCoW)
```

**Time to complete**: 4-6 hours (multiple requirements)

### 2. **non-functional-requirements.md** `[COMPLETABLE BY HUMAN & AI]`
**Purpose**: Define system characteristics (performance, security, scalability, etc.)

**Format per NFR**:
```
## [NFR-XXX] Category: Requirement Name

**Category**: Performance, Security, Scalability, Usability, Maintainability

**Requirement**: Specific, measurable target
- Example: "API endpoints must respond in < 200ms for 95th percentile"

**Rationale**: Why does this matter?

**Measurement**: How will we verify it?
- Example: "Load test with expected traffic volume"

**Target SLA**: Acceptable baseline
```

**Example NFRs to cover**:
- Performance: Response times, throughput
- Security: Authentication, authorization, data protection
- Scalability: Max users, concurrent requests, data volume
- Availability: Uptime targets, disaster recovery
- Usability: Accessibility, browser support
- Maintainability: Code quality, test coverage

**Time to complete**: 2-3 hours

### 3. **scope-boundaries.md** `[COMPLETABLE BY HUMAN]`
**Purpose**: Create a matrix showing what's in/out of scope by phase

**Format**: Table linking requirements to phases
```
| Requirement | Phase 1 | Phase 2 | Phase 3 | Notes |
|-------------|---------|---------|---------|-------|
| FR-001: Create task | In | | | MVP feature |
| FR-002: Search tasks | | In | | Later enhancement |
| FR-003: Integrations | | | In | Future phase |
| NFR-001: <500ms latency | In | | | Always |
```

**Time to complete**: 1-2 hours

### 4. **traceability-matrix.md** `[COMPLETABLE BY AI]`
**Purpose**: Link requirements back to discovery actors and needs

**Format**: Requirement → Actor → Business Need
```
| FR-ID | Title | Actor | Discovery Need | Priority |
|-------|-------|-------|---|----------|
| FR-001 | Create task | PM, Developer | Organize work | Must |
| FR-002 | Assign task | PM | Allocate work | Must |
| FR-003 | Search | All | Find work | Should |
```

**Time to complete**: 1 hour (AI can generate initial version)

---

## Completion Checklist

### Requirements Phase Deliverables
- [ ] All functional requirements documented with acceptance criteria
- [ ] Non-functional requirements defined with targets
- [ ] Scope boundaries clear (in/out of Phase 1, 2, 3+)
- [ ] Traceability to discovery documented
- [ ] Requirements prioritized (MoSCoW)
- [ ] Stakeholder validation completed

### Sign-Off
- [ ] **Prepared by**: [Name, Date]
- [ ] **Reviewed by**: [Stakeholders, Date]
- [ ] **Approved by**: [Product Manager, Date]

---

## Phase Discipline Rules

**Before moving to Design, verify**:
1. ✅ No technology names (REST, GraphQL, JWT, OAuth, PostgreSQL, etc.)
2. ✅ No frameworks or libraries mentioned (Spring, React, Django, etc.)
3. ✅ No implementation patterns (repository pattern, singleton, etc.)
4. ✅ All requirements link back to discovery
5. ✅ Acceptance criteria are testable (not "user is happy")

---

## AI Assistance

### What AI Can Do Well
- Expand feature descriptions into full requirements
- Generate acceptance criteria from descriptions
- Create user stories and flows
- Suggest similar projects' requirements for inspiration
- Generate requirement matrices and traceability

### What Needs Human Input
- Actual business rules and workflows
- Legal/compliance requirements
- Performance targets (based on business need)
- Security and privacy requirements
- Prioritization (only product owners decide)

### Suggested Workflow
```
1. Human: Describe a feature briefly
   "Users need to upload documents"
2. AI: Generate full requirement with flows, criteria
3. Human: Review and adjust business logic
4. AI: Generate related NFRs (file size, format, storage)
5. Human: Validate and prioritize
6. Repeat for all features
```

---

## Examples

### Example: Functional Requirement
```
## [FR-005] Export Task Report

**Description**: Users can export tasks to CSV or PDF format

**Actor**: Project Manager
**Trigger**: User clicks "Export" button
**Preconditions**: User is viewing task list, has read access

**Main Flow**:
1. User opens project task list
2. User optionally filters tasks (by status, assignee, etc.)
3. User clicks "Export" dropdown
4. User selects format: CSV or PDF
5. System generates report
6. File downloads to user's computer

**Acceptance Criteria**:
- [ ] CSV export includes: task ID, title, status, assignee, priority, dates
- [ ] PDF export includes: title, task summary, status indicator, dates
- [ ] File names: `tasks_export_YYYY-MM-DD.csv` or `.pdf`
- [ ] CSV properly escaped (commas, quotes, newlines)
- [ ] PDF includes company branding (header/footer)
- [ ] Works with 10,000+ tasks in list
- [ ] Export completes in < 5 seconds

**Assumptions**:
- User has permission to view all included tasks
- System doesn't need to send via email (just download)

**Dependencies**:
- FR-001 (task creation)
- NFR-002 (scalability to 10K tasks)
```

### Example: Non-Functional Requirement
```
## [NFR-003] Performance: API Response Time

**Category**: Performance

**Requirement**: All API endpoints must respond in < 200ms for the 95th percentile

**Rationale**: 
- Users expect responsive UI (< 200ms feels instant)
- Slow APIs degrade user experience
- Performance affects adoption rates

**Measurement**: 
- Production monitoring tracks all endpoint latencies
- Weekly reports on p95, p99 response times
- Load test simulates 1000 concurrent users

**Target SLA**: 
- 95th percentile: < 200ms
- 99th percentile: < 500ms
- Average: < 100ms

**Excludes**:
- First load (cold cache) — target 500ms
- Bulk operations — handled separately
```

---

## Tips

1. **Start with features, then expand**: Brief description → Full requirement
2. **Acceptance criteria are critical**: Make them testable and specific
3. **Link to discovery**: Every requirement should trace to a business need
4. **Prioritize ruthlessly**: MoSCoW forces trade-offs
5. **Get validation early**: Don't wait until design to find out requirements were wrong
6. **Be specific**: "Users can search" is vague; "Users can search by title/assignee/status/date" is clear

---

## Common Mistakes to Avoid

- ❌ "Users should be able to..." (not specific enough)
- ❌ "System should be fast" (no target specified)
- ❌ "Use JWT for auth" (implementation detail, wrong phase)
- ❌ Acceptance criteria: "User is happy" (not testable)
- ❌ Vague dates: "asap", "soon" (use actual dates)

---

## Next Steps

Once Requirements are complete and signed off:
1. Share requirements with design team
2. Use for design validation (can we design this?)
3. Use for development planning (can we build this in sprint?)
4. **Move to Phase 3: Design**

---

**Files**:
- `functional-requirements.md` — Feature requirements with acceptance criteria
- `non-functional-requirements.md` — Performance, security, scalability targets
- `scope-boundaries.md` — Phase-by-phase feature matrix
- `traceability-matrix.md` — Link requirements to discovery needs

**Time Estimate**: 8-10 hours total (depends on feature complexity)  
**Team**: Product Manager, Stakeholders, 1-2 Engineers (for feasibility check)  
**Output**: Complete, validated requirements ready for design

**Definition of Done**: 
- All requirements have acceptance criteria
- Requirements traced to discovery
- Prioritization complete
- Stakeholders have signed off
