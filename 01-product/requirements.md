# Requerimientos Funcionales y No-Funcionales — KeyGo

> **Descripción:** Consolidación de requisitos por dominio (contextos). Fuente única de verdad para especificaciones de KeyGo.

**Última actualización:** 2026-04-19

---

## 1. Requerimientos Funcionales por Bounded Context

### **A. AUTHENTICATION (Autenticación & OAuth2/OIDC)**

#### **RF-A1: Authorization Code Flow con PKCE**
- **Descripción:** Cliente SPA inicia login solicitando authorization code con PKCE challenge
- **Endpoint:** `GET /api/v1/tenants/{tenantSlug}/oauth2/authorize?client_id=...&redirect_uri=...&response_type=code&scope=...&code_challenge=...&code_challenge_method=S256`
- **Respuesta:** Redirect a `redirect_uri` con `?code=...&state=...`
- **Validaciones:**
  - `redirect_uri` registrada en ClientApp
  - `code_challenge` no-vacío, length 43-128 (base64url)
  - `state` preservado (no puede ser nulo)
- **Status:** ✅ Completado
- **Propuestas asociadas:** T-059 (futuro: redirect HTTP 302 en lugar de JSON)

#### **RF-A2: Token Exchange (Authorization Code → Access Token + ID Token + Refresh Token)**
- **Descripción:** Cliente backend intercambia `code` por tokens JWT
- **Endpoint:** `POST /api/v1/tenants/{tenantSlug}/oauth2/token` (application/x-www-form-urlencoded)
- **Parámetros:** `grant_type=authorization_code, code=..., code_verifier=..., client_id=..., client_secret=...`
- **Respuesta:** `{ access_token, token_type=Bearer, expires_in, id_token, refresh_token }`
- **Validaciones:**
  - `code` válido y no expirado (TTL 10 min)
  - `code_verifier` matched PKCE challenge
  - `client_id`+`client_secret` correcto
  - Usuario no suspendido
  - Scope solicitado no excede scopes app
- **Status:** ✅ Completado
- **Propuestas asociadas:** T-043 (filtro scope en userinfo)

#### **RF-A3: Refresh Token Rotation**
- **Descripción:** Cliente intercambia refresh token por nuevo access token + nuevo refresh token
- **Endpoint:** `POST /api/v1/tenants/{tenantSlug}/oauth2/token` (grant_type=refresh_token)
- **Parámetros:** `grant_type=refresh_token, refresh_token=..., client_id=..., client_secret=...`
- **Respuesta:** `{ access_token, refresh_token (NUEVO), expires_in, token_type=Bearer }`
- **Validaciones:**
  - Refresh token no expirado (TTL 30 días)
  - Hash SHA-256 válido (no tampering)
  - Status ≠ REVOKED (sino rechaza)
  - Estado anterior NO USED (sino = replay attack → revocar cadena, T-035)
- **Comportamiento:** Nuevo refresh token reemplaza anterior; anterior queda status=USED
- **Status:** ✅ Completado
- **Propuestas asociadas:** T-035 (detección replay automática), T-036 (TTL configurable)

#### **RF-A4 a RF-A11: Otros Requisitos Auth**
[Ver archivo completo en backend para RF-A4 a RF-A11: Token Revocation, Userinfo Endpoint, JWKS, Client Credentials, Email Verification, Password Reset, Credential Validation, i18n]

**Status:** ✅ Completados (ver backend requirements.md para detalles)

---

### **B. TENANT MANAGEMENT (Gestión de Tenants)**

#### **RF-B1: CRUD de Tenants**
- **Status:** ✅ Completado

#### **RF-B2: Multi-Tenant Isolation**
- **Status:** ✅ Completado

#### **RF-B3 a RF-B6: User Management, Roles Jerárquicos, Memberships, Stats**
- **Status:** ✅ Completado (ver backend requirements.md para detalles)

---

### **C. BILLING (Facturación & Suscripciones)**

#### **RF-C1 a RF-C6: Catálogo de Planes, Contratos, Email Verification, Facturas, Pagos, Catálogo Público**
- **Status:** ✅ Parcial / 🔲 Pendiente

**Requisito Crítico Pendiente:**
- **T-084: Payment Gateway Real** (Stripe, MercadoPago) — Actualmente solo mock
- **T-085: Renovación Automática** — Pendiente
- **T-089: Multi-moneda** — Pendiente
- **T-090: Dunning (Failed Payments)** — Pendiente

---

### **D. ACCOUNT (Self-Service del Usuario)**

#### **RF-D1: Perfil de Usuario**
- **Status:** ✅ Completado

#### **RF-D2: Gestión de Sesiones**
- **Status:** ✅ Completado

#### **RF-D3 a RF-D6: Cambio Password, Acceso/Permisos, Preferencias, Account Connections**
- **Status:** ✅ Completado (excepto F-042: Account Connections)

---

## 2. Requerimientos No-Funcionales

### **RNF-SEC: Seguridad**
- ✅ Bearer Token Only (RS256)
- ✅ Multi-Tenant Isolation
- ✅ RBAC (Role-Based Access Control)
- ✅ PKCE (OAuth2 Security)
- ✅ Refresh Token Rotation
- ✅ Password Security (BCrypt)
- ✅ Anti-Enumeration (Forgot Password)
- 🔲 Rate Limiting (Futuro)

---

### **RNF-PERF: Rendimiento**
- ✅ Paginación DB-Side (JPA Specifications)
- 🔲 Caché Dashboard (T-074)
- 🟡 Índices DB (Parcial, validación no automatizada)
- ✅ Connection Pool (HikariCP)

---

### **RNF-OBS: Observabilidad**
- 🟡 Logging Estructurado (Parcial)
- 🟡 Trace ID / Request ID (Parcial)
- 🔲 Métricas (Futuro T-073)
- ✅ Health Check
- 🔲 Audit Trail (Futuro T-076)

---

### **RNF-DATA: Persistencia & Datos**
- ✅ PostgreSQL 15+
- ✅ Flyway Migraciones
- ✅ JPA Validation
- 🟡 Soft Deletes (Parcial)

---

### **RNF-I18N: Internacionalización**
- ✅ Locale Resolution
- ✅ Error Messages Localizados
- 🟡 Soporte Múltiples Idiomas (Base: es, en-US; Futuro: expansión)

---

### **RNF-COMPAT: Compatibilidad**
- ✅ OpenAPI / Swagger
- ✅ Response Envelope
- ✅ HTTP Status Codes
- ✅ Error Response Format

---

## 3. Resumen Ejecutivo

### **Cobertura Actual**
- **Funcional:** 85% ✅
- **No-funcional:** 70% ✅

### **Capacidades Completas**
- ✅ Autenticación OAuth2/OIDC completa
- ✅ Gestión multi-tenant
- ✅ Self-service account
- ✅ Billing base (sin gateway real)

### **Pendientes Críticas**
- 🔴 Payment Gateway Real (T-084)
- 🔴 Rate Limiting
- 🔴 Métricas & Observabilidad avanzada

---

**Para detalles completos**, consultar backend requirements.md original (595 líneas).

**Próximas actualizaciones**: Consolidar otros bounded contexts (Tenants, Billing, Account) conforme se completen implementaciones.
