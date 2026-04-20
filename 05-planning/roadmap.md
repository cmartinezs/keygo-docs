[← Índice](./README.md) | [Siguiente >](./epics.md)

---

# Roadmap

Visión de producto a corto y mediano plazo. Este roadmap responde a la pregunta: ¿en qué orden entregamos las capacidades identificadas en la priorización?

## Contenido

- [Filosofía del roadmap](#filosofía-del-roadmap)
- [Fases del roadmap](#fases-del-roadmap)
- [Corto plazo (0-3 meses)](#corto-plazo-0-3-meses)
- [Mediano plazo (3-12 meses)](#mediano-plazo-3-12-meses)
- [Largo plazo (12+ meses)](#largo-plazo-12-meses)
- [Supuestos y riesgos](#supuestos-y-riesgos)

---

## Filosofía del roadmap

El roadmap se construye sobre dos principios:

1. **Primero lo que habilita todo lo demás**: Sin identidad y acceso, nada tiene sentido. Entregamos el Core Domain primero.
2. **Cada entrega es usable**: Cada fase produce algo que una organización puede usar en producción. No hay fases de "solo backend" o "solo infraestructura".

El resultado es un roadmap de **entregas horizontales** donde cada fase toca todos los contextos necesarios para que una historia de usuario funcione de extremo a extremo.

[↑ Volver al inicio](#roadmap)

---

## Fases del roadmap

| Fase | Enfoque | Meta principal |
|------|---------|---------------|
| **v0.1** | Fundaciones del Core | Autenticación y sesiones funcionales |
| **v0.2** | Acceso básico | Control de acceso por aplicación |
| **v0.3** | Ecosistema | Registro y consumo de aplicaciones cliente |
| **v1.0** | Producto mínimo viable | Todo lo necesario para operación en producción |
| **v1.x** | Expansión | Enhancements de seguridad y usabilidad |
| **v2.0** | Escala | Multi-org, billing, y capacidades avanzadas |

[↑ Volver al inicio](#roadmap)

---

## Corto plazo (0-3 meses)

### v0.1 — Fundaciones del Core

**Objetivo**: tener un sistema de autenticación funcional que pueda verificar credenciales.

**Qué se entrega**:

| Capability | Descripción | RFs relacionados |
|------------|-------------|-----------------|
| Gestión de organizaciones | Crear y configurar tenants | RF01, RF02 |
| Gestión de usuarios | Directorio de usuarios por organización | RF03 |
| Autenticación | Login, logout, cambio de contraseña | RF04, RF05 |
| Sesiones | Emisión y validación de tokens de sesión | RF11, RF12, RF14 |

**Criterio de aceptación**: Una organización puede registrar usuarios, y esos usuarios pueden autenticarse y mantener sesión.

**Notas de entrega**: Esta fase produce la API de autenticación pero no el portal de usuario. El portal viene en v0.3.

---

### v0.2 — Acceso Básico

**Objetivo**: Poder definir qué puede hacer cada usuario en cada aplicación.

**Qué se entrega**:

| Capability | Descripción | RFs relacionados |
|------------|-------------|-----------------|
| Aplicaciones cliente | Registro de apps externas | RF06, RF07 |
| Roles por aplicación | Definición de roles | RF09 |
| Membresías | Asociación usuario-aplicación-rol | RF08, RF10 |
| Verificación de acceso | Validación de credenciales de sesión | RF12 |

**Criterio de aceptación**: Una aplicación cliente puede delegar la autenticación en Keygo y obtener información de roles del usuario autenticado.

**Dependencias internas**: Requiere v0.1 completa.

---

### v0.3 — Ecosistema

**Objetivo**: Cerrar el loop de integración para que las aplicaciones cliente puedan consumir Keygo de forma autónoma.

**Qué se entrega**:

| Capability | Descripción | RFs relacionados |
|------------|-------------|-----------------|
| Portal de organización | UI para gestión de la organización | RF01, RF02, RF20 |
| Portal de usuarios | Login, gestión de perfil, recuperación | RF03, RF04, RF05 |
| Verificación pública | Endpoint para validación autónoma de credenciales | RF13 |
| Configuración de apps | UI para registrar y configurar aplicaciones | RF06, RF07 |

**Criterio de aceptación**: Una organización puede usar Keygo completamente desde el portal sin intervención del equipo de operaciones.

**Dependencias internas**: Requiere v0.1 y v0.2 completas.

[↑ Volver al inicio](#roadmap)

---

## Mediano plazo (3-12 meses)

### v1.0 — MVP Completo

**Objetivo**: El producto está listo para operación en producción sin dependencia del equipo de desarrollo.

**Qué se entrega**:

| Capability | Descripción | RFs relacionados |
|------------|-------------|-----------------|
| Suscripciones | Planes y límites por organización | RF15 |
| Medición de uso | Contadores por plan | RF16 |
| Auditoría | Registro de eventos de seguridad | RF18, RF19 |
| Herramientas de admin | Diagnóstico y soporte operativo | RF21 |

**Criterio de aceptación**: El equipo operativo puede dar soporte sin acceder a la base de datos directamente.

**Dependencias internas**: Requiere v0.1–v0.3 completas.

---

### v1.1 — Seguridad Avanzada

**Objetivo**: Fortalecer la postura de seguridad.

**Qué se entrega**:
- Rotación de claves de firma (RNF12)
- Autenticación multifactor opcional
- Detección de anomalías básica

**RNFs relacionados**: RNF01, RNF12, RNF13

---

### v1.2 — Planes de Aplicación

**Objetivo**: Habilitar que las aplicaciones cliente ofrezcan planes comerciales a sus usuarios finales.

**Qué se entrega**:

| Capability | Descripción | RFs relacionados |
|------------|-------------|-----------------|
| Planes por aplicación | Catálogo de planes que una app ofrece a sus usuarios | RF22 |
| Suscripciones de usuarios | Contratación de plan por usuario final de una app | RF23 |
| Evaluación de derechos | Derechos del plan embebidos en la sesión de acceso | RF24 |

**Criterio de aceptación**: Una aplicación cliente puede definir planes con límites y habilitaciones; sus usuarios pueden contratar un plan y el sistema aplica los derechos en cada sesión.

**Dependencias internas**: Requiere v1.0 completa.

---

### v1.3 — Mejoras de usabilidad

**Objetivo**: Reducir fricción en la adopción.

**Qué se entrega**:
- Autenticación con proveedores de identidad externos
- Invitaciones por email
- Mejora de flujos de recuperación de cuenta
- Dashboard de actividad por usuario

**RNFs relacionados**: RNF09, RNF14

[↑ Volver al inicio](#roadmap)

---

## Largo plazo (12+ meses)

### v2.0 — Escala y Multi-org

**Objetivo**: Habilitar escenarios de alta complejidad organizacional.

**Qué se entrega**:
- Organizaciones padre-hijo (jerarquía de tenants)
- Roles jerárquicos (herencia de roles)
- Políticas de acceso basadas en atributos
- Federation entre organizaciones

---

### v2.1 — Billing Real

**Objetivo**: Monetización completa con cobro automatizado.

**Qué se entrega**:
- Integración con proveedor de pago externo (RF17)
- Facturación automatizada para tenants y usuarios de app
- Portal de billing para organizaciones

---

### v2.x — Ecosistema Expandido

**Qué se entrega**:
- Webhooks configurables
- SDKs oficiales
- Marketplace de integraciones

[↑ Volver al inicio](#roadmap)

---

## Supuestos y riesgos

### Supuestos

| Supuesto | Implicación |
|---------|------------|
| El equipo tiene capacidad de construir el Core Domain en paralelo con la infraestructura | Las fases v0.1–v0.3 pueden implementarse en paralelo si se cuenta con los recursos. |
| Las organizaciones early adopter tolerarán limitaciones en la UI inicial | El MVP prioriza funcionalidad sobre experiencia visual. |

### Riesgos

| Riesgo | Probabilidad | Impacto | Mitigación |
|-------|-------------|--------|------------|
| La complejidad del Core Domain retrasa la entrega | Media | Alto | Priorizar autenticación básica primero; deferir granularidad avanzada a v1.x |
| El equipo no tiene experiencia con multi-tenancy | Media | Medio | Invertir en spike de arquitectura multi-tenant antes de v0.1 |

[↑ Volver al inicio](#roadmap)

---

[← Índice](./README.md) | [Siguiente >](./epics.md)
