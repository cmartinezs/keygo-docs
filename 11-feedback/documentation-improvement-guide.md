# Feedback: Documentation & Process Improvement Guide

**Fase:** 11-feedback | **Audiencia:** All team members, leadership | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Documentation as Living System](#documentation-as-living-system)
2. [Update Triggers](#update-triggers)
3. [Feedback Loops](#feedback-loops)
4. [Quality Metrics](#quality-metrics)

---

## Documentation as Living System

### vs Static Wikipedia

**Static approach:** Write once, reference forever → becomes stale

**Living system approach:**
- Docs updated when code changes
- Docs tested (broken links, examples runnable)
- Team accountability (owner per doc)
- Regular audits (quarterly)

### Ownership Model

Every document has:
- **Owner**: Who maintains it
- **Last Updated**: When it was last reviewed
- **Next Review**: When it should be audited

Example:
```
**Última actualización:** 2025-Q1 | **Mantenedor:** Backend/Security | **Licencia:** Keygo Docs
```

---

## Update Triggers

### When to Update Docs

| Change | Docs to Update | Timing |
|--------|---|---|
| New API endpoint added | `api-endpoints-comprehensive.md` | Same commit |
| Breaking API change | `api-endpoints-comprehensive.md`, `api-versioning-strategy.md` | Before merge |
| New validation rule | `validation-strategy.md` | Same PR |
| Security vulnerability fixed | `security-implementation-guide.md` | Security PR |
| New testing pattern | `test-plans.md` | Same commit |
| New deployment procedure | `production-runbook.md` | Before rollout |
| New error code | `api-endpoints-comprehensive.md` (Error Reference) | Same PR |
| Component pattern discovered | `frontend-component-patterns.md` | Next refinement cycle |

### PR Review Checklist

```
[ ] Code changes reflected in docs?
    - New API? → api-endpoints.md updated
    - New validation? → validation-strategy.md updated
    - Breaking change? → api-versioning.md marked deprecated
[ ] Examples in docs still work?
[ ] Cross-references still valid (no broken links)?
[ ] README.md index updated if new doc created?
```

---

## Feedback Loops

### Quarterly Documentation Audit

**Every Q1, Q2, Q3, Q4:**

1. **Broken Links Scan** (30 min)
   ```bash
   ./scripts/check-links.sh  # Runs in CI/CD anyway
   ```

2. **Example Code Validation** (1 hour)
   - Run curl examples from API docs
   - Verify code snippets compile
   - Check screenshots are current

3. **Owner Review** (30 min per doc)
   - Owner reads their doc
   - Updates "Last Updated" date
   - Flags any changes needed

4. **Team Retro** (1 hour)
   - "What docs helped this quarter?"
   - "What docs were outdated?"
   - "What new docs are needed?"

### Continuous Feedback

**Slack channel: #docs-feedback**

When someone:
- Finds broken example → Post in #docs-feedback
- Notices outdated section → Add comment in doc file
- Suggests improvement → Create issue with label `documentation`

---

## Quality Metrics

### Health Checks

| Metric | Target | Tool | Frequency |
|--------|--------|------|-----------|
| **Broken Links** | 0 | linkchecker | CI/CD (every push) |
| **Examples Working** | 100% | manual test | Quarterly |
| **Last Updated < 3 months** | 95% | grep + script | Quarterly |
| **Cross-references Valid** | 100% | grep + manual | Quarterly |

### Dashboards

Create metrics dashboard in Grafana:

```
Docs Health Panel:
  - Total docs: 32
  - Updated this month: 5 (16%)
  - Broken links: 0
  - Examples failing: 0
  - Owners without review: 2
```

---

## Process: Adding New Documentation

### 1. Identify Need

```
"Our team doesn't understand how to implement X"
→ Create documentation PR
```

### 2. Create Document

```markdown
# [Title]

**Fase:** [XX-name] | **Audiencia:** [Who reads] | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Section]

---

## Section

Content here.

---

**Última actualización:** 2025-Q1 | **Mantenedor:** [Owner] | **Licencia:** Keygo Docs
```

### 3. Cross-Reference

- Add link to parent README.md index
- Link to related docs (Véase También section)
- Update macro-plan.md if it's a new doc

### 4. Commit

```bash
git add docs/new-doc.md
git commit -m "docs(phase): Add new-topic doc

- 06-development/new-doc.md (X KB): Description, key sections.
  Purpose: What problem does this solve.

Relates to [other docs], extends [feature area].

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
```

### 5. Announce

Post in team Slack channel with link and 1-liner about content.

---

## Process: Updating Existing Documentation

### Small Update (typo, clarification)

1. Edit directly in file
2. Commit with message: `docs(phase): Fix typo in doc-name.md`

### Medium Update (section rewrite, new example)

1. Check if other docs reference this section
2. Update cross-references if needed
3. Commit with message: `docs(phase): Update section in doc-name.md`

### Major Update (new structure, deprecation)

1. Discuss in #docs-feedback or team meeting
2. Update related docs first
3. Update README.md index if structure changed
4. Commit with message: `docs(phase): Refactor doc-name.md for clarity`

---

## Anti-Patterns

### ❌ Documentation Debt

```
"We'll document it later"
→ Later never comes → Docs become stale → Team stops reading
```

**Fix:** Docs updated same commit/PR as code change.

### ❌ Silos (Doc-per-team)

```
Backend docs separate from Frontend docs
→ Cross-team features undocumented → Integration fails
```

**Fix:** All docs in single repo, organized by SDLC phase, not team.

### ❌ Theory vs Practice

```
"Design pattern: Factory" (abstract)
→ No code example → Team doesn't know how to apply
```

**Fix:** Every pattern includes 3-5 real examples + anti-patterns.

### ❌ Dead Links

```
"See details in ../path/to/doc.md"
→ Doc renamed/moved → Link broken → Team frustrated
```

**Fix:** CI/CD scan for broken links, reference by doc title in text.

---

## Véase También

- **00-documental-planning/sdlc-framework.md** — How SDLC phases map to doc folders
- **README.md** — Top-level navigation for all docs

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Leadership | **Licencia:** Keygo Docs
