[← Índice](./README.md)

---

# Feedback Types

Tipos de feedback que el sistema puede recopilar.

## Contenido

- [Tipos de Feedback](#tipos-de-feedback)
- [NPS](#nps)
- [Survey](#survey)
- [Bug Report](#bug-report)
- [Feature Request](#feature-request)

---

## Tipos de Feedback

| Tipo | Código | Descripción |时机 |
|------|--------|-------------|------|
| **NPS** | `nps` | Net Promoter Score | Post-login, email campaign |
| **Survey** | `survey` | Encuesta estructurada | Triggers configurados |
| **Bug Report** | `bug` | Reporte de bug | Botón en UI |
| **Feature Request** | `feature` | Solicitud de feature | Botón en UI |
| **General Feedback** | `general` | Feedback libre | Formulario |

 [↑ Volver al inicio](#feedback-types)

---

## NPS

### Estructura

```json
{
  "type": "nps",
  "score": 9,
  "reason": "Fácil de usar",
  "follow_up": "Vendría bien integración con Slack"
}
```

### Score Scale

| Score | Categoría |
|-------|----------|
| 0-6 | Detractor |
| 7-8 | Passive |
| 9-10 | Promoter |

### Triggers

- **Post-login:** Después del login (configurable)
- **Email campaign:** Envío periódico (semanal/mensual)
- **In-app:** Botón flotante

### Configuración

```yaml
keygo:
  feedback:
    nps:
      enabled: true
      triggers:
        - post_login: true
          frequency: always  # once, always, daily
        - email_campaign: true
          schedule: "0 9 * * 1"  # Monday 9am
      score_thresholds:
        detractor: 6
        promoter: 9
```

### Respuestas típicas

**Detractor (0-6):**
- "¿Qué podría mejorar?"
- "¿Qué experiencia tuvimos?"

**Passive (7-8):**
- "¿Qué falta para dar 9-10?"

**Promoter (9-10):**
- "¿Qué te gusta más?"

 [↑ Volver al inicio](#feedback-types)

---

## Survey

### Estructura

```json
{
  "type": "survey",
  "survey_id": "post-onboarding-2024",
  "answers": [
    {
      "question_id": "q1",
      "answer": "Muy clara"
    },
    {
      "question_id": "q2",
      "answer": 4
    }
  ],
  "comments": "Todo bien!"
}
```

### Question Types

| Tipo | Descripción |
|------|-------------|
| `rating` | Escala 1-5 o 1-10 |
| `choice` | Opción única |
| `multiple` | Multi-opción |
| `text` | Texto libre |
| `nps` | NPS embebido |

### Templates

```json
// post-onboarding-survey.json
{
  "id": "post-onboarding-2024",
  "name": "Post Onboarding",
  "trigger": "user_days_since_onboarding > 7",
  "questions": [
    {
      "id": "q1",
      "type": "rating",
      "question": "¿Cómo fue el proceso de onboarding?",
      "scale": 5
    },
    {
      "id": "q2",
      "type": "text",
      "question": "¿Qué podría mejorar?"
    },
    {
      "id": "q3",
      "type": "nps",
      "question": "¿Recomendarías KeyGo?"
    }
  ]
}
```

### Trigger Conditions

| Condition | Descripción |
|-----------|-------------|
| `days_since_onboarding > N` | Después de N días |
| `days_since_last_login > N` | Inactivo por N días |
| `feature_used.feature = X` | Usó feature X |
| `plan_changed` | Cambió de plan |
| `manual` | Trigger manual |

 [↑ Volver al inicio](#feedback-types)

---

## Bug Report

### Estructura

```json
{
  "type": "bug",
  "title": "No puedo actualizar mi perfil",
  "description": "Cuando intento guardar...",
  "severity": "high",
  "steps_to_reproduce": [
    "1. Ir a Settings",
    "2. Click en Profile",
    "3. Editar cualquier campo",
    "4. Click Save"
  ],
  "expected": "Debería guardar los cambios",
  "actual": "Error 500",
  "environment": {
    "browser": "Chrome 120",
    "os": "Windows 11",
    "app_version": "1.2.3"
  }
}
```

### Severity Levels

| Level | Descripción |
|-------|-------------|
| `critical` | Bloquea completamente |
| `high` | Afecta funcionalidad principal |
| `medium` | Afecta parcialmente |
| `low` | Minor, cosmético |

### Auto-triage

```yaml
# Palabras clave → severity
critical:
  - "no puedo trabajar"
  - "sistema caido"
  - "error 500"

high:
  - "no funciona"
  - "no puedo"

medium:
  - "lento"
  - "raro"

low:
  - "mejorable"
  - "sugerencia"
```

 [↑ Volver al inicio](#feedback-types)

---

## Feature Request

### Estructura

```json
{
  "type": "feature",
  "title": "Agregar autenticación con Google",
  "description": "Me gustaría poder iniciar sesión con mi cuenta de Google",
  "use_case": "Ya tengo muchas contraseñas, sería más fácil",
  "priority": "high",
  "votes": 15,
  "duplicates": 3
}
```

### Duplication

- Mismo título → mismo request
- Auto-merge de duplicate requests
- Votación agregada

### Workflow

```
Feature Request
    │
    ▼
Auto-check duplicates
    │
    ├──► Existe ──► +1 vote
    │
    └──► Nueva ──► Create ticket
              │
              ▼
         Product review
              │
              ├──► Approved ──► Backlog
              │
              └──► Rejected ──► Close + reason
```

 [↑ Volver al inicio](#feedback-types)

---

[← Índice](./README.md)