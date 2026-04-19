# RNF5 — Escalabilidad

**Descripción (alto nivel)**  
GRADE debe poder **escalar horizontalmente** sus componentes críticos para soportar picos de uso, especialmente en periodos de exámenes, sin degradación significativa del servicio.

**Alcance incluye**
- Escalado horizontal en procesos críticos:
    - Ingesta de respuestas (OCR, fotos, CSV).
    - Motor de calificación automática.
    - Consultas de resultados.
- Capacidad de aumentar recursos en base a **carga concurrente** de usuarios.
- Balanceo de carga para distribuir solicitudes entre instancias.
- Uso de colas y procesamiento asincrónico para absorber variaciones de demanda.

**No incluye (MVP)**
- Escalabilidad multi-región (queda para fases avanzadas).
- Balanceo global entre distintas instituciones a gran escala.

**Dependencias**
- RF4 (Ingesta de respuestas).
- RF5 (Calificación automática).
- RF6 (Publicación de resultados).
- RNF3 (Rendimiento).
- RNF4 (Disponibilidad y resiliencia).

**Criterios de aceptación (CA)**
1. El sistema puede manejar **al menos el doble de la carga promedio** sin degradar tiempos de respuesta por encima de lo definido en RNF3.
2. Durante picos de uso, el sistema escala automáticamente (horizontal o mediante colas).
3. La ingesta de 1.000 respuestas simultáneas se procesa en tiempos aceptables (<15 min).
4. Los procesos de calificación se distribuyen correctamente entre múltiples instancias.
5. Los reportes de resultados se mantienen accesibles sin errores bajo carga alta.

**Riesgos/mitigaciones**
- Saturación del motor de calificación → distribución en instancias paralelas.
- Cuellos de botella en almacenamiento → particionamiento o caché.
- Fallos en escalado → monitoreo y pruebas de carga periódicas.
