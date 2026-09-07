[← Diseño y Proceso](../README.md)

---

# Contextos del Dominio

Cada archivo en esta sección describe bounded contexts que existen o han existido materialmente en el diseño/implementación de KeyGo. Desde `DEC-KEYGO-SCOPE-001` (2026-09-07), esta carpeta distingue **target KeyGo ownership** de **embedded/legacy contexts pending extraction**.

> [!IMPORTANT]
> `Billing` permanece documentado para no perder conocimiento ni ocultar el estado real del código, pero ya **no forma parte del target bounded-context ownership de KeyGo**. Subscription/entitlement target ownership pasa a `INIT-SUB-001 / CAP-SUB-001`; payment execution target ownership pasa a `INIT-PAY-001 / CAP-PAY-001`. Ver [Capability Extraction Boundaries](../capability-extraction-boundaries.md).

Para entender el mapa de relaciones histórico/current, ver [Mapa de Contextos](../context-map.md). Para el vocabulario completo, ver [Lenguaje Ubicuo](../ubiquitous-language.md).

---

## Target KeyGo bounded contexts

| Contexto | Tipo | Target ownership |
|----------|------|------------------|
| [Identity](./identity.md) | Core Domain | **KEEP_KEYGO / CAP-IAM-001** — identidad, autenticación, sesión/token. |
| [Access Control](./access-control.md) | Core Domain | **KEEP_KEYGO / CAP-IAM-001** — roles, permisos, memberships, authorization. |
| [Organization](./organization.md) | Supporting | **KEEP_KEYGO / CAP-IAM-001** únicamente como tenant/membership IAM boundary. |
| [Client Applications](./client-applications.md) | Supporting | **KEEP_KEYGO / CAP-IAM-001** — OAuth/OIDC client/application registration and access context. |
| [Audit](./audit.md) | Supporting | **KEEP_KEYGO / CAP-IAM-001** para security/IAM actor and audit context. |
| [Platform](./platform.md) | Supporting | **KEEP_KEYGO** solo para operación/administración IAM; no debe absorber commercial platform semantics. |

## Embedded context under extraction

| Contexto | Estado | Target ownership |
|----------|--------|------------------|
| [Billing](./billing.md) | **LEGACY_EMBEDDED / EXTRACTION_REQUIRED** | Split: subscription/catalog/entitlements → `CAP-SUB-001`; payment execution → `CAP-PAY-001`; invoices/fiscal/accounting portions remain `BOUNDARY_UNRESOLVED`. |

El archivo `billing.md` sigue siendo una fuente relevante para inventario/migración. No debe eliminarse ni interpretarse como target KeyGo authority después de 2026-09-07.

---

## Reglas de interacción entre capacidades

- KeyGo/CAP-IAM puede aportar `IdentityRef`, `TenantRef`, `ApplicationRef`, `ActorContext` y autorización a las capacidades comerciales.
- CAP-SUB y CAP-PAY no comparten tablas internas con KeyGo.
- CAP-SUB no convierte entitlements comerciales en roles IAM.
- CAP-PAY no convierte payment state en user/account state.
- El consumidor de negocio mantiene su propio Organization/Product/Reservation/etc. y referencia IAM/commercial capabilities mediante contratos.

---

## Referencias de reconciliación

- [Scope Reconciliation — 2026-09-07](../../01-discovery/scope-reconciliation-2026-09-07.md)
- [Capability Extraction Boundaries](../capability-extraction-boundaries.md)

---

[← Diseño y Proceso](../README.md)
