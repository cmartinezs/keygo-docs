[← Índice](../README.md) | [< Anterior](rf22-planes-por-aplicacion.md) | [Siguiente >](rf24-evaluacion-derechos-membresia.md)

---

# RF23 — Suscripciones de usuarios a planes de aplicación

**Descripción**
El sistema debe permitir que un usuario contrate un plan de una aplicación cliente, gestionar el ciclo de vida de esa suscripción y mantener el vínculo entre la membresía del usuario y su suscripción activa. Este flujo opera dentro del contexto de una aplicación específica y para sus usuarios finales.

Cuando una aplicación tiene planes definidos (RF22), el sistema registra automáticamente la suscripción del usuario al plan seleccionado. Esta relación es el ancla de la relación comercial entre el usuario final y la app.

**Alcance incluye**
- Registro de la suscripción del usuario al seleccionar un plan. Existe como máximo una suscripción activa por usuario por aplicación.
- Flujo de contratación de plan: selección de versión de plan, selección de cadencia de facturación, registro del contrato y activación de la suscripción.
- Verificación de email de contacto durante el flujo de contratación cuando aplique.
- Activación de la suscripción y su efecto sobre los derechos y acceso del usuario a la app.
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

**Criterios de aceptación**
1. Cuando una aplicación tiene al menos un plan activo, un usuario que inicia el flujo de acceso puede seleccionar y contratar un plan como parte del proceso de incorporación.
2. Al activarse una suscripción, el sistema activa los derechos del plan para el usuario; a partir de ese momento, los derechos son evaluables en cada sesión (RF24).
3. Un usuario con suscripción activa no puede tener simultáneamente otra suscripción activa a la misma app; el cambio de plan produce exactamente una suscripción activa.
4. Cuando la suscripción queda en estado no activo (suspendida, cancelada, expirada), el sistema puede restringir el acceso del usuario a las funcionalidades cubiertas por el plan.
5. El administrador de organización puede consultar el estado de suscripción de cualquier miembro de su organización para cualquier app del tenant.
6. Todos los eventos del ciclo de contratación quedan registrados en el registro de auditoría (RF18).

**Riesgos y mitigaciones**
- Usuario que pierde acceso inesperadamente por vencimiento → el sistema debe notificar al usuario antes del vencimiento de la suscripción y mantener un período de gracia configurable antes de restringir el acceso.
- Membresía sin suscripción en app con planes → el sistema debe impedir que una membresía quede en estado activo sin suscripción activa cuando la app tiene planes obligatorios; las apps con planes opcionales permiten membresías sin suscripción.

---

[← Índice](../README.md) | [< Anterior](rf22-planes-por-aplicacion.md) | [Siguiente >](rf24-evaluacion-derechos-membresia.md)
