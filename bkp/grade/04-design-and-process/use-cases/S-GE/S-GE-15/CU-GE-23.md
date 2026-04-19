# CU-GE-23 — Configurar parámetros globales

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-15 | Administración del sistema

### RF relacionados: RF13, RF7, RF8

**Actor principal:** Administrador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Administrador configure parámetros globales del sistema, como escalas de calificación, límites de ítems por evaluación o tiempos máximos, alineándolos a políticas institucionales.

### Precondiciones
- Usuario autenticado con rol de Administrador.
- El sistema se encuentra en operación normal.

### Postcondiciones
- Los parámetros globales quedan actualizados y aplican a todas las evaluaciones futuras.
- La acción queda registrada en la auditoría.

### Flujo principal (éxito)
1. El Administrador accede al módulo **Administración del sistema**.
2. Selecciona la opción **“Parámetros globales”**.
3. El Sistema muestra parámetros configurables (escala de notas, máximos de ítems, límites de tiempo).
4. El Administrador modifica los valores y guarda cambios.
5. El Sistema valida consistencia de los parámetros (ej. rango válido de notas).
6. El Sistema actualiza la configuración global.
7. El Sistema registra la acción en auditoría.
8. El Sistema confirma la actualización exitosa.

### Flujos alternativos / Excepciones
- **A1 — Valores inválidos:** El Sistema bloquea la acción e informa error.
- **A2 — Falta de permisos:** El Sistema impide acceso a usuarios no administradores.
- **A3 — Error al guardar:** El Sistema permite reintentar y mantiene configuración anterior.

### Reglas de negocio
- **RN-1:** Toda configuración debe tener valores válidos según rango definido (ej. escala de notas).
- **RN-2:** Cambios solo aplican a evaluaciones futuras, no a evaluaciones ya publicadas.
- **RN-3:** Toda acción de configuración debe quedar registrada en auditoría.

### Datos principales
- **Parámetros globales**(escala de notas, límites de ítems, tiempos máximos, fecha última modificación).
- **Auditoría**(usuario, acción, fecha/hora, valores anteriores/nuevos).

### Consideraciones de seguridad/permiso
- Solo usuarios con rol de Administrador pueden modificar parámetros globales.

### No funcionales
- **Disponibilidad:** cambios deben reflejarse inmediatamente en el sistema.
- **Integridad:** los valores antiguos deben quedar registrados para trazabilidad.

### Criterios de aceptación (QA)
- **CA-1:** El administrador puede modificar parámetros globales y guardarlos exitosamente.
- **CA-2:** El sistema bloquea valores fuera de rango.
- **CA-3:** Los cambios solo afectan evaluaciones futuras.
- **CA-4:** Todas las acciones quedan registradas en auditoría.  