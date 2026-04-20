[← Índice](./README.md) | [< Anterior](./cicd.md)

---

# Release Process

Proceso de release, versionado y deployment a producción.

## Contenido

- [Release Strategy](#release-strategy)
- [Versioning](#versioning)
- [Release Checklist](#release-checklist)
- [Deployment](#deployment)
- [Post-Deployment](#post-deployment)
- [Rollback](#rollback)
- [Disaster Recovery](#disaster-recovery)

---

## Release Strategy

### Flujo de Release

```
develop ──[PR]──► main ──[tag]──► staging ──[approval]──► production
                │              │
                │              │
                ▼              ▼
             dev (auto)    prod (manual)
```

### Tipos de Release

| Tipo | Frecuencia | Comandos |
|------|------------|----------|
| **Patch** | Cuando se necesario | Bug fixes urgentes |
| **Minor** | Mensual | Nuevas features compatibles |
| **Major** | Trimestral | Breaking changes |

[↑ Volver al inicio](#release-process)

---

## Versioning

### Git Tags

```bash
# Crear tag
git tag -a v1.0.0 -m "Release v1.0.0"

# Firmar tag (GPG)
git tag -s v1.0.0 -m "Release v1.0.0"

# Push tag
git push origin v1.0.0
```

### Versionado Semántico

| Componente | Cambio |
|------------|--------|
| **Major** | Breaking changes (API incompatible) |
| **Minor** | Nuevas features (compatibles) |
| **Patch** | Bug fixes |

### Changelog

Cada release incluye:
- Fecha
- Features nuevos
- Bug fixes
- Deprecaciones
- Contributors

[↑ Volver al inicio](#release-process)

---

## Release Checklist

### Antes de Release

- [ ] Todos los tests pasando (unit, integration, smoke)
- [ ] Code coverage ≥ 75%
- [ ] SonarQube quality gate passed
- [ ] Snyk scan sin high/critical CVEs
- [ ] Imagen Docker firmada con Cosign
- [ ] Database migrations probadas en staging
- [ ] Rollback plan documentado
- [ ] Monitoreo configurado
- [ ] Equipo notificado

### Durante Release

- [ ] Backup creado
- [ ] Rolling update en progreso
- [ ] No más de 1 pod unavailable
- [ ] Smoke tests pasando
- [ ] Métricas estables (error rate < 1%, latency < 2s)

### Después de Release

- [ ] Todos los pods healthy
- [ ] Logs sin ERRORS
- [ ] Métricas estables
- [ ] Usuarios sin Issues
- [ ] Runbook actualizado
- [ ] Retrospective programado (si hubo issues)

[↑ Volver al inicio](#release-process)

---

## Deployment

### Trigger Manual

```bash
# via GitHub UI
gh workflow run deploy-prod.yml -f version=v1.0.0
```

### Helm Commands

```bash
# Dry run
helm upgrade keygo-server ./helm -f helm/values-prod.yaml --dry-run --debug

# Deploy
helm upgrade keygo-server ./helm -f helm/values-prod.yaml \
  --namespace production \
  --wait \
  --timeout 15m \
  --atomic

# Verificar
kubectl rollout status deployment/keygo-server -n production
```

[↑ Volver al inicio](#release-process)

---

## Post-Deployment

### Verificación

```bash
# Health check
curl -f https://api.keygo.io/actuator/health

# Service info
curl https://api.keygo.io/api/v1/platform/service-info

# Metrics
curl https://api.keygo.io/actuator/prometheus | grep http_requests
```

### Notificación

```json
{
  "text": "✅ Production deployment successful",
  "version": "v1.0.0",
  "status_page": "https://api.keygo.io/actuator/health"
}
```

[↑ Volver al inicio](#release-process)

---

## Rollback

### Automático

El deployment use `--atomic` hace rollback automático si falla.

### Manual

```bash
# List revisions
helm history keygo-server -n production

# Rollback to previous
helm rollout undo keygo-server -n production

# Rollback to specific
helm rollout undo keygo-server -n production --revision=3
```

### Trigger Automático por Métricas

```bash
# Si error rate > 5%
ERROR_RATE=$(curl -s ... | grep '5xx' | awk '{print $2}')
if [ "$ERROR_RATE" > 5 ]; then
  helm rollout undo keygo-server -n production
fi
```

[↑ Volver al inicio](#release-process)

---

## Disaster Recovery

### DB Restore

```bash
# List backups
aws s3 ls s3://keygo-backups/

# Restore
gunzip < s3://keygo-backups/prod-20260410_120000.sql.gz | \
  kubectl exec -i -n production keygo-postgres -- \
  psql -U keygo keygo
```

### Cluster Recovery

```bash
# Delete and recreate namespace
kubectl delete namespace production
kubectl create namespace production

# Redeploy
helm install keygo-server ./helm \
  -f helm/values-prod.yaml \
  --namespace production \
  --wait
```

### Contactos de Emergencia

| Recurso | Contacto |
|---------|----------|
| DBA On-Call | +1-555-0199 |
| DevOps Lead | +1-555-0188 |
| Engineering Manager | +1-555-0177 |

[↑ Volver al inicio](#release-process)

---

[← Índice](./README.md) | [< Anterior](./cicd.md)