[← Index](./README.md)

---

# API Endpoints Catalog (Quick Reference)

## Purpose

Quick reference table for all API endpoints. Use for implementation and documentation.

> **Note**: This is a template. Adapt paths, parameters, and response fields to your project.

---

## Endpoints by Domain

### Discovery

| Method | Path | Description | Auth | Status |
|--------|------|-------------|------|--------|
| GET | /health | Health check | ❌ | 200 |
| GET | /api/v1/info | Service info | ❌ | 200 |

---

### Auth

| Method | Path | Description | Auth | Request | Response | Status |
|--------|------|-------------|------|---------|----------|--------|
| POST | /api/v1/auth/register | Register user | ❌ | email, password | user | 201 |
| POST | /api/v1/auth/login | Login | ❌ | email, password | token | 200 |
| POST | /api/v1/auth/logout | Logout | ✅ | - | 200 |

---

### Users

| Method | Path | Description | Auth | Request | Response | Status |
|--------|------|-------------|------|---------|----------|--------|
| GET | /api/v1/users | List users | ✅ | page?, limit? | data[], meta | 200 |
| GET | /api/v1/users/:id | Get user | ✅ | - | user | 200 |
| POST | /api/v1/users | Create user | ✅ | user | user | 201 |
| PATCH | /api/v1/users/:id | Update user | ✅ | user | user | 200 |
| DELETE | /api/v1/users/:id | Delete user | ✅ | - | 204 |

**Path Parameters**: `id` (UUID)

**Query Parameters**: `page`, `limit`, `search`

---

### Sessions

| Method | Path | Description | Auth | Request | Response | Status |
|--------|------|-------------|------|---------|----------|--------|
| GET | /api/v1/sessions | List sessions | ✅ | - | data[] | 200 |
| DELETE | /api/v1/sessions/:id | Revoke session | ✅ | - | - | 204 |

---

### Organizations (if multi-tenant)

| Method | Path | Description | Auth | Request | Response | Status |
|--------|------|-------------|------|---------|----------|--------|
| GET | /api/v1/organizations | List orgs | ✅ | - | data[] | 200 |
| GET | /api/v1/organizations/:id | Get org | ✅ | - | org | 200 |
| POST | /api/v1/organizations | Create org | ✅ | org | org | 201 |

---

### Applications (if client apps)

| Method | Path | Description | Auth | Request | Response | Status |
|--------|------|-------------|------|---------|----------|--------|
| GET | /api/v1/applications | List apps | ✅ | - | data[] | 200 |
| POST | /api/v1/applications | Register app | ✅ | app | app | 201 |

---

## Error Responses

| Status | Code | Scenario |
|--------|------|----------|
| 400 | BAD_REQUEST | Invalid parameters |
| 401 | UNAUTHORIZED | Invalid/missing token |
| 403 | FORBIDDEN | No permission |
| 404 | NOT_FOUND | Resource not found |
| 409 | CONFLICT | Duplicate, state conflict |
| 422 | VALIDATION_ERROR | Business rule violation |
| 429 | RATE_LIMITED | Too many requests |
| 500 | INTERNAL_ERROR | Server error |

### Error Format

```json
{
  "error": {
    "code": "CODE",
    "message": "Description",
    "details": [{ "field": "field", "message": "reason" }]
  }
}
```

---

## Standard Response Wrappers

### Collection Response
```json
{
  "data": [],
  "meta": { "page": 1, "limit": 20, "total": 100 }
}
```

### Single Response
```json
{
  "data": {}
}
```

### No Content
```json
// No body
```

---

## Implementation Checklist

- [ ] All endpoints documented
- [ ] Authentication middleware
- [ ] Authorization checks
- [ ] Validation
- [ ] Error handling
- [ ] Rate limiting
- [ ] Logging

---

[← Index](./README.md)