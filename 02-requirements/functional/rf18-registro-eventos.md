[← Índice](../README.md) | [< Anterior](rf17-integracion-proveedores-pago.md) | [Siguiente >](rf19-trazabilidad-acciones.md)

---

# RF18 — Registro de eventos

**Descripción**
El sistema debe registrar de forma automática y confiable todos los eventos relevantes de seguridad y operación, garantizando que exista una traza auditable de lo que ocurre en la plataforma.

**Alcance incluye**
- Registro automático de eventos de autenticación: intentos exitosos, fallidos y bloqueos.
- Registro de eventos de gestión: creación, modificación, suspensión y eliminación de organizaciones, usuarios y aplicaciones cliente.
- Registro de eventos de acceso: habilitación y revocación de acceso de usuarios a aplicaciones.
- Registro de eventos de sesión: creación, renovación, expiración y revocación de sesiones.
- Registro de cambios de configuración: políticas de organización, configuración de aplicaciones cliente.
- Registro de eventos de credenciales: cambios de contraseña, recuperaciones, rotaciones de claves.
- Cada registro incluye: tipo de evento, actor que lo generó, momento en que ocurrió, organización y recurso afectado.
- Los registros son inmutables una vez creados.

**No incluye (MVP)**
- Exportación de registros a sistemas externos de análisis de seguridad.
- Alertas en tiempo real sobre eventos críticos.
- Retención diferenciada por tipo de evento.

**Dependencias**
- RNF08 (Observabilidad).
- RNF11 (Cumplimiento y gobernanza).

**Criterios de aceptación**
1. Cada acción relevante en la plataforma genera automáticamente un registro de evento, sin intervención del actor.
2. Los registros no pueden ser modificados ni eliminados por ningún usuario, incluido el administrador de la plataforma.
3. Cada registro contiene al menos: tipo de evento, actor, marca de tiempo, organización y recurso afectado.
4. Los registros de una organización son visibles únicamente para el administrador de esa organización y para el administrador de la plataforma.
5. El sistema garantiza la escritura del registro incluso si la operación principal falla parcialmente; el registro refleja el intento y su resultado.

**Riesgos y mitigaciones**
- Registros que no se generan ante fallos del sistema → el registro de eventos se escribe de forma preferente, con mecanismos de reintento ante fallos transitorios.
- Acceso no autorizado a registros de auditoría → los registros de cada organización están aislados y solo son accesibles por actores autorizados (RNF02).

---

[← Índice](../README.md) | [< Anterior](rf17-integracion-proveedores-pago.md) | [Siguiente >](rf19-trazabilidad-acciones.md)
