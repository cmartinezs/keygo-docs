# Skills & Plugins: Guía Completa para DDD + Hexagonal

Cómo usar Claude Code skills y plugins para acelerar cada fase de la documentación y desarrollo.

---

## Tabla de Contenido

- [General: Todos los skills útiles](#general-todos-los-skills-útiles)
- [Por Fase](#por-fase)
  - [Discovery & Requirements](#discovery--requirements)
  - [Design](#design)
  - [Development](#development)
  - [Testing](#testing)
  - [Deployment & CI/CD](#deployment--cicd)
  - [Operations](#operations)
  - [Monitoring](#monitoring)
  - [Feedback & Learning](#feedback--learning)
- [Cómo Instalar/Activar](#cómo-instalarmactivar)
- [Recomendaciones de Uso](#recomendaciones-de-uso)

---

## General: Todos los Skills Útiles

### 🎯 Core Skills (Usar en TODAS las fases)

#### 1. **domain-driven-design**
- **Qué hace**: Guía modelado de software alrededor del dominio del negocio
- **Cuándo usarlo**: Antes de diseñar cualquier cosa
- **Para DDD Template**: CRÍTICO — asegura que tu modelo refleja el negocio real
- **Cómo usar**:
  ```
  /domain-driven-design
  
  [Describe tu modelo/agregado/contexto acá]
  ```
- **Triggers automáticos**: Cuando mencionas "bounded context", "ubiquitous language", "aggregate", "context mapping"

**Clave**: Verifica que tu estrategia de diseño alínea completamente con esta guía antes de avanzar a código.

---

#### 2. **code-craftsmanship:clean-code**
- **Qué hace**: Revisión de código para legibilidad, mantenibilidad, eficiencia
- **Cuándo usarlo**: Después de escribir código (testing, development)
- **Para DDD Template**: Asegura que el código refleja el dominio (nombres, estructura)
- **Cómo usar**:
  ```
  /code-craftsmanship:clean-code
  
  [Pega tu código para revisar]
  ```

---

#### 3. **code-craftsmanship:software-design-philosophy**
- **Qué hace**: Principios de diseño (SOLID, complexity management)
- **Cuándo usarlo**: Planning de arquitectura, decisiones de diseño
- **Para DDD Template**: Complementa DDD con principios arquitectónicos

---

#### 4. **functional-requirements**
- **Qué hace**: Escritura y revisión de requisitos funcionales
- **Cuándo usarlo**: Fase 2 (Requirements)
- **Para DDD Template**: Asegura RF correctos (no tecnología, claro, verificable)

---

#### 5. **security-review**
- **Qué hace**: Auditoría de seguridad en código y diseño
- **Cuándo usarlo**: Después de design y antes de implementar
- **Para DDD Template**: Identifica riesgos de seguridad en tu modelo

---

### 🛠️ Dev Tools (Uso general)

#### **dev-tools:project-docs**
- **Qué hace**: Genera documentación de proyecto completa
- **Cuándo usarlo**: Para complementar documentación de template
- **Cómo usar**:
  ```
  /dev-tools:project-docs
  
  [Describe tu proyecto, estructura, cómo empezar]
  ```

---

#### **dev-tools:project-health**
- **Qué hace**: Auditoría de configuración y salud del proyecto
- **Cuándo usarlo**: Al final para validar todo está en orden
- **Cómo usar**:
  ```
  /dev-tools:project-health
  
  [Describe tu setup: CI/CD, testing, docs, etc.]
  ```

---

#### **dev-tools:deep-research**
- **Qué hace**: Investigación profunda sobre un tema
- **Cuándo usarlo**: Para validar decisiones de diseño o arquitectura
- **Cómo usar**:
  ```
  /dev-tools:deep-research
  
  ¿Debería usar Event Sourcing para mi audit trail?
  ```

---

#### **dev-tools:brains-trust**
- **Qué hace**: Segunda opinión de expertos
- **Cuándo usarlo**: Para validar decisiones de arquitectura complejas
- **Cómo usar**:
  ```
  /dev-tools:brains-trust
  
  ¿Es correcto mi strategic design con estos 3 bounded contexts?
  ```

---

---

## Por Fase

### Discovery & Requirements

#### **01-discovery/ & 02-requirements/**

| Skill | Uso | Comando | Resultado |
|-------|-----|---------|-----------|
| **functional-requirements** | Revisar RF escritos | `/functional-requirements` + [RF text] | Validación de claridad, verificabilidad, agnóstico |
| **dev-tools:deep-research** | Validar supuestos | `/dev-tools:deep-research` | Research sobre mercado, competencia |
| **domain-driven-design** | Identificar lenguaje ubicuo | `/domain-driven-design` + [glossary] | Validación de términos, claridad de conceptos |

**Workflow típico**:
```
1. Genera Discovery/Requirements con AI (ver AI-WORKFLOW-GUIDE.md)
2. Después, pasa documents a /functional-requirements
3. Si tienes duda sobre un requisito, usa /dev-tools:deep-research
4. Para glossary: /domain-driven-design (valida lenguaje ubicuo)
```

---

### Design

#### **03-design/ (Strategic Design + Bounded Contexts)**

| Skill | Uso | Comando | Resultado |
|-------|-----|---------|-----------|
| **domain-driven-design** ⭐ | CRÍTICO: Validar bounded contexts | `/domain-driven-design` + [strategic-design.md] | Score 0-10 para modelo de dominio |
| **code-craftsmanship:software-design-philosophy** | Validar decisiones arquitectónicas | `/code-craftsmanship:software-design-philosophy` | Análisis de principios (SOLID, etc.) |
| **dev-tools:brains-trust** | Segunda opinión sobre contextos | `/dev-tools:brains-trust` | Validación de boundaries y context mapping |

**Workflow típico**:
```
1. Genera Strategic Design + Bounded Contexts con AI
2. Pasa a /domain-driven-design para validación DDD
   → Espera score, mejora hasta 10/10
3. Pasa a /code-craftsmanship:software-design-philosophy
   → Valida que arquitectura sigue principios
4. Si contextos son complejos: /dev-tools:brains-trust
```

**Ejemplo**: 
```
/domain-driven-design

# Mi Modelo de Dominio

Bounded Contexts:
1. Identity: autenticación, sesiones
2. Authorization: roles, permisos
3. Audit: logs de acceso

Lenguaje Ubicuo (Identity):
- Sesión: estado autenticado de usuario
- Token: credencial temporal
- Usuario: identidad única

[Strategic design completo]

→ Claude revisa y da score DDD
```

---

### Development

#### **06-development/ (Architecture + API + Coding Standards)**

| Skill | Uso | Comando | Resultado |
|-------|-----|---------|-----------|
| **domain-driven-design** | Validar que arquitectura refleja dominio | `/domain-driven-design` | Mapeo de agregados → módulos, nombres en código |
| **code-craftsmanship:clean-code** ⭐ | Revisar código escrito | `/code-craftsmanship:clean-code` | Feedback sobre legibilidad, naming, estructura |
| **code-craftsmanship:refactoring-patterns** | Mejorar código existente | `/code-craftsmanship:refactoring-patterns` | Sugerencias de refactor (Extract Method, etc.) |
| **dev-tools:fork-discipline** | Si tienes repo monolítico | `/dev-tools:fork-discipline` | Auditoría de separación core/client |
| **security-review** | Revisar seguridad en APIs | `/security-review` + [architecture.md + api-reference.md] | Identificar vulnerabilidades, mejoras de seguridad |

**Workflow típico**:
```
1. Genera architecture.md, api-reference.md, coding-standards.md con AI
2. Para cada módulo/componente importante:
   a) /domain-driven-design → Valida que nombres reflejan dominio
   b) /code-craftsmanship:clean-code → Revisa código
   c) /code-craftsmanship:refactoring-patterns → Si hay deuda técnica
3. /security-review → Auditoría de seguridad
4. Si es monolítico: /dev-tools:fork-discipline → Detectar violaciones de límites
```

**Ejemplo**:
```
/code-craftsmanship:clean-code

# Mi Arquitectura Hexagonal

Aquí está mi código de Identity Context:

[Pega identityController.go, userRepository.go, etc.]

→ Claude revisa y da feedback sobre:
  - Nombres (¿reflejan dominio?)
  - Legibilidad
  - Violaciones de DDD (anemic model, etc.)
```

---

#### **Frontend (si aplica)**

| Skill | Uso | Comando | Resultado |
|-------|-----|---------|-----------|
| **frontend:react-patterns** | Revisar componentes React | `/frontend:react-patterns` | Patrones de performance, structure |
| **frontend:shadcn-ui** | Instalar/usar shadcn components | `/frontend:shadcn-ui` | Setup inicial + patrones |
| **frontend:tailwind-theme-builder** | Setup de Tailwind v4 | `/frontend:tailwind-theme-builder` | Tema configurado, design system |
| **dev-tools:responsiveness-check** | Testear responsive design | `/dev-tools:responsiveness-check` | Validar en desktop/tablet/mobile |
| **dev-tools:ux-audit** | Auditoría UX completa | `/dev-tools:ux-audit` | Review de flujos, usabilidad |

---

### Testing

#### **07-testing/ (Test Strategy + Test Plans)**

| Skill | Uso | Comando | Resultado |
|-------|-----|---------|-----------|
| **dev-tools:vitest** | Setup testing framework | `/dev-tools:vitest` | Vitest + composables setup |
| **code-craftsmanship:clean-code** | Revisar tests escritos | `/code-craftsmanship:clean-code` | Tests deben ser legibles |
| **security-review** | Tests de seguridad | `/security-review` | Checklist de security tests |

**Workflow típico**:
```
1. Genera test-strategy.md con AI
2. Para tests específicos:
   a) /dev-tools:vitest → Setup correcto
   b) /code-craftsmanship:clean-code → Tests son legibles
3. /security-review → Cobertura de seguridad
```

---

### Deployment & CI/CD

#### **08-deployment/ (CI/CD + Environments + Release Process)**

| Skill | Uso | Comando | Resultado |
|-------|-----|---------|-----------|
| **dev-tools:git-workflow** | Procesos de git, PR workflow | `/dev-tools:git-workflow` | Guía de branching, PR standards |
| **dev-tools:release** | Release process, versioning | `/dev-tools:release` | Plan de release, changelog, tagging |
| **cloudflare:wrangler** | Si usas Cloudflare Workers | `/cloudflare:wrangler` | Setup de Wrangler CLI |
| **cloudflare:cloudflare** | Despliegue en Cloudflare | `/cloudflare:cloudflare` | Setup completo de infraestructura |

**Workflow típico**:
```
1. Genera CI/CD pipeline config con AI
2. /dev-tools:git-workflow → Validar proceso de branching/PR
3. /dev-tools:release → Planning de releases
4. Si usas Cloudflare: /cloudflare:cloudflare → Setup infra
```

---

### Operations

#### **09-operations/ (Runbooks + Incident Response + SLAs)**

| Skill | Uso | Comando | Resultado |
|-------|-----|---------|-----------|
| **dev-tools:project-health** | Validar health checks | `/dev-tools:project-health` | Auditoría de estado del proyecto |
| **security-review** | Auditoría de seguridad operacional | `/security-review` | Checklist de seguridad ops |

**Workflow típico**:
```
1. Genera runbooks.md, incident-response.md con AI
2. /dev-tools:project-health → Validar health checks
3. /security-review → Cobertura de seguridad en incidentes
```

---

### Monitoring

#### **10-monitoring/ (Metrics + Alerts + Dashboards)**

| Skill | Uso | Comando | Resultado |
|-------|-----|---------|-----------|
| **cloudflare:web-perf** | Si usas Cloudflare | `/cloudflare:web-perf` | Análisis de performance |

**Workflow típico**:
```
1. Genera metrics.md, alerts.md, dashboards.md con AI
2. Si usas Cloudflare: /cloudflare:web-perf → Análisis de perf
```

---

### Feedback & Learning

#### **11-feedback/ (Retrospectives + User Feedback + Improvements)**

| Skill | Uso | Comando | Resultado |
|-------|-----|---------|-----------|
| **dev-tools:team-update** | Compartir updates al equipo | `/dev-tools:team-update` | Formato de update para Slack/email |
| **dev-tools:deep-research** | Investigar feedback | `/dev-tools:deep-research` | Análisis profundo de learnings |

**Workflow típico**:
```
1. Genera retrospectives.md, user-feedback.md con AI
2. /dev-tools:team-update → Formatear updates para equipo
3. /dev-tools:deep-research → Analizar tendencias de feedback
```

---

---

## Cómo Instalar/Activar

### Opción 1: Skills (Dentro de Claude Code)

**Skills ya están activos por defecto.** Para usarlos:

```
En cualquier conversación con Claude, escribe:

/domain-driven-design

o cualquier otro skill de la lista.

Claude automáticamente activa el skill y aplica su contexto.
```

**Disponibles sin instalación**:
- Todos los skills listados arriba ya están en tu Claude Code
- Solo necesitas escribir `/nombre-del-skill`

---

### Opción 2: MCP Servers (Cloudflare, Google Drive, etc.)

Algunos skills requieren plugins MCP (Model Context Protocol):

**Cloudflare**:
```
Requiere autenticación OAuth

1. En conversación, escribe: /cloudflare:cloudflare
2. Claude te pide: "Authorize with Cloudflare"
3. Elige OAuth flow
4. Completa autenticación en navegador
5. Listo — puedes usar skills de Cloudflare
```

**Google Drive** (para compartir/guardar docs):
```
Sistema de Claude Code ya tiene integración.

Si necesitas:
- Subir documentos: Usa /mcp__claude_ai_Google_Drive__create_file
- Descargar: Usa /mcp__claude_ai_Google_Drive__download_file_content
- Buscar: Usa /mcp__claude_ai_Google_Drive__search_files
```

---

### Opción 3: Configurar Skills en `settings.json`

Para usar skills específicos **por defecto** en ciertas carpetas:

```json
{
  "skills": {
    "domains": [
      {
        "path": "ddd-hexagonal-ai-template/03-design/",
        "skills": ["domain-driven-design", "code-craftsmanship:software-design-philosophy"]
      },
      {
        "path": "ddd-hexagonal-ai-template/06-development/",
        "skills": ["code-craftsmanship:clean-code", "domain-driven-design", "security-review"]
      },
      {
        "path": "ddd-hexagonal-ai-template/07-testing/",
        "skills": ["dev-tools:vitest", "code-craftsmanship:clean-code"]
      }
    ]
  }
}
```

Así, cuando trabajes en `03-design/`, los skills DDD se activan automáticamente.

---

---

## Recomendaciones de Uso

### 🎯 Minimal Setup (Para empezar)

Si tienes poco tiempo, prioriza estos 3:

```
1. /domain-driven-design
   → Úsalo ANTES de cualquier design
   → Validar modelo cada fase de design
   
2. /code-craftsmanship:clean-code
   → Úsalo DESPUÉS de escribir código
   → Revisar cada módulo/componente importante
   
3. /security-review
   → Úsalo en DESIGN y en DEVELOPMENT
   → No dejes seguridad para el final
```

---

### 📊 Full Stack Setup (Para hacer bien)

Si tienes tiempo, usa:

```
Discovery & Requirements:
├─ /functional-requirements
├─ /dev-tools:deep-research
└─ /domain-driven-design (para glossary)

Design:
├─ /domain-driven-design ⭐⭐⭐
├─ /code-craftsmanship:software-design-philosophy
└─ /dev-tools:brains-trust

Development:
├─ /domain-driven-design (validar módulos)
├─ /code-craftsmanship:clean-code ⭐⭐
├─ /code-craftsmanship:refactoring-patterns
├─ /security-review ⭐⭐
└─ /dev-tools:fork-discipline (si monolítico)

Testing:
├─ /dev-tools:vitest
├─ /code-craftsmanship:clean-code
└─ /security-review

Deployment:
├─ /dev-tools:git-workflow
├─ /dev-tools:release
└─ /cloudflare:cloudflare (si aplica)

Operations & Monitoring:
├─ /dev-tools:project-health
├─ /security-review
└─ /cloudflare:web-perf (si aplica)

Feedback:
├─ /dev-tools:team-update
└─ /dev-tools:deep-research
```

---

### 🔄 Workflow Recomendado por Día

**Día de generación de docs con AI**:
```
1. AI genera documento
2. Tú lo validas manualmente
3. Pasa a skill correspondiente:
   - Design → /domain-driven-design
   - Código → /code-craftsmanship:clean-code
   - Security → /security-review
4. Ajusta según feedback del skill
5. Commit
```

**Día de escritura de código**:
```
1. Escribes módulo/componente
2. /code-craftsmanship:clean-code → validar
3. /domain-driven-design (si es lógica de dominio) → validar nombres
4. /security-review (si es auth/datos sensibles) → validar
5. Tests
6. Commit
```

---

### ⚠️ Anti-Patterns (QUÉ NO HACER)

```
❌ Generar TODA la documentación sin validar con skills
✅ Genera fase, valida con skill correspondiente, ajusta, siguiente fase

❌ Usar /domain-driven-design para lógica de infraestructura
✅ Úsalo para: contextos, agregados, entities, value objects, eventos

❌ Ignorar /security-review hasta "después"
✅ Revisa security en DESIGN (decisiones) y DEVELOPMENT (implementación)

❌ Asumir que /code-craftsmanship:clean-code arregla todo
✅ Úsalo para legibilidad/estructura, no para lógica de negocio (usa /domain-driven-design)
```

---

### 📋 Checklist: Antes de Producción

Antes de shipping, ejecuta estos skills:

```
[ ] /domain-driven-design
    → Carga architecture.md + bounded contexts
    → Score debe ser 8+/10

[ ] /code-craftsmanship:clean-code
    → Pasa código más crítico (Domain logic, APIs)
    → Revisa naming, estructura

[ ] /security-review
    → Pasa architecture.md + api-reference.md + código de auth
    → Identifica y mitiga riesgos

[ ] /dev-tools:project-health
    → Validar: CI/CD, tests, docs, seguridad
    → Todo debe estar verde

[ ] /cloudflare:web-perf (si aplicable)
    → Performance OK para producción
```

---

## Resumen Rápido

| Fase | Skill Primario | Comando | Cuándo |
|------|---|---|---|
| **Discovery/Req** | functional-requirements | `/functional-requirements` | Después generar RF |
| **Design** | domain-driven-design | `/domain-driven-design` | Después strategic design |
| **Code (Backend)** | clean-code + DDD | `/code-craftsmanship:clean-code` | Después escribir módulo |
| **Security** | security-review | `/security-review` | Design + Development |
| **Testing** | vitest | `/dev-tools:vitest` | Setup testing |
| **Deploy** | git-workflow | `/dev-tools:git-workflow` | Release planning |
| **Prod** | project-health | `/dev-tools:project-health` | Antes shipping |

---

[← HOME](../README.md)
