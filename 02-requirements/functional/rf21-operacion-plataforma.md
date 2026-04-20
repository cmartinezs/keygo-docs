[← Índice](../README.md) | [< Anterior](rf20-administracion-global-plataforma.md)

---

# RF21 — Operación de la plataforma

**Descripción**
El sistema debe proveer al equipo técnico de Keygo las herramientas básicas necesarias para monitorear el estado operativo de la plataforma, diagnosticar problemas y mantener la continuidad del servicio.

**Alcance incluye**
- Consulta del estado de salud de los componentes críticos de la plataforma.
- Visualización de indicadores básicos de operación: volumen de autenticaciones, tasa de errores, latencia general.
- Acceso a registros de operación para diagnóstico de incidentes.
- Capacidad de ejecutar operaciones de mantenimiento planificado sin interrumpir el servicio cuando sea posible.
- Gestión del ciclo de vida de las claves criptográficas de la plataforma: rotación planificada y de emergencia.

**No incluye (MVP)**
- Dashboards avanzados de observabilidad con métricas históricas y proyecciones.
- Integración con sistemas externos de alerta (PagerDuty, OpsGenie, etc.).
- Herramientas de depuración de flujos específicos de usuario o aplicación.

**Dependencias**
- RF18 (Registro de eventos).
- RF20 (Administración global de la plataforma).
- RNF08 (Observabilidad).
- RNF12 (Gestión del ciclo de vida de claves).

**Criterios de aceptación**
1. El equipo técnico puede consultar el estado de salud de la plataforma sin necesidad de acceder a la infraestructura subyacente directamente.
2. La rotación de claves criptográficas puede ejecutarse sin interrumpir las autenticaciones en curso.
3. Los registros de operación están disponibles para diagnóstico en un plazo acotado tras ocurrir el evento.
4. Las operaciones de mantenimiento que requieran interrupción parcial del servicio pueden planificarse y comunicarse con antelación.
5. Solo actores con rol técnico autorizado pueden ejecutar operaciones de mantenimiento y gestión de claves.

**Riesgos y mitigaciones**
- Rotación de claves que invalida sesiones activas → el proceso de rotación debe mantener las claves antiguas activas durante el período de transición (RF13).
- Acceso no autorizado a herramientas de operación → las capacidades de operación están restringidas a roles técnicos diferenciados del rol de administrador de organización.

---

[← Índice](../README.md) | [< Anterior](rf20-administracion-global-plataforma.md) | [Siguiente >](rf22-planes-por-aplicacion.md)
