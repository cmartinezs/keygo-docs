[← Diseño y Proceso](../README.md)

---

# Contextos del Dominio

Cada archivo en esta sección describe un bounded context del dominio de Keygo: su propósito, los conceptos que gestiona, sus invariantes y cómo se relaciona con el resto del sistema.

Para entender el mapa de relaciones entre contextos, ver [Mapa de Contextos](../context-map.md). Para el vocabulario completo, ver [Lenguaje Ubicuo](../ubiquitous-language.md).

---

## Contenido

| Contexto | Tipo de subdominio | Descripción |
|----------|--------------------|-------------|
| [Identity](./identity.md) | Core Domain | Quién es una identidad, cómo se autentica y cuál es el estado de sus sesiones. |
| [Access Control](./access-control.md) | Core Domain | Qué puede hacer una identidad autenticada: roles, permisos y membresías. |
| [Organization](./organization.md) | Supporting | Ciclo de vida de organizaciones y de los miembros que las componen. |
| [Client Applications](./client-applications.md) | Supporting | Aplicaciones externas registradas que delegan autenticación a Keygo. |
| [Billing](./billing.md) | Supporting | Relación comercial: planes, suscripciones, límites de uso y facturación. |
| [Audit](./audit.md) | Supporting | Registro inmutable de eventos de seguridad y gobernanza. |
| [Platform](./platform.md) | Supporting | Visibilidad operativa global y soporte del equipo de Keygo. |

---

[← Diseño y Proceso](../README.md)
