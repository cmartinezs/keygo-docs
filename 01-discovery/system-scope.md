[← Índice](./README.md) | [< Anterior](./system-vision.md) | [Siguiente >](./actors.md)

---

# Alcance del Sistema

## Contenido

- [Propósito](#propósito)
- [Alcance funcional](#alcance-funcional)
  - [Trazabilidad entre Objetivos Estratégicos y Alcance Funcional](#trazabilidad-entre-objetivos-estratégicos-y-alcance-funcional)
  - [Alcance del MVP](#alcance-del-mvp)
- [Fuera de alcance en esta fase](#fuera-de-alcance-en-esta-fase)
- [Otras consideraciones](#otras-consideraciones)
  - [Límites operativos iniciales](#límites-operativos-iniciales)
  - [Dependencias y supuestos](#dependencias-y-supuestos)
- [Comentarios de los Revisores](#comentarios-de-los-revisores)

---

## Propósito

Keygo se establece como el punto central de autenticación, autorización y gestión de identidad para ecosistemas SaaS multi-organización. Su propósito es proveer a las aplicaciones cliente un único lugar desde donde resolver quién es el usuario, qué puede hacer y bajo qué organización opera, eliminando la necesidad de que cada aplicación gestione esas responsabilidades de forma independiente.

El alcance del sistema comprende la gestión completa del ciclo de vida de la identidad —desde el registro de una organización y sus usuarios hasta el control de acceso granular, la facturación por uso y la trazabilidad de cada evento de seguridad— ofreciendo un marco coherente, seguro y administrable desde una única plataforma.

[↑ Volver al inicio](#alcance-del-sistema)

---

## Alcance funcional

Esta sección detalla las **capacidades clave** que Keygo deberá incorporar a lo largo de su roadmap, más allá de la primera entrega. Cada capacidad describe "lo que el sistema debe poder hacer" sin entrar en soluciones de implementación.

El objetivo es:

1. **Trazar** cómo cada capacidad contribuye a los objetivos estratégicos definidos.
2. **Guiar la priorización** de iteraciones futuras, mostrando qué piezas son fundamentales y cuáles pueden añadirse gradualmente.
3. **Dar visibilidad** a todos los actores sobre el alcance total, evitando malentendidos sobre qué estará y qué no estará cubierto.

| # | Capacidad | Descripción | Valor estratégico |
|---|-----------|-------------|-------------------|
| **1** | **Gestión de organizaciones** | Registro, configuración y administración del ciclo de vida de cada organización en la plataforma. Cada organización opera de forma completamente aislada. | Habilita el modelo multi-organización y es el punto de partida para todas las demás capacidades. |
| **2** | **Autenticación de usuarios** | Gestión del ciclo completo de inicio de sesión, renovación de credenciales, cierre de sesión y revocación de acceso. Las credenciales son siempre validadas en el contexto de la organización correspondiente. | Elimina la duplicación de mecanismos de autenticación en cada aplicación cliente. |
| **3** | **Gestión de usuarios por organización** | Creación, modificación, suspensión y eliminación de usuarios dentro de cada organización. El administrador de la organización gestiona su propio directorio de usuarios de forma autónoma. | Transfiere el control del directorio de usuarios a cada organización, reduciendo la dependencia del equipo operativo de Keygo. |
| **4** | **Control de acceso basado en roles** | Definición de roles y permisos por organización, asignación a usuarios y aplicaciones cliente, y verificación automática en cada operación. La jerarquía de roles permite delegar administración dentro de la organización. | Permite que cada organización modele su propia estructura de acceso sin exponer privilegios globales. |
| **5** | **Registro y gestión de aplicaciones cliente** | Las organizaciones registran las aplicaciones que tendrán acceso a sus usuarios. Cada aplicación tiene un ámbito de acceso definido y controlado. | Garantiza que solo las aplicaciones autorizadas puedan operar sobre los recursos de cada organización. |
| **6** | **Facturación por organización** | Gestión de planes, suscripciones y ciclos de facturación por organización. Permite cobrar por el uso de la plataforma y habilita que cada organización gestione su propia suscripción. | Hace posible la operación de Keygo como producto SaaS sostenible, con ingresos proporcionales al uso. |
| **7** | **Auditoría y trazabilidad de accesos** | Registro inmutable de todos los eventos de seguridad relevantes: inicio de sesión, cierre, revocación, cambios de rol, creación y eliminación de usuarios. El historial es consultable por la propia organización. | Habilita el cumplimiento de requisitos de auditoría, la detección de accesos anómalos y el soporte ante incidentes. |
| **8** | **Integración con el ecosistema de aplicaciones** | Exposición de contratos estables para que las aplicaciones cliente puedan integrarse y consumir los servicios de Keygo. Incluye mecanismos de notificación ante eventos relevantes (usuario creado, acceso revocado, etc.). | Multiplica el valor de la plataforma con cada nueva aplicación integrada y reduce el costo de incorporación de nuevos equipos. |

[↑ Volver al inicio](#alcance-del-sistema)

---

### Trazabilidad entre Objetivos Estratégicos y Alcance Funcional

El siguiente mapa muestra cómo cada capacidad del alcance funcional contribuye al logro de los siete objetivos estratégicos definidos para Keygo.

| # | Capacidad | 1<br>Centralizar IAM | 2<br>Aislamiento orgs | 3<br>Estándares abiertos | 4<br>Control de acceso | 5<br>Trazabilidad | 6<br>Integración ecosistema | 7<br>Escala enterprise |
|---|-----------|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| **1** | Gestión de organizaciones           | 🟢 | 🟢 | 🟡 | 🟡 | 🟡 | 🟡 | 🟢 |
| **2** | Autenticación de usuarios           | 🟢 | 🟢 | 🟢 | 🟡 | 🟡 | 🟢 | 🟢 |
| **3** | Gestión de usuarios por organización | 🟢 | 🟢 | 🟡 | 🟢 | 🟡 | 🟡 | 🟢 |
| **4** | Control de acceso basado en roles   | 🟢 | 🟢 | 🟡 | 🟢 | 🟡 | 🟡 | 🟢 |
| **5** | Gestión de aplicaciones cliente     | 🟢 | 🟢 | 🟢 | 🟢 | 🟡 | 🟢 | 🟡 |
| **6** | Facturación por organización        | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🟡 | 🟢 |
| **7** | Auditoría y trazabilidad            | 🟢 | 🟡 | 🟡 | 🟡 | 🟢 | 🟡 | 🟢 |
| **8** | Integración con el ecosistema       | 🟢 | 🟡 | 🟢 | 🟡 | 🟡 | 🟢 | 🟢 |

> 🟢 Contribución principal — la capacidad habilita o impacta directamente el objetivo.
> 🟡 Contribución secundaria — refuerza o soporta el objetivo, pero no es su motor principal.

Cobertura: cada objetivo estratégico tiene al menos una capacidad marcada con 🟢, lo que confirma que el alcance funcional respalda todos los resultados deseados.

Priorización: las capacidades 1, 2 y 4 —gestión de organizaciones, autenticación y control de acceso— son las de mayor impacto transversal. Su ausencia bloquea la mayoría de los demás objetivos.

[↑ Volver al inicio](#alcance-del-sistema)

---

### Alcance del MVP

El **MVP** define el conjunto mínimo de capacidades necesarias para validar la propuesta de valor de Keygo con organizaciones reales y recoger aprendizaje temprano. El objetivo es entregar una plataforma funcional —aunque aún limitada— que permita cubrir el ciclo completo de identidad y acceso para una organización y sus aplicaciones, y sentar las bases sobre las que evolucionará el sistema.

En esta fase no se busca cubrir escenarios enterprise de alta complejidad, sino demostrar que un punto único de autenticación y control de acceso puede reducir la carga operativa de las organizaciones conectadas y generar confianza suficiente para justificar las siguientes iteraciones.

**Capacidades incluidas en el MVP:**

1. Registro y configuración de una organización.
2. Gestión de usuarios dentro de la organización: alta, baja, modificación y suspensión.
3. Autenticación de usuarios: inicio de sesión, cierre de sesión y renovación de credenciales.
4. Registro y configuración de aplicaciones cliente por organización.
5. Control de acceso básico por roles: asignación de roles a usuarios y verificación de permisos.
6. Facturación básica: gestión de plan y suscripción activa por organización.
7. Registro de eventos de seguridad: bitácora consultable de acciones críticas.

[↑ Volver al inicio](#alcance-del-sistema)

---

## Fuera de alcance en esta fase

- Aprovisionamiento automático de usuarios desde sistemas externos (ej. directorios corporativos, plataformas de RRHH).
- Inicio de sesión único federado entre múltiples aplicaciones del ecosistema.
- Soporte para múltiples monedas en facturación.
- Gestión de claves criptográficas mediante servicios externos especializados.
- Federación de identidad con proveedores externos (ej. inicio de sesión con cuentas de terceros).
- Analítica avanzada de comportamiento de acceso.
- Corrección o administración de datos personales más allá de lo necesario para la gestión de identidad.
- Módulos de administración de campus, aulas o estructuras organizativas internas de cada tenant.

[↑ Volver al inicio](#alcance-del-sistema)

---

## Otras consideraciones

### Límites operativos iniciales

| Concepto | Límite | Notas |
|----------|--------|-------|
| Usuarios activos por organización (MVP) | **X** usuarios | Placeholder; se definirá según validación comercial. |
| Aplicaciones cliente por organización | **Y** aplicaciones | Límite inicial para controlar la superficie de integración. |
| Retención del historial de eventos | **Z** meses | Se alineará con políticas de protección de datos aplicables. |
| Disponibilidad del servicio | **W** % | Se formalizará en el SLA de producción. |

[↑ Volver al inicio](#alcance-del-sistema)

---

### Dependencias y supuestos

- Las organizaciones que se integren dispondrán de equipos técnicos capaces de consumir contratos de integración estándar de la industria.
- Las aplicaciones cliente que deseen integrarse con Keygo deberán registrarse formalmente y operar bajo las condiciones de uso de la plataforma.
- Keygo no es responsable de la política interna de cada organización sobre qué usuarios tienen qué roles —esa decisión la toma el administrador de la organización.
- La pasarela de pagos que soporte la facturación deberá ser compatible con los mercados objetivo de Keygo.

[↑ Volver al inicio](#alcance-del-sistema)

---

## Comentarios de los Revisores

A continuación se presentan los comentarios de los revisores sobre el alcance del sistema.

| Revisor | Tipo | Contenido |
| ------- | ---- | --------- |
| — | — | Pendiente de revisión |

[↑ Volver al inicio](#alcance-del-sistema)

---

[← Índice](./README.md) | [< Anterior](./system-vision.md) | [Siguiente >](./actors.md)
