[← Índice](../README.md) | [< Anterior](rf15-gestion-suscripciones.md) | [Siguiente >](rf17-integracion-proveedores-pago.md)

---

# RF16 — Medición de uso

**Descripción**
El sistema debe medir y registrar el uso operativo de cada organización para que los límites del plan de suscripción puedan aplicarse y el estado de consumo pueda ser consultado.

**Alcance incluye**
- Conteo de usuarios activos por organización.
- Conteo de aplicaciones cliente registradas por organización.
- Registro de volumen de autenticaciones por organización en períodos definidos.
- Comparación del uso actual con los límites del plan de suscripción vigente.
- Consulta del estado de uso por parte del administrador de organización.
- Consulta del uso agregado por parte del administrador de la plataforma.

**No incluye (MVP)**
- Analítica de uso avanzada: tendencias, proyecciones, segmentación por aplicación.
- Exportación de datos de uso a sistemas externos.
- Facturación basada en uso real (pay-per-use).

**Dependencias**
- RF15 (Gestión de suscripciones).
- RF03 (Gestión de usuarios).
- RF06 (Registro de aplicaciones cliente).
- RF04 (Autenticación de usuarios).

**Criterios de aceptación**
1. El sistema registra en tiempo real el número de usuarios activos y aplicaciones de cada organización.
2. Al intentar crear un usuario o aplicación que supere el límite del plan, la operación es rechazada con indicación del límite alcanzado.
3. El administrador de organización puede consultar su uso actual frente a los límites de su plan en cualquier momento.
4. Los datos de uso son consistentes con las operaciones realizadas: el conteo se actualiza al crear o desactivar usuarios y aplicaciones.
5. El administrador de la plataforma puede consultar el uso de cualquier organización.

**Riesgos y mitigaciones**
- Contador desfasado que permita superar límites → los contadores se actualizan de forma atómica junto con las operaciones que los afectan.
- Datos de uso inaccesibles para el administrador → la consulta de uso no depende del sistema de auditoría; es una capacidad operativa independiente.

---

[← Índice](../README.md) | [< Anterior](rf15-gestion-suscripciones.md) | [Siguiente >](rf17-integracion-proveedores-pago.md)
