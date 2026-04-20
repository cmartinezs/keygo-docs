# Capability Matrix — KeyGo Server

> **Descripción:** Matriz exhaustiva de 60+ capacidades del sistema por Bounded Context, mostrando status (✅ Completado, 🟡 Parcial, 🔲 Pendiente), horizonte de implementación, RF asociado, y esfuerzo estimado.

**Fecha:** 2026-04-20  
**Versión:** 1.0  
**Horizonte:** 2026 Q2-Q4 (roadmap de desarrollo)

---

## Índice

1. [UC-A: Authentication & OAuth2/OIDC](#uca-authentication--oauth2oidc) (17 capacidades)
2. [UC-T: Tenant Management](#uct-tenant-management) (11 capacidades)
3. [UC-B: Billing & Subscriptions](#ucb-billing--subscriptions) (14 capacidades)
4. [UC-AC: Account & Self-Service](#ucac-account--self-service) (8 capacidades)
5. [UC-P: Platform & Observability](#ucp-platform--observability) (5 capacidades)
6. [Resumen de Cobertura](#resumen-de-cobertura) — Status by horizon

---

## UC-A: Authentication & OAuth2/OIDC

| Capacidad | Status | RF | UC | Horizonte | Esfuerzo | Propuesta | Descripción |
|---|---|---|---|---|---|---|---|
| **A1: Authorization Code Flow + PKCE** | ✅ | RF-A1 | UC-A1 | Q2 | 12h | — | Endpoints `/oauth2/authorize` (query params), validación PKCE per RFC 7636 |
| **A2: JWT RS256** | ✅ | RF-A1 | UC-A1 | Q2 | 8h | — | Tokens signed RSA keys per tenant, `kid` + JWKS endpoint |
| **A3: Refresh Token Rotation** | ✅ | RF-A3 | UC-A3 | Q2 | 10h | — | SHA-256 hash, estado (ACTIVE/USED/REVOKED), TTL 30d |
| **A4: Token Revocation (RFC 7009)** | ✅ | RF-A4 | UC-A4 | Q2 | 6h | — | Endpoint `/oauth2/revoke`, RFC 7009 compliant |
| **A5: Userinfo Endpoint (OIDC)** | ✅ | RF-A5 | UC-A5 | Q2 | 4h | — | `/.well-known/userinfo`, retorna OIDC claims (sub, name, email, etc.) |
| **A6: OpenID Configuration** | ✅ | RF-A6 | UC-A5 | Q2 | 3h | — | `/.well-known/openid-configuration` metadata discovery |
| **A7: Client Credentials Grant (M2M)** | ✅ | RF-A7 | UC-A1 | Q2 | 6h | — | Backend-to-backend, `grant_type=client_credentials` |
| **A8: Session Management** | ✅ | Custom | UC-A2 | Q2 | 8h | — | Tabla `sessions`, tracking UA/IP, created/terminated_at |
| **A9: Email Verification** | ✅ | RF-A8 | UC-A8 | Q2 | 6h | — | Código 6-dígitos (TTL 30 min) para nuevos usuarios |
| **A10: Password Reset Code** | ✅ | RF-A9 | UC-A11 | Q2 | 6h | — | Código 6-dígitos (TTL 24h) para reset de contraseña |
| **A11: Password Recovery Token** | ✅ | RF-A9 | UC-A9 | Q2 | 4h | — | Token 32-char (TTL 30 min) para forgot-password flow |
| **A12: Status RESET_PASSWORD** | ✅ | RF-A10 | UC-A6 | Q2 | 3h | — | Bloquea login, requiere código + nueva contraseña |
| **A13: i18n + Locale Resolution** | ✅ | RF-A11 | UC-A5 | Q2 | 8h | — | `Accept-Language` header, cache message source, error i18n |
| **A14: Scope Filtering en Userinfo** | 🟡 | RF-A5 | UC-A5 | Q2 | 6h | T-043 | Claims filtradas por scope solicitado (profile, email, phone) — actualmente retorna todos |
| **A15: Replay Attack Detection** | 🟡 | RF-A3 | UC-A3 | Q2 | 8h | T-035 | Token USED debe revocar cadena entera automáticamente |
| **A16: Redirect OAuth2 Clásico** | 🔲 | RF-A1 | UC-A1 | Q3 | 4h | T-059 | HTTP 302 redirect en lugar de JSON para `authorization_code` |
| **A17: TTL Configurable Refresh** | 🔲 | RF-A3 | UC-A3 | Q3 | 3h | T-036 | TTL editable vía `application.yml` (actualmente 30d fixed) |

---

## UC-T: Tenant Management

| Capacidad | Status | RF | UC | Horizonte | Esfuerzo | Propuesta | Descripción |
|---|---|---|---|---|---|---|---|
| **T1: CRUD de Tenants** | ✅ | RF-B1 | UC-T1 through T6 | Q2 | 12h | — | Create, Read (list/get), Update, Delete (suspend/reactivate) |
| **T2: Multi-Tenant Isolation** | ✅ | RF-B1 | UC-T* | Q2 | 10h | — | Aislamiento por `tenant_slug` en path, queries filtrados |
| **T3: Tenant Resolution** | ✅ | RF-B1 | UC-T* | Q2 | 4h | — | Resolver tenant automáticamente desde URL path variable |
| **T4: CRUD Usuarios (per Tenant)** | ✅ | RF-B2 | UC-T7 through T12 | Q2 | 16h | — | Create, Read, Update, Suspend, Force password reset |
| **T5: Roles Jerárquicos** | ✅ | RF-B4 | UC-T16, T17 | Q2 | 12h | — | `parent_role_id`, expansión recursiva vía CTE SQL, JWT claims |
| **T6: RBAC Básico** | ✅ | RF-B4 | UC-T* | Q2 | 10h | — | `@PreAuthorize` por endpoint, roles ADMIN/ADMIN_TENANT |
| **T7: Memberships (User-Role)** | ✅ | RF-B5 | UC-T18 through T20 | Q2 | 10h | — | Asignación usuario→role, N:M con tabla `membership_roles` |
| **T8: Client Applications (CRUD)** | ✅ | RF-B3 | UC-T13 through T15 | Q2 | 12h | — | Crear, listar, actualizar apps; clientId/clientSecret generation |
| **T9: Tenant Stats** | ✅ | Custom | UC-T21 | Q2 | 8h | — | Conteos: usuarios, apps, memberships, roles por tenant |
| **T10: Dashboard Tenant-Específico** | 🔲 | Custom | UC-T22 | Q2 | 8h | T-075 | GET `/api/v1/admin/tenants/{slug}/dashboard` (KPIs acotados al tenant) |
| **T11: Estadísticas con Filtros de Fecha** | 🔲 | RF-B2 | UC-T21 | Q3 | 4h | T-070 | `created_after/created_before` en stats queries |

---

## UC-B: Billing & Subscriptions

| Capacidad | Status | RF | UC | Horizonte | Esfuerzo | Propuesta | Descripción |
|---|---|---|---|---|---|---|---|
| **B1: Planes Inmutables (Versionado)** | ✅ | RF-B6 | UC-B1 through B4 | Q2 | 12h | — | `AppPlan` + `AppPlanVersion` + `AppPlanBillingOption` (período+precio) |
| **B2: Catálogo Público** | ✅ | RF-B6 | UC-B1, B2 | Q2 | 4h | — | GET `/billing/plans` (público, cacheado) + detalles por plan |
| **B3: Contratos (Subscriptions)** | ✅ | RF-B7 | UC-B5, B6 | Q2 | 10h | — | Suscripción a plan, status (PENDING/ACTIVE/SUSPENDED/CANCELED) |
| **B4: Facturas (Invoices)** | ✅ | RF-B8 | UC-B7 | Q2 | 10h | — | Documento por período, status (PENDING/PAID/FAILED) |
| **B5: Endpoints Pública de Catálogo** | ✅ | RF-B6 | UC-B1 | Q2 | 4h | — | Acceso sin token a planes + activación |
| **B6: Seeds Funcionales (V17/V18)** | ✅ | Custom | UC-B1 | Q2 | 6h | — | Planes FREE/STARTER/BUSINESS/ENTERPRISE + contractors de prueba |
| **B7: Integración Gateway Real** | 🔲 | RF-B9 | UC-B8 | Q2 | 24h | T-084 | Stripe/MercadoPago (actualmente solo mock `/mock-approve-payment`) |
| **B8: Renovación Automática** | 🔲 | RF-B10 | UC-B9 | Q2 | 12h | T-085 | Job `@Scheduled` detects vencidas, genera factura nueva |
| **B9: Motor Dunning (Reintentos)** | 🔲 | RF-B11 | UC-B10 | Q2 | 16h | T-090 | Reintentos D+1/D+3/D+7, notificaciones email |
| **B10: Multi-Moneda** | 🔲 | RF-B6 | UC-B3, B6 | Q3 | 12h | T-101 | Overrides de precio por moneda (USD, MXN, EUR) |
| **B11: Precios Dinámicos** | 🔲 | Custom | UC-B1 | Q3 | 10h | T-102 | Webhook externo para precio en tiempo real |
| **B12: PDF de Facturas** | 🔲 | Custom | UC-B13 | Q3 | 8h | T-087 | iText/JasperReports → S3/Supabase Storage |
| **B13: Filtros Avanzados en Invoices** | 🔲 | RF-B12 | UC-B12, B13 | Q2 | 6h | T-098, T-083 | `?subscriberType` filter, endpoint individual invoice |
| **B14: Caché Plan Catalog** | 🔲 | RF-B6 | UC-B1 | Q2 | 4h | T-099 | `@Cacheable` TTL 5 min en GetAppPlanCatalogUseCase |

---

## UC-AC: Account & Self-Service

| Capacidad | Status | RF | UC | Horizonte | Esfuerzo | Propuesta | Descripción |
|---|---|---|---|---|---|---|---|
| **AC1: Perfil de Usuario** | ✅ | Custom | UC-AC1, AC2 | Q2 | 6h | — | GET/PATCH `/account/profile` (name, email, picture, phone, locale) |
| **AC2: Gestión de Sesiones** | ✅ | Custom | UC-AC3, AC4 | Q2 | 8h | — | GET `/account/sessions` (lista), DELETE (sign out device) |
| **AC3: Cambio de Contraseña** | ✅ | RF-A12 | UC-A12 | Q2 | 6h | — | POST `/account/change-password` (verifica actual, nueva con complejidad) |
| **AC4: Forgot Password** | ✅ | RF-A9 | UC-A9 | Q2 | 4h | — | POST `/account/forgot-password` (anti-enumeración, token 32-char) |
| **AC5: Recover Password** | ✅ | RF-A9 | UC-A10 | Q2 | 4h | — | POST `/account/recover-password` (valida token, genera código) |
| **AC6: Reset Password** | ✅ | RF-A9 | UC-A11 | Q2 | 4h | — | POST `/account/reset-password` (valida código, asigna nueva) |
| **AC7: Geolocalización IP en Sesiones** | 🔲 | Custom | UC-AC3 | Q3 | 10h | T-108 | Campo `location` en `sessions`, `GeoIpPort` adapter |
| **AC8: Account Connections (OAuth)** | 🔲 | Custom | UC-AC* | Q3 | 12h | F-042 | Apps externas vinculadas, tabla `connections` (V24+) |

---

## UC-P: Platform & Observability

| Capacidad | Status | RF | UC | Horizonte | Esfuerzo | Propuesta | Descripción |
|---|---|---|---|---|---|---|---|
| **P1: Service Info Endpoint** | ✅ | Custom | — | Q2 | 2h | — | GET `/api/v1/service/info` (nombre, versión, ambiente) |
| **P2: Response Codes Catalog** | ✅ | Custom | — | Q2 | 2h | — | GET `/api/v1/response-codes` (catálogo enum `ResponseCode`) |
| **P3: Platform Stats** | ✅ | Custom | — | Q2 | 6h | — | GET `/api/v1/platform/stats` (conteos tenants, usuarios, apps, keys) |
| **P4: Platform Dashboard** | ✅ | Custom | — | Q2 | 8h | — | GET `/api/v1/admin/platform/dashboard` (KPIs, cached) |
| **P5: Caché Dashboard** | 🔲 | Custom | — | Q2 | 4h | T-074 | `@Cacheable` TTL 60 s (actualmente ~25 queries JPA) |
| **P6: Métricas Prometheus/Micrometer** | 🔲 | Custom | — | Q2 | 14h | T-073 | Push a Prometheus: `keygo_tenants_total`, `keygo_users_total`, etc. |

---

## Resumen de Cobertura

### Por Status

| Status | Contexto | Qty | % | Horizonte |
|---|---|---|---|---|
| ✅ **Completado** | AUTH (13), TENANTS (9), BILLING (6), ACCOUNT (6), PLATFORM (4) | **38** | **64%** | Q2 2026 |
| 🟡 **Parcial** | AUTH (2), TENANTS (0), BILLING (0), ACCOUNT (0), PLATFORM (0) | **2** | **3%** | Q2 2026 |
| 🔲 **Pendiente** | AUTH (2), TENANTS (2), BILLING (8), ACCOUNT (2), PLATFORM (2) | **18** | **30%** | Q2-Q4 2026 |
| **TOTAL** | | **58** | **100%** | |

### Por Horizonte

| Horizonte | Qty | Capacidades Principales | Esfuerzo Total |
|---|---|---|---|
| **Q2 2026 (Corto Plazo)** | 44 | A1-A15, T1-T11 (parcial), B1-B6, B13-B14, AC1-AC6, P1-P5 (parcial) | 280h (~35 dev-days) |
| **Q3 2026 (Mediano)** | 8 | A16-A17, T11, B10-B12, AC7-AC8, P6 | 80h (~10 dev-days) |
| **Q4 2026+ (Largo)** | 2 | Future integrations (SCIM, MFA, Federated Sessions) | TBD |

### Por Contexto

| Contexto | Completado | Parcial | Pendiente | Total | % Ready |
|---|---|---|---|---|---|
| **AUTH** | 13 | 2 | 2 | 17 | 76% |
| **TENANTS** | 9 | 0 | 2 | 11 | 82% |
| **BILLING** | 6 | 0 | 8 | 14 | 43% |
| **ACCOUNT** | 6 | 0 | 2 | 8 | 75% |
| **PLATFORM** | 4 | 0 | 2 | 6 | 67% |
| **TOTAL** | 38 | 2 | 18 | 58 | **66%** |

---

## Traceabilidad: Capacidades → RF

### Auth (UC-A)
- **RF-A1:** A1, A2, A7, A16
- **RF-A3:** A3, A15, A17
- **RF-A4:** A4
- **RF-A5:** A5, A6, A14
- **RF-A8:** A9
- **RF-A9:** A10, A11
- **RF-A10:** A12
- **RF-A11:** A13

### Tenants (UC-T)
- **RF-B1:** T1, T2, T3, T4
- **RF-B2:** T4, T11
- **RF-B3:** T8
- **RF-B4:** T5, T6
- **RF-B5:** T7

### Billing (UC-B)
- **RF-B6:** B1, B2, B4, B10
- **RF-B7:** B3, B5
- **RF-B8:** B4
- **RF-B9:** B7
- **RF-B10:** B8
- **RF-B11:** B9
- **RF-B12:** B13

### Account (UC-AC)
- **RF-A9:** AC4, AC5, AC6
- **RF-A12:** AC3
- **Custom:** AC1, AC2, AC7, AC8

### Platform (UC-P)
- **Custom:** P1, P2, P3, P4, P5, P6

---

## Priorización Recomendada (HITO 1: Q2 2026)

### 🔴 **Bloqueadores (Must-Have)**
1. **A1-A8, T1-T9, AC1-AC6** — Funcionalidad base completada ✅
2. **B1-B6, B13-B14** — Billing MVP (sin gateway real aún)
3. **P1-P4** — Platform observability básica

**Subtotal:** 35 capacidades, ~220 horas (~28 dev-days)

### 🟡 **Nice-to-Have (Should-Have)**
1. **A14-A15** — Replay detection + scope filtering (hardening)
2. **B7-B9** — Gateway + renovación automática (monetización real)
3. **T10-T11** — Dashboard + filtros avanzados (analytics)
4. **P5-P6** — Caché + métricas (observabilidad avanzada)

**Subtotal:** 9 capacidades, ~60 horas (~8 dev-days)

### 🔵 **Futuros (Nice-to-Have Largo Plazo)**
1. **A16-A17** — OAuth2 classics + TTL config
2. **B10-B12** — Multi-moneda + PDF invoices
3. **AC7-AC8** — Geolocalización + OAuth connections

**Subtotal:** 6 capacidades, ~56 horas (~7 dev-days)

---

## Notas de Implementación

### Dependencias Críticas

```
A1-A4 → foundational (tokens, sessions)
  ↓
T1-T9 → depend on A (RBAC in JWT)
  ↓
B1-B6 → depend on T (billing per tenant)
  ↓
B7-B9 → depend on B6 (gateway integration)
```

### Constraint T1 Impact

- **Capacidades afectadas:** A2 (JWT RS256), T6 (RBAC), P3-P4 (stats)
- **Rationale:** Stack fijo (Java 21/Spring Boot 4.x) → no puede cambiar JWT library
- **Workaround:** Jackson 3 namespace + Nimbus compatible

### Testing Coverage

- **Unit tests:** A1-A6, AC1-AC6 (keygo-domain, sin Spring)
- **Integration tests:** T1-T9, B1-B6 (TestContainers JPA)
- **E2E tests:** A7-A8, B7-B9 (gateway mocking)

### Future Extensions (Out of Scope Q2)

- **SCIM 2.0** — Enterprise aprovisionamiento (Q3, 20h)
- **MFA** — Multi-factor authentication (Q3, 18h)
- **Federated Sessions** — SAML/OAuth federation (Q4, 30h)
- **Event Sourcing** — Full audit trail (Q4, 40h)

---

**Última actualización:** 2026-04-20  
**Próximo:** Hitos y Propuestas (roadmap detallado con effort estimates)  
**Traceabilidad:** use-cases-catalog.md → requirements.md → test-plans.md

Co-authored by: Domain-Driven Design Framework + Product Analysis
