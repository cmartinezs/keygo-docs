# Design: UI Flows — Role-Based Access Areas

**Fase:** 03-design | **Audiencia:** Product, UX, frontend devs | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Platform Administrator](#platform-administrator)
2. [Tenant Administrator](#tenant-administrator)
3. [End User (Member)](#end-user-member)
4. [Shared Features](#shared-features)
5. [Access Denied Handling](#access-denied-handling)

---

## Platform Administrator

### Responsibilities

- View system health and global platform metrics
- Manage tenants (create, suspend, reactivate)
- Manage platform users (invite, assign roles, suspend)
- Review audit logs and compliance reports
- Execute quick actions from dashboard

### Dashboard

```
Header:
  - Platform logo
  - Global search
  - Notification bell (system alerts)
  - User menu

Sidebar:
  - Dashboard
  - Tenants
  - Users
  - Audit Logs
  - Settings
  - Support

Main Content (Dashboard):
  - System Health Widget
    * Database status
    * API uptime
    * Active sessions
  - Quick Actions
    * Create Tenant
    * Invite User
    * View System Logs
  - Recent Activity (last 50 events)
    * Tenant created/suspended
    * User added/removed
    * Config changes
```

### Tenants Management

```
List View:
  - Table: Name | Slug | Status | Plan | Users | Created | Actions
  - Filters: Status (ACTIVE/SUSPENDED), Created Date
  - Sort: By Name, Created, Users
  - Bulk actions: Suspend multiple tenants

Tenant Detail View:
  - General Info: Name, slug, status, billing plan
  - Contact: Admin name, email, phone
  - Subscription: Plan, renewal date, billing status
  - Users: Count, link to users list
  - Actions: Suspend, Reactivate, Delete
  - Audit Log: Recent events (created, updated, suspended)

Create Tenant Flow:
  1. Form: Name, slug, admin email, admin name, initial plan
  2. Email verification (admin email)
  3. Confirm and create
  4. Redirect to tenant detail
```

### Users Management

```
List View:
  - Table: Name | Email | Username | Roles | Status | Created | Actions
  - Filters: Role (ADMIN, SUPPORT, VIEWER), Status
  - Sort: By name, created, status
  - Bulk actions: Assign role, suspend multiple

User Detail View:
  - Personal Info: Name, email, username, phone, picture
  - Identity: UUID, created date, last login
  
  - Roles Section:
    * List assigned roles (name, code, scope, date assigned)
    * Assign new role dropdown (exclude already assigned)
    * [+ Assign Role] button
  
  - When assigning KEYGO_ADMIN:
    * Show warning: "You are assigning ADMIN privileges. This user will have full platform access."
    * Require confirmation phrase: "I confirm assigning KEYGO_ADMIN to [username]"
    * Require operator password re-entry (CSRF protection)
    * Show loading state during assignment
    * Success notification: "KEYGO_ADMIN assigned to [username]"
  
  - Status:
    * If ACTIVE: Show "Suspend" button
    * If SUSPENDED: Show "Reactivate" button
  
  - When suspending:
    * Show warning: "Suspending [username] will revoke all sessions and API keys."
    * Require confirmation phrase: "I confirm suspending [username]"
    * Require operator password re-entry
    * Show loading state
    * Success: "User suspended"
  
  - When reactivating:
    * Show confirmation: "Reactivate [username]?"
    * No password re-entry required (less sensitive than suspend)
    * Success: "User reactivated"
  
  - Audit Log: Actions taken by/on this user
```

### Audit Logs

```
Query Interface:
  - Filters:
    * Event type: USER_CREATED, TENANT_SUSPENDED, etc.
    * Date range: Last 7 days / 30 days / custom
    * Actor: Which user/system performed the action
    * Resource: Which entity was affected
  
  - Columns: Timestamp | Event | Actor | Resource | Details | Status
  - Export: CSV, JSON

Example:
  2026-04-20 14:05 | TENANT_SUSPENDED | admin@keygo.com | ACME Corp | Billing overdue | SUCCESS
  2026-04-20 13:50 | USER_ASSIGNED_ROLE | admin@keygo.com | john@acme.com | KEYGO_ADMIN | SUCCESS
  2026-04-20 13:45 | USER_SUSPENDED | admin@keygo.com | carol@acme.com | Breach investigation | SUCCESS
```

---

## Tenant Administrator

### Responsibilities

- Manage users within their tenant
- Manage OAuth applications
- Manage team memberships and roles
- View subscription and billing
- Configure tenant settings

### Tenant Context

```
Header:
  - "Tenant: ACME Corp" (clickable, can switch between tenant contexts)
  - Tenant selector dropdown (if admin of multiple)

Sidebar:
  - Dashboard
  - Users
  - Applications
  - Memberships
  - Billing
  - Tenant Settings
  - Support
```

### Users Management (Tenant-Scoped)

```
List View:
  - Only users in THIS tenant
  - Table: Name | Email | Roles | Status | Last Login | Actions
  - Filters: Role, Status
  
  - Actions per user:
    * View details
    * Assign/remove roles within tenant
    * Invite to applications
    * Reset password (send reset email)
    * Suspend/reactivate

User Detail View:
  - Personal Info: Name, email, created date, last login
  - Roles: List roles assigned in this tenant
  - Applications: Apps user has access to
  - Sessions: Active sessions (count, device type)
  - Actions:
    * Assign/remove roles
    * Suspend/reactivate
    * Send password reset
    * View audit log
```

### Applications (OAuth Clients)

```
List View:
  - Table: Name | ID | Status | Scopes | Created | Actions
  - [+ Create Application] button

Application Detail:
  - Name, client_id, client_secret (masked, copy button)
  - Redirect URIs: List of allowed callback URLs
  - Scopes: Permissions requested (openid, profile, email, etc.)
  - Created/Last used dates
  - Actions:
    * Edit name/redirect URIs
    * Regenerate secret
    * Rotate keys (if multi-key support)
    * View authorized users
    * Revoke all tokens issued to this app
```

### Memberships & Roles

```
List View:
  - Show user → role → scope mappings
  - Table: User | App | Role | Assigned By | Assigned At | Actions
  
  - Actions:
    * Assign user to app with role
    * Remove user from app
    * Change role for user on app
```

### Billing

```
Plan Overview:
  - Current plan: [Plan Name]
  - Renewal date: [Date]
  - Cost per month: $[Amount]
  - Status: ACTIVE/PAST_DUE/SUSPENDED
  - [Upgrade] [Downgrade] buttons if available

Billing History:
  - Table: Date | Invoice ID | Amount | Status | Download
  - Filters: Status (PAID, PENDING, FAILED)
  - Export invoices

Payment Method:
  - Last 4 digits of card on file
  - [Update Payment Method] button
```

---

## End User (Member)

### Responsibilities

- View their own profile
- Change password
- Manage personal sessions
- Review access across applications
- Configure preferences (language, timezone)

### Dashboard (User View)

```
Header:
  - "Welcome, John"
  - Notification bell
  - User menu (Profile, Logout)

Main Content:
  - Quick links:
    * View Profile
    * Change Password
    * My Sessions
    * Integrations

Sidebar:
  - Dashboard
  - My Account
  - Preferences
  - Help
```

### Account Profile

```
Personal Info (Read-Only in Platform Scope):
  - Full name
  - Email
  - Username
  - Profile picture (if picture_url exists)
  - Created date

Edit Actions (Platform Scope):
  - First name
  - Last name
  - Phone
  - Locale (English, Spanish, etc.)
  - Timezone
  - Profile picture (upload or URL)

Note: If platform session, use GET/PATCH /api/v1/platform/account/profile
If tenant session, cannot edit (read-only tenant profile view)
```

### Change Password

```
Form:
  - Current password (validation)
  - New password (12 chars, 4 char classes)
  - Confirm password
  
  - Submit
  
  → Backend validates, updates, logs event
  → Success: "Password updated. For security, you'll be logged out."
  → Auto-logout, redirect to /login
```

### Sessions

```
List:
  - Table: Device Type | OS | Browser | IP Address | Created | Last Active | Actions
  
  Example:
    Chrome 120 | Windows 11 | 192.168.1.100 | 2026-04-15 | 2026-04-20 14:30 | [Logout]
    Safari 17 | macOS | 203.0.113.45 | 2026-04-18 | 2026-04-20 13:00 | [Logout]
  
  Actions:
    * [Logout this session] → immediate invalidation
    * [Logout all other sessions] → keep current, clear rest
```

---

## Shared Features

### Profile Header (Authenticated Shell)

```
In header/sidebar when authenticated:
  - Display: User's name + email (NOT UUID or technical ID)
  - Picture: If picture_url exists, display avatar
  - Fallback: Initials avatar if no picture
  - Source: GET /api/v1/platform/account/profile on F5 recovery
    (if token doesn't contain friendly claims)
```

### Language Selector

```
Location: Header or settings
Values: en (English), es (Spanish), pt (Portuguese)
Behavior:
  - Changes affect: UI labels, form validation messages, error messages, help text
  - Selected language persisted in:
    * Local storage (browser)
    * User profile (backend) on next profile update
  - On login, default to user's profile language
  - On anonymous pages (login, signup, landing), use browser language or URL param
```

### Error Handling (Access Denied)

```
If user lacks permission (403 Forbidden):
  - Don't redirect to login
  - Don't hide error
  - Show: "Access Denied"
    * Message: "You don't have permission to access this resource."
    * Suggestion: "Contact your administrator if you believe this is an error."
    * [Report Issue] button → opens support form with context
    * [Go Back] button → return to previous page

If admin is checking user that doesn't exist (404):
  - Show: "User Not Found"
    * Message: "This user doesn't exist or has been deleted."
    * [Back to Users] button
```

---

## Véase También

- **ui-flows-public-experience.md** — Public experience (landing, login, signup)
- **frontend-architecture.md** — Tech stack for implementing RBAC
- **frontend-auth-implementation.md** — Role guards, token validation

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Product/UX | **Licencia:** Keygo Docs
