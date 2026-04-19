# RF5 — Calificación automática de ítems objetivos

**Descripción (alto nivel)**  
GRADE debe **calificar automáticamente** las respuestas de los estudiantes para ítems cerrados (selección múltiple, verdadero/falso, opción única, etc.), calculando puntajes y convirtiéndolos en notas según reglas configurables.

**Alcance incluye**
- Procesamiento de respuestas cargadas (RF4) contra la **clave de corrección** definida en la evaluación.
- Soporte para ítems de tipo **cerrado/objetivo** (única respuesta correcta o múltiple).
- Cálculo automático de **puntajes brutos** por estudiante.
- Conversión de puntajes a **notas/escala definida** (ej. 1–7, 0–100).
- Generación de **reportes individuales** de calificación por estudiante.
- Registro de resultados en el **historial del sistema**.

**No incluye (MVP)**
- Evaluación de ítems abiertos o ensayos con rúbricas complejas.
- Ajustes manuales en la nota final dentro del sistema (solo automatización).
- Algoritmos de IA para interpretación de respuestas ambiguas.

**Dependencias**
- RF1 (Ciclo de evaluación centralizado).
- RF3 (Gestión de evaluaciones y entregables).
- RF4 (Ingesta de respuestas multicanal).
- RF8 (Auditoría).

**Criterios de aceptación (CA)**
1. El sistema puede **comparar respuestas** con la clave de corrección configurada.
2. Cada estudiante obtiene un **puntaje automático** en base a sus respuestas.
3. El puntaje se **convierte automáticamente** a nota según la escala definida.
4. Los resultados individuales se **guardan en el sistema** y se asocian a la evaluación.
5. Los docentes pueden **consultar y exportar** los resultados obtenidos.
6. Todo el proceso queda **registrado en la auditoría**.
7. El cálculo ocurre en **tiempos acotados** (nivel de minutos por evaluación).

**Riesgos/mitigaciones**
- Errores en la clave → validaciones previas a la calificación (ej. ítems sin respuesta correcta marcada).
- Escalas mal configuradas → reglas parametrizables y mensajes de advertencia.
- Carga excesiva en época de exámenes → diseño escalable del motor de calificación.

---

[< Anterior](rf04-multichannel-answers-ingest.md) | [Inicio](../README.md#requerimientos-funcionales) | [Siguiente >](rf06-results-publication-and-consulting.md)