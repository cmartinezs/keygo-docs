[← Índice](./README.md)

---

# Matriz de Priorización

Clasificación MoSCoW de todos los requerimientos funcionales y no funcionales de Keygo.

## Contenido

- [Criterios de priorización](#criterios-de-priorización)
- [Requerimientos funcionales](#requerimientos-funcionales)
- [Requerimientos no funcionales](#requerimientos-no-funcionales)
- [Comentarios de los Revisores](#comentarios-de-los-revisores)

---

## Criterios de priorización

| Nivel | Significado |
|-------|-------------|
| **Must** | Imprescindible para el MVP. Su ausencia impide la operación o invalida la propuesta de valor. |
| **Should** | Importante para el MVP pero con margen de postergación si hay restricciones de tiempo o recursos. |
| **Could** | Deseable en el MVP; se incluye si hay capacidad disponible sin comprometer los Must y Should. |
| **Won't** | Explícitamente excluido del MVP. Pertenece a fases futuras o al backlog de producto. |

[↑ Volver al inicio](#matriz-de-priorización)

---

## Requerimientos funcionales

| # | Requerimiento | Prioridad | Justificación |
|---|---------------|-----------|---------------|
| RF01 | Gestión de organizaciones | **Must** | Sin organizaciones no existe ninguna otra capacidad del sistema. |
| RF02 | Configuración de la organización | **Should** | La configuración básica es necesaria; el branding y opciones avanzadas pueden postergarse. |
| RF03 | Gestión de usuarios | **Must** | El directorio de usuarios es condición para cualquier flujo de autenticación. |
| RF04 | Autenticación de usuarios | **Must** | Propuesta de valor central de la plataforma. |
| RF05 | Gestión de credenciales | **Must** | Cambio y recuperación de contraseña son requisitos mínimos de usabilidad y seguridad. |
| RF06 | Registro de aplicaciones cliente | **Must** | Sin aplicaciones registradas no hay integración posible con el ecosistema. |
| RF07 | Configuración de aplicaciones cliente | **Should** | Los ámbitos básicos son necesarios; modalidades avanzadas pueden postergarse. |
| RF08 | Acceso de usuarios a aplicaciones | **Must** | La membresía usuario-aplicación es el núcleo del modelo de acceso. |
| RF09 | Roles por aplicación | **Should** | El control de acceso básico es necesario; la jerarquía avanzada puede postergarse. |
| RF10 | Control de acceso basado en roles | **Must** | Sin verificación de permisos el sistema no puede garantizar autorización granular. |
| RF11 | Emisión de credenciales de sesión | **Must** | Base de toda integración con aplicaciones cliente. |
| RF12 | Verificación de credenciales de sesión | **Must** | Las aplicaciones cliente dependen de esta capacidad para verificar identidad. |
| RF13 | Verificación pública de credenciales | **Should** | Habilita integración autónoma; sin ello las aplicaciones dependen de llamadas directas a Keygo. |
| RF14 | Gestión de sesiones | **Must** | El ciclo de vida de sesiones (expiración, revocación) es requisito de seguridad. |
| RF15 | Gestión de suscripciones | **Must** | Hace viable el modelo de negocio SaaS desde el primer día. |
| RF16 | Medición de uso | **Should** | Los límites básicos por plan son necesarios; la analítica avanzada puede postergarse. |
| RF17 | Integración con proveedores de pago | **Won't** | Fase futura; la facturación básica del MVP no requiere integración de pagos. |
| RF18 | Registro de eventos | **Must** | Requisito de seguridad y compliance no negociable. |
| RF19 | Trazabilidad de acciones | **Should** | La consulta básica del historial es necesaria; la exportación avanzada puede postergarse. |
| RF20 | Administración global de la plataforma | **Must** | Sin gestión de organizaciones el equipo operativo no puede administrar la plataforma. |
| RF21 | Operación de la plataforma | **Should** | Las herramientas básicas de diagnóstico son necesarias; las avanzadas pueden postergarse. |

[↑ Volver al inicio](#matriz-de-priorización)

---

## Requerimientos no funcionales

| # | Requerimiento | Prioridad | Justificación |
|---|---------------|-----------|---------------|
| RNF01 | Seguridad | **Must** | Requisito no negociable desde el primer commit. Una brecha invalida la plataforma completa. |
| RNF02 | Aislamiento entre organizaciones | **Must** | Restricción de diseño P0. Una filtración entre organizaciones es un incidente crítico. |
| RNF03 | Privacidad de datos | **Must** | Obligatorio para operar en cualquier mercado con datos personales. |
| RNF04 | Disponibilidad y resiliencia | **Must** | Un servicio de autenticación caído bloquea a todas las aplicaciones cliente. |
| RNF05 | Rendimiento | **Must** | La latencia en autenticación impacta directamente la experiencia de todos los usuarios. |
| RNF06 | Escalabilidad | **Should** | El diseño debe permitir escala; la capacidad máxima puede crecer iterativamente. |
| RNF07 | Mantenibilidad | **Must** | Un núcleo difícil de mantener bloquea la evolución del producto. |
| RNF08 | Observabilidad | **Should** | Los logs y métricas básicos son necesarios; los dashboards avanzados pueden postergarse. |
| RNF09 | Usabilidad | **Should** | Criterio de aceptación de cada entrega; sin usabilidad la adopción será lenta. |
| RNF10 | Compatibilidad con estándares abiertos | **Must** | Base de toda integración con el ecosistema. Sin estándares, cada integración es ad-hoc. |
| RNF11 | Cumplimiento y gobernanza | **Should** | El registro básico de auditoría cubre el MVP; el compliance avanzado es iterativo. |
| RNF12 | Gestión del ciclo de vida de claves | **Must** | La rotación de claves es parte del ciclo de seguridad operativa. |
| RNF13 | Consistencia de credenciales de sesión | **Must** | El manejo incorrecto de expiración genera vulnerabilidades o sesiones zombie. |
| RNF14 | Latencia de autenticación | **Should** | El SLA debe estar definido; la optimización avanzada es iterativa. |

[↑ Volver al inicio](#matriz-de-priorización)

---

## Comentarios de los Revisores

| Revisor | Tipo | Contenido |
| ------- | ---- | --------- |
| — | — | Pendiente de revisión |

[↑ Volver al inicio](#matriz-de-priorización)

---

[← Índice](./README.md)
