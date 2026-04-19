[← Índice](../README.md) | [< Anterior](rnf09-usabilidad.md) | [Siguiente >](rnf11-cumplimiento-gobernanza.md)

---

# RNF10 — Compatibilidad con estándares abiertos

**Descripción**
El sistema debe basar sus mecanismos de autenticación, autorización e interoperabilidad en estándares abiertos ampliamente adoptados, de forma que las aplicaciones cliente puedan integrarse usando herramientas y bibliotecas estándar del ecosistema.

**Alcance incluye**
- Los flujos de autenticación delegada siguen protocolos de autorización e identidad reconocidos por la industria.
- Las credenciales de sesión tienen un formato estructurado y verificable compatible con el ecosistema de aplicaciones.
- La verificación pública de credenciales sigue un formato estándar de publicación de claves.
- La información de identidad del usuario se expone en un formato normalizado.
- La integración con la plataforma no requiere bibliotecas propietarias de Keygo en las aplicaciones cliente.

**No incluye (MVP)**
- Soporte a estándares de federación de identidad entre plataformas externas.
- Certificación formal de conformidad con estándares específicos en el MVP.

**Dependencias**
- RF11 (Emisión de credenciales de sesión).
- RF12 (Verificación de credenciales de sesión).
- RF13 (Verificación pública de credenciales).

**Criterios de aceptación**
1. Una aplicación cliente puede integrarse con la plataforma usando herramientas estándar del ecosistema sin dependencia de SDKs propietarios de Keygo.
2. Las credenciales de sesión pueden ser verificadas por cualquier herramienta compatible con el formato estándar utilizado.
3. Las claves públicas de verificación se publican en un formato estándar consultable por herramientas del ecosistema.
4. La información de identidad del usuario retornada al finalizar la autenticación sigue un esquema normalizado.
5. Las guías de integración son aplicables a cualquier plataforma de desarrollo sin dependencia de lenguaje o entorno específico.

**Riesgos y mitigaciones**
- Extensiones propietarias que rompan la compatibilidad con clientes estándar → cualquier extensión sobre los estándares base se implementa de forma que no interfiera con el comportamiento estándar esperado.
- Evolución de estándares que requiera actualización → el diseño aísla las dependencias de estándares para facilitar su actualización sin impacto en la lógica de negocio.

---

[← Índice](../README.md) | [< Anterior](rnf09-usabilidad.md) | [Siguiente >](rnf11-cumplimiento-gobernanza.md)
