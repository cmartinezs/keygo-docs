[← Índice](../README.md) | [Siguiente >](rnf02-aislamiento-organizaciones.md)

---

# RNF01 — Seguridad

**Descripción**
El sistema debe proteger la confidencialidad, integridad y disponibilidad de los datos y operaciones, aplicando prácticas de seguridad desde el diseño y en todos los niveles de la plataforma.

**Alcance incluye**
- Protección de las credenciales de usuarios: almacenadas de forma que no puedan ser recuperadas en texto plano.
- Protección de las credenciales de aplicaciones cliente.
- Cifrado de datos en tránsito entre todos los actores del sistema.
- Cifrado de datos sensibles en reposo.
- Protección contra ataques comunes de aplicaciones web: inyección, falsificación de solicitudes, manipulación de sesiones, entre otros.
- Control de acceso estricto a las operaciones de la plataforma según el rol del actor.
- Validación de entradas en todos los puntos de recepción de datos externos.

**No incluye (MVP)**
- Gestión de vulnerabilidades de terceros (análisis de dependencias automatizado).
- Certificaciones de seguridad formales (SOC 2, ISO 27001) en el MVP.

**Dependencias**
- RNF02 (Aislamiento entre organizaciones).
- RNF03 (Privacidad de datos).
- RNF12 (Gestión del ciclo de vida de claves).

**Criterios de aceptación**
1. Las contraseñas no se almacenan en texto plano ni en formatos reversibles.
2. Toda comunicación entre actores del sistema utiliza canales cifrados.
3. Las operaciones administrativas requieren autenticación y autorización explícita del actor.
4. El sistema rechaza entradas malformadas o que excedan los rangos esperados sin propagar el error a capas internas.
5. Las credenciales de cliente de las aplicaciones no son recuperables en texto plano tras su creación.

**Riesgos y mitigaciones**
- Brecha de credenciales almacenadas → almacenamiento con funciones de derivación de contraseñas resistentes a ataques de fuerza bruta.
- Ataques sobre el canal de comunicación → cifrado obligatorio en tránsito sin excepciones, incluso en entornos internos.

---

[← Índice](../README.md) | [Siguiente >](rnf02-aislamiento-organizaciones.md)
