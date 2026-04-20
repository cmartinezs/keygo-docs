# Operations: Incident Response Guide

**Fase:** 10-monitoring | **Audiencia:** On-call engineers, SRE, incident commanders | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Severity Levels](#severity-levels)
2. [Incident Triage](#incident-triage)
3. [Runbooks by Incident Type](#runbooks-by-incident-type)
4. [Escalation & Notifications](#escalation--notifications)
5. [Postmortem Process](#postmortem-process)

---

## Severity Levels

### SEV-1: Critical (Immediate Response)

```
Impact: Complete service outage or data loss imminent
Duration tolerance: < 5 minutes
Response time: < 2 minutes (page on-call immediately)

Examples:
  - All requests return 500
  - Database is down
  - Authentication broken (no user can login)
  - Data corruption detected
```

### SEV-2: High (Urgent)

```
Impact: Degraded service, subset of users affected
Duration tolerance: < 30 minutes
Response time: < 5 minutes (page on-call within next cycle)

Examples:
  - 50% of requests fail
  - Specific tenant cannot login
  - API latency > 5 seconds
  - Payment processing broken
```

### SEV-3: Medium (Normal Priority)

```
Impact: Minor functionality broken, workaround available
Duration tolerance: < 4 hours
Response time: < 30 minutes (standard on-call)

Examples:
  - Some features unavailable
  - UI display issue (not blocking)
  - Slow performance (but usable)
  - Non-critical API endpoint down
```

### SEV-4: Low (Backlog)

```
Impact: Cosmetic or informational
Duration tolerance: Next sprint
Response time: During business hours

Examples:
  - Typos in UI
  - Documentation outdated
  - Deprecated feature still working
```

---

## Incident Triage

### Page On-Call (SEV-1 & SEV-2)

```bash
# 1. Acknowledge alert (< 2 min)
# Pagerduty → Acknowledge

# 2. Assess severity
# Check: customer impact, affected services, user count

# 3. Create war room
# Slack: #incident-sev-1
# Zoom: [war-room-link]

# 4. First actions
# - Check /actuator/health
# - Review recent deployments (git log)
# - Check metrics (CPU, memory, DB connections)
```

### Assessment Matrix

| Signal | Likely Issue | Action |
|--------|-------------|--------|
| HTTP 503 (Service Unavailable) | Overload or crash | Restart app or scale |
| HTTP 500 (Internal Server Error) | Bug or DB issue | Check logs, rollback if recent deploy |
| HTTP 401 (Unauthorized) | Auth broken | Check JWT signing key, JWKS endpoint |
| High latency (> 5s) | DB slow or network | Check DB connection pool, query performance |
| Memory leak (heap > 90%) | OOM pending | Restart app, investigate heap dump |

---

## Runbooks by Incident Type

### INC-001: High Error Rate (> 5% 5xx)

```
Triage:
  1. Check /actuator/metrics/http.server.requests
     Count 5xx / total > 5% → confirmed

Decision tree:
  A. Recent deployment (< 10 min)?
     → Rollback immediately
     kubectl rollout undo deployment/keygo-server
  
  B. Database slow (queries > 2 sec)?
     → Check connections, kill long-running queries
     SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE duration > '30 min'
  
  C. Out of memory?
     → Restart pod
     kubectl delete pod <pod-id>
     
Verify recovery:
  - Error rate drops to < 1% within 5 min
  - No new alerts fire
  - Customer reports OK

Escalate if:
  - Still failing after 15 min
  - Multiple components affected
```

### INC-002: Database Connection Pool Exhausted

```
Triage:
  1. Check pool usage
     curl http://localhost:8080/actuator/metrics | grep db_connections
  
  2. Identify long-running transactions
     SELECT pid, usename, query, query_start 
     FROM pg_stat_activity 
     WHERE query NOT LIKE '%idle%'
     ORDER BY query_start;

Action:
  A. Kill idle connections
     SELECT pg_terminate_backend(pid) 
     FROM pg_stat_activity 
     WHERE state = 'idle' AND query_start < NOW() - INTERVAL '30 min'
  
  B. Increase pool size (temporary)
     export SPRING_DATASOURCE_HIKARI_MAXIMUM_POOL_SIZE=50
     kubectl set env deployment/keygo-server ...
  
  C. Scale database (if persistent)
     Upgrade instance type in cloud provider

Verify:
  - Pool usage < 80%
  - No connection timeouts
```

### INC-003: Tenant Reports Cannot Login

```
Triage:
  1. Check tenant status
     curl http://admin.example.com/api/v1/tenants/acme-corp
     → status: ACTIVE (expected)
     → status: SUSPENDED (explain: see admin console)
  
  2. Check user status
     curl http://admin.example.com/api/v1/users?email=john@acme.com
     → status: ACTIVE (expected)
     → status: SUSPENDED (explain: locked out, try reset password)
  
  3. Check authentication service
     curl http://localhost:8080/.well-known/openid-configuration
     → 200 OK (expected)
     → Error (identity context broken, page SRE)
  
  4. Check user's recent attempts
     grep "john@acme.com" logs/keygo*.log | tail -20
     → "invalid_password (attempt 3/3)" = account locked
     → "session_not_valid" = token expired (refresh and retry)

Action:
  A. Account locked
     → Reset password via admin console
     → Send email to user
  
  B. Tenant suspended
     → Verify this is intentional (billing issue?)
     → Contact customer, reactivate if needed
  
  C. Token invalid/expired
     → User refreshes browser (F5)
     → Tokens regenerated

Communicate:
  - Slack: Update #incident-sev-2 with root cause
  - Email: Customer notification if extended outage
```

### INC-004: Payment Processing Broken

```
Triage:
  1. Check Stripe integration
     POST http://localhost:8080/actuator/health/stripe
     → UP (expected)
     → DOWN (Stripe API unreachable, page infrastructure team)
  
  2. Check recent payment attempts
     SELECT * FROM billing_transactions 
     WHERE created_at > NOW() - INTERVAL '1 hour'
     ORDER BY created_at DESC
     → status: FAILED (Stripe returned error)
     → status: PENDING (webhook not received)

Action:
  A. Stripe API down
     → Acknowledge maintenance window
     → Pause subscription page
     → Queue payments for retry
  
  B. Webhook processing failures
     → Check logs for Stripe webhook handler errors
     → Retry webhook from Stripe dashboard
  
  C. Payment intent expired (> 24h)
     → Customer retries, generates new intent

Verify:
  - New transactions succeeding
  - Pending transactions resolved
```

---

## Escalation & Notifications

### Escalation Chain (5-min intervals if no response)

```
1. Page Primary On-Call (< 2 min)
   If no response → next level at T+5

2. Notify Backup On-Call + SRE Lead (T+5)
   If no response → next level at T+10

3. Page Engineering Manager + VP Eng (T+10)
   If no response → next level at T+15

4. CEO Notification (if still ongoing) (T+15)
   "Customer impact, ETA for resolution?"
```

### Customer Communication

```
At T+5: Internal Slack alert posted
At T+15: Status page updated: "Investigating [issue]"
At T+30: Status page: "Identified root cause, working on fix"
At T+60: Status page: "Fix deployed, monitoring"
At T+5 after recovery: "Incident resolved. Postmortem scheduled."
```

### War Room Protocol

```
Zoom link: [keygo-incident-response]
Participants: On-call, SRE, PM, CEO (if SEV-1)

Cadence:
  - Initial briefing (T+2)
  - Updates every 5 minutes
  - Final update when resolved

Scribe: Takes notes for postmortem
Commander: Decides actions, coordinates teams
```

---

## Postmortem Process

### Timeline (Done within 48 hours of resolution)

```
T+0: Incident starts
T+X: Incident resolved
T+2 hours: Initial postmortem meeting
T+24 hours: Detailed postmortem report
T+48 hours: Root cause analysis + action items
```

### Postmortem Template

```markdown
# Incident Postmortem: [INC-001] High Error Rate on 2026-04-20

## Incident Summary
- **Duration:** 2026-04-20 14:00 - 14:47 UTC (47 minutes)
- **Severity:** SEV-2
- **Impact:** 500 users, 12 failed login attempts, $50K potential revenue loss

## Timeline
- 14:00: Alert fired (error rate 8.5%)
- 14:03: On-call paged
- 14:05: War room created, identified DB slow queries
- 14:30: DB connection pool exhausted
- 14:35: Restarted app, pool recovered
- 14:47: Error rate < 1%, all clear

## Root Cause
Backend deployment (v1.1.0) introduced N+1 query in user listing endpoint.
When tenant admin fetched users, query executed once per user instead of once total.
With 1000 users, this triggered 1000 DB queries in parallel → connection pool exhausted.

## Why Wasn't This Caught?
- Load testing only with 100 users (should test with 1000+)
- Code review missed the nested loop + query
- Integration tests don't run against real DB size

## Resolution
- Rolled back to v1.0.5
- Fixed query in feature branch
- Added integration test with 1000 users
- Re-deployed v1.1.1 after 2 hours

## Preventive Actions (Action Items)
- [ ] Add load testing with 5000 users to CI pipeline (Owner: @alice, Due: 2026-05-04)
- [ ] Code review checklist for N+1 queries (Owner: @bob, Due: 2026-05-01)
- [ ] Alert on "connections_active > 80% of max" (Owner: @carol, Due: 2026-04-25)
- [ ] Update runbook INC-002 with faster diagnosis (Owner: @dave, Due: 2026-04-23)

## Lessons Learned
1. Load testing is crucial before major deploys
2. Connection pool limits need monitoring
3. Alert thresholds should fire earlier (80% not 95%)
```

---

## Véase También

- **production-runbook.md** — Operational procedures (health checks, scaling)
- **security-testing-plan.md** — Security incidents specific guidance
- **pipeline-strategy.md** — How to quickly rollback if needed

---

**Última actualización:** 2025-Q1 | **Mantenedor:** SRE/Ops | **Licencia:** Keygo Docs
