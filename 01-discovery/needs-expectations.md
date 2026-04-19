[← Índice](./README.md) | [< Anterior](./actors.md) | [Siguiente >](./next-steps.md)

---

# Definición de Necesidades y Expectativas del Sistema

## Contenido

- [Necesidades funcionales clave](#necesidades-funcionales-clave)
- [Expectativas operativas y de largo plazo](#expectativas-operativas-y-de-largo-plazo)
  - [Cómo usar esta tabla](#cómo-usar-esta-tabla)
- [Supuestos y dependencias](#supuestos-y-dependencias)
- [Riesgos y mitigaciones](#riesgos-y-mitigaciones)
- [Criterios de aceptación de alto nivel](#criterios-de-aceptación-de-alto-nivel)
- [Comentarios de los Revisores](#comentarios-de-los-revisores)

---

## Necesidades funcionales clave

La siguiente matriz identifica **qué debe hacer Keygo para cumplir su propuesta de valor** y a qué objetivos estratégicos contribuye cada necesidad. Sirve como puente entre la visión de alto nivel y el backlog de desarrollo: toda funcionalidad que ingrese al producto debe mapearse a una fila de esta tabla, garantizando foco y evitando _scope creep_.

| Nº | Necesidad | Descripción resumida | Objetivos estratégicos relacionados |
|----|-----------|----------------------|-------------------------------------|
| N1 | **Centralización de la identidad y el acceso** | Keygo deberá ser el único punto donde se resuelve quién es el usuario, qué puede hacer y en qué organización opera, eliminando la necesidad de que cada aplicación gestione esas responsabilidades de forma independiente. | 1, 2 |
| N2 | **Aislamiento completo entre organizaciones** | Ninguna organización deberá poder ver ni afectar los usuarios, roles, sesiones ni datos de otra. Este aislamiento deberá ser una restricción de diseño, verificable en cada operación, no una configuración opcional. | 2 |
| N3 | **Gestión del ciclo de vida de usuarios por organización** | Los administradores de organización deberán poder crear, modificar, suspender y eliminar usuarios de su directorio de forma autónoma, sin depender del equipo operativo de Keygo. | 1, 3, 7 |
| N4 | **Control de acceso configurable por organización** | Cada organización deberá poder definir sus propios roles y asignarlos a usuarios y aplicaciones. El sistema deberá verificar automáticamente los permisos en cada operación, sin delegar esa responsabilidad en las aplicaciones cliente. | 4 |
| N5 | **Autenticación confiable con trazabilidad** | El sistema deberá gestionar el ciclo completo de inicio de sesión, renovación de credenciales, cierre de sesión y revocación de acceso, dejando registro de cada evento relevante. | 1, 5 |
| N6 | **Registro y gestión de aplicaciones cliente** | Cada organización deberá poder registrar las aplicaciones que tendrán acceso a sus usuarios, definir su ámbito de acceso y revocar ese acceso cuando corresponda, sin intervención del equipo operativo de Keygo. | 1, 6 |
| N7 | **Facturación autónoma por organización** | Cada organización deberá poder gestionar su plan, su suscripción y su ciclo de facturación de forma independiente. La plataforma deberá soportar diferentes planes con distintos límites de uso. | 7 |
| N8 | **Auditoría de eventos de seguridad** | Todos los eventos relevantes —inicio de sesión, cierre de sesión, revocación de acceso, cambios de rol, altas y bajas de usuarios— deberán quedar registrados de forma inmutable y ser consultables de forma autónoma por cada organización. | 5 |
| N9 | **Integración sin fricción con el ecosistema** | Las aplicaciones cliente deberán poder integrarse con Keygo apoyándose en contratos estables y estándares ampliamente adoptados en la industria, sin necesidad de desarrollar adaptadores propietarios ni conocimiento especializado de la plataforma. | 3, 6 |

> _Nota_: los números de objetivos estratégicos (1–7) corresponden a los definidos en [Visión del Sistema](./system-vision.md).

[↑ Volver al inicio](#definición-de-necesidades-y-expectativas-del-sistema)

---

## Expectativas operativas y de largo plazo

Más allá de las funciones concretas, Keygo deberá regirse por **principios que aseguren sostenibilidad, seguridad y adopción a futuro**. Esta tabla resume esos principios y muestra cómo refuerzan las necesidades funcionales. Actúa como guía de diseño y gobernanza para que el sistema mantenga su integridad mientras evoluciona.

| Eje | Expectativa | Cómo se alinea con las necesidades |
|-----|-------------|------------------------------------|
| **Aislamiento por diseño** | El aislamiento entre organizaciones deberá ser verificable mediante pruebas automáticas en cada ciclo de entrega, no solo documentado como principio. | Refuerza N2 |
| **Autonomía operativa** | Los administradores de organización deberán poder operar de forma completamente autónoma: gestionar usuarios, roles, aplicaciones y suscripción sin requerir intervención del equipo operativo de Keygo. | N3, N6, N7 |
| **Contratos de integración estables** | Los contratos que Keygo expone a las aplicaciones cliente deberán ser estables y predecibles, de modo que una aplicación integrada no requiera cambios ante evoluciones internas de la plataforma. | N9 |
| **Evolutividad modular** | El sistema deberá organizarse en dominios funcionales independientes, permitiendo que cada uno evolucione sin impactar a los demás y facilitando la incorporación de nuevas capacidades sin reescritura del núcleo. | N3, N4, N9 |
| **Seguridad y trazabilidad permanentes** | Toda acción de autenticación, autorización y cambio de estado deberá quedar registrada. La integridad del registro deberá estar garantizada por diseño. | N5, N8 |
| **Protección y privacidad de datos** | Los datos de cada organización deberán almacenarse y gestionarse con las garantías necesarias para cumplir las normativas de protección de datos aplicables a los mercados objetivo. | N2, N5 |
| **Disponibilidad y rendimiento sostenidos** | La plataforma deberá estar disponible de forma continua y responder de manera que no represente un cuello de botella para las aplicaciones que dependen de ella, incluso bajo carga elevada. | N5, N9 |
| **Experiencia coherente por rol** | Cada actor del sistema —administrador de plataforma, administrador de organización, usuario final, equipo operativo— deberá disponer de una experiencia de uso adecuada a sus responsabilidades, sin exponer funcionalidades que no le corresponden. | N3, N4, N6 |

### Cómo usar esta tabla

- **Priorización**: los responsables de producto pueden revisar qué necesidad impacta más objetivos y priorizar en consecuencia.
- **Trazabilidad**: cualquier historia de usuario deberá enlazar con la necesidad correspondiente y, por extensión, con su objetivo estratégico.
- **Revisión futura**: nuevas necesidades o expectativas deberán agregarse solo si respaldan objetivos existentes o abren uno nuevo acordado por el equipo.

[↑ Volver al inicio](#definición-de-necesidades-y-expectativas-del-sistema)

---

## Supuestos y dependencias

Esta tabla registra los **factores externos o condicionantes** que deberán mantenerse válidos para que las necesidades y expectativas de Keygo se cumplan. Monitorearlos de forma proactiva permitirá anticipar ajustes de alcance o planes de contingencia antes de que un riesgo se materialice.

| Nº | Supuesto / Dependencia | Impacto si no se cumple | Acción de monitoreo / Plan de contingencia |
|----|------------------------|-------------------------|-------------------------------------------|
| S1 | Las organizaciones que se integren dispondrán de equipos técnicos capaces de consumir contratos de integración basados en estándares de la industria. | Integraciones retrasadas o inseguras; frena la adopción y compromete el KPI de centralización. | - Entregar documentación de integración detallada con anticipación.<br>- Ofrecer soporte técnico activo durante el proceso de incorporación. |
| S2 | Las aplicaciones cliente adoptarán los mecanismos de integración que Keygo establezca, sin exigir adaptaciones propietarias. | Proliferación de integraciones ad-hoc; aumenta la carga de mantenimiento y debilita la estabilidad de los contratos. | - Validar con aplicaciones piloto antes del lanzamiento general.<br>- Proveer entorno de pruebas y ejemplos de referencia. |
| S3 | La pasarela de pagos seleccionada soportará los modelos de suscripción previstos en los mercados objetivo de Keygo. | Retraso en la activación del modelo de ingresos; organizaciones no pueden activar su suscripción. | - Verificar compatibilidad legal y comercial antes del diseño del módulo de facturación.<br>- Contemplar alternativas de pasarela desde el inicio. |
| S4 | La infraestructura de despliegue permitirá escalar la capacidad según la demanda, garantizando disponibilidad continua. | Caídas o degradación del servicio en momentos de alta carga; impacto directo en la confianza de las organizaciones conectadas. | - Definir requisitos de escalabilidad antes de seleccionar proveedor de infraestructura.<br>- Realizar pruebas de carga previas a cada entrega significativa. |
| S5 | Las normativas de protección de datos aplicables a los mercados objetivo de Keygo no sufrirán cambios disruptivos durante el desarrollo del núcleo. | Re-diseño de componentes críticos con impacto en plazos y costos. | - Seguimiento legal periódico.<br>- Diseñar con principios de privacidad desde el inicio para facilitar adaptaciones futuras. |
| S6 | Habrá disponibilidad de al menos una organización piloto para validar el ciclo completo de uso antes del lanzamiento general. | Riesgo de lanzar con supuestos no validados; mayor probabilidad de retrabajo tras el primer uso real. | - Establecer acuerdo con organización piloto desde etapas tempranas.<br>- Definir incentivos de participación claros. |

[↑ Volver al inicio](#definición-de-necesidades-y-expectativas-del-sistema)

---

## Riesgos y mitigaciones

Esta matriz identifica los **principales riesgos** que podrían impedir el logro de las necesidades y objetivos estratégicos de Keygo, junto con la estrategia de mitigación y el responsable primario. Sirve como guía de vigilancia continua y referencia durante las retrospectivas de proyecto.

| Nº | Riesgo | Necesidades / Objetivos afectados | Prob. | Impacto | Mitigación / Acción preventiva | Responsable |
|----|--------|-----------------------------------|-------|---------|--------------------------------|-------------|
| R1 | **Baja adopción por parte de administradores de organización** | N1, N3, N9 · Obj 1, 6 | Media | Alto | - Diseño de incorporación guiada con plantillas y flujos paso a paso.<br>- Validación temprana con administradores piloto.<br>- Ajuste continuo de la experiencia según retroalimentación. | Product Owner |
| R2 | **Incidente de acceso cruzado entre organizaciones** | N2 · Obj 2 | Baja | Crítico | - El aislamiento deberá ser verificable mediante pruebas automáticas en cada entrega.<br>- Revisión de diseño orientada a seguridad antes de cada ciclo de desarrollo.<br>- Trazabilidad de accesos activa desde el primer día en producción. | Tech Lead |
| R3 | **Degradación del servicio en períodos de alta demanda** | N5, N9 · Obj 1, 6 | Media | Alto | - Pruebas de carga como requisito antes de cada lanzamiento significativo.<br>- Monitoreo proactivo de indicadores de rendimiento.<br>- Plan de escalado documentado y validado. | Tech Lead |
| R4 | **Retrasos o fallos en la integración de aplicaciones cliente** | N9 · Obj 3, 6 | Media | Medio | - Contratos de integración documentados y disponibles desde etapas tempranas.<br>- Entorno de pruebas para validar integraciones antes de producción.<br>- Soporte técnico dedicado durante la incorporación de nuevas aplicaciones. | Integration PM |
| R5 | **Cambios regulatorios que afecten el manejo de datos de identidad** | N5, N8 · Obj 5 | Baja | Medio | - Revisión legal periódica alineada con mercados objetivo.<br>- Diseño con principios de privacidad que faciliten adaptaciones futuras sin reescritura del núcleo. | Legal Advisor |
| R6 | **Dificultad de los administradores para auditar eventos complejos** | N4, N8 · Obj 5 | Media | Medio | - Diseñar la bitácora de eventos con criterios de consultabilidad desde el inicio.<br>- Validar con administradores piloto que los registros son comprensibles y accionables. | Product Owner |
| R7 | **Experiencia de uso poco intuitiva para administradores no técnicos** | N3, N4, N6 · Obj 7 | Media | Alto | - Pruebas de usabilidad con administradores reales en cada iteración.<br>- Flujos diferenciados por rol, sin exponer complejidad innecesaria.<br>- Retroalimentación continua incorporada al backlog. | UX Lead |
| R8 | **Incapacidad de la facturación para adaptarse a diferentes mercados** | N7 · Obj 7 | Baja | Medio | - Verificar compatibilidad de la pasarela de pagos con los mercados objetivo antes de diseñar el módulo.<br>- Diseñar el módulo de facturación con separación de la lógica de negocio y el proveedor de cobro. | Product Owner |

[↑ Volver al inicio](#definición-de-necesidades-y-expectativas-del-sistema)

---

## Criterios de aceptación de alto nivel

Los criterios siguientes definen **cómo se demostrará** que cada necesidad funcional clave ha sido satisfecha en producción. Actúan como puente entre el discovery y los planes de validación: antes de cerrar una épica o una iteración, el equipo deberá presentar la evidencia correspondiente.

| Necesidad | Criterio(s) de aceptación — Evidencia requerida | KPI / Métrica asociada |
|-----------|-----------------------------------------------|------------------------|
| **N1** Centralización de la identidad | - Las aplicaciones piloto conectadas a Keygo no implementan lógica propia de autenticación ni gestión de sesiones.<br>- Toda autenticación del ecosistema queda registrada en Keygo. | ≥ 90 % de las aplicaciones del ecosistema autenticando vía Keygo a los 12 meses. |
| **N2** Aislamiento entre organizaciones | - Las pruebas de aislamiento son parte obligatoria del proceso de validación de cada entrega.<br>- No se registra ningún evento de acceso cruzado entre organizaciones en producción. | 0 incidentes de acceso cruzado en producción. |
| **N3** Gestión del ciclo de vida de usuarios | - Un administrador de organización puede completar el flujo completo de alta, modificación, suspensión y baja de usuarios sin intervención del equipo operativo de Keygo.<br>- El flujo puede completarse por alguien sin conocimiento técnico previo de la plataforma. | Autonomía operativa total del administrador de organización. |
| **N4** Control de acceso configurable | - Un administrador puede crear un rol, asignarlo a un usuario y verificar que el acceso resultante es el esperado, en menos de 10 minutos desde el primer uso.<br>- Toda operación del sistema tiene una política de acceso explícita que puede consultarse. | Toda operación con política de acceso documentada y verificable. |
| **N5** Autenticación confiable | - El sistema gestiona correctamente los flujos de inicio de sesión, renovación de credenciales, cierre de sesión y revocación bajo condiciones de uso normal y bajo carga.<br>- Cada evento de autenticación queda registrado en la bitácora. | Disponibilidad del servicio de autenticación ≥ 99,9 % en producción. |
| **N6** Gestión de aplicaciones cliente | - Un administrador puede registrar una aplicación, definir su ámbito de acceso y revocar ese acceso sin intervención del equipo operativo.<br>- La aplicación registrada solo puede operar dentro del ámbito definido. | Tiempo de registro de una nueva aplicación cliente ≤ 1 día. |
| **N7** Facturación autónoma | - Cada organización puede activar, cambiar y cancelar su suscripción de forma autónoma.<br>- Los límites del plan activo se aplican automáticamente sin intervención manual. | Gestión de suscripción completamente autónoma por organización. |
| **N8** Auditoría de eventos | - Toda acción de autenticación, cierre de sesión, revocación, cambio de rol y gestión de usuarios queda registrada.<br>- El historial es consultable de forma autónoma por el administrador de la organización sin acceso al equipo operativo de Keygo. | 100 % de eventos de seguridad relevantes registrados y consultables. |
| **N9** Integración sin fricción | - Una aplicación cliente puede completar la integración con Keygo en ≤ 1 día de desarrollo apoyándose en la documentación disponible.<br>- La integración es funcional sin modificaciones adicionales en herramientas estándar de la industria. | Tiempo de integración de una nueva aplicación cliente ≤ 1 día. |

> _Nota_: estos criterios son de alto nivel. Cada historia de usuario deberá detallar casos de prueba específicos y condiciones límite concretas (por ejemplo, comportamiento ante sesiones expiradas, intentos de acceso cruzado, cambios de plan con usuarios activos).

[↑ Volver al inicio](#definición-de-necesidades-y-expectativas-del-sistema)

---

## Comentarios de los Revisores

A continuación se presentan los comentarios de los revisores sobre las necesidades y expectativas del sistema.

| Revisor | Tipo | Contenido |
| ------- | ---- | --------- |
| — | — | Pendiente de revisión |

[↑ Volver al inicio](#definición-de-necesidades-y-expectativas-del-sistema)

---

[← Índice](./README.md) | [< Anterior](./actors.md) | [Siguiente >](./next-steps.md)
