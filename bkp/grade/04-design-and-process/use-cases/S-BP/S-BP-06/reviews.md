# Apreciación CU-BP-09 — Consultar trazabilidad de ítem

- [Volver](../../README.md#1-banco-de-preguntas)

### Qué cubre
- Consulta directa del historial de uso de un ítem.
- Muestra evaluaciones asociadas, número de respuestas, tasa de acierto y fecha de última utilización.
- Permite análisis pedagógico y decisiones de gestión basadas en evidencia.

### Escenario lo justifica
- En S-BP-05, Maxi necesita revisar en qué evaluaciones se usó un ítem y su desempeño.
- El sistema entrega la trazabilidad completa con métricas agregadas.
- Responde a la necesidad de controlar la calidad y frecuencia de uso de las preguntas.

### ¿Es suficiente como CU separado?
✅ Sí. Es una funcionalidad claramente diferenciada de crear, editar o retirar ítems.  
Su propósito es **informar y analizar**, no modificar.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Funciones como **comparar trazabilidad entre ítems** o **consultar tendencias globales** pueden considerarse evolutivas, pero no son parte del escenario descrito.

### Apreciación final
El CU-BP-09 está completo y suficiente para cubrir la acción de **consultar trazabilidad de un ítem**.  
No se requieren CUs adicionales en este escenario.

---

# Apreciación CU-BP-10 — Generar reporte de trazabilidad

### Qué cubre
- Generación de un archivo descargable (CSV o PDF) con la trazabilidad de un ítem.
- Incluye evaluaciones, métricas de desempeño y metadatos relevantes.
- Facilita análisis externo, auditoría y respaldo documental.

### Escenario lo justifica
- En S-BP-05, además de visualizar trazabilidad en pantalla, resulta útil **exportar la información** para análisis pedagógico o informes institucionales.
- El reporte aporta trazabilidad formal y registro de consulta.

### ¿Es suficiente como CU separado?
✅ Sí. Aunque se apoya en CU-BP-09, la exportación merece su propio CU porque implica generación de archivos, permisos y reglas de negocio distintas.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Funciones como **programar reportes automáticos** o **enviar reportes por correo** pueden plantearse como mejoras futuras, pero no forman parte del alcance actual.

### Apreciación final
El CU-BP-10 está bien definido y complementa a CU-BP-09.  
Juntos cubren la trazabilidad tanto en consulta como en generación de reportes.  
