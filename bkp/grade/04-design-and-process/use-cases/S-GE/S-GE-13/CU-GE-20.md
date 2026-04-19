# CU-GE-20 — Configurar preferencias de notificación

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-13 | Notificar hitos

### RF relacionados: RF11

**Actor principal:** Docente / Coordinador / Administrador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que cada usuario configure **qué hitos** desea recibir, **por qué canales** (in-app; futuros: email, integraciones) y, opcionalmente, **horarios silenciosos**.

### Precondiciones
- Usuario autenticado.
- Canales disponibles habilitados por la institución.

### Postcondiciones
- Se almacenan las preferencias del usuario y se aplican a futuros envíos.
- El sistema respeta horarios silenciosos y canales seleccionados.

### Flujo principal (éxito)
1. El Usuario abre **Preferencias de notificación**.
2. El Sistema muestra tipos de hitos y canales disponibles.
3. El Usuario activa/desactiva hitos y canales; configura horarios silenciosos (opcional).
4. El Usuario guarda cambios.
5. El Sistema persiste preferencias y confirma.

### Flujos alternativos / Excepciones
- **A1 — Canal no disponible:** El Sistema lo deshabilita en la UI y explica el motivo.
- **A2 — Configuración inconsistente (todos off):** El Sistema solicita al menos un canal por hito crítico.

### Reglas de negocio
- **RN-1:** Eventos críticos (p. ej., errores de ingesta) requieren al menos un canal activo salvo override institucional.
- **RN-2:** Preferencias por defecto: in-app habilitado para todos los hitos MVP.
- **RN-3:** Horarios silenciosos no aplican a notificaciones críticas (configurable).

### Datos principales
- **Preferencias de usuario**(hitos habilitados, canales, silencios, última actualización).
- **Catálogo de hitos**(clave, descripción, criticidad).

### Consideraciones de seguridad/permiso
- Solo el propio usuario (o un Admin) puede editar sus preferencias.
- Auditoría de cambios de preferencias.

### No funcionales
- **Usabilidad:** interfaz clara y accesible en < 3 clics.
- **Persistencia:** cambios reflejados de inmediato en el motor de notificaciones.

### Criterios de aceptación (QA)
- **CA-1:** El usuario puede activar/desactivar notificaciones por hito.
- **CA-2:** Las notificaciones posteriores respetan las preferencias guardadas.
- **CA-3:** Los eventos críticos no quedan totalmente silenciados si así lo define la política institucional.
- **CA-4:** Los cambios quedan registrados en auditoría.