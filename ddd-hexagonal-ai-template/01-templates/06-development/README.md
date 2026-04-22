# Phase 6: Development

## Overview

Development phase defines the technical implementation: architecture, APIs, coding standards, and technology stack. This is where requirements become code.

## Key Objectives

- [ ] Define system architecture (hexagonal focus)
- [ ] Design APIs and service contracts
- [ ] Establish coding standards and conventions
- [ ] Document technology stack decisions
- [ ] Create Architecture Decision Records (ADRs)

## Files to Complete

### 1. **architecture.md** `[COMPLETABLE BY HUMAN & AI]`
**Purpose**: System structure following hexagonal (ports & adapters) architecture

**Sections**:
- **Core Domain**: Entities, aggregates, domain services, business rules
- **Ports**: Input/output interfaces/contracts
- **Adapters**: Specific implementations (REST, database, email, etc.)
- **Layers**: How components relate (domain → application → presentation)
- **Communication Patterns**: Synchronous, asynchronous, event-driven

**Includes**:
- Architecture diagram(s)
- Component descriptions
- Technology choices and rationale
- Scalability and deployment strategy

**Time to complete**: 4-6 hours

### 2. **api-design.md** `[COMPLETABLE BY HUMAN & AI]`
**Purpose**: API specifications (REST, GraphQL, gRPC, etc.)

**Per endpoint/operation**:
- Description and purpose
- Request format (headers, body, parameters)
- Response format and status codes
- Error handling
- Authentication/authorization
- Rate limiting
- Example requests/responses

**Format**: OpenAPI 3.0 or AsyncAPI 2.0 (auto-generated tools preferred)

**Time to complete**: 3-4 hours

### 3. **coding-standards.md** `[COMPLETABLE BY HUMAN]`
**Purpose**: Development conventions and best practices

**Topics**:
- Language/framework conventions
- Naming standards (classes, functions, variables)
- Code organization (packages, modules)
- Comment and documentation standards
- Error handling approach
- Logging standards
- Testing requirements
- Security guidelines
- Performance considerations

**Time to complete**: 2-3 hours

### 4. **adr/** directory `[COMPLETABLE BY HUMAN & AI]`
**Purpose**: Architecture Decision Records — "why" behind decisions

**Per decision** (`ADR-001-decision-name.md`):
- Context: What problem were we solving?
- Decision: What did we decide?
- Consequences: Trade-offs and implications

**Examples**: Technology choice, architecture pattern, library selection

**Time to complete**: 30 min per decision

---

## Completion Checklist

### Development Phase Deliverables
- [ ] System architecture documented (hexagonal focus)
- [ ] All major APIs designed and specified
- [ ] Coding standards established
- [ ] Technology stack documented
- [ ] ADRs created for major decisions
- [ ] Architecture reviewed and approved

### Sign-Off
- [ ] **Prepared by**: [Tech Lead, Architects]
- [ ] **Reviewed by**: [Engineering Team]
- [ ] **Approved by**: [Architecture Lead]

---

## Tips

1. **Hexagonal Architecture**: Separate domain from adapters, maintain testability
2. **API-First**: Define APIs before implementing backends
3. **Document decisions**: Future engineers need to understand choices
4. **Consistency**: Standards make code reviews faster
5. **Flexibility**: Architecture should allow for change

---

## Next Steps

Once Development specifications are ready:
1. Share with engineering team
2. Begin implementation
3. Create ADRs for new decisions during development
4. **Move to Phase 7: Testing**

---

**Files**:
- `architecture.md` — System architecture and design
- `api-design.md` — API specifications
- `coding-standards.md` — Development conventions
- `adr/` — Architecture Decision Records

**Time Estimate**: 10-12 hours total  
**Team**: Tech Lead, Architects, Senior Engineers  
**Output**: Architecture and implementation ready for development

**Definition of Done**:
- Architecture documented and reviewed
- All APIs specified
- Coding standards established
- Major decisions recorded in ADRs
