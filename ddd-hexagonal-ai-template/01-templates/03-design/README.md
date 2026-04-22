# Phase 3: Design

## Overview

Design transforms requirements into specific system flows, user interactions, and architectural decisions. This is where "what" meets "how".

## Key Objectives

- [ ] Define system flows (happy path + exceptions)
- [ ] Create UI/UX designs (wireframes, mockups)
- [ ] Document key design decisions
- [ ] Validate design meets requirements
- [ ] Get design team sign-off

## Files to Complete

### 1. **system-flows.md** `[COMPLETABLE BY AI with human validation]`
**Purpose**: Document how the system behaves for major workflows

**Format per flow**:
```
## [SF-001] User Workflow Name

### Actors Involved
- User, System, External Service (if any)

### Happy Path
1. User action...
2. System response...
3. Outcome...

### Exception Flows
- If [condition]: [alternative path]
- If [other]: [other alternative]

### Decision Points
- Where can the flow branch?
- What conditions cause branches?

### Data Flow
- What data moves where?
```

**Scope**: Cover all major user workflows that appeared in requirements

**Time to complete**: 3-4 hours

### 2. **ui-ux-design.md** `[COMPLETABLE BY HUMAN with AI assistance]`
**Purpose**: Describe UI layout, interaction patterns, accessibility

**Note**: Link to actual mockups (Figma, XD, etc.), don't duplicate them here

**Sections per screen/component**:
```
## [UI-001] Screen/Component Name

**Purpose**: What does this screen/component do?

**Layout**:
- Header: Elements and purpose
- Main area: Content sections
- Footer: Navigation, actions
- Sidebars: Any supporting areas

**Key Elements**:
- Forms: Fields, validation, error states
- Buttons: Primary actions, secondary actions
- Lists: How data is displayed

**Interactions**:
- What happens when user clicks/types?
- Validation and error messages
- Loading states
- Empty states

**Responsive Design**:
- Mobile layout (< 600px)
- Tablet layout (600-1024px)
- Desktop layout (> 1024px)

**Accessibility**:
- WCAG 2.1 compliance level (A/AA/AAA)
- Color contrast ratios
- Keyboard navigation
- Screen reader support
- Form labeling

**Related Requirements**:
- Which FR does this implement?
```

**Time to complete**: 2-3 hours per major screen (5-6 hours total for MVP)

### 3. **process-decisions.md** `[COMPLETABLE BY HUMAN]`
**Purpose**: Document significant design decisions and rationale

**Format per decision**:
```
## [DD-001] Decision Name

**Question**: What were we deciding?

**Options Considered**:
1. Option A: Description, pros/cons
2. Option B: Description, pros/cons
3. Option C: Description, pros/cons

**Decision**: We chose [Option X]

**Rationale**:
- Why this option?
- What does it enable?
- Trade-offs accepted?

**Consequences**:
- Positives (benefits)
- Negatives (limitations)
- Future implications

**Alternatives Rejected**:
- Why not the others?
- Could we revisit later?

**Related Requirements**:
- Which requirements does this fulfill?
```

**Examples**:
- Authentication approach (simple email/password vs OAuth vs SAML)
- Database type (SQL vs NoSQL)
- Architecture style (monolith vs microservices)
- UI framework choice (if mentioned in design decisions)
- Real-time vs polling (for notifications)

**Time to complete**: 1-2 hours

---

## Completion Checklist

### Design Phase Deliverables
- [ ] System flows documented for all major workflows
- [ ] UI mockups created and described
- [ ] Interaction patterns defined
- [ ] Design decisions documented with rationale
- [ ] Accessibility requirements addressed
- [ ] Design validated against requirements

### Sign-Off
- [ ] **Prepared by**: [Designer, Architect]
- [ ] **Reviewed by**: [Product, Engineering Lead]
- [ ] **Approved by**: [Tech Lead, Design Lead]

---

## AI Assistance

### What AI Can Do Well
- Generate system flow diagrams (Mermaid format)
- Suggest UI patterns based on requirements
- Draft accessibility checklist
- Document interaction flows
- Suggest design decisions based on requirements

### What Needs Human Input
- Actual UI/UX mockups and designs
- Visual design language and branding
- User experience validated with users
- Specific architectural decisions
- Performance and scalability considerations

---

## Tips

1. **Start with flows**: Before designing screens, know what the system does
2. **Link to requirements**: Each flow should address specific requirements
3. **Include error paths**: Don't just show the happy path
4. **Design for mobile first**: Responsive design from the start
5. **Validate with users**: Get feedback on mockups before building
6. **Document decisions**: Future engineers need to understand WHY

---

## Next Steps

Once Design is complete and approved:
1. Share designs with development team
2. Begin detailing data structures (Phase 4)
3. Use designs for development estimation
4. **Move to Phase 4: Data Model**

---

**Files**:
- `system-flows.md` — User workflows and system behavior
- `ui-ux-design.md` — Screen layouts and interactions
- `process-decisions.md` — Design decisions with rationale

**Time Estimate**: 6-8 hours total  
**Team**: Designer, Product Manager, Architecture Lead  
**Output**: Designs ready for implementation

**Definition of Done**:
- All requirements have corresponding flows/screens
- Mockups created and approved
- Key design decisions documented
- Accessibility requirements met
