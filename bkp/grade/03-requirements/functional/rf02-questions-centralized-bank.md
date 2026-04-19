# RF2 — Banco centralizado de preguntas

**Descripción (alto nivel)**  
GRADE debe proveer un **repositorio único de ítems reutilizables**, versionados y catalogados, que sirva como base para la creación de evaluaciones. Este banco debe asegurar **coherencia curricular, trazabilidad y reutilización** de preguntas, evitando duplicidad de esfuerzos entre docentes.

**Alcance incluye**
- Registro de ítems con **metadatos pedagógicos** (unidad, dificultad, resultado de aprendizaje, tema, etc.).
- **Control de versiones**: historial de cambios por pregunta y vínculo con evaluaciones donde fue utilizada.
- Búsqueda, filtrado y selección de ítems para armar nuevas evaluaciones.
- Posibilidad de marcar ítems como **vigentes / retirados** del uso activo.
- Identificación única por ítem y trazabilidad de uso.

**No incluye (MVP)**
- Importación/exportación masiva de bancos desde sistemas externos.
- Preguntas abiertas con rúbricas complejas.
- Funcionalidades de analítica avanzada por ítem (quedan para fases posteriores).

**Dependencias**
- RF1 (Ciclo centralizado de evaluación).
- RF5 (Calificación automática).
- RF7 (Roles/permisos).
- RF8 (Auditoría).

**Criterios de aceptación (CA)**
1. Se puede **crear y guardar** una pregunta en el banco con sus metadatos obligatorios.
2. Cada pregunta tiene un **identificador único** y queda asociada a su historial de cambios.
3. Es posible **buscar y filtrar** preguntas por atributos (ej. unidad, dificultad, tema).
4. Los docentes pueden **reutilizar ítems** existentes en nuevas evaluaciones.
5. Se registra en el historial **en qué evaluaciones** ha sido utilizada cada pregunta.
6. Solo usuarios con permisos adecuados (ej. Administrador, Coordinador, Docente) pueden **crear, editar o usar** ítems según su rol.
7. Preguntas retiradas o inactivas **no aparecen disponibles** para nuevas evaluaciones.

**Riesgos/mitigaciones**
- Duplicación de preguntas → uso obligatorio de identificador único + búsqueda avanzada.
- Inconsistencia en cambios de preguntas → control de versiones y trazabilidad de uso.

---

[< Anterior](rf01-centralized-evaluation-cicle.md) | [Inicio](../README.md#requerimientos-funcionales) | [Siguiente >](rf03-evaluations-and-deliverables-management.md)