# RNF6 — Mantenibilidad y extensibilidad

**Descripción (alto nivel)**  
GRADE debe contar con una **arquitectura modular y bien documentada** que facilite el mantenimiento correctivo/evolutivo y la incorporación de nuevas capacidades (tipos de ítems, flujos, integraciones) con **bajo impacto** en el resto del sistema.

**Alcance incluye**
- **Modularidad clara** (componentes/servicios desacoplados: banco, entregables, ingesta, calificación, publicación).
- **Contratos estables** entre módulos (APIs internas/versionadas, DTOs bien definidos).
- **Estrategia de versionado** semántico para APIs internas/externas y para el esquema de datos.
- **Pruebas automatizadas** unitarias/integración con cobertura mínima acordada.
- **Documentación técnica** actualizada (diagramas, decisiones de arquitectura, ADRs, guías de desarrollo).
- **Feature flags** o configuraciones para habilitar nuevas funciones de forma gradual.
- **Migraciones de base de datos** con retrocompatibilidad cuando sea posible.

**No incluye (MVP)**
- Refactorizaciones masivas no justificadas por alcance.
- Soporte multi-tenant avanzado (si no está en el roadmap inmediato).

**Dependencias**
- RNF3 (Rendimiento) y RNF5 (Escalabilidad) — decisiones de arquitectura afectarán cómo se mantiene/escala.
- RF2 (Banco), RF3 (Gestión), RF4–RF6 (Ciclo) — módulos principales a desacoplar.
- RNF7 (Observabilidad) — facilita mantenimiento proactivo.

**Criterios de aceptación (CA)**
1. Nuevos tipos de ítems o cambios en reglas de calificación pueden **añadirse sin afectar** otros módulos (acoplamiento bajo).
2. Las **APIs internas** están documentadas y versionadas; cambios incompatibles siguen un proceso de deprecación.
3. Existe **pipeline de CI** con pruebas automáticas y checks mínimos (lint, seguridad, cobertura).
4. Se dispone de **ADRs** (Architecture Decision Records) para las decisiones clave.
5. Las **migraciones** de esquema se ejecutan con scripts versionados y plan de rollback.
6. Nuevas funcionalidades pueden activarse con **feature flags** sin redeploy completo.

**Riesgos/mitigaciones**
- Aumento del acoplamiento → revisión de arquitectura, límites de módulos y contratos bien definidos.
- Deuda técnica acumulada → política de hardening por iteración (porcentaje de sprint), métricas de salud.
- Cambios rompientes en APIs → versionado semántico + deprecación progresiva y comunicación.
