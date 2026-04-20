[← Índice](./README.md) | [< Anterior](./strategic-design.md) | [Siguiente >](./context-map.md)

---

# Lenguaje Ubicuo

El lenguaje ubicuo es el vocabulario compartido entre el dominio de negocio y el diseño del sistema. No es un glosario técnico ni un diccionario de base de datos — es el lenguaje que usan tanto quienes conocen el negocio como quienes diseñan y construyen el sistema. Cuando este lenguaje cambia, el modelo cambia. Cuando el modelo revela un nombre incómodo, el lenguaje se refina.

Este documento extiende el [glosario de requirements](../02-requirements/glossary.md) añadiendo la dimensión de contexto: un mismo término puede tener significados distintos en distintos bounded contexts, y esa distinción es parte del modelo, no un error.

## Contenido

- [Cómo leer este documento](#cómo-leer-este-documento)
- [Términos transversales](#términos-transversales)
- [Identity Context](#identity-context)
- [Access Control Context](#access-control-context)
- [Organization Context](#organization-context)
- [Client Applications Context](#client-applications-context)
- [Billing Context](#billing-context)
- [Audit Context](#audit-context)
- [Platform Context](#platform-context)
- [Ambigüedades resueltas](#ambigüedades-resueltas)
- [Verbos del dominio](#verbos-del-dominio)
- [Comentarios de los Revisores](#comentarios-de-los-revisores)

---

## Cómo leer este documento

Cada término incluye:
- **Definición**: qué significa en este contexto
- **Contexto**: en qué bounded context aplica (si aplica en varios, se indica)
- **No confundir con**: aclaraciones sobre términos similares o el mismo término en otro contexto

Los términos marcados con ⚠️ son **términos de riesgo**: palabras que se usan coloquialmente de forma ambigua y que en este sistema tienen un significado preciso y único.

[↑ Volver al inicio](#lenguaje-ubicuo)

---

## Términos transversales

Aplican en todos los contextos como restricciones de diseño, no como conceptos de un contexto específico.

| Término | Definición |
|---------|------------|
| **Organización** | Unidad aislada de operación dentro de Keygo. Todo dato, usuario, rol y sesión pertenece a exactamente una organización. El aislamiento entre organizaciones es una restricción de diseño absoluta. |
| **Aislamiento** | Propiedad por la cual ningún dato de una organización es accesible desde otra, bajo ninguna circunstancia y por ningún actor del sistema — salvo el Administrador de Plataforma con trazabilidad explícita. |
| **Identificador único** | Valor asignado en el momento de creación de una entidad que la identifica de forma inequívoca durante toda su existencia. No cambia. No se reutiliza. |
| **Actor** | Cualquier entidad que inicia una acción en el sistema: Usuario Final, Administrador de Organización, Administrador de Plataforma, Aplicación Cliente o el propio sistema. |
| **Ciclo de vida** | Secuencia de estados por los que puede pasar una entidad del dominio, con las transiciones válidas entre ellos. |

[↑ Volver al inicio](#lenguaje-ubicuo)

---

## Identity Context

El contexto de Identidad es el núcleo del sistema. Gestiona quién es una identidad, cómo se verifica, y cuál es el estado activo de su autenticación.

| Término | Definición |
|---------|------------|
| **Identidad** | La representación de una persona dentro de Keygo. Toda identidad existe a nivel de plataforma — puede autenticarse, autogestionar su cuenta (perfil, contraseña, sesiones activas) y tiene exactamente un rol de plataforma que determina para qué existe en el sistema. No confundir con *Miembro* (la pertenencia de una identidad a una organización) ni con *Sujeto* (la identidad desde la perspectiva del control de acceso). |
| **Autenticación** | Proceso de verificar que una identidad es quien afirma ser, mediante la validación de sus credenciales. Produce una sesión activa si es exitosa. |
| **Credencial** ⚠️ | Secreto que una identidad presenta para autenticarse. En el contexto de usuarios, es la contraseña. No confundir con *Credencial de Sesión*. |
| **Credencial de Sesión** ⚠️ | Artefacto emitido por Keygo tras una autenticación exitosa. Acredita que la identidad ha sido verificada. Tiene período de validez y puede ser verificado por aplicaciones cliente sin consultar a Keygo. |
| **Credencial de Renovación** | Artefacto de larga duración que permite obtener una nueva Credencial de Sesión sin que la identidad deba autenticarse nuevamente. Se invalida al usarse o al revocarla explícitamente. |
| **Sesión** | Estado activo asociado a una autenticación exitosa. Tiene un ciclo de vida: creación → uso → renovación → cierre o expiración. Una identidad puede tener varias sesiones activas simultáneamente. |
| **Revocación** ⚠️ | Acción de invalidar una sesión o credencial antes de su expiración natural. Puede ser iniciada por la propia identidad, por el Administrador de Organización o por el sistema. |
| **Expiración** | Fin natural del período de validez de una sesión o credencial, sin acción explícita de ningún actor. |
| **Rotación de claves** | Proceso por el cual las claves criptográficas usadas para firmar Credenciales de Sesión son reemplazadas. Las credenciales emitidas con claves anteriores siguen siendo verificables durante el período de transición. |
| **Verificación pública** | Mecanismo que permite a una aplicación cliente comprobar la autenticidad de una Credencial de Sesión usando información expuesta públicamente por Keygo, sin necesidad de consultar un endpoint privado. |
| **Política de autenticación** | Conjunto de reglas que rigen cómo deben autenticarse las identidades de una organización: requisitos de contraseña, duración de sesión, número máximo de sesiones activas. |
| **Conexión externa** ⚠️ | Vínculo entre una identidad de Keygo y una cuenta en un proveedor de identidad externo (social o federado). Permite a la identidad autenticarse usando ese proveedor. Una identidad puede tener varias conexiones externas activas simultáneamente. No confundir con *Credencial de Aplicación* (que identifica a una aplicación, no a un usuario). |
| **Preferencias de notificación** | Configuración personal de una identidad que determina qué comunicaciones del sistema desea recibir y por qué canal. No afecta la lógica de autenticación ni de acceso. |

[↑ Volver al inicio](#lenguaje-ubicuo)

---

## Access Control Context

El contexto de Control de Acceso gestiona qué puede hacer una identidad una vez autenticada. Opera sobre el concepto de roles y permisos dentro del contexto específico de cada aplicación.

| Término | Definición |
|---------|------------|
| **Sujeto** | Una identidad autenticada desde la perspectiva del control de acceso: alguien sobre quien se evalúan permisos. |
| **Rol** | Agrupación con nombre de permisos, asignada a un sujeto dentro de un contexto específico. Existen tres tipos según el contexto: **Rol de aplicación** (dentro de una aplicación cliente, definido por la organización), **Rol de organización** (sobre la organización en su conjunto, para administración), **Rol de plataforma** (para operadores del equipo de Keygo con acceso transversal). Un sujeto puede tener roles distintos en distintas aplicaciones de la misma organización. |
| **Permiso** | Autorización granular que determina si un sujeto puede ejecutar una operación específica. Los permisos se agrupan en roles. |
| **Membresía** | Relación entre un sujeto y una aplicación cliente dentro de la misma organización. Define que ese sujeto tiene acceso a esa aplicación, y bajo qué roles. Sin membresía, no hay acceso. |
| **Evaluación de acceso** | Proceso de determinar si un sujeto puede ejecutar una operación, consultando sus roles y permisos activos en el contexto de la aplicación correspondiente. |
| **Ámbito de acceso** ⚠️ | Conjunto de operaciones o recursos sobre los cuales un sujeto o aplicación cliente está autorizado a actuar. Define el alcance de lo que está permitido, no la identidad de quien lo hace. |
| **Asignación de rol** | Acción de vincular un rol a un sujeto dentro de una aplicación cliente. Solo el Administrador de Organización puede realizarla. |
| **Revocación de acceso** ⚠️ | En este contexto: eliminación de la membresía de un sujeto a una aplicación, o remoción de un rol. Distinto de *Revocación* en Identity (que invalida una sesión). |

[↑ Volver al inicio](#lenguaje-ubicuo)

---

## Organization Context

El contexto de Organización gestiona el ciclo de vida de los tenants y de los usuarios como miembros de una organización.

| Término | Definición |
|---------|------------|
| **Tenant** | Sinónimo de Organización desde la perspectiva operativa de la plataforma. Se usa cuando se habla de la unidad de aislamiento, no de la entidad de negocio. |
| **Miembro** | Una identidad de plataforma que pertenece a una organización. La misma identidad puede ser miembro de varias organizaciones simultáneamente con estados independientes en cada una. No confundir con *Membresía* (que es el acceso a una aplicación dentro de la organización). |
| **Aprovisionamiento** | Proceso de incorporar una identidad como miembro de una organización. En el MVP es exclusivamente manual, iniciado por el Administrador de Organización. |
| **Suspensión** | Estado en que un miembro o una organización completa queda inhabilitada para operar. No implica eliminación de datos. |
| **Configuración de organización** | Parámetros que cada organización define para controlar su operación: política de autenticación, nombre, dominio de correo permitido. |
| **Administrador de Organización** | Miembro con privilegios de gestión total sobre su organización: usuarios, roles, aplicaciones cliente y suscripción. No puede ver ni actuar sobre otras organizaciones. |

[↑ Volver al inicio](#lenguaje-ubicuo)

---

## Client Applications Context

El contexto de Aplicaciones Cliente gestiona los sistemas externos que delegan en Keygo la autenticación de sus usuarios.

| Término | Definición |
|---------|------------|
| **Aplicación cliente** | Sistema externo registrado dentro de una organización que delega en Keygo la autenticación y verificación de identidad. Puede ser una app web, mobile, API, o cualquier otro sistema. |
| **Credencial de aplicación** ⚠️ | Par de identificador y secreto asignado a una aplicación cliente al registrarla. Le permite identificarse ante Keygo para iniciar flujos de autenticación. No confundir con *Credencial* (de usuario) ni con *Credencial de Sesión*. |
| **Registro de aplicación** | Acto de dar de alta una aplicación cliente en una organización. Produce una Credencial de Aplicación y define los ámbitos de acceso permitidos. |
| **Ámbito autorizado** | Subconjunto de ámbitos de acceso que la plataforma permite a una aplicación cliente solicitar en nombre de sus usuarios. Definido en el momento del registro. |
| **Política de incorporación** | Regla configurada en cada aplicación cliente que determina cómo una identidad puede convertirse en miembro con acceso a esa aplicación. Existen cuatro modalidades: **sin autoregistro** (solo el administrador puede incorporar), **por invitación** (el administrador invita, el usuario acepta), **validado por administrador** (el usuario solicita acceso, el administrador aprueba), **autovalidado** (el usuario solicita y obtiene acceso inmediato). |
| **Integración** | La relación operativa entre una aplicación cliente y Keygo: el flujo mediante el cual la app delega autenticación y consume las credenciales de sesión emitidas. |

[↑ Volver al inicio](#lenguaje-ubicuo)

---

## Billing Context

El contexto de Facturación gestiona la relación comercial entre Keygo y cada organización.

| Término | Definición |
|---------|------------|
| **Plan** | Configuración de límites y capacidades disponible para una organización: cantidad máxima de usuarios, aplicaciones cliente, llamadas por período. |
| **Suscripción** | Estado activo de un plan en una organización. Determina qué capacidades están habilitadas. Una organización tiene exactamente una suscripción activa. |
| **Límite de uso** | Restricción cuantitativa impuesta por el plan activo: número de usuarios, aplicaciones o eventos que la organización puede tener o generar. |
| **Medición de uso** | Registro continuo del consumo de recursos de una organización contra los límites de su plan activo. |
| **Excedente** | Estado en que una organización supera un límite de su plan. El sistema puede bloquear nuevas altas o notificar según la política configurada. |
| **Ciclo de facturación** | Período durante el cual se acumula el consumo para efectos de cobro. |

[↑ Volver al inicio](#lenguaje-ubicuo)

---

## Audit Context

El contexto de Auditoría registra de forma inmutable lo que ocurre en el sistema para fines de trazabilidad, cumplimiento y soporte.

| Término | Definición |
|---------|------------|
| **Evento de seguridad** | Acción relevante para la seguridad o gobernanza que queda registrada: inicio de sesión, cierre de sesión, cambio de rol, revocación de acceso, cambio de contraseña, alta o baja de usuario. |
| **Registro de auditoría** | Colección inmutable y ordenada cronológicamente de eventos de seguridad. No puede ser modificada ni eliminada por ningún actor del sistema, incluido el Administrador de Plataforma. |
| **Trazabilidad** | Capacidad de reconstruir la secuencia de acciones que llevaron a un estado dado, a partir del registro de auditoría. |
| **Actor del evento** | Quién originó el evento registrado: una identidad autenticada, un administrador, una aplicación cliente o el propio sistema. |
| **Alcance del evento** | Organización a la que pertenece el evento. El registro de auditoría de una organización solo es visible para su Administrador y para el Administrador de Plataforma con trazabilidad. |

[↑ Volver al inicio](#lenguaje-ubicuo)

---

## Platform Context

El contexto de Plataforma gestiona la operación global de Keygo como producto: visibilidad sobre organizaciones, soporte operativo y administración del servicio.

| Término | Definición |
|---------|------------|
| **Rol de plataforma** | Atributo obligatorio de toda identidad en Keygo que determina qué puede hacer dentro del propio sistema. Una identidad sin rol de plataforma es una inconsistencia — no puede operar. Los roles forman una jerarquía de inclusión: `KEYGO_ADMIN` ⊇ `KEYGO_ACCOUNT_ADMIN` ⊇ `KEYGO_USER`. Una identidad con un rol superior incluye todas las capacidades de los roles inferiores. |
| **KEYGO_USER** | Rol base. Toda identidad en Keygo lo tiene. Capacidades: autogestión de cuenta (contraseña, sesiones, preferencias, conexiones externas) y acceso a las aplicaciones de una organización a través de sus membresías. Se obtiene a través de alguno de los flujos de incorporación habilitados en la aplicación destino. |
| **KEYGO_ACCOUNT_ADMIN** | Incluye todo lo de `KEYGO_USER`, más la capacidad de administrar una organización: gestión de usuarios, aplicaciones, roles y suscripción. Se obtiene a través del flujo de contratación (billing): es la identidad que suscribió un plan de Keygo. Es el Administrador de Organización de facto. |
| **KEYGO_ADMIN** | Incluye todo lo de `KEYGO_ACCOUNT_ADMIN`, más acceso transversal a todas las organizaciones para operación y soporte del servicio. Sus acciones quedan siempre registradas. No accede a datos de negocio de los tenants. |
| **Rol activo** | El rol de plataforma bajo el cual una identidad está operando en un momento dado en la interfaz de Keygo. Una identidad con más de un rol puede cambiar su rol activo en cualquier momento; la interfaz y las acciones disponibles se adaptan al rol seleccionado. |
| **Vista global** | Perspectiva del `KEYGO_ADMIN` sobre el estado del sistema: organizaciones activas, uso agregado, alertas operativas. |
| **Operación de soporte** | Acción realizada por un `KEYGO_ADMIN` en respuesta a un incidente o solicitud: suspender una organización, reactivarla, escalar un problema. Siempre queda registrada. |

[↑ Volver al inicio](#lenguaje-ubicuo)

---

## Ambigüedades resueltas

Estos son los términos que generan mayor confusión porque aparecen en múltiples contextos con significados distintos. La tabla establece el significado canónico en cada uno.

| Término | En Identity | En Access Control | En Organization | En Billing |
|---------|-------------|-------------------|-----------------|------------|
| **Usuario** | Identidad con credenciales y sesiones | Sujeto con roles y permisos en una aplicación | Miembro: identidad de plataforma que pertenece a la organización, con estado propio en ella | Unidad de consumo contra el plan |
| **Credencial** | Secreto de autenticación (contraseña) | No aplica | No aplica | No aplica |
| **Credencial de sesión** | Artefacto emitido tras autenticación | No aplica | No aplica | No aplica |
| **Credencial de aplicación** | No aplica | No aplica | No aplica | No aplica |
| **Revocación** | Invalidación anticipada de sesión o credencial de sesión | Eliminación de membresía o rol | No aplica | No aplica |
| **Ámbito** | No aplica | Lo que un sujeto puede hacer en una app | No aplica | No aplica |
| **Acceso** | Capacidad de autenticarse; determinada por el rol de plataforma y el estado de la identidad | Capacidad de ejecutar operaciones; determinada por roles de aplicación | Membresía activa en la organización | No aplica |

[↑ Volver al inicio](#lenguaje-ubicuo)

---

## Verbos del dominio

Los verbos del dominio son las acciones que el sistema realiza o que los actores ejecutan. Nombrarlos con precisión es parte del lenguaje ubicuo — un verbo impreciso esconde lógica de negocio.

| Verbo | Sujeto | Descripción |
|-------|--------|-------------|
| **Autenticar** | Identidad | Verificar las credenciales de una identidad y producir una sesión activa. |
| **Emitir** | Sistema | Generar una Credencial de Sesión o de Renovación tras una autenticación exitosa. |
| **Verificar** | Sistema / App cliente | Comprobar que una Credencial de Sesión es auténtica, vigente y no revocada. |
| **Renovar** | Sistema | Emitir una nueva Credencial de Sesión a partir de una Credencial de Renovación válida. |
| **Revocar** | Identidad / Admin / Sistema | Invalidar anticipadamente una sesión, Credencial de Sesión o Credencial de Renovación. |
| **Aprovisionar** | Admin de Organización | Dar de alta un nuevo miembro en la organización. |
| **Suspender** | Admin de Organización / Admin de Plataforma | Inhabilitar temporalmente un miembro u organización. |
| **Asignar** | Admin de Organización | Vincular un rol a un sujeto en una aplicación cliente. |
| **Evaluar** | Sistema | Determinar si un sujeto tiene permiso para ejecutar una operación. |
| **Registrar** | Sistema | Persistir un evento de seguridad en el registro de auditoría. |
| **Rotar** | Sistema | Reemplazar claves criptográficas manteniendo verificabilidad de credenciales anteriores. |
| **Suscribir** | Admin de Organización | Activar un plan en una organización. |
| **Medir** | Sistema | Contabilizar el consumo de recursos de una organización contra su plan activo. |

[↑ Volver al inicio](#lenguaje-ubicuo)

---

## Comentarios de los Revisores

| Revisor | Tipo | Contenido |
|---------|------|-----------|
| — | — | Pendiente de revisión |

[↑ Volver al inicio](#lenguaje-ubicuo)

---

[← Índice](./README.md) | [< Anterior](./strategic-design.md) | [Siguiente >](./context-map.md)
