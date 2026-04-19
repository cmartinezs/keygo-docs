# CU-GE-05 — Importar alumnos desde CSV

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-02 | Gestionar alumnos

### RF relacionados: RF1, RF3, RF13

**Actor principal:** Administrador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Administrador cargue múltiples alumnos desde un archivo CSV estandarizado, asociándolos automáticamente a cursos.

### Precondiciones
- Usuario autenticado con rol de Administrador.
- Archivo CSV sigue la estructura predefinida (identificador, nombre, correo, curso).

### Postcondiciones
- Los alumnos quedan registrados en el sistema.
- Cada alumno queda asociado al curso correspondiente.
- Se genera reporte de éxito y errores de importación.

### Flujo principal (éxito)
1. El Administrador accede al módulo de gestión de alumnos.
2. Selecciona la opción **“Importar desde CSV”**.
3. El Sistema muestra ejemplo de plantilla con columnas requeridas.
4. El Administrador sube el archivo CSV.
5. El Sistema valida estructura y datos.
6. El Sistema registra los alumnos válidos y los asocia a cursos.
7. El Sistema genera reporte con filas correctas y con error.
8. El Sistema confirma importación exitosa.

### Flujos alternativos / Excepciones
- **A1 — Archivo inválido:** El Sistema bloquea carga y muestra errores.
- **A2 — Duplicados en archivo:** El Sistema descarta registros duplicados e informa en el reporte.
- **A3 — Curso inexistente:** El Sistema bloquea asociación y reporta error.

### Reglas de negocio
- **RN-1:** Identificador de alumno debe ser único en todo el sistema.
- **RN-2:** Los alumnos importados deben quedar en estado **Activo** por defecto.

### Datos principales
- **Archivo CSV**(nombre, tamaño, fecha de carga).
- **Alumno**(ID, identificador, nombre, correo, cursos asociados, estado, timestamps).
- **Reporte de importación**(total filas, válidas, con error).

### Consideraciones de seguridad/permiso
- Validar permisos de Administrador antes de permitir importación.
- Validar seguridad del archivo para evitar inyección de datos maliciosos.

### No funcionales
- **Rendimiento:** importación de 500 alumnos < 1 minuto.
- **Usabilidad:** reporte claro con detalle de errores por línea.

### Criterios de aceptación (QA)
- **CA-1:** Al subir un CSV válido, los alumnos quedan registrados y asociados a cursos.
- **CA-2:** Si hay errores, el sistema muestra reporte con detalle por fila.
- **CA-3:** Los duplicados se bloquean y se registran en el reporte.
- **CA-4:** El registro de importación queda en auditoría.  