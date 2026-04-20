[← Índice](../README.md) | [< Anterior](rf21-operacion-plataforma.md) | [Siguiente >](rf23-suscripciones-usuarios-app.md)

---

# RF22 — Planes comerciales por aplicación cliente

**Descripción**
El sistema debe permitir que el administrador de organización defina un catálogo de planes comerciales propios para cada aplicación cliente que administra. Los usuarios que accedan a esa aplicación pueden ser requeridos a contratar uno de esos planes como condición para el acceso.

Una aplicación puede tener cero o más planes. Si no tiene ninguno, el flujo de acceso funciona exactamente como está descrito en RF08. Si tiene al menos uno, el sistema habilita el flujo de suscripción de usuario (RF23).

**Alcance incluye**
- Creación, activación y desactivación de planes dentro de una aplicación cliente.
- Definición de versiones de plan: cada cambio en precios o límites produce una nueva versión, preservando las condiciones de los contratos existentes.
- Configuración de opciones de facturación por versión: mensual, anual o pago único.
- Definición de derechos por versión: límites cuantitativos (quotas), habilitaciones booleanas y límites de tasa por métrica configurable.
- Consulta del catálogo de planes de una aplicación por parte del administrador de organización y por parte de los usuarios que acceden a esa app.
- Desactivación de una versión de plan sin afectar las suscripciones activas que la referencian.

**No incluye (MVP)**
- Migración automática de usuarios de una versión de plan a otra.
- Descuentos por volumen o códigos promocionales.
- Períodos de prueba diferenciados por usuario (el período de prueba aplica a nivel de versión de plan).

**Dependencias**
- RF06 (Registro de aplicaciones cliente).
- RF07 (Configuración de aplicaciones cliente).
- RF23 (Suscripciones de usuarios de app).
- RF18 (Registro de eventos).
- RNF02 (Aislamiento entre organizaciones).

**Criterios de aceptación**
1. El administrador de organización puede crear planes para cualquier aplicación cliente de su organización.
2. Cada plan puede tener múltiples versiones; las versiones activas son las disponibles para nuevas contrataciones.
3. Las suscripciones existentes no se ven afectadas cuando se desactiva o depreca una versión de plan.
4. El catálogo de planes de una app solo es visible para usuarios con acceso o posibilidad de acceso a esa app; nunca es visible para usuarios de otras organizaciones.
5. Los derechos de un plan (límites, habilitaciones) son consultables por el sistema en tiempo de evaluación de acceso.
6. Todas las modificaciones al catálogo de planes quedan registradas en el registro de auditoría (RF18).

**Riesgos y mitigaciones**
- Modificación de plan activo que afecta suscripciones en curso → las versiones son inmutables una vez creadas; los cambios producen siempre una nueva versión, nunca modifican una existente.
- Catálogo visible entre organizaciones → el aislamiento de RNF02 garantiza que los planes de una app solo son accesibles dentro del tenant propietario.

---

[← Índice](../README.md) | [< Anterior](rf21-operacion-plataforma.md) | [Siguiente >](rf23-suscripciones-usuarios-app.md)
