[← Índice](../README.md) | [< Anterior](rf05-gestion-credenciales.md) | [Siguiente >](rf07-configuracion-aplicaciones-cliente.md)

---

# RF06 — Registro de aplicaciones cliente

**Descripción**
El sistema debe permitir que el administrador de organización registre las aplicaciones que podrán integrarse con la plataforma para autenticar y autorizar a sus usuarios.

**Alcance incluye**
- Registro de una nueva aplicación cliente dentro de la organización con sus atributos básicos: nombre, descripción, tipo de aplicación.
- Generación de un identificador único por aplicación, inmutable durante su ciclo de vida.
- Generación y gestión de credenciales de cliente para las aplicaciones que lo requieran según su tipo.
- Rotación de credenciales de cliente bajo demanda del administrador.
- Activación y desactivación de una aplicación cliente sin eliminarla.
- Eliminación definitiva de una aplicación cliente, sujeta a confirmación explícita.
- Consulta del catálogo de aplicaciones cliente registradas en la organización.

**No incluye (MVP)**
- Aprobación de aplicaciones por parte de usuarios finales (pantalla de consentimiento).
- Registro de aplicaciones desde marketplaces o catálogos externos.
- Aplicaciones cliente pertenecientes a más de una organización.

**Dependencias**
- RF01 (Gestión de organizaciones).
- RF07 (Configuración de aplicaciones cliente).
- RF08 (Acceso de usuarios a aplicaciones).
- RF18 (Registro de eventos).
- RNF02 (Aislamiento entre organizaciones).

**Criterios de aceptación**
1. El administrador puede registrar una nueva aplicación cliente con los datos mínimos requeridos.
2. Cada aplicación cliente tiene un identificador único que no cambia durante su ciclo de vida.
3. Las credenciales de cliente son visibles únicamente en el momento de su creación o rotación; no se pueden recuperar posteriormente.
4. Al desactivar una aplicación, los flujos de autenticación iniciados desde ella son rechazados de forma inmediata.
5. El administrador no puede ver ni gestionar aplicaciones de otras organizaciones.
6. Todas las acciones sobre aplicaciones cliente quedan registradas en el registro de auditoría (RF18).

**Riesgos y mitigaciones**
- Credenciales de cliente expuestas → visibilidad única al momento de creación/rotación; el sistema no las almacena en texto plano.
- Eliminación accidental de aplicación activa → confirmación explícita requerida; la desactivación es el paso previo recomendado.

---

[← Índice](../README.md) | [< Anterior](rf05-gestion-credenciales.md) | [Siguiente >](rf07-configuracion-aplicaciones-cliente.md)
