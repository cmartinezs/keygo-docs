# Operations: Production Runbook

**Fase:** 09-operations | **Audiencia:** DevOps, SRE, on-call engineers | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Introducción](#introducción)
2. [Pre-Requisitos](#pre-requisitos)
3. [Deployment Options](#deployment-options)
4. [Health Checks & Monitoring](#health-checks--monitoring)
5. [Troubleshooting Común](#troubleshooting-común)
6. [Backup & Recovery](#backup--recovery)
7. [Scaling & Performance](#scaling--performance)
8. [Security Hardening](#security-hardening)
9. [Runbooks de Incidentes](#runbooks-de-incidentes)
10. [Escalation & SLA](#escalation--sla)

---

## Introducción

Este runbook es la **guía operacional para mantener KeyGo en producción**. Asume que ya está deployado en un entorno (Docker Compose, Kubernetes, o cloud).

**Responsabilidades:**

- DevOps: Mantener infraestructura, patches, backups
- SRE: Monitoreo, alertas, incident response
- On-call: Responder a páginas, troubleshoot, escalar

---

## Pre-Requisitos

### Hardware Requerido

| Componente | Desarrollo | Producción | Comentario |
|---|---|---|---|
| **CPU** | 1 core | 2+ cores | Recomendado: 4 cores para >500 usuarios |
| **RAM** | 512 MB | 2+ GB | JVM mínimo: 1 GB (-Xmx); con overhead: 2-3 GB total |
| **Disco** | 5 GB | 50+ GB | SSD recomendado; logs + BD pueden crecer |
| **Latencia BD** | < 100 ms | < 50 ms | Misma región/AZ es crítico para HITO 1 |
| **Networking** | Localhost | Dedicated VPC | Firewalls restringidos por default |

### Software Requerido

```
- Java: JDK 21 LTS (Adoptium o similar)
- Database: PostgreSQL 14+ con uuid-ossp extension
- Reverse Proxy: Nginx 1.24+ o Caddy 2.7+
- Container: Docker 24+, Docker Compose 2.20+
- Optional Monitoring: Prometheus 2.45+, Grafana 10+
- Optional Logging: ELK stack 8.x or cloud alternative
```

### Network Requirements

```
Ingress:
  - 443 (HTTPS) → Reverse proxy
  - 22 (SSH) → Bastion only

Egress:
  - 25 (SMTP) → Email provider (SendGrid, AWS SES)
  - 443 → OAuth providers (Google, GitHub, etc.)
  - 5432 → PostgreSQL (if external)

Internal:
  - 8080 → App health check
  - 9090 → Prometheus scrape endpoint
```

---

## Deployment Options

### Opción 1: Docker Compose (Small Production)

**Recomendado para:** < 500 usuarios activos, < 1 GB/día logs.

#### Setup

```bash
# 1. Crear estructura de directorios
mkdir -p /opt/keygo/{data,logs,backups}
cd /opt/keygo

# 2. Crear .env (nunca commit a git)
cat > .env << 'EOF'
# Database
POSTGRES_DB=keygo
POSTGRES_USER=keygo_admin
POSTGRES_PASSWORD=$(openssl rand -base64 32)
POSTGRES_INITDB_ARGS="-c ssl=on -c ssl_cert_file=/etc/ssl/certs/postgres.crt -c ssl_key_file=/etc/ssl/private/postgres.key"

# Application
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/keygo
SPRING_DATASOURCE_USERNAME=keygo_admin
SPRING_DATASOURCE_PASSWORD=${POSTGRES_PASSWORD}
KEYGO_ISSUER_BASE_URL=https://auth.example.com
KEYGO_UI_BASE_URL=https://console.example.com

# JWT Signing
KEYGO_JWT_SIGNING_KEY=$(openssl rand -base64 64)

# Email
SPRING_MAIL_HOST=smtp.sendgrid.net
SPRING_MAIL_PORT=587
SPRING_MAIL_USERNAME=apikey
SPRING_MAIL_PASSWORD=SG.xxxxxxxx...

# JVM
JAVA_OPTS=-Xms1g -Xmx2g -XX:+UseG1GC -XX:+ParallelRefProcEnabled

# Profile
SPRING_PROFILES_ACTIVE=prod
EOF

chmod 600 .env
```

#### docker-compose.yml

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:16-alpine
    container_name: keygo-postgres
    restart: unless-stopped
    volumes:
      - ./data:/var/lib/postgresql/data
      - ./backups:/backups
    env_file: .env
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U $POSTGRES_USER"]
      interval: 10s
      timeout: 5s
      retries: 5

  keygo:
    image: keygo/keygo-server:1.0
    container_name: keygo-app
    restart: unless-stopped
    depends_on:
      postgres:
        condition: service_healthy
    env_file: .env
    ports:
      - "8080:8080"
    volumes:
      - ./logs:/opt/keygo/logs
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8080/actuator/health"]
      interval: 30s
      timeout: 10s
      retries: 3
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  nginx:
    image: nginx:alpine
    container_name: keygo-proxy
    restart: unless-stopped
    ports:
      - "443:443"
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      - /etc/letsencrypt:/etc/letsencrypt:ro
    depends_on:
      - keygo
```

#### Start & Verify

```bash
# Start
docker-compose up -d

# Verify
docker-compose ps
docker-compose logs -f keygo

# Health check
curl http://localhost:8080/actuator/health
```

### Opción 2: Kubernetes (Medium to Large)

**Recomendado para:** > 500 usuarios, multi-region, enterprise.

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: keygo-server
  namespace: keygo
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: keygo-server
  template:
    metadata:
      labels:
        app: keygo-server
    spec:
      containers:
      - name: keygo
        image: keygo/keygo-server:1.0
        ports:
        - containerPort: 8080
        env:
        - name: SPRING_DATASOURCE_URL
          valueFrom:
            secretKeyRef:
              name: keygo-secrets
              key: db-url
        - name: SPRING_PROFILES_ACTIVE
          value: "prod"
        resources:
          requests:
            cpu: 500m
            memory: 1Gi
          limits:
            cpu: 1000m
            memory: 2Gi
        livenessProbe:
          httpGet:
            path: /actuator/health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /actuator/health/readiness
            port: 8080
          initialDelaySeconds: 10
          periodSeconds: 5
```

---

## Health Checks & Monitoring

### Actuator Endpoints

```bash
# Health
curl http://localhost:8080/actuator/health
# Response: {"status":"UP","components":{...}}

# Metrics
curl http://localhost:8080/actuator/metrics

# Database connectivity
curl http://localhost:8080/actuator/db
# Response: {"result":"OK"} if DB ok

# Info
curl http://localhost:8080/actuator/info
# Response: {"app":{"name":"KeyGo","version":"1.0"}}
```

### Prometheus Scrape Config

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'keygo'
    static_configs:
      - targets: ['localhost:8080']
    metrics_path: '/actuator/prometheus'
    scrape_interval: 30s
```

### Key Metrics to Watch

| Métrica | Threshold Alerta | Acción |
|---------|-----------------|--------|
| `http_requests_seconds_max` | > 5s | Posible DB slow query |
| `jvm_memory_usage_percent` | > 85% | Aumentar heap size (-Xmx) |
| `tomcat_threads_busy_threads` | > 100 | Rate limiting, scale up |
| `db_connection_pool_active` | > 90% of max | Increase pool size |
| `system_load_average_1m` | > num_cpu | CPU saturation |

---

## Troubleshooting Común

### Problema: App no inicia (503 Service Unavailable)

**Síntomas:**
- `docker logs keygo` muestra `Connection refused` o timeout en DB

**Causas posibles:**
- PostgreSQL no está listo
- Credenciales incorrectas
- Flyway migration fallando

**Solución:**
```bash
# 1. Verificar DB está corriendo
docker-compose ps postgres

# 2. Verificar logs de DB
docker-compose logs postgres | grep ERROR

# 3. Verificar credenciales en .env
grep POSTGRES_PASSWORD .env

# 4. Ejecutar migraciones manualmente
docker exec keygo ./mvnw flyway:baseline
```

### Problema: Memory Leak (Heap grows sin descanso)

**Síntomas:**
- `jvm_memory_heap_used` crece linealmente
- App muere con OutOfMemoryError

**Solución:**
```bash
# 1. Recolectar heap dump
jmap -dump:live,format=b,file=heap.bin $(pgrep java)

# 2. Analizar con Eclipse MAT o similar
# Buscar referencias retenidas

# 3. Aumentar Xmx temporalmente
export JAVA_OPTS=-Xmx4g
docker-compose restart keygo

# 4. Abrir issue con heap dump adjunto
```

### Problema: Database replication lag (Multi-region)

**Síntomas:**
- Lecturas en replica devuelven datos stale
- Discrepancia entre master y replica

**Solución:**
```bash
# 1. Ver lag en PostgreSQL
psql -c "SELECT slot_name, restart_lsn, confirmed_flush_lsn FROM pg_replication_slots;"

# 2. Si lag > 1GB, considerar:
#    - Aumentar WAL segment size
#    - Dedicar BW más ancho entre regiones
#    - Usar pglogical para replication más eficiente
```

---

## Backup & Recovery

### Estrategia: Daily Automated + Weekly Manual

```bash
# Crear script backup daily
cat > /opt/keygo/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/opt/keygo/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/keygo_db_$DATE.sql.gz"

# Dump completo
docker exec keygo-postgres pg_dump -U keygo_admin keygo | gzip > $BACKUP_FILE

# Guardar último en cloud (S3, GCS, etc.)
aws s3 cp $BACKUP_FILE s3://keygo-backups/

# Borrar backups > 30 días
find $BACKUP_DIR -name "keygo_db_*.sql.gz" -mtime +30 -delete

echo "Backup completado: $BACKUP_FILE"
EOF

chmod +x /opt/keygo/backup.sh
```

### Configurar Cron

```bash
# Backup diario a las 2 AM
0 2 * * * /opt/keygo/backup.sh >> /var/log/keygo-backup.log 2>&1
```

### Recovery Procedure

```bash
# 1. Restaurar de backup
BACKUP_FILE="/opt/keygo/backups/keygo_db_20260415_020000.sql.gz"

# 2. Stop app
docker-compose stop keygo

# 3. Restore DB
zcat $BACKUP_FILE | docker exec -i keygo-postgres psql -U keygo_admin keygo

# 4. Restart app
docker-compose up -d keygo

# 5. Verify
curl http://localhost:8080/actuator/health
```

---

## Scaling & Performance

### Vertical Scaling (Bigger Machine)

```bash
# 1. Aumentar JVM heap
export JAVA_OPTS=-Xmx4g
docker-compose restart keygo

# 2. Aumentar CPU reservation en K8s
# (edit deployment.yaml, increase resources.requests.cpu)
kubectl apply -f deployment.yaml

# 3. Monitor nuevas métricas
curl http://localhost:8080/actuator/metrics/jvm.memory.usage
```

### Horizontal Scaling (Load Balancer)

```bash
# docker-compose.yml: 2 instancias + nginx LB
services:
  keygo-1:
    image: keygo/keygo-server:1.0
    environment: ...
  keygo-2:
    image: keygo/keygo-server:1.0
    environment: ...
  nginx:
    image: nginx:alpine
    volumes:
      - ./nginx-lb.conf:/etc/nginx/nginx.conf
```

**nginx-lb.conf:**
```nginx
upstream keygo {
  server keygo-1:8080;
  server keygo-2:8080;
}

server {
  listen 80;
  location / {
    proxy_pass http://keygo;
  }
}
```

---

## Security Hardening

### 1. SSL/TLS

```bash
# Generar certificado con Let's Encrypt
certbot certonly --standalone -d auth.example.com

# Copiar a nginx
sudo cp /etc/letsencrypt/live/auth.example.com/fullchain.pem ./nginx/cert.pem
sudo cp /etc/letsencrypt/live/auth.example.com/privkey.pem ./nginx/key.pem
```

### 2. Database Encryption

```sql
-- PostgreSQL: enable SSL
ALTER SYSTEM SET ssl = on;
SELECT pg_reload_conf();

-- Enable encrypted columns (if sensitive data)
-- Use pgcrypto extension
CREATE EXTENSION pgcrypto;
ALTER TABLE users ADD COLUMN phone_encrypted BYTEA;
UPDATE users SET phone_encrypted = pgp_sym_encrypt(phone, 'encryption-key');
```

### 3. Firewall Rules

```bash
# Allow only HTTPS
ufw allow 443/tcp
ufw allow 22/tcp  # SSH from bastion only
ufw deny 8080    # Deny direct app access
ufw enable
```

### 4. Secret Management

```bash
# Use .env with restricted permissions
chmod 600 /opt/keygo/.env

# Or use environment-specific secrets manager
# - AWS Secrets Manager
# - HashiCorp Vault
# - Azure Key Vault
```

---

## Runbooks de Incidentes

### Incident: High Error Rate (> 5% 5xx errors)

```
1. CHECK metrics
   curl http://localhost:8080/actuator/metrics/http.server.requests

2. CHECK logs for patterns
   docker logs keygo | grep ERROR | tail -50

3. SUSPECT: Database connectivity
   - Check DB connection pool: _db_connections_active_
   - If maxed out: scale DB or app

4. SUSPECT: Memory pressure
   - Check jvm_memory_usage
   - If > 90%: restart app, increase -Xmx

5. ACTION: Scale horizontally if needed
   docker-compose up -d --scale keygo=2

6. MONITOR: For 15 minutes
   curl http://localhost:8080/actuator/metrics | grep http
```

### Incident: Database CPU at 100%

```
1. CHECK slow queries
   SELECT * FROM pg_stat_statements 
   ORDER BY mean_exec_time DESC LIMIT 10;

2. KILL long-running queries if needed
   SELECT pg_terminate_backend(pid) 
   FROM pg_stat_activity 
   WHERE duration > interval '30 minutes';

3. PLAN: Add index or optimize query
   - Report to dev team
   - Add to next sprint

4. IMMEDIATE: Restart DB connection pool
   docker-compose restart keygo
```

---

## Escalation & SLA

### On-Call Escalation Tree

```
Level 1 (First response):
  - Check health: /actuator/health
  - Read recent logs
  - Restart service if hung

Level 2 (If not resolved in 15 min):
  - Escalate to SRE team lead
  - Page database specialist if DB issue

Level 3 (If not resolved in 1 hour):
  - Escalate to VP Engineering
  - Consider rollback to last stable version
```

### SLA Targets

| Metric | Target | Consequence |
|--------|--------|-------------|
| **Availability** | 99.9% | 8.76 hours/year downtime |
| **MTTR** | < 30 min | Incident response must engage < 5 min |
| **Recovery Time** | < 15 min | Failover automated or manual restart |

---

## Véase También

- **observability.md** — Logs, Metrics, Traces (correlate with runbook alerts)
- **bootstrap-filter-routes.md** — Understand public endpoints for health checks
- **incident-response-guide.md** — Full postmortem + escalation process
- **deployment/pipeline-strategy.md** — How new versions are released (revert procedure)

---

**Última actualización:** 2025-Q1 | **Mantenedor:** DevOps/SRE | **Licencia:** Keygo Docs
