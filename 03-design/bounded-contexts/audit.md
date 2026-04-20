[← Índice](./README.md) | [< Anterior](./billing.md) | [Siguiente >](./platform.md)

---

# Audit

## Contenido

- [Propósito](#propósito)
- [Conceptos clave](#conceptos-clave)
- [Invariantes del contexto](#invariantes-del-contexto)
- [Relaciones con otros contextos](#relaciones-con-otros-contextos)
- [Lo que este contexto no hace](#lo-que-este-contexto-no-hace)
- [Comentarios de los Revisores](#comentarios-de-los-revisores)

---

## Propósito

Audit es el repositorio inmutable de todo lo que ocurre en el sistema. Es el único contexto cuya responsabilidad exclusiva es **recordar**: persistir eventos de seguridad y gobernanza de forma que no puedan ser alterados ni eliminados por ningún actor, incluido el equipo de Keygo.

**Responsabilidades de este contexto:**
- Recibir y persistir eventos de seguridad y gobernanza publicados por todos los demás contextos.
- Mantener un registro cronológico, ordenado e inmutable de esos eventos.
- Proveer capacidad de consulta del registro para trazabilidad y cumplimiento.
- Garantizar que el registro de auditoría de cada organización solo sea visible para su Administrador y para el Administrador de Plataforma con trazabilidad explícita.

**Fuera del alcance de este contexto:**
- Reaccionar ante eventos (tomar acciones como consecuencia de lo registrado) → ningún contexto lo delega en Audit.
- Generar sus propios eventos de dominio.
- Modificar o compensar registros previos bajo ninguna circunstancia.

[↑ Volver al inicio](#audit)

---

## Conceptos clave

### Registro de auditoría

Colección inmutable y ordenada cronológicamente de eventos de seguridad. Es la fuente de verdad para reconstruir qué ocurrió, cuándo y quién lo inició. No puede ser modificada ni eliminada por ningún actor del sistema.

### Evento de seguridad

Acción relevante para la seguridad o gobernanza que queda registrada. Proviene siempre de otro contexto del dominio, que lo publica con un contrato formal. El evento incluye:

| Campo | Descripción |
|-------|-------------|
| Tipo de evento | Identificador del evento: qué ocurrió (`SesiónIniciada`, `RolAsignado`, etc.). |
| Marca de tiempo | Cuándo ocurrió, con precisión suficiente para ordenación. |
| Actor del evento | Quién lo originó: una identidad, un administrador, una aplicación cliente o el propio sistema. |
| Alcance (organización) | A qué organización pertenece el evento. Determina quién puede consultarlo. |
| Datos del evento | Información contextual del evento, tal como fue publicada por el contexto origen. |

### Trazabilidad

Capacidad de reconstruir la secuencia de acciones que llevaron a un estado dado, consultando el registro de auditoría. Es la utilidad principal de este contexto para equipos de soporte, auditores y los propios administradores de organización.

### Actor del evento

Quién originó el evento registrado: una identidad autenticada, un administrador, una aplicación cliente o el propio sistema (cuando la acción es automática). El actor siempre queda identificado en el registro.

### Alcance del evento

La organización a la que pertenece el evento. El registro de auditoría de una organización solo es visible para:
- Su Administrador de Organización (solo ve la suya).
- El Administrador de Plataforma (`KEYGO_ADMIN`), con trazabilidad explícita de su acceso.

[↑ Volver al inicio](#audit)

---

## Invariantes del contexto

| # | Invariante |
|---|-----------|
| 1 | El registro de auditoría es inmutable: ningún registro puede ser modificado o eliminado, por ningún actor, bajo ninguna circunstancia operativa. |
| 2 | Audit no reacciona a los eventos que recibe. Solo los persiste. No genera efectos secundarios. |
| 3 | Audit acepta eventos publicados con contratos formales definidos por los contextos origen. No acepta eventos en formatos ad hoc o sin contrato. |
| 4 | El aislamiento entre organizaciones aplica también al registro de auditoría. El Administrador de Organización solo puede consultar el registro de su propia organización. |
| 5 | Todo acceso de un `KEYGO_ADMIN` al registro de auditoría de una organización queda registrado como un evento de seguridad dentro del propio registro de auditoría de esa organización. |
| 6 | Audit no tiene dependencias de escritura hacia ningún otro contexto. Es un receptor puro; el flujo de datos es unidireccional hacia Audit. |
| 7 | El orden de los eventos en el registro es determinado por la marca de tiempo del momento en que el contexto origen publicó el evento, no por el momento de persistencia en Audit. |

[↑ Volver al inicio](#audit)

---

## Relaciones con otros contextos

Audit consume eventos de todos los demás contextos bajo el patrón **Published Language**: cada contexto publica eventos con un contrato formal y estable; Audit se suscribe sin acoplarse a los detalles internos del publicador.

| Contexto origen | Ejemplos de eventos consumidos |
|----------------|-------------------------------|
| **Identity** | `SesiónIniciada`, `SesiónRevocada`, `AtaqueDeReproducciónDetectado`, `ClaveDeFirmaRotada`, `ContraseñaCambiada` |
| **Access Control** | `RolAsignado`, `RolRevocado`, `MembresíaCreada`, `MembresíaRevocada`, `InvitaciónEnviada` |
| **Organization** | `UsuarioDadoDeAlta`, `UsuarioSuspendido`, `OrganizaciónSuspendida`, `ContraseñaRestablecimientoForzado` |
| **Client Applications** | `AplicaciónRegistrada`, `AplicaciónSuspendida`, `CredencialDeAplicaciónRotada` |
| **Billing** | `SuscripciónActivada`, `SuscripciónSuspendida`, `PagoConfirmado`, `PagoRechazado`, `LímiteDeUsuariosAlcanzado` |
| **Platform** | `UsuarioDePlataformaCreado`, `UsuarioDePlataformaSuspendido` |

Ver [Mapa de Contextos](../context-map.md) para el diagrama completo de relaciones.

[↑ Volver al inicio](#audit)

---

## Lo que este contexto no hace

Este contexto es deliberadamente pasivo. A diferencia del resto, Audit no:

- Emite eventos de dominio propios.
- Toma decisiones basadas en lo que registra.
- Notifica a otros contextos.
- Modifica su estado en respuesta a acciones externas más allá de agregar nuevos registros.

Esta pasividad es una garantía de diseño: si Audit tuviera efectos secundarios, dejaría de ser una fuente de verdad neutral.

[↑ Volver al inicio](#audit)

---

## Comentarios de los Revisores

| Revisor | Tipo | Contenido |
|---------|------|-----------|
| — | — | Pendiente de revisión |

[↑ Volver al inicio](#audit)

---

[← Índice](./README.md) | [< Anterior](./billing.md) | [Siguiente >](./platform.md)
