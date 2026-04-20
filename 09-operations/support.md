[← Índice](./README.md)

---

# Support

Sistema de tickets de soporte: flujo, herramientas y procedimientos.

## Contenido

- [Herramientas](#herramientas)
- [Flujo de Tickets](#flujo-de-tickets)
- [Categorías](#categorías)
- [Prioridades](#prioridades)
- [Integración con Incidentes](#integración-con-incidentes)

---

## Herramientas

### Opción A: Herramientas de Mercado

| Herramienta | Costo | Plan Free | Notas |
|------------|-------|----------|-------|
| **Zendesk** | $5+/user | Starter (limitado) | Enterprise-grade |
| **Freshdesk** | $0-79/user | Free (limitado) | Easy setup |
| **Intercom** | $74+/user | No free | In-app chat |
| **HelpScout** | $20+/user | No free | Multi-brand |
| **Trello** | $0 | Free | Simple, configurable |

### Opción B: Desarrollo Interno

> **Nota:** Si se desarrolla internamente, se alinea con el modelo de datos existente.

**Entidades a crear:**

```sql
-- Soporte ticket
CREATE TABLE support_ticket (
    id UUID PRIMARY KEY,
    tenant_id UUID NOT NULL REFERENCES tenant(id),
    user_id UUID REFERENCES user(id),
    category ticket_category,
    priority ticket_priority,
    status ticket_status,
    subject VARCHAR(255),
    description TEXT,
    assigned_to UUID REFERENCES user(id),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    resolved_at TIMESTAMP
);

-- Comentarios internos
CREATE TABLE ticket_comment (
    id UUID PRIMARY KEY,
    ticket_id UUID REFERENCES support_ticket(id),
    user_id UUID REFERENCES user(id),
    is_internal BOOLEAN DEFAULT FALSE,
    comment TEXT,
    created_at TIMESTAMP
);

-- Adjuntos
CREATE TABLE ticket_attachment (
    id UUID PRIMARY KEY,
    ticket_id UUID REFERENCES support_ticket(id),
    filename VARCHAR(255),
    mime_type VARCHAR(100),
    file_path VARCHAR(500)
);
```

**APIs:**

```
POST   /api/v1/tenants/{slug}/support/tickets     # Crear ticket
GET    /api/v1/tenants/{slug}/support/tickets  # Listar tickets
GET    /api/v1/tenants/{slug}/support/tickets/{id}  # Ver ticket
POST   /api/v1/tenants/{slug}/support/tickets/{id}/comments  # Agregar comentario
PATCH  /api/v1/tenants/{slug}/support/tickets/{id}  # Actualizar ticket
```

**Referencia modelo:** `04-data-model/` para entidades relacionadas.

↑ Volver al inicio](#support)

---

## Flujo de Tickets

### Flujo Completo

```
User reporta issue
       │
       ▼
Ticket creado (status: OPEN)
       │
       ▼
Auto-categorización (by keywords)
       │
       ▼
Asignación automática (by category)
       │
       ▼
Soporte responde (status: IN_PROGRESS)
       │
       ▼
Solución proporcionada
       │
       ├──► User confirma ──► (status: RESOLVED)
       │
       └──► User no responde (7 days) ──► (status: CLOSED)
```

### Estados

| Estado | Descripción |
|--------|------------|
| **OPEN** | Nuevo, sin asignar |
| **IN_PROGRESS** | Asignado, en atención |
| **WAITING_FOR_USER** | Esperando respuesta del usuario |
| **RESOLVED** | Solución dada, pendiente confirmación |
| **CLOSED** | Completado |
| **ON_HOLD** | Bloqueado por otra dependencia |

### SLA por Estado

- **OPEN → IN_PROGRESS:** 4 horas (Free), 1 hora (Pro), 15 min (Enterprise)
- **IN_PROGRESS → RESOLVED:** Según categoría

↑ Volver al inicio](#support)

---

## Categorías

| Categoría | Descripción | Asigna a |
|-----------|------------|----------|
| **BILLING** | Pagos, facturas, planes | Finance team |
| **TECHNICAL** | Bugs, errors, performance | Engineering |
| **ACCOUNT** | Login, roles, accesos | Support team |
| **INTEGRATION** | APIs, webhooks | DevOps |
| **FEATURE_REQUEST** | Nuevas features | Product |
| **DATA** | Export, importación | Data team |
| **SECURITY** | Vulnerabilidades, accesos | Security team |

**Auto-clasificación por keywords:**

- "factura", "pago", "cobro" → BILLING
- "error", "no funciona", "404" → TECHNICAL
- "login", "password", "no puedo entrar" → ACCOUNT
- "api", "webhook", "integración" → INTEGRATION

↑ Volver al inicio](#support)

---

## Prioridades

| Prioridad | SLA Inicial | Descripción | Ejemplo |
|----------|-----------|------------|---------|
| **URGENT** | 15 min | Sistema down completo | API no responde |
| **HIGH** | 4 horas | Funcionalidad crítica | Login no funciona |
| **MEDIUM** | 24 horas | Problema menor | Bug cosmético |
| **LOW** | 72 horas | Pregunta, consulta | Cómo usar X |

**Auto-priorización por keywords:**

- "sistema down", "urgente" → URGENT
- "no puedo trabajar", "crítico" → HIGH
- "possible bug", "inconveniente" → MEDIUM
- "pregunta", "cómo" → LOW

↑ Volver al inicio](#support)

---

## Integración con Incidentes

El sistema de soporte se integra con el manejo de incidentes:

```
Support Ticket (SEV1/2)
       │
       ▼
Auto-crear Incident
       │
       ▼
Escalar según incident response
       (ver incident-response.md)
```

### Mapeo Ticket → Incident

| Ticket Priority | Incident SEV |
|---------------|-------------|
| URGENT | SEV1 |
| HIGH | SEV2 |
| MEDIUM | SEV3 |
| LOW | SEV4 |

### Notificaciones

```yaml
# Slack cuando ticket URGENT
- channel: #keygo-support
- mention: @oncall
- template: "🚨 Ticket URGENT: {subject} - Asignado a {assigned_to}"

# Email cuando ticket asignado
- to: {assigned_to}
- template: "Nuevo ticket asignado: {subject}"
```

↑ Volver al inicio](#support)

---

## Canales de Entrada

| Canal | Configuración |
|-------|-------------|
| **Portal** | `/api/v1/tenants/{slug}/support/tickets` |
| **Email** | support@{tenant}.keygo.io |
| **Chat** | Widget en UI |
| **Phone** | Solo Enterprise |

### Portal de Usuario

```
GET /support
  - Ver mis tickets
  - Crear nuevo ticket
  - Ver status
  - Agregar comentarios

GET /support/{id}
  - Details
  - Comments (internos ocultos)
  - Attachments
```

### Portal de Soporte (Admin)

```
GET /admin/support
  - Todos los tickets
  - Filtros (status, category, priority)
  - Asignar
  - Resolver
```

↑ Volver al inicio](#support)

---

[← Índice](./README.md)