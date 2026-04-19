[← Índice](../README.md) | [< Anterior](rnf07-mantenibilidad.md) | [Siguiente >](rnf09-usabilidad.md)

---

# RNF08 — Observabilidad

**Descripción**
El sistema debe emitir información suficiente sobre su estado y comportamiento para que el equipo técnico pueda detectar problemas, diagnosticar incidentes y verificar que el sistema opera correctamente.

**Alcance incluye**
- Registro de operación estructurado para todos los flujos críticos de la plataforma.
- Exposición de indicadores básicos de salud del sistema: disponibilidad de componentes, tasa de errores, latencia de operaciones críticas.
- Trazabilidad de las solicitudes a través de los componentes del sistema para facilitar el diagnóstico.
- Separación entre los registros operativos (para diagnóstico técnico) y los registros de auditoría (para trazabilidad de acciones, RF18).

**No incluye (MVP)**
- Dashboards de visualización integrados en el MVP.
- Integración con plataformas externas de monitoreo y alerta en el MVP inicial.
- Trazabilidad distribuida completa entre todos los servicios en el MVP.

**Dependencias**
- RNF04 (Disponibilidad y resiliencia).
- RNF11 (Cumplimiento y gobernanza).

**Criterios de aceptación**
1. Los flujos de autenticación y emisión de credenciales generan registros operativos con el nivel de detalle suficiente para diagnosticar fallos.
2. El estado de salud del sistema es consultable por el equipo técnico en tiempo real.
3. Los registros operativos y los de auditoría son independientes; la ausencia o fallo de uno no afecta al otro.
4. Cada solicitud al sistema puede correlacionarse a través de sus pasos de procesamiento mediante un identificador de trazabilidad.

**Riesgos y mitigaciones**
- Registros operativos que contengan datos personales → los registros operativos usan identificadores internos, no datos personales de usuarios.
- Ausencia de señales ante fallos silenciosos → los componentes críticos emiten indicadores de actividad continuos; la ausencia de señal es interpretable como fallo.

---

[← Índice](../README.md) | [< Anterior](rnf07-mantenibilidad.md) | [Siguiente >](rnf09-usabilidad.md)
