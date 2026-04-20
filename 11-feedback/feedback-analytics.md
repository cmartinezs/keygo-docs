[← Índice](./README.md)

---

# Feedback Analytics

Análisis y métricas de feedback.

## Contenido

- [NPS Analytics](#nps-analytics)
- [Survey Analytics](#survey-analytics)
- [Bug Analytics](#bug-analytics)
- [Feature Request Analytics](#feature-request-analytics)
- [Dashboards](#dashboards)

---

## NPS Analytics

### NPS Score

```
NPS = %Promoters - %Detractors
```

### Métricas

| Métrica | Descripción |
|---------|-------------|
| **NPS Score** | -100 a +100 |
| **Promoters %** | Score 9-10 |
| **Passives %** | Score 7-8 |
| **Detractors %** | Score 0-6 |
| **Response Rate** | % de usuarios que responden |
| **Avg Score** | Media de scores |

### Queries

```sql
-- NPS Score
SELECT
  COUNT(CASE WHEN score >= 9 THEN 1 END) * 100.0 / COUNT(*) as promoters_pct,
  COUNT(CASE WHEN score <= 6 THEN 1 END) * 100.0 / COUNT(*) as detractors_pct
FROM feedback
WHERE type = 'nps'
  AND tenant_id = :tenant_id
  AND created_at >= :from_date
  AND created_at <= :to_date;
```

### Trends

```sql
-- NPS by month
SELECT
  DATE_TRUNC('month', created_at) as month,
  COUNT(CASE WHEN score >= 9 THEN 1 END) * 100.0 / COUNT(*) as promoters,
  COUNT(CASE WHEN score <= 6 THEN 1 END) * 100.0 / COUNT(*) as detractors
FROM feedback
WHERE type = 'nps'
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY month;
```

### Segmentación

| Segmento | Query |
|----------|-------|
| By plan | `GROUP BY tenant_plan` |
| By tenure | `GROUP BY days_since_signup` |
| By feature usage | `GROUP BY feature_used` |
| By region | `GROUP BY user_region` |

 [↑ Volver al inicio](#feedback-analytics)

---

## Survey Analytics

### Métricas

| Métrica | Descripción |
|---------|-------------|
| **Completion Rate** | % que completan la survey |
| **Avg Time** | Tiempo promedio de completion |
| **Drop-off Rate** | Preguntas abandonadas |
| **Answer Distribution** | Distribución de respuestas |

### Pregunta Rating

```sql
SELECT
  question_id,
  answer,
  COUNT(*) as count,
  COUNT(*) * 100.0 / SUM(COUNT(*)) OVER() as pct
FROM survey_responses
WHERE survey_id = :survey_id
  AND question_id = :question_id
GROUP BY question_id, answer;
```

### Pregunta Text

```sql
-- Word frequency
SELECT
  word,
  COUNT(*) as count
FROM survey_responses,
  LATERAL SPLIT_TO_TABLE(answer, ' ')
WHERE survey_id = :survey_id
  AND question_id = :question_id
GROUP BY word
ORDER BY count DESC
LIMIT 20;
```

### Funnel Analysis

```sql
-- Completion funnel
SELECT
  question_id,
  response_count,
  LAG(response_count) OVER (ORDER BY question_order) as prev_count,
  response_count * 100.0 / LAG(response_count) OVER (ORDER BY question_order) as dropoff_pct
FROM (
  SELECT
    question_id,
    question_order,
    COUNT(DISTINCT response_id) as response_count
  FROM survey_responses
  WHERE survey_id = :survey_id
  GROUP BY question_id, question_order
) t
ORDER BY question_order;
```

 [↑ Volver al inicio](#feedback-analytics)

---

## Bug Analytics

### Métricas

| Métrica | Descripción |
|---------|-------------|
| **Bug Count** | Total bugs reportados |
| **By Severity** | Distribución por severity |
| **Time to Fix** | Tiempo promedio de resolución |
| **Reopen Rate** | % bugs reopened |
| **By Component** | Distribución por componente |

### By Severity

```sql
SELECT
  severity,
  COUNT(*) as count,
  COUNT(CASE WHEN status = 'resolved' THEN 1 END) as resolved,
  COUNT(CASE WHEN status = 'resolved' THEN 1 END) * 100.0 / COUNT(*) as resolution_rate
FROM feedback
WHERE type = 'bug'
  AND tenant_id = :tenant_id
GROUP BY severity;
```

### Time to Resolution

```sql
SELECT
  severity,
  AVG(EXTRACT(EPOCH FROM (resolved_at - created_at))) / 3600 as avg_hours
FROM feedback
WHERE type = 'bug'
  AND status = 'resolved'
GROUP BY severity;
```

### By Component

```sql
SELECT
  component,
  COUNT(*) as count
FROM feedback
WHERE type = 'bug'
GROUP BY component
ORDER BY count DESC
LIMIT 10;
```

 [↑ Volver al inicio](#feedback-analytics)

---

## Feature Request Analytics

### Métricas

| Métrica | Descripción |
|---------|-------------|
| **Request Count** | Total requests |
| **Unique Users** | Usuarios únicos |
| **Vote Count** | Votos totales |
| **Duplicates** | Requests duplicados |
| **Approved Rate** | % approved por product |

### Top Features

```sql
SELECT
  title,
  COUNT(DISTINCT user_id) as unique_users,
  COUNT(*) as total_votes,
  MAX(created_at) as latest_request
FROM feedback
WHERE type = 'feature'
GROUP BY title
ORDER BY total_votes DESC
LIMIT 20;
```

### Funnel

```
Feature Request
     │
     ▼
Product Review
     │
     ├──► Approved ──► 15%
     │
     └──► Rejected ──► 85%
              │
              ▼
         Not Planned ──► 70%
              │
              ▼
         Planned ──► 15%
```

 [↑ Volver al inicio](#feedback-analytics)

---

## Dashboards

### NPS Dashboard

```yaml
- title: "NPS Overview"
  panels:
    - NPS Score (gauge)
    - NPS Trend (line)
    - Response Rate (stat)
    - Score Distribution (bar)
    - By Plan (table)

- title: "NPS Details"
  panels:
    - Recent Responses (table)
    - Sentiment Analysis (word cloud)
    - By Segment (heatmap)
```

### Survey Dashboard

```yaml
- title: "Survey Overview"
  panels:
    - Completion Rate (gauge)
    - Response Count (stat)
    - Avg Time to Complete (stat)

- title: "Question Analysis"
  panels:
    - Answer Distribution (bar)
    - Text Responses (table)
    - Drop-off Analysis (funnel)
```

### Bug Dashboard

```yaml
- title: "Bug Overview"
  panels:
    - Bug Count (stat)
    - By Severity (pie)
    - Time to Fix (line)
    - By Component (bar)

- title: "Bug Details"
  panels:
    - Recent Bugs (table)
    - Reopen Rate (gauge)
    - Unresolved Aging (table)
```

### Feature Request Dashboard

```yaml
- title: "Feature Requests"
  panels:
    - Request Count (stat)
    - Top Voted (table)
    - Approval Funnel (funnel)
    - By Status (pie)
```

 [↑ Volver al inicio](#feedback-analytics)

---

[← Índice](./README.md)