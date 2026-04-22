# Phase 4: Data Model

## Overview

The data model defines how information is structured, stored, and related. It translates design requirements into database schema and data flow specifications.

## Key Objectives

- [ ] Define all entities and their attributes
- [ ] Document entity relationships
- [ ] Create Entity-Relationship Diagram (ERD)
- [ ] Define validation rules and constraints
- [ ] Plan for data migration and archival

## Files to Complete

### 1. **entities-and-relationships.md** `[COMPLETABLE BY HUMAN & AI]`
**Purpose**: Define all entities, attributes, and constraints

**Format per entity**:
```
## Entity: Entity Name

**Primary Key**: field name and type

**Attributes**:
- field_name: Type, constraints (nullable, unique, etc.)
- field_name: Type, constraints
- timestamps: created_at, updated_at (always include)

**Relationships**:
- Has many [Other Entity] (1:N)
- Has one [Other Entity] (1:1)
- Belongs to [Parent Entity] (N:1)

**Constraints**:
- Business rules (e.g., status can only be X, Y, Z)
- Data constraints (e.g., email must be unique)
- Temporal constraints (e.g., end_date >= start_date)

**Soft Delete Strategy**: Is this entity soft-deleted or hard-deleted?

**Archival**: How long is data retained?

**Indexes**: What queries need to be fast?

**Notes**: Any special considerations?
```

**Time to complete**: 2-3 hours

### 2. **erd-diagram.md** `[COMPLETABLE BY AI with human validation]`
**Purpose**: Visual representation of entities and relationships

**Format**: ASCII diagram or reference to external tool (Lucidchart, Draw.io, etc.)

```
User
├── user_id (PK)
├── email (unique)
└── created_at

Project
├── project_id (PK)
├── name
├── owner_id (FK → User)
└── created_at

Task
├── task_id (PK)
├── project_id (FK → Project)
├── title
├── assignee_id (FK → User, nullable)
└── created_at
```

**Time to complete**: 1-2 hours

### 3. **data-flows.md** `[COMPLETABLE BY HUMAN & AI]`
**Purpose**: Document how data moves through the system

**Sections**:
- Data entry points (where does data come from?)
- Processing (transformations, validations)
- Storage (where is data kept?)
- Retrieval (how is data accessed?)
- Archival/Deletion (what happens to old data?)

**Time to complete**: 1-2 hours

---

## Completion Checklist

### Data Model Phase Deliverables
- [ ] All entities defined with attributes
- [ ] Relationships clearly documented
- [ ] ERD created and reviewed
- [ ] Validation rules and constraints defined
- [ ] Data flow through system documented
- [ ] Archival and retention policies defined
- [ ] Performance indexes identified

### Sign-Off
- [ ] **Prepared by**: [Database Architect]
- [ ] **Reviewed by**: [Backend Lead]
- [ ] **Approved by**: [Tech Lead]

---

## AI Assistance

### What AI Can Do Well
- Generate entity definitions from requirements
- Create ERD diagrams (Mermaid format)
- Suggest attribute types and constraints
- Identify common relationships
- Draft validation rules

### What Needs Human Input
- Database technology choice
- Performance optimization (indexing)
- Denormalization decisions
- Data retention policies (legal/business)
- Migration strategy

---

## Tips

1. **Always include timestamps**: created_at, updated_at on every entity
2. **Use UUIDs for IDs**: Better for distributed systems than auto-increment
3. **Normalize, then denormalize**: Start normalized, optimize with data
4. **Plan for archival**: Determine data retention from day 1
5. **Index for queries**: Consider what queries need to be fast

---

## Next Steps

Once Data Model is complete:
1. Share with development team
2. Begin implementation planning (Phase 5)
3. Use ERD for code generation (some tools can auto-generate models)
4. **Move to Phase 5: Planning**

---

**Files**:
- `entities-and-relationships.md` — Entity definitions
- `erd-diagram.md` — Entity Relationship Diagram
- `data-flows.md` — Data movement through system

**Time Estimate**: 4-6 hours total  
**Team**: Database Architect, Backend Lead  
**Output**: Complete data model ready for implementation

**Definition of Done**:
- All entities from requirements have definitions
- Relationships documented and validated
- ERD created and peer-reviewed
- Validation rules and constraints clear
