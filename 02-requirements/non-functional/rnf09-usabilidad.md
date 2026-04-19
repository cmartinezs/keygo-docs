[← Índice](../README.md) | [< Anterior](rnf08-observabilidad.md) | [Siguiente >](rnf10-compatibilidad-estandares.md)

---

# RNF09 — Usabilidad

**Descripción**
El sistema debe proporcionar interfaces claras y flujos comprensibles tanto para los usuarios finales que se autentican como para los administradores que gestionan la plataforma, minimizando la fricción en las tareas más frecuentes.

**Alcance incluye**
- Flujo de autenticación de usuario con pasos mínimos y mensajes de error comprensibles.
- Mensajes de error que indiquen qué salió mal sin revelar información sensible de seguridad.
- Interfaces de administración que permitan completar las tareas más frecuentes (gestión de usuarios, aplicaciones, accesos) sin documentación adicional.
- Confirmación explícita antes de ejecutar operaciones destructivas o irreversibles.
- Retroalimentación visual o informativa ante acciones que tienen efecto inmediato.

**No incluye (MVP)**
- Personalización visual de la interfaz de autenticación por organización.
- Soporte a múltiples idiomas en el MVP inicial.
- Interfaz optimizada para accesibilidad según estándares específicos en el MVP.

**Dependencias**
- RF04 (Autenticación de usuarios).
- RF03 (Gestión de usuarios).
- RF06 (Registro de aplicaciones cliente).

**Criterios de aceptación**
1. Un usuario puede completar el flujo de autenticación sin instrucciones previas en condiciones normales.
2. Los mensajes de error ante autenticación fallida son informativos para el usuario sin revelar la causa exacta del fallo a potenciales atacantes.
3. Un administrador puede realizar las operaciones más frecuentes de gestión desde la interfaz sin necesidad de documentación adicional.
4. Las operaciones destructivas (eliminar usuario, revocar acceso, eliminar aplicación) requieren confirmación explícita.
5. La interfaz indica de forma clara cuando una operación tiene efecto inmediato e irreversible.

**Riesgos y mitigaciones**
- Mensajes de error que revelen información sensible → los mensajes de cara al usuario son genéricos; el detalle técnico queda en los registros operativos internos.
- Operaciones destructivas ejecutadas por error → confirmación obligatoria con descripción del impacto antes de proceder.

---

[← Índice](../README.md) | [< Anterior](rnf08-observabilidad.md) | [Siguiente >](rnf10-compatibilidad-estandares.md)
