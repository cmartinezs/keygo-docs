# CU-GE-22 — Exportar historial de auditoría

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-14 | Auditoría y consulta de historial

### RF relacionados: RF8, RF7

**Actor principal:** Administrador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Administrador exporte los resultados de una consulta de auditoría en formato **CSV**, para respaldo o presentación en informes institucionales.

### Precondiciones
- Usuario autenticado con permisos de acceso al módulo de auditoría.
- Se ha realizado previamente una consulta con resultados.

### Postcondiciones
- El archivo CSV queda generado y disponible para descarga.
- El evento de exportación queda registrado en auditoría.

### Flujo principal (éxito)
1. El Administrador ejecuta una consulta de auditoría.
2. Selecciona la opción **“Exportar resultados”**.
3. El Sistema genera un archivo CSV con los registros filtrados.
4. El Sistema habilita la descarga del archivo.
5. El Sistema registra la exportación en auditoría.

### Flujos alternativos / Excepciones
- **A1 — Sin resultados a exportar:** El Sistema bloquea la exportación e informa.
- **A2 — Error en generación de archivo:** El Sistema informa fallo y permite reintentar.

### Reglas de negocio
- **RN-1:** El CSV debe incluir todos los campos visibles en la consulta.
- **RN-2:** La exportación debe respetar los filtros aplicados en la búsqueda.
- **RN-3:** Cada exportación debe quedar registrada en auditoría.

### Datos principales
- **Archivo CSV**(nombre, tamaño, fecha/hora, usuario exportador).
- **Evento auditoría exportado**(detalle de los registros incluidos).

### Consideraciones de seguridad/permiso
- Solo Administradores autorizados pueden exportar auditorías completas.
- Los archivos deben protegerse contra accesos no autorizados.

### No funcionales
- **Rendimiento:** generación de archivos con hasta 10.000 registros en < 10s p95.
- **Compatibilidad:** CSV estándar UTF-8.
- **Trazabilidad:** exportación registrada en auditoría.

### Criterios de aceptación (QA)
- **CA-1:** El Administrador puede exportar en CSV los resultados de una consulta de auditoría.
- **CA-2:** El archivo contiene los mismos registros y filtros aplicados en la consulta.
- **CA-3:** Cada exportación queda registrada en auditoría.
- **CA-4:** Si no hay resultados, el sistema bloquea la exportación.  