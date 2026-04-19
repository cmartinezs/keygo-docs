[← Índice](../README.md) | [< Anterior](rf12-verificacion-credenciales-sesion.md) | [Siguiente >](rf14-gestion-sesiones.md)

---

# RF13 — Verificación pública de credenciales

**Descripción**
El sistema debe publicar la información criptográfica necesaria para que cualquier aplicación cliente pueda verificar la autenticidad de las credenciales de sesión de forma autónoma, sin necesidad de realizar una llamada directa a la plataforma en cada operación.

**Alcance incluye**
- Publicación de las claves públicas de verificación en un punto de acceso conocido y estable.
- Actualización automática del punto de acceso cuando se rotan las claves de firma.
- Soporte a la coexistencia de múltiples claves activas durante el período de transición de una rotación.
- Las aplicaciones cliente pueden obtener y cachear las claves para verificar credenciales de forma local.

**No incluye (MVP)**
- Publicación de claves diferenciada por aplicación cliente o por organización.
- Soporte a algoritmos de firma múltiples simultáneamente en el MVP inicial.

**Dependencias**
- RF11 (Emisión de credenciales de sesión).
- RF12 (Verificación de credenciales de sesión).
- RNF12 (Gestión del ciclo de vida de claves).

**Criterios de aceptación**
1. El punto de acceso de claves públicas está disponible sin autenticación para cualquier consumidor.
2. Las claves publicadas son suficientes para verificar todas las credenciales de sesión vigentes emitidas por la plataforma.
3. Tras una rotación de claves, las credenciales emitidas con la clave anterior siguen siendo verificables durante su período de vigencia.
4. El punto de acceso refleja el conjunto actualizado de claves en un plazo acotado tras cada rotación.
5. Una aplicación cliente que cachea las claves puede detectar que necesita refrescar su caché cuando encuentra una credencial firmada con una clave desconocida.

**Riesgos y mitigaciones**
- Aplicaciones que no actualizan su caché de claves → el mecanismo debe indicar claramente cuándo una clave desconocida requiere refrescar la información publicada.
- Clave comprometida publicada → el proceso de rotación permite revocar una clave y reemplazarla sin interrumpir la verificación de credenciales vigentes emitidas antes de la rotación.

---

[← Índice](../README.md) | [< Anterior](rf12-verificacion-credenciales-sesion.md) | [Siguiente >](rf14-gestion-sesiones.md)
