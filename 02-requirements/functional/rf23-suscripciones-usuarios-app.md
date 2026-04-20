[← Índice](../README.md) | [< Anterior](rf22-planes-por-aplicacion.md) | [Siguiente >](rf24-evaluacion-derechos-membresia.md)

---

# RF23 — Suscripciones de usuarios a planes de aplicación

**Descripción**
El sistema debe permitir que un usuario contrate un plan de una aplicación cliente, gestionar el ciclo de vida de esa suscripción y mantener el vínculo entre la membresía del usuario y su suscripción activa. Este flujo es análogo al flujo de contratación de un plan de Keygo por un contratante, pero opera dentro del contexto de una aplicación específica y para sus usuarios finales.

Cuando una aplicación tiene planes definidos (RF22), el sistema crea automáticamente una cuenta de billing de app (`AppBillingAccount`) para cada usuario que contrata un plan. Esta cuenta es el ancla de la relación comercial entre el usuario final y la app; es independiente de la entidad `Contractor` que modela la relación comercial entre el tenant y Keygo.

**Alcance incluye**
- Creación de la cuenta de billing de app (`AppBillingAccount`) al iniciarse el primer proceso de contratación del usuario en esa app. Existe como máximo una cuenta por usuario por aplicación.
- Flujo de contratación de plan: selección de versión de plan, selección de cadencia de facturación, registro del contrato y activación de la suscripción.
- Verificación de email de contacto durante el flujo de contratación cuando aplique.
- Vinculación de la membresía activa del usuario (`app_membership`) con su `AppBillingAccount` al activarse la suscripción.
- Consulta del estado de la suscripción activa por parte del usuario y del administrador de organización.
- Suspensión de la suscripción por impago y efecto sobre el acceso del usuario a la app.
- Cancelación voluntaria de la suscripción y gestión del acceso hasta el fin del período contratado.
- Cambio de plan: el usuario puede pasar a un plan distinto; la suscripción anterior queda supersedida.

**No incluye (MVP)**
- Integración directa con proveedores de pago para cobro automatizado al usuario final de la app (la app cliente gestiona el cobro externamente y notifica al sistema).
- Facturación prorrateada al cambiar de plan en medio de un período.
- Reembolsos automáticos.

**Dependencias**
- RF08 (Acceso de usuarios a aplicaciones).
- RF22 (Planes comerciales por aplicación cliente).
- RF24 (Evaluación de derechos de membresía).
- RF16 (Medición de uso).
- RF18 (Registro de eventos).
- RNF02 (Aislamiento entre organizaciones).
- DD-15 (App Billing Account como entidad de billing para usuarios finales de una app).

**Criterios de aceptación**
1. Cuando una aplicación tiene al menos un plan activo, un usuario que inicia el flujo de acceso puede seleccionar y contratar un plan como parte del proceso de incorporación.
2. Al activarse una suscripción, la membresía del usuario queda vinculada a su `AppBillingAccount`; a partir de ese momento, los derechos de su plan son evaluables en cada sesión (RF24).
3. Un usuario con suscripción activa no puede tener simultáneamente otra suscripción activa a la misma app; el cambio de plan produce exactamente una suscripción activa.
4. Cuando la suscripción queda en estado no activo (suspendida, cancelada, expirada), el sistema puede restringir el acceso del usuario a las funcionalidades cubiertas por el plan, conforme a los derechos de la versión activa.
5. El administrador de organización puede consultar el estado de suscripción de cualquier miembro de su organización para cualquier app del tenant.
6. Todos los eventos del ciclo de contratación quedan registrados en el registro de auditoría (RF18).

**Riesgos y mitigaciones**
- Usuario que pierde acceso inesperadamente por vencimiento → el sistema debe notificar al usuario antes del vencimiento de la suscripción y mantener un período de gracia configurable antes de restringir el acceso.
- Membresía sin suscripción en app con planes → el sistema debe impedir que una membresía quede en estado activo sin suscripción activa cuando la app tiene planes obligatorios; las apps con planes opcionales permiten membresías sin suscripción.

---

[← Índice](../README.md) | [< Anterior](rf22-planes-por-aplicacion.md) | [Siguiente >](rf24-evaluacion-derechos-membresia.md)
