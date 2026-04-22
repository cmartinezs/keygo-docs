# SDLC Framework — KeyGo Docs

## Propósito

Este documento define el ciclo de vida de producto que usamos como eje organizador de toda la documentación de Keygo. No es un proceso waterfall — es un mapa de referencia que describe qué producir en cada etapa, iterable por feature, dominio o versión.

---

## El Ciclo

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   Discovery ──► Requirements ──► Design & Process               │
│       ▲                               │                         │
│       │                               ▼                         │
│   Feedback              UI Design + Data Model                  │
│       ▲                               │                         │
│       │                               ▼                         │
│   Monitoring ◄── Operating ◄── Deployment ◄── Testing ◄── Planning ◄── Development
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Fases

### 1. Discovery
**Pregunta central**: ¿Qué problema estamos resolviendo y para quién?

**Qué produce**:
- Problem statement — el problema real, no la solución
- User personas — quiénes son los usuarios, qué necesitan, cómo piensan
- Competitive analysis — qué alternativas existen, cómo nos diferenciamos
- Glossary — vocabulario unificado del dominio

**Cuándo iterar**: Al explorar una nueva feature o dominio que no está documentado. Al detectar que el equipo usa términos distintos para lo mismo.

---

### 2. Requirements
**Pregunta central**: ¿Qué debe hacer el sistema?

**Qué produce**:
- Functional requirements (RF) — capacidades del sistema desde la perspectiva del usuario
- Non-functional requirements (RNF) — atributos de calidad (seguridad, performance, escalabilidad)
- Scope boundaries — qué queda fuera explícitamente
- Traceability matrix — estado de implementación de cada requisito

**Reglas**:
- Agnósticos de tecnología y de implementación
- Responden a "qué", nunca a "cómo"
- No asumen que nada existe aún

---

### 3. Design & Process
**Pregunta central**: ¿Cómo fluye el sistema a nivel de procesos y decisiones?

**Qué produce**:
- System flows — diagramas de los flujos principales (registro, login, billing, etc.)
- Process decisions — decisiones de diseño de procesos y las alternativas descartadas
- Domain model conceptual — entidades del negocio y sus relaciones (sin SQL)

---

### 4. UI Design
**Pregunta central**: ¿Cómo interactúa el usuario con el sistema?

**Qué produce**:
- Design system — tokens, tipografía, colores, componentes base
- Wireframes — pantallas principales y flujos de navegación
- UX decisions — por qué se eligió esta UX sobre otras alternativas

---

### 5. Data Model
**Pregunta central**: ¿Cómo se estructura y fluye la información?

**Qué produce**:
- Entities — entidades del dominio, atributos, invariantes
- Relationships — ERD (diagrama entidad-relación)
- Data flows — cómo se transforma y mueve la información

---

### 6. Planning
**Pregunta central**: ¿Cuándo y cómo entregamos?

**Qué produce**:
- Roadmap — visión a corto/mediano plazo
- Epics — agrupación de trabajo por iniciativa de negocio
- Versioning — estrategia de versiones y compatibilidad

---

### 7. Development
**Pregunta central**: ¿Cómo construimos esto técnicamente?

**Qué produce**:
- Architecture — arquitectura del sistema (agnóstica, backend, frontend)
- API reference — contratos de API
- Coding standards — convenciones de código
- ADRs — Architecture Decision Records (decisiones técnicas y alternativas)

---

### 8. Testing
**Pregunta central**: ¿Cómo validamos que el sistema funciona correctamente?

**Qué produce**:
- Test strategy — pirámide de testing, niveles de cobertura, criterios
- Test plans — planes de prueba por feature o módulo
- Security testing — estrategia de pruebas de seguridad

---

### 9. Deployment
**Pregunta central**: ¿Cómo llevamos el sistema a producción?

**Qué produce**:
- Environments — dev, staging, producción y sus diferencias
- CI/CD — pipelines, gates, automatización
- Release process — pasos para un release seguro

---

### 10. Operations
**Pregunta central**: ¿Cómo operamos el sistema en producción?

**Qué produce**:
- Runbooks — procedimientos paso a paso para operaciones comunes
- Incident response — protocolo de incidentes (detección → resolución → post-mortem)
- SLA — acuerdos de nivel de servicio

---

### 11. Monitoring
**Pregunta central**: ¿Cómo sabemos que el sistema está sano?

**Qué produce**:
- Metrics — métricas de sistema y de negocio que seguimos
- Alerts — reglas de alerta, severidad, escalamiento
- Dashboards — qué monitorear, cómo interpretarlo

---

### 12. Feedback
**Pregunta central**: ¿Qué aprendemos para mejorar el siguiente ciclo?

**Qué produce**:
- Retrospectives — aprendizajes por ciclo o versión
- User feedback — feedback de usuarios y cómo lo incorporamos
- Process improvements — backlog de mejoras al proceso de desarrollo

---

## Principios del Framework

1. **Iterativo, no waterfall**: Cada feature puede estar en fases distintas simultáneamente
2. **Agnóstico de tecnología en las primeras fases**: Discovery y Requirements no mencionan lenguajes ni frameworks
3. **Un ciclo por dominio**: Autenticación, billing, organizaciones — cada dominio tiene su propio ciclo
4. **Vivo, no congelado**: Los documentos se actualizan cuando cambia la realidad
5. **Trazable**: Los requisitos conectan con design, que conecta con código, que conecta con tests

---

## Mapping Fase → Carpeta

| Fase | Carpeta |
|------|---------|
| Discovery | `01-discovery/` |
| Requirements | `02-requirements/` |
| Design & Process + UI Design | `03-design/` |
| Data Model | `04-data-model/` |
| Planning | `05-planning/` |
| Development | `06-development/` |
| Testing | `07-testing/` |
| Deployment | `08-deployment/` |
| Operations | `09-operations/` |
| Monitoring | `10-monitoring/` |
| Feedback | `11-feedback/` |
| Framework + Metadocs | `00-documental-planning/` |
