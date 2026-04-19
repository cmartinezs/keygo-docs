[← Índice](../README.md) | [< Anterior](rf16-medicion-uso.md) | [Siguiente >](rf18-registro-eventos.md)

---

# RF17 — Integración con proveedores de pago

**Descripción**
El sistema debe integrarse con proveedores de pago externos para automatizar el cobro de suscripciones, gestionar los estados de pago y reflejar los cambios de suscripción derivados de eventos de facturación.

**Alcance incluye**
- Integración con al menos un proveedor de pago externo para el procesamiento de cobros recurrentes.
- Recepción y procesamiento de notificaciones de pago exitoso, fallido o cancelado.
- Actualización automática del estado de la suscripción de la organización según los eventos de pago recibidos.
- Manejo del período de gracia ante pagos fallidos antes de suspender la organización.

**No incluye (MVP)**
- Esta funcionalidad está explícitamente excluida del MVP. La gestión de suscripciones en el MVP (RF15) se administra manualmente desde el panel de la plataforma.

**Dependencias**
- RF15 (Gestión de suscripciones).
- RF20 (Administración global de la plataforma).
- RF18 (Registro de eventos).

**Criterios de aceptación**
> Esta funcionalidad está fuera del alcance del MVP. Los criterios de aceptación se definirán en la fase correspondiente del roadmap.

**Riesgos y mitigaciones**
> Los riesgos asociados se evaluarán cuando esta funcionalidad sea incorporada al roadmap activo.

---

[← Índice](../README.md) | [< Anterior](rf16-medicion-uso.md) | [Siguiente >](rf18-registro-eventos.md)
