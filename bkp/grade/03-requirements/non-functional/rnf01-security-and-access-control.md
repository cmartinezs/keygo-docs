# RNF1 — Seguridad y control de acceso

**Descripción (alto nivel)**  
GRADE debe garantizar la **seguridad del acceso al sistema** y la protección de la información, mediante autenticación robusta, autorización granular y cifrado de datos.

**Alcance incluye**
- **Autenticación robusta** para todos los usuarios (mínimo usuario/contraseña con políticas de complejidad).
- **Autorización basada en roles** (RF7) para limitar accesos a funciones y datos.
- **Cifrado de datos en tránsito (TLS/HTTPS)** y en reposo (base de datos, respaldos).
- **Protección de credenciales**: almacenamiento con hash seguro y rotación periódica de claves.
- **Bitácoras de acceso** registradas en auditoría (RF8).
- **Mecanismos de prevención de ataques comunes** (fuerza bruta, inyección, CSRF).

**No incluye (MVP)**
- Integración con SSO institucional (cubierto en RF16, fase posterior).
- Mecanismos biométricos o multifactor avanzados (posibles evoluciones futuras).

**Dependencias**
- RF7 (Roles y permisos).
- RF8 (Auditoría).

**Criterios de aceptación (CA)**
1. Todos los accesos al sistema requieren **autenticación válida**.
2. Cada usuario puede acceder solo a las funciones que le permite su **rol asignado**.
3. Los datos sensibles viajan siempre **cifrados con TLS**.
4. Las contraseñas se almacenan con **algoritmo de hash seguro**.
5. Cada intento de acceso (exitoso o fallido) queda **registrado en auditoría**.
6. El sistema bloquea accesos tras varios intentos fallidos consecutivos.

**Riesgos/mitigaciones**
- Ataques de fuerza bruta → bloqueo progresivo de intentos fallidos.
- Fuga de credenciales → cifrado de datos y rotación de claves.
- Vulnerabilidades de inyección → validación y sanitización de entradas.
