[← Índice](../README.md) | [< Anterior](rf11-emision-credenciales-sesion.md) | [Siguiente >](rf13-verificacion-publica-credenciales.md)

---

# RF12 — Verificación de credenciales de sesión

**Descripción**
El sistema debe permitir que las aplicaciones cliente verifiquen la validez y el contenido de las credenciales de sesión emitidas por la plataforma, ya sea mediante una llamada directa a la plataforma o de forma autónoma.

**Alcance incluye**
- Exposición de un mecanismo para que las aplicaciones cliente verifiquen si unas credenciales de sesión son válidas y vigentes.
- Retorno del estado de las credenciales: activas, expiradas o revocadas.
- Retorno de los atributos del usuario incluidos en las credenciales: organización, roles, ámbitos, identidad básica.
- Soporte para verificación sin contacto a la plataforma cuando las credenciales son verificables de forma autónoma (RF13).

**No incluye (MVP)**
- Verificación de credenciales de sesión emitidas por terceros externos.
- Traducción o conversión entre formatos de credenciales.

**Dependencias**
- RF11 (Emisión de credenciales de sesión).
- RF13 (Verificación pública de credenciales).
- RF14 (Gestión de sesiones).
- RNF13 (Consistencia de credenciales de sesión).

**Criterios de aceptación**
1. Una aplicación cliente puede verificar la validez de unas credenciales de sesión usando los mecanismos provistos por la plataforma.
2. Las credenciales revocadas son rechazadas, incluso si no han expirado por tiempo.
3. La respuesta de verificación incluye los atributos relevantes del usuario codificados en las credenciales.
4. Las credenciales expiradas son rechazadas con indicación de la causa.
5. La verificación es consistente: el mismo par de credenciales produce el mismo resultado en cualquier instancia de la plataforma.

**Riesgos y mitigaciones**
- Credenciales revocadas aceptadas por verificación local sin consulta a la plataforma → las credenciales de acceso tienen duración corta; la revocación inmediata requiere verificación en línea.
- Inconsistencia entre instancias → el estado de revocación se propaga de forma que todas las instancias puedan rechazar credenciales inválidas dentro de una ventana de tiempo acotada.

---

[← Índice](../README.md) | [< Anterior](rf11-emision-credenciales-sesion.md) | [Siguiente >](rf13-verificacion-publica-credenciales.md)
