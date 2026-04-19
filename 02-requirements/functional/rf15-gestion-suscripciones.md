[← Índice](../README.md) | [< Anterior](rf14-gestion-sesiones.md) | [Siguiente >](rf16-medicion-uso.md)

---

# RF15 — Gestión de suscripciones

**Descripción**
El sistema debe permitir asociar a cada organización un plan de suscripción que determine las capacidades y límites disponibles, y gestionar el estado de dicha suscripción a lo largo del tiempo.

**Alcance incluye**
- Asociación de un plan de suscripción a cada organización en el momento de su creación o posterior.
- Gestión del estado de la suscripción: activa, en período de gracia, suspendida por impago, cancelada.
- Cambio de plan de una organización por parte del administrador de la plataforma.
- Definición de los límites incluidos en cada plan: número máximo de usuarios, aplicaciones cliente, y otros parámetros operativos.
- Consulta del estado y los límites de la suscripción vigente por parte del administrador de organización.
- Suspensión automática del acceso de una organización cuando su suscripción expira o queda impaga.

**No incluye (MVP)**
- Autoservicio de cambio de plan por parte del administrador de organización.
- Integración con proveedores de pago para cobro automatizado (RF17).
- Facturación detallada por uso o por ítem.

**Dependencias**
- RF01 (Gestión de organizaciones).
- RF16 (Medición de uso).
- RF20 (Administración global de la plataforma).
- RF18 (Registro de eventos).

**Criterios de aceptación**
1. Cada organización tiene siempre un plan de suscripción asociado.
2. Los límites del plan se aplican operativamente: al alcanzar el límite de usuarios o aplicaciones, no se pueden crear más hasta cambiar de plan.
3. El administrador de la plataforma puede cambiar el plan de una organización en cualquier momento.
4. Cuando la suscripción queda en estado no activo, la organización y sus usuarios pierden acceso de forma equivalente a una suspensión.
5. El administrador de organización puede consultar los límites de su plan y el nivel de uso actual.
6. Los cambios de plan y estado de suscripción quedan registrados en el registro de auditoría (RF18).

**Riesgos y mitigaciones**
- Organización que supera límites sin aviso → el sistema debe notificar al administrador cuando el uso se aproxima a los límites del plan.
- Suspensión inesperada por expiración → período de gracia configurable antes de la suspensión efectiva por impago.

---

[← Índice](../README.md) | [< Anterior](rf14-gestion-sesiones.md) | [Siguiente >](rf16-medicion-uso.md)
