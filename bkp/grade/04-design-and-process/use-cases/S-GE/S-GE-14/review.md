# Apreciación CU-GE-21 — Consultar historial de auditoría

- [Volver](../../README.md#2-gestión-de-evaluación)

### Qué cubre
- Acceso al historial completo de acciones realizadas en el sistema.
- Filtros por usuario, evaluación, rango de fechas y tipo de acción.
- Visualización de resultados con detalle de usuario, fecha/hora, acción y estado (éxito/error).
- Registro de la propia consulta en la auditoría.

### Escenario lo justifica
- En S-GE-14, Carlos M. necesita revisar quién hizo cambios en una evaluación y en qué momento.
- El sistema asegura trazabilidad y respaldo para procesos de control y auditorías.

### ¿Es suficiente como CU separado?
✅ Sí. La consulta de historial es un proceso específico, independiente de la exportación, con flujos y reglas de negocio propias.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Evolutivos posibles: vistas gráficas de auditoría, alertas automáticas ante patrones sospechosos, integración con sistemas de compliance.

### Apreciación final
El CU-GE-21 está correctamente definido y suficiente para cubrir la **consulta del historial de auditoría** en S-GE-14.

---

# Apreciación CU-GE-22 — Exportar historial de auditoría

### Qué cubre
- Generación de un archivo CSV con los resultados de una consulta de auditoría.
- Inclusión de todos los campos visibles y respetando los filtros aplicados.
- Registro de la exportación en la propia auditoría para garantizar trazabilidad.

### Escenario lo justifica
- En S-GE-14, Carlos M. debe presentar informes institucionales y necesita exportar el historial de acciones.
- El sistema ofrece la exportación en CSV, asegurando compatibilidad y portabilidad.

### ¿Es suficiente como CU separado?
✅ Sí. La exportación es un proceso adicional a la consulta, con reglas y flujos propios (generación de archivo, descarga, registro).

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Evolutivos posibles: exportación en PDF, envío automático por correo, integraciones con herramientas de BI.

### Apreciación final
El CU-GE-22 está correctamente definido y suficiente para cubrir la **exportación del historial de auditoría** en S-GE-14.  
