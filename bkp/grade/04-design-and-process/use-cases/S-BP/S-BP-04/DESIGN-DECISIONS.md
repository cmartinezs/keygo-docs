# DESIGN-DECISIONS — S-BP-04 (Buscar/Seleccionar) & S-BP-05 (Trazabilidad)

Este documento consolida las decisiones de diseño tomadas durante el refinamiento de los casos de uso del Banco de Preguntas (S-BP). Está pensado como referencia ejecutiva para producto y desarrollo; no incluye detalles de implementación que ya están en los anexos técnicos de cada CU.

- Referencias rápidas:
  - `use-cases/S-BP/S-BP-04/CU-BP-07.md` — Buscar Ítems
  - `use-cases/S-BP/S-BP-04/CU-BP-08.md` — Seleccionar Ítems
  - `use-cases/S-BP/S-BP-05/CU-BP-09.md` — Consultar trazabilidad
  - `use-cases/S-BP/S-BP-05/CU-BP-10.md` — Generar reporte
  - Registro extendido de ideas pendientes: `../../04-design-and-process/review-items.md`

---

## Decisiones acordadas (resumen)

1. Formato de exportación por defecto
   - JSON recomendado para exportaciones desde el Banco (preserva estructura y metadatos).
   - CSV soportado como alternativa para usuarios/hojas de cálculo.

2. Workspace (carpeta temporal)
   - No persistir workspaces en el MVP. Mantener en sesión/app-side (memoria/redis).
   - Persistencia en DB (`workspaces`/`workspace_items`) queda como mejora futura.

3. Política de intentos para métricas
   - Recomendación por defecto: contar el **último intento válido** por estudiante por evaluación.
   - Si la política institucional es «un solo intento», usar `attempt_no IS NULL`.

4. Precomputación de métricas
   - Implementar `question_metrics` (vista materializada o tabla) recomendado para producción, no para MVP.
   - Job batch (nightly) para refresh; diseño incremental según carga.

5. Etiquetas y metadata adicional
   - `tags` / `question_tags` recomendadas en roadmap, no obligatorias en MVP.

6. Auditoría de exportes y trazabilidad de reportes
   - Registrar generación/descarga de reportes (`reports`/`audit_logs`).
   - Enlaces de descarga con expiración y control de acceso.

7. Seguridad y privacidad
   - Los reportes y vistas de trazabilidad deben exponer solo datos agregados; no incluir `student_id` ni `identifier`.
   - Control de accesos por rol (Coordinador/Administrador) y auditoría de acciones.

8. Transiciones de estado (retirar/reactivar)
   - Encapsular lógica crítica en funciones DB (PL/pgSQL) cuando proceda y registrar motivo en `question_state_changes` si se requiere.

9. Contrato entre módulos
   - Definir un contrato (endpoint) para import/export entre Banco y Composer de Evaluaciones (`POST /evaluation-composer/import`) cuando se implemente la integración.

---

## Acciones y seguimiento
- Las ideas técnicas y propuestas de mejora están registradas en `../../04-design-and-process/review-items.md` (A..K). Priorizar en backlog con Product e Infra.
- Para implementación futura: preparar DDL propuesto, `DATA_TEST.sql` y pruebas de rendimiento antes de desplegar la vista de métricas.

---

Fecha: 2025-10-06

[Volver al índice](../../README.md)

