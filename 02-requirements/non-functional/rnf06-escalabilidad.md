[← Índice](../README.md) | [< Anterior](rnf05-rendimiento.md) | [Siguiente >](rnf07-mantenibilidad.md)

---

# RNF06 — Escalabilidad

**Descripción**
El sistema debe ser capaz de escalar para soportar el crecimiento en número de organizaciones, usuarios, aplicaciones cliente y volumen de autenticaciones, sin requerir rediseño arquitectónico.

**Alcance incluye**
- Diseño que permita el escalado horizontal de los componentes de autenticación y verificación de credenciales.
- Capacidad de incorporar nuevas organizaciones sin impacto en el rendimiento de las existentes.
- Soporte al crecimiento del volumen de credenciales de sesión emitidas sin degradación del servicio.
- Separación de los componentes de alta frecuencia (autenticación, verificación) de los de baja frecuencia (administración, auditoría) para escalar de forma independiente.

**No incluye (MVP)**
- Escala a volúmenes de miles de organizaciones en el MVP inicial; el diseño debe soportarlo pero la capacidad instalada puede ser menor.
- Escalado automático basado en métricas de carga en el MVP.

**Dependencias**
- RNF04 (Disponibilidad y resiliencia).
- RNF05 (Rendimiento).

**Criterios de aceptación**
1. La incorporación de nuevas organizaciones no degrada el rendimiento de las organizaciones existentes.
2. Los componentes críticos del sistema pueden escalar horizontalmente añadiendo instancias sin cambios en la lógica de negocio.
3. El diseño no asume estado local en los componentes de autenticación; el estado se gestiona de forma centralizada o distribuida.
4. Los límites de capacidad del MVP están documentados; el diseño no impone barreras arquitectónicas para superarlos.

**Riesgos y mitigaciones**
- Arquitectura con estado local en componentes de autenticación → diseño sin estado en los nodos de procesamiento; el estado de sesión se externaliza.
- Cuellos de botella no detectados hasta producción → los límites y el comportamiento bajo carga se prueban antes del lanzamiento del MVP.

---

[← Índice](../README.md) | [< Anterior](rnf05-rendimiento.md) | [Siguiente >](rnf07-mantenibilidad.md)
