[← Índice](./README.md) | [< Anterior](./final-reflection.md)

---

# Análisis de la Fase de Discovery de Keygo

> En la fase **Discovery** del proyecto Keygo, el equipo mantuvo discusiones internas para alinear la visión y definir **qué debe lograr la plataforma**. A continuación se analizan los temas clave que emergieron durante esta etapa, mostrando cómo cada deliberación interna llevó a decisiones concretas sobre el alcance, los actores, las necesidades y los objetivos estratégicos finalmente aprobados. El objetivo es evidenciar que cada elemento del Discovery no es arbitrario, sino que responde a una razón debatida y acordada por el equipo.

---

## Contenido

- [Centralización de la identidad como principio rector](#centralización-de-la-identidad-como-principio-rector)
- [Aislamiento entre organizaciones como restricción no negociable](#aislamiento-entre-organizaciones-como-restricción-no-negociable)
- [Actores y gobernanza: delimitación de roles y responsabilidades](#actores-y-gobernanza-delimitación-de-roles-y-responsabilidades)
- [Autonomía operativa de las organizaciones](#autonomía-operativa-de-las-organizaciones)
- [Ciclo completo de autenticación y control de acceso](#ciclo-completo-de-autenticación-y-control-de-acceso)
- [Integración con el ecosistema de aplicaciones](#integración-con-el-ecosistema-de-aplicaciones)
- [Facturación por organización como habilitador de sostenibilidad](#facturación-por-organización-como-habilitador-de-sostenibilidad)
- [Trazabilidad y auditoría como requisitos de confianza](#trazabilidad-y-auditoría-como-requisitos-de-confianza)
- [Delimitación del MVP y evolución futura](#delimitación-del-mvp-y-evolución-futura)
- [Conclusión](#conclusión)
- [Comentarios de los Revisores](#comentarios-de-los-revisores)

---

## Centralización de la identidad como principio rector

Uno de los acuerdos más tempranos y fundamentales del equipo fue reconocer que la **gestión fragmentada de identidad** era el problema central a resolver. En ecosistemas donde múltiples aplicaciones coexisten, cada una tiende a implementar sus propios mecanismos de autenticación, definir sus propios permisos y mantener su propio almacén de usuarios. El resultado — credenciales duplicadas, políticas de acceso divergentes, trazabilidad inexistente — fue identificado como un riesgo que escala con el crecimiento del ecosistema.

Esta constatación llevó al equipo a acordar que Keygo debía ser **la única fuente de verdad para autenticación y autorización**, eliminando la necesidad de que cada aplicación cliente resuelva esas responsabilidades de forma independiente. El principio rector quedó expresado en la visión: _"ser la plataforma de referencia de identidad y acceso para ecosistemas SaaS multi-tenant"_. No es una característica opcional — es la razón de ser de la plataforma.

Este acuerdo fundamentó directamente el primer objetivo estratégico (_centralizar la gestión de identidad y acceso_) y la necesidad funcional N1, y condicionó todas las demás decisiones del Discovery: cualquier capacidad que no contribuyera a la centralización o que la duplicara quedaba fuera del alcance.

[↑ Volver al inicio](#análisis-de-la-fase-de-discovery-de-keygo)

---

## Aislamiento entre organizaciones como restricción no negociable

La segunda gran deliberación del equipo fue definir si el aislamiento entre organizaciones sería una _característica configurable_ o una _restricción de diseño_. La conclusión fue inequívoca: el aislamiento debía ser una restricción estructural, verificable en cada operación, no un parámetro que el operador pueda habilitar o deshabilitar.

El razonamiento fue que una filtración de datos entre organizaciones no es un incidente de baja severidad — invalida la propuesta de valor completa de la plataforma y genera responsabilidad legal. Por tanto, el equipo acordó que el diseño del sistema debía hacer _imposible_ el acceso cruzado entre organizaciones, no solo improbable. Esta posición quedó reflejada en el segundo objetivo estratégico con su KPI más estricto de todos: _0 incidentes de acceso cruzado en producción_, y en la necesidad funcional N2.

Esta decisión tuvo consecuencias prácticas sobre cómo se definieron los demás elementos del Discovery: cada capacidad funcional, cada actor y cada criterio de aceptación fue revisado bajo la pregunta _"¿garantiza o amenaza el aislamiento?"_. La verificación del aislamiento quedó establecida como requisito obligatorio del proceso de validación de cada entrega, no como una prueba opcional.

[↑ Volver al inicio](#análisis-de-la-fase-de-discovery-de-keygo)

---

## Actores y gobernanza: delimitación de roles y responsabilidades

Una parte significativa del Discovery se dedicó a responder: _¿quién interactúa con la plataforma y hasta dónde llega su ámbito de acción?_ Este debate fue necesario porque en plataformas multi-tenant existe tensión entre el control global (necesario para operar la plataforma) y la autonomía de cada organización (necesaria para que el modelo de negocio funcione).

El equipo identificó cinco actores. La decisión más debatida fue la separación entre el **administrador de la plataforma** y el **administrador de organización**: el primero tiene visibilidad global sobre la existencia de las organizaciones y sus suscripciones, pero no puede acceder a sus usuarios ni datos internos; el segundo tiene control total sobre su propio espacio, pero no puede cruzar los límites hacia otras organizaciones. Esta separación no es solo conceptual — condiciona cómo se diseñarán los permisos, los contratos de integración y la propia estructura de datos del sistema.

También se deliberó sobre qué actores excluir explícitamente en esta fase. El equipo acordó que los sistemas de directorio corporativo externo, los proveedores de identidad externos y los usuarios anónimos quedaban fuera del alcance del MVP. Esta exclusión no fue descuido sino decisión consciente: incorporar esos actores en la primera fase habría ampliado considerablemente la complejidad sin aportar valor proporcional a la validación inicial.

[↑ Volver al inicio](#análisis-de-la-fase-de-discovery-de-keygo)

---

## Autonomía operativa de las organizaciones

Un tema transversal en las discusiones fue la pregunta: _¿cuánto debe depender una organización del equipo operativo de Keygo para operar?_ La respuesta que el equipo acordó fue: lo menos posible. La propuesta de valor de Keygo se debilita si cada alta de usuario, cada cambio de rol o cada registro de aplicación requiere intervención del equipo de la plataforma.

Este principio se tradujo en un conjunto coherente de decisiones. Las capacidades del MVP se diseñaron para que el administrador de organización pueda gestionar de forma autónoma su directorio de usuarios, sus roles, sus aplicaciones cliente y su suscripción. La necesidad N3 (_gestión del ciclo de vida de usuarios_), la N4 (_control de acceso configurable_), la N6 (_registro de aplicaciones cliente_) y la N7 (_facturación autónoma_) son todas expresiones de este principio.

La autonomía también aparece como expectativa operativa explícita: se acordó que _un administrador que no ha usado la plataforma antes debe poder completar el flujo completo sin requerir asistencia técnica_. Este criterio orientará las decisiones de diseño de interfaz y de experiencia de usuario en fases posteriores.

[↑ Volver al inicio](#análisis-de-la-fase-de-discovery-de-keygo)

---

## Ciclo completo de autenticación y control de acceso

El equipo debatió hasta dónde debía llegar Keygo en materia de autenticación y control de acceso. Una postura era limitar la plataforma a la validación de credenciales (quién es el usuario); otra era extenderla al control granular de permisos (qué puede hacer). El equipo optó por la segunda: Keygo debía resolver ambas preguntas, porque separarlas obligaría a las aplicaciones cliente a implementar su propia lógica de permisos, recreando exactamente el problema que Keygo busca eliminar.

Esta decisión fundamentó las capacidades 2 (_autenticación de usuarios_) y 4 (_control de acceso basado en roles_) del alcance funcional, así como las necesidades N5 y N4. También estableció un principio que condiciona el diseño: la verificación de permisos debe ocurrir dentro de Keygo, no delegarse a las aplicaciones cliente. Las aplicaciones cliente no deben necesitar conocer la estructura interna de roles para operar correctamente — esa lógica reside en la plataforma.

El ciclo también incluyó los extremos del flujo de sesión: no solo el inicio de sesión, sino la renovación de credenciales, el cierre de sesión y la revocación de acceso. Gestionar solo el inicio sin gestionar el cierre habría dejado un flanco abierto en términos de seguridad.

[↑ Volver al inicio](#análisis-de-la-fase-de-discovery-de-keygo)

---

## Integración con el ecosistema de aplicaciones

La discusión sobre integración giró alrededor de una tensión: Keygo necesita ser adoptado por aplicaciones cliente para generar valor, pero si la integración es compleja, la adopción será lenta. El equipo acordó que la integración debía basarse en **estándares ampliamente adoptados en la industria**, de modo que cualquier aplicación que ya conozca esos estándares pueda conectarse sin desarrollar adaptadores propietarios.

Este principio se convirtió en el tercer objetivo estratégico y en la necesidad funcional N9. El criterio de aceptación de alto nivel asociado es claro: una aplicación cliente debe poder completar la integración en no más de un día de desarrollo. Si ese umbral no se alcanza, la plataforma habrá fallado en uno de sus compromisos fundamentales.

El equipo también acordó que Keygo debía notificar a las aplicaciones cliente los eventos relevantes del ciclo de identidad — usuario creado, acceso revocado, cambio de rol — para que no tuvieran que consultar el estado periódicamente. Este mecanismo de notificación quedó incluido en la capacidad 8 (_integración con el ecosistema_) como parte esencial del contrato de integración, no como característica adicional.

[↑ Volver al inicio](#análisis-de-la-fase-de-discovery-de-keygo)

---

## Facturación por organización como habilitador de sostenibilidad

La decisión de incluir la facturación en el alcance del MVP generó debate en el equipo. Una postura señalaba que la facturación podría postergarse a una fase posterior, dejando el MVP enfocado exclusivamente en las capacidades de identidad. La postura que prevaleció fue que la facturación era condición para que Keygo existiera como producto sostenible: sin un mecanismo de cobro operativo, la plataforma podría validar la propuesta de valor técnica pero no el modelo de negocio.

El equipo acordó incluir una facturación básica en el MVP — gestión de plan y suscripción activa por organización — y postergar escenarios de mayor complejidad como el soporte de múltiples monedas o la integración con múltiples pasarelas de pago. Este equilibrio quedó reflejado en la capacidad 6 del alcance funcional y en la necesidad N7.

La facturación también condicionó la definición de _límites operativos_: los planes de suscripción determinarán cuántos usuarios, aplicaciones o eventos de auditoría puede gestionar cada organización. Esta relación entre facturación y límites operativos quedó reconocida en el alcance pero pendiente de valores concretos, sujetos a validación comercial.

[↑ Volver al inicio](#análisis-de-la-fase-de-discovery-de-keygo)

---

## Trazabilidad y auditoría como requisitos de confianza

El equipo debatió si la auditoría de eventos era una capacidad "nice to have" o un requisito fundamental del MVP. La conclusión fue que la trazabilidad no es opcional: es lo que permite a una organización demostrar que sus accesos han sido gestionados correctamente, detectar comportamientos anómalos y responder ante incidentes.

Este debate llevó a dos decisiones concretas. La primera: el registro de eventos debía ser _inmutable_ — no solo almacenado, sino protegido contra modificación retroactiva. La segunda: el historial debía ser _consultable de forma autónoma por la propia organización_, sin depender del equipo operativo de Keygo. Ambas condiciones quedaron reflejadas en la necesidad N8 y en su criterio de aceptación: el 100 % de los eventos de seguridad relevantes deben quedar registrados y ser consultables de forma autónoma.

También se acotó qué eventos debían registrarse: inicio de sesión, cierre de sesión, revocación de acceso, cambios de rol, altas y bajas de usuarios. Esta lista no es exhaustiva — se irá ampliando en fases posteriores — pero cubre los eventos de mayor impacto en la seguridad y el cumplimiento normativo.

[↑ Volver al inicio](#análisis-de-la-fase-de-discovery-de-keygo)

---

## Delimitación del MVP y evolución futura

Una parte significativa del Discovery se dedicó a acordar qué _no_ entraría en el MVP. Este ejercicio fue tan importante como definir lo que sí entraría, porque sin límites claros la primera entrega no sería viable.

El equipo evaluó cada capacidad potencial contra dos criterios: _¿es necesaria para validar la propuesta de valor central?_ y _¿su ausencia impide usar las demás capacidades?_ Las capacidades que no superaban ambos criterios quedaron explícitamente fuera del alcance en esta fase. El resultado fue una lista clara de exclusiones: aprovisionamiento automático de usuarios desde sistemas externos, inicio de sesión único federado entre múltiples aplicaciones, soporte de múltiples monedas, federación de identidad con proveedores externos y analítica avanzada de comportamiento de acceso.

Estas exclusiones no son definitivas — forman parte de la proyección de evolución del sistema hacia casos de uso enterprise, reconocida en el séptimo objetivo estratégico. El equipo acordó que el diseño del núcleo debía _permitir_ incorporar esas capacidades en iteraciones futuras sin reescritura, aunque no las incluyera en la primera entrega. Este principio de diseño para la extensión — sin sobrediseñar para escenarios hipotéticos — quedó como orientación para las fases de arquitectura e implementación.

[↑ Volver al inicio](#análisis-de-la-fase-de-discovery-de-keygo)

---

## Conclusión

Las decisiones capturadas en los documentos de Discovery de Keygo no son convenciones arbitrarias: son el resultado de deliberaciones en las que el equipo evaluó alternativas, identificó tensiones y eligió con criterio. La centralización como principio rector, el aislamiento como restricción no negociable, la autonomía operativa de las organizaciones, la integración basada en estándares abiertos y la trazabilidad como condición de confianza — cada uno de estos ejes responde a una pregunta concreta que el equipo se hizo y respondió en esta fase.

El Discovery cumple su propósito cuando las fases siguientes pueden tomar decisiones de diseño, arquitectura e implementación _sin necesidad de volver a debatir el qué_. Ese es el estándar con el que debe evaluarse este material: si quien aborda la fase de Requisitos encuentra en estos documentos una base clara, sin ambigüedades irresolubles y sin compromisos contradictorios, el Discovery habrá hecho bien su trabajo.

[↑ Volver al inicio](#análisis-de-la-fase-de-discovery-de-keygo)

---

## Comentarios de los Revisores

A continuación se presentan los comentarios de los revisores sobre el análisis del Discovery.

| Revisor | Tipo | Contenido |
| ------- | ---- | --------- |
| — | — | Pendiente de revisión |

[↑ Volver al inicio](#análisis-de-la-fase-de-discovery-de-keygo)

---

[← Índice](./README.md) | [< Anterior](./final-reflection.md)
