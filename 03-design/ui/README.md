[← Diseño y Proceso](../README.md)

---

# Diseño de Interfaz

Esta sección documenta **qué ve y qué puede hacer cada actor** en Keygo — sin prescribir tecnología ni implementación. El diseño técnico del frontend (arquitectura de componentes, patrones de estado, estándares de código) se aborda en `06-development/`.

---

## Contenido

| Documento | Descripción |
|-----------|-------------|
| [Sistema de Diseño](./design-system.md) | Principios visuales, lenguaje de componentes y patrones de interacción. |
| [Inventario de pantallas](./wireframes.md) | Pantallas principales por portal, flujos de navegación y estructura de cada sección. |
| [Decisiones UX](./ux-decisions.md) | Decisiones de experiencia de usuario, alternativas descartadas y justificación. |

---

## Una interfaz con contexto de rol seleccionable

Los roles de plataforma forman una jerarquía de inclusión: `KEYGO_ADMIN` ⊇ `KEYGO_ACCOUNT_ADMIN` ⊇ `KEYGO_USER`. Toda identidad tiene un rol máximo pero puede operar bajo cualquiera de los roles que incluye. Keygo muestra un **selector de rol activo** en la interfaz: la identidad elige con qué rol está trabajando en ese momento, y la interfaz — las secciones visibles y las acciones disponibles — se adapta a esa selección. El rol activo puede cambiarse en cualquier momento sin cerrar sesión.

| Contexto de rol | Quién puede seleccionarlo | Qué habilita |
|-----------------|--------------------------|--------------|
| **KEYGO_USER** | Toda identidad autenticada | Autogestión de cuenta (perfil, contraseña, sesiones, conexiones externas, preferencias). Para `KEYGO_USER` puro, es el único contexto disponible. |
| **KEYGO_ACCOUNT_ADMIN** | Identidades con rol máximo `KEYGO_ACCOUNT_ADMIN` o `KEYGO_ADMIN` | Consola de Organización: gestión de usuarios, aplicaciones, roles y suscripción de la organización. |
| **KEYGO_ADMIN** | Identidades con rol máximo `KEYGO_ADMIN` | Consola de Plataforma: visibilidad operativa global y operaciones de soporte sobre todas las organizaciones. |

Un `KEYGO_USER` puro no ve el selector — su único contexto es la autogestión de cuenta. Un `KEYGO_ACCOUNT_ADMIN` puede alternar entre su contexto de administrador y su contexto de usuario final. Un `KEYGO_ADMIN` puede operar en cualquiera de los tres contextos.

---

[← Diseño y Proceso](../README.md)
