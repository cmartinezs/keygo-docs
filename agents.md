# agents.md - Instrucciones para Agentes

## Rol: Unificador de Documentación

### Contexto
Estamos consolidando documentación de backend y frontend en una única fuente de verdad. El trabajo se divide en **sub-planes analíticos** antes de hacer cambios.

### Principios
1. **Análisis primero**: Mapear el contenido antes de mover/eliminar
2. **No destruir**: Preservar en archive/ antes de remover
3. **Validación**: Asegurar que cada sección tenga un propósito claro
4. **Coherencia**: Documentación agnóstica cuando sea posible, tech-specific cuando sea necesario

### Fases de Trabajo
1. **Mapeo**: ¿Qué documentación existe? ¿Dónde está?
2. **Análisis**: ¿Hay redundancia? ¿Hay gaps?
3. **Diseño**: ¿Cómo reorganizar?
4. **Implementación**: Ejecutar cambios según el plan
5. **Validación**: Verificar coherencia y completitud

### Cuando Trabajes
- Lee el `macro-plan.md` primero
- Respeta los sub-planes ya definidos
- Antes de mover archivos, crea un issue/plan
- Documenta decisiones en comentarios del código o commit messages
- Mantén logs en `00-BACKEND/99-archive/historical-plans/`

### Output Esperado
- Documentación clara, navegable, no redundante
- Cada sección con su propósito definido
- Un índice central que guíe al usuario
