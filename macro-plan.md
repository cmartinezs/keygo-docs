# MACRO-PLAN: Unificación de Documentación Keygo

## Visión
Transformar documentación fragmentada (back/front separados) en una única fuente de verdad coherente, navegable y sin redundancia.

## Sub-Planes (Fases de Trabajo)

### [SP-1] Mapeo y Análisis de Contenido
**Objetivo**: Entender qué documentación existe, dónde está, qué es redundante, qué falta.

**Entregables**: ✅ COMPLETADO
- `00-PLANNING/SP-1-mapping-analysis/docs-inventory.md` - Listado completo de 519 archivos clasificados
- `00-PLANNING/SP-1-mapping-analysis/redundancy-analysis.md` - 8 áreas de duplicación (9-13 horas consolidación)
- `00-PLANNING/SP-1-mapping-analysis/gaps-analysis.md` - 12 áreas faltantes (25-45 horas total)
- `00-PLANNING/SP-1-mapping-analysis/structure-proposal.md` - Arquitectura unificada recomendada

**Estado**: ✅ Completado
**Documentación**: Ver `00-PLANNING/SP-1-mapping-analysis/README.md`

---

### [SP-2] Diseño de Arquitectura Documental
**Objetivo**: Definir estructura final, navegación, índices.

**Entregables**:
- `information-architecture.md` - Jerarquía final
- `navigation-map.md` - Cómo navegar entre secciones
- `index-structure.md` - Índices y puntos de entrada
- `naming-conventions.md` - Estándares de nomenclatura

**Responsables**: Diseño
**Estado**: Bloqueado por SP-1

---

### [SP-3] Consolidación de Sections por Dominio
Ejecutar unificación por cada sección principal:

- **[SP-3.1] Product** - Glossario, casos de uso, requisitos
- **[SP-3.2] Functional** - Guías de features, flows
- **[SP-3.3] Architecture** - Patrones, decisiones técnicas
- **[SP-3.4] Quality** - Testing, observability, code style
- **[SP-3.5] Operations** - Deployment, runbooks

**Para cada subsección**:
- Análisis de redundancia
- Propuesta de consolidación
- Merge/rewrite de contenido
- Validación de coherencia

**Estado**: Bloqueado por SP-2

---

### [SP-4] Creación de Índices y Navegación Central
**Objetivo**: Hacer la documentación navegable y descubrible.

**Entregables**:
- `INDEX.md` - Índice maestro
- `QUICKSTART.md` - Cómo empezar según rol
- `sitemap.md` - Mapa visual de la estructura
- Actualizar `README.md` raíz

**Estado**: Paralelo a SP-3

---

### [SP-5] Validación y Publicación
**Objetivo**: Asegurar que documentación sea coherente, completa, actualizada.

**Checklist**:
- [ ] No hay links rotos
- [ ] Todas las secciones tienen descripción clara
- [ ] Glosario es consistente
- [ ] Ejemplos son correctos
- [ ] Actualizado a fecha actual

**Estado**: Bloqueado por SP-3

---

## Dependencias
```
SP-1 (Mapeo)
  ↓
SP-2 (Arquitectura) + SP-4 (Índices)
  ↓
SP-3 (Consolidación)
  ↓
SP-5 (Validación)
```

## Timeline Estimado
- **SP-1**: 1-2 sesiones (análisis)
- **SP-2**: 1 sesión (diseño)
- **SP-3**: 3-5 sesiones (consolidación de cada dominio)
- **SP-4**: 1 sesión (índices)
- **SP-5**: 1 sesión (validación)

**Total**: ~8-12 sesiones

## Documentación de Planificación

Todos los documentos de análisis y planificación viven en **`00-PLANNING/`** (no mezclados con documentación raw):

```
00-PLANNING/
├── SP-1-mapping-analysis/    ✅ Completado
├── SP-2-architecture-design/ ⏳ Próximo
├── SP-3-consolidation/       (fases posteriores)
├── SP-4-navigation/          (fases posteriores)
└── SP-5-validation/          (fases posteriores)
```

Ver `00-PLANNING/README.md` para navegación completa.

## Siguiente Paso
👉 Revisar **`00-PLANNING/SP-1-mapping-analysis/`** para análisis completado  
👉 Proceder a **SP-2: Diseño de Arquitectura Documental** (1 sesión)
