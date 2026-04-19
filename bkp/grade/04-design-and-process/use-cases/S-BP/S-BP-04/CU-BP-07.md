# CU-BP-07 — Buscar Ítems

- [Revisión](reviews.md)
- [Volver](../../README.md#1-banco-de-preguntas)

## Escenario origen: S-BP-04 | Buscar y seleccionar ítems

### RF relacionados: RF2, RF8

**Actor principal:** Docente / Coordinador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un usuario busque preguntas en el Banco aplicando filtros (tema, dificultad, unidad, etiquetas) y obtenga resultados relevantes con sus metadatos asociados. La búsqueda está orientada a localizar ítems sobre los que el usuario podrá realizar acciones posteriores: ver, editar, versionar, clonar, retirar/reactivar o seleccionar para su inclusión en una evaluación.

### Precondiciones
- Usuario autenticado con permisos de consulta en el banco.
- Catálogos de metadatos disponibles y vigentes.

### Postcondiciones
- El sistema presenta una lista de ítems que cumplen con los filtros aplicados.
- Cada ítem se muestra con metadatos básicos para facilitar su selección y la ejecución de acciones (editar, versionar, clonar, retirar/reactivar, añadir a carpeta de trabajo).
- La búsqueda queda registrada para trazabilidad y análisis de uso.

### Flujo principal (éxito)
1. El Docente accede al módulo de búsqueda avanzada.
2. El Docente ingresa uno o más filtros (ej.: tema, dificultad, unidad, etiquetas).
3. El Sistema valida los filtros seleccionados.
4. El Sistema consulta el repositorio de ítems.
5. El Sistema presenta la lista de ítems relevantes con metadatos (tema, dificultad, uso histórico, estado).
6. El Docente revisa los resultados y puede, sobre cada ítem, elegir una acción contextual:
   - Ver/abrir ítem.
   - Editar ítem (ver CU relacionado: [CU-BP-02 — Editar/Versionar/Clonar](../S-BP-02/CU-BP-02.md)).
   - Versionar / Clonar (ver CU relacionado: [CU-BP-02 — Editar/Versionar/Clonar](../S-BP-02/CU-BP-02.md)).
   - Retirar / Reactivar (ver CU relacionados: [CU-BP-05 — Retirar Ítem](../S-BP-03/CU-BP-05.md) y [CU-BP-06 — Reactivar Ítem](../S-BP-03/CU-BP-06.md)).
   - Añadir a carpeta temporal / espacio de trabajo (ver CU relacionado: [CU-BP-08 — Seleccionar Ítems](./CU-BP-08.md)).
7. El usuario ejecuta la acción deseada; el Sistema confirma la operación y actualiza la vista según corresponda.

### Flujos alternativos / Excepciones
- **A1 — Sin resultados:** El Sistema informa que no hay coincidencias y sugiere ampliar filtros.
- **A2 — Filtros inválidos:** El Sistema muestra mensaje de error y permite corrección.
- **A3 — Exceso de resultados:** El Sistema pagina la búsqueda y permite refinar con más filtros.

### Reglas de negocio
- **RN-1:** Los ítems inactivos no deben aparecer en resultados por defecto.
- **RN-2:** Los resultados deben respetar permisos de visibilidad.
- **RN-3:** El sistema debe mostrar un número máximo de resultados por página (configurable).

### Datos principales
- **Ítem**(ID, estado, enunciado, metadatos, historial de uso, autor, timestamps).
- **Filtros de búsqueda**(tema, unidad, dificultad, etiquetas).

### Consideraciones de seguridad/permiso
- Mostrar únicamente ítems accesibles al rol del usuario.
- No exponer información sensible (ej.: borradores privados de otros autores).

### No funcionales
- **Rendimiento:** búsqueda < 2s p95.
- **Usabilidad:** interfaz intuitiva con filtros claros y posibilidad de refinar.

### Criterios de aceptación (QA)
- **CA-1:** Al ingresar filtros válidos, el sistema devuelve ítems que cumplen con esos criterios.
- **CA-2:** Ítems inactivos no aparecen en la búsqueda por defecto.
- **CA-3:** Si no hay resultados, se muestra mensaje de ayuda para refinar la búsqueda.
- **CA-4:** Los resultados incluyen metadatos (tema, dificultad, veces usadas).

---

## Anexo Técnico (para desarrollo)

> Mapeo al modelo DDL y notas sobre inconsistencias detectadas entre el caso de uso y el modelo de datos actual.

### Mapeo relevante al DDL (Banco de Preguntas)
- Fuente principal de ítems: tabla `questions` (almacena enunciado, tipo, referencia a `topics`, `difficulties`, `question_type`, trazabilidad y flags de auditoría).
- Filtros mencionados en el CU:
  - `tema`: corresponde a `topics` (campo `topic_id` / relación `questions.topic_fk`).
  - `unidad`: no es un campo directo en `questions`; se infiere a través de la relación `topics → units` (hacer JOIN con `units` para filtrar por unidad).
  - `dificultad`: corresponde a `difficulties` (relación `questions.difficulty_fk`).
  - `etiquetas`: el modelo DDL actual no define una tabla genérica de etiquetas para preguntas; si se requieren etiquetas, debe implementarse una tabla `tags` y una tabla de relación `question_tags`.

### Estado / visibilidad
- El CU menciona "ítems inactivos"; en el DDL la vigencia/visibilidad se controla con `active` (BOOLEAN) y los campos de auditoría (`deleted_at`, `deleted_by`).
- Recomendación: las consultas de búsqueda deben filtrar por registros activos (por ejemplo `WHERE active = TRUE` o según la política decidida: `deleted_at IS NULL`).

### Métricas y metadatos derivados
- El CU pide mostrar "uso histórico" y "veces usadas"; el DDL no contiene una columna `usage_count` en `questions`.
  - Opción A: derivar esas métricas desde logs/tabla de uso (p.ej. `evaluation_questions`, `student_answers`) usando agregaciones.
  - Opción B: mantener un contador actualizado en `questions` (`usage_count`) si se requiere consulta rápida (añade mantenimiento en transacciones).

### Borradores y visibilidad privada
- El CU advierte sobre "borradores privados"; el DDL no incluye un flag `draft` ni un mecanismo explícito para borradores privados.
  - Si la funcionalidad de borradores existe, se recomienda definir un campo `is_draft` o un mecanismo de visibilidad/propiedad adicional.

### Índices y rendimiento
- Para búsquedas por tema/unidad/dificultad y filtrado por vigor (activo): usar índices compuestos sobre `questions(topic_fk, active)` (ya existe `idx_questions_topic_active`).
- Para búsquedas textuales por enunciado considerar FTS (`to_tsvector`) y un índice GIN.

### Ejemplo de consulta para implementar la búsqueda (texto, filtros y jerarquía curricular)
```text
SELECT q.question_id, q.text, t.name AS topic_name, u.name AS unit_name, d.level AS difficulty
FROM questions q
JOIN topics t ON q.topic_fk = t.topic_id
JOIN units u ON t.unit_fk = u.unit_id
JOIN difficulties d ON q.difficulty_fk = d.difficulty_id
WHERE q.active = TRUE
  AND (t.topic_id = :topic_id OR u.unit_id = :unit_id OR d.difficulty_id = :difficulty_id)
ORDER BY q.created_at DESC
LIMIT :limit OFFSET :offset;
```

### Inconsistencias detectadas (resumen)
- "Unidad" no es campo directo de `questions` (se infiere via `topics`).
- "Etiquetas" no existe en el DDL actual (se necesitaría `tags` y `question_tags`).
- "Veces usadas"/"uso histórico" no es un campo directo; debe derivarse o añadirse.
- "Borradores privados" no está contemplado en el modelo actual.

---

[Subir](#cu-bp-07--buscar-ítems)