[← Índice](../README.md) | [< Anterior](rnf11-cumplimiento-gobernanza.md) | [Siguiente >](rnf13-consistencia-credenciales-sesion.md)

---

# RNF12 — Gestión del ciclo de vida de claves

**Descripción**
El sistema debe gestionar el ciclo de vida completo de las claves criptográficas utilizadas para firmar y verificar las credenciales de sesión, garantizando que la rotación y revocación de claves no interrumpa el servicio ni deje credenciales emitidas sin posibilidad de verificación.

**Alcance incluye**
- Generación de claves criptográficas para la firma de credenciales de sesión.
- Rotación planificada de claves: sustitución de la clave activa manteniendo las claves anteriores durante el período de transición.
- Rotación de emergencia: sustitución inmediata de una clave comprometida con impacto mínimo en el servicio.
- Las credenciales emitidas con una clave anterior son verificables hasta su expiración natural.
- Publicación actualizada de las claves activas para verificación autónoma (RF13).
- Retiro definitivo de claves una vez que ninguna credencial emitida con ellas esté vigente.

**No incluye (MVP)**
- Claves diferenciadas por organización en el MVP; la firma es a nivel de plataforma.
- Almacenamiento de claves en módulos de seguridad de hardware en el MVP inicial.

**Dependencias**
- RF11 (Emisión de credenciales de sesión).
- RF13 (Verificación pública de credenciales).
- RF21 (Operación de la plataforma).

**Criterios de aceptación**
1. La rotación planificada de claves no invalida las credenciales de sesión vigentes emitidas antes de la rotación.
2. Tras una rotación, las nuevas credenciales se firman con la nueva clave y las anteriores siguen siendo verificables con la clave correspondiente.
3. El punto de verificación pública se actualiza automáticamente tras cada rotación, reflejando tanto la nueva clave como las anteriores aún vigentes.
4. Una rotación de emergencia puede ejecutarse sin interrupción del flujo de autenticación.
5. Las claves retiradas no son accesibles ni utilizables una vez que su período de transición ha concluido.

**Riesgos y mitigaciones**
- Clave comprometida que invalide la confianza en todas las credenciales emitidas → la rotación de emergencia revoca la clave comprometida; las credenciales emitidas con ella quedan inválidas; el impacto en usuarios se limita a reautenticación.
- Aplicaciones que no actualizan su caché de claves → el mecanismo de verificación pública (RF13) incluye señales para que los consumidores detecten cuándo necesitan refrescar su caché.

---

[← Índice](../README.md) | [< Anterior](rnf11-cumplimiento-gobernanza.md) | [Siguiente >](rnf13-consistencia-credenciales-sesion.md)
