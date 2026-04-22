[← Índice](./README.md)

---

# Trazabilidad

Relación entre los requerimientos del sistema, las necesidades identificadas en el Discovery y los objetivos estratégicos de Keygo.

## Contenido

- [Referencias](#referencias)
- [Trazabilidad de requerimientos funcionales](#trazabilidad-de-requerimientos-funcionales)
- [Trazabilidad de requerimientos no funcionales](#trazabilidad-de-requerimientos-no-funcionales)
- [Cobertura de necesidades](#cobertura-de-necesidades)
- [Comentarios de los Revisores](#comentarios-de-los-revisores)

---

## Referencias

**Necesidades (N)** — definidas en [Necesidades y Expectativas](../01-discovery/needs-expectations.md):

| ID | Necesidad |
|----|-----------|
| N1 | Centralización de la identidad y el acceso |
| N2 | Aislamiento completo entre organizaciones |
| N3 | Gestión del ciclo de vida de usuarios por organización |
| N4 | Control de acceso configurable por organización |
| N5 | Autenticación confiable con trazabilidad |
| N6 | Registro y gestión de aplicaciones cliente |
| N7 | Facturación autónoma por organización |
| N8 | Auditoría de eventos de seguridad |
| N9 | Integración sin fricción con el ecosistema |

**Objetivos estratégicos (OE)** — definidos en [Visión del Sistema](../01-discovery/system-vision.md):

| ID | Objetivo |
|----|----------|
| OE1 | Centralizar la gestión de identidad y acceso |
| OE2 | Garantizar aislamiento completo entre organizaciones |
| OE3 | Adoptar estándares abiertos como base de integración |
| OE4 | Habilitar autorización granular basada en roles |
| OE5 | Proveer trazabilidad y auditoría de accesos |
| OE6 | Facilitar la integración con el ecosistema de aplicaciones |
| OE7 | Escalar hacia casos de uso enterprise |

[↑ Volver al inicio](#trazabilidad)

---

## Trazabilidad de requerimientos funcionales

| RF | Requerimiento | Necesidades | Objetivos estratégicos |
|----|---------------|-------------|------------------------|
| RF01 | Gestión de organizaciones | N1, N2 | OE1, OE2, OE7 |
| RF02 | Configuración de la organización | N2, N3 | OE2, OE7 |
| RF03 | Gestión de usuarios | N3 | OE1, OE7 |
| RF04 | Autenticación de usuarios | N5 | OE1, OE3 |
| RF05 | Gestión de credenciales | N5 | OE1 |
| RF06 | Registro de aplicaciones cliente | N6 | OE1, OE6 |
| RF07 | Configuración de aplicaciones cliente | N6, N9 | OE3, OE6 |
| RF08 | Acceso de usuarios a aplicaciones | N4, N6 | OE4, OE6 |
| RF09 | Roles por aplicación | N4 | OE4, OE7 |
| RF10 | Control de acceso basado en roles | N4 | OE4 |
| RF11 | Emisión de credenciales de sesión | N5, N9 | OE1, OE3, OE6 |
| RF12 | Verificación de credenciales de sesión | N9 | OE3, OE6 |
| RF13 | Verificación pública de credenciales | N9 | OE3, OE6 |
| RF14 | Gestión de sesiones | N5 | OE1, OE5 |
| RF15 | Gestión de suscripciones | N7 | OE7 |
| RF16 | Medición de uso | N7 | OE7 |
| RF17 | Integración con proveedores de pago | N7 | OE7 |
| RF18 | Registro de eventos | N8 | OE5 |
| RF19 | Trazabilidad de acciones | N8 | OE5 |
| RF20 | Administración global de la plataforma | N1 | OE1, OE7 |
| RF21 | Operación de la plataforma | N1 | OE1 |
| RF22 | Planes comerciales por aplicación cliente | N7 | OE7 |
| RF23 | Suscripciones de usuarios a planes de aplicación | N7 | OE7 |
| RF24 | Evaluación de derechos de membresía | N4, N7 | OE4, OE7 |

[↑ Volver al inicio](#trazabilidad)

---

## Trazabilidad de requerimientos no funcionales

| RNF | Requerimiento | Necesidades | Objetivos estratégicos |
|-----|---------------|-------------|------------------------|
| RNF01 | Seguridad | N2, N5 | OE1, OE2 |
| RNF02 | Aislamiento entre organizaciones | N2 | OE2 |
| RNF03 | Privacidad de datos | N2, N5 | OE2, OE7 |
| RNF04 | Disponibilidad y resiliencia | N5, N9 | OE1, OE6 |
| RNF05 | Rendimiento | N5, N9 | OE1, OE6 |
| RNF06 | Escalabilidad | N1, N9 | OE1, OE7 |
| RNF07 | Mantenibilidad | N9 | OE6, OE7 |
| RNF08 | Observabilidad | N8 | OE5 |
| RNF09 | Usabilidad | N3, N6 | OE7 |
| RNF10 | Compatibilidad con estándares abiertos | N9 | OE3, OE6 |
| RNF11 | Cumplimiento y gobernanza | N8 | OE5, OE7 |
| RNF12 | Gestión del ciclo de vida de claves | N5 | OE1 |
| RNF13 | Consistencia de credenciales de sesión | N5 | OE1 |
| RNF14 | Latencia de autenticación | N5 | OE1, OE6 |

[↑ Volver al inicio](#trazabilidad)

---

## Cobertura de necesidades

Verificación de que cada necesidad del Discovery tiene al menos un requerimiento que la satisface.

| Necesidad | RF que la satisfacen | RNF que la refuerzan | Cobertura |
|-----------|---------------------|----------------------|-----------|
| N1 — Centralización de la identidad | RF01, RF04, RF20, RF21 | RNF01, RNF06 | ✅ |
| N2 — Aislamiento entre organizaciones | RF01, RF02 | RNF01, RNF02, RNF03 | ✅ |
| N3 — Gestión del ciclo de vida de usuarios | RF03 | RNF09 | ✅ |
| N4 — Control de acceso configurable | RF08, RF09, RF10 | — | ✅ |
| N5 — Autenticación confiable con trazabilidad | RF04, RF05, RF14 | RNF01, RNF04, RNF05, RNF12, RNF13, RNF14 | ✅ |
| N6 — Registro y gestión de aplicaciones cliente | RF06, RF07, RF08 | RNF09 | ✅ |
| N7 — Facturación autónoma | RF15, RF16, RF17 | — | ✅ |
| N8 — Auditoría de eventos | RF18, RF19 | RNF08, RNF11 | ✅ |
| N9 — Integración sin fricción | RF07, RF11, RF12, RF13 | RNF04, RNF05, RNF07, RNF10 | ✅ |

> Todas las necesidades del Discovery tienen cobertura en el catálogo de requerimientos.

[↑ Volver al inicio](#trazabilidad)

---

## Comentarios de los Revisores

| Revisor | Tipo | Contenido |
| ------- | ---- | --------- |
| — | — | Pendiente de revisión |

[↑ Volver al inicio](#trazabilidad)

---

[← Índice](./README.md)
