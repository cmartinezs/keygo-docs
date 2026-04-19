[← Índice](../README.md) | [< Anterior](rf19-trazabilidad-acciones.md) | [Siguiente >](rf21-operacion-plataforma.md)

---

# RF20 — Administración global de la plataforma

**Descripción**
El sistema debe proveer al equipo operativo de Keygo las capacidades para gestionar el ciclo de vida de las organizaciones a nivel de plataforma, garantizando que los administradores globales puedan supervisar y actuar sobre cualquier organización sin interferir en sus datos internos.

**Alcance incluye**
- Consulta del listado de organizaciones registradas en la plataforma con filtros por estado.
- Activación de una organización recién registrada.
- Suspensión de una organización activa, con efecto inmediato sobre todos sus usuarios y aplicaciones.
- Reactivación de una organización suspendida.
- Eliminación definitiva de una organización, sujeta a confirmación explícita y período de retención.
- Cambio del plan de suscripción de una organización.
- Consulta del uso operativo agregado de la plataforma.

**No incluye (MVP)**
- Acceso al contenido interno de una organización (usuarios, aplicaciones, configuraciones).
- Impersonación de usuarios o administradores de organización.
- Delegación de permisos de administración global a actores externos.

**Dependencias**
- RF01 (Gestión de organizaciones).
- RF15 (Gestión de suscripciones).
- RF18 (Registro de eventos).
- RF21 (Operación de la plataforma).

**Criterios de aceptación**
1. El administrador de la plataforma puede ver y filtrar todas las organizaciones registradas.
2. Las acciones de activación, suspensión y eliminación sobre una organización tienen efecto inmediato.
3. El administrador global no puede acceder ni modificar datos internos de una organización (usuarios, aplicaciones, configuraciones).
4. Todas las acciones del administrador global quedan registradas en el registro de auditoría (RF18).
5. Solo los actores con rol de administrador global pueden ejecutar estas operaciones.

**Riesgos y mitigaciones**
- Suspensión accidental de organización activa con clientes reales → confirmación explícita requerida; la suspensión es reversible.
- Privilegio excesivo del administrador global → el rol global tiene capacidad de gestión del ciclo de vida, no de acceso a datos internos de las organizaciones.

---

[← Índice](../README.md) | [< Anterior](rf19-trazabilidad-acciones.md) | [Siguiente >](rf21-operacion-plataforma.md)
