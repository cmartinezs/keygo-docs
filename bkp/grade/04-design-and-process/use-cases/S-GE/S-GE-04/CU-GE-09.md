# CU-GE-09 — Generar entregable con identificador único

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-04 | Generar entregable con ID/QR

### RF relacionados: RF1, RF3, RF8

**Actor principal:** Docente  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Docente genere un archivo PDF de la evaluación en borrador, asignando un identificador único (código, QR o marca de agua) a cada copia para garantizar trazabilidad.

### Precondiciones
- Usuario autenticado con permisos de Docente o Coordinador.
- El curso existe y está activo (CU-GE-01).
- Los alumnos están asociados al curso (CU-GE-04 / CU-GE-05).
- La evaluación existe y está en estado **Borrador** (CU-GE-07).

### Postcondiciones
- El sistema genera un PDF con identificador único en cada copia.
- El estado de la evaluación cambia a **Listo para aplicar**.
- La acción queda registrada en el historial de auditoría.

### Flujo principal (éxito)
1. El Docente accede a una evaluación en estado **Borrador**.
2. Selecciona la opción **“Generar entregable”**.
3. El Sistema genera un identificador único para la evaluación y cada copia (ej.: QR por estudiante o folio).
4. El Sistema inserta el identificador en el PDF de la evaluación (encabezado, pie o marca de agua).
5. El Sistema produce el archivo en formato PDF.
6. El Sistema cambia el estado de la evaluación a **Listo para aplicar**.
7. El Sistema registra la acción en auditoría.
8. El Sistema confirma la generación y deja el archivo disponible para descarga.

### Flujos alternativos / Excepciones
- **A1 — Evaluación no en estado Borrador:** El Sistema bloquea la acción e informa al Docente.
- **A2 — Error en generación de PDF:** El Sistema muestra mensaje y permite reintentar.
- **A3 — Falla en asignación de identificador:** El Sistema cancela la operación y registra el error.

### Reglas de negocio
- **RN-1:** Cada entregable debe contar con un identificador único no repetible.
- **RN-2:** La evaluación debe cambiar automáticamente a estado **Listo para aplicar** tras la generación.
- **RN-3:** Los entregables generados deben estar disponibles solo para usuarios autorizados.

### Datos principales
- **Evaluación**(ID, curso, estado, ítems asociados, timestamps).
- **Entregable**(ID entregable, ID evaluación, identificador único, archivo PDF, fecha de generación).
- **Auditoría**(usuario, acción, fecha/hora).

### Consideraciones de seguridad/permiso
- Solo el creador de la evaluación o un Coordinador autorizado puede generar entregables.
- El archivo PDF debe quedar protegido frente a modificaciones externas no autorizadas.

### No funcionales
- **Rendimiento:** generación de entregables < 10s p95 para hasta 100 copias.
- **Seguridad:** el identificador único debe ser irrepetible y verificable.
- **Disponibilidad:** el entregable debe estar disponible inmediatamente para descarga.

### Criterios de aceptación (QA)
- **CA-1:** Al generar entregable, cada copia contiene identificador único visible.
- **CA-2:** La evaluación cambia a estado **Listo para aplicar** automáticamente.
- **CA-3:** La acción queda registrada en auditoría.
- **CA-4:** El PDF se genera correctamente y queda disponible para descarga.  