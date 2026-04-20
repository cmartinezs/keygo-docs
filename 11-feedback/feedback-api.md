[← Índice](./README.md)

---

# Feedback API

APIs para gestión de feedback.

## Contenido

- [Feedback CRUD](#feedback-crud)
- [Survey Management](#survey-management)
- [NPS Configuration](#nps-configuration)
- [Admin APIs](#admin-apis)

---

## Feedback CRUD

### Create Feedback

```
POST /api/v1/tenants/{tenantSlug}/feedback
Authorization: Bearer {token}
Content-Type: application/json

{
  "type": "nps",
  "score": 9,
  "reason": "Fácil de usar",
  "follow_up": "Me gustaría mejor integración"
}
```

**Response:**
```json
{
  "data": {
    "id": "fb-uuid",
    "type": "nps",
    "score": 9,
    "status": "received",
    "created_at": "2024-01-15T10:00:00Z"
  },
  "success": { "code": "FEEDBACK_RECEIVED" }
}
```

### Get Feedback

```
GET /api/v1/tenants/{tenantSlug}/feedback/{id}
Authorization: Bearer {token}
```

### List Feedback

```
GET /api/v1/tenants/{tenantSlug}/feedback
Authorization: Bearer {token}
Query params:
  - type: nps|survey|bug|feature|general
  - status: received|reviewed|resolved|closed
  - from: ISO date
  - to: ISO date
  - page: 0
  - size: 20
```

 [↑ Volver al inicio](#feedback-api)

---

## Survey Management

### Get Active Surveys

```
GET /api/v1/tenants/{tenantSlug}/feedback/surveys
Authorization: Bearer {token}
```

**Response:**
```json
{
  "data": [
    {
      "id": "post-onboarding-2024",
      "name": "Post Onboarding",
      "trigger": "days_since_onboarding > 7",
      "questions": [...],
      "completed_count": 45,
      "pending_count": 12
    }
  ]
}
```

### Take Survey

```
POST /api/v1/tenants/{tenantSlug}/feedback/surveys/{surveyId}/responses
Authorization: Bearer {token}
Content-Type: application/json

{
  "answers": [
    { "question_id": "q1", "answer": 5 },
    { "question_id": "q2", "answer": "Muy claro" }
  ]
}
```

### List Survey Responses (Admin)

```
GET /api/v1/tenants/{tenantSlug}/feedback/surveys/{surveyId}/responses
Authorization: Bearer {token}
Query params:
  - page: 0
  - size: 20
```

 [↑ Volver al inicio](#feedback-api)

---

## NPS Configuration

### Get NPS Settings

```
GET /api/v1/tenants/{tenantSlug}/feedback/nps/config
Authorization: Bearer {token}
```

### Update NPS Settings

```
PATCH /api/v1/tenants/{tenantSlug}/feedback/nps/config
Authorization: Bearer {token}
Content-Type: application/json

{
  "enabled": true,
  "triggers": {
    "post_login": {
      "enabled": true,
      "frequency": "once"
    }
  },
  "score_thresholds": {
    "detractor": 6,
    "passive": 8,
    "promoter": 9
  }
}
```

### Get NPS Stats

```
GET /api/v1/tenants/{tenantSlug}/feedback/nps/stats
Authorization: Bearer {token}
```

**Response:**
```json
{
  "data": {
    "nps_score": 42,
    "total_responses": 156,
    "promoters": 89,
    "passives": 34,
    "detractors": 33,
    "promoters_pct": 57,
    "passives_pct": 22,
    "detractors_pct": 21,
    "trend": [
      { "month": "2024-01", "nps": 38 },
      { "month": "2024-02", "nps": 42 }
    ]
  }
}
```

 [↑ Volver al inicio](#feedback-api)

---

## Admin APIs

### List All Feedback

```
GET /api/v1/platform/feedback
Authorization: Bearer {token} (keygo_admin)
Query params:
  - tenant: tenant-slug
  - type: nps|survey|bug|feature|general
  - severity: critical|high|medium|low
  - status: received|reviewed|resolved|closed
  - assigned_to: user-id
```

### Assign Feedback

```
PATCH /api/v1/platform/feedback/{id}/assign
Authorization: Bearer {token} (keygo_admin)
Content-Type: application/json

{
  "assigned_to": "user-uuid"
}
```

### Update Status

```
PATCH /api/v1/platform/feedback/{id}/status
Authorization: Bearer {token} (keygo_admin)
Content-Type: application/json

{
  "status": "resolved",
  "resolution_notes": "Fixed in v1.2.0"
}
```

### Export Feedback

```
GET /api/v1/platform/feedback/export
Authorization: Bearer {token} (keygo_admin)
Query params:
  - type: nps|survey|bug|feature|general
  - from: ISO date
  - to: ISO date
  - format: csv|json

Response: File download
```

 [↑ Volver al inicio](#feedback-api)

---

[← Índice](./README.md)