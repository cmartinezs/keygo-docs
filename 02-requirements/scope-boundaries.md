[← Índice](./README.md)

---

# Límites de Alcance

Define qué está incluido en el MVP de Keygo, qué queda explícitamente fuera de esta fase y qué pertenece a iteraciones futuras.

## Contenido

- [Alcance del MVP](#alcance-del-mvp)
- [Fuera del alcance en esta fase](#fuera-del-alcance-en-esta-fase)
- [Fases futuras](#fases-futuras)
- [Comentarios de los Revisores](#comentarios-de-los-revisores)

---

## Alcance del MVP

El MVP cubre el ciclo completo de identidad y acceso para una organización y sus aplicaciones cliente. El objetivo es validar la propuesta de valor central con organizaciones reales antes de incorporar capacidades avanzadas.

| RF / RNF | Incluido en MVP | Notas |
|----------|-----------------|-------|
| RF01 — Gestión de organizaciones | ✅ | Núcleo de la plataforma |
| RF02 — Configuración de la organización | ✅ Parcial | Parámetros básicos; branding opcional fuera |
| RF03 — Gestión de usuarios | ✅ | Alta, baja, modificación, suspensión |
| RF04 — Autenticación de usuarios | ✅ | Flujo completo de inicio de sesión |
| RF05 — Gestión de credenciales | ✅ | Cambio y recuperación de contraseña |
| RF06 — Registro de aplicaciones cliente | ✅ | Registro y generación de credenciales |
| RF07 — Configuración de aplicaciones cliente | ✅ Parcial | Ámbitos básicos; modalidades avanzadas fuera |
| RF08 — Acceso de usuarios a aplicaciones | ✅ | Asignación y revocación de acceso |
| RF09 — Roles por aplicación | ✅ Parcial | Definición y asignación básica; jerarquía opcional |
| RF10 — Control de acceso basado en roles | ✅ | Evaluación de permisos en cada operación |
| RF11 — Emisión de credenciales de sesión | ✅ | Emisión y renovación |
| RF12 — Verificación de credenciales de sesión | ✅ | Validación por aplicaciones cliente |
| RF13 — Verificación pública de credenciales | ✅ | Mecanismo de verificación autónoma |
| RF14 — Gestión de sesiones | ✅ | Ciclo de vida, expiración, revocación |
| RF15 — Gestión de suscripciones | ✅ | Plan activo y estado de suscripción |
| RF16 — Medición de uso | ✅ Parcial | Límites básicos por plan; analítica avanzada fuera |
| RF17 — Integración con proveedores de pago | ❌ | Fase futura |
| RF18 — Registro de eventos | ✅ | Bitácora inmutable de eventos críticos |
| RF19 — Trazabilidad de acciones | ✅ Parcial | Consulta básica; exportación avanzada fuera |
| RF20 — Administración global de la plataforma | ✅ | Registro y suspensión de organizaciones |
| RF21 — Operación de la plataforma | ✅ Parcial | Herramientas básicas de diagnóstico |
| RNF01 — Seguridad | ✅ | Requisito no negociable desde el primer día |
| RNF02 — Aislamiento entre organizaciones | ✅ | Restricción de diseño verificada en cada entrega |
| RNF03 — Privacidad de datos | ✅ | Aplicable desde el inicio |
| RNF04 — Disponibilidad y resiliencia | ✅ | Definición de SLA base |
| RNF05 — Rendimiento | ✅ | Umbrales básicos de latencia |
| RNF06 — Escalabilidad | ✅ Parcial | Diseño para escala; capacidad enterprise en fases futuras |
| RNF07 — Mantenibilidad | ✅ | Requisito de arquitectura desde el inicio |
| RNF08 — Observabilidad | ✅ Parcial | Métricas y logs básicos; dashboards avanzados fuera |
| RNF09 — Usabilidad | ✅ | Criterio de aceptación de cada entrega |
| RNF10 — Compatibilidad con estándares abiertos | ✅ | Base de integración desde el MVP |
| RNF11 — Cumplimiento y gobernanza | ✅ Parcial | Auditoría básica; compliance avanzado en fases futuras |
| RNF12 — Gestión del ciclo de vida de claves | ✅ | Rotación básica incluida |
| RNF13 — Consistencia de credenciales de sesión | ✅ | Manejo correcto de expiración |
| RNF14 — Latencia de autenticación | ✅ | SLA definido y medido |

[↑ Volver al inicio](#límites-de-alcance)

---

## Fuera del alcance en esta fase

Los siguientes elementos no forman parte del MVP. Su ausencia no impide validar la propuesta de valor central de Keygo.

| Elemento | Justificación |
|----------|---------------|
| Aprovisionamiento automático de usuarios desde sistemas externos | Requiere contratos de integración con directorios corporativos no contemplados en esta fase. La gestión es manual por el administrador de organización. |
| Inicio de sesión único federado entre múltiples aplicaciones del ecosistema | Capacidad enterprise que depende de una base validada de integraciones. Se incorporará en iteraciones futuras. |
| Integración con proveedores de identidad externos | El inicio de sesión mediante cuentas de terceros queda fuera del MVP. Toda autenticación se gestiona con credenciales propias de Keygo. |
| Soporte de múltiples monedas en facturación | La integración con proveedores de pago y el soporte multi-moneda pertenecen a una fase posterior al MVP. |
| Analítica avanzada de comportamiento de acceso | Los reportes de uso avanzados y el análisis de patrones de acceso pertenecen a iteraciones posteriores. |
| Branding configurable por organización | La personalización visual de la experiencia de autenticación es opcional y se postergará hasta validar el núcleo funcional. |
| Jerarquía avanzada de roles con herencia | La jerarquía básica cubre el MVP; la herencia de roles entre niveles es una capacidad enterprise para fases futuras. |
| Exportación avanzada del historial de auditoría | El historial es consultable en el MVP; la exportación en formatos especializados o la integración con plataformas externas de auditoría son fases futuras. |
| Integración con sistemas de auditoría o SIEM externos | No contemplada en esta fase. Keygo gestiona su propio registro de eventos. |
| Usuarios anónimos | Keygo no gestiona flujos sin autenticación. Toda interacción requiere identidad verificada. |

[↑ Volver al inicio](#límites-de-alcance)

---

## Fases futuras

Los siguientes requerimientos están identificados como parte del roadmap de Keygo pero no integran el MVP. Su incorporación depende de la validación del núcleo y de la demanda de las organizaciones conectadas.

| Elemento | Dominio | Condición de entrada |
|----------|---------|----------------------|
| Aprovisionamiento automático desde directorios corporativos | Identidad | Demanda validada por organizaciones enterprise |
| Inicio de sesión único federado entre aplicaciones | Sesiones | Base de integraciones consolidada |
| Federación de identidad con proveedores externos | Identidad | Acuerdo con proveedores y diseño de contratos |
| Integración con proveedores de pago (RF17) | Facturación | Validación del modelo de negocio con el MVP |
| Soporte multi-moneda | Facturación | Expansión a mercados con requisitos distintos |
| Jerarquía avanzada de roles con herencia | Autorización | Casos de uso enterprise validados |
| Analítica avanzada de accesos | Auditoría | Volumen de datos suficiente para análisis |
| Integración con plataformas externas de auditoría | Auditoría | Requisitos de compliance enterprise identificados |
| Aprovisionamiento automatizado vía estándares de directorio | Identidad | Adopción enterprise verificada |

[↑ Volver al inicio](#límites-de-alcance)

---

## Comentarios de los Revisores

| Revisor | Tipo | Contenido |
| ------- | ---- | --------- |
| — | — | Pendiente de revisión |

[↑ Volver al inicio](#límites-de-alcance)

---

[← Índice](./README.md)
