[← Índice](./README.md)

---

# Feedback Collection

Métodos para recolectar feedback de usuarios.

## Contenido

- [In-App Widget](#in-app-widget)
- [Email Campaigns](#email-campaigns)
- [Dashboard Widget](#dashboard-widget)
- [API](#api)
- [Integration](#integration)

---

## In-App Widget

### Widget Flotante

```tsx
// FeedbackWidget.tsx
import { FeedbackWidget } from '@keygo/ui';

<FeedbackWidget
  position="bottom-right"
  trigger={{
    type: 'time_on_page',
    value: 300  // 5 minutes
  }}
  types={['nps', 'bug', 'feature']}
/>
```

### Botón de Bug Report

```tsx
<Button
  icon="bug"
  onClick={() => openFeedbackModal('bug')}
>
  Report Bug
</Button>
```

### Modal de Feedback

```tsx
<FeedbackModal
  defaultType="nps"
  onSubmit={handleFeedbackSubmit}
  // NPS
  npsProps={{
    question: '¿Cómo calificarías tu experiencia?',
    showReason: true,
    showFollowUp: true
  }}
  // Bug Report
  bugProps={{
    severityOptions: ['critical', 'high', 'medium', 'low'],
    includeStepsToReproduce: true,
    includeEnvironment: true
  }}
/>
```

### Configuración por Tenant

```json
{
  "feedback": {
    "widget": {
      "enabled": true,
      "position": "bottom-right",
      "triggers": [
        { "type": "time_on_page", "value": 300 },
        { "type": "action", "value": "logout" },
        { "type": "manual", "value": true }
      ],
      "types": ["nps", "bug", "feature"]
    },
    "nps": {
      "enabled": true,
      "score_threshold": 9
    }
  }
}
```

 [↑ Volver al inicio](#feedback-collection)

---

## Email Campaigns

### NPS Campaign

```yaml
# Email campaign config
keygo:
  feedback:
    email_campaigns:
      - id: weekly_nps
        name: "Weekly NPS"
        schedule: "0 9 * * 1"  # Monday 9am
        template: nps_survey
        recipients:
          type: active_users
          filter: days_since_login <= 7
        send_if:
          - days_since_login >= 7
          - no_nps_last_30_days
```

### Email Templates

```html
<!-- nps-survey.html -->
<h2>¿Cómo calificarías KeyGo?</h2>

<p>Tu opinión nos ayuda a mejorar.</p>

<div class="nps-scale">
  {% for score in 0..10 %}
    <a href="{{feedback_url}}?score={{score}}">{{score}}</a>
  {% endfor %}
</div>

<p>Promoted: 9-10 | Passive: 7-8 | Detractor: 0-6</p>

<p>
  <small>
    <a href="{{unsubscribe_url}}">No recibir más encuestas</a>
  </small>
</p>
```

### Open/Click Tracking

```sql
-- Track email opens
UPDATE feedback_campaign_recipient
SET opened_at = NOW()
WHERE email = :email AND campaign_id = :campaign_id;
```

 [↑ Volver al inicio](#feedback-collection)

---

## Dashboard Widget

### Feedback Summary Widget

```tsx
<DashboardWidget
  title="User Feedback"
  type="feedback_summary"
  config={{
    period: 'last_30_days',
    show_nps: true,
    show_bugs: true,
    show_features: true
  }}
/>
```

### Widget Content

- NPS score actual
- NPS trend (graph)
- Bugs reportados (count)
- Feature requests top (list)

### Placement

- Admin dashboard
- Tenant admin dashboard
- Platform admin dashboard

 [↑ Volver al inicio](#feedback-collection)

---

## API

### Submit Feedback (External)

```bash
# Para integraciones externas
curl -X POST https://api.keygo.io/api/v1/feedback \
  -H "Content-Type: application/json" \
  -d '{
    "source": "zendesk",
    "type": "nps",
    "tenant_id": "tenant-uuid",
    "score": 8,
    "reason": "Buen servicio"
  }'
```

### Webhook

```yaml
# Configurar webhook para nuevos feedbacks
keygo:
  feedback:
    webhooks:
      - url: https://your-app.com/feedback
        events:
          - feedback.created
          - nps.received
          - bug.reported
```

### Payload

```json
{
  "event": "feedback.created",
  "timestamp": "2024-01-15T10:00:00Z",
  "data": {
    "id": "fb-uuid",
    "type": "nps",
    "tenant_id": "tenant-uuid",
    "user_id": "user-uuid",
    "score": 9
  }
}
```

 [↑ Volver al inicio](#feedback-collection)

---

## Integration

### Zendesk Integration

```yaml
keygo:
  feedback:
    integrations:
      zendesk:
        enabled: true
        auto_create_ticket:
          - type: bug
            priority: severity_mapping
          - type: feature
            priority: low
```

### Slack Integration

```yaml
keygo:
  feedback:
    integrations:
      slack:
        enabled: true
        channels:
          - name: "#keygo-feedback"
            events:
              - bug.reported
              - feature.high_votes
          - name: "#product"
            events:
              - nps.score_change
```

### PagerDuty Integration

```yaml
keygo:
  feedback:
    integrations:
      pagerduty:
        enabled: true
        critical_bugs:
          - severity: critical
            create_incident: true
```

 [↑ Volver al inicio](#feedback-collection)

---

[← Índice](./README.md)