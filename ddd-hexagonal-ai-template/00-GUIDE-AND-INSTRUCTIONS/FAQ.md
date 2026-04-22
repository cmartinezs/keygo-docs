[← Índice](./README.md)

---

# Preguntas Frecuentes

Respuestas a las dudas más comunes sobre la plantilla.

---

## Contenido

- [Tiempo y duración](#tiempo-y-duración)
- [Alcance y fases](#alcance-y-fases)
- [Agnóstico vs. específico](#agnóstico-vs-específico)
- [Colaboración con IA](#colaboración-con-ia)
- [Mantenimiento](#mantenimiento)
- [Adaptación](#adaptación)

---

## Tiempo y Duración

### ¿Cuánto tiempo toma completar toda la documentación?

**Respuesta**: 30-40 horas distribuidas en 5-7 días de trabajo (no consecutivos).

**Desglose**:
- Preparación + adaptación: 30 min
- Discovery: 2-3 h
- Requirements: 3-4 h
- Design: 3-4 h
- Data Model: 2 h
- Planning: 2 h
- Development: 4-5 h
- Testing, Deployment, Operations, Monitoring, Feedback: ~15 h
- Validación cross-phase: 1-2 días

**Consejo**: No intentes hacerlo todo en 1 día. Es mejor 1 fase/día para que puedas revisar y ajustar.

### ¿Puedo hacerlo más rápido?

**Respuesta**: Sí, pero con trade-offs:

- **Versión express** (1 día): Solo Discovery + Requirements + Design → buen MVP
- **Versión completa** (5-7 días): Todas las 12 fases
- **Versión extendida** (2+ semanas): Incluye ejemplos de código, diagramas UML detallados, etc.

**Recomendación**: Haz versión express primero, luego itera.

---

## Alcance y Fases

### ¿Necesito completar las 12 fases?

**Respuesta**: Depende de tu situación.

| Situación | Fases Necesarias | Opcional |
|-----------|------------------|----------|
| Startup MVP (primeras 4 semanas) | 1-6 (Discovery → Development) | 7-12 |
| Producto maduro que itera | Todas | Depende |
| Mantenimiento de producto vivo | 10, 11, 12 (Operations, Monitoring, Feedback) | 1-9 (si no cambian) |
| Refactorización importante | 6, 7, 8 (Development, Testing, Deployment) | 1-5 (si problema sigue igual) |

**Regla de oro**: Siempre incluye:
- ✅ Discovery (¿por qué?)
- ✅ Requirements (¿qué?)
- ✅ Testing (¿validamos?)

### ¿Puedo saltarme la fase X?

**Respuesta**: Técnicamente sí, pero hay riesgos.

| Si saltas... | Riesgo | Alternativa |
|---|---|---|
| Discovery | Construyes la solución equivocada | Haz versión ultra-rápida (30 min) |
| Requirements | RF confusos, dev bloquea | Haz versión ejecutiva por epic |
| Design | Sin modelo de dominio, arquitectura desorganizada | Usa DDD estratégico ligero |
| Data Model | BD sin relaciones claras, refactors futuros | Esboza ERD rápido en 30 min |
| Testing | Bugs en prod, cambios rompen | Planifica tests al menos |
| Operations | Downtime, confusion en incidentes | Runbook simple 1 página |

**Consejo**: Si tienes prisa, reduce no saltes. Haz versiones ejecutivas.

### ¿Qué pasa si cambio de dominio a mitad de camino?

**Respuesta**: Vuelve a Discovery.

Ejemplo:
```
Empezaste con: Sistema de Blog
Ahora necesitas: Sistema de Blog + E-Commerce

Acción: 
1. Haz Discovery NEW para E-Commerce context
2. Agrega nuevos Bounded Contexts en Design
3. Fusiona Data Models
4. Continúa con Development para nuevos endpoints
```

No es waterfall. Es iterativo por dominio.

---

## Agnóstico vs. Específico

### ¿Cómo sé si un documento es agnóstico?

**Pregunta clave**: ¿Lo entendería alguien sin conocer mi stack?

**Ejemplos agnósticos** (✅):
- "El sistema debe soportar múltiples idiomas"
- "Debe haber trazabilidad de acciones de usuario"
- "La API debe responder en <500ms"

**Ejemplos específicos** (❌):
- "Usaremos PostgreSQL con particiones por tenant"
- "REST API con Spring Boot @RestController"
- "React con Redux para state management"

**Regla**: Fases 1-5 agnóstico, fases 6-12 específico.

### ¿Por qué importa ser agnóstico en fases tempranas?

**Razón 1**: Cambio de stack sin reescribir documentación.

Ejemplo:
```
Escenario A (agnóstico):
"RF: Usuario puede autenticarse"
  → Implementación Java + Spring → Años después → Migración a Node.js
  → Misma RF sigue siendo válida ✅

Escenario B (específico):
"Usar Spring Security con @PreAuthorize"
  → Migración a Node.js
  → Toda la documentación está obsoleta ❌
```

**Razón 2**: No-técnicos pueden contribuir.

```
PM entiende: "El usuario puede filtrar órdenes por estatus"
PM NO entiende: "Implementar índices en (user_id, order_status)"
```

**Razón 3**: Debate libre sin ancla tecnológica.

```
"¿Cuántas autorizaciones soportamos?" ← Debate de negocios
vs.
"¿JWT o Session?" ← Debate técnico (viene después)
```

---

## Colaboración con IA

### ¿Por qué necesito instrucciones especiales para IA?

**Respuesta**: IA funciona mejor con:

1. **Estructura clara** — sabe exactamente qué producir
2. **Contexto suficiente** — no inventa, genera basándose en hechos
3. **Validación explícita** — validas, no asume que estuvo bien
4. **Lenguaje precisado** — "agnóstico" para IA significa no mencionar frameworks

**Resultado**: Documentación 80% lista en primera iteración. Requiere 1-2 rondas de ajustes.

### ¿Qué información debo proporcionar a IA?

**Mínimo**:
- Nombre + problema en 1 oración
- Target users
- Contextos de dominio esperados (3-5)
- Restricciones clave (compliance, escala, etc.)

**Ideal**:
- + Documentación existente
- + Competidores
- + Visión a largo plazo
- + Stack técnico (para fases 6+)

Ej. prompt mínimo:

```
Producto: TaskFlow
Problema: Equipos pequeños gastan 5h/día en sincronización de tareas
Usuarios: Startups 5-15 personas
Contextos: Auth, Projects, Tasks, Notifications, Billing
Restricción: <500ms response, GDPR

Genera Discovery/context-motivation.md
```

### ¿IA puede generar las 12 fases de una vez?

**Respuesta**: No recomendado.

**Por qué**: 
- Una fase depende de output de anterior
- Errores se amplifican (garbage in → garbage out)
- Es difícil validar 40 páginas de una vez

**Mejor**:
```
Día 1: Discovery (2-3h con IA)
Validar con equipo (30 min)
  ↓
Día 2: Requirements (3-4h con IA)
Validar con PM (30 min)
  ↓
Día 3: Design (3-4h con IA)
Validar con tech lead (1h)
  ↓
...
```

### ¿Qué tan buena es la calidad de IA-generated docs?

**Respuesta**: 70-80% usable, 20-30% requiere ajustes.

**Típicamente bien**:
- Estructura y secciones ✅
- Ejemplos básicos ✅
- Descripciones narrativas ✅

**Típicamente requiere ajuste**:
- Complejidad del dominio (IA entiende pero generaliza)
- Detalles específicos (requiere tu conocimiento)
- Decisiones de trade-offs (IA no decide, documenta alternativas)

**Consejo**: Trata IA como "primer borrador" no "documento final".

---

## Mantenimiento

### ¿Con qué frecuencia actualizo la documentación?

**Respuesta**: Depende de qué cambió.

| Cambio | Cuándo actualizar | Fase afectada |
|--------|------------------|---------------|
| Código se refactoriza | Inmediatamente | Development |
| Se descubre un nuevo requisito | Antes de coding | Requirements |
| Se cambia roadmap | Próxima planning | Planning |
| Incidente en prod | Después, en postmortem | Operations, Feedback |
| Número de usuarios crece 2x | Quarterly review | Monitoring |

**Política simple**:
- 🟢 **Greenfield** (nuevo producto): Documenta mientras codificas
- 🟡 **Brownfield** (iteración): Actualiza docs con PRs importantes
- 🔴 **Refactor/Rewrite**: Pausa, documenta cambios, continúa

### ¿Cómo evito que los documentos se desactualicen?

**Respuesta**: Ownership + triggers.

**Ownership**:
```markdown
---
**Owner**: [nombre]
**Last Updated**: 2026-04-22
**Next Review**: 2026-07-22
---
```

**Triggers** (cuándo actualizar):
```markdown
**Update Triggers**:
- [ ] Si cambia [RF-001], revisar sección "Autenticación"
- [ ] Si se agregan nuevos Bounded Contexts, actualizar "Context Map"
- [ ] Si cambia versioning strategy, actualizar "Roadmap"
```

**Revisión trimestral**: Cada equipo revisa sus docs. 30 min meeting.

### ¿Qué pasa si olvido actualizar y doc está obsoleta?

**Respuesta**: Convierte en "Legacy" (deprecada).

```markdown
⚠️ **DEPRECATED** — Este documento es histórico (2026-03)
Consulta [nuevo documento](./nuevo.md) para información actual.

[Información histórica abajo...]
```

**No borres**, mantén para referencia histórica.

---

## Adaptación

### ¿Puedo cambiar los nombres de las carpetas?

**Respuesta**: Sí, pero mantén consistencia.

**No recomendado**: `01-discovery/`, `req/`, `03-design/` (inconsistente)

**Recomendado opciones**:
```
Opción A (números + nombres): 
  01-discovery, 02-requirements, 03-design, ...

Opción B (solo nombres, ordenados):
  discovery, requirements, design, data-model, planning, ...

Opción C (números + acrónimos):
  01-disc, 02-req, 03-des, 04-data, ...
```

**Consejo**: Usa la convención de Keygo (números + nombres). Es clara.

### ¿Puedo eliminar secciones de un documento?

**Respuesta**: Sí, si no necesitas esa información.

Ejemplos de reducción:

**Original RF**:
```
1. Descripción
2. Justificación
3. Criterios de Aceptación
4. Dependencias
5. Riesgos
6. Notas de Implementación
```

**Reducido** (MVP):
```
1. Descripción
2. Criterios de Aceptación
```

**Consejo**: Empieza con versión completa. Reduce si es demasiado verbosa.

### ¿Puedo agregar nuevas secciones?

**Respuesta**: Sí, especialmente para dominios complejos.

Ejemplo (agregar a Bounded Context):
```markdown
## Agregados

[lista de agregados]

## Invariantes Críticas

[lista de reglas que SIEMPRE deben cumplirse]

## Patrones Especiales

[patrones únicos del contexto]
```

**Consejo**: Agrega solo si agrega valor. Evita sobrecarga de info.

### ¿Cómo integro documentación existente en Notion/Confluence?

**Respuesta**: Exporta a Markdown, mapea a fases, ajusta.

**Pasos**:
1. Exporta documentos existentes (Notion → Markdown, Confluence → HTML → Markdown)
2. Identifica a qué fase pertenece cada uno
3. Coloca en la carpeta correspondiente
4. Actualiza secciones faltantes
5. Agrega navegación (links anterior/siguiente)

Ejemplo:
```
Notion "Product Spec" 
  → Análisis: Contiene RF + RNF + Diseño
  → Separar en: 02-requirements + 03-design
  → Crear nuevas secciones: 01-discovery (falta)
  → Agregar navegación
```

---

## Troubleshooting Común

### "IA generó todo idéntico, texto genérico"

**Causa**: Contexto insuficiente

**Solución**:
```
Agrega a tu próximo prompt:
- Ejemplo específico del flujo (no abstracto)
- Restricciones reales (GDPR, PCI, etc.)
- Escala esperada (10k users? 1M?)
- Un competitor para comparar
```

### "No sé cuándo termina una fase y comienza otra"

**Causa**: Ambigüedad en límites

**Solución**: Usa pregunta central de cada fase:

```
Discovery: ¿QUÉ PROBLEMA resolvemos?
Requirements: ¿QUÉ DEBE HACER?
Design: ¿CÓMO FLUYE?
Development: ¿CÓMO LO CODIFICAMOS?
```

Si tu documento responde varias preguntas → Divídelo

### "Mi documentación es muy larga / muy corta"

**Causa**: Expectativa de granularidad mal definida

**Solución**:
```
Muy larga: Reduce secciones, convierte en bullet points
Muy corta: Agrega ejemplos, casos de uso, pros/contras
```

Usa esta heurística:
- 500-800 palabras: Resumen ejecutivo
- 1000-1500 palabras: Visión general
- 2000-3000 palabras: Detalle completo
- 3000+ palabras: Probablemente debería ser 2 documentos

---

## Contacto y Mejoras

### ¿Dónde reporto un bug en la plantilla?

**GitHub Issues**: [Crear issue](../../issues)

**Plantilla**:
```
**Título**: [Bug/Feature/Question] [Componente]

**Ubicación**: Qué archivo afectado

**Problema**: Descripción clara de 2-3 oraciones

**Impacto**: Quién se ve afectado

**Solución propuesta**: Qué cambiar
```

### ¿Puedo mejorar un template?

**Sí, mediante Pull Request**.

**Pasos**:
1. Fork repo
2. Crea rama: `improve/template-name`
3. Haz cambios
4. Describe cambios en PR
5. Espera revisión

---

[← Índice](./README.md)
