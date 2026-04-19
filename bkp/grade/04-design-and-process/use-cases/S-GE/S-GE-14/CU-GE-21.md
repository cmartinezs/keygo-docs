# CU-GE-21 — Consultar historial de auditoría

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-14 | Auditoría y consulta de historial

### RF relacionados: RF8, RF7

**Actor principal:** Administrador  
**Actores secundarios:** Sistema GRADE, Coordinador (con permisos limitados)

---

### Objetivo
Permitir que un Administrador (o Coordinador autorizado) consulte el historial de acciones realizadas en el sistema, con opciones de filtrado por usuario, evaluación, fecha o tipo de acción.

### Precondiciones
- Usuario autenticado con permisos de acceso al módulo de auditoría.
- Existen registros de eventos en el sistema.

### Postcondiciones
- El usuario visualiza un listado de eventos con detalle de acción, usuario, fecha/hora y resultado.
- La consulta queda registrada en auditoría.

### Flujo principal (éxito)
1. El Administrador accede al módulo de Auditoría.
2. Selecciona filtros (usuario, evaluación, fecha, tipo de acción).
3. El Sistema ejecuta la búsqueda en el historial.
4. El Sistema presenta un listado con:
    - Usuario responsable.
    - Fecha y hora.
    - Acción realizada.
    - Resultado (éxito/error).
5. El Administrador revisa el historial en pantalla.

### Flujos alternativos / Excepciones
- **A1 — Sin resultados:** El Sistema informa que no existen registros según los filtros aplicados.
- **A2 — Filtros inválidos:** El Sistema muestra advertencia y solicita corrección.
- **A3 — Error en la consulta:** El Sistema informa fallo y permite reintentar.

### Reglas de negocio
- **RN-1:** Todos los eventos relevantes deben quedar registrados en la auditoría (alta, baja, cambios de estado, cargas, publicaciones, etc.).
- **RN-2:** Los registros no pueden ser alterados ni eliminados manualmente.
- **RN-3:** La consulta de historial también debe quedar registrada en auditoría.

### Datos principales
- **Evento auditoría**(ID, usuario, acción, recurso afectado, fecha/hora, resultado, detalles).
- **Filtros de búsqueda**(usuario, evaluación, fecha, tipo acción).

### Consideraciones de seguridad/permiso
- Solo Administradores (y Coordinadores con permisos específicos) pueden acceder al historial.
- Los datos deben protegerse contra modificaciones no autorizadas.

### No funcionales
- **Disponibilidad:** el historial debe estar disponible en todo momento.
- **Rendimiento:** consultas con hasta 10.000 registros deben resolverse en < 5s p95.
- **Integridad:** los registros de auditoría deben ser inmutables.

### Criterios de aceptación (QA)
- **CA-1:** El sistema permite filtrar eventos por usuario, evaluación, fecha y tipo de acción.
- **CA-2:** Cada evento muestra usuario, fecha/hora, acción y resultado.
- **CA-3:** Si no hay resultados, el sistema lo indica claramente.
- **CA-4:** Toda consulta queda registrada en la auditoría.  
