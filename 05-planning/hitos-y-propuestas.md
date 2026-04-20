# Hitos y Propuestas de Desarrollo — KeyGo Server

> **Descripción:** Roadmap detallado de 4 hitos principales (Q2 2026), desglosado en propuestas de trabajo (T-NNN, V-NNN, F-NNN) con effort estimates, dependencias y deliverables. Única fuente de verdad para planificación de desarrollo y asignación de recursos.

**Fecha:** 2026-04-20  
**Versión:** 1.0  
**Horizonte:** 2026-04-05 a 2026-08-26 (5 meses, 51 semanas)

---

## Índice

1. [Visión General](#visión-general)
2. [HITO 1: Hosted Login Seguro & Documentación](#hito-1-hosted-login-seguro--documentación-p0--4-semanas)
3. [HITO 2: Pré-Monetización & Stability](#hito-2-pré-monetización--stability-p1--4-semanas)
4. [HITO 3: Gateway Real & Renovación](#hito-3-gateway-real--renovación-p1--6-semanas)
5. [HITO 4: Multi-Dominio & Hardening](#hito-4-multi-dominio--hardening-p1--6-semanas)
6. [HITO 5: Largo Plazo (Post-Monetización)](#hito-5-largo-plazo--post-monetización-p2p3--16-semanas)
7. [Resumen Consolidado](#resumen-consolidado)

---

## Visión General

### Objetivos Estratégicos por Horizonte

| Horizonte | Objetivo | Status | Capacidad Agregada |
|---|---|---|---|
| **Corto Plazo (4 sem)** | Solidificar hosted login seguro; documentación centralizada; deuda técnica menor | 🟡 En ejecución | 38 ✅ + 2 🟡 = 40/58 (69%) |
| **Mediano Plazo (8 sem)** | Multi-dominio hardening (auth → payment), gateway real, renewal automática | 🔲 No iniciado | + 8 🔲 = 48/58 (83%) |
| **Largo Plazo (16 sem)** | Observabilidad avanzada, SCIM, federated session, multi-moneda | 🔲 No iniciado | + 10 🔲 = 58/58 (100%) |

### Dependencias Críticas

```
HITO 1 (51h)
├─ Core auth + tenant isolation
└─ Foundation para HITO 2 ✅

HITO 2 (81h)
├─ Billing MVP (sin gateway real)
├─ Tests integración
└─ Foundation para HITO 3

HITO 3 (94h)
├─ Gateway Stripe/MercadoPago
├─ Auto-renewal + dunning
└─ Monetización possible

HITO 4 (96h)
├─ Multi-dominio contract
├─ BFF pattern
└─ Observabilidad avanzada
```

---

## HITO 1: Hosted Login Seguro & Documentación (P0 — 4 semanas)

**Período:** 2026-04-05 a 2026-05-03  
**Objetivo:** MVP lanzable con documentación de referencia única  
**Prioridad:** 🔴 CRÍTICO (P0)  
**Esfuerzo Total:** 51 horas (~6 dev-days)

### Propuestas Incluidas

| ID | Tipo | Propuesta | Status | Esfuerzo | Bloqueador | Contexto |
|---|---|---|---|---|---|---|
| **T-030** | 📋 Doc | Verificación referencias Markdown rotas post-reorganización | 🔲 | 4h | — | DevOps |
| **T-031** | 🤖 CI | Automatizar verificación links rotos en CI (lychee/markdown-link-check) | 🔲 | 6h | T-030 | DevOps |
| **T-023** | ⚙️ QA | Configurar lint/formato (Checkstyle/Spotless) | 🔲 | 8h | — | DevOps |
| **V-067** | 🔧 Refactor | Eliminar `SigningKeyBootstrapService` redundante | 🔲 | 2h | — | AUTH |
| **T-051** | 🔐 Feature | Suite autorización por endpoint (@PreAuthorize matriz) | 🔲 | 12h | — | TENANTS |
| **T-035** | 🔐 Security | Detección replay attack: USED token → revocar cadena | 🔲 | 6h | — | AUTH |
| **T-062** | 🐛 Fix | Handler específico `MissingServletRequestParameterException` → 400 | 🔲 | 4h | — | Platform |
| **T-036** | ⚙️ Config | TTL configurable refresh tokens (`application.yml`) | 🔲 | 3h | — | AUTH |
| **T-043** | 🔐 Feature | Scope filtering en `/userinfo` (profile, email, phone) | 🔲 | 6h | — | AUTH |

### Deliverables

✅ **Core Security**
- Verificación de referencias Markdown completadas
- CI/CD enforcement de links válidos
- Lint + formato automático en CI
- Replay attack detection funcional (T-035)
- Scope filtering en userinfo (T-043)

✅ **Code Quality**
- Redundancia signing key eliminada (V-067)
- Matriz @PreAuthorize exhaustiva (T-051)
- Configuración linting (Checkstyle/Spotless)
- Error handler mejorado (T-062)

✅ **Documentación**
- use-cases-catalog.md (52 UC documentados)
- capability-matrix.md (58 capacidades mapeadas)
- technical-constraints.md (restricciones codificadas)
- glossary-technical.md (40+ términos del stack)

### Plan de Ejecución

**Semana 1 (12h):** T-023, T-030, T-031
- Lint setup (Checkstyle, Spotless, pre-commit hooks)
- Markdown reference validation
- CI enforcement

**Semana 2 (14h):** V-067, T-051, T-062
- Eliminar redundancia
- @PreAuthorize matriz (completar coverage)
- Handler exception mejorado

**Semana 3 (12h):** T-035, T-036, T-043
- Replay attack detection
- TTL configurable refresh tokens
- Scope filtering endpoint

**Semana 4 (13h):** Documentation + Testing
- Validación de todos los cambios
- Tests para nuevas features
- Documentación final

### Riesgos y Mitigaciones

| Riesgo | Probabilidad | Impacto | Mitigación |
|---|---|---|---|
| Linting rules demasiado strict | Media | Bajo | Configurar reglas razonables, permitir overrides por caso |
| @PreAuthorize matriz incompleta | Media | Alto | Review exhaustivo con team, coverage report |
| Replay detection tiene edge cases | Baja | Alto | Testing exhaustivo, security review |

### Criterios de Éxito

- ✅ 0 broken markdown links en CI
- ✅ Linting pasa en todos los módulos
- ✅ @PreAuthorize coverage ≥ 95% endpoints
- ✅ Replay attack tests pasan (security scenario)
- ✅ TTL configurable documentado + tested
- ✅ Scope filtering funciona para todos los scopes standard
- ✅ Documentation: use-cases, capabilities, constraints completadas

---

## HITO 2: Pré-Monetización & Stability (P1 — 4 semanas)

**Período:** 2026-05-04 a 2026-06-01  
**Objetivo:** Billing operacional, tests integración, caché performance  
**Prioridad:** 🟠 ALTA (P1)  
**Esfuerzo Total:** 81 horas (~10 dev-days)

### Propuestas Incluidas

| ID | Tipo | Propuesta | Status | Esfuerzo | Bloqueador | Contexto |
|---|---|---|---|---|---|---|
| **T-091** | 🧪 Test | Test integración Testcontainers: JPA ↔ Flyway coherencia | 🔲 | 12h | — | Testing |
| **T-013** | 🧪 Test | Tests integración Testcontainers para `keygo-supabase` | 🔲 | 16h | T-091 | Testing |
| **T-025** | 🧪 Test | Tests integración flujo completo Tenant | 🔲 | 10h | T-091 | Testing |
| **T-074** | ⚡ Perf | Caché `@Cacheable` en GetPlatformDashboardUseCase (TTL 60s) | 🔲 | 6h | — | PLATFORM |
| **T-075** | 📊 Feature | `GET /api/v1/admin/tenants/{slug}/dashboard` (ADMIN_TENANT) | 🔲 | 8h | T-074 | TENANTS |
| **T-070** | 📊 Feature | `GET /api/v1/tenants/{slug}/stats` con filtros fecha | 🔲 | 8h | — | TENANTS |
| **T-053** | 🧪 Test | Script SQL verificación post-seed V14 (conteos esperados) | 🔲 | 4h | — | Testing |
| **T-083** | 📝 Feature | Endpoint `GET /billing/invoices/{invoiceId}` | 🔲 | 4h | — | BILLING |
| **T-094** | 🧪 Test | Test unitario `AppPlanBillingOptionRepositoryAdapter` | 🔲 | 6h | — | Testing |
| **T-095** | 🔍 Validation | Validar `CreateAppPlanCommand`: ≥1 billingOption con `isDefault=true` | 🔲 | 3h | — | BILLING |
| **T-096** | 🔍 Validation | Agregar `@NotNull`, `@Valid` en `CreateAppPlanRequest` + tests | 🔲 | 4h | — | BILLING |

### Deliverables

✅ **Testing Foundation**
- Suite tests integración JPA ↔ Flyway (T-091)
- Tests completos keygo-supabase (T-013)
- Flujo tenant end-to-end (T-025)
- SQL seed verification (T-053)
- Repository adapter tests (T-094)
- Cobertura tests: 50% → 65%

✅ **Billing MVP**
- Endpoint invoice individual (T-083)
- Validaciones completas plans (T-095, T-096)
- Stats con filtros fecha (T-070)

✅ **Observabilidad**
- Dashboard tenant-específico (T-075)
- Caché platform dashboard (T-074)
- KPIs por tenant accesibles

### Plan de Ejecución

**Semana 1 (15h):** T-091, T-053, T-094
- TestContainers setup para JPA
- SQL seed verification
- Repository adapter unit tests

**Semana 2 (21h):** T-013, T-025, T-070
- Tests integración keygo-supabase
- Tenant flow e2e tests
- Stats filtering implementation

**Semana 3 (16h):** T-074, T-075, T-083
- Caché setup para dashboards
- Tenant dashboard endpoint
- Invoice individual endpoint

**Semana 4 (13h):** T-095, T-096, Validation
- Plan validations (@Valid, @NotNull)
- Tests para validaciones
- Performance testing

### Criterios de Éxito

- ✅ JPA ↔ Flyway integration tests pasan
- ✅ keygo-supabase test coverage ≥ 50%
- ✅ Tenant flow e2e tests completos
- ✅ Dashboard performance: <500ms (con caché)
- ✅ Plan validations exhaustivas
- ✅ Invoice endpoint retorna datos correctos
- ✅ Stats endpoint con filtros fecha funciona

---

## HITO 3: Gateway Real & Renovación (P1 — 6 semanas)

**Período:** 2026-06-02 a 2026-07-14  
**Objetivo:** Monetización posible; suscripciones automáticas  
**Prioridad:** 🟠 ALTA (P1)  
**Esfuerzo Total:** 94 horas (~12 dev-days)

### Propuestas Incluidas

| ID | Tipo | Propuesta | Status | Esfuerzo | Bloqueador | Contexto |
|---|---|---|---|---|---|---|
| **T-084** | 🔌 Integration | Integración gateway Stripe/MercadoPago (reemplaza mock) | 🔲 | 24h | — | BILLING |
| **T-085** | ⏰ Scheduled | Renovación automática @Scheduled job | 🔲 | 12h | T-084 | BILLING |
| **T-090** | 📧 Dunning | Motor dunning: reintentos D+1/D+3/D+7 + email | 🔲 | 16h | T-084, T-085 | BILLING |
| **T-086** | 🔐 Auth | Soporte Bearer TENANT_USER en `/billing/subscription` | 🔲 | 6h | — | BILLING |
| **T-098** | 🔍 Filter | Filtro `?subscriberType` en catalog | 🔲 | 4h | — | BILLING |
| **T-099** | ⚡ Perf | Caché `@Cacheable` +Caffeine en GetAppPlanCatalogUseCase (TTL 5m) | 🔲 | 4h | — | BILLING |
| **T-097** | 📝 Feature | `PUT /billing/plans/{planCode}/billing-options` sin crear versión | 🔲 | 8h | — | BILLING |
| **T-115** | 📊 Coverage | Aumentar JaCoCo en `keygo-supabase`: 0.15 → 0.60 | 🔲 | 20h | — | Testing |

### Deliverables

✅ **Payment Integration**
- Stripe/MercadoPago adaptado e integrado (T-084)
- Webhook handling para payment status
- Transactiones de pago tracked en BD

✅ **Automation**
- Auto-renewal @Scheduled job (T-085)
- Dunning engine con reintentos (T-090)
- Email notifications para pagos fallidos

✅ **Billing Features**
- Bearer token support para subscription (T-086)
- subscriberType filtering (T-098)
- Plan billing-options update sin versionado (T-097)

✅ **Performance & Quality**
- Catalog caché TTL 5m (T-099)
- JaCoCo coverage 60% en keygo-supabase (T-115)
- Monetización ready (pagos reales posibles)

### Plan de Ejecución

**Semana 1-2 (20h):** T-084 (Payment Integration)
- Setup Stripe SDK (o MercadoPago)
- Webhook receiver + signature validation
- Transaction logging en BD
- Mock mode → production mode toggle

**Semana 3 (16h):** T-085, T-086
- @Scheduled job para renovación
- Bearer token auth para subscription endpoint
- Job logic: queries contracts vencidas, crea invoices, charge

**Semana 4 (16h):** T-090 (Dunning Engine)
- D+1, D+3, D+7 retry logic
- Email notifications template
- Contract suspension si todas fallan
- Payment status state machine

**Semana 5 (16h):** T-097, T-098, T-099
- Plan billing-options update endpoint
- subscriberType filtering implementation
- Catalog caché setup
- Test coverage improvements

**Semana 6 (10h):** T-115, Validation
- JaCoCo coverage → 60%
- Integration testing (full payment flow)
- Performance testing (renovación batch)

### Criterios de Éxito

- ✅ Stripe/MercadoPago integration funciona end-to-end
- ✅ Webhooks reciben y procesan correctamente
- ✅ Auto-renewal job se ejecuta sin errores
- ✅ Dunning reintentos D+1/D+3/D+7 pasan
- ✅ Email notifications enviadas correctamente
- ✅ Plan billing-options updated sin crear version
- ✅ Catalog caché hit rate > 80%
- ✅ JaCoCo coverage ≥ 60%
- ✅ Monetización ready: pagos reales posibles

---

## HITO 4: Multi-Dominio & Hardening (P1 — 6 semanas)

**Período:** 2026-07-15 a 2026-08-26  
**Objetivo:** Contrato multi-dominio, federación de sesión, observabilidad  
**Prioridad:** 🟠 ALTA (P1)  
**Esfuerzo Total:** 96 horas (~12 dev-days)

### Propuestas Incluidas

| ID | Tipo | Propuesta | Status | Esfuerzo | Bloqueador | Contexto |
|---|---|---|---|---|---|---|
| **T-057** | 🔐 Contract | Contrato formal multi-dominio (validación, firma, CORS, cookies) | 🔲 | 12h | — | Platform |
| **T-058** | 🏗️ Pattern | Patrón BFF para canje authorization_code (backend, SPA segura) | 🔲 | 16h | — | AUTH |
| **T-063** | 📊 Tracing | Incorporar `traceId/requestId` en `ErrorData` | 🔲 | 6h | — | Platform |
| **T-066** | 💡 UX | Agregar `endpointHint/actionHint` para errores CLIENT_TECHNICAL | 🔲 | 4h | — | Platform |
| **T-064** | 🌍 i18n | Catálogo i18n avanzado: origin + clientRequestCause + locale | 🔲 | 10h | — | Platform |
| **T-108** | 📍 Tracking | Geolocalización IP en sesiones (GeoIpPort + adapter) | 🔲 | 10h | — | ACCOUNT |
| **T-109** | 🧹 Cleanup | Job cleanup sesiones expiradas/terminadas (@Scheduled) | 🔲 | 8h | — | Platform |
| **T-073** | 📈 Metrics | Micrometer + Prometheus: métricas keygo_tenants_total, etc. | 🔲 | 14h | — | PLATFORM |
| **T-076** | 📋 Audit | Tabla audit_events (V24) + endpoint `GET /admin/audit` | 🔲 | 16h | — | Platform |

### Deliverables

✅ **Multi-Domain Security**
- Contrato multi-dominio documentado e implementado (T-057)
- Validación CORS + cookies per domain
- Patrón BFF para auth code exchange (T-058)
- SPA segura (tokens en HttpOnly cookies, no localStorage)

✅ **Observability & Tracing**
- TraceId/requestId en errorData (T-063)
- Endpoint hints para debugging (T-066)
- Advanced i18n (T-064): origin + cause + locale
- Micrometer/Prometheus (T-073): keygo_tenants_total, keygo_users_total, keygo_sessions_active, etc.

✅ **Account & Session Management**
- Geolocalización IP sesiones (T-108)
- Session cleanup job (T-109)
- Sessiones con localización + UA information

✅ **Audit & Compliance**
- Tabla audit_events (V24) inmutable
- Endpoint GET /admin/audit (T-076)
- Full audit trail: quién, qué, cuándo, dónde

### Plan de Ejecución

**Semana 1 (16h):** T-057, T-058
- Multi-domain contract implementación
- CORS setup, cookie handling
- BFF pattern setup + auth code exchange

**Semana 2 (14h):** T-063, T-066, T-064
- TraceId/requestId propagation
- Endpoint hints en error responses
- Advanced i18n catalog

**Semana 3-4 (24h):** T-073 (Prometheus Integration)
- Micrometer setup
- Metrics gathering (tenants, users, sessions, tokens)
- Prometheus scrape config
- Grafana dashboards

**Semana 5 (18h):** T-108, T-109, T-076
- GeoIP adapter (MaxMind or Cloudflare)
- Session cleanup job
- Audit events table (V24)
- Audit endpoint implementation

**Semana 6 (8h):** Validation & Testing
- Multi-domain security testing
- Observability validation
- Audit trail completeness

### Criterios de Éxito

- ✅ Multi-domain contract implementado y documentado
- ✅ BFF pattern funciona para SPA segura
- ✅ TraceId/requestId propagados correctamente
- ✅ Prometheus scrape funciona, métricas ingieren
- ✅ GeoIP geolocalización en sesiones accesible
- ✅ Session cleanup job sin errores
- ✅ Audit trail completo: todas las operaciones logged
- ✅ Grafana dashboards muestran KPIs (tenants, users, sessions, etc.)

---

## HITO 5: Largo Plazo — Post-Monetización (P2/P3 — 16+ semanas)

**Período:** 2026-09-01 onwards  
**Objetivo:** Enterprise integrations, observabilidad avanzada, multi-currency  
**Prioridad:** 🔵 MEDIA (P2/P3)  
**Esfuerzo Total:** TBD (estimado 150+ horas)

### Track A: Integraciones Enterprise

| ID | Propuesta | Horizonte | Esfuerzo | Descripción |
|---|---|---|---|---|
| **T-047** | SCIM 2.0 endpoint aprovisionamiento | Q3 2026 | 20h | Aprovisionamiento user/group via SCIM standard |
| **T-048** | Custom attributes schema por tenant | Q3 2026 | 12h | Extensible attribute model per tenant |
| **T-044** | Membership attributes metadata | Q2 2026 | 8h | Attributes adicionales en memberships |
| **T-045** | Claim mappers por ClientApp | Q3 2026 | 10h | Custom JWT claim mapping per app |
| **T-055** | Bootstrap programático tenants/apps/roles (control-plane) | Q3 2026 | 14h | Programmatic setup vía control-plane |

**Deliverables:** SCIM compliance, custom attributes, programmatic management

### Track B: Expansión Global (Multi-Moneda)

| ID | Propuesta | Horizonte | Esfuerzo | Descripción |
|---|---|---|---|---|
| **T-089** | Multi-moneda: tabla exchange_rates | Q3 2026 | 12h | Exchange rate management + caching |
| **T-100** | Pricing tiers/escalonado | Q3 2026 | 10h | Tiered pricing per user count, API calls, etc. |
| **T-101** | Overrides precio por moneda | Q3 2026 | 8h | Currency-specific pricing |
| **T-102** | Precios dinámicos vía webhook | Q4 2026 | 12h | External pricing engine integration |
| **T-087** | PDF de facturas (iText/JasperReports) | Q3 2026 | 12h | Invoice PDF generation + S3/Supabase Storage |
| **T-088** | CFDI México (factura electrónica) | Q4 2026 | 16h | Mexican electronic invoice compliance |

**Deliverables:** Multi-currency billing, tiered pricing, invoice PDFs, regional compliance

### Track C: Seguridad Avanzada (Future Phases)

| Propuesta | Horizonte | Esfuerzo | Descripción |
|---|---|---|---|
| **MFA (TOTP/WebAuthn)** | Q4 2026 | 20h | Multi-factor authentication |
| **Federated Sessions (SAML)** | Q4 2026 | 30h | SAML federation para enterprise |
| **Event Sourcing** | Q4 2026+ | 40h | Full event sourcing architecture |
| **Risk-Based Auth** | Q1 2027 | 24h | Adaptive authentication (geolocation, device, behavior) |

**Deliverables:** Enterprise security, federation, audit trail

---

## Resumen Consolidado

### Por Hito

| Hito | Período | Propuestas | Esfuerzo | Status | Objetivo |
|---|---|---|---|---|---|
| **HITO 1** | 2026-04-05 to 2026-05-03 | 9 | 51h (6 dd) | 🔲 | Auth seguro + docs centralizadas |
| **HITO 2** | 2026-05-04 to 2026-06-01 | 11 | 81h (10 dd) | 🔲 | Billing MVP + tests + caché |
| **HITO 3** | 2026-06-02 to 2026-07-14 | 8 | 94h (12 dd) | 🔲 | Gateway real + auto-renewal |
| **HITO 4** | 2026-07-15 to 2026-08-26 | 9 | 96h (12 dd) | 🔲 | Multi-dominio + observabilidad |
| **HITO 5** | 2026-09-01+ | 18 | 150+h (19 dd) | 🔲 | Enterprise + multi-currency |
| **TOTAL Q2 2026** | 2026-04-05 to 2026-08-26 | 37 | 322h (40 dd) | 🔲 | 85% capacidades completadas |

### Por Tipo de Propuesta

| Tipo | Count | Esfuerzo | Ejemplos |
|---|---|---|---|
| 🔐 **Security/Auth** | 8 | 48h | T-035, T-036, T-043, T-051, T-057, T-058 |
| 💳 **Billing/Payment** | 12 | 96h | T-084, T-085, T-090, T-083, T-097 |
| 🧪 **Testing** | 8 | 68h | T-091, T-013, T-025, T-094, T-115 |
| 📊 **Observability** | 6 | 54h | T-074, T-075, T-073, T-076, T-063, T-064 |
| ⚙️ **Infrastructure** | 4 | 18h | T-023, T-030, T-031, T-109 |
| 🌍 **Global/Enterprise** | 12 | 150+h | T-047, T-048, T-087, T-088, T-101, etc. |

### Roadmap Timeline

```
2026-04-05 ════════════════════════════════════════════════════════════════ 2026-08-26
│
├─ HITO 1 (4 sem) ────────────── Auth Seguro + Docs
│  └─ T-035, T-036, T-043, T-051, T-030, T-031, T-023, V-067, T-062
│
├─ HITO 2 (4 sem) ────────────── Billing MVP + Tests
│  └─ T-091, T-013, T-025, T-074, T-075, T-070, T-053, T-083, T-094, T-095, T-096
│
├─ HITO 3 (6 sem) ────────────── Gateway + Auto-Renewal
│  └─ T-084, T-085, T-090, T-086, T-098, T-099, T-097, T-115
│
└─ HITO 4 (6 sem) ────────────── Multi-Dominio + Observability
   └─ T-057, T-058, T-063, T-066, T-064, T-108, T-109, T-073, T-076

(2026-09-01 onwards) HITO 5: Enterprise Track A/B/C (150+ horas)
```

### Criterios de Éxito Q2 2026

**Por Hito:**
- ✅ HITO 1: Auth pases compliance, docs complete, CI/CD enforced
- ✅ HITO 2: Tests coverage 65%, billing MVP functional
- ✅ HITO 3: Gateway real, payment processing, auto-renewal working
- ✅ HITO 4: Multi-domain secured, observability live, audit trail complete

**Agregado Q2:**
- ✅ 37 propuestas completadas (322 horas)
- ✅ 48/58 capacidades implementadas (83%)
- ✅ Monetización posible (gateway real + billing)
- ✅ Enterprise-ready observability (Prometheus + Grafana)
- ✅ Compliance & Audit trail completo
- ✅ Multi-tenant multi-domain secure

---

## Notas de Planificación

### Resource Allocation

```
Equipo sugerido: 4 developers + 1 QA
├─ Developer 1: AUTH context (T-035, T-036, T-043, T-051, T-057, T-058)
├─ Developer 2: BILLING context (T-084, T-085, T-090, T-083, T-097, T-087)
├─ Developer 3: PLATFORM/Testing (T-074, T-075, T-091, T-013, T-025, T-073, T-076)
├─ Developer 4: DEVOPS (T-023, T-030, T-031, T-109) + support
└─ QA: T-094, T-096, T-115, end-to-end validation
```

### Risk Factors

1. **T-084 (Gateway Integration):** Stripe/MercadoPago API learning curve
2. **T-090 (Dunning Engine):** Complex retry logic, edge cases
3. **T-073 (Prometheus):** Metric cardinality explosion, requires careful design
4. **T-058 (BFF Pattern):** SPAs have evolving security best practices

### Assumptions

- Team availability: 40h/week (4 dev-days/dev/week)
- No major production incidents during Q2
- Third-party APIs (Stripe, Prometheus) stable and documented
- Testing infrastructure (TestContainers) compatible with current setup

### Future Considerations (HITO 5)

- SCIM 2.0 implementation (Enterprise)
- Multi-currency support (Global expansion)
- Advanced security (MFA, Risk-based auth, Federated sessions)
- Event sourcing (Audit trail, temporal queries)

---

**Última actualización:** 2026-04-20  
**Próximo:** Kickoff HITO 1 (2026-04-21)  
**Owner:** Product Lead + Engineering Lead  
**Status:** Ready for approval

Co-authored by: Domain-Driven Design Framework + Product Planning
