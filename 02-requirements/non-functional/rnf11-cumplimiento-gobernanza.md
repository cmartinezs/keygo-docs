[← Índice](../README.md) | [< Anterior](rnf10-compatibilidad-estandares.md) | [Siguiente >](rnf12-gestion-ciclo-vida-claves.md)

---

# RNF11 — Cumplimiento y gobernanza

**Descripción**
El sistema debe proporcionar las capacidades mínimas necesarias para que las organizaciones y el equipo operativo de Keygo puedan demostrar el cumplimiento de sus obligaciones regulatorias y de gobernanza interna mediante registros auditables.

**Alcance incluye**
- Disponibilidad de un registro de auditoría completo e inmutable de las acciones relevantes del sistema (RF18).
- Capacidad de consultar el historial de acciones sobre cualquier recurso de la plataforma dentro del período de retención (RF19).
- Aplicación de períodos de retención de datos configurables para cumplir con obligaciones de conservación o eliminación.
- Separación de roles: las capacidades administrativas de organización, las de la plataforma y las operativas están diferenciadas y no son intercambiables.
- Documentación del modelo de datos y de los flujos del sistema como soporte a auditorías externas.

**No incluye (MVP)**
- Certificaciones formales de cumplimiento normativo (SOC 2, ISO 27001, GDPR DPA, etc.) en el MVP.
- Generación automatizada de informes de cumplimiento.
- Integración con sistemas de gestión de riesgos o GRC externos.

**Dependencias**
- RF18 (Registro de eventos).
- RF19 (Trazabilidad de acciones).
- RNF03 (Privacidad de datos).
- RNF08 (Observabilidad).

**Criterios de aceptación**
1. El registro de auditoría es inmutable y cubre todas las acciones declaradas en RF18.
2. El historial de cualquier recurso es consultable dentro del período de retención configurado.
3. Los roles de administrador de organización, administrador de plataforma y rol técnico operativo tienen capacidades diferenciadas y no solapadas.
4. Los períodos de retención de datos son configurables y se aplican de forma efectiva.
5. La documentación del sistema es suficiente para soportar una auditoría de seguridad básica.

**Riesgos y mitigaciones**
- Registros de auditoría incompletos ante fallos del sistema → el registro de eventos (RF18) tiene mecanismos de escritura preferente con reintento.
- Retención de datos más allá de lo permitido por regulación → la configuración de retención tiene valor máximo; la eliminación al vencer el período es automática y verificable.

---

[← Índice](../README.md) | [< Anterior](rnf10-compatibilidad-estandares.md) | [Siguiente >](rnf12-gestion-ciclo-vida-claves.md)
