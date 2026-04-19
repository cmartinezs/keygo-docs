# RF1 — Ciclo de evaluación centralizado

**Descripción (alto nivel)**  
GRADE debe unificar en un **flujo único** el ciclo completo de una evaluación: **creación → preparación/distribución → recolección de respuestas → calificación → publicación de resultados**, evitando el uso de herramientas dispersas.

**Alcance incluye**
- Orquestación de fases con **estados** claros (borrador, listo para aplicar, aplicado, calificado, publicado).
- Transiciones controladas por **rol/permisos**.
- Vista de **progreso/estado** por evaluación.
- Registro automático de **hitos** (timestamps y usuario responsable).

**No incluye (MVP)**
- Proctoring/antifraude avanzado.
- Flujos para **preguntas abiertas** con rúbricas complejas.
- Integraciones institucionales complejas (SSO/SIS).

**Dependencias**
- RF2 (Banco de preguntas).
- RF4–RF5 (ingesta y calificación).
- RF7 (Roles/permisos).
- RF8 (Auditoría).

**Criterios de aceptación (CA)**
1. Es posible **crear** una evaluación a partir de ítems del banco y dejarla en *borrador*.
2. Se puede **preparar y distribuir** el entregable (ej. PDF con identificador único) y pasar a *listo para aplicar*.
3. El sistema **recibe respuestas** (escaneo/foto/CSV/web) y mueve la evaluación a *aplicado* cuando hay cargas.
4. El sistema **califica automáticamente** ítems objetivos y transita a *calificado*.
5. El docente puede **publicar resultados** (y exportarlos), quedando en *publicado*.
6. Todas las transiciones quedan **auditadas** (quién/cuándo/qué), visibles en un historial.
7. Los **roles** restringen acciones (p.ej., solo el docente propietario publica sus evaluaciones; el coordinador no puede ver respuestas individuales).

**Riesgos/mitigaciones**
- Saltos de estado indebidos → reglas de transición + validaciones por rol.
- Inconsistencias entre fases → auditoría (RF8) y estados transaccionales.

---

[Inicio](../README.md#requerimientos-funcionales) | [Siguiente >](rf02-questions-centralized-bank.md)