# Deployment: Pipeline Strategy

**Fase:** 08-deployment | **Audiencia:** DevOps, CI/CD engineers, release managers | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Introducción](#introducción)
2. [Pipeline Architecture](#pipeline-architecture)
3. [CI Workflow](#ci-workflow)
4. [Security Scanning](#security-scanning)
5. [Artifact Management](#artifact-management)
6. [CD: Deployment Strategy](#cd-deployment-strategy)
7. [Release Process](#release-process)
8. [Rollback Procedure](#rollback-procedure)
9. [Monitoring & Validation](#monitoring--validation)

---

## Introducción

La **Pipeline Strategy** define cómo el código de KeyGo fluye desde commit hasta producción:

```
Code → Git Push → CI (Build, Test, Scan) → Artifacts → CD (Deploy) → Prod
```

**Responsabilidad:**

- Garantizar **calidad** antes de merge (tests, coverage)
- Garantizar **seguridad** (SAST, dependency scan, container scan)
- Garantizar **trazabilidad** (signed images, immutable artifacts)
- Permitir **rollback rápido** en caso de issues

---

## Pipeline Architecture

### Overall Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    GitHub Repository                             │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  develop branch      ← PR merge triggers CI                      │
│      ↓                                                             │
│  GitHub Actions: test + build (5 min)                           │
│      ├─ Unit tests                                               │
│      ├─ Integration tests                                        │
│      ├─ Code coverage (min 80%)                                  │
│      ├─ Build Docker image                                       │
│      └─ Push to registry (ghcr.io)                              │
│      ↓                                                             │
│  Docker Image: ghcr.io/keygo/keygo-server:1.0-dev-abc123       │
│      ↓                                                             │
│  main branch      ← Only production releases                     │
│      ├─ Tag v1.0.0                                               │
│      ├─ GitHub Actions: promote artifact (2 min)                │
│      ├─ Sign image (Cosign)                                      │
│      ├─ Push to prod registry                                    │
│      └─ Create release notes                                     │
│      ↓                                                             │
│  staging ← Manual trigger (CD stage 1)                          │
│      ├─ Deploy with smoke tests                                  │
│      ├─ Verify canary: 10% traffic → new version                │
│      ├─ Monitor for 30 min                                       │
│      └─ If OK → proceed to prod                                 │
│      ↓                                                             │
│  production ← Manual approval required (CD stage 2)              │
│      ├─ Blue-green deployment                                    │
│      ├─ Route 50% traffic to green                              │
│      ├─ Monitor 15 min                                           │
│      ├─ If issues: instant rollback                              │
│      └─ Route 100% traffic to green                             │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

---

## CI Workflow

### .github/workflows/ci.yml

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [develop, main]
  pull_request:
    branches: [develop]

env:
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}/keygo-server

jobs:
  # Stage 1: Lint & Test
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16-alpine
        env:
          POSTGRES_DB: keygo_test
          POSTGRES_PASSWORD: test123
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Java
        uses: actions/setup-java@v4
        with:
          java-version: '21'
          distribution: 'temurin'
          cache: maven
      
      - name: Run unit tests
        run: ./mvnw clean test
      
      - name: Run integration tests
        env:
          SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/keygo_test
        run: ./mvnw verify
      
      - name: Check code coverage
        run: |
          coverage=$(./mvnw jacoco:report | grep -oP '(?<=Coverage: )\d+')
          if [ "$coverage" -lt 80 ]; then
            echo "Coverage $coverage% is below 80% threshold"
            exit 1
          fi
      
      - name: Upload coverage to Codecov
        uses: codecov/codecov-action@v3
        with:
          files: ./target/site/jacoco/jacoco.xml

  # Stage 2: Build & Security Scan
  build:
    needs: test
    runs-on: ubuntu-latest
    if: github.event_name == 'push' || github.event.pull_request.state == 'open'
    
    permissions:
      contents: read
      packages: write
      security-events: write

    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Java
        uses: actions/setup-java@v4
        with:
          java-version: '21'
          distribution: 'temurin'
          cache: maven
      
      - name: Build Docker image
        run: |
          ./mvnw clean package -DskipTests
          docker build -t ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} .
          docker tag ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} \
                     ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest
      
      - name: Run Trivy container scan
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
          format: 'sarif'
          output: 'trivy-results.sarif'
      
      - name: Upload Trivy results to GitHub Security
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: 'trivy-results.sarif'
      
      - name: Run SAST (SonarQube)
        env:
          SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
        run: |
          ./mvnw clean verify sonar:sonar \
            -Dsonar.projectKey=keygo \
            -Dsonar.host.url=$SONAR_HOST_URL \
            -Dsonar.login=$SONAR_TOKEN

  # Stage 3: Push to Registry
  push:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/develop' || github.ref == 'refs/heads/main'
    
    permissions:
      contents: read
      packages: write

    steps:
      - uses: actions/checkout@v4
      
      - name: Log in to GitHub Container Registry
        uses: docker/login-action@v2
        with:
          registry: ${{ env.REGISTRY }}
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      
      - name: Build and push image
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: |
            ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }}
            ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:latest
```

---

## Security Scanning

### SAST: Static Application Security Testing

```bash
# SonarQube local scan
./mvnw sonar:sonar \
  -Dsonar.projectKey=keygo \
  -Dsonar.sources=src \
  -Dsonar.exclusions=src/test/**
```

**Reglas:**
- No hardcoded credentials
- No SQL injection patterns
- No XXE vulnerabilities
- Coverage must be >= 80%

### Dependency Scanning

```bash
# Snyk: check for vulnerable dependencies
npm install -g snyk
snyk test --file=pom.xml
snyk monitor --file=pom.xml  # continuous monitoring
```

### Container Scanning

```bash
# Trivy: scan Docker image
trivy image keygo/keygo-server:1.0

# Fix vulns in base image
# FROM ubuntu:24.04  → use smaller base (alpine, distroless)
```

---

## Artifact Management

### Versioning Scheme

```
Development:    keygo-server:1.0-dev-abc1234   (each commit)
Release:        keygo-server:1.0.0              (git tag)
Hotfix:         keygo-server:1.0.1              (patch release)
```

### Image Signing (Cosign)

```bash
# Generate signing key
cosign generate-key-pair

# Sign image
cosign sign --key cosign.key $REGISTRY/$IMAGE:1.0.0

# Verify signature
cosign verify --key cosign.pub $REGISTRY/$IMAGE:1.0.0
```

### Artifact Retention

```bash
# Keep last 10 images per tag
# Delete images older than 90 days (in prod)
# Keep indefinitely: v1.0.0, v1.1.0 (release tags)
```

---

## CD: Deployment Strategy

### Blue-Green Deployment

```
Current (Blue):  10.0.0.1:8080  ← 100% traffic
Staging (Green): 10.0.0.2:8080  ← 0% traffic

Deployment:
  1. Deploy new version to Green
  2. Run smoke tests on Green
  3. Route 50% traffic to Green (monitor 5 min)
  4. If OK: route 100% to Green
  5. Blue becomes backup for rollback
```

### Canary Deployment

```
Prod-A: 90% traffic (stable)
Prod-B: 10% traffic (canary)

Roll out new version:
  - Monitor error rate, latency, crashes on 10% for 30 min
  - If metrics OK: increase to 25%
  - If metrics OK: increase to 50%
  - If metrics OK: increase to 100%
```

### GitHub Actions: CD Workflow

```yaml
deploy:
  needs: push
  runs-on: ubuntu-latest
  environment:
    name: production
    url: https://auth.example.com
  
  steps:
    - uses: actions/checkout@v4
    
    - name: Deploy to staging
      run: |
        kubectl set image deployment/keygo-server \
          keygo=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} \
          --namespace=staging
    
    - name: Run smoke tests
      run: |
        curl -f https://staging.example.com/actuator/health
        npm run e2e:smoke --prefix=tests/
    
    - name: Approve for production
      if: github.ref == 'refs/heads/main'
      run: echo "Manual approval required in GitHub UI"
    
    - name: Deploy to production
      run: |
        kubectl set image deployment/keygo-server \
          keygo=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.sha }} \
          --namespace=production
```

---

## Release Process

### Step 1: Prepare Release

```bash
# Create release branch
git checkout -b release/1.0.0

# Update version in pom.xml
sed -i 's/<version>1.0-SNAPSHOT/<version>1.0.0/g' pom.xml

# Generate changelog
git log --oneline v0.9.0..HEAD > CHANGELOG.md

# Commit
git add pom.xml CHANGELOG.md
git commit -m "chore: Prepare release 1.0.0"
```

### Step 2: Tag & Release

```bash
# Tag release
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0

# GitHub Actions triggers build + sign + push to prod registry
# Wait for CI to complete
```

### Step 3: Post-Release

```bash
# Merge release branch back to develop
git checkout develop
git merge release/1.0.0
git push origin develop

# Update version to next snapshot
sed -i 's/<version>1.0.0/<version>1.1.0-SNAPSHOT/g' pom.xml
git commit -am "chore: Bump version to 1.1.0-SNAPSHOT"
git push origin develop
```

---

## Rollback Procedure

### Quick Rollback (< 5 min)

```bash
# If issue detected within 30 min of deployment

# Option 1: Kubernetes
kubectl set image deployment/keygo-server \
  keygo=keygo/keygo-server:1.0.0 \  # previous stable version
  --namespace=production

# Option 2: Docker Compose
docker-compose down
git checkout v1.0.0
docker-compose up -d

# Option 3: Kubernetes rollout undo
kubectl rollout undo deployment/keygo-server --namespace=production
```

### Investigation After Rollback

```bash
# Collect logs
kubectl logs -l app=keygo --namespace=production > logs.txt

# Collect metrics
curl http://localhost:8080/actuator/prometheus > metrics.txt

# Store for postmortem
git add logs.txt metrics.txt
git commit -m "incident: Collect logs from 1.0.1 rollback"
```

---

## Monitoring & Validation

### Post-Deployment Checklist

```bash
# 1. Health check
curl https://auth.example.com/actuator/health

# 2. Database connectivity
curl https://auth.example.com/actuator/db

# 3. Smoke tests
npm run e2e:smoke

# 4. Canary traffic (if 10% deployed)
curl -H "X-Canary: true" https://auth.example.com/api/v1/health

# 5. Error rate
# Check Prometheus: rate(http_requests_total{status=~"5.."}[5m])
# Should be < 1% of traffic
```

### SLA for Deployment

| Metric | Target | Consequence |
|--------|--------|-------------|
| Build time | < 10 min | Faster feedback |
| Deployment time | < 5 min | Faster rollback |
| MTTR (if issue) | < 15 min | Automated rollback or pagerduty |

---

## Véase También

- **production-runbook.md** — Operational procedures post-deployment
- **environment-setup.md** — Configure dev/staging/prod environments
- **incident-response-guide.md** — Handle deployment incidents
- **release-strategy.md** — Versioning and release notes

---

**Última actualización:** 2025-Q1 | **Mantenedor:** DevOps/Release Eng | **Licencia:** Keygo Docs
