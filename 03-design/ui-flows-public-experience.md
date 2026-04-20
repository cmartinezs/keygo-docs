# Design: UI Flows — Public Experience

**Fase:** 03-design | **Audiencia:** Product, UX, frontend devs | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Public Surfaces](#public-surfaces)
2. [Landing Page](#landing-page)
3. [Login Flow (OAuth2 PKCE)](#login-flow-oauth2-pkce)
4. [Registration Flow](#registration-flow)
5. [Password Recovery](#password-recovery)
6. [Signup/Subscription Flow](#signupsubscription-flow)

---

## Public Surfaces

| Area | Route | Purpose | Auth Required |
|------|-------|---------|----------------|
| **Landing** | `/` | Present platform, CTA to login/signup | No |
| **Login** | `/login` | OAuth2 PKCE flow or direct login | No |
| **Register** | `/register` | Self-registration | No |
| **Forgot Password** | `/forgot-password` | Request password reset | No |
| **Reset Password** | `/reset-password?token=...` | Reset with token | No |
| **Subscription** | `/subscribe` | Billing, contract signing, onboarding | No |
| **Status Page** | `/status` | System health | No |

---

## Landing Page

### Content

```
Hero Section:
  - Product tagline: "Identity & Access Management for Modern Teams"
  - CTA buttons: "Login" → /login | "Start Free Trial" → /subscribe

Features Section:
  - Multi-tenancy
  - OAuth2 / OIDC
  - Role-Based Access Control
  - Audit Logging

Pricing Section:
  - Plans pulled from /api/v1/billing/catalog
  - Translatable: plan names, descriptions, CTAs

Trust Section:
  - "Trusted by X organizations"
  - SOC2, GDPR badges

Footer:
  - Links: About, Docs, Terms, Privacy
  - Language selector
```

### Behavior

- No login required
- Language selector affects all content
- Loading errors: show toast, link to status page

---

## Login Flow (OAuth2 PKCE)

### Flow Diagram

```
User at /login
  ↓
Select "Login with OAuth2"
  ↓
Frontend generates code_verifier + code_challenge + state
  ↓
Redirect to GET /oauth2/authorize?
  client_id=...&
  code_challenge=...&
  code_challenge_method=S256&
  state=...
  ↓
Backend: shows login form (username + password)
  ↓
User enters credentials
  ↓
Backend: validates, generates code
  ↓
Backend: redirects to /callback?code=...&state=...
  ↓
Frontend: validates state (CSRF check)
  ↓
Frontend: exchanges code for tokens
  POST /oauth2/token with code + code_verifier
  ↓
Backend: validates, returns access_token + id_token
  ↓
Frontend: stores tokens in memory
  ↓
Redirect to /dashboard
```

### Error Handling

```
Invalid credentials:
  Show toast: "Username or password incorrect"
  Keep user on login form
  Increment failed login counter

Session expired during login:
  Show toast: "Session expired; try again"
  Redirect to /login

Invalid code_challenge:
  Show error page: "Login failed; try again"
  Logs security event
```

---

## Registration Flow

### Step 1: Email Verification

```
User enters email: john@example.com
  ↓
POST /api/v1/platform/account/check-email
  → 200: Email exists (show error)
  → 404: Email available (continue)
  → 401: Session invalid (redirect to login)
  ↓
Send verification code to email
  ↓
User enters code: 123456
  ↓
Verify code, unlock next step
```

### Step 2: User Details

```
Fields:
  - First name
  - Last name
  - Password (validated: 12 chars, 4 character classes)
  - Agree to terms (checkbox)
  ↓
POST /api/v1/platform/account/register
  ↓
Backend: creates user, sends welcome email
  ↓
Redirect to /login (require fresh login)
```

---

## Password Recovery

### Flow

```
1. Forgot Password Page
   User enters email: john@example.com
   Submit
   
   Backend: checks if email exists (no enumeration)
   → Always responds 200: "Check your email for reset link"

2. Email Arrives
   Click: "Reset password"
   → Redirects to /reset-password?token=abc123xyz

3. Reset Page
   Enter new password (12 chars, 4 classes)
   Submit
   
   POST /api/v1/platform/account/reset-password
     body: { token, newPassword }
   
   Backend: validates token, updates password
   
   → Redirect to /login with toast: "Password updated; login now"

4. Error Handling
   - Expired token (> 24h): "Link expired; request new one"
   - Invalid token: "Invalid link; try again"
```

---

## Signup/Subscription Flow

### Step 1: Plan Selection

```
Show catalog from GET /api/v1/billing/catalog

For each plan:
  - Name (translated)
  - Price (monthly/annual selector)
  - Features list
  - CTA button: "Subscribe" or "Start 14-Day Trial"
  
User selects a plan
  ↓
Store in form: selectedPlan
```

### Step 2: Your Details (Email Validation)

```
Form fields:
  - First name
  - Last name
  - Email
  
User clicks "Continue"
  ↓
POST /api/v1/platform/account/check-email?email=john@example.com
  
  Response 200: { "status": "EMAIL_EXISTS" }
    → Show error: "Email already registered; use login or different email"
    → Stay on same step
  
  Response 404: { "status": "EMAIL_AVAILABLE" }
    → Continue to Step 3: Terms
  
  Response 401: { "status": "SESSION_INVALID" }
    → Reestablish session (call platformAuthorize())
    → Retry check-email
```

### Step 3: Terms & Review

```
Display:
  - Plan summary (name, price, trial info)
  - Terms of Service (scroll required)
  - Checkbox: "I agree to terms"

User clicks "Continue"
  ↓
Proceed to Step 4: Payment
```

### Step 4: Payment (Stripe)

```
Stripe element embedded

User enters:
  - Card number
  - Expiry
  - CVC

User clicks "Complete Purchase"
  ↓
Frontend: Stripe creates payment token
  ↓
POST /api/v1/billing/contracts { stripeToken, planId, ... }
  ↓
Backend: processes payment, creates contract
  ↓
Success: Redirect to /signup-success
  ↓
Email: "Welcome! Your subscription is active"
```

### Resume Mode

```
URL: /subscribe?resume=1&contract_id=abc123

Behavior:
  - Pre-fill contract_id field (read-only)
  - Skip plan selection
  - Go directly to "Your Details" step
  - Cannot change plan mid-flow
```

---

## Véase También

- **ui-flows-rbac-areas.md** — Authenticated user areas
- **frontend-architecture.md** — Tech stack for implementing flows
- **frontend-auth-implementation.md** — Token handling

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Product/UX | **Licencia:** Keygo Docs
