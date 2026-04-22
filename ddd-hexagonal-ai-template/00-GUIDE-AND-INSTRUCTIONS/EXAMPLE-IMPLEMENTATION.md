# Ejemplo Práctico: Generación de Documentación con IA

Caso de uso completo: generando documentación para **Keygo** (producto real de manejo de sesiones y permisos).

---

## Contexto: Keygo

```
Nombre: Keygo
Problema: Equipos de desarrollo pierden 2+ horas/día en gestión 
          de sesiones y permisos — no hay single source of truth
Usuarios: 
  - Desarrolladores (crean features, necesitan acceso rápido)
  - DevOps/Platform Engineers (mantienen infra, auditoría)
  - PM/Managers (control, compliance, reportes)
Mercado: Compite con Vault (demasiado complejo), soluciones caseras
Stack: Go + gRPC backend, React frontend, PostgreSQL, Kubernetes
Timeline: MVP en 8 semanas (Q2 2026)
```

---

## Día 1: Preparación (30 min)

### Información Recopilada

```markdown
# Keygo - Información del Producto

## Visión en 3 líneas
Keygo es la fuente única de verdad para identidad y autorización.
Equipos gastan horas sincronizando sesiones y permisos.
Keygo centraliza, audita y automatiza — reduciendo Time to Access de horas a minutos.

## Problema específico
Hoy:
- Desarrollador necesita acceso → email a Platform → espera 4-24 horas
- PM no puede auditar quién tiene qué → requiere auditoría manual
- No hay auto-revocación de sesiones → riesgo de seguridad

Con Keygo:
- Dev pide acceso → aprobado en minutos → acceso inmediato
- Auditoría automática de quién/qué/cuándo
- Sesiones se revocan automáticamente

## Usuarios
1. **Developer** (técnico)
   - Necesita acceder a servicios (dev, staging, prod)
   - Urgencia: alta (necesita acceso ahora)
   - Frustración: espera, múltiples sistemas

2. **DevOps Engineer** (técnico)
   - Mantiene infraestructura y policies
   - Necesita auditoría y control
   - Frustración: inconsistencia, falta de visibilidad

3. **Manager** (no técnico)
   - Necesita reportes de compliance
   - Supervisión de quién accede qué
   - Frustración: falta de trazabilidad

## Restricciones
- Debe integrar con K8s existente
- Debe cumplir regulaciones de seguridad internas
- Debe soportar múltiples cloud providers (AWS, GCP)
- Latencia de decisión <500ms (crítico)

## Stack técnico
- Backend: Go 1.21, gRPC, goreleaser
- Frontend: React 19, TypeScript
- Database: PostgreSQL 15+
- Infrastructure: Kubernetes 1.24+, Docker
- CI/CD: GitHub Actions
```

### Preparación Local

```bash
# 1. Copiar plantilla
cp -r ddd-hexagonal-ai-template/ docs/

# 2. Crear rama de documentación
git checkout -b docs/initialize-keygo-docs

# 3. Renombrar archivos TEMPLATE-*
cd docs/
find . -name "TEMPLATE-*.md" -type f | while read f; do
  newname=$(echo "$f" | sed 's/TEMPLATE-//')
  mv "$f" "$newname"
done

# 4. Actualizar MACRO-PLAN.md y README.md
# [editar manualmente]

# 5. Commit
git add .
git commit -m "docs: initialize DDD+Hexagonal documentation for Keygo"
```

---

## Día 2: Discovery 1.1 — Context & Motivation

### Tú (20 min):

Prepara el prompt copiando de `AI-WORKFLOW-GUIDE.md` — sección "Discovery 1.1":

```markdown
# Contexto del Producto

Mi producto es: Keygo — single source of truth para identidad y autorización.

Problema: Equipos de desarrollo pierden 2+ horas/día en gestión de sesiones
y permisos. No hay visibilidad ni control centralizado.

Usuarios: 
  - Desarrolladores (acceso rápido a servicios)
  - DevOps/Platform Engineers (control, auditoría)
  - Managers (compliance, reportes)

Mercado: Competencia con Vault (demasiado complejo), soluciones caseras,
herramientas genéricas no adaptadas a equipos ágiles.

---

# Tarea

Genera "01-discovery/context-motivation.md" basado en la plantilla adjunta.

---

# Plantilla

[COPIAR COMPLETO de TEMPLATE-context-motivation.md]

---

# Requisitos Específicos

## Contenido
- Extensión: 2000-2500 palabras
- Secciones obligatorias:
  1. Problema Concreto
  2. Contexto de Mercado
  3. Motivación Estratégica
  4. Actores e Impactados
  5. Riesgos Iniciales
  6. Oportunidades
  7. Supuestos Clave

## Estilo
- Agnóstico: NO mencionar Kubernetes, Go, React, PostgreSQL
- Accesible a ejecutivos y PM (algunos no-técnicos)
- Narrativo pero profesional

## Datos Concretos
- Equipos pierden 2+ horas/día (dato concreto)
- Access time hoy: 4-24 horas, con Keygo: <5 minutos
- Mercado: startups de 20-500 personas
- Competencia: Vault, 1Password, soluciones caseras

---

# Validación

Después de escribir:
- [ ] Responde claramente: "¿Cuál es el problema?"
- [ ] Diferencia problema (qué está mal) vs visión (solución)
- [ ] No prescribe tecnología
- [ ] Riesgos documentados (seguridad, adoption, integración)
- [ ] Párrafos <4 líneas
- [ ] Lenguaje claro (sin jargon)
```

### IA (2-5 min):

Pega el prompt en Claude y espera.

IA genera documento (~2000 palabras) similar a:

```markdown
# Context & Motivation: Keygo

## El Problema Real

Los equipos de ingeniería modernos no tienen una solución centralizada
para gestionar identidad y autorización...

[Documento generado por IA — largo, estructurado, agnóstico]
```

### Tú (5-10 min):

```markdown
# Validación del documento generado

✅ Sección "Problema": Claro. Específica horas/día, competencia, urgencia.
✅ Sección "Mercado": Menciona Vault, soluciones caseras. Sin prescribir cómo.
✅ Sin tecnología: No hay "Kubernetes", "gRPC", "PostgreSQL".
✅ Números: 2+ horas/día, 4-24 horas access time, startups 20-500 personas.
✅ Riesgos: Seguridad, adoption, integración — con explicación.
✅ Tono: Profesional, narrativo, no vendedor.
✅ Extensión: 2100 palabras.

Resultado: ✅ APROBADO
```

**Guardar documento**:

```bash
mv 01-discovery/TEMPLATE-context-motivation.md 01-discovery/context-motivation.md
git add 01-discovery/context-motivation.md
git commit -m "docs(discovery): add context and motivation"
```

---

## Día 2 (tarde): Discovery 1.2 — System Vision

### Tú (5 min):

Resume el documento anterior y pide el siguiente:

```markdown
# Contexto

Discovery completado: Keygo pierde equipos 2+ horas/día en gestión
de sesiones. Market opportunity: centralizar identidad sin complejidad
de soluciones genéricas.

---

# Tarea

Genera "01-discovery/system-vision.md" basado en la plantilla.

---

# Plantilla

[COPIAR TEMPLATE-system-vision.md]

---

# Requisitos

## Contenido (1500-2000 palabras)
- Visión a 5 años
- Qué es Keygo (definición clara)
- Qué NO es (límites explícitos)
- 3-5 principios rectores
- Beneficios esperados (usuarios + negocio)
- Diferenciación vs Vault, 1Password
- Success metrics (medibles)

## Importante
- Inspiracional pero realista
- Agnóstico
- Tangible (números, no solo aspiración)
```

### IA (2 min):

Genera documento con visión, principios, beneficios.

### Tú (5 min):

Valida:
- ✅ Diferente de context-motivation (problema vs visión)
- ✅ Límites claros ("Keygo es X", "NO es Y")
- ✅ Success metrics cuantitativos (ej: "reducir access time a <5 min")

---

## Día 3: Discovery 1.3 — Actors & Needs

### Tú (5 min):

```markdown
# Contexto

[Vision + Context-Motivation]

---

# Tarea

Genera dos documentos:
1. "01-discovery/actors.md"
2. "01-discovery/needs-expectations.md"

---

# Documento 1: Actors (1500 palabras)

Actores a documentar:
1. Developer (quién, qué hace, dolor, incentivos, restricciones)
2. DevOps Engineer
3. Manager/PM
4. [Sistema externo: Cloud Provider]

---

# Documento 2: Needs (2000 palabras)

Por cada actor: qué necesita, por qué, alternativas, problemas con ellas.

Incluir tabla MoSCoW: Must / Should / Could.
```

### IA (3 min):

Genera ambos documentos.

### Tú (10 min):

Valida coherencia con discovery anterior.

---

## Día 4-5: Requirements (3 documentos)

### Tarea 1: Glossary

**Tú**: Prepara lista de términos del dominio (30-50):
- Sesión, Usuario, Rol, Permiso, Token, etc.

**IA**: Genera con definiciones, contexto, ejemplos.

**Tú**: Valida que todo término se entiende sin externo.

---

### Tarea 2: RF/RNF

**Tú**: Haz lista base:
```
RF-001: Usuario puede iniciar sesión
RF-002: Admin puede crear nueva sesión
RF-003: Usuario puede ver sus sesiones activas
RF-004: Sistema revoca sesión expirada automáticamente
RNF-001: Latencia <500ms al 99th percentile
RNF-002: Disponibilidad 99.9%
RNF-003: Soportar 10k usuarios simultáneos
```

**IA**: Para cada RF/RNF, genera documento con:
- Descripción
- Justificación
- Criterios de Aceptación (Gherkin)
- Dependencias
- Riesgos

**Tú**: Valida que cada uno es independiente y verificable.

---

### Tarea 3: Priority Matrix & Scope

**IA**: Genera tabla MoSCoW con todos los RF.

**Resultado esperado**:

| ID | Nombre | Categoría | Justificación |
|----|--------|-----------|---------------|
| RF-001 | User Login | Must | Core del MVP |
| RF-004 | Auto Revoke | Should | Seguridad, v1.1 |
| RF-010 | ML Anomaly | Won't | Requiere data, v2.0 |

---

## Día 6-7: Design (3 documentos)

### Tarea 1: Strategic Design (Bounded Contexts)

**Tú**: Identifica dominios:
- Identity Context: autenticación, sesiones
- Authorization Context: roles, permisos
- Audit Context: logs, trazabilidad

**IA**: Genera con:
- Domain Vision Statement
- Subdomain Classification (Core/Supporting/Generic)
- Lenguaje ubicuo por contexto
- Agregados raíces

---

### Tarea 2: System Flows

**IA**: Genera 5-8 flujos:
1. User Login
2. Grant Permission
3. Revoke Session (expiry)
4. Audit Retrieval (admin)
5. Incident: Unauthorized Access

Cada flujo: pasos, decisiones, diagrama Mermaid sequence.

---

### Tarea 3: Bounded Context Models

**IA**: Genera modelos para cada contexto:

**Identity Context**:
- Agregados: Usuario (root), Sesión, Credencial
- Eventos: UserAuthenticated, SessionCreated, SessionExpired
- Invariantes: Usuario → múltiples sesiones, pero single active

---

## Día 8: Data Model (2 documentos)

**IA**: Genera:

1. **Entities**: User, Session, Role, Permission, with attributes
2. **Relationships**: 
   - User 1:N Session
   - User M:N Role
   - Role M:N Permission
   - ERD Mermaid

---

## Día 9: Planning (2 documentos)

**IA**: Genera:

1. **Roadmap** (6 meses):
   - Phase 1 MVP (RF-001-004): 8 weeks
   - Phase 2 Advanced Auth (SSO): 6 weeks
   - Phase 3 Analytics: Q4

2. **Epics** (decomposición de RF):
   - Epic 1: User Authentication (RF-001, 002)
   - Epic 2: Session Management (RF-003, 004)
   - Epic 3: Audit & Compliance (RF-005+)

---

## Día 10+: Development (Technical Stack Specific)

Aquí incluyes tecnología específica:

```markdown
# Stack Técnico
Backend: Go 1.21, gRPC
Frontend: React 19, TypeScript
Database: PostgreSQL 15
Infrastructure: Kubernetes 1.24+

---

# Tarea

Genera "06-development/architecture.md" con:
- Hexagonal architecture diagram
- Bounded Contexts → modules
- gRPC services mapping
- Repository pattern for persistence
```

---

## Resultado Final

Después de 10 días:

```
✅ 01-discovery/
   ├── context-motivation.md (2100 palabras)
   ├── system-vision.md (1800 palabras)
   ├── actors.md (1500 palabras)
   └── needs-expectations.md (2000 palabras)

✅ 02-requirements/
   ├── glossary.md (40 términos)
   ├── functional/ (8 RF documentados)
   ├── non-functional/ (3 RNF documentados)
   ├── priority-matrix.md
   └── scope-boundaries.md

✅ 03-design/
   ├── strategic-design.md (3 contextos)
   ├── system-flows.md (8 flujos + diagramas)
   └── bounded-contexts/ (3 modelos)

✅ 04-data-model/
   ├── entities.md (12 entidades)
   ├── relationships.md (ERD)

✅ 05-planning/
   ├── roadmap.md (6 meses)
   └── epics.md (10 epics)

✅ 06-development/ [technical — requiere stack específico]
   ├── architecture.md
   ├── api-reference.md
   └── coding-standards.md
```

**Documentación completa**: ~30,000 palabras  
**Trabajo humano**: ~25-30 horas de lectura, validación, ajustes  
**Esfuerzo IA**: ~15 minutos de generación (time elapsed)  
**Tiempo total**: 10-12 días de calendario  

---

## Checklist de Validación Cross-Fase

```markdown
# Post-Documentación: Coherencia Integral

Después de completar todas las fases:

✅ Discovery → Requirements
   - ¿Cada Need → al menos 1 RF?
   - ¿Cada RF es consecuencia de Need identificada?

✅ Requirements → Design
   - ¿Cada RF → implementable en system flow?
   - ¿Design flows → cubren todos los Must RF?

✅ Design → Data Model
   - ¿Cada agregado → presente en data model?
   - ¿Relaciones → soportan los flujos de design?

✅ Data Model → Planning
   - ¿Cada epic → cubre uno o más contextos de design?
   - ¿MVP → completa un flujo end-to-end?

✅ Planning → Development
   - ¿Arquitectura → refleja contextos de design?
   - ¿APIs → cubren los flujos de sistema?

✅ Trazabilidad Completa
   - Selecciona 1 RF (ej: RF-001 "User Login")
   - Traza: Discovery need → System flow → Bounded context → Entities → Epic → API endpoint
   - ¿Todo conectado? ✅
```

---

## Conclusión

Este ejemplo muestra:
- **Flujo día a día**: qué hacer cada jornada
- **Inputs/Outputs**: qué pasas a IA, qué validar
- **Tiempos reales**: no es magia, toma ~30 minutos por documento
- **Validación en tiempo real**: no esperes a completar todo
- **Resultado**: documentación lista para arquitectos, ingenieros, PMs

---

[← HOME](../README.md)
