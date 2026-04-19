# RNF3 — Rendimiento

**Descripción (alto nivel)**  
GRADE debe ofrecer un **rendimiento adecuado** que permita a docentes y administradores usar el sistema de manera fluida, incluso en contextos de alta demanda como períodos de examen.

**Alcance incluye**
- Procesamiento de **ingestas de respuestas** (OCR, foto, CSV) en tiempos acotados.
- **Calificación automática** completada en minutos por evaluación.
- Interfaz de usuario con **tiempos de respuesta ágiles** (<2 segundos en operaciones comunes).
- Manejo eficiente de consultas y generación de reportes básicos.
- Optimización de procesos de base de datos y uso de cachés cuando corresponda.

**No incluye (MVP)**
- Optimización para analítica avanzada de grandes volúmenes de datos (ej. big data).
- Escenarios de benchmarking a nivel de miles de instituciones en paralelo.

**Dependencias**
- RF4 (Ingesta de respuestas).
- RF5 (Calificación automática).
- RF6 (Publicación y consulta de resultados).
- RF10 (Reportes pedagógicos).

**Criterios de aceptación (CA)**
1. Una evaluación con **100 estudiantes y 50 ítems** se califica en **<5 minutos**.
2. La interfaz responde en **<2 segundos** en operaciones comunes (crear evaluación, consultar resultados).
3. Procesos de carga masiva (CSV de respuestas) completan en **tiempos consistentes** sin bloqueos.
4. El sistema maneja cargas concurrentes de al menos **50 docentes activos** sin degradación perceptible.
5. Los reportes básicos se generan en **<1 minuto** en evaluaciones estándar.

**Riesgos/mitigaciones**
- Tiempos de OCR variables → procesamiento paralelo y colas asincrónicas.
- Cuellos de botella en calificación → motor optimizado y escalable.
- Sobrecarga en consultas → uso de índices y cachés en la base de datos.
