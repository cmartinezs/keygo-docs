[← Índice](./README.md)

---

# Runbook

Guía operativa para desplegar, monitorear y mantener KeyGo en producción.

## Contenido

- [Pre-Requisitos](#pre-requisitos)
- [Deployment](#deployment)
- [Monitoreo](#monitoreo)
- [Mantenimiento](#mantenimiento)
- [Escalamiento](#escalamiento)
- [Emergency Contacts](#emergency-contacts)

---

## Pre-Requisitos

### Hardware Mínimo

| Componente | Desarrollo | Producción |
|---|---|---|
| **CPU** | 1 core | 2+ cores |
| **RAM** | 512 MB | 2+ GB |
| **Disco** | 5 GB | 50+ GB |
| **Latencia BD** | < 100ms | < 50ms |

### Software Requerido

- Java 21+ (LTS)
- PostgreSQL 14+
- Docker + Kubernetes
- Prometheus + Grafana

 [↑ Volver al inicio](#runbook)

---

## Deployment

### Docker Compose (Simple)

**Para:** Hasta 100 usuarios.

```bash
# 1. Preparar entorno
cat > .env << EOF
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/keygo
SPRING_DATASOURCE_USERNAME=keygo
SPRING_DATASOURCE_PASSWORD=<strong-password>
KEYGO_ISSUER_BASE_URL=https://keygo.example.com
KEYGO_CORS_ALLOWED_ORIGINS=https://app.example.com,https://console.example.com
JAVA_OPTS=-Xms1g -Xmx2g -XX:+UseG1GC
SPRING_PROFILES_ACTIVE=prod
EOF

# 2. Levantar
docker-compose up -d

# 3. Verificar
curl -f http://localhost:8080/actuator/health
```

### Kubernetes (Producción)

```bash
# 1. Namespace
kubectl create namespace production

# 2. Secrets
kubectl create secret generic keygo-secrets \
  --from-literal=DB_PASSWORD='<strong-password>' \
  --from-literal=JWT_SECRET='<jwt-key>' \
  -n production

# 3. Deploy
kubectl apply -f helm/values-prod.yaml -n production

# 4. Verificar
kubectl rollout status deployment/keygo-server -n production
kubectl get pods -n production
```

 [↑ Volver al inicio](#runbook)

---

## Monitoreo

### Health Checks

```bash
# Application
curl http://localhost:8080/actuator/health

# Database
curl http://localhost:8080/actuator/health/db

# Disk
curl http://localhost:8080/actuator/health/disk
```

### Métricas Clave

| Métrica | Umbral | Acción |
|---------|-------|--------|
| Error rate 5xx | > 1% | Page oncall |
| Latencia p99 | > 5s | Investigar |
| Heap usage | > 80% | Monitor GC |
| DB connections | > 90% | Investigar queries |

### Logs

```bash
#tail -f /var/log/keygo/app.log
grep ERROR /var/log/keygo/app.log | tail -50
```

 [↑ Volver al inicio](#runbook)

---

## Mantenimiento

### Restart

```bash
# Docker
docker-compose restart keygo-server

# Kubernetes
kubectl rollout restart deployment/keygo-server -n production
```

### Database Backup

```bash
# Manual backup
kubectl exec -n production keygo-postgres -- \
  pg_dump -U keygo keygo | gzip > /tmp/backup.sql.gz
```

### Logs Rotation

```bash
# Configurar logrotate
/etc/logrotate.d/keygo {
  daily
  rotate 30
  compress
  missingok
}
```

 [↑ Volver al inicio](#runbook)

---

## Escalamiento

### Vertical

```yaml
# kubernetes/values.yaml
resources:
  limits:
    cpu: 4
    memory: 4Gi
  requests:
    cpu: 2
    memory: 2Gi
```

### Horizontal

```yaml
autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
```

 [↑ Volver al inicio](#runbook)

---

## Emergency Contacts

| Rol | Contacto |
|-----|---------|
| DevOps Lead | +1-555-0188 |
| DBA On-Call | +1-555-0199 |
| Engineering Manager | +1-555-0177 |

 [↑ Volver al inicio](#runbook)

---

[← Índice](./README.md)