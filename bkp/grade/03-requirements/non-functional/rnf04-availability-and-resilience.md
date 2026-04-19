# RNF4 — Disponibilidad y resiliencia

**Descripción (alto nivel)**  
GRADE debe estar disponible de forma confiable durante los períodos críticos (ej. exámenes), garantizando **alta disponibilidad** y mecanismos de **recuperación ante fallos** para evitar pérdida de información.

**Alcance incluye**
- Diseño de infraestructura con **alta disponibilidad** (mínimo 99,5% uptime en MVP).
- **Tolerancia a fallos**: los procesos críticos (ingesta, calificación, publicación) deben reanudarse tras interrupciones.
- **Recuperación automática** de procesos fallidos mediante reintentos o colas.
- **Respaldos periódicos** de base de datos y restauración verificable.
- Estrategias de **failover** o redundancia básica en entornos de despliegue.

**No incluye (MVP)**
- Esquemas avanzados multi-región o disaster recovery con RPO/RTO de nivel corporativo.
- Contratos de SLA superiores al 99,9%.

**Dependencias**
- RF4 (Ingesta de respuestas).
- RF5 (Calificación automática).
- RF6 (Publicación de resultados).
- RF8 (Auditoría).

**Criterios de aceptación (CA)**
1. El sistema mantiene un **uptime ≥99,5%** en entornos de producción.
2. Los procesos interrumpidos en la ingesta o calificación se **reanuden automáticamente** sin pérdida de datos.
3. Los respaldos se realizan al menos **1 vez al día** y se prueban restauraciones de forma periódica.
4. Ante un fallo crítico, los usuarios reciben un **mensaje claro** y la operación se reintenta de forma automática.
5. La auditoría registra cualquier evento de caída y recuperación.

**Riesgos/mitigaciones**
- Caída durante exámenes → redundancia en procesos críticos.
- Pérdida de información → respaldos automáticos y restauraciones probadas.
- Indisponibilidad prolongada → monitoreo y alertas en tiempo real.
