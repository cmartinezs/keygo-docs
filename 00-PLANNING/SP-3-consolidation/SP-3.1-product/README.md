# SP-3.1: Consolidación de Product (01-product/)

**Estado**: Plan listo para ejecución  
**Fecha**: 2026-04-19  
**Duración estimada**: 1.5 horas

---

## Objetivo

Consolidar documentación dispersa de product (glossary, requirements, vision, constraints) en una sección unificada **01-product/** que sea SINGLE SOURCE OF TRUTH para QUÉ estamos construyendo.

---

## Documentos en Esta Fase

### 📊 analysis.md
Análisis detallado de qué existe hoy:
- Backend glossary (550 líneas, completo)
- Frontend role-model (24 líneas, incompleto)
- Backend requirements (200+ líneas, solo Auth documentado)
- Frontend vision-and-scope (17 líneas, útil para extraer vision)
- Backend pain-points (80+ líneas, documentación de dolor)

**Hallazgo clave**: Backend tiene documentación más completa; frontend aporta visión de UX/alcance.

### 🗂️ merge-plan.md
Plan ejecutable paso-a-paso:
1. Consolidar glossary (30 min) - Backend como base, expandir roles
2. Consolidar requirements (20 min) - Backend como base, marcar incompletos
3. Crear vision.md (20 min) - Agnóstico, extraer de vision-and-scope
4. Crear constraints-limitations.md (15 min) - Renombrar pain-points, mover
5. Crear README.md (10 min) - Entry point e índice local
6. Validar + Commit (10 min)

**Output**: 5 archivos nuevos en 01-product/

---

## Resultado Esperado

### Nuevo: 01-product/

```
01-product/
├── README.md                    ← Entry point + mini-index
├── vision.md                    ← NEW: Visión agnóstica (1-2 páginas)
├── glossary.md                  ← CONSOLIDATED: 100+ términos (SINGLE SOURCE OF TRUTH)
├── requirements.md              ← CONSOLIDATED: RF-A/B/T/C por bounded context
├── constraints-limitations.md    ← CONSOLIDATED: Pain points + restricciones
├── diagrams/                    ← KEEP: Use cases, flows, etc.
├── bounded-contexts.md          ← KEEP: Existing
├── current-state.md             ← KEEP: Existing
├── solution-proposal.md          ← KEEP: Existing
└── dependency-map.md            ← KEEP: Existing
```

### Benefits

| Antes | Después |
|-------|---------|
| glossary en 00-BACKEND | ✅ glossary en 01-product (CENTRALIZED) |
| role-model en 01-FRONTEND | ✅ Merged en glossary |
| requirements en 00-BACKEND | ✅ requirements en 01-product |
| pain-points en 00-BACKEND | ✅ constraints-limitations en 01-product |
| NO vision.md | ✅ vision.md agnóstico nuevo |
| NO README en 01-product | ✅ README con navegación |

### Developers ahora pueden

1. Ir a `01-product/` y ver todo lo que define el producto
2. Usar `glossary.md` como single source of truth (no buscar en 2 repos)
3. Leer `vision.md` en 5 minutos para entender qué es KeyGo
4. Ver `requirements.md` para especificaciones detalladas
5. Entender `constraints.md` para restricciones que afectan decisiones

---

## Checklist Ejecutable

**ACCIÓN 1: Consolidar Glossary**
- [ ] Leer 00-BACKEND/01-product/glossary.md (550 líneas)
- [ ] Leer 01-FRONTEND/01-product/02-role-model.md (24 líneas)
- [ ] Expandir sección de Roles (agregar definiciones detalladas de ADMIN, ADMIN_TENANT, USER_TENANT)
- [ ] Crear `01-product/glossary.md` con contenido consolidado
- [ ] Validar: roles bien definidos, sin conflictos, contextos claros

**ACCIÓN 2: Consolidar Requirements**
- [ ] Copiar 00-BACKEND/01-product/requirements.md
- [ ] Crear `01-product/requirements.md`
- [ ] Agregar notas de "PENDIENTE COMPLETAR" para contextos incompletos (Billing, Tenants, Account)
- [ ] Validar: RF-A1 a RF-A8 completos, status claro

**ACCIÓN 3: Crear Vision.md**
- [ ] Leer 01-FRONTEND/01-product/01-vision-and-scope.md
- [ ] Extraer "vision" part (no "scope")
- [ ] Crear `01-product/vision.md` agnóstico (What, For whom, Key Principles, Core Features)
- [ ] Validar: 1-2 páginas, sin tech-specifics

**ACCIÓN 4: Crear Constraints-Limitations.md**
- [ ] Leer 00-BACKEND/01-product/pain-points.md
- [ ] Crear `01-product/constraints-limitations.md`
- [ ] Renombrar de pain-points a constraints-limitations
- [ ] Validar: Pain points + causa raíz + impacto + soluciones

**ACCIÓN 5: Crear README.md**
- [ ] Crear `01-product/README.md` como entry point
- [ ] Link a cada documento (vision, glossary, requirements, constraints, diagrams)
- [ ] Descripción de qué leer cuándo
- [ ] Navegación hacia otras secciones (02-functional, 03-architecture)
- [ ] Validar: Claro, conciso, orientador

**ACCIÓN 6: Validar + Commit**
- [ ] Verificar todos los archivos existen y contienen expected content
- [ ] Verificar estructura de 01-product/ completa
- [ ] Commit: "Complete SP-3.1: Consolidate 01-product section"
- [ ] Marcar deprecated (con notas) archivos en 00-BACKEND/ y 01-FRONTEND/

---

## Dependencies

**Debe estar completo antes**:
- ✅ SP-1 (Mapeo y análisis) - YA COMPLETADO
- ✅ SP-2 (Arquitectura y estándares) - YA COMPLETADO

**Puede proceder paralelo**:
- SP-3.2 (Functional consolidation) - Puede comenzar después
- SP-3.3 (Architecture consolidation) - Puede comenzar después

---

## Próximo Paso

👉 Ejecutar merge-plan.md acciones una por una

**Comenzar con**:
1. Crear 01-product/ si no existe
2. Acción 1: Consolidar glossary (ver merge-plan.md para detalles específicos)
