[← Índice](./README.md) | [< Anterior](./roadmap.md) | [Siguiente >](./versioning.md)

---

# Epics

Agrupación del trabajo por iniciativa estratégica. Cada epic agrupa features relacionados que se entregan juntos.

## Contenido

- [Filosofía de epics](#filosofía-de-epics)
- [Epic 1: Autenticación Core](#epic-1-autenticación-core)
- [Epic 2: Control de Acceso](#epic-2-control-de-acceso)
- [Epic 3: Ecosistema de Aplicaciones](#epic-3-ecosistema-de-aplicaciones)
- [Epic 4: Observabilidad y Operaciones](#epic-4-observabilidad-y-operaciones)
- [Epic 5: Modelo de Negocio](#epic-5-modelo-de-negocio)
- [Epic 6: Escalabilidad](#epic-6-escalabilidad)
- [Matriz de dependencias](#matriz-de-dependencias)

---

## Filosofía de epics

Un epic es una **unidad de entrega** que:
- Tiene un **objetivo de negocio** claro
- Se puede **estimar** como un todo
- Produce un **incremento usable** del producto
- Es trazable a los RFs mediante [Trazabilidad](../02-requirements/traceability.md)

Los epics se solapan en el tiempo. No todos los RFs de un epic se entregan juntos — se priorizan por dependencia interna.

[↑ Volver al inicio](#epics)

---

## Epic 1: Autenticación Core

**Objetivo**: Que cualquier usuario pueda autenticarse en el sistema y mantener una sesión activa.

| Atributo | Valor |
|---------|-------|
| Prioridad | **Must** |
| RFs | RF03, RF04, RF05, RF11, RF12, RF14 |
| RNFs | RNF01, RNF02, RNF03, RNF04, RNF05 |
| Estimación | 3 sprints |
| Criterio | Usuario puede registrarse, iniciar sesión, cerrar sesión, cambiar contraseña, renovar sesión |

### Features

| Feature | Descripción | RF |
|---------|-------------|-----|
| F1.1 | Registro de organizaciones | RF01 |
| F1.2 | Gestión de usuarios (ciclo de vida) | RF03 |
| F1.3 | Autenticación con contraseña | RF04 |
| F1.4 | Cambio de contraseña | RF05 |
| F1.5 | Recuperación de contraseña | RF05 |
| F1.6 | Emisión de credenciales de sesión | RF11 |
| F1.7 | Validación de credenciales de sesión | RF12 |
| F1.8 | Cierre de sesión y revocación | RF14 |
| F1.9 | Expiración automática de sesión | RF14 |

[↑ Volver al inicio](#epics)

---

## Epic 2: Control de Acceso

**Objetivo**: Que una organización pueda definir qué puede hacer cada usuario en cada aplicación.

| Atributo | Valor |
|---------|-------|
| Prioridad | **Must** |
| RFs | RF08, RF09, RF10 |
| RNFs | RNF10 |
| Estimación | 2 sprints |
| Criterio | Usuario recibe credencial con roles; aplicación puede verificar permisos |

### Features

| Feature | Descripción | RF |
|---------|-------------|-----|
| F2.1 | Registro de aplicaciones cliente | RF06 |
| F2.2 | Configuración de ámbitos de acceso | RF07 |
| F2.3 | Definición de roles por aplicación | RF09 |
| F2.4 | Asignación de roles a usuarios | RF08 |
| F2.5 | Evaluación de permisos (RBAC) | RF10 |
| F2.6 | Inclusión de roles en credencial de sesión | RF10, RF11 |

[↑ Volver al inicio](#epics)

---

## Epic 3: Ecosistema de Aplicaciones

**Objetivo**: Habilitar el ecosistema de integraciones para que las aplicaciones cliente consuman Keygo de forma autónoma.

| Atributo | Valor |
|---------|-------|
| Prioridad | **Should** |
| RFs | RF06, RF07, RF13 |
| Estimación | 2 sprints |
| Criterio | Una aplicación externa puede autenticarse contra Keygo de forma autónoma |

### Features

| Feature | Descripción | RF |
|---------|-------------|-----|
| F3.1 | Portal de organización | RF01, RF02, RF20 |
| F3.2 | Portal de usuarios | RF03, RF04, RF05 |
| F3.3 | Gestión de aplicaciones desde portal | RF06, RF07 |
| F3.4 | Verificación pública de credenciales | RF13 |

[↑ Volver al inicio](#epics)

---

## Epic 4: Observabilidad y Operaciones

**Objetivo**: Que el equipo operativo pueda dar soporte y mantener el sistema en producción.

| Atributo | Valor |
|---------|-------|
| Prioridad | **Should** |
| RFs | RF18, RF19, RF21 |
| RNFs | RNF08, RNF11 |
| Estimación | 2 sprints |
| Criterio | Registro de auditoría disponible; el equipo puede hacer diagnóstico sin acceso directo a la base de datos |

### Features

| Feature | Descripción | RF |
|---------|-------------|-----|
| F4.1 | Registro inmutable de eventos de seguridad | RF18 |
| F4.2 | Registro de eventos de acceso | RF18 |
| F4.3 | Consulta de historial de auditoría | RF19 |
| F4.4 | Herramientas de diagnóstico y soporte | RF21 |

[↑ Volver al inicio](#epics)

---

## Epic 5: Modelo de Negocio

**Objetivo**: Habilitar el modelo de negocio SaaS con planes, límites, medición de uso y planes de aplicación para usuarios finales.

| Atributo | Valor |
|---------|-------|
| Prioridad | **Could** (v1.0+) |
| RFs | RF15, RF16, RF22, RF23, RF24 |
| Estimación | 4 sprints |
| Criterio | Organización tiene plan con límites medidos; apps pueden ofrecer planes a sus usuarios con derechos evaluados en cada sesión |

### Features

| Feature | Descripción | RF |
|---------|-------------|-----|
| F5.1 | Planes de plataforma por organización | RF15 |
| F5.2 | Medición de uso contra límites del plan | RF16 |
| F5.3 | Catálogo de planes por aplicación cliente | RF22 |
| F5.4 | Suscripción de usuario final a plan de app | RF23 |
| F5.5 | Evaluación de derechos de membresía en sesión | RF24 |
| F5.6 | Enforcement HARD (bloqueo) y SOFT (notificación) | RF24 |

[↑ Volver al inicio](#epics)

---

## Epic 6: Escalabilidad

**Objetivo**: Preparación para escenarios de alta carga y complejidad organizacional.

| Atributo | Valor |
|---------|-------|
| Prioridad | **Won't** (v2.0+) |
| Estimación | 3+ sprints |
| Criterio | Sistema soporta alta concurrencia y jerarquías de organización complejas |

### Features

| Feature | Descripción |
|---------|-------------|
| F6.1 | Organizaciones padre-hijo (jerarquía de tenants) |
| F6.2 | Roles jerárquicos (herencia entre organizaciones) |
| F6.3 | Políticas de acceso basadas en atributos (ABAC) |
| F6.4 | Federación entre organizaciones |

Esta epic se diseña anticipadamente pero no se implementa en el MVP. Las decisiones de arquitectura deben permitir estas capacidades sin refactorización mayor.

[↑ Volver al inicio](#epics)

---

## Matriz de dependencias

```
EPIC 1 (Auth Core)
    │
    ├──► EPIC 2 (Control de Acceso)
    │        │
    │        └──► EPIC 3 (Ecosistema)
    │
    └──► EPIC 4 (Observabilidad) ──────────────► EPIC 5 (Negocio)
                                                      │
                                                      └──► EPIC 6 (Escala)
```

- **Epic 1** no tiene dependencias externas
- **Epic 2** depende de Epic 1 completa
- **Epic 3** depende de Epics 1 y 2 completas
- **Epic 4** corre en paralelo a Epics 1–3
- **Epic 5** depende de Epics 1–4 completas
- **Epic 6** es diseño anticipado, no implementación

[↑ Volver al inicio](#epics)

---

[← Índice](./README.md) | [< Anterior](./roadmap.md) | [Siguiente >](./versioning.md)
