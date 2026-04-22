[← Índice](./README.md)

---

# Arquitectura de la Plantilla DDD + Hexagonal

Cómo está diseñada internamente y por qué, para que puedas adaptarla a tus necesidades.

---

## Contenido

- [Filosofía](#filosofía)
- [Las 12 fases explicadas](#las-12-fases-explicadas)
- [Principios de diseño](#principios-de-diseño)
- [Agnóstico vs. Específico](#agnóstico-vs-específico)
- [Mapa mental](#mapa-mental)
- [Cuándo extender o adaptar](#cuándo-extender-o-adaptar)
- [Gobernanza de templates](#gobernanza-de-templates)

---

## Filosofía

### Premisa

La mejor documentación es:

1. **Agnóstica primero** — describe qué antes de cómo
2. **Iterable** — permite desarrollo paralelo de features
3. **Viva** — cambia con el código, no se congela
4. **Trazable** — desde requisito hasta métrica
5. **Colaborativa** — fácil de generar con IA, fácil de revisar con equipo

### ¿Por qué DDD + Hexagonal?

**DDD (Domain-Driven Design)**:
- Organiza la complejidad alrededor del *dominio de negocio*
- Fuerza convención común (ubiquitous language)
- Produce una arquitectura que refleja el negocio, no el framework

**Hexagonal (Ports & Adapters)**:
- Separa el *dominio* de la *implementación técnica*
- El dominio vive en el centro (agnóstico)
- La tecnología es detalle de implementación (intercambiable)

**Juntos**:
- Documentación agnóstica en fases 1-5 (descubre y especifica el dominio)
- Documentación específica en fases 6-12 (implementa el dominio en código)
- Lenguaje común entre negocio y técnica

---

## Las 12 Fases Explicadas

### Ciclo de Vida Completo

```
Discovery → Requirements → Design → UI & Data
    ↓
    └─ Planning → Development → Testing
         ↓
    Deployment → Operations → Monitoring → Feedback
         ↓
         └─ (vuelve a Discovery con aprendizajes)
```

### Fase por Fase

#### 1. **Discovery** — ¿Qué problema resolvemos?

**Pregunta central**: ¿Por qué existe este producto?

**Qué produces**:
- Problem statement (el problema real, no la solución)
- User personas (quién lo usa, qué necesita)
- Competitive analysis (por qué nosotros)
- Stakeholders e impactados
- Riesgos u oportunidades

**Agnóstico**: ✅ SÍ — Sin mencionar tecnologías

**Audiencia**: PM, Founders, Users, Stakeholders

**Duración típica**: 1-2 semanas

---

#### 2. **Requirements** — ¿Qué debe hacer el sistema?

**Pregunta central**: ¿Cuales son las capacidades esperadas?

**Qué produces**:
- Requisitos funcionales (RF): capacidades del usuario
- Requisitos no-funcionales (RNF): atributos de calidad
- Glossary: vocabulario unificado
- Scope boundaries: qué entra, qué no

**Agnóstico**: ✅ SÍ — "El sistema debe permitir..." no "usando JWT..."

**Audiencia**: PM, Product Owners, QA

**Duración típica**: 1-2 semanas

---

#### 3. **Design & Process** — ¿Cómo fluye el sistema?

**Pregunta central**: ¿Cuales son los procesos y el modelo de dominio?

**Qué produces**:
- System flows: flujos principales con diagramas
- Strategic design (DDD): bounded contexts, ubiquitous language
- Process decisions: alternativas consideradas
- Context models: agregados, invariantes, eventos

**Agnóstico**: 🟡 PARCIALMENTE — Arquitectural (DDD conceptos) pero no técnico

**Audiencia**: Tech Lead, Architects, Senior Devs

**Duración típica**: 2-3 semanas

---

#### 4. **UI Design** — ¿Cómo interactúa el usuario?

**Pregunta central**: ¿Cuales son los portales, pantallas y flujos de navegación?

**Qué produces**:
- Design system: principios visuales, componentes
- Wireframes: pantallas principales
- Navigation flows: cómo se mueve el usuario
- UX decisions: alternativas descartadas

**Agnóstico**: 🟡 PARCIALMENTE — Conceptual pero no de código frontend

**Audiencia**: Designers, Product Owners, Devs

**Duración típica**: 1-2 semanas (paralelo con Design)

---

#### 5. **Data Model** — ¿Cómo se estructura la información?

**Pregunta central**: ¿Cuales son las entidades y sus relaciones?

**Qué produces**:
- Entities: qué datos guardamos
- Relationships: cómo se relacionan (ERD)
- Data flows: cómo se transforma y mueve
- Constraints: invariantes de datos

**Agnóstico**: ✅ SÍ — "Base de datos relacional" no "PostgreSQL"

**Audiencia**: Architects, DBAs, Backend Devs

**Duración típica**: 1 semana (se extrae del Design)

---

#### 6. **Planning** — ¿Cuándo y cómo entregamos?

**Pregunta central**: ¿Cuales son los milestones y el roadmap?

**Qué produces**:
- Roadmap: visión a 6-12 meses
- Epics: agrupar requisitos por iniciativa
- Versioning: estrategia de versiones
- Release plan: timing y dependencias

**Agnóstico**: ✅ SÍ

**Audiencia**: PM, Tech Lead, Stakeholders

**Duración típica**: 1 semana

---

#### 7. **Development** — ¿Cómo lo construimos técnicamente?

**Pregunta central**: ¿Cuales son la arquitectura y los patrones de código?

**Qué produces**:
- Architecture: hexagonal/limpia/capas
- API reference: contratos REST/GraphQL/etc.
- Coding standards: convenciones, paterns
- ADRs: decisions técnicas

**Agnóstico**: ❌ NO — Específico a tu stack (Java, Python, Node, etc.)

**Audiencia**: Backend Devs, Frontend Devs, Tech Lead

**Duración típica**: 2-3 semanas (paralelo con testing)

---

#### 8. **Testing** — ¿Cómo validamos?

**Pregunta central**: ¿Cuales son los criterios y estrategias de testing?

**Qué produces**:
- Test strategy: pirámide, cobertura, filosofía
- Test plans: planes por feature/módulo
- Security testing: OWASP, compliance
- UAT plan: user acceptance testing

**Agnóstico**: 🟡 PARCIALMENTE — Strategy agnóstica, pero implementation específica

**Audiencia**: QA, Testers, Devs

**Duración típica**: 1-2 semanas (paralelo con development)

---

#### 9. **Deployment** — ¿Cómo vamos a producción?

**Pregunta central**: ¿Cuales son los ambientes y pipelines CI/CD?

**Qué produces**:
- Environments: dev, staging, prod
- CI/CD: pipelines, gates, automatización
- Release process: steps para un release seguro
- Rollback strategy: cómo revertir

**Agnóstico**: ❌ NO — Específico a tu infraestructura (Docker, K8s, AWS, etc.)

**Audiencia**: DevOps, Tech Lead, SREs

**Duración típica**: 1 semana

---

#### 10. **Operations** — ¿Cómo operamos en producción?

**Pregunta central**: ¿Cuales son los procedimientos operacionales?

**Qué produces**:
- Runbooks: procedimientos paso a paso
- Incident response: protocolo de incidentes
- SLAs: acuerdos de nivel de servicio
- Escalamiento: cuándo alertar a quién

**Agnóstico**: 🟡 PARCIALMENTE — Procesos agnósticos, tooling específico

**Audiencia**: DevOps, SREs, On-Call Team

**Duración típica**: 1 semana

---

#### 11. **Monitoring** — ¿Cómo medimos la salud?

**Pregunta central**: ¿Cuales son las métricas y alertas clave?

**Qué produces**:
- Metrics: qué medimos (técnicas, negocio)
- Alerts: cuándo alertar, por qué
- Dashboards: cómo visualizar
- SLO/SLI: objetivos y indicadores

**Agnóstico**: 🟡 PARCIALMENTE — Qué medir es agnóstico, cómo específico

**Audiencia**: DevOps, SREs, PM

**Duración típica**: 1 semana

---

#### 12. **Feedback** — ¿Qué aprendemos?

**Pregunta central**: ¿Qué mejorar en el próximo ciclo?

**Qué produces**:
- Retrospectives: aprendizajes por ciclo
- User feedback: qué piden los usuarios
- Metrics analysis: qué dicen los números
- Process improvements: evolución del proceso

**Agnóstico**: ✅ SÍ

**Audiencia**: Todos

**Duración típica**: 1 semana (al final de cada ciclo)

---

## Principios de Diseño

### 1. Agnóstico-First (Fases 1-5)

**Principio**: Describe el problema y su solución conceptual ANTES de comprometerte con tecnología.

**Beneficio**: 
- Si cambias de stack, la visión sigue siendo válida
- No-técnicos pueden contribuir
- El código puede refactorizarse sin re-documentar

**Cómo**: 
- Usa términos de dominio (no nombres de tecnología)
- Describe "qué" y "por qué", no "cómo"

### 2. Iterable (No Waterfall)

**Principio**: Cada feature/dominio puede estar en fases distintas simultáneamente.

**Beneficio**:
- No esperes a tener todo el design para empezar a código
- Feedback temprano
- Aprendizaje continuo

**Cómo**:
- Etiqueta cada documento con: dominio, versión, estado
- Mapea features a contextos de dominio
- Actualiza macro-plan cuando avanza una fase

### 3. Vivo, No Congelado

**Principio**: Los documentos se actualizan cuando cambia la realidad.

**Beneficio**:
- La documentación sigue siendo verdadera
- El equipo confía en ella
- Punto de referencia único (no conflictos con código)

**Cómo**:
- Ownership claro (quién mantiene este doc)
- Trigger de actualización (cuándo actualizar)
- Revisiones periódicas (trimestrales)

### 4. Trazable End-to-End

**Principio**: Un requisito debe rastrearse desde discovery hasta métrica.

**Beneficio**:
- Validar cobertura (¿nada se cae?)
- Entender impacto (¿qué requisito afecta qué métrica?)
- Debugear (¿de dónde viene este bug?)

**Cómo**:
- Usa IDs consistentes (RF-001, T-001, M-001)
- Incluye cross-references
- Mantén una matriz de trazabilidad

### 5. Colaborativo-Friendly

**Principio**: La documentación es fácil de generar con IA y de revisar con el equipo.

**Beneficio**:
- No bloquea al equipo (generación rápida)
- Fácil de iterar (templates claros)
- Fácil de validar (checklists explícitos)

**Cómo**:
- Templates parametrizables
- Instrucciones claras para IA
- Validación checklist

---

## Agnóstico vs. Específico

### Matriz de Decisión

| Fase | Agnóstico? | Ejemplos de "SÍ" | Ejemplos de "NO" |
|------|-----------|------------------|------------------|
| Discovery | ✅ SÍ | "El usuario necesita autenticarse" | "Usamos OAuth2" |
| Requirements | ✅ SÍ | "RF: Permitir login multi-factor" | "Implementar TOTP" |
| Design | 🟡 PARCIAL | "Bounded Context: Identity" | "Spring Security @PreAuthorize" |
| UI Design | 🟡 PARCIAL | "Pantalla: Login Modal" | "Usar React Modal component" |
| Data Model | ✅ SÍ | "Entidad: Usuario (id, email, name)" | "PostgreSQL SERIAL type" |
| Planning | ✅ SÍ | "Fase 1: MVP Authentication" | "Sprint 1: 2 developers" |
| Development | ❌ NO | Stack específico es OK | "PostgreSQL, Java 21, React" |
| Testing | 🟡 PARCIAL | "Unit tests for User entity" | "JUnit 5, Mockito" |
| Deployment | ❌ NO | Stack específico es OK | "Docker, K8s, GitHub Actions" |
| Operations | 🟡 PARCIAL | "Runbook: Deploy a staging" | "ssh ec2-user@ip, ansible" |
| Monitoring | 🟡 PARCIAL | "Métrica: Login success rate" | "Prometheus, Grafana" |
| Feedback | ✅ SÍ | "Aprendizaje: Usuarios quieren SSO" | "Usaremos Okta" |

### Regla Práctica

**Pregúntate**: ¿Entendería esto una persona sin conocer mi stack?

- **SÍ** → Usa términos agnósticos
- **NO** → Especifica tu stack explícitamente

---

## Mapa Mental

```
Product Vision (Discovery)
    ↓
Problem Statement & Actors
    ↓
Functional Requirements (RF-001..N)
    ↓
Non-Functional Requirements (RNF-001..N)
    ├─ Scope Boundaries
    ├─ Priority Matrix (MoSCoW)
    └─ Glossary
         ↓
    System Flows
    (cómo fluye el negocio)
         ↓
    Strategic Design (DDD)
    ├─ Bounded Contexts
    ├─ Ubiquitous Language
    ├─ Context Maps
    └─ Domain Events
         ├─ UI Design
         │  ├─ Design System
         │  ├─ Wireframes
         │  └─ Navigation Flows
         │
         └─ Data Model
            ├─ Entities
            ├─ Relationships (ERD)
            └─ Data Flows
                  ↓
            Planning & Roadmap
            (cuándo entregamos)
                  ↓
            Development Architecture
            (cómo lo codificamos)
                  ├─ Hexagonal Ports & Adapters
                  ├─ Module-to-Context Mapping
                  ├─ API Contracts
                  └─ Coding Standards
                  ├─ Test Strategy
                  │  ├─ Unit Tests
                  │  ├─ Integration Tests
                  │  └─ E2E Tests
                  │
                  ├─ Deployment & CI/CD
                  │
                  ├─ Operations (Runbooks)
                  │  ├─ Monitoring
                  │  ├─ Incident Response
                  │  └─ SLAs
                  │
                  └─ Feedback & Learning
                     (vuelve a Discovery)
```

---

## Cuándo Extender o Adaptar

### Escenarios Comunes

#### 1. "Mi producto es muy simple, ¿necesito 12 fases?"

**Respuesta**: No. Usa lo que necesites:

- **Startup MVP** (1-3 meses): Discovery + Requirements + Design + Development + Testing
- **Producto maduro** (iteración): Todas las 12
- **Mantenimiento**: Operations + Monitoring + Feedback

Siempre mantén:
- ✅ Discovery (entender el problema)
- ✅ Requirements (especificar qué)
- ✅ Testing (validar funciona)

#### 2. "Mi organización usa Scrum/Kanban, ¿es incompatible?"

**Respuesta**: No, son complementarios:

- **SDLC Framework** (este): Estructura de documentación (qué producir)
- **Scrum/Kanban**: Metodología de ejecución (cómo organizar el trabajo)

**Mapping**:
```
Scrum Sprint (1-2 semanas)
  ├─ Discovery tasks (explorar feature nueva)
  ├─ Development tasks (codificar requisitos)
  ├─ Testing tasks (validar)
  └─ Documentación (actualizar docs de cada fase)
```

#### 3. "Tengo documentación existente en otro formato, ¿cómo migro?"

**Respuesta**: Gradualmente:

1. Identifica qué documentación tienes (audit)
2. Mapea a las 12 fases
3. Migra fase por fase
4. Rellena gaps con IA

Ejemplo:
```
Existente: "API Spec" 
  → Va a: 06-development/api-reference.md

Existente: "Product Roadmap" 
  → Va a: 05-planning/roadmap.md

Gap identificado: No hay Discovery document
  → Generar con IA
```

#### 4. "Queremos más/menos detalle en algunas fases"

**Respuesta**: Personaliza los templates:

- 📉 **Reducir**: Elimina secciones opcionales
- 📈 **Aumentar**: Agrega secciones a templates

Ejemplo (reducir Requirements):
```markdown
# RF-001: User Login

Descripción: ...
Criterios de Aceptación: ...
(eliminar: Riesgos, Notas de Implementación)
```

---

## Gobernanza de Templates

### Estructura de Template

Cada archivo `TEMPLATE-*.md` sigue este patrón:

```markdown
[← Índice](./README.md) | [< Anterior] | [Siguiente >]

---

# [NOMBRE DEL DOCUMENTO]

[1-2 frases de propósito]

## Contenido

[Índice de secciones]

---

## Sección 1

[Contenido]

[↑ Volver al inicio](#nombre-del-documento)

---

## Sección N

[Contenido]

[↑ Volver al inicio](#nombre-del-documento)

---

[← Índice] | [< Anterior] | [Siguiente >]
```

### Cuándo Actualizar Un Template

Actualiza un template cuando:

- ✏️ Descubres una sección faltante
- ✏️ Una sección es confusa
- ✏️ El orden debería cambiar
- ✏️ Hay un nuevo requisito

**NO** actualices cuando:
- ❌ Un documento concreto necesita tweaks (usa ese documento, no el template)
- ❌ Cambios de corta duración (ciclo temporal)

### Cómo Proponer Cambios

Si tienes una mejora a los templates:

1. Documenta el cambio propuesto en `IMPROVEMENTS.md` (crear si no existe)
2. Explica por qué (impacto, beneficio)
3. Proporciona un ejemplo del template mejorado
4. Discute con el equipo
5. Aplica a todos los templates si se aprueba

---

## Contribución a la Plantilla

### Dónde Reportar Issues

- **Bug** (template roto, instrucción incorrecta): Issues del repo
- **Feature** (nueva sección, nueva fase): Discussiones
- **Mejora** (hacer más claro, más corto): Pull Request

### Plantilla de Issue

```markdown
**Tipo**: Bug / Feature / Enhancement

**Ubicación**: [ej: 00-GUIDE-AND-INSTRUCTIONS/INSTRUCTIONS-FOR-AI.md]

**Problema**: [describe en 2-3 oraciones]

**Impacto**: [quién se ve afectado, cuántos documentos]

**Solución propuesta**: [qué cambiar]

**Ejemplo** (si aplica):
```

### Cómo Mantener la Plantilla Agnóstica

Cuando contribuyas:

1. **Revisa las 12 fases**: ¿Tu cambio afecta a alguna?
2. **Valida agnóstico**: ¿Sigue siendo agnóstico en fases 1-5?
3. **Prueba con ejemplo**: ¿Funciona para productos distintos?
4. **Actualiza docs** si lo que cambias afecta a instrucciones

---

## Hoja de Trucos

### Renombrar un Documento

```bash
# Cambiar nombre
mv 02-requirements/TEMPLATE-glossary.md 02-requirements/glossary.md

# Actualizar referencias en README
nano 02-requirements/README.md
# Cambiar la línea del documento

# Actualizar referencias en otros docs
grep -r "TEMPLATE-glossary" .
```

### Agregar una Nueva Sección a un Template

1. Abre el template
2. Copia una sección existente como referencia
3. Adapta para tu nueva sección
4. Actualiza el Índice de Contenido al inicio
5. Prueba con IA (pide que complete la nueva sección)

### Validar Que la Plantilla Está Completa

Checklist:

- [ ] 12 carpetas de fases (00 → 11)
- [ ] Cada carpeta tiene `README.md`
- [ ] Cada README apunta a documentos en esa carpeta
- [ ] Cada documento tiene `[← Índice]` y navegación
- [ ] No hay archivos `TEMPLATE-` sin renombrar en fase final
- [ ] Todos los links son relativos (no rutas absolutas)
- [ ] Cross-references existen (ej: RF referencia Design)

---

## Próximos Pasos

1. 📖 Lee esta guía completamente
2. 🎯 Decide: ¿Adaptaré los 12 fases o seleccionaré algunos?
3. 🔧 Comienza con adaptación de estructura (Paso 2 de [`TEMPLATE-USAGE-GUIDE.md`](./TEMPLATE-USAGE-GUIDE.md))
4. 🤖 Usa [`INSTRUCTIONS-FOR-AI.md`](./INSTRUCTIONS-FOR-AI.md) para generar contenido

---

[← Índice](./README.md)
