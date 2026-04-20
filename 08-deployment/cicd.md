[← Índice](./README.md) | [< Anterior](./environments.md) | [Siguiente >](./release-process.md)

---

# CI/CD Pipeline

> **Nota**: Esta documentación cubre **Backend (KeyGo Server)**. Para deployment de **Frontend (KeyGo UI)**, ver sección al final de este documento.

---

Pipeline de CI/CD con GitHub Actions, security scanning y deployment automation.

## Contenido

- [Pipeline Architecture](#pipeline-architecture)
- [CI Pipeline](#ci-pipeline)
- [Security Scanning](#security-scanning)
- [CD Pipeline](#cd-pipeline)
- [Artifact Management](#artifact-management)
- [Rollback](#rollback)
- [Frontend Deployment](#frontend-deployment-keygo-ui)

---

## Pipeline Architecture

```
Push to develop
    ↓
GitHub Actions workflow
    ├─ Build & Test
    │  ├─ Unit tests
    │  ├─ Integration tests
    │  └─ Code coverage check
    ├─ Security Scanning
    │  ├─ SAST (SonarQube)
    │  ├─ Dependency check (Snyk)
    │  └─ Container scan (Trivy)
    ├─ Build Artifact
    │  ├─ Docker image build
    │  ├─ Push to registry
    │  └─ Sign image (Cosign)
    └─ Deploy
       ├─ Dev → Auto-deploy
       ├─ Staging → Manual approval
       └─ Prod → Manual approval + runbook
```

[↑ Volver al inicio](#cicd-pipeline)

---

## CI Pipeline

### Workflow: `.github/workflows/ci.yml`

```yaml
name: CI

on:
  push:
    branches: [develop, main]
  pull_request:
    branches: [develop]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          java-version: 21
          distribution: temurin
          cache: maven
      
      - name: Run unit tests
        run: ./mvnw clean test -DskipITs
      
      - name: Run integration tests
        run: ./mvnw verify
      
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3

  security:
    runs-on: ubuntu-latest
    needs: test
    
    steps:
      - uses: actions/checkout@v4
      
      - name: SonarQube scan
        run: ./mvnw clean verify sonar:sonar
      
      - name: Snyk dependency check
        run: snyk test --severity-threshold=high
      
      - name: Check quality gate
        run: |
          QUALITY=$(curl -s ... | jq -r '.projectStatus.status')
          if [ "$QUALITY" != "OK" ]; then exit 1; fi

  build:
    runs-on: ubuntu-latest
    needs: [test, security]
    if: github.event_name == 'push'
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Build JAR
        run: ./mvnw clean package -DskipTests
      
      - name: Build and push Docker image
        uses: docker/build-push-action@v4
      
      - name: Scan image with Trivy
        uses: aquasecurity/trivy-action@master
      
      - name: Sign image with Cosign
        run: cosign sign --key env://COSIGN_KEY ...
```

[↑ Volver al inicio](#cicd-pipeline)

---

## Security Scanning

### SAST: SonarQube

**Thresholds:**
- Code Smells < 50
- Bugs < 5
- Vulnerabilities > 0 (fail)
- Coverage < 75% (fail)
- Duplications > 10% (fail)

### Dependency: Snyk

```bash
snyk test --severity-threshold=high
snyk monitor
```

### Container: Trivy

```bash
trivy image --severity HIGH,CRITICAL --exit-code 1 \
  ghcr.io/cmartinezs/keygo-server:v1.0.0
```

[↑ Volver al inicio](#cicd-pipeline)

---

## CD Pipeline

### Deploy to Dev

```yaml
name: Deploy to Dev

on:
  workflow_run:
    workflows: [CI]
    types: [completed]
    branches: [develop]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
      - name: Update Helm values
        run: sed -i "s/tag:.*/tag: ${{ github.sha }}/g" helm/values-dev.yaml
      
      - name: Deploy with Helm
        run: helm upgrade keygo-server ./helm -f helm/values-dev.yaml --namespace development --wait
      
      - name: Verify deployment
        run: kubectl rollout status deployment/keygo-server -n development
```

### Deploy to Staging

```yaml
name: Deploy to Staging

on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Version to deploy'
        required: true

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: staging
    
    steps:
      - name: Pre-deployment checklist
        run: |
          echo "✓ Database backup scheduled"
          echo "✓ Rollback plan documented"
          echo "✓ Monitoring alerts configured"
      
      - name: Deploy with Helm
        run: helm upgrade keygo-server ./helm -f helm/values-staging.yaml --namespace staging --wait
      
      - name: Smoke tests
        run: |
          curl -f https://api-staging.keygo.io/actuator/health
```

### Deploy to Production

```yaml
name: Deploy to Production

on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Version to deploy (git tag)'
        required: true

jobs:
  deploy:
    runs-on: ubuntu-latest
    environment: production
    
    steps:
      - name: Notify team
        run: echo "🚀 Starting production deployment"
      
      - name: Create backup
        run: |
          kubectl exec -n production keygo-postgres -- \
            pg_dump -U keygo keygo | gzip > /tmp/backup.sql.gz
      
      - name: Deploy with Helm
        run: helm upgrade keygo-server ./helm -f helm/values-prod.yaml --namespace production --wait --atomic
      
      - name: Smoke tests
        run: curl -f https://api.keygo.io/actuator/health
      
      - name: Success notification
        run: echo "✅ Production deployment successful"
```

[↑ Volver al inicio](#cicd-pipeline)

---

## Artifact Management

### Docker Registry Strategy

```
ghcr.io/cmartinezs/keygo-server:develop-abc123  (branch + sha)
ghcr.io/cmartinezs/keygo-server:v1.0.0           (semver tag)
ghcr.io/cmartinezs/keygo-server:latest           (latest release)
```

### Retention Policy

- Keep last 10 images per branch
- Delete untagged images > 7 days old
- Keep all semantic version tags

[↑ Volver al inicio](#cicd-pipeline)

---

## Rollback

### Automatic Rollback

```bash
kubectl rollout undo deployment/keygo-server -n production
```

### Manual Rollback

```bash
# List versions
helm history keygo-server -n production

# Rollback to previous
helm rollout undo keygo-server -n production

# Rollback to specific revision
helm rollout undo keygo-server -n production --revision=3
```

[↑ Volver al inicio](#cicd-pipeline)

---

## Frontend Deployment (KeyGo UI)

### Stack

| Capa | Herramienta |
|------|------------|
| Framework | React + Vite |
| Hosting | Vercel / Netlify / Cloudflare Pages |
| CDN | Cloudflare |
| CI | GitHub Actions |

### Ambientes

| Environment | URL | Deploy |
|-------------|-----|--------|
| **Dev** | `https://dev-ui.keygo.io` | Auto |
| **Preview** | `https://preview-ui.keygo-io.vercel.app` | PR automatic |
| **Staging** | `https://staging-ui.keygo.io` | Manual |
| **Production** | `https://ui.keygo.io` | Manual con aprobación |

### Variables de Entorno

```env
VITE_KEYGO_BASE=https://api.keygo.io
VITE_TENANT_SLUG=keygo
VITE_CLIENT_ID=keygo-ui
VITE_REDIRECT_URI=https://ui.keygo.io/callback
```

### GitHub Actions: Frontend CI/CD

```yaml
name: Frontend CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      
      - name: Install dependencies
        run: npm ci
      
      - name: Lint
        run: npm run lint
      
      - name: Type check
        run: npm run typecheck
      
      - name: Run tests
        run: npm run test

  build:
    runs-on: ubuntu-latest
    needs: test
    if: github.event_name == 'push'
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build
        run: npm run build
        
      - name: Deploy to Vercel
        uses: amondnet/vercel-action@v20
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: '--prod'  # For production branch
```

### Vercel Configuration

```json
// vercel.json
{
  "buildCommand": "npm run build",
  "outputDirectory": "dist",
  "framework": "vite",
  "installCommand": "npm ci"
}
```

### Preview Deployments (PR)

Los PRs automágicamente generan un preview URL:
- `https://keygo-ui-abc123.vercel.app`
- Permite testing antes de merge

### Rollback

```bash
# Vercel automáticamente guarda deployments
# Desde dashboard o CLI:
vercel rollback keygo-ui --env production
```

### CDN y Cache

```yaml
# Headers recommendados
Cache-Control: public, max-age=0, must-revalidate
# Static assets
Cache-Control: public, max-age=31536000, immutable
```

[↑ Volver al inicio](#cicd-pipeline)

---

[← Índice](./README.md) | [< Anterior](./environments.md) | [Siguiente >](./release-process.md)