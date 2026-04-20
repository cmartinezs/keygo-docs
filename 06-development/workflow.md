[← Índice](./README.md) | [< Anterior](./coding-standards.md) | [Siguiente >](./adrs/README.md)

---

# Workflow de Desarrollo

Convenciones de ramas, commits, pull requests, integración con herramientas y hooks de pre-commit.

## Contenido

- [Estrategia de Ramas](#estrategia-de-ramas)
- [Commits Convencionales](#commits-convencionales)
- [Pull Request Workflow](#pull-request-workflow)
- [Pre-Commit Hooks](#pre-commit-hooks)
- [Integración con Herramientas](#integración-con-herramientas)

---

## Estrategia de Ramas

### Ramas Principales

| Rama | Propósito | Protegida |
|------|-----------|-----------|
| `main` | Producción | ✅ (require PR + 2 reviews) |
| `develop` | Integración | ✅ (require PR + 1 review) |

### Ramas de Soporte

| Tipo | Prefijo | Ejemplo | Merge a |
|------|---------|---------|---------|
| Feature | `feature/` | `feature/user-auth` | `develop` |
| Bugfix | `bugfix/` | `bugfix/login-fix` | `develop` |
| Hotfix | `hotfix/` | `hotfix/security-patch` | `main` + `develop` |
| Release | `release/` | `release/v1.0.0` | `main` + `develop` |

### Flujo

```
feature/NOMBRE
    │
    └──► PR ──► develop ──► staging (auto)
                    │
                    └──► PR ──► main ──► TAG ──► production
```

[↑ Volver al inicio](#workflow-de-desarrollo)

---

## Commits Convencionales

### Formato

```
<tipo>(<alcance>): <descripción en imperativo, minúsculas>
```

### Tipos

| Tipo | Cuándo usarlo |
|------|---------------|
| `feat` | Nueva funcionalidad |
| `fix` | Corrección de bug |
| `docs` | Solo documentación |
| `refactor` | Refactorización sin cambio de comportamiento |
| `test` | Agregar o corregir tests |
| `chore` | Mantenimiento, dependencias |
| `perf` | Mejora de rendimiento |
| `ci` | Cambios en CI/CD |

### Ejemplos

```bash
feat(auth): add password recovery flow
fix(user): reject duplicate email on creation
docs(api): document /users endpoint
refactor(session): extract token validation to domain service
test(membership): add unit tests for role assignment
chore(deps): bump spring-boot to 3.3.0
```

[↑ Volver al inicio](#workflow-de-desarrollo)

---

## Pull Request Workflow

### Checklist antes de abrir PR

- [ ] Tests pasando localmente (`./mvnw test` / `npm run test`)
- [ ] Sin warnings de lint (`./mvnw checkstyle:check` / `npm run lint`)
- [ ] Cobertura no bajó
- [ ] Descripción del PR explica el **por qué**, no solo el qué
- [ ] Linked a issue o ticket si aplica

### Validaciones automáticas (CI en PR)

```yaml
# .github/workflows/pr.yml
name: PR Checks
on:
  pull_request:
    branches: [develop, main]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - name: Conventional commit format
        run: |
          commits=$(git log --format=%s ${{ github.event.pull_request.base.sha }}..HEAD)
          echo "$commits" | grep -qE '^(feat|fix|docs|refactor|test|chore|perf|ci)' \
            || { echo "Commit no sigue convención"; exit 1; }

      - name: Branch name
        run: |
          echo "${{ github.head_ref }}" | \
            grep -qE '^(feature|bugfix|hotfix|release)/' \
            || { echo "Nombre de rama inválido"; exit 1; }
```

### Protected Branches

| Rama | Reviews requeridos | Status checks |
|------|--------------------|---------------|
| `main` | 2 approvals | CI passing |
| `develop` | 1 approval | CI passing |

### Release desde rama

```bash
# 1. Crear rama de release
git checkout -b release/v1.0.0 develop

# 2. Testing en staging

# 3. Merge a main
git checkout main && git merge release/v1.0.0

# 4. Tag
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0

# 5. Merge de vuelta a develop
git checkout develop && git merge main
git push origin develop
```

[↑ Volver al inicio](#workflow-de-desarrollo)

---

## Pre-Commit Hooks

### Instalación

```bash
pip install pre-commit
pre-commit install --hook-type pre-commit
pre-commit install --hook-type commit-msg
```

### Configuración (`.pre-commit-config.yaml`)

```yaml
repos:
  # Checks generales
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: detect-private-key

  # Secrets
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks

  # Backend (Java/Maven)
  - repo: local
    hooks:
      - id: backend-build
        name: Backend Build
        entry: ./mvnw clean package -DskipTests -q
        language: system
        files: \.java$

      - id: backend-test
        name: Backend Unit Tests
        entry: ./mvnw test -q
        language: system
        files: \.java$

      - id: backend-lint
        name: Backend Checkstyle
        entry: ./mvnw checkstyle:check -q
        language: system
        files: \.java$

  # Frontend (Node/npm)
  - repo: local
    hooks:
      - id: frontend-lint
        name: Frontend ESLint
        entry: npm run lint
        language: system
        files: \.(tsx?|jsx?)$

      - id: frontend-typecheck
        name: Frontend TypeCheck
        entry: npm run typecheck
        language: system
        files: \.tsx?$

      - id: frontend-test
        name: Frontend Unit Tests
        entry: npm run test -- --run
        language: system
        files: \.(tsx?|jsx?)$

  # Commit message
  - repo: https://github.com/compilerla/conventional-pre-commit
    rev: v3.2.0
    hooks:
      - id: conventional-pre-commit
        stages: [commit-msg]
```

### Thresholds

| Ámbito | Herramienta | Mínimo |
|--------|-------------|--------|
| Backend | JaCoCo | 75% líneas |
| Frontend | Vitest | 80% líneas |
| Linting | Checkstyle + ESLint | 0 errores |

### Ejecución manual

```bash
# Todos los hooks
pre-commit run --all-files

# Solo un hook
pre-commit run backend-test --all-files

# Saltar temporalmente (WIP)
git commit --no-verify -m "WIP: work in progress"
```

[↑ Volver al inicio](#workflow-de-desarrollo)

---

## Integración con Herramientas

### Slack — Canales

| Canal | Propósito |
|-------|-----------|
| `#keygo-pr` | Notificaciones de PR |
| `#keygo-deploy` | Despliegues |
| `#keygo-alerts` | Alertas y errores |
| `#keygo-ci` | Resultados de CI |

### Transiciones automáticas (Jira / Linear)

| Evento PR | Estado ticket |
|-----------|---------------|
| PR abierto | In Progress |
| PR aprobado | In Review |
| PR mergeado | Done |
| PR cerrado sin merge | Cancelled |

### Kanban

| Columna | Estado |
|---------|--------|
| To Do | PR draft |
| In Progress | PR abierto |
| In Review | PR aprobado |
| Done | PR mergeado |

[↑ Volver al inicio](#workflow-de-desarrollo)

---

[← Índice](./README.md) | [< Anterior](./coding-standards.md) | [Siguiente >](./adrs/README.md)
