[← Índice](./README.md) | [< Anterior](./system-flows.md) | [Siguiente >](./bounded-contexts/identity.md)

---

# Decisiones de Diseño

Este documento registra las decisiones no obvias que dieron forma al modelo de dominio y a la arquitectura del proceso. Para cada decisión se documenta qué se eligió, por qué se eligió eso y qué alternativa se descartó. Las decisiones técnicas de implementación se registran en las ADRs del módulo de desarrollo.

## Contenido

- [Cómo leer este documento](#cómo-leer-este-documento)
- [Arquitectura general](#arquitectura-general)
  - [DD-01 — Arquitectura hexagonal estricta](#dd-01--arquitectura-hexagonal-estricta)
- [Modelo de identidad](#modelo-de-identidad)
  - [DD-02 — Identidad dual: usuario de plataforma y usuario de tenant](#dd-02--identidad-dual-usuario-de-plataforma-y-usuario-de-tenant)
  - [DD-03 — Ciclo de vida de autenticación: tres agregados en cadena](#dd-03--ciclo-de-vida-de-autenticación-tres-agregados-en-cadena)
  - [DD-04 — Reclamos OIDC como atributos de primer nivel en el dominio](#dd-04--reclamos-oidc-como-atributos-de-primer-nivel-en-el-dominio)
- [Seguridad y credenciales](#seguridad-y-credenciales)
  - [DD-05 — Rotación de credencial de renovación con almacenamiento solo de hash](#dd-05--rotación-de-credencial-de-renovación-con-almacenamiento-solo-de-hash)
  - [DD-06 — Roles embebidos en la credencial de sesión al momento de emisión](#dd-06--roles-embebidos-en-la-credencial-de-sesión-al-momento-de-emisión)
  - [DD-07 — PKCE obligatorio con soporte de dos métodos](#dd-07--pkce-obligatorio-con-soporte-de-dos-métodos)
  - [DD-08 — Claves de firma con ámbito por tenant y fallback global](#dd-08--claves-de-firma-con-ámbito-por-tenant-y-fallback-global)
  - [DD-09 — Duración de credenciales como constante de dominio, no configuración](#dd-09--duración-de-credenciales-como-constante-de-dominio-no-configuración)
- [Multi-tenancy](#multi-tenancy)
  - [DD-10 — Aislamiento de tenant via contexto de hilo con resolución por encabezado](#dd-10--aislamiento-de-tenant-via-contexto-de-hilo-con-resolución-por-encabezado)
- [Modelo de control de acceso](#modelo-de-control-de-acceso)
  - [DD-11 — Ámbito de acceso como objeto de valor inmutable](#dd-11--ámbito-de-acceso-como-objeto-de-valor-inmutable)
  - [DD-12 — Roles efectivos por herencia, calculados en la emisión del token](#dd-12--roles-efectivos-por-herencia-calculados-en-la-emisión-del-token)
- [Modelo de dominio general](#modelo-de-dominio-general)
  - [DD-13 — Máquinas de estado mediante enums con transiciones explícitas](#dd-13--máquinas-de-estado-mediante-enums-con-transiciones-explícitas)
  - [DD-14 — Métodos de fábrica sobre constructores en los agregados](#dd-14--métodos-de-fábrica-sobre-constructores-en-los-agregados)
- [Modelo de billing de aplicación](#modelo-de-billing-de-aplicación)
  - [DD-15 — App Billing Account como entidad de billing para usuarios finales de una app](#dd-15--app-billing-account-como-entidad-de-billing-para-usuarios-finales-de-una-app)
- [Comentarios de los Revisores](#comentarios-de-los-revisores)

---

## Cómo leer este documento

Cada decisión incluye:
- **Decisión**: qué se eligió
- **Contexto**: el problema que motivó la decisión
- **Justificación**: por qué esta opción es la correcta para este dominio
- **Alternativa descartada**: qué se consideró y por qué no se eligió
- **Consecuencias**: efectos observables en el modelo o en el comportamiento del sistema

[↑ Volver al inicio](#decisiones-de-diseño)

---

## Arquitectura general

### DD-01 — Arquitectura hexagonal estricta

**Decisión**: El sistema se estructura en capas con dependencia unidireccional: dominio → aplicación → infraestructura. El dominio no depende de ningún framework.

**Contexto**: Un sistema IAM tiene lógica de negocio compleja (ciclo de vida de sesiones, reglas de contraseñas, evaluación de permisos) que debe ser verificable de forma aislada y mantenible a largo plazo.

**Justificación**:
- El dominio sin framework es testeable sin levantar contenedores ni bases de datos
- La capa de aplicación (casos de uso) orquesta sin acoplarse al mecanismo de entrega (HTTP, CLI, eventos)
- El intercambio de infraestructura (base de datos, proveedor de correo) no afecta al dominio ni a los casos de uso
- Las reglas de negocio críticas (revocación, rotación, evaluación de acceso) quedan en el lugar más protegido del modelo

**Alternativa descartada**: Estructura en capas clásica (controlador → servicio → repositorio en un mismo módulo). Mezcla infraestructura y dominio, dificulta el testing y crea dependencias circulares.

**Consecuencias**:
- Todo caso de uso tiene una interfaz de entrada (comando) y una interfaz de salida (resultado) explícitas
- Los repositorios son interfaces del dominio; las implementaciones viven en infraestructura
- El módulo de dominio no tiene dependencias de Spring ni de JPA

[↑ Volver al inicio](#decisiones-de-diseño)

---

## Modelo de identidad

### DD-02 — Roles de plataforma jerárquicos: todo usuario es KEYGO_USER; algunos son también KEYGO_ACCOUNT_ADMIN o KEYGO_ADMIN

**Decisión**: Los roles de plataforma forman una jerarquía de inclusión: `KEYGO_ADMIN` ⊇ `KEYGO_ACCOUNT_ADMIN` ⊇ `KEYGO_USER`. Una identidad tiene un rol máximo asignado, pero ese rol incluye todas las capacidades de los roles inferiores. No existe identidad sin rol de plataforma — es una inconsistencia que el sistema debe impedir.

La jerarquía es:
- **KEYGO_USER** — rol base. Todo usuario del sistema lo tiene. Capacidad: acceder a las aplicaciones de una organización y autogestionar su cuenta (contraseña, sesiones, preferencias, conexiones externas).
- **KEYGO_ACCOUNT_ADMIN** — incluye todo lo de `KEYGO_USER`, más: contrató un plan de Keygo y administra la organización resultante (usuarios, aplicaciones, roles, suscripción).
- **KEYGO_ADMIN** — incluye todo lo de `KEYGO_ACCOUNT_ADMIN`, más: acceso transversal a todas las organizaciones para operación y soporte del servicio.

La interfaz de Keygo permite al usuario seleccionar activamente con qué rol está trabajando en cada momento. La selección cambia el contexto de la interfaz y las acciones disponibles. Los roles disponibles para seleccionar son los que la identidad posee (un `KEYGO_ACCOUNT_ADMIN` puede seleccionar `KEYGO_ACCOUNT_ADMIN` o `KEYGO_USER`; un `KEYGO_USER` no tiene selector).

La pertenencia a una organización y el acceso a sus aplicaciones se modelan como capas sobre esta identidad de plataforma:
1. La identidad pertenece a una o más organizaciones como **miembro** (con estado propio en cada una)
2. Como miembro, puede tener **membresías** a aplicaciones específicas de esa organización, con los roles que le corresponden

**Contexto**: Separar la identidad de plataforma de la pertenencia organizacional permite que las operaciones de autogestión (contraseña, sesiones activas, perfil) sean independientes del contexto de organización. La jerarquía de roles permite que el mismo sistema gestione escenarios distintos sin duplicar identidades.

**Justificación**:
- La jerarquía hace explícito que `KEYGO_ADMIN` y `KEYGO_ACCOUNT_ADMIN` no son "tipos distintos de usuario" — son usuarios con mayor alcance sobre la plataforma
- El selector de rol activo en la interfaz permite que un `KEYGO_ADMIN` actúe como `KEYGO_USER` para comprobar experiencias de usuario sin necesidad de otra cuenta
- `KEYGO_ACCOUNT_ADMIN` se origina en el flujo de contratación (billing), lo que vincula la identidad con la responsabilidad comercial de la organización
- `KEYGO_USER` puede incorporarse a las aplicaciones de una organización mediante cuatro modalidades según la política de la aplicación: sin autoregistro, por invitación, validado por administrador, o autovalidado
- La autogestión de cuenta es una capacidad del rol base (`KEYGO_USER`), que todos los usuarios tienen por definición

**Alternativa descartada**: Roles planos sin jerarquía (tres tipos de usuario completamente distintos). Obliga a crear identidades separadas para un operador de Keygo que también necesita probar la experiencia de un usuario final. Oscurece la relación entre los roles.

**Consecuencias**:
- El selector de rol activo es parte de la interfaz de Keygo para cualquier identidad con más de un rol
- Los eventos de auditoría registran el rol activo en el momento de cada acción, no solo la identidad
- La jerarquía es solo de plataforma — dentro de una organización, los roles de aplicación son independientes y los gestiona Access Control

[↑ Volver al inicio](#decisiones-de-diseño)

---

### DD-03 — Ciclo de vida de autenticación: tres agregados en cadena

**Decisión**: El flujo de autenticación produce tres agregados con responsabilidades distintas: **Código de Autorización** (uso único, corta duración), **Sesión** (agrupa todos los tokens de una autenticación), **Credencial de Renovación** (cadena rotativa de larga duración).

**Contexto**: La autenticación no es un evento puntual sino un ciclo con fases: el usuario prueba su identidad, obtiene un artefacto temporal para canjear por tokens, y luego renueva sus credenciales sin reautenticarse. Cada fase tiene reglas distintas.

**Justificación**:
- El Código de Autorización es de un solo uso; modelarlo como agregado propio hace que su invalidación sea explícita en el dominio
- La Sesión agrupa todas las Credenciales de Renovación de un mismo acto de autenticación, lo que permite revocar "todo lo de esta autenticación" en una sola operación
- La Credencial de Renovación tiene su propia cadena de rotación (cada uso produce una nueva), que habilita la detección de ataques de reproducción

**Alternativa descartada**: Modelo plano con un único artefacto de sesión que acumula todas las responsabilidades. No distingue entre el artefacto de canje inicial y las credenciales de larga duración; hace difícil detectar replay attacks y complicado implementar revocación selectiva.

**Consecuencias**:
- La revocación de una Sesión invalida en cascada todas sus Credenciales de Renovación
- La detección de ataque de reproducción es posible porque cada Credencial de Renovación tiene estado (ACTIVA, USADA, REVOCADA)
- Una identidad puede tener varias Sesiones activas simultáneamente (multi-dispositivo)

[↑ Volver al inicio](#decisiones-de-diseño)

---

### DD-04 — Reclamos OIDC como atributos de primer nivel en el dominio

**Decisión**: El modelo de identidad del usuario incluye los atributos estándar de OIDC (locale, zona horaria, número de teléfono, foto de perfil, fecha de nacimiento, sitio web) como campos explícitos del dominio, no como metadatos genéricos.

**Contexto**: Las Credenciales de Sesión deben incluir reclamos sobre el usuario para que las aplicaciones cliente no necesiten consultar al servidor en cada petición. OIDC define un conjunto estándar de reclamos de perfil. El dominio necesita decidir cuáles gestiona y cómo.

**Justificación**:
- Los reclamos explícitos son verificables en tiempo de compilación; un mapa genérico acepta cualquier clave sin validación
- El vínculo entre ámbito solicitado (scope) y atributos incluidos en el token se puede expresar como lógica del dominio, no como configuración
- Adoptar el estándar OIDC en el modelo garantiza interoperabilidad con aplicaciones cliente que entienden el vocabulario estándar

**Alternativa descartada**: Mapa genérico de atributos personalizados (clave-valor). No tiene tipado, no se puede controlar qué atributos se emiten por ámbito, y hace el modelo opaco para quien lee el código.

**Consecuencias**:
- El scope `profile` determina qué atributos de identidad se incluyen en la Credencial de Sesión
- El scope `email` y `phone` controlan la inclusión de esos atributos específicos
- Atributos no estándar de OIDC no forman parte del modelo de identidad

[↑ Volver al inicio](#decisiones-de-diseño)

---

## Seguridad y credenciales

### DD-05 — Rotación de credencial de renovación con almacenamiento solo de hash

**Decisión**: Las Credenciales de Renovación se almacenan únicamente como hash (SHA-256). El artefacto en texto plano se entrega una sola vez al cliente y el sistema nunca lo vuelve a conocer. Cada uso de una Credencial de Renovación la invalida y genera una nueva.

**Contexto**: Las Credenciales de Renovación son de larga duración (30 días). Si la base de datos fuera comprometida, las credenciales almacenadas en texto plano permitirían al atacante impersonar cualquier identidad autenticada durante el período de vigencia.

**Justificación**:
- El hash es determinista: el cliente presenta el texto plano, el sistema lo hashea y busca por hash — no se necesita el texto plano original
- El robo de la base de datos no compromete las sesiones activas — el atacante obtiene hashes que no puede revertir
- La rotación detecta ataques de reproducción: si una credencial en estado USADA es presentada, alguien la robó — se revoca toda la cadena

**Alternativa descartada**: Almacenar texto plano o valor cifrado. El cifrado reversible sigue siendo vulnerable si el atacante obtiene la clave de cifrado junto con los datos. El texto plano es directamente explotable.

**Consecuencias**:
- Cada Credencial de Renovación tiene un estado explícito: ACTIVA, USADA, REVOCADA
- La cadena de rotación (cada credencial apunta a la siguiente) permite trazar la historia completa de una sesión
- Presentar una credencial en estado USADA produce el evento `AtaqueDeReproduccíónDetectado` y revocación inmediata de la sesión completa

[↑ Volver al inicio](#decisiones-de-diseño)

---

### DD-06 — Roles embebidos en la credencial de sesión al momento de emisión

**Decisión**: Los roles efectivos del usuario se calculan en el momento de emitir o renovar la Credencial de Sesión y quedan embebidos en ella. Las aplicaciones cliente no necesitan consultar a Keygo para evaluar roles en cada petición.

**Contexto**: Las aplicaciones cliente reciben una Credencial de Sesión y la usan para proteger sus propios endpoints. Si los roles no estuvieran embebidos, cada evaluación de acceso requeriría una llamada al servidor de Keygo.

**Justificación**:
- Elimina la latencia de N consultas por petición en las aplicaciones cliente
- La Credencial de Sesión es autocontenida y verificable offline — el cliente no necesita conectividad a Keygo para validar identidad y roles
- El TTL de la credencial (1 hora) es la ventana máxima de inconsistencia aceptable si los roles cambian

**Alternativa descartada**: Incluir solo el identificador de usuario en el token y consultar roles en tiempo real. Dobla la carga del servidor; elimina la capacidad de verificación offline; genera latencia adicional en cada petición protegida.

**Consecuencias**:
- Un cambio de rol no tiene efecto hasta que el usuario renueve su Credencial de Sesión (máximo 1 hora de inconsistencia)
- La revocación de acceso urgente requiere también revocar la Sesión activa del usuario
- Los roles incluidos son los efectivos, incluyendo los heredados por la jerarquía de roles de la aplicación

[↑ Volver al inicio](#decisiones-de-diseño)

---

### DD-07 — PKCE obligatorio con soporte de dos métodos

**Decisión**: El flujo de autorización requiere PKCE (Proof Key for Code Exchange) para todos los tipos de cliente. Se soportan dos métodos: S256 (SHA-256, recomendado) y plain (texto plano, para compatibilidad).

**Contexto**: El flujo de autorización emite un Código de Autorización que, si es interceptado, puede ser canjeado por tokens. PKCE garantiza que solo el cliente que inició el flujo puede completar el canje.

**Justificación**:
- El Código de Autorización viaja por URL de redirección — vector de intercepción conocido en aplicaciones móviles y SPA
- PKCE convierte el código en inutilizable para un atacante que lo intercepte sin conocer el verificador original
- S256 es el método estándar y el más seguro; plain se mantiene para compatibilidad con clientes que no pueden computar hash

**Alternativa descartada**: PKCE opcional o solo para clientes públicos. La obligatoriedad universal simplifica la política de seguridad y elimina la decisión de si un cliente particular debe usar PKCE o no.

**Consecuencias**:
- Todo flujo de autorización requiere enviar `code_challenge` y `code_challenge_method` al inicio
- El canje del Código de Autorización requiere presentar el `code_verifier` original
- S256 es la opción por defecto; plain solo se acepta si el cliente lo declara explícitamente

[↑ Volver al inicio](#decisiones-de-diseño)

---

### DD-08 — Claves de firma con ámbito por tenant y fallback global

**Decisión**: Las claves criptográficas que firman las Credenciales de Sesión pueden ser específicas de un tenant o globales (fallback de plataforma). Una clave en estado RETIRADA sigue publicándose en el endpoint público de claves hasta que expire, para que los tokens ya emitidos con ella puedan verificarse.

**Contexto**: Las Credenciales de Sesión se verifican offline por las aplicaciones cliente. Si las claves de firma cambian, los tokens existentes deben seguir siendo verificables durante su período de validez.

**Justificación**:
- Las claves por tenant permiten rotarlas independientemente, aislando el impacto de un compromiso
- El fallback global garantiza continuidad si un tenant no tiene clave propia configurada
- El estado RETIRADA distingue "ya no firmo con esta clave" de "ya no es válida para verificar" — período de transición necesario

**Alternativa descartada**: Clave global única. No permite rotación por tenant; un compromiso de la clave global invalida todas las sesiones de todos los tenants simultáneamente.

**Consecuencias**:
- El endpoint JWKS público expone tanto las claves ACTIVAS como las RETIRADAS aún vigentes
- La rotación de claves no invalida las Credenciales de Sesión existentes — expiran naturalmente
- El evento `ClavesRotadas` registra el identificador del conjunto anterior y su fecha de expiración

[↑ Volver al inicio](#decisiones-de-diseño)

---

### DD-09 — Duración de credenciales como constante de dominio, no configuración

**Decisión**: La duración de la Credencial de Sesión (1 hora) y de la Credencial de Renovación (30 días) son constantes del dominio definidas en los casos de uso, no parámetros de configuración externa.

**Contexto**: Los TTLs de los tokens son decisiones de seguridad con implicaciones directas en la postura de riesgo del sistema. Una configuración externa permite cambiarlos sin modificar el código, lo que puede crear inconsistencias o regresiones de seguridad inadvertidas.

**Justificación**:
- Hacer los TTLs explícitos en el código los convierte en parte del modelo visible y sujeto a revisión en code review
- Un cambio de TTL es una decisión de seguridad que merece un cambio de código deliberado, no una modificación de variable de entorno
- Los valores actuales son el resultado de evaluar el equilibrio entre seguridad (tokens cortos) y usabilidad (no reautenticarse frecuentemente)

**Alternativa descartada**: TTLs en propiedades de aplicación o variables de entorno. Facilita ajustes operativos pero hace opaca la decisión de seguridad y permite degradar la postura sin dejar rastro en el historial de código.

**Consecuencias**:
- Cambiar los TTLs requiere modificar el código y pasar por revisión
- Las Credenciales de Sesión expiran en 1 hora; las aplicaciones cliente deben implementar renovación automática
- Las Credenciales de Renovación expiran en 30 días; inactividad mayor a ese período requiere nueva autenticación

[↑ Volver al inicio](#decisiones-de-diseño)

---

## Multi-tenancy

### DD-10 — Aislamiento de tenant via contexto de hilo con resolución por encabezado

**Decisión**: El tenant activo en cada petición se determina por un encabezado HTTP (`X-Tenant-Slug` o path variable `tenantSlug`), se resuelve a un identificador de organización, se almacena en un contexto de hilo y se limpia al finalizar la petición. El código de dominio y de aplicación no recibe el tenant como parámetro explícito en cada llamada.

**Contexto**: El aislamiento entre organizaciones es la restricción más crítica del sistema. Cada consulta, cada operación y cada evento debe pertenecer a exactamente una organización. Propagar el identificador de tenant como parámetro en cada llamada es propenso a errores de omisión.

**Justificación**:
- El contexto de hilo hace el tenant implícito para el código de dominio — es un invariante del entorno de ejecución, no un argumento de función
- El filtro de resolución lo establece una sola vez por petición y lo verifica: tenant debe existir y estar activo
- El cleanup en finally garantiza que no hay fuga de contexto entre peticiones en servidores con thread pooling

**Alternativa descartada**: Pasar el identificador de tenant como parámetro en cada método de caso de uso y repositorio. Funciona pero es verboso, repetitivo y fácil de olvidar en un nuevo punto de entrada.

**Consecuencias**:
- El tenant se valida (existente, activo) en cada petición antes de llegar al caso de uso
- Una organización suspendida provoca rechazo en el filtro antes de ejecutar ninguna lógica de negocio
- Los endpoints de plataforma (sin `tenantSlug`) no pasan por resolución de tenant

[↑ Volver al inicio](#decisiones-de-diseño)

---

## Modelo de control de acceso

### DD-11 — Ámbito de acceso como objeto de valor inmutable

**Decisión**: El conjunto de ámbitos de acceso autorizados (openid, profile, email, offline_access) es un objeto de valor inmutable. No se puede modificar un ámbito existente — se debe crear un nuevo conjunto.

**Contexto**: Los ámbitos determinan qué reclamos incluye la Credencial de Sesión y a qué operaciones puede acceder el portador. Un ámbito inválido o una modificación silenciosa del conjunto podría otorgar acceso no autorizado.

**Justificación**:
- La inmutabilidad garantiza que el conjunto de ámbitos en uso es siempre el que fue validado en el momento de construcción
- La validación centralizada en la construcción del objeto detecta ámbitos inválidos en el límite del dominio, no en el momento de uso
- El modelo de ámbitos es estable (OIDC define un conjunto finito); la inmutabilidad refleja esa estabilidad

**Alternativa descartada**: Lista mutable de strings. Acepta valores arbitrarios, no hay momento claro de validación y puede cambiar de forma silenciosa durante el procesamiento de un flujo.

**Consecuencias**:
- Un ámbito no reconocido por el dominio se rechaza en el momento de construcción del objeto, no al emitir el token
- Las aplicaciones cliente declaran ámbitos al registrarse; ese conjunto no puede ampliarse sin un nuevo registro
- El scope `offline_access` es el que habilita la emisión de Credencial de Renovación

[↑ Volver al inicio](#decisiones-de-diseño)

---

### DD-12 — Roles efectivos por herencia, calculados en la emisión del token

**Decisión**: Al emitir una Credencial de Sesión, el sistema calcula los roles efectivos del usuario en la aplicación incluyendo los heredados por la jerarquía de roles. El resultado se embebe en el token y no se recalcula hasta la próxima renovación.

**Contexto**: El control de acceso por roles incluye herencia: un rol puede tener un rol padre, y los permisos del padre se aplican al hijo. Calcular la jerarquía en cada petición de evaluación de acceso es costoso.

**Justificación**:
- Computar una vez y embeber el resultado en el token elimina la latencia de múltiples evaluaciones de herencia
- La jerarquía de roles es estable durante la sesión — cambios infrecuentes no justifican el costo de recálculo por petición
- Los roles efectivos (directos + heredados) son exactamente lo que las aplicaciones cliente necesitan para evaluar acceso

**Alternativa descartada**: Calcular roles efectivos en tiempo real en cada petición de evaluación. Correcto en términos de consistencia estricta, pero impracticable para el volumen de peticiones de una aplicación en uso normal.

**Consecuencias**:
- Cambiar la jerarquía de roles no tiene efecto inmediato en las sesiones activas — requiere renovación de token
- Un rol asignado directamente y uno heredado son indistinguibles en la Credencial de Sesión
- La granularidad de actualización de roles es el TTL de la Credencial de Sesión (1 hora)

[↑ Volver al inicio](#decisiones-de-diseño)

---

## Modelo de dominio general

### DD-13 — Máquinas de estado mediante enums con transiciones explícitas

**Decisión**: Los ciclos de vida de los agregados (Sesión, Código de Autorización, Credencial de Renovación, Membresía, etc.) se modelan con enums de estado. Las transiciones válidas están codificadas en los métodos del agregado y se rechazan si el estado actual no lo permite.

**Contexto**: Los agregados con ciclo de vida complejo (creación → uso → expiración o revocación) deben garantizar que no ocurran transiciones inválidas (revocar algo ya expirado, usar algo ya revocado, etc.).

**Justificación**:
- Los enums hacen el conjunto de estados finito y visible en el código
- Las transiciones en el método del agregado (no en el servicio) mantienen la lógica de negocio dentro del dominio
- Las transiciones no válidas se rechazan explícitamente con un error del dominio, no silenciosamente

**Alternativa descartada**: Clases selladas (sealed class) con una subclase por estado. Más expresivo para tipos algebraicos complejos, pero innecesario para máquinas de estado simples donde el comportamiento por estado es uniforme.

**Consecuencias**:
- El estado se almacena como string en la base de datos y se reconstruye como enum al cargar el agregado
- Agregar un nuevo estado requiere un cambio de código deliberado — no es posible de forma silenciosa
- Las transiciones inválidas generan excepciones del dominio, no errores de infraestructura

[↑ Volver al inicio](#decisiones-de-diseño)

---

### DD-14 — Métodos de fábrica sobre constructores en los agregados

**Decisión**: Los agregados se crean mediante métodos de fábrica estáticos con nombres del dominio (`Session.open()`, `RefreshToken.issue()`) y se reconstituyen desde almacenamiento con un método semánticamente distinto (`Session.reconstitute()`, `RefreshToken.reconstitute()`). Los constructores son privados.

**Contexto**: La creación de un nuevo agregado y la carga de uno existente son operaciones semánticamente distintas. La creación implica aplicar reglas de negocio e inicializar estado; la reconstitución implica restaurar estado ya validado sin ejecutar reglas de creación.

**Justificación**:
- El nombre del método de fábrica es vocabulario del dominio (emitir, abrir, crear) — el constructor no puede serlo
- La distinción entre crear y reconstituir previene que reglas de creación se disparen al cargar un agregado desde base de datos
- El constructor privado hace imposible crear un agregado inválido accidentalmente

**Alternativa descartada**: Constructores públicos con sobrecarga. No hay forma de distinguir semánticamente creación de reconstitución con un constructor; cualquier código puede construir el agregado directamente sin pasar por las validaciones.

**Consecuencias**:
- El repositorio usa `reconstitute()` al cargar agregados — no reedita reglas de creación
- Los casos de uso usan el método de fábrica de creación (`open`, `issue`) — aplican invariantes de inicio
- Los nombres de los métodos son parte del lenguaje ubicuo y deben coincidir con los verbos del dominio documentados

[↑ Volver al inicio](#decisiones-de-diseño)

---

## Modelo de billing de aplicación

### DD-15 — App Billing Account como entidad de billing para usuarios finales de una app

**Decisión**: Cuando una aplicación cliente define planes comerciales propios, cada usuario que contrata uno de esos planes queda representado por una entidad `AppBillingAccount` — un objeto de billing ligero, scoped a la combinación usuario + aplicación. No se reutiliza la entidad `Contractor` (que modela la relación comercial entre Keygo y sus clientes) para representar usuarios finales de las apps de un tenant.

La jerarquía de billing resultante es:

```
Keygo → Contractor → [app_contract / app_subscription]  (billing de plataforma)
Tenant's App → AppBillingAccount → [app_contract / app_subscription]  (billing de app)
```

Un `AppBillingAccount` existe como máximo uno por usuario por aplicación. Una membresía activa (`app_membership`) referencia opcionalmente su `AppBillingAccount` cuando la app tiene planes. La suscripción activa del cuenta determina qué derechos (`app_plan_entitlements`) tiene ese usuario en esa app.

**Contexto**: El modelo de `Contractor` fue diseñado para representar personas o empresas que firman contratos con Keygo y son responsables de pagar por tenants y aplicaciones. Un usuario final de la app de un tenant tiene una naturaleza distinta: no es un contratante de Keygo, no posee tenants, y su relación comercial es con la app, no con la plataforma. Forzar a cada usuario final en un registro `Contractor` crearía un acoplamiento incorrecto y una proliferación de registros sin semántica de plataforma.

**Justificación**:
- `AppBillingAccount` tiene exactamente el scope correcto: `tenant_user + client_app`. Un `Contractor` es global en la plataforma; un usuario de app solo tiene relación comercial con una app específica.
- Mantener los dos modelos separados preserva la pureza semántica de `Contractor` (cliente de Keygo) sin mezclarla con la de "usuario final de una app de un tenant".
- `app_subscriptions` soporta ambos escenarios mediante campos mutuamente excluyentes: `contractor_id` (billing de plataforma) o `app_billing_account_id` (billing de app). Exactamente uno debe estar presente.
- La membresía (`app_membership`) referencia opcionalmente el `AppBillingAccount`: si la app no tiene planes, la membresía no necesita cuenta de billing y el flujo es idéntico al actual.

**Alternativa descartada**: Reutilizar `Contractor` para usuarios finales de apps, creando un registro `Contractor` por cada usuario que suscriba a un plan de app. Técnicamente posible pero semánticamente incorrecto: mezcla el concepto de "cliente de Keygo" con "usuario de app", complica las vistas de administración de plataforma (el listado de contratantes incluiría millones de usuarios finales), y hace opaca la distinción entre billing de plataforma y billing de app.

**Consecuencias**:
- `AppBillingAccount` tiene su propio ciclo de vida: `ACTIVE` → `SUSPENDED` → `CLOSED`.
- Al activarse una suscripción de app para un usuario, se crea o activa su `AppBillingAccount` y se vincula a la `app_membership`.
- Al evaluarse la sesión OAuth, el sistema puede resolver el plan activo del usuario: `app_membership.app_billing_account_id` → `app_subscription` activa → `app_plan_version` → `app_plan_entitlements`. El resultado puede incluirse como claims en la credencial de sesión o exponerse como endpoint consultable.
- Los derechos del plan (`app_plan_entitlements`) se evalúan en el momento de emisión de la credencial de sesión y quedan embebidos, con la misma lógica TTL que los roles (ventana de inconsistencia de 1 hora).

[↑ Volver al inicio](#decisiones-de-diseño)

---

## Comentarios de los Revisores

| Revisor | Tipo | Contenido |
|---------|------|-----------|
| — | — | Pendiente de revisión |

[↑ Volver al inicio](#decisiones-de-diseño)

---

[← Índice](./README.md) | [< Anterior](./system-flows.md) | [Siguiente >](./bounded-contexts/identity.md)
