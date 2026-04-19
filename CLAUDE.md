# CLAUDE.md - Contexto para Claude Code

## Propósito del Repositorio

Repositorio de **documentación unificada** para Keygo. Será un submódulo en los repos de backend y frontend.

Objetivo: Una única fuente de verdad que elimine redundancia y divergencia entre documentación de back/front.

## Estructura Actual

```
00-BACKEND/
├── 01-product/          # Contexto del negocio, product specs
├── 02-functional/       # Guías funcionales por features
├── 03-architecture/     # Patrones, decisiones técnicas
├── 04-decisions/        # ADRs, RFCs
├── 06-quality/          # Testing, code style
├── 07-operations/       # Deployment, runbooks
├── 08-reference/        # APIs, data models
└── 99-archive/          # Histórico, deprecated
```

## Cómo Ayudar

1. **Análisis de documentación**: Identificar redundancias, gaps, inconsistencias
2. **Restructuring**: Reorganizar para eliminar duplicación back/front
3. **Unificación**: Crear documentación agnóstica de tech stack cuando sea posible
4. **Validación**: Asegurar coherencia y actualización

## Archivos Importantes

- `macro-plan.md` - Plan maestro de unificación
- `agents.md` - Instrucciones para agentes de IA
- Cada sección con su propio `README.md` como punto de entrada

## Notas

- No edites contenido directamente sin un plan previo
- Primero análisis, luego restructuring
- Mantén el histórico en `/99-archive`
