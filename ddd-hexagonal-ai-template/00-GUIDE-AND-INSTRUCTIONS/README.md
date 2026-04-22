[← HOME](../README.md)

---

# Guías y Instrucciones

Centro de control para entender y usar la plantilla DDD + Hexagonal.

---

## 📚 Documentación

### Para empezar rápido

1. **[TEMPLATE-USAGE-GUIDE.md](./TEMPLATE-USAGE-GUIDE.md)** — Paso a paso completo
   - Preparación (15 min)
   - Adaptación (20 min)
   - Generación (2-3 días)
   - Validación
   - Mantener viva la documentación

2. **[INSTRUCTIONS-FOR-AI.md](./INSTRUCTIONS-FOR-AI.md)** — Referencia rápida: principios y estructura
   - Principios generales
   - Estructura de prompts
   - Prompts por fase (discovery, requirements, design, etc.)
   - Validación checklist
   - Troubleshooting

3. **[AI-WORKFLOW-GUIDE.md](./AI-WORKFLOW-GUIDE.md)** ⭐ **← COMIENZA AQUÍ si trabajas con IA**
   - Flujo general paso a paso
   - Preparación detallada (Día 1)
   - Discovery con ejemplos prácticos (Día 2-3)
   - Requirements con templates listos (Día 4-5)
   - Design con patrones DDD (Día 6-7)
   - Data Model, Planning, Development (Día 8-10+)
   - Validación integral
   - Troubleshooting avanzado

### Ejemplos y Referencia

4. **[EXAMPLE-IMPLEMENTATION.md](./EXAMPLE-IMPLEMENTATION.md)** — Ejemplo completo día a día
   - Caso real: documentación de Keygo
   - Qué hacer cada día (Día 1-10)
   - Prompts y validación específicos
   - Checklist de coherencia cross-fase

### Para entender la arquitectura

5. **[TEMPLATE-ARCHITECTURE.md](./TEMPLATE-ARCHITECTURE.md)** — Cómo está diseñada la plantilla
   - Filosofía (por qué 12 fases)
   - Principios (agnóstico, iterable, vivo)
   - Mapa mental
   - Cuándo adaptar/extender

### Ayuda

6. **[FAQ.md](./FAQ.md)** — Preguntas frecuentes
   - "¿Cuánto tiempo toma completar todo?"
   - "¿Puedo saltarme fases?"
   - "¿Cómo actualizo documentos cuando el código cambia?"
   - Y más...

---

## 🚀 Quick Start (30 minutos)

**Si trabajas con IA:**
1. Lee este README (5 min)
2. Abre [`AI-WORKFLOW-GUIDE.md`](./AI-WORKFLOW-GUIDE.md) y comienza con "Preparación (Día 1)"
3. Sigue el flujo día a día
4. Consulta [`INSTRUCTIONS-FOR-AI.md`](./INSTRUCTIONS-FOR-AI.md) para prompts específicos

**Si trabajas sin IA:**
1. Lee este README (5 min)
2. Abre [`TEMPLATE-USAGE-GUIDE.md`](./TEMPLATE-USAGE-GUIDE.md) y completa "Paso 1: Preparación"
3. Completa "Paso 2: Adaptación de estructura"
4. Documenta manualmente o usa herramientas propias

---

## 📁 Estructura de la Plantilla

```
00-PLANNING/
├── sdlc-framework.md
└── navigation-conventions.md

01-discovery/  ← Qué problema resolvemos
02-requirements/  ← Qué debe hacer el sistema
03-design/  ← Cómo fluye el sistema
04-data-model/  ← Cómo se almacenan datos
05-planning/  ← Cuándo y cómo entregamos
06-development/  ← Cómo lo construimos técnicamente
07-testing/  ← Cómo validamos
08-deployment/  ← Cómo vamos a producción
09-operations/  ← Cómo operamos
10-monitoring/  ← Cómo medimos
11-feedback/  ← Qué aprendemos
```

---

## 📖 Índice de Documentos (por orden de lectura)

| Orden | Documento | Duración | Para quién | Propósito |
|-------|-----------|----------|-----------|-----------|
| 1 | [`TEMPLATE-USAGE-GUIDE.md`](./TEMPLATE-USAGE-GUIDE.md) | 20 min | Todos | Entender proceso completo |
| 2 | [`AI-WORKFLOW-GUIDE.md`](./AI-WORKFLOW-GUIDE.md) ⭐ | 30 min | **Con IA** | Flujo práctico día a día, con ejemplos reales |
| 3 | [`EXAMPLE-IMPLEMENTATION.md`](./EXAMPLE-IMPLEMENTATION.md) | 20 min | **Con IA** | Caso real (Keygo) día a día, Día 1-10 |
| 4 | [`INSTRUCTIONS-FOR-AI.md`](./INSTRUCTIONS-FOR-AI.md) | 20 min | Referencias durante trabajo | Prompts específicos por fase, troubleshooting |
| 5 | [`TEMPLATE-ARCHITECTURE.md`](./TEMPLATE-ARCHITECTURE.md) | 15 min | Curiosos | Entender diseño interno |
| 6 | [`FAQ.md`](./FAQ.md) | 10 min | Dudosos | Resolver problemas comunes |

---

## 🎯 Caminos de Aprendizaje

### "Quiero generar documentación RÁPIDO con IA" ⭐

1. Abre [`AI-WORKFLOW-GUIDE.md`](./AI-WORKFLOW-GUIDE.md) — sección "Flujo General"
2. Prepara tu información del producto (20 min)
3. Sigue "Día 1: Preparación"
4. Luego Día 2-3: Discovery, Día 4-5: Requirements, etc.
5. Consulta [`INSTRUCTIONS-FOR-AI.md`](./INSTRUCTIONS-FOR-AI.md) si necesitas prompts específicos
6. **Resultado**: Documentación completa en 10-15 días

### "Quiero ver un ejemplo real paso a paso"

1. Lee [`EXAMPLE-IMPLEMENTATION.md`](./EXAMPLE-IMPLEMENTATION.md)
2. Caso: Generación de docs para Keygo (producto real)
3. Día 1: Prepara información
4. Día 2-3: Genera Discovery (3 documentos)
5. Sigue el patrón para los demás días
6. Adapta ejemplos a tu producto

### "Tengo documentación desorganizada y quiero centralizarla"

1. Lee esta carpeta para entender estructura
2. Mapea tu documentación existente a las 12 fases
3. Completa gaps con IA
4. Centraliza en esta estructura

### "Quiero entender si el enfoque DDD + Hexagonal es para mí"

1. Lee [`TEMPLATE-ARCHITECTURE.md`](./TEMPLATE-ARCHITECTURE.md)
2. Lee `../00-PLANNING/sdlc-framework.md`
3. Decide si adaptar o crear tu propia estructura

### "Tengo problemas generando documentación con IA"

1. Ve a [`INSTRUCTIONS-FOR-AI.md`](./INSTRUCTIONS-FOR-AI.md) → "Troubleshooting"
2. Lee el caso que se asemeja al tuyo
3. O consulta [`AI-WORKFLOW-GUIDE.md`](./AI-WORKFLOW-GUIDE.md) → "Troubleshooting Avanzado"
4. Ajusta tu prompt según la solución sugerida

---

## 🔑 Conceptos Clave

### 1. Agnóstico vs. Específico

- **Fases 1-5** (Discovery → Planning): **Agnóstico de tecnología**
  - Describe "qué", no "cómo"
  - Sin nombres de frameworks, lenguajes, BD
  - Enfoque en negocio y usuario

- **Fases 6-12** (Development → Feedback): **Específico a tu stack**
  - Aquí mencionas tu tecnología
  - Arquitectura real, APIs, código
  - Enfoque técnico

### 2. Iterativo, no Waterfall

Cada feature/dominio puede estar en fases distintas:

```
Fase de Auth:     Discovery ✅ → Requirements ✅ → Design → Development
Fase de Billing:  Discovery ✅ → Requirements → Design (próximas semanas)
Fase de Admin:    Backlog (no empezado)
```

### 3. Trazabilidad

Un requisito debe ser trazable desde Discovery hasta Monitoring:

```
RF-001 (usuario puede loguear)
  ↓ referenciado en
Discovery (necesidad de usuario)
  ↓ implementado en
Design (flujo de login)
  ↓ reflejado en
Data Model (usuario entity)
  ↓ codificado en
Development (LoginController + API)
  ↓ testeado en
Testing (unit + integration)
  ↓ medido en
Monitoring (login success rate)
```

---

## ⚠️ Errores Comunes

1. **Saltarse fases** ← Tentador pero causa incoherencia
   - Solución: Haz versiones rápidas (1 página) si tienes prisa, pero no saltes

2. **Mezclar agnóstico con específico en fases 1-5**
   - Solución: Usa [`INSTRUCTIONS-FOR-AI.md`](./INSTRUCTIONS-FOR-AI.md) como checklist

3. **No actualizar documentos cuando cambia el código**
   - Solución: Configura ownership + alertas (ver TEMPLATE-USAGE-GUIDE.md)

4. **Generar todo de una vez sin validar**
   - Solución: Genera fase por fase, valida, ajusta

5. **No proporcionar contexto suficiente a IA**
   - Solución: Ver ["Proporciona contexto, no pidas que lo invente"](./INSTRUCTIONS-FOR-AI.md#2-proporciona-contexto-no-pidas-que-lo-invente)

---

## 🤝 Contribución y Mejoras

Esta plantilla está diseñada para ser **agnóstica y reutilizable**. Si encuentras:

- ✅ Una mejora al formato
- ✅ Un template que no funciona bien
- ✅ Un caso de uso no cubierto
- ✅ Un error en las instrucciones

**Documentalo** y mejora la plantilla. Usa el template de issue en [`TEMPLATE-ARCHITECTURE.md`](./TEMPLATE-ARCHITECTURE.md#contribución).

---

## 📞 Ayuda

- **¿Cómo empiezo sin IA?** → Lee [`TEMPLATE-USAGE-GUIDE.md`](./TEMPLATE-USAGE-GUIDE.md)
- **¿Cómo trabajo CON IA?** → Lee [`AI-WORKFLOW-GUIDE.md`](./AI-WORKFLOW-GUIDE.md) ⭐
- **¿Necesito prompts específicos?** → Consulta [`INSTRUCTIONS-FOR-AI.md`](./INSTRUCTIONS-FOR-AI.md) por fase
- **¿Tengo una duda?** → Busca en [`FAQ.md`](./FAQ.md)
- **¿Quiero entender la arquitectura?** → Lee [`TEMPLATE-ARCHITECTURE.md`](./TEMPLATE-ARCHITECTURE.md)

---

[← HOME](../README.md)
