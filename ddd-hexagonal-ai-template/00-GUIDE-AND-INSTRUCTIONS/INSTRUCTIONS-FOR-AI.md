# Instrucciones para Generar Documentación con IA

Cómo colaborar con Claude (o similar) para generar cada fase de la documentación de manera coherente y de calidad.

---

## Contenido

- [Principios generales](#principios-generales)
- [Estructura de prompt](#estructura-de-prompt)
- [Prompts por fase](#prompts-por-fase)
- [Validación checklist](#validación-checklist)
- [Troubleshooting](#troubleshooting)

---

## Principios Generales

### 1. Una fase a la vez

**NO** pidas todo de una vez. Genera fase por fase, valida, ajusta.

### 2. Proporciona contexto, no pidas que lo invente

IA es mejor generadora que inventora. Dale:

- Problem statement claro
- Lista de requisitos (si existen)
- Decisiones ya tomadas
- Restricciones conocidas

### 3. Especifica el formato

Siempre incluye en el prompt:

- Número de palabras esperado
- Secciones que debe incluir
- Nivel de detalle (ejecutivo vs. técnico)
- Referencias cruzadas esperadas

### 4. Usa ejemplos si es posible

Si tienes un ejemplo de otro producto, proporciona un extracto para que IA replique el estilo.

### 5. Valida agnóstico vs. específico

- Fases 1-5: **agnóstico de tecnología**
- Fases 6+: **específico a tu stack**

Si IA menciona nombres de tecnologías en fases 1-5, pide que abstraccionice.

---

## Estructura de Prompt

Usa esta estructura para todos los prompts:

```
[CONTEXTO]
[PREGUNTA CENTRAL]
[TEMPLATE/EJEMPLO]
[REQUISITOS ESPECÍFICOS]
[VALIDACIÓN]
```

### Ejemplo de estructura:

```markdown
# Contexto
[Información de tu producto, problema, usuarios]

# Tarea
Genera el documento "context-motivation.md" para la fase Discovery.

# Template
[Copia la sección TEMPLATE de la plantilla]

# Requisitos
- Extensión: 2000-2500 palabras
- Secciones: [lista exacta]
- Agnóstico: NO mencionar tecnologías específicas
- Referencias: Linkear a [otros docs]
- Tone: Profesional pero accesible

# Validación
Después de escribir, valida:
- [ ] Responde la pregunta "¿Qué problema resolvemos?"
- [ ] Incluye análisis de riesgos y oportunidades
- [ ] No asume que el lector conoce el dominio
- [ ] Los stakeholders se ven reflejados
```

---

## Prompts por Fase

### FASE 1: Discovery

**Pregunta central**: ¿Qué problema resolvemos y para quién?

#### Prompt 1.1: Context & Motivation

```markdown
# Contexto
Mi producto es: [DESCRIPCIÓN 2-3 ORACIONES]

Problema: [PROBLEMA ESPECÍFICO]
Usuarios: [QUIÉN LO USA]
Mercado: [CONTEXTO DE MERCADO]
Oportunidad: [POR QUÉ AHORA]

# Tarea
Genera "01-discovery/context-motivation.md" basado en la plantilla adjunta.

# Template
[COPIAR TEMPLATE-context-motivation.md]

# Requisitos
- Extensión: 2000-2500 palabras
- Secciones obligatorias:
  1. Problema (formulación clara)
  2. Contexto de mercado (competencia, oportunidad)
  3. Motivación estratégica (por qué ahora)
  4. Stakeholders e impactados
  5. Riesgos iniciales (qué podría salir mal)
  6. Oportunidades (qué ganamos si funciona)
  7. Supuestos clave (qué damos por verdadero)

# Estilo
- Agnóstico de tecnología (no nombres de frameworks, lenguajes, etc.)
- Accesible a no técnicos (ej: PM, ejecutivos)
- Profesional pero narrativo
- Incluir ejemplos si es posible

# Validación post-generación
- [ ] ¿Queda claro cuál es el problema real (no la solución)?
- [ ] ¿Se entiende por qué es importante ahora?
- [ ] ¿Se menciona a todos los stakeholders?
- [ ] ¿Hay análisis de riesgos concretos?
- [ ] ¿Es agnóstico? (sin mencionar "database", "API", "frontend", etc.)
```

#### Prompt 1.2: System Vision

```markdown
# Contexto
[Del documento anterior: context-motivation.md]

# Tarea
Genera "01-discovery/system-vision.md" basado en la plantilla.

# Template
[COPIAR TEMPLATE-system-vision.md]

# Requisitos
- Extensión: 1500-2000 palabras
- Secciones obligatorias:
  1. Visión a largo plazo (3-5 años)
  2. Qué es [PRODUCTO] (definición clara)
  3. Qué NO es (límites explícitos)
  4. Principios rectores (3-5 valores)
  5. Beneficios esperados (para usuarios y negocio)
  6. Diferenciación (cómo nos diferenciamos)
  7. Success metrics (cómo sabremos que ganamos)

# Estilo
- Inspiracional pero realista
- Agnóstico de tecnología
- Tangible (no solo aspiración)

# Validación
- [ ] ¿Es diferente del context-motivation (uno es problema, otro es visión)?
- [ ] ¿Están claros los límites (qué NO es)?
- [ ] ¿Los success metrics son medibles?
```

#### Prompt 1.3: Actors & Needs

```markdown
# Contexto
[Sistema vision + context-motivation]

# Tarea
Genera dos documentos:
1. "01-discovery/actors.md"
2. "01-discovery/needs-expectations.md"

# Requirements
Actors (1500 palabras):
- Listar 4-7 actores principales (usuarios, stakeholders, sistemas externos)
- Por cada actor: quién es, qué hace, qué incentivos tiene, qué restricciones
- Incluir diagramas o tablas

Needs (2000 palabras):
- Por cada actor: qué necesita, qué espera, dolor puntos, soluciones alternativas
- Priorización: must-have vs. nice-to-have
- Conflictos de necesidades (si existen)

# Estilo
- User-centric (personas reales, no abstracciones)
- Agnóstico de tecnología
- Incluir ejemplos concretos

# Validación
- [ ] ¿Cubren todos los stakeholders identificados?
- [ ] ¿Se entienden los dolor puntos específicos?
- [ ] ¿Las necesidades conectan con los requisitos futuros?
```

---

### FASE 2: Requirements

**Pregunta central**: ¿Qué debe hacer el sistema?

#### Prompt 2.1: Glossary

```markdown
# Contexto
[Discovery completado]

# Tarea
Genera "02-requirements/glossary.md"

# Template
[COPIAR TEMPLATE-glossary.md]

# Requisitos
- 30-50 términos del dominio
- Por cada término:
  1. Definición (1-2 oraciones)
  2. Contexto (cuándo/dónde se usa)
  3. Sinónimos (si aplica)
  4. Relacionado con (otros términos)
  5. Ejemplo

# Estilo
- Claro y preciso (como diccionario)
- Agnóstico (ej: no "JWT", pero sí "token de sesión")
- Incluir términos del negocio Y técnicos clave

# Validación
- [ ] ¿Todo término está definido sin usar otros no definidos?
- [ ] ¿Cubre los conceptos clave del dominio?
```

#### Prompt 2.2: Functional & Non-Functional Requirements

```markdown
# Contexto
[Discovery + Glossary]

# Lista de Requisitos (proporciona una lista base)
RF1: Usuario puede iniciar sesión
RF2: Usuario puede ver su perfil
RNF1: Sistema debe responder en <500ms
RNF2: Sistema debe soportar 10k usuarios concurrentes
...

# Tarea
Genera documentos individuales:
- "02-requirements/functional/rf-001-*.md"
- "02-requirements/non-functional/rnf-001-*.md"

# Template por Requisito
[COPIAR TEMPLATE-rf-template.md Y TEMPLATE-rnf-template.md]

# Estructura por Requisito
1. ID y nombre (RF-001: User Authentication)
2. Descripción (qué debe hacer)
3. Justificación (por qué es importante)
4. Criterios de aceptación (Gherkin Given/When/Then)
5. Dependencias (otros RF que necesita)
6. Riesgos (qué puede salir mal)
7. Notas de implementación (agnósticas, pero contexto útil)

# Requisitos Especiales
- Agnóstico: Describe "qué", nunca "cómo"
- Ejemplos: "El sistema debe permitir que un usuario..." no "usando JWT..."
- Criteria de aceptación: Formato Gherkin (Cucumber)

# Validación
- [ ] ¿Cada requisito es independiente?
- [ ] ¿Los criterios de aceptación son verificables?
- [ ] ¿No hay prescripción tecnológica?
- [ ] ¿Cada RF conecta con necesidades del Discovery?
```

#### Prompt 2.3: Priority Matrix & Scope Boundaries

```markdown
# Contexto
[Todos los RF/RNF generados]

# Tarea
Genera dos documentos:
1. "02-requirements/priority-matrix.md"
2. "02-requirements/scope-boundaries.md"

# Priority Matrix
- Usar MoSCoW: Must, Should, Could, Won't
- Tabla: RF/RNF | Category | Justification | Effort (low/med/high)
- Comentario: cuál es el MVP (qué es absolutamente necesario)

# Scope Boundaries
- Qué está DENTRO (MVP + fase 2)
- Qué está EXPLÍCITAMENTE FUERA (future, depende de otros, etc.)
- Razones (restricciones de tiempo, técnicas, de negocio)
- Tabla de decisiones (qué era candidato y por qué se descartó)

# Validación
- [ ] ¿El MVP es claro?
- [ ] ¿Los límites son explícitos (no solo lo no mencionado)?
- [ ] ¿Las razones son claras?
```

---

### FASE 3: Design & Process

**Pregunta central**: ¿Cómo fluye el sistema y cuál es el modelo de dominio?

#### Prompt 3.1: Strategic Design (Bounded Contexts)

```markdown
# Contexto
[Requirements completados]
[Bounded Contexts identificados en preparación]

# Lista de Contextos Iniciales
[Ej: Identity, Authorization, Billing, Organization]

# Tarea
Genera "03-design/strategic-design.md"

# Template
[COPIAR TEMPLATE-strategic-design.md]

# Estructura
1. Domain Vision Statement (por qué estos contextos)
2. Subdomain Classification:
   - Core Domains (diferenciación competitiva)
   - Supporting Domains (necesarios pero genéricos)
   - Generic Domains (commodity)
3. Bounded Contexts (nombre, responsabilidad, lenguaje ubicuo)
4. Lenguaje Ubicuo (términos clave por contexto)
5. Ubicaciones de Agregados (raíces de agregados por contexto)

# Estilo
- DDD-centric (lenguaje de contextos, subdominios, agregados)
- Agnóstico de implementación
- Incluir rationale (por qué estos límites)

# Validación
- [ ] ¿Cada contexto tiene una responsabilidad única y clara?
- [ ] ¿El lenguaje ubicuo es distinto por contexto?
- [ ] ¿Se justifica la clasificación (Core/Supporting/Generic)?
```

#### Prompt 3.2: System Flows

```markdown
# Contexto
[Strategic Design + Requirements]

# Tarea
Genera "03-design/system-flows.md"

# Estructura
Documentar 5-10 flujos principales, incluyendo:
1. User Registration / Authentication
2. Main business process (ej: Purchase, Account Setup, etc.)
3. Error/Exception handling
4. Admin operations
5. Integration points (con sistemas externos si hay)

# Por Cada Flujo
- Nombre y descripción breve
- Actores involucrados
- Pasos (1. Usuario hace X, 2. Sistema responde Y, etc.)
- Decisiones (si hay branches)
- Salida exitosa y alternativas
- Diagram (Mermaid: sequence o flowchart)

# Estilo
- Narrativo + diagrama
- Agnóstico (no mencionar "database query" sino "obtener información de X")
- Incluir contextos de dominio involucrados

# Validación
- [ ] ¿Cubren los RF principales?
- [ ] ¿Están claros los actores?
- [ ] ¿Los diagramas son legibles?
```

#### Prompt 3.3: Bounded Context Models

```markdown
# Contexto
[Strategic Design completado]

# Tarea
Genera modelos de dominio para cada Bounded Context.
Ej: "03-design/bounded-contexts/identity.md"

# Template
[COPIAR TEMPLATE-context.md]

# Por Contexto, Documenta
1. Propósito del contexto
2. Lenguaje ubicuo (10-15 términos clave)
3. Agregados principales (root entities, value objects)
4. Invariantes de dominio (qué siempre debe ser verdadero)
5. Eventos de dominio (qué ocurre cuando algo importante pasa)
6. Interfaces (cómo interactúa con otros contextos)
7. Decisiones del diseño (alternativas consideradas)

# Estilo
- DDD táctica (agregados, value objects, events)
- Agnóstico de tecnología
- Basado en requisitos específicos del contexto

# Validación
- [ ] ¿Se entiende la responsabilidad del contexto?
- [ ] ¿Los eventos de dominio son eventos del negocio, no técnicos?
- [ ] ¿Las invariantes son claras?
```

---

### FASE 4: UI Design (Opcional en versión agnóstica)

**Pregunta central**: ¿Cómo interactúa el usuario con el sistema?

```markdown
# Nota
UI Design es agnóstico a nivel de estructura, pero específico en detalles.
Se recomienda hacer esta fase DESPUÉS de que el equipo de design lo complete.

# Tarea (si quieres documentar UI conceptual)
Genera "03-design/ui/wireframes.md"

# Estructura
- Por cada pantalla principal:
  1. Nombre
  2. Propósito (qué flujo resuelve)
  3. Actores (quién la ve)
  4. Componentes principales (no nombres técnicos, sino "formulario", "tabla", etc.)
  5. Flujo de interacción (1. Usuario hace X, 2. Sistema responde Y)
  6. Estados (normal, loading, error)
  7. Diagram (ASCII o Mermaid)

# Validación
- [ ] ¿Cada pantalla tiene un propósito claro?
- [ ] ¿Se entiende el flujo sin conocer UI frameworks?
```

---

### FASE 5: Data Model

**Pregunta central**: ¿Cómo se estructura y fluye la información?

#### Prompt 5.1: Entities & Relationships

```markdown
# Contexto
[Design completo]

# Tarea
Genera "04-data-model/entities.md" y "relationships.md"

# Template
[COPIAR TEMPLATE-entities.md Y TEMPLATE-relationships.md]

# Entities Document
- Por cada entidad del dominio:
  1. Nombre y descripción
  2. Atributos (tipo, opcional/requerido, restricciones)
  3. Invariantes (qué siempre debe cumplirse)
  4. Origen (de qué requisito o flujo viene)
  5. Notas (ej: "soft delete", "auditable", etc.)
- Tabla consolidada con todas las entidades

# Relationships Document
- Diagrama ERD (Mermaid: entity relationship)
- Por cada relación: (1:1, 1:N, N:N, obligatoria/opcional)
- Tabla de relaciones con justificación

# Estilo
- Agnóstico de DB (no mencionar "SERIAL", "VARCHAR", sino "identificador único", "texto")
- Basado en entidades de dominio (del Design)

# Validación
- [ ] ¿Cada entidad corresponde a un concepto del dominio?
- [ ] ¿Las relaciones soportan los flujos del Design?
- [ ] ¿No hay tablas "genéricas" innecesarias?
```

---

### FASE 6: Planning

**Pregunta central**: ¿Cuándo y cómo entregamos?

```markdown
# Contexto
[Requirements + Design + Data Model]

# Tarea
Genera "05-planning/roadmap.md" y "epics.md"

# Roadmap
- Visión a 6-12 meses
- Fases (MVP → Phase 2 → Phase 3...)
- Por fase: nombre, duración estimada, RF inclusos, resultado esperado
- Dependencias entre fases

# Epics
- Agrupar RF por feature/capacidad
- Por epic: nombre, descripción, RF inclusos, prioridad, estimación (story points)

# Validación
- [ ] ¿El MVP es claro?
- [ ] ¿Las dependencias son explícitas?
- [ ] ¿Las estimaciones son razonables?
```

---

### FASE 7: Development

**Pregunta central**: ¿Cómo construimos esto técnicamente?

AQUÍ es donde usas tu stack específico. Proporciona:

```markdown
# Stack técnico
Backend: [ej: Java 21, Spring Boot 3.x]
Frontend: [ej: React 19, TypeScript]
Database: [ej: PostgreSQL 15]
Infrastructure: [ej: Docker, Kubernetes]

# Tarea
Genera "06-development/architecture.md" + "api-reference.md" + "coding-standards.md"

# Architecture
- Arquitectura hexagonal / limpia / por capas (según tu stack)
- Mapa de módulos a Bounded Contexts
- Patrones clave (ej: Repository, Factory, Anti-Corruption Layer)
- Flujo de request (cómo entra una solicitud, cómo se procesa)

# API Reference
- Por cada endpoint: método, ruta, parámetros, respuesta, errores
- Ejemplos de requests/responses
- Notas de seguridad (ej: qué roles pueden acceder)

# Coding Standards
- Convenciones (naming, formatting)
- Patrón de naming por rol (Controller, UseCase, Entity, etc.)
- Anti-patterns a evitar
- Testing expectations

# Validación
- [ ] ¿La arquitectura refleja el modelo de dominio?
- [ ] ¿Las APIs son RESTful (o tu estándar)?
- [ ] ¿Las convenciones son claras y consistentes?
```

---

### FASES 8-12: Testing, Deployment, Operations, Monitoring, Feedback

Para estas fases, el prompt es similar:

```markdown
# Contexto
[Todas las fases anteriores]

# Tarea
Genera "07-testing/test-strategy.md" (o equivalente por fase)

# Estructura
[Específica a la fase — ver templates]

# Validación
- [ ] ¿Conecta con los RF y el Design?
- [ ] ¿Es ejecutable por el equipo?
- [ ] ¿Incluye ejemplos concretos?
```

---

## Validación Checklist

Después de generar cada documento, valida:

### ✅ Contenido

- [ ] Responde la pregunta central de la fase
- [ ] Incluye todas las secciones requeridas
- [ ] Proporciona suficiente detalle (ni superficial ni excesivo)
- [ ] Tiene ejemplos concretos (no solo teoría)

### ✅ Estilo

- [ ] Accesible a la audiencia esperada (técnicos, no técnicos, ejecutivos)
- [ ] Profesional pero no pretencioso
- [ ] Sin jargon no explicado
- [ ] Párrafos no muy largos (max 3-4 frases)

### ✅ Consistencia

- [ ] Mantiene el tono de los documentos previos
- [ ] Usa los mismos términos (glossary)
- [ ] Referencias cruzadas funcionan
- [ ] Datos no se contradicen

### ✅ Agnóstico (fases 1-5)

- [ ] No menciona nombres de tecnologías
- [ ] Describe "qué", no "cómo"
- [ ] No asume soluciones técnicas
- [ ] Se puede entender sin conocer el stack

### ✅ Formato

- [ ] Markdown válido
- [ ] Títulos en jerarquía correcta (H1, H2, H3...)
- [ ] Listas y tablas están bien formadas
- [ ] Diagramas son legibles (Mermaid o ASCII)

---

## Troubleshooting

### Problema: IA genera contenido muy genérico

**Causa**: Contexto insuficiente

**Solución**: Proporciona ejemplos específicos de tu producto:
- Casos de uso concretos
- Restricciones reales (ej: "debe cumplir GDPR")
- Números reales (ej: "10k usuarios simultáneos")

### Problema: IA menciona tecnologías en fases agnósticas

**Causa**: Sesgo del modelo

**Solución**: Agrega instrucción explícita:
```
IMPORTANTE: Este documento es agnóstico de tecnología. 
NO menciones: bases de datos, lenguajes, frameworks, protocolos específicos.
Reemplaza "PostgreSQL" con "base de datos relacional".
Reemplaza "REST API" con "interfaz programática".
```

### Problema: IA olvida secciones o requisitos

**Causa**: Prompt muy largo o poco estructurado

**Solución**: Usa listas explícitas:
```
Este documento DEBE incluir:
1. [sección]
2. [sección]
3. [sección]
```

### Problema: Documentos no conectan entre fases

**Causa**: No se comparten contexto entre prompts

**Solución**: Para cada fase, incluye:
```
# Contexto de fases anteriores
[Resume brevemente discovery, requirements, design]

# Cómo este documento conecta
[Explica qué RF/design decisions soporta]
```

### Problema: Documentación es muy larga o corta

**Causa**: Expectativa mal definida

**Solución**: Especifica exactamente:
```
Extensión: 2000-2500 palabras
Estilo: Ejecutivo (máximo 2 párrafos por sección)
Nivel: Visión general (no detalles de implementación)
```

---

## Ejemplo Completo: Generación de Discovery

### Input (lo que TÚ proporcionas a IA):

```markdown
# Tu Producto

**Nombre**: TaskFlow
**Problema**: Pequeños equipos gastan 5+ horas/día en sincronización de tareas

**Contexto**:
- Target: Equipos de 3-15 personas (startups, agencias)
- Competencia: Jira (demasiado complejo), Asana (demasiado caro)
- Oportunidad: Herramienta simple, barata, con IA

**Stack** (solo FYI, NO debe mencionarse en docs):
- Backend: Node.js + Express
- Frontend: React
- DB: PostgreSQL

---

# Tarea para IA

Genera el documento "discovery/context-motivation.md" para TaskFlow.

# Template
[PEGAR TEMPLATE-context-motivation.md]

# Especificaciones
- Extensión: 2000-2500 palabras
- Agnóstico: NO mencionar tecnologías específicas
- Secciones: Problema, Contexto de Mercado, Motivación Estratégica, Stakeholders, 
  Riesgos Iniciales, Oportunidades, Supuestos Clave
- Tone: Profesional, inspirador pero realista
- Incluir: 
  - Cuánto tiempo gastan los equipos (dato concreto)
  - Competidores mencionados (Jira, Asana) sin decir cómo implementan
  - Segmento de mercado específico
```

### Output (lo que IA genera):

```markdown
[Documento generado: discovery/context-motivation.md]

[Largo, estructurado, agnóstico, con secciones claras]
```

### Validación (lo que TÚ revisas):

```
✅ ¿Quedó claro el problema?
✅ ¿Se entiende el contexto de mercado?
✅ ¿Menciona Jira/Asana sin prescribir soluciones?
✅ ¿2000+ palabras?
✅ ¿Sin tecnologías mencionadas?

Si todo OK → Siguiente documento
Si NO → Pide ajustes específicos a IA
```

---

## Próximos Pasos

1. 📖 Lee [`TEMPLATE-USAGE-GUIDE.md`](./TEMPLATE-USAGE-GUIDE.md) para entender el proceso end-to-end
2. 📋 Usa los prompts anteriores para generar cada fase
3. ✅ Aplica el checklist de validación después de cada documento
4. 🔗 Asegúrate de cross-references entre fases

---

[← Índice](./README.md)
