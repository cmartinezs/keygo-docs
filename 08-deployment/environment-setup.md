# Deployment: Environment Setup & Configuration

**Fase:** 08-deployment | **Audiencia:** Developers, DevOps, Infra engineers | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Introducción](#introducción)
2. [Environment Hierarchy](#environment-hierarchy)
3. [Local Development Setup](#local-development-setup)
4. [Staging Environment](#staging-environment)
5. [Production Environment](#production-environment)
6. [Environment Variables Reference](#environment-variables-reference)
7. [Tools & Prerequisites](#tools--prerequisites)
8. [Troubleshooting Setup](#troubleshooting-setup)

---

## Introducción

KeyGo se ejecuta en **3 ambientes principales**, cada uno con configuración específica:

```
Local (Developer Machine)
    ↓
Staging (Pre-prod, testing)
    ↓
Production (Customer-facing)
```

**Objetivo:** Garantizar consistencia entre ambientes mientras se adaptan a necesidades específicas (DB size, TLS, secrets).

---

## Environment Hierarchy

### Configuration Precedence

```
System Environment Variables (highest priority)
    ↓
.env file (development)
    ↓
application.yml (default)
    ↓
application-{profile}.yml (lowest priority)
```

**Ejemplo:**

```bash
# This overrides everything
export SPRING_DATASOURCE_PASSWORD=prod-secret-123

# Falls back to .env
cat .env | grep SPRING_DATASOURCE_PASSWORD

# Falls back to application.yml
cat src/main/resources/application.yml
```

---

## Local Development Setup

### Prerequisites

```bash
Java 21 (Adoptium or OpenJDK)
Docker 24+ (with Docker Compose)
PostgreSQL client tools (psql, pg_dump)
Maven 3.9+
Node.js 20+ (for frontend)
Git 2.40+
```

### Step 1: Checkout & Setup

```bash
git clone https://github.com/keygo/keygo-server.git
cd keygo-server

# Switch to local environment
./docs/scripts/switch-env.sh local

# Load environment
set -a; source .env; set +a
```

### Step 2: .env File (Local)

**File:** `.env` (or `envs/.env-local`)

```bash
# Database
SPRING_DATASOURCE_URL=jdbc:postgresql://localhost:5432/keygo
SPRING_DATASOURCE_USERNAME=keygo_admin
SPRING_DATASOURCE_PASSWORD=dev-password-123
SPRING_DATASOURCE_HIKARI_MAXIMUM_POOL_SIZE=5

# Application
KEYGO_ISSUER_BASE_URL=http://localhost:8080
KEYGO_UI_BASE_URL=http://localhost:3000
KEYGO_PLATFORM_REDIRECT_URI=http://localhost:3000/callback
KEYGO_CORS_ALLOWED_ORIGINS=http://localhost:3000,http://localhost:5173

# JWT Signing (local: simple key)
KEYGO_JWT_SIGNING_KEY=dev-signing-key-do-not-use-in-prod

# Email (local: console output)
SPRING_MAIL_HOST=localhost
SPRING_MAIL_PORT=1025
SPRING_MAIL_DEBUG=true

# Logging
LOGGING_LEVEL_ROOT=INFO
LOGGING_LEVEL_IO_CMARTINEZS_KEYGO=DEBUG

# Profile
SPRING_PROFILES_ACTIVE=dev,h2  # h2 for embedded DB alternative
```

### Step 3: Start Services

```bash
# Start PostgreSQL (Docker)
docker-compose up -d postgres mailhog

# Verify DB is ready
docker-compose exec postgres pg_isready

# Run migrations (Flyway)
./mvnw flyway:migrate

# Start application
./mvnw spring-boot:run -pl keygo-run

# Frontend (separate terminal)
cd keygo-ui
npm install
npm run dev
```

### Step 4: Verify Setup

```bash
# Backend health
curl http://localhost:8080/actuator/health

# Frontend
open http://localhost:5173

# Mailhog (email testing)
open http://localhost:1025
```

---

## Staging Environment

### Setup via Docker Compose

```yaml
# docker-compose.staging.yml
version: '3.8'

services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: keygo_staging
      POSTGRES_USER: keygo
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - staging-db:/var/lib/postgresql/data

  keygo:
    image: keygo/keygo-server:1.0.0-rc1
    environment:
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/keygo_staging
      SPRING_DATASOURCE_USERNAME: keygo
      SPRING_DATASOURCE_PASSWORD: ${POSTGRES_PASSWORD}
      KEYGO_ISSUER_BASE_URL: https://staging.auth.example.com
      KEYGO_UI_BASE_URL: https://staging.example.com
      # All staging-specific values
    depends_on:
      - postgres
    ports:
      - "8080:8080"

volumes:
  staging-db:
```

### Launch Staging

```bash
# Load staging env
./docs/scripts/switch-env.sh staging

# Start
docker-compose -f docker-compose.staging.yml up -d

# Verify
curl https://staging.auth.example.com/actuator/health
```

### Staging Configuration

```bash
# File: envs/.env-staging
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres-staging.example.com:5432/keygo_staging
SPRING_DATASOURCE_USERNAME=keygo_staging_user
SPRING_DATASOURCE_PASSWORD=${SECRETS_MANAGER_STAGING_DB_PASSWORD}

KEYGO_ISSUER_BASE_URL=https://staging.auth.example.com
KEYGO_UI_BASE_URL=https://staging.example.com
KEYGO_CORS_ALLOWED_ORIGINS=https://staging.example.com

KEYGO_JWT_SIGNING_KEY=${SECRETS_MANAGER_STAGING_JWT_KEY}

SPRING_MAIL_HOST=smtp-relay.staging.example.com
SPRING_MAIL_PORT=587

LOGGING_LEVEL_ROOT=WARN
LOGGING_LEVEL_IO_CMARTINEZS_KEYGO=INFO
SPRING_PROFILES_ACTIVE=staging
```

---

## Production Environment

### HA Architecture (Kubernetes)

```yaml
# kubernetes/prod-namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: keygo-prod

---
apiVersion: v1
kind: Secret
metadata:
  name: keygo-secrets
  namespace: keygo-prod
type: Opaque
stringData:
  db-url: "jdbc:postgresql://postgres-prod.example.com:5432/keygo_prod"
  db-user: "keygo_prod_user"
  db-password: ${PROD_DB_PASSWORD}
  jwt-signing-key: ${PROD_JWT_KEY}
  
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: keygo-server
  namespace: keygo-prod
spec:
  replicas: 3
  template:
    spec:
      containers:
      - name: keygo
        image: ghcr.io/keygo/keygo-server:1.0.0
        env:
        - name: SPRING_DATASOURCE_URL
          valueFrom:
            secretKeyRef:
              name: keygo-secrets
              key: db-url
        # ... other env vars
        resources:
          requests:
            cpu: 500m
            memory: 1Gi
          limits:
            cpu: 1000m
            memory: 2Gi
```

### Production Configuration

```bash
# File: envs/.env-prod (never committed; loaded from secret manager)
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres-prod.example.com:5432/keygo_prod
SPRING_DATASOURCE_USERNAME=keygo_prod_user
SPRING_DATASOURCE_PASSWORD=<fetched-from-aws-secrets-manager>

KEYGO_ISSUER_BASE_URL=https://auth.example.com
KEYGO_UI_BASE_URL=https://console.example.com
KEYGO_CORS_ALLOWED_ORIGINS=https://console.example.com

KEYGO_JWT_SIGNING_KEY=<fetched-from-aws-secrets-manager>

SPRING_MAIL_HOST=email-smtp.us-east-1.amazonaws.com
SPRING_MAIL_PORT=587
SPRING_MAIL_USERNAME=<aws-ses-user>
SPRING_MAIL_PASSWORD=<aws-ses-password>

# TLS/SSL
SERVER_SSL_ENABLED=true
SERVER_SSL_KEY_STORE=/etc/ssl/keystore.jks
SERVER_SSL_KEY_STORE_PASSWORD=<keystore-password>

# Security
SPRING_SECURITY_REQUIRE_HTTPS=true
SERVER_SERVLET_SESSION_COOKIE_SECURE=true
SERVER_SERVLET_SESSION_COOKIE_HTTP_ONLY=true

# Logging (JSON structured logs)
LOGGING_LEVEL_ROOT=WARN
LOGGING_LEVEL_IO_CMARTINEZS_KEYGO=INFO
LOGGING_PATTERN_CONSOLE=%d{ISO8601} %-5level %logger{36} - %msg%n
SPRING_PROFILES_ACTIVE=prod
```

### Production Deployment

```bash
# 1. Load prod env from secrets manager
export $(aws secretsmanager get-secret-value --secret-id keygo/prod/env --query SecretString --output text | jq -r 'to_entries[] | "\(.key)=\(.value)"' | xargs)

# 2. Deploy to Kubernetes
kubectl apply -f kubernetes/prod-namespace.yaml
kubectl set image deployment/keygo-server \
  keygo=ghcr.io/keygo/keygo-server:1.0.0 \
  --namespace=keygo-prod

# 3. Verify
kubectl rollout status deployment/keygo-server --namespace=keygo-prod
curl https://auth.example.com/actuator/health
```

---

## Environment Variables Reference

| Variable | Local | Staging | Prod | Type | Description |
|----------|-------|---------|------|------|-------------|
| `SPRING_DATASOURCE_URL` | localhost | staging-db | prod-db | URL | Database connection |
| `SPRING_DATASOURCE_USERNAME` | keygo_admin | keygo_staging | keygo_prod | String | DB user |
| `KEYGO_ISSUER_BASE_URL` | http://localhost:8080 | https://staging.auth... | https://auth... | URL | JWT issuer |
| `KEYGO_JWT_SIGNING_KEY` | dev-key | secret-manager | secret-manager | String | JWT signing key (512b) |
| `SPRING_MAIL_HOST` | localhost | smtp-relay | aws-ses | String | Email server |
| `LOGGING_LEVEL_ROOT` | INFO | WARN | WARN | String | Root log level |
| `SPRING_PROFILES_ACTIVE` | dev | staging | prod | String | Active Spring profiles |

---

## Tools & Prerequisites

### Installation Scripts

```bash
# macOS
brew install openjdk@21 postgresql@16 docker maven node

# Ubuntu
sudo apt-get install openjdk-21-jdk postgresql-client maven docker.io nodejs

# Windows (PowerShell with Chocolatey)
choco install openjdk21 postgresql maven docker nodejs
```

### Docker Images

```bash
# Local development
docker pull postgres:16-alpine
docker pull mailhog/mailhog:latest

# Staging/Prod
docker pull ghcr.io/keygo/keygo-server:latest
docker pull nginx:alpine
```

---

## Troubleshooting Setup

### Issue: Database Connection Refused

```bash
# Check if PostgreSQL is running
docker-compose ps postgres

# Check port mapping
docker port keygo-postgres 5432

# Try connecting
psql -h localhost -U keygo_admin -d keygo
# If fails: incorrect password or wrong host
```

### Issue: Port Already in Use

```bash
# Find process using port 8080
lsof -i :8080

# Kill and restart
kill -9 <PID>
./mvnw spring-boot:run
```

### Issue: Flyway Migration Fails

```bash
# Check migration files
ls src/main/resources/db/migration/

# Reset DB (dev only!)
psql -h localhost -U keygo_admin -d keygo -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

# Re-run migrations
./mvnw flyway:migrate
```

---

## Véase También

- **production-runbook.md** — Operational procedures in production
- **pipeline-strategy.md** — How environments are deployed to
- **release-strategy.md** — Versioning and release coordination

---

**Última actualización:** 2025-Q1 | **Mantenedor:** DevOps/Infra | **Licencia:** Keygo Docs
