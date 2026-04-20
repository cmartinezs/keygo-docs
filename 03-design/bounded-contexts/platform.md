[← Índice](./README.md) | [< Anterior](./audit.md)

---

# Platform

## Contenido

- [Propósito](#propósito)
- [Conceptos clave](#conceptos-clave)
- [Invariantes del contexto](#invariantes-del-contexto)
- [Relaciones con otros contextos](#relaciones-con-otros-contextos)
- [Eventos que produce](#eventos-que-produce)
- [Comentarios de los Revisores](#comentarios-de-los-revisores)

---

## Propósito

Platform es el contexto desde el cual el equipo operativo de Keygo gestiona el propio producto: observa el estado global del sistema, atiende incidentes, y ejecuta operaciones de soporte sobre organizaciones. Es el único lugar donde existe una perspectiva transversal a todas las organizaciones.

**Responsabilidades de este contexto:**
- Proveer una vista global sobre el estado del sistema: organizaciones activas, uso agregado, alertas operativas.
- Gestionar el ciclo de vida de las identidades con rol de plataforma `KEYGO_ADMIN`.
- Ejecutar operaciones de soporte sobre organizaciones: suspender, reactivar, escalar problemas.
- Garantizar que toda acción de un `KEYGO_ADMIN` quede registrada, incluyendo el acceso a datos de organizaciones.

**Fuera del alcance de este contexto:**
- Gestionar directamente usuarios, roles o aplicaciones de una organización → se hace a través de Organization, que es el punto de escritura autorizado.
- Autenticar identidades → Identity.
- Acceder a datos de negocio de los tenants (documentos, transacciones, datos propios de la app cliente).

[↑ Volver al inicio](#platform)

---

## Conceptos clave

### Jerarquía de roles de plataforma

Los roles de plataforma forman una jerarquía de inclusión: `KEYGO_ADMIN` ⊇ `KEYGO_ACCOUNT_ADMIN` ⊇ `KEYGO_USER`. Una identidad con un rol superior incluye todas las capacidades de los roles inferiores. La interfaz de Keygo expone un selector de rol activo que permite a la identidad elegir con qué contexto está operando en cada momento.

### KEYGO_USER

Rol base. Toda identidad en Keygo lo tiene. Capacidades: autogestión de cuenta (contraseña, sesiones activas, preferencias, conexiones externas) y acceso a las aplicaciones de una organización a través de sus membresías.

### KEYGO_ACCOUNT_ADMIN

Incluye todo lo de `KEYGO_USER`, más la capacidad de administrar una organización (usuarios, aplicaciones, roles, suscripción). Se origina en el flujo de contratación (billing). Desde la perspectiva de Platform, es el punto de contacto responsable de la organización. Platform no gestiona sus acciones dentro de la organización — esas pertenecen al contexto Organization.

### KEYGO_ADMIN

Incluye todo lo de `KEYGO_ACCOUNT_ADMIN`, más acceso transversal a todas las organizaciones para operación y soporte. Sus acciones siempre quedan registradas. Un `KEYGO_ADMIN` **no puede** acceder a los datos de negocio internos de los tenants (contenido de aplicaciones, transacciones propias de la app cliente).

### Vista global

Perspectiva del `KEYGO_ADMIN` sobre el estado del sistema: organizaciones activas, uso agregado por organización, alertas operativas (suscripciones en riesgo, organizaciones suspendidas, anomalías). Es una vista de lectura construida a partir de los estados publicados por los demás contextos; Platform no mantiene su propia copia de la verdad.

### Operación de soporte

Acción realizada por un `KEYGO_ADMIN` en respuesta a un incidente o solicitud legítima: suspender una organización, reactivarla, escalar un problema al equipo de ingeniería. Toda operación de soporte queda registrada en Audit de la organización afectada, incluyendo la identidad del `KEYGO_ADMIN` que la ejecutó y el motivo.

[↑ Volver al inicio](#platform)

---

## Invariantes del contexto

| # | Invariante |
|---|-----------|
| 1 | Platform nunca escribe directamente en los contextos que observa. Para ejecutar una acción sobre una organización (suspender, reactivar), lo hace a través de Organization, que es el único punto de escritura autorizado. |
| 2 | Toda acción de un `KEYGO_ADMIN` sobre una organización queda registrada en Audit con identificación explícita del actor y el motivo. No existe acción de soporte sin trazabilidad. |
| 3 | El acceso de un `KEYGO_ADMIN` al registro de auditoría de una organización queda registrado como un evento dentro de ese mismo registro. |
| 4 | Un `KEYGO_ADMIN` no puede acceder a los datos de negocio de los tenants. Su acceso está limitado a la información operativa del sistema. |
| 5 | Platform acepta los modelos de los demás contextos tal como son (patrón Conformist). No negocia contratos con otros contextos ni construye un modelo de dominio propio que necesite protección. |
| 6 | Las identidades con rol `KEYGO_ADMIN` son gestionadas exclusivamente dentro de este contexto. No pueden ser creadas, suspendidas ni eliminadas desde ningún otro contexto. |

[↑ Volver al inicio](#platform)

---

## Relaciones con otros contextos

Platform adopta el patrón **Conformist** con todos los contextos que lee: acepta sus modelos tal como son, sin capa de traducción, porque no tiene un modelo de dominio propio que proteger.

| Contexto relacionado | Patrón | Naturaleza de la relación |
|---------------------|--------|--------------------------|
| **Organization** | Conformist (Platform lee) + escribe a través de Organization | Platform inicia suspensiones y reactivaciones de organizaciones solicitándolas a Organization. Organization aplica el cambio y publica el evento. |
| **Identity** | Conformist (Platform lee) | Platform observa el estado de las identidades para visibilidad operativa. No modifica identidades directamente. |
| **Billing** | Conformist (Platform lee) | Platform observa el estado de suscripciones para detectar organizaciones en riesgo o suspendidas. No modifica suscripciones directamente. |
| **Audit** | Conformist (Platform lee) | Platform puede consultar el registro de auditoría de cualquier organización. Todo acceso queda registrado. |

Ver [Mapa de Contextos](../context-map.md) para el diagrama completo de relaciones.

[↑ Volver al inicio](#platform)

---

## Eventos que produce

| Evento | Descripción | Prioridad de auditoría |
|--------|-------------|----------------------|
| `UsuarioDePlataformaCreado` | Se creó una nueva identidad con rol `KEYGO_ADMIN`. | Crítica |
| `UsuarioDePlataformaSuspendido` | Una identidad `KEYGO_ADMIN` fue inhabilitada. | Crítica |
| `UsuarioDePlataformaReactivado` | Una identidad `KEYGO_ADMIN` suspendida fue habilitada nuevamente. | Crítica |
| `AccesoDeAdminARegistroDeAuditoría` | Un `KEYGO_ADMIN` consultó el registro de auditoría de una organización. | Crítica |
| `OperaciónDeSoporteEjecutada` | Un `KEYGO_ADMIN` ejecutó una operación de soporte sobre una organización (suspensión, reactivación, escalación). | Crítica |

[↑ Volver al inicio](#platform)

---

## Comentarios de los Revisores

| Revisor | Tipo | Contenido |
|---------|------|-----------|
| — | — | Pendiente de revisión |

[↑ Volver al inicio](#platform)

---

[← Índice](./README.md) | [< Anterior](./audit.md)
