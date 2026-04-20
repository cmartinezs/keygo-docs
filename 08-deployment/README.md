[← HOME](../README.md)

---

# Deployment

Fase de documentación de pipelines CI/CD, ambientes y estrategias de release, con énfasis en automatización, seguridad y multi-tenancy.

## Contenido

- [Resumen](#resumen)
- [Environments](./environments.md) — Dev, Staging, Production y configuración multi-tenant
- [CI/CD Pipeline](./cicd.md) — GitHub Actions, security scanning, automatización
- [Release Process](./release-process.md) — Versionado, checklist, deployment, rollback
- [Deployment Strategies](#deployment-strategies) — Blue-Green, Canary, Feature Flags

---

## Resumen

| Artefacto | Descripción |
|-----------|-------------|
| [environments.md](./environments.md) | Dev (auto-deploy), Staging (manual), Production (manual + approval) |
| [cicd.md](./cicd.md) | GitHub Actions, SAST, dependency scanning, image signing |
| [release-process.md](./release-process.md) | Versionado semántico, checklist, rollback, disaster recovery |

[↑ Volver al inicio](#deployment)

---

## Deployment Strategies

### Blue-Green Deployment

Mantener dos ambientes idénticos (Blue y Green). El tráfico apunta a Blue. El nuevo release se despliega en Green. Después de validación, el tráfico cambia.

**Ventajas:**
- Zero downtime
- Rollback instantáneo
- Testing en prod-like antes de switch

**En KeyGo (Multi-tenant):**
```
┌──────────────────────────────────┐
│ Load Balancer                      │
│ (Dirección tráfico)               │
└────────────────┬──────────────────┘
                 │
        ┌────────┴────────┐
        ▼                 ▼
   ┌─────────┐       ┌─────────┐
   │  Blue   │       │  Green  │
   │(Active) │       │(Standby)│
   │v1.0.0   │       │v1.1.0   │
   └─────────┘       └─────────┘
        ▲                 │
        │                 │
        └─────────────────┘
    (switch después de validar)
```

**Requisitos multi-tenant:**
- Base de datos compartida (ambientes comparten BD)
- Migraciones deben ser forward-compatible
- Estados de tenant se sincronizan automáticamente

### Canary Deployment

Desplegar nueva versión en pequeño porcentaje de tráfico. Monitor qué ocurre. Gradualmente aumentar.

**Fases:**
- 5% tráfico → 15 min observación
- 25% tráfico → 30 min observación
- 50% tráfico → 30 min observación
- 100% tráfico

**En KeyGo:**
```bash
# Canary weights (Istio)
kubectl apply -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: keygo-canary
spec:
  hosts:
  - api.keygo.io
  http:
  - match:
    - headers:
        user-agent:
          regex: ".*Chrome.*"  # 5% de Chrome users
    route:
    - destination:
        host: keygo-v1.1.0
      weight: 100
  - route:
    - destination:
        host: keygo-v1.0.0
      weight: 100
EOF
```

**Métricas a monitorear:**
- Error rate (vs baseline)
- Latency p95 (vs baseline)
- Tenant-specific errors (algún tenant afectado?)

### Feature Flags (Deployable but Dark)

Desplegar código que no está activo aún. Permite releases sin activar features.

**En KeyGo:**
```java
@Component
public class FeatureFlagService {
  private final FeatureFlagRepository repository;
  
  public boolean isEnabled(String featureName, String tenantSlug) {
    return repository.findByNameAndTenant(featureName, tenantSlug)
        .map(FeatureFlag::isEnabled)
        .orElse(false);
  }
}

// En código
@GetMapping("/api/v1/tenants/{slug}/advanced-search")
public ResponseEntity<?> advancedSearch(...) {
  if (!featureFlags.isEnabled("ADVANCED_SEARCH", tenantSlug)) {
    return ResponseEntity.status(404).build();  // Feature not available
  }
  // Lógica de búsqueda avanzada
}
```

**Multi-tenant control:**
- Habilitar por tenant (gradual rollout)
- A/B testing por tenant
- Rollback instant sin deploy

[↑ Volver al inicio](#deployment)

---

## Cómo Navegar

1. **Primero**: Lee [environments.md](./environments.md) para entender Dev/Staging/Prod
2. **Pipeline**: Consulta [cicd.md](./cicd.md) para ver cómo se automatiza build + security
3. **Release**: Revisa [release-process.md](./release-process.md) para el flujo de versionado y deployment
4. **Estrategias**: Aplica Blue-Green, Canary o Feature Flags según el cambio

---

[← HOME](../README.md) | [Siguiente >](./environments.md)