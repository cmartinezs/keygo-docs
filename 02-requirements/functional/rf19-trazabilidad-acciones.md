[← Índice](../README.md) | [< Anterior](rf18-registro-eventos.md) | [Siguiente >](rf20-administracion-global-plataforma.md)

---

# RF19 — Trazabilidad de acciones

**Descripción**
El sistema debe permitir que los administradores consulten el historial de eventos registrados para investigar incidentes, auditar comportamientos y hacer seguimiento de acciones específicas de usuarios, aplicaciones u organizaciones.

**Alcance incluye**
- Consulta del historial de eventos de la organización por parte del administrador de organización.
- Consulta del historial de eventos de cualquier organización por parte del administrador de la plataforma.
- Filtrado del historial por: tipo de evento, actor, recurso afectado y rango de fechas.
- Visualización del detalle de cada evento: todos los atributos registrados.
- Paginación del historial para conjuntos de datos grandes.

**No incluye (MVP)**
- Exportación del historial a formatos externos (CSV, JSON, SIEM).
- Búsqueda de texto libre sobre el contenido de los registros.
- Alertas o notificaciones automáticas basadas en patrones del historial.

**Dependencias**
- RF18 (Registro de eventos).

**Criterios de aceptación**
1. El administrador de organización puede consultar todos los eventos de su organización dentro del período de retención definido.
2. Los filtros disponibles permiten acotar los resultados por tipo de evento, actor, recurso y rango de fechas.
3. El administrador no puede acceder al historial de otras organizaciones.
4. El administrador de la plataforma puede consultar el historial de cualquier organización.
5. La consulta del historial no afecta el rendimiento de las operaciones operativas de la plataforma.

**Riesgos y mitigaciones**
- Historial inaccesible bajo carga alta → la consulta de auditoría opera sobre una ruta de lectura separada de las operaciones críticas de autenticación.
- Volumen de datos que degrada las consultas → paginación obligatoria y filtros que evitan consultas sin acotación temporal excesiva.

---

[← Índice](../README.md) | [< Anterior](rf18-registro-eventos.md) | [Siguiente >](rf20-administracion-global-plataforma.md)
