[← Índice](../README.md) | [< Anterior](rnf02-aislamiento-organizaciones.md) | [Siguiente >](rnf04-disponibilidad-resiliencia.md)

---

# RNF03 — Privacidad de datos

**Descripción**
El sistema debe proteger los datos personales de los usuarios conforme a los principios de minimización, propósito y retención definidos, y debe facilitar el cumplimiento de las obligaciones de privacidad aplicables.

**Alcance incluye**
- Recolección y almacenamiento únicamente de los datos personales estrictamente necesarios para la operación de la plataforma.
- Definición de períodos de retención para datos de usuarios y registros de operación.
- Capacidad de eliminar los datos de un usuario de forma definitiva al concluir el período de retención.
- Protección de datos personales incluidos en registros de auditoría: acceso restringido y sin exposición innecesaria.
- Las credenciales de sesión incluyen únicamente los atributos del usuario necesarios para el contexto de uso.

**No incluye (MVP)**
- Portabilidad de datos en formato estructurado exportable por el usuario.
- Gestión de consentimientos granulares por tipo de dato.
- Certificación formal de cumplimiento normativo (GDPR, LGPD, etc.) en el MVP.

**Dependencias**
- RNF01 (Seguridad).
- RNF02 (Aislamiento entre organizaciones).

**Criterios de aceptación**
1. El sistema no almacena datos personales más allá de los necesarios para la operación declarada.
2. Los datos de un usuario eliminado son purgados de forma definitiva al concluir el período de retención configurado.
3. Los registros de auditoría que contienen datos personales solo son accesibles por actores autorizados.
4. Las credenciales de sesión no incluyen datos personales más allá de los necesarios para el contexto de la aplicación cliente.
5. El período de retención de datos es configurable por el administrador de la plataforma.

**Riesgos y mitigaciones**
- Datos personales almacenados en registros de operación de forma inadvertida → los registros se diseñan con campos estructurados; los valores de datos personales se omiten o se reemplazan por identificadores no sensibles.
- Retención indefinida por omisión → la retención tiene un valor predeterminado explícito; la ausencia de configuración no implica retención ilimitada.

---

[← Índice](../README.md) | [< Anterior](rnf02-aislamiento-organizaciones.md) | [Siguiente >](rnf04-disponibilidad-resiliencia.md)
