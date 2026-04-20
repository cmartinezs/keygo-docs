# Operations: Admin Console Guide

**Fase:** 09-operations | **Audiencia:** Platform admins, operators | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Acceso al Admin Console](#acceso-al-admin-console)
2. [Dashboard Principal](#dashboard-principal)
3. [Gestión de Tenants](#gestión-de-tenants)
4. [Gestión de Usuarios](#gestión-de-usuarios)
5. [Gestión de Roles](#gestión-de-roles)
6. [Auditoría & Logs](#auditoría--logs)
7. [Incident Response desde Admin](#incident-response-desde-admin)

---

## Acceso al Admin Console

### URL

```
https://console.example.com/admin
```

### Requisitos

- Rol: `KEYGO_ADMIN` en JWT
- 2FA habilitado (recomendado)
- Último login < 90 días

### Flows

```
Platform Admin (rol KEYGO_ADMIN):
  ├─ Ver todos los tenants
  ├─ Crear / suspender tenants
  ├─ Ver todos los usuarios
  └─ Auditar operaciones globales

Tenant Admin (rol KEYGO_ACCOUNT_ADMIN):
  ├─ Ver solo su tenant
  ├─ Invitar / remover usuarios
  ├─ Asignar roles dentro de tenant
  └─ Auditar operaciones de tenant
```

---

## Dashboard Principal

### Home

**Panel overview:**
- Total tenants: `X`
- Total usuarios: `Y`
- Signups this week: `Z`
- Failed logins: `W` (últimas 24h)

**Acciones rápidas:**
- Create tenant
- Invite user
- View incidents
- Check health status

**Métricas:**
- API response time (p95)
- Database connections
- Error rate

---

## Gestión de Tenants

### Crear Tenant

```
Admin → Tenants → Create

Formulario:
  Organization Name: "Acme Corp"
  Organization Slug: "acme"  [auto-generated]
  Plan: "Enterprise" | "Standard" | "Free"
  Contact Email: "admin@acme.com"
  Max Users: 100

Submit → Creates tenant
       → Genera API keys
       → Envía email de bienvenida
```

### Suspender Tenant

```
Tenants → Select "Acme Corp" → Suspend

Confirmación:
  ❌ Usuarios no pueden loguear
  ❌ APIs retornan 403 Forbidden
  ✅ Datos siguen almacenados (2 años legal hold)

Reason: abuse, non-payment, compliance
```

### Audit Tenant

```
Tenants → "Acme Corp" → Audit

Muestra:
  - Created: 2026-01-15
  - Last login: 2026-04-20 14:30 UTC
  - Users: 42
  - API calls: 1.2M/month
  - Incidents: 3 (últimas 30 días)
```

---

## Gestión de Usuarios

### Listar Usuarios de Tenant

```
Tenants → "Acme Corp" → Users

Tabla:
  Email | Name | Role | Status | Last Login | Actions
  
  john@acme.com | John Doe | ADMIN | ACTIVE | 2h ago | Reset password | Suspend
  alice@acme.com | Alice S. | USER | ACTIVE | 3d ago | Reset password | Suspend
```

### Resetear Contraseña

```
Users → John Doe → Reset Password

Acción:
  ✓ Genera token temporal
  ✓ Envía email: "Click to reset password"
  ✓ Token válido por 24h
  ✓ Registra en audit log: "admin reset password"
```

### Suspender Usuario

```
Users → John Doe → Suspend

Efecto:
  ❌ Token revocado inmediatamente
  ✅ Datos almacenados
  ✅ Puede ser reactivado
```

---

## Gestión de Roles

### Ver Roles de Tenant

```
Roles → List

Tabla:
  Role | Users | Permissions
  
  ADMIN | 3 | create:users, delete:users, manage:roles, read:audit
  USER | 42 | read:own_profile, update:own_profile
```

### Asignar Rol

```
Users → John Doe → Change Role

Dropdown: ADMIN | USER | READONLY

Confirmación:
  ✓ John now has ADMIN role
  ✓ John receives email notification
  ✓ Audit log: "admin assigned ADMIN role to john@acme.com"
```

---

## Auditoría & Logs

### Audit Log

```
Admin → Audit Log

Filtros:
  - Date range
  - Action type: login, create_user, delete_user, suspend_tenant, etc.
  - Actor: admin email
  - Resource: tenant, user, role

Cada entrada:
  2026-04-20 14:30 UTC | admin@example.com | suspend_tenant | acme | Reason: non-payment
```

### Búsqueda

```
Search: john@acme.com

Results:
  - Created user: 2026-01-20
  - Last login: 2026-04-20 14:30
  - Failed logins: 2 (último: 2026-04-19)
  - Role changes: ADMIN (since 2026-02-01)
```

---

## Incident Response desde Admin

### Detectar Incidente

**Alta tasa de errores:**
```
Dashboard → Metrics → Error rate: 5% (threshold: 1%)

Acción:
  ✓ Check health: /actuator/health → OK
  ✓ Check DB connections → 80% utilization
  ✓ Page SRE on-call → "DB connections high"
```

**Tenant reporta no puede loguear:**
```
Dashboard → Search user: alice@acme.com

Results:
  ✓ User exists, role: USER, status: ACTIVE
  ✓ Last failed login: 2026-04-20 14:25 (wrong password 3x)
  
  Acción:
  ✓ Reset password
  ✓ Notify user: "Password reset link sent"
  ✓ Monitor failed attempts
```

**Suspicious activity:**
```
Audit Log → Filter: "failed_login"

Results:
  2026-04-20 14:00 | bob@tenant.com | failed_login | reason: invalid_password (attempt 1/3)
  2026-04-20 14:05 | bob@tenant.com | failed_login | reason: invalid_password (attempt 2/3)
  2026-04-20 14:10 | bob@tenant.com | failed_login | reason: account_locked (attempt 3/3, locked)

Acción:
  ✓ Unlock user: "Potential password spray attack"
  ✓ Notify tenant: "Account was locked; check your security"
  ✓ Consider: reset password
```

---

## Véase También

- **production-runbook.md** — Operational procedures (when to use admin console)
- **incident-response-guide.md** — Escalation (when to page admin)
- **authorization-patterns.md** — How roles work technically

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Platform/Ops | **Licencia:** Keygo Docs
