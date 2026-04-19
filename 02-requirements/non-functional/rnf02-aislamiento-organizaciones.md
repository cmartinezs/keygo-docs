[← Índice](../README.md) | [< Anterior](rnf01-seguridad.md) | [Siguiente >](rnf03-privacidad-datos.md)

---

# RNF02 — Aislamiento entre organizaciones

**Descripción**
El sistema debe garantizar que los datos, configuraciones y operaciones de una organización estén completamente aislados de los de cualquier otra organización, sin posibilidad de acceso cruzado.

**Alcance incluye**
- Aislamiento lógico total entre organizaciones: ningún dato de una organización es accesible desde otra.
- Aplicación del aislamiento en todas las capas: operaciones, datos, credenciales de sesión emitidas y registros de auditoría.
- Garantía de que un administrador de organización no puede ver ni operar sobre datos de otras organizaciones.
- Garantía de que un usuario de una organización no puede autenticarse en aplicaciones de otra organización.
- Propagación del aislamiento a las credenciales de sesión: las credenciales incluyen la organización de origen y son válidas únicamente en ese contexto.

**No incluye (MVP)**
- Aislamiento a nivel de infraestructura dedicada por organización.
- Controles de aislamiento auditados externamente en el MVP.

**Dependencias**
- RNF01 (Seguridad).
- RNF03 (Privacidad de datos).

**Criterios de aceptación**
1. No existe ningún mecanismo por el que un usuario de la organización A pueda acceder a datos de la organización B.
2. Las credenciales de sesión de un usuario de la organización A son rechazadas por aplicaciones de la organización B.
3. El administrador de la organización A no puede ver usuarios, aplicaciones ni configuraciones de la organización B.
4. El registro de auditoría de cada organización es accesible únicamente por actores de esa organización o por el administrador global de la plataforma.
5. El aislamiento se mantiene incluso ante fallos parciales del sistema.

**Riesgos y mitigaciones**
- Error en la lógica de consultas que devuelva datos de otra organización → todas las operaciones de acceso a datos incluyen el contexto de organización como restricción no omitible.
- Credenciales de sesión sin atributo de organización → la organización es un atributo obligatorio en toda credencial emitida.

---

[← Índice](../README.md) | [< Anterior](rnf01-seguridad.md) | [Siguiente >](rnf03-privacidad-datos.md)
