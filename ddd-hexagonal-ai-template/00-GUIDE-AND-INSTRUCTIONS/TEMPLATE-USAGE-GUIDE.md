# Guía Completa: Usando la Plantilla DDD + Hexagonal

Paso a paso para adaptar esta plantilla a tu proyecto y generar documentación con IA.

---

## Contenido

- [Paso 1: Preparación (15 min)](#paso-1-preparación-15-min)
- [Paso 2: Adaptación de la estructura (20 min)](#paso-2-adaptación-de-la-estructura-20-min)
- [Paso 3: Generación de contenido con IA (2-3 días)](#paso-3-generación-de-contenido-con-ia-2-3-días)
- [Paso 4: Validación y ajustes (1-2 días)](#paso-4-validación-y-ajustes-1-2-días)
- [Paso 5: Mantener viva la documentación](#paso-5-mantener-viva-la-documentación)
- [Checklist final](#checklist-final)

---

## Paso 1: Preparación (15 min)

### 1.1 Reúne información sobre tu producto

Antes de comenzar, debes tener claridad sobre:

**Información de Negocio:**
- ¿Qué problema resuelve tu producto? (1-2 frases)
- ¿Para quién? (usuarios finales, empresas, etc.)
- ¿Por qué ahora? (contexto de mercado)
- ¿Cuál es tu ventaja competitiva?

**Información Técnica:**
- ¿Qué tecnologías usarás? (stack de backend, frontend, BD, etc.) — solo para tener claridad, no es parte de la plantilla
- ¿Cuál es tu escala esperada? (usuarios, datos, requests/segundo)
- ¿Qué restricciones técnicas existen? (latencia, compliance, etc.)

**Información Organizacional:**
- ¿Quién es el dueño del producto? (PM, founder, etc.)
- ¿Quién es el tech lead?
- ¿Cuál es tu roadmap a 6-12 meses?

### 1.2 Define los "Bounded Contexts" iniciales

Los Bounded Contexts son los dominios de negocio distintos en tu sistema. Ejemplos:

- **Sistema de autenticación**: Identidad, Autorización, Sesiones
- **Sistema de billing**: Catálogo, Suscripciones, Facturación, Pagos, Dunning
- **Marketplace**: Productos, Órdenes, Pagos, Envíos, Reseñas
- **SaaS**: Organizaciones, Usuarios, Configuración, Roles

**Identifica 3-5 contextos principales.** No necesitan ser perfectos ahora — se refinarán en Discovery.

---

## Paso 2: Adaptación de la estructura (20 min)

### 2.1 Copia la plantilla

```bash
# En tu repo, copia la carpeta
cp -r ddd-hexagonal-ai-template/ tu-proyecto-docs/

# Navega
cd tu-proyecto-docs/
```

### 2.2 Renombra los archivos TEMPLATE-

Reemplaza `TEMPLATE-` con nombres reales:

```bash
cd 01-discovery/
mv TEMPLATE-context-motivation.md context-motivation.md
mv TEMPLATE-system-vision.md system-vision.md
mv TEMPLATE-system-scope.md system-scope.md
# ... y así con todos los TEMPLATE-*.md
```

**Atajo**: Busca todos los TEMPLATE-*.md en la estructura:

```bash
find . -name "TEMPLATE-*.md" -type f
```

### 2.3 Actualiza los README.md de cada carpeta

Cada `README.md` tiene un template. Actualiza:

1. La descripción de la fase (3-4 frases)
2. El listado de documentos que irá en esa carpeta

**Ejemplo para `01-discovery/README.md`:**

```markdown
[← HOME](../README.md)

---

# Discovery: [TU PRODUCTO]

En esta fase exploramos el problema que [TU PRODUCTO] resuelve: 
[descripción de 2-3 oraciones].

Identificamos los usuarios, sus necesidades, el contexto de mercado y 
los riesgos u oportunidades clave.

---

## Contenido

* [Contexto y Motivación](./context-motivation.md)
* [Visión del Sistema](./system-vision.md)
* [Alcance del Sistema](./system-scope.md)
* [Actores](./actors.md)
* [Necesidades y Expectativas](./needs-expectations.md)
* [Análisis Final](./final-analysis.md)

---

[← HOME](../README.md) | [Siguiente >](./context-motivation.md)
```

### 2.4 Actualiza el MACRO-PLAN.md

Reemplaza los placeholders con tu información:

```markdown
# MACRO-PLAN: Documentación [TU PRODUCTO] — SDLC Framework

## Visión

[Tu visión del producto en 3-4 oraciones]

## El Ciclo

[Copia el diagrama de ciclo]

---

## Fases y Sub-Planes

### [SP-0] Framework SDLC ✅
**Objetivo**: [describe]
**Entregable**: [lista de archivos]
**Estado**: 🔲 (En progreso)

### [SP-D1] Discovery 🔲
**Objetivo**: [describe]
**Carpeta**: `01-discovery/`
**Entregables**:
- [lista de archivos]

**Estado**: 🔲 (No iniciado)

... (repite para todas las 12 fases)
```

---

## Paso 3: Generación de contenido con IA (2-3 días)

### 3.1 Lee las instrucciones para IA

Abre [`INSTRUCTIONS-FOR-AI.md`](./INSTRUCTIONS-FOR-AI.md) para ver:

- Cómo estructurar prompts
- Qué contexto proporcionar
- Validación checklist

### 3.2 Genera contenido fase por fase

**Orden recomendado:**

1. **01-Discovery** (2-3 horas)
   - Proporciona el problem statement y contexto
   - IA genera: context-motivation, system-vision, scope, actors, needs
   - Revisa y ajusta

2. **02-Requirements** (3-4 horas)
   - Proporciona glossary y lista de requisitos (puedo ayudarte a extraerlos)
   - IA genera: RF, RNF, matriz de priorización
   - Revisa y asegúrate de agnóstico de tecnología

3. **03-Design** (3-4 horas)
   - Proporciona los requisitos validados
   - IA genera: bounded contexts, strategic design, system flows
   - Revisa la coherencia del modelo de dominio

4. **04-Data Model** (2 horas)
   - IA extrae del design: entities, relationships, data flows
   - Valida que ERD sea coherente

5. **05-Planning** (2 horas)
   - Define roadmap a nivel de features/epics
   - IA genera estructuración por versión

6. **06-Development** (4-5 horas)
   - Aquí SÍ usas tu stack específico
   - IA genera: architecture, API contracts, coding standards

7. **07-Testing → 11-Feedback** (2-3 horas c/u)
   - IA genera basándose en los anteriores

### 3.3 Validación después de cada fase

**Para cada documento generado:**

1. ✅ Léelo completo
2. ✅ Valida que responda a la pregunta central de la fase
3. ✅ Valida que sea agnóstico de tecnología (si aplica)
4. ✅ Valida que haya cross-references (vínculos a otros documentos)
5. ✅ Si falta algo, pide a IA que expanda

---

## Paso 4: Validación y ajustes (1-2 días)

### 4.1 Validación de coherencia cross-phase

Después de completar todas las fases:

1. **Discovery ↔ Requirements**: ¿Los RF responden a las necesidades del Discovery?
2. **Requirements ↔ Design**: ¿El design cubre todos los RF?
3. **Design ↔ Data Model**: ¿Las entidades soportan los flujos?
4. **Data Model ↔ Development**: ¿La arquitectura y APIs mapean el modelo de datos?
5. **Development ↔ Testing**: ¿Los test plans cubren los requisitos?

Crea una matriz de trazabilidad:

```
RF-001 (Login) 
  ↓ 
  Design (AuthFlow + 3 Bounded Contexts) 
  ↓ 
  Data Model (User, Session entities)
  ↓ 
  Dev (Spring Security config + API /auth/login)
  ↓ 
  Testing (unit + integration tests)
  ↓
  Deployment (secrets, environment setup)
```

### 4.2 Revisión con el equipo

- Tech lead: revisa Development + Testing
- PM: revisa Discovery + Requirements + Planning
- DevOps: revisa Deployment + Operations

---

## Paso 5: Mantener viva la documentación

### 5.1 Política de actualización

La documentación se actualiza cuando:

- ✏️ **Código cambia** — si cambias una API, actualiza `06-development/api-reference.md`
- ✏️ **Requisitos cambian** — si descubres un nuevo requisito, actualiza `02-requirements/`
- ✏️ **Procesos cambian** — si el equipo cambia cómo trabaja, actualiza `CLAUDE.md` o `08-deployment/`

### 5.2 Ownership

Cada documento debe tener un owner:

```markdown
---
**Owner**: [nombre]  
**Last Updated**: YYYY-MM-DD  
**Next Review**: YYYY-MM-DD
---
```

### 5.3 Feedback loops

Cada trimestre:
- El equipo revisa los documentos
- ¿Están actualizados? ¿Falta algo?
- Registra en `11-feedback/retrospectives.md`

---

## Checklist Final

Antes de considerar completada la documentación:

### Estructura
- [ ] Todas las 12 fases tienen carpetas
- [ ] Cada carpeta tiene `README.md`
- [ ] No hay archivos `TEMPLATE-*` en la estructura final (todos renombrados)
- [ ] `MACRO-PLAN.md` está actualizado

### Contenido
- [ ] Discovery responde: ¿Qué problema resolvemos?
- [ ] Requirements responde: ¿Qué debe hacer el sistema?
- [ ] Design responde: ¿Cómo fluye el sistema?
- [ ] Data Model responde: ¿Cómo se almacenan datos?
- [ ] Planning responde: ¿Cuándo y cómo entregamos?
- [ ] Development responde: ¿Cómo lo construimos técnicamente?
- [ ] Testing responde: ¿Cómo validamos?
- [ ] Deployment responde: ¿Cómo vamos a producción?
- [ ] Operations responde: ¿Cómo operamos?
- [ ] Monitoring responde: ¿Cómo medimos salud?
- [ ] Feedback responde: ¿Qué aprendemos?

### Cross-references
- [ ] Cada RF en Requirements tiene trazabilidad a Design + Development
- [ ] Cada Design decision tiene justificación (alternativas consideradas)
- [ ] Cada API en Development referencia el requisito que implementa

### Agnóstico/Específico
- [ ] Discovery-Requirements son **agnósticos de tecnología**
- [ ] Design es **agnóstico o agnóstico-con-principios** (ej: "API REST" es arquitectural, no específico)
- [ ] Development-Deployment-Operations son **específicos a tu stack**

### Navegación
- [ ] Cada documento tiene links Anterior/Siguiente
- [ ] Cada documento tiene link a Índice de carpeta
- [ ] Cada sección tiene link de retorno al inicio
- [ ] No hay links rotos (revisión manual)

---

## Tiempo Total Estimado

| Fase | Tiempo | Notas |
|------|--------|-------|
| Preparación | 15 min | Información de negocio + contextos |
| Adaptación | 20 min | Copiar, renombrar, actualizar READMEs |
| Discovery (con IA) | 2-3 h | Más tiempo si necesitas refinar mucho |
| Requirements | 3-4 h | Importante validar agnóstico |
| Design | 3-4 h | Centro de la documentación |
| Data Model | 2 h | Se extrae del design |
| Planning | 2 h | |
| Development | 4-5 h | Aquí usas tu stack |
| Testing → Feedback | 2-3 h c/u | Total ~12-15 h |
| **Validación y ajustes** | **1-2 días** | Cross-checking |
| **TOTAL** | **~30-40 h** | Trabajo distribuido en 5-7 días |

---

## Próximos Pasos

1. ✅ Completa la preparación (Paso 1)
2. 📁 Adapta la estructura (Paso 2)
3. 🤖 Usa `INSTRUCTIONS-FOR-AI.md` para generar contenido
4. 🔍 Valida coherencia cross-phase (Paso 4)
5. 📈 Configura ownership y feedback loops (Paso 5)

---

[← Índice](./README.md)
