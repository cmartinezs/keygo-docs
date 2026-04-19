# 00-PLANNING - Documentos de Planificación y Análisis

Este directorio contiene **documentos de trabajo y análisis** para la unificación de documentación de Keygo. NO es documentación de usuarios o del producto.

## Propósito

Registrar análisis, decisiones, y planes para reorganizar la documentación de manera coherente y sin redundancia.

## Estructura

```
00-PLANNING/
├── SP-1-mapping-analysis/         [COMPLETADO ✅]
│   ├── docs-inventory.md          - Mapeo de 519 archivos
│   ├── redundancy-analysis.md     - 8 áreas de duplicación
│   ├── gaps-analysis.md           - 12 áreas faltantes
│   └── structure-proposal.md      - Arquitectura recomendada
│
├── SP-2-architecture-design/      [PRÓXIMO]
│   ├── information-architecture.md
│   ├── naming-conventions.md
│   └── final-structure.md
│
├── SP-3-consolidation/            [Fases posteriores]
│   ├── SP-3.1-product/
│   ├── SP-3.2-functional/
│   ├── SP-3.3-architecture/
│   ├── SP-3.4-quality/
│   └── SP-3.5-operations/
│
├── SP-4-navigation/               [Índices y navegación]
│   ├── index-design.md
│   └── navigation-map.md
│
└── SP-5-validation/               [Validación final]
    └── validation-checklist.md
```

## Cómo Usar

1. **Lee primero**: `../../macro-plan.md` - visión general
2. **Análisis completado**: `SP-1-mapping-analysis/` - resultados del mapeo
3. **Próximo paso**: Espera SP-2 para refinamiento de arquitectura

## Diferencia: Documentación vs. Planificación

| Documento | Ubicación | Propósito |
|-----------|-----------|----------|
| **Documentación del Producto** | `00-BACKEND/`, `01-FRONTEND/` | Para users, developers, operators |
| **Documentación de Planificación** | `00-PLANNING/` | Para entender cambios y decisiones |
| **Instrucciones Meta** | Raíz (`CLAUDE.md`, `agents.md`) | Cómo trabajar en este repo |

## Notas de Trabajo

- Estos documentos **pueden cambiar** mientras refinamos la arquitectura
- **No son definitivos** hasta que se aprueben en cada fase
- Al finalizar cada SP, crear resumen y archivar en `99-ARCHIVE/`

## Próximo Paso

👉 Revisar `SP-1-mapping-analysis/structure-proposal.md`  
👉 Aprobar o sugerir cambios  
👉 Proceder a **SP-2: Diseño de Arquitectura**
