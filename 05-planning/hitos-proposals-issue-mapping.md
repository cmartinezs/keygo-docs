[← Índice](./README.md) | [< Anterior](./hitos-y-propuestas.md)

---

# Mapeo de Hitos y Propuestas a Issues

**Versión:** 1.0  
**Fecha:** 2026-04-15  
**Estado:** Referencia de validación para crear/verificar issues en sistema de tracking

> **Propósito:** Validar que cada propuesta documentada en hitos-y-propuestas.md tiene su correspondiente issue/task creado en el sistema de seguimiento (Jira, GitHub Issues, Azure DevOps, etc.). Este documento sirve como checklist y fuente única de verdad para la trazabilidad entre documentación y ejecución.

---

## Resumen Ejecutivo

- **Total de hitos:** 4
- **Total de propuestas documentadas:** 37
- **Estructura:** 4 hitos (HITO 1-4) con propuestas T-NNN (tasks), V-NNN (validaciones), F-NNN (features)
- **Validación requerida:** Cada propuesta debe tener un issue creado y enlazado a su hito correspondiente

---

## Convenciones de Código para Issues

### Nomenclatura

```
HITO-{n}-{id_propuesta}

Ejemplos:
- HITO-1-T-030: Auth Security Checklist (Hito 1, Task 30)
- HITO-2-T-060: Billing Integration Tests (Hito 2, Task 60)
- HITO-3-V-067: Performance Validation (Hito 3, Validation 67)
- HITO-4-F-042: Multi-Domain Feature (Hito 4, Feature 42)
```

### Etiquetas (Labels)

Aplicar siempre:
- `hito:{number}` (hito:1, hito:2, hito:3, hito:4)
- `tipo:{t|v|f}` (tipo:t=task, tipo:v=validation, tipo:f=feature)
- `q2-2026` (horizonte temporal)
- `priority:{high|medium|low}` (basado en hito criticidad)

Opcional:
- `bounded-context:{context}` (auth, billing, tenant-mgmt, account, platform)
- `ddd:{pattern}` (aggregate, entity, value-object, domain-event, etc.)

---

## HITO 1: Auth Security + Documentation (51h)

Seguridad OAuth2/OIDC, documentación técnica, validaciones de autorización, detección de replay attacks.

| # | ID | Propuesta | Descripción | Esfuerzo | Estado Validación | Ticket ID |
|---|----|----|---|---|---|---|
| 1 | T-030 | Markdown Validation + Linting | Workflow CI para validar sintaxis markdown y generation de índices automáticos | 4h | ⏳ Crear | |
| 2 | T-031 | @PreAuthorize Security Matrix | Documentar todas las combinaciones de role+scope válidas por endpoint, matriz de validación | 6h | ⏳ Crear | |
| 3 | T-032 | Replay Attack Detection (T-035) | Implementar detección de reutilización de refresh_token: marcar USED, revoque toda la cadena si se detecta replay | 8h | ⏳ Crear | |
| 4 | T-033 | Scope Filtering en Access Control | Verificar que Access Control aplica filtering de scopes en cada evaluación de permisos | 5h | ⏳ Crear | |
| 5 | T-034 | TTL Configurable por Contexto | Permitir configuración de TTL de access_token y refresh_token por tenant/plan (min 5m, max 7d) | 6h | ⏳ Crear | |
| 6 | T-035 | Replay Attack Detection Implementation | Ver T-032 (mismo item con nomenclatura dual) | — | ⏳ Consolidar | |
| 7 | V-001 | Auth Security Validation | Validar que todos los endpoints de auth usan Bearer-only, sin Basic auth, sin sesiones server-side | 4h | ⏳ Crear | |
| 8 | V-002 | Documentation Completeness | Validar que toda API auth tiene ejemplo de curl + JWT + esperado | 3h | ⏳ Crear | |
| 9 | F-001 | PKCE Implementation | Verificar que /authorize requiere code_challenge en todos los flows (no solo web) | 5h | ⏳ Crear | |

**Subtotal HITO 1:** 51h (✅ 9 propuestas)

---

## HITO 2: Billing MVP + Test Foundation (81h)

Integración de gateway de pagos, facturación básica, primeros tests de integración, caché de catálogo.

| # | ID | Propuesta | Descripción | Esfuerzo | Estado Validación | Ticket ID |
|---|----|----|---|---|---|---|
| 1 | T-060 | Integration Tests Framework Setup | Skeleton de tests de integración: testcontainers, fixtures de tenant, factories de agregados | 8h | ⏳ Crear | |
| 2 | T-061 | Billing Dashboard MVP | UI mínima: planes activos, próximas facturas, botón upgrade, historial 3 meses | 10h | ⏳ Crear | |
| 3 | T-062 | Invoice Endpoints (CRUD) | GET/POST/PATCH /billing/contracts/{id}/invoices, con validaciones RFC | 8h | ⏳ Crear | |
| 4 | T-063 | Payment Gateway Wrapper | Abstracción para Stripe/MercadoPago: charge, refund, webhook handling, retry logic | 12h | ⏳ Crear | |
| 5 | T-064 | Invoice Validations | Validar líneas, impuestos, descuentos; rechazar invoices malformadas; audit trail | 7h | ⏳ Crear | |
| 6 | T-065 | Plan Catalog Caching (T-099) | Implementar caché en Redis con TTL 5m; invalidar al actualizarse; warming en startup | 8h | ⏳ Crear | |
| 7 | T-066 | Contract State Machine | Estados: DRAFT → ACTIVE → SUSPENDED → TERMINATED con transiciones validadas | 6h | ⏳ Crear | |
| 8 | T-067 | Subscription Metrics | Registrar: active_subs, churn_rate, mrr por plan, eventos para monitoring | 6h | ⏳ Crear | |
| 9 | V-010 | Integration Tests Pass (70%+) | Validar que integration tests cubran: auth, billing, tenant mgmt con > 70% coverage | 6h | ⏳ Crear | |
| 10 | V-011 | Performance: Catalog < 200ms | Validar que /billing/plans responde en < 200ms (p95) desde caché caliente | 4h | ⏳ Crear | |

**Subtotal HITO 2:** 81h (✅ 10 propuestas)

---

## HITO 3: Gateway Real + Auto-Renewal (94h)

Integración productiva con Stripe/MercadoPago, motor de dunning (reintentos D+1/D+3/D+7), renovación automática, hardening de seguridad.

| # | ID | Propuesta | Descripción | Esfuerzo | Estado Validación | Ticket ID |
|---|----|----|---|---|---|---|
| 1 | T-080 | Stripe Live Integration | Pasar de modo test a producción: claves, webhooks, PCI compliance, error handling | 10h | ⏳ Crear | |
| 2 | T-081 | MercadoPago Integration | Integración paralela: charging, refunds, webhooks, pesos/CLP support | 12h | ⏳ Crear | |
| 3 | T-082 | Dunning Engine MVP | Motor de reintentos: D+1 (suave), D+3 (firme), D+7 (terminal); templates de email | 14h | ⏳ Crear | |
| 4 | T-083 | Auto-Renewal @Scheduled Job | Job diario a las 02:00 UTC que renueva contracts activos; idempotencia garantizada | 8h | ⏳ Crear | |
| 5 | T-084 | Failed Payment Notifications | Alertas al usuario vía email + SPA toast; link directo a actualizar método de pago | 6h | ⏳ Crear | |
| 6 | T-085 | Auto-Renewal Idempotency (T-088) | Garantizar que 2 ejecuciones del job no crean 2 facturas; version/timestamp deduplication | 6h | ⏳ Crear | |
| 7 | T-086 | Revenue Recognition (ASC606) | Registrar revenue en prorrata; soporte para splits de período (mid-cycle upgrade) | 8h | ⏳ Crear | |
| 8 | T-087 | Refund & Credit Policy | Procesar reembolsos (full/partial); aplicar créditos a future invoices; audit trail | 8h | ⏳ Crear | |
| 9 | T-088 | Idempotency Tokens | Ver T-085 (mismo concepto, nomenclatura dual) | — | ⏳ Consolidar | |
| 10 | T-089 | Performance: Renewal < 5s | Asegurar que renovación de 1 contract toma < 5s; batch processing para 1000s | 6h | ⏳ Crear | |
| 11 | T-090 | Dunning Retries (T-095) | Ver T-082 (motor de reintentos) | — | ⏳ Consolidar | |
| 12 | V-050 | Payment Flow E2E Test | Validar flujo completo: crear contract → pagar → renovar automáticamente → dunning → refund | 6h | ⏳ Crear | |

**Subtotal HITO 3:** 94h (✅ 12 propuestas, 2 consolidables)

---

## HITO 4: Multi-Domain + Hardening (96h)

Soporte de multi-dominio por tenant, patrón BFF, tracing distribuido, i18n, hardening de seguridad, geolocalización, audit trail extenso.

| # | ID | Propuesta | Descripción | Esfuerzo | Estado Validación | Ticket ID |
|---|----|----|---|---|---|---|
| 1 | T-100 | Multi-Domain Contract | Struct: contract.allowedDomains = [domain1, domain2, ...]; validación en token endpoint | 8h | ⏳ Crear | |
| 2 | T-101 | Domain Validation + CORS | Verificar que /oauth2/token rechaza requests desde dominio no autorizado (origin check) | 6h | ⏳ Crear | |
| 3 | T-102 | BFF Pattern: Unified Auth API | Gateway que unifica auth para múltiples dominios; resuelve tenant desde Host header | 12h | ⏳ Crear | |
| 4 | T-103 | Distributed Tracing (OpenTelemetry) | Instrumentar spans: auth → billing → audit; exportar a Jaeger/Tempo; trace IDs en logs | 10h | ⏳ Crear | |
| 5 | T-104 | i18n + Message Catalogs | Catálogos de mensajes por locale (es, en, pt-BR); respuesta de errores localizada | 8h | ⏳ Crear | |
| 6 | T-105 | Prometheus Metrics | Exponer métricas: requests, latency, errors, token counts, payment events; compatible con Prometheus | 8h | ⏳ Crear | |
| 7 | T-106 | Micrometer Integration | Usar Micrometer para abstracción de métricas; soportar múltiples backends (Datadog, New Relic) | 6h | ⏳ Crear | |
| 8 | T-107 | IP Geolocation Logging | Registrar geolocalización de login (país, city); alertas si login desde país nuevo | 6h | ⏳ Crear | |
| 9 | T-108 | Audit Trail Extended | Extender audit: qué cambió (field-level diff), quién, cuándo, por qué (reason code) | 8h | ⏳ Crear | |
| 10 | T-109 | Session Device Fingerprinting | Fingerprint: UA, IP, TLS cipher; detectar cambios sospechosos (step-up auth si > threshold) | 8h | ⏳ Crear | |
| 11 | T-110 | Rate Limiting per Tenant | Limitar: auth attempts (5/min), token endpoint (50/min), API (plan-dependent); backoff exponencial | 6h | ⏳ Crear | |
| 12 | V-067 | Multi-Domain E2E | Validar que token emitido en domain1 es rechazado en domain2; cross-domain refresh falla | 4h | ⏳ Crear | |
| 13 | F-042 | Advanced Security Features | Consolidar: 2FA backup codes, WebAuthn support, FIDO2 registration | 6h | ⏳ Crear | |

**Subtotal HITO 4:** 96h (✅ 13 propuestas)

---

## Validación Consolidada

### Issues a Consolidar (Nomenclatura Dual)

| Propuesta Primaria | Propuesta Duplicada | Recomendación |
|---|---|---|
| T-032 | T-035 | Consolidar en T-035 (replay attack detection) |
| T-085 | T-088 | Consolidar en T-085 (auto-renewal idempotency tokens) |
| T-082 | T-090 | Consolidar en T-082 (dunning retries = parte del motor) |

**Total después de consolidación:** 37 → 34 unique issues

---

## Checklist de Validación

Para validar que todos los issues están creados:

1. **Crear issues por hito:**
   - [ ] HITO 1: 9 issues (T-030 → T-035, V-001, V-002, F-001)
   - [ ] HITO 2: 10 issues (T-060 → T-067, V-010, V-011)
   - [ ] HITO 3: 10 unique issues (T-080 → T-089, V-050, consolidando duplicados)
   - [ ] HITO 4: 13 issues (T-100 → T-110, V-067, F-042)

2. **Aplicar etiquetas estándar:**
   - [ ] Todas tienen label `q2-2026`
   - [ ] Todas tienen label `hito:{n}`
   - [ ] Todas tienen label `tipo:{t|v|f}`
   - [ ] Todas tienen label `priority:{high|medium|low}` (HITO 1-2 = high, HITO 3-4 = medium)

3. **Validar dependencias:**
   - [ ] HITO 1 sin dependencias externas (entrada de Q2)
   - [ ] HITO 2 depende de HITO 1 completado (issues blocked hasta T-030+ ✅)
   - [ ] HITO 3 depende de HITO 2 completado (issues blocked hasta T-060+ ✅)
   - [ ] HITO 4 depende de HITO 3 completado (issues blocked hasta T-080+ ✅)

4. **Validar esfuerzo estimado:**
   - [ ] HITO 1: 51h ✓
   - [ ] HITO 2: 81h ✓
   - [ ] HITO 3: 94h ✓
   - [ ] HITO 4: 96h ✓
   - [ ] Total: 322h (~40 dev-days con 2 devs, ~20 dev-days con 4 devs)

---

## Mapeo de Bounded Contexts a Issues

Por contexto (para facilitar asignación por especialista):

### Identity Context (Auth)
- T-030, T-031, T-032, T-033, T-034, V-001, V-002, F-001 (HITO 1)
- T-080, T-081 (HITO 3 — integración gateways)
- T-103, T-104, T-107, T-109 (HITO 4 — tracing, i18n, geolocation, fingerprinting)

### Billing Context
- T-060, T-061, T-062, T-063, T-064, T-065, T-066, T-067, V-010, V-011 (HITO 2)
- T-082, T-083, T-084, T-085, T-086, T-087, T-089, V-050 (HITO 3)

### Organization Context
- T-100, T-101, T-102 (HITO 4 — multi-dominio, BFF)

### Monitoring/Platform Context
- T-105, T-106, T-108, T-110, V-067, F-042 (HITO 4)

---

## Plantilla de Issue (para crear en Jira/GitHub)

```markdown
Title: [HITO-{n}-{id}] {Propuesta Name}

Labels:
- hito:{n}
- tipo:{t|v|f}
- q2-2026
- bounded-context:{context}
- priority:{high|medium|low}

Description:
{Descripción de la propuesta}

Effort:
{Esfuerzo} hours (~{Esfuerzo/8} dev-days)

Acceptance Criteria:
- [ ] {AC1}
- [ ] {AC2}
- [ ] {AC3}

Depends On:
- {lista de tickets previos si aplica}

Related Use Cases:
- {UC-XXX si aplica}

Related Requirements:
- {RF-XXX si aplica}
```

---

## Contacto & Preguntas

Para aclaraciones sobre:
- **Consolidación de duplicados:** Revisar sección "Issues a Consolidar"
- **Dependencias:** Revisar sección "Validar dependencias"
- **Mapeo a bounded contexts:** Revisar sección "Mapeo de Bounded Contexts"
- **Esfuerzos:** Ref hitos-y-propuestas.md (líneas de detalle)

---

[← Índice](./README.md) | [< Anterior](./hitos-y-propuestas.md)
