[← HOME](../README.md)

---

# Requerimientos del Sistema

Esta sección especifica **qué debe hacer Keygo** y **cómo debe comportarse**, sin prescribir implementación. Cada requerimiento es trazable a una necesidad del Discovery y a un objetivo estratégico del sistema.

## Contenido

- [Documentos de soporte](#documentos-de-soporte)
- [Requerimientos funcionales](#requerimientos-funcionales)
- [Requerimientos no funcionales](#requerimientos-no-funcionales)

---

## Documentos de soporte

| Documento | Descripción |
|-----------|-------------|
| [Glosario](glossary.md) | Términos del dominio de identidad y acceso usados en este catálogo. |
| [Matriz de priorización](priority-matrix.md) | Clasificación MoSCoW de todos los RF y RNF. |
| [Límites de alcance](scope-boundaries.md) | Qué está dentro del MVP, qué queda fuera y qué pertenece a fases futuras. |
| [Trazabilidad](traceability.md) | Relación entre RF/RNF, necesidades del Discovery y objetivos estratégicos. |
| [Restricciones técnicas y funcionales](technical-constraints.md) | Restricciones no-negociables: T1-T6 (técnicas), F1-F3 (funcionales), compliance. |

[↑ Volver al inicio](#requerimientos-del-sistema)

---

## Requerimientos funcionales

### Dominio: Organización

| # | Requerimiento |
|---|---------------|
| [RF01](functional/rf01-gestion-organizaciones.md) | **Gestión de organizaciones** — Registro, activación, suspensión y eliminación de organizaciones en la plataforma. |
| [RF02](functional/rf02-configuracion-organizacion.md) | **Configuración de la organización** — Parámetros operativos y políticas propias de cada organización. |

### Dominio: Identidad

| # | Requerimiento |
|---|---------------|
| [RF03](functional/rf03-gestion-usuarios.md) | **Gestión de usuarios** — Ciclo de vida completo de usuarios dentro de una organización. |
| [RF04](functional/rf04-autenticacion-usuarios.md) | **Autenticación de usuarios** — Verificación de identidad y creación de sesión. |
| [RF05](functional/rf05-gestion-credenciales.md) | **Gestión de credenciales** — Cambio, recuperación y políticas de contraseñas. |

### Dominio: Aplicaciones cliente

| # | Requerimiento |
|---|---------------|
| [RF06](functional/rf06-registro-aplicaciones-cliente.md) | **Registro de aplicaciones cliente** — Alta y gestión de credenciales de aplicaciones dentro de una organización. |
| [RF07](functional/rf07-configuracion-aplicaciones-cliente.md) | **Configuración de aplicaciones cliente** — Ámbitos de acceso y modalidades de integración. |

### Dominio: Acceso a aplicaciones

| # | Requerimiento |
|---|---------------|
| [RF08](functional/rf08-acceso-usuarios-aplicaciones.md) | **Acceso de usuarios a aplicaciones** — Asignación y revocación de acceso de usuarios a aplicaciones cliente. |
| [RF09](functional/rf09-roles-por-aplicacion.md) | **Roles por aplicación** — Definición y asignación de roles dentro del contexto de cada aplicación. |

### Dominio: Autorización

| # | Requerimiento |
|---|---------------|
| [RF10](functional/rf10-control-acceso-roles.md) | **Control de acceso basado en roles** — Evaluación y aplicación de permisos en cada operación. |

### Dominio: Sesiones

| # | Requerimiento |
|---|---------------|
| [RF11](functional/rf11-emision-credenciales-sesion.md) | **Emisión de credenciales de sesión** — Generación de credenciales verificables para sesiones activas. |
| [RF12](functional/rf12-verificacion-credenciales-sesion.md) | **Verificación de credenciales de sesión** — Validación de credenciales emitidas en cada operación. |
| [RF13](functional/rf13-verificacion-publica-credenciales.md) | **Verificación pública de credenciales** — Mecanismo para que aplicaciones verifiquen credenciales de forma autónoma. |
| [RF14](functional/rf14-gestion-sesiones.md) | **Gestión de sesiones** — Ciclo de vida, expiración y revocación de sesiones activas. |

### Dominio: Facturación

| # | Requerimiento |
|---|---------------|
| [RF15](functional/rf15-gestion-suscripciones.md) | **Gestión de suscripciones** — Planes y estado de suscripción por organización. |
| [RF16](functional/rf16-medicion-uso.md) | **Medición de uso** — Registro y aplicación de límites según plan activo. |
| [RF17](functional/rf17-integracion-proveedores-pago.md) | **Integración con proveedores de pago** — Gestión de pagos a través de servicios externos _(fase futura)_. |
| [RF22](functional/rf22-planes-por-aplicacion.md) | **Planes comerciales por aplicación cliente** — Catálogo de planes que una app puede ofrecer a sus usuarios. |
| [RF23](functional/rf23-suscripciones-usuarios-app.md) | **Suscripciones de usuarios a planes de aplicación** — Contratación de plan por usuario final de una app; ciclo de vida de la suscripción. |
| [RF24](functional/rf24-evaluacion-derechos-membresia.md) | **Evaluación de derechos de membresía** — Resolución y aplicación de los derechos del plan activo en el flujo de acceso. |

### Dominio: Auditoría

| # | Requerimiento |
|---|---------------|
| [RF18](functional/rf18-registro-eventos.md) | **Registro de eventos** — Persistencia inmutable de eventos relevantes de seguridad. |
| [RF19](functional/rf19-trazabilidad-acciones.md) | **Trazabilidad de acciones** — Historial consultable de acciones por actor y organización. |

### Dominio: Plataforma

| # | Requerimiento |
|---|---------------|
| [RF20](functional/rf20-administracion-global-plataforma.md) | **Administración global de la plataforma** — Gestión de organizaciones a nivel de plataforma. |
| [RF21](functional/rf21-operacion-plataforma.md) | **Operación de la plataforma** — Herramientas de soporte y monitoreo global para el equipo operativo. |

[↑ Volver al inicio](#requerimientos-del-sistema)

---

## Requerimientos no funcionales

| # | Requerimiento |
|---|---------------|
| [RNF01](non-functional/rnf01-seguridad.md) | **Seguridad** — Protección de credenciales, datos sensibles y prevención de vulnerabilidades. |
| [RNF02](non-functional/rnf02-aislamiento-organizaciones.md) | **Aislamiento entre organizaciones** — Garantía de separación total entre los datos de cada organización. |
| [RNF03](non-functional/rnf03-privacidad-datos.md) | **Privacidad de datos** — Protección de datos personales y cumplimiento de normativas aplicables. |
| [RNF04](non-functional/rnf04-disponibilidad-resiliencia.md) | **Disponibilidad y resiliencia** — Alta disponibilidad y tolerancia a fallos parciales. |
| [RNF05](non-functional/rnf05-rendimiento.md) | **Rendimiento** — Tiempos de respuesta aceptables bajo condiciones de uso normal y bajo carga. |
| [RNF06](non-functional/rnf06-escalabilidad.md) | **Escalabilidad** — Capacidad de crecer en organizaciones, usuarios y carga sin rediseño del núcleo. |
| [RNF07](non-functional/rnf07-mantenibilidad.md) | **Mantenibilidad** — Arquitectura que permita evolución sin impacto en componentes no modificados. |
| [RNF08](non-functional/rnf08-observabilidad.md) | **Observabilidad** — Visibilidad del estado interno del sistema en tiempo real. |
| [RNF09](non-functional/rnf09-usabilidad.md) | **Usabilidad** — Experiencia clara y eficiente para cada actor del sistema. |
| [RNF10](non-functional/rnf10-compatibilidad-estandares.md) | **Compatibilidad con estándares abiertos** — Interoperabilidad con el ecosistema de herramientas de identidad. |
| [RNF11](non-functional/rnf11-cumplimiento-gobernanza.md) | **Cumplimiento y gobernanza** — Facilitar auditorías y cumplimiento normativo. |
| [RNF12](non-functional/rnf12-ciclo-vida-claves.md) | **Gestión del ciclo de vida de claves criptográficas** — Rotación y gestión segura de las claves del sistema. |
| [RNF13](non-functional/rnf13-consistencia-credenciales.md) | **Consistencia de credenciales de sesión** — Manejo correcto de expiración y sincronización de estado. |
| [RNF14](non-functional/rnf14-latencia-autenticacion.md) | **Latencia de autenticación** — Definición de niveles de servicio aceptables para los flujos de autenticación. |

[↑ Volver al inicio](#requerimientos-del-sistema)

---

[← HOME](../README.md)
