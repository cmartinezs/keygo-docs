[← Índice](./README.md)

---

# Retrospectives: Aprendizajes por Ciclo SDLC

Retrospectivas que capturan aprendizajes, decisiones validadas, problemas descobertos y acciones para el próximo ciclo. Cada retro se organiza por **Bounded Context**, enfatizando cómo DDD y multi-tenancy informan evoluciones futuras del sistema.

---

## Contenido

- [Estructura de una Retrospective](#estructura-de-una-retrospective)
- [Ciclo N: Discovery → Requirements](#ciclo-n-discovery--requirements)
- [Ciclo N+1: Design & Data Model](#ciclo-n1-design--data-model)
- [Ciclo N+2: Development → Operations](#ciclo-n2-development--operations)
- [Retrospectives by Bounded Context](#retrospectives-by-bounded-context)
- [DDD Maturity Assessment](#ddd-maturity-assessment)

---

## Estructura de una Retrospective

Cada retrospective sigue esta estructura:

```
## [Ciclo X]: Fase1 → Fase2

**Timeline**: [fecha inicio] - [fecha fin]
**Equipo**: [rol/área]
**Contextos Primarios**: [Identity, Access Control, ...]

### ✅ Qué Funcionó Bien

- [Decisión DDD validada]
- [Patrón que funcionó]
- [Capacidad que emergió]

**Evidencia**: [métrica, feedback, cambio de código]

### ⚠️ Problemas Descobertos

- [Anti-pattern detectado]
- [Acoplamiento no esperado]
- [Gap en el modelo]

**Impacto**: [dónde se manifestó, qué usuarios afectó]

### 🔧 Acciones para Próximo Ciclo

| Acción | Contexto | Propósito | Prioridad |
|--------|----------|----------|-----------|
| [Descripción] | [Identity/Access/...] | [Corregir/Mejorar] | P0/P1/P2 |

### 📊 Métricas

| Métrica | Valor | Trend |
|---------|-------|-------|
| NPS Promedio | 7.2 | ↗ |
| Bugs por Contexto | Identity: 3, Access: 5 | → |
| Deployment Frequency | 2.3 days | ↗ |

### 🎯 Next Cycle Focus

[Síntesis: qué hacer diferente basado en aprendizajes]

---
```

---

## Ciclo N: Discovery → Requirements

**Timeline**: Fase SP-D1 → SP-D2
**Equipo**: Product, Domain Experts
**Contextos Primarios**: Todos (modelado inicial)

### ✅ Qué Funcionó Bien

- **Separación de Contextos**: La colaboración entre domain experts reveló 7 Bounded Contexts claramente diferenciados (Identity, Access Control, Organization, Client Apps, Billing, Audit, Platform). Cada uno con lenguaje y preocupaciones distintas.
- **Ubiquitous Language Early**: Definir la lengua de negocio desde el principio (ej. "RoleAssigner" no "Manager") evitó confusiones posteriores.
- **Stakeholder Alignment**: Actores y sus necesidades mapeadas por contexto → cuando llegó desarrollo, el equipo entendió para quién construía.

**Evidencia**: Cero conflictos de interpretación entre discovery y requirements. Transición suave desde "qué" al "cómo".

### ⚠️ Problemas Descobertos

- **Tenant Personas Incompletas**: Inicialmente asumimos 3 planes (Enterprise, Standard, Community), pero feedback post-lanzamiento reveló un cuarto tipo: "Startups en Crecimiento". Esto cambió expectativas de features.
- **Multi-tenant Implications Underestimated**: El discovery fue agnóstico de tenants; cuando llegó diseño, preguntas de "¿Qué datos son compartidos? ¿Qué es por-tenant?" no tenían respuesta. 

**Impacto**: Requirió retrabajo en data model para garantizar aislamiento. Retrasos en Deployment.

### 🔧 Acciones para Próximo Ciclo

| Acción | Contexto | Propósito | Prioridad |
|--------|----------|----------|-----------|
| Expandir Personas a 4 tipos de tenant | Platform | Reflejar realidad de mercado | P0 |
| Añadir "Multi-Tenancy Implications" checklist a Discovery | Platform | Evitar surpresas en diseño | P1 |
| Incluir domain experts de Operations en Requirements | Audit, Platform | Validar que capacidades de monitoreo cierren loops | P1 |

### 📊 Métricas

| Métrica | Valor | Trend |
|---------|-------|-------|
| Contextos Identificados | 7 | ✓ |
| Stakeholder Consensus | 95% | ↗ |
| Rework en Data Model | 1 ciclo | — |

### 🎯 Next Cycle Focus

Incluir perspectiva multi-tenant desde Discovery. Expandir Personas. Traer Operations y Audit al conversation temprano.

---

## Ciclo N+1: Design & Data Model

**Timeline**: Fase SP-D3 → SP-D5
**Equipo**: Architecture, Domain Experts, Data Engineers
**Contextos Primarios**: Todos (diseño de flujos) + Data Model

### ✅ Qué Funcionó Bien

- **Aggregate Design by Context**: Diseñar agregates separados por contexto (Identity.User ≠ Organization.User) eliminó coupling y permitió que cada contexto evolucionara independientemente.
- **Anti-Corruption Layer Concept**: La idea de un ACL como barrera defensiva evitó que modelos externos (Stripe, Identity Providers) polúen el dominio.
- **Forward-Compatible Migrations**: Planificar migraciones (nullable columns → backfill → NOT NULL) permitió lanzar cambios sin downtime multi-tenant.

**Evidencia**: Cambios posteriores a un contexto no necesitaron refactoring en otros. Integraciones con proveedores externos sin fricción.

### ⚠️ Problemas Descobertos

- **Value Object Immutability Gaps**: Algunos Value Objects (Money, Address) no fueron diseñados como truly immutable. Esto llevó a bugs sutiles donde mutations no se persistían.
- **Domain Event Strategy Undefined**: La data model no tenía clara la estrategia: ¿eventos stored como facts o just notifications? Esto generó ambigüedad en testing.
- **Multi-Tenant Isolation in Design**: El diagrama ERD mostró tablas compartidas con tenant_id, pero algunas consultas asumían tenant global. RLS (Row-Level Security) no estaba diseñado en.

**Impacto**: Bugs en estado de Value Objects. Confusión en testing. Data leaks potenciales si RLS no se implementaba.

### 🔧 Acciones para Próximo Ciclo

| Acción | Contexto | Propósito | Prioridad |
|--------|----------|----------|-----------|
| Enforce Value Object immutability in code generation | Identity, Billing | Prevenir mutation bugs | P0 |
| Define Domain Event Storage Strategy | All | Event sourcing vs. just notifications | P1 |
| Add RLS templates per Context to Data Model | Organization, Billing | Garantizar tenant isolation | P0 |
| Document ACL checklist for external integrations | Platform | Reusable template para nuevas integraciones | P2 |

### 📊 Métricas

| Métrica | Valor | Trend |
|---------|-------|-------|
| Agregates per Context | 3-5 | ✓ |
| Value Object Immutability Violations | 4 | ↘ (después acción) |
| Zero-Downtime Migrations | 100% | ↗ |

### 🎯 Next Cycle Focus

Enfatizar inmutabilidad en Value Objects. Definir estrategia de eventos claramente antes de coding. Integrar RLS desde el día 1 de desarrollo.

---

## Ciclo N+2: Development → Operations

**Timeline**: Fase SP-D6 → SP-D10
**Equipo**: Engineering, DevOps, On-Call Engineers
**Contextos Primarios**: Identity, Access Control, Billing (más fricción operacional)

### ✅ Qué Funcionó Bien

- **Bounded Context Packages**: Organizar código como `keygo-domain/identity/`, `keygo-domain/access/`, etc. hizo clair dónde vive lógica. Zero cross-context dependencies.
- **Ubiquitous Language in Code Enforcement**: Code review checklist "¿Experto en dominio entendería este nombre?" evitó nombres técnicos como "ProcessorService".
- **Repository Abstraction**: Business logic nunca vio SQL. Cambios de persistence (relacional → document) podrían hacerse sin afectar agregates.
- **DDD-Driven Testing**: Testing por agregates + Value Objects + domain events en lugar de "API tests" resultó en cobertura más precisa y rápida.
- **Multi-Tenant Feature Flags**: Desplegar features gated por tenant permitió Enterprise usar SSO día 1, Standard día 3, sin redeployments.

**Evidencia**: 
- Code review cycle: 1.5 horas promedio (antes: 4 horas con debates de naming)
- Test execution time: 8 minutos para full suite (antes: 22 minutos con tests acoplados)
- Deployment velocity: 3-4 features/week por contexto
- Zero cross-tenant data leaks en 6 meses de ops

### ⚠️ Problemas Descobertos

- **Incident Scope Diagnosis Friction**: Cuando un incident ocurría, no era claro si era single-tenant o multi-tenant. Perdimos 15 minutos en incidents típicamente.
- **Billing Context Complexity**: El agregado `Subscription` hizo demasiado (billing + feature entitlements + metering). Acoplamiento oculto emergió bajo load.
- **Monitoring Gaps by Context**: Alertas genéricas (CPU, memory) no capturaban contexto-specific issues (ej. "Identity auth latency spike" ≠ "Access Control permission denials").
- **Tenant Plan Differences in Ops**: Enterprise esperaba 15-minute SEV1 response; Community 4-hour. Runbooks no diferenciaban → SLA breaches en Community.

**Impacto**:
- MTTR 25 min promedio (target: 15 min para Enterprise)
- Billing bugs relacionados con feature flags requirieron hotfixes
- Pagerduty alertas generaron "alert fatigue" (90% false positives)

### 🔧 Acciones para Próximo Ciclo

| Acción | Contexto | Propósito | Prioridad |
|--------|----------|----------|-----------|
| Add Incident Scope Diagnosis SOP | Platform | Quick decision: single-tenant vs multi | P0 |
| Split Subscription aggregate | Billing | Separate subscriptions (billing) from entitlements (access) | P0 |
| Context-Specific PromQL Queries | All | Monitoring por Identity, Access, Billing, etc. | P1 |
| Tenant-Aware SLAs in Incident Response | Platform | Different SEV definitions by plan | P0 |
| Feature Flag Audit Trail | Billing | Trazabilidad de entitlements changes | P1 |

### 📊 Métricas

| Métrica | Valor | Trend |
|---------|-------|-------|
| MTTR Enterprise | 24 min | ↘ (target: 15) |
| MTTR Community | 180 min | ↙ (SLA breaches) |
| Code Review Cycle | 1.5 hrs | ↗ (good) |
| Test Execution | 8 min | ↗ (good) |
| Deployment Frequency | 3-4 features/week | ↗ (good) |
| NPS by Tenant | Enterprise: 8.5, Community: 6.2 | — |
| Multi-tenant Data Incidents | 0 | ✓ |

### 🎯 Next Cycle Focus

Incident response debe ser multi-tenant-aware desde el primer día. Billing agregates deben ser más granulares. Monitoring debe hablar el lenguaje del dominio, no del infrastructure.

---

## Retrospectives by Bounded Context

Cada Bounded Context acumula lecciones propias. A continuación, síntesis por contexto:

### Identity Context

**Key Learnings**:
- Value Object `Password` debe encapsular hashing logic. Evita que developers usen plaintext passwords.
- Event `UserAuthenticated` debe capturar `method` (SSO vs local) para auditoría.
- ACL con Identity Providers (Okta, Azure AD) requiere retry + exponential backoff.

**DDD Maturity**: 8/10 — Ubiquitous language fuerte, agregates bien scoped, events claros. Gap: RLS no estava en el modelo inicial.

---

### Access Control Context

**Key Learnings**:
- Role-Based vs Attribute-Based decisión impactó enormemente el design. ABAC es más flexible pero requiere policy language (similar a Rego).
- Permission Denials deben ser logeadas como events para auditoría.
- Aggregate `RoleAssignment` puede ser separado de `Permission`. Permite que tenants cambien roles sin recompilar permisos.

**DDD Maturity**: 7/10 — Buena separación de agregates. Gap: policy language no fue modelado en dominio, vive en configuración. Próxima iteración: traer como Value Object.

---

### Billing Context

**Key Learnings**:
- Aggregate `Subscription` mezclaba billing con entitlements. Debería ser dos: `BillingSubscription` (pagos) + `TenantEntitlements` (features).
- `Invoice` debería ser event-sourced para auditoría.
- Feature-flag based billing requiere audit trail de cada decision: "¿Por qué este tenant tiene SSO if no lo pagó?"

**DDD Maturity**: 6/10 — Modelo inicia agnóstico de multi-tenancy. Gaps: feature entitlements no fueron distinguidas de billing. Próxima: separar agregates, introducir `FeatureEntitlement` Value Object.

---

### Audit Context

**Key Learnings**:
- Event sourcing natural para Audit. Every domain event genera audit event.
- Tenant isolation crítica: audit de Tenant A no debe ver eventos de Tenant B.
- Correlation IDs permiten trazar una acción a través de múltiples contextos.

**DDD Maturity**: 9/10 — Diseño fue puro event sourcing desde el inicio. Modelo refleja bien auditing requirements.

---

### Organization Context

**Key Learnings**:
- Aggregate `Team` puede contener `Members`. Pero si members != users, se necesita un `TeamMember` Value Object.
- Invitaciones son transient state. Pueden ser events + TTL.

**DDD Maturity**: 7/10 — Buen modelo conceptual. Gap: member lifecycle (invite → accept → remove) no fue modelado claramente como state machine.

---

### Client Apps Context

**Key Learnings**:
- `ClientApp` (OAuth client) es un Entity, no Value Object. Tiene identidad duradera.
- Secrets deben ser rotable sin cambiar app ID. Modelo de `Secret` como separado agreggate.
- Redirect URI validation es critical. Debe ser parte del aggregate invariants.

**DDD Maturity**: 8/10 — Security constraints fueron modelados bien. Gap: secret rotation no fue anticipada, agregada post-hoc.

---

### Platform Context

**Key Learnings**:
- Multi-tenant governance es complejo. Necesita su propio model dentro de Platform Context.
- Feature flags, tenant configuration, SLA definitions todas viven aquí.
- Platform events (tenant created, plan upgraded) generan acciones en otros contextos.

**DDD Maturity**: 6/10 — Emergente. Inicialmente fue "grab bag" de features no clasificadas. Próxima: clearer boundaries y ubiquitous language.

---

## DDD Maturity Assessment

**Definición**: 10/10 = Ubiquitous Language clara y enforced, agregates pequeños y cohesivos, ACLs en todos los boundaries externos, eventos como backbone de integración.

| Contexto | Maturity | Strengths | Gaps | Next Action |
|----------|----------|-----------|------|------------|
| Identity | 8/10 | Value Objects claros, SSO ACL bien hecho | RLS no en modelo | Integrar tenant checks en agregates |
| Access Control | 7/10 | Role aggregates seprados de permisos | Policy language técnico, no dominio | Traer Rego-like policies como VO |
| Organization | 7/10 | Team/Member bien modelados | Lifecycle de invitaciones ad-hoc | State machine para member invites |
| Client Apps | 8/10 | Security constraints bien modelados | Secret rotation post-hoc | Añadir ` SecretVersion` aggregate |
| Billing | 6/10 | Basic invoicing | Entitlements mezcladas, no event-sourced | Split aggregates, introducir eventos |
| Audit | 9/10 | Pure event sourcing | Ninguno significativo | Mantener |
| Platform | 6/10 | Governance emergente | Limites borrosos, VO inconsistentes | Consolidar ubiquitous language |

---

## Key Takeaways for Next Cycle

1. **DDD is a Practice, Not a Checkbox**: Maturing from 6/10 to 8/10 requiere refinamiento iterativo, no rewrite.
2. **Multi-Tenancy Changes Everything**: Agregates, ACLs, testing, monitoring — todo se vuelve tenant-aware. Planificar desde fase Discovery.
3. **Events are the Integration Glue**: Domain events, no service calls, es cómo contextos se hablan limpiamente.
4. **Monitoring Must Speak the Domain**: "Identity auth latency" > "API p99 response time".
5. **Incident Response Varies by Tenant Plan**: Single incident puede ser SEV2 para Community, SEV1 para Enterprise. Ops debe entenderlo.

---

↑ [Volver al inicio](#retrospectives-aprendizajes-por-ciclo-sdlc)

---

[← Volver a Feedback](./README.md)
