# Constraints & Limitations — KeyGo

> **Propósito**: Documentar restricciones técnicas, pain points identificados y limitaciones conocidas. Referencia para decisiones de diseño y priorización de trabajo.

**Última actualización:** 2026-04-19

---

## 1. Dolores de Desarrollo

### **Dolor 1: Conocimiento Disperso 🧠**

**Síntoma**: Documentación en 40+ archivos sin hilo conductor. Propuestas (ROADMAP, propuestas.md) sin explicar el *por qué*. Nuevo dev tarda 2 semanas entendiendo estructura.

**Causa Raíz**:
- Proyecto evolucionó orgánicamente sin referencia única centralizada
- Decisiones de diseño (bounded contexts, entidades, flujos) no documentadas
- Análisis de dolores/restricciones implícito en código y commits

**Impacto**:
- ⏱️ Onboarding lento (~10-15 horas para contexto básico)
- 🐛 Errores por falta de contexto (refs rotas, patrones no seguidos)
- 📉 Velocidad de desarrollo reduce por re-aprendizaje

**Solución**: Esta documentación centralizada en `01-product/` + `03-architecture/` unifica todo.

---

### **Dolor 2: Desalineación Roadmap-Código 🗺️**

**Síntoma**: 152 propuestas (T-NNN/F-NNN) pero equipo implementa por urgencia, no por priorización. Features parcialmente implementadas; propuestas completadas sin actualizar roadmap.

**Causa Raíz**:
- Roadmap es "wish list" sin dependencias explícitas (¿qué bloquea qué?)
- Sin dueño visible por contexto (¿quién es responsable de Auth?, ¿de Billing?)
- Propuestas de largo plazo (T-059, T-064, T-020) no descompuestas en pasos

**Impacto**:
- 🔀 Trabajo ad-hoc, no estratégico
- 🚧 Propuestas mediano/largo plazo congeladas (3+ meses sin progreso)
- 💔 Frustración: "no progresamos hacia arquitectura objetivo"

**Solución**: `04-decisions/decisions-log.md` mapea rutas críticas y bloqueadores.

---

### **Dolor 3: Inconsistencias Docs ↔ Código 🔴**

**Síntoma**: Documentación describe `X-KEYGO-ADMIN` cuando la realidad es `Authorization: Bearer` desde 2026-03-25. `BOOTSTRAP_FILTER.md` con rutas públicas incompletas. Docs dice JPA **Specifications** pero adaptadores antiguos en caché.

**Causa Raíz**:
- Documentación no actualizada post-refactor
- Sin proceso de validación docs-vs-código pre-commit
- Sin script CI que verifique consistencia (lychee/markdown-link-check no configurados)

**Impacto**:
- 😕 Confusión al leer docs obsoleta
- 🐛 Copy-paste de ejemplos que no funcionan
- 💢 Pérdida de confianza en documentación

**Solución**: Documentación unificada como fuente de verdad única. Pre-commit hook (futuro).

---

### **Dolor 4: Falta de Diagramas Visuales 📊**

**Síntoma**: Casos de uso descritos en texto (prosa). Flujos OAuth2 sin diagrama. Máquinas de estado (usuario ACTIVE → RESET_PASSWORD → ACTIVE) solo en código JPA.

**Causa Raíz**:
- Sin herramienta preferida de diagramas definida
- PlantUML / Mermaid no configurados en CI
- Texto es "más fácil" que mantener SVG

**Impacto**:
- 🧩 Difícil entender flujos complejos (password reset: 4 pasos)
- 🔀 Ambigüedad en handoff entre contextos (¿cuándo pasa estado del usuario?)
- 📚 Onboarding requiere reading code para entender sequences

**Solución**: `diagrams/` con Mermaid (cases, flows, sequences, state machines).

---

## 2. Dolores de Producto

### **Dolor 5: Billing sin Gateway Real 💳**

**Síntoma**: Endpoint `/mock-approve-payment` hardcoded. No integración Stripe/MercadoPago. Imposible vender KeyGo hoy; solo demo.

**Causa Raíz**:
- Funcionalidad MVP entregable en tiempo (T-086 Q2 2026)
- Gateway requiere PCI compliance, contratos, testing de integración
- Modelo económico no validado aún

**Impacto**:
- 🚫 No monetización posible
- ⏱️ Bloquea propuestas downstream (renovación automática T-085, dunning T-090, CFDI T-088)

**Solución**: T-084 (mediano plazo), descompuesto en T-084 (gateway), T-085 (renewal), T-086 (soporte TENANT_USER bearer).

---

### **Dolor 6: Sin Multi-Moneda / Precios Dinámicos 💱**

**Síntoma**: Todos los precios en una moneda base. No hay soporte para MXN/EUR/JPY. Clientes globales quedan fuera.

**Causa Raíz**:
- MVP usa moneda única (decisión: Largo plazo)
- Tipos de cambio requieren tabla, API externa, o fijación manual
- Modelos de pricing (tiers, dinámicos) requieren arquitectura nueva

**Impacto**:
- 🌍 Mercado limitado (solo USD)
- 💰 Margen reducido (conversiones externas, comisiones)

**Solución**: T-089 (multi-moneda), T-100 (pricing tiers), T-102 (precios dinámicos) — Largo plazo.

---

### **Dolor 7: Sin Integración SCIM / Aprovisionamiento 👥**

**Síntoma**: Admin de tenant crea usuarios manualmente vía API. HR/Okta/OneLogin no pueden auto-provisionar empleados.

**Causa Raíz**:
- SCIM 2.0 es estándar pero no MVP
- Requiere mapeo de atributos personalizados (T-048)
- Roadmap = Q3 2026

**Impacto**:
- 🔄 Setup manual tedioso para tenants grandes
- 📋 No integración con sistemas HR existentes

**Solución**: T-047 (SCIM 2.0) + T-048 (custom attributes) — Largo plazo Q3.

---

## 3. Restricciones Técnicas

### **Restricción T1: Stack Fijo (Java 21 + Spring Boot 4.x + PostgreSQL)**

**Descripción**: Arquitectura base no es negociable. No migramos a Go, Node, Rust.

**Impacto**:
- Decisiones deben alinearse con Spring ecosystem
- ORM es JPA (no Hibernate custom)
- Observabilidad usa Micrometer (no Jaeger custom)

---

### **Restricción T2: Monolito Backend**

**Descripción**: Única instancia de backend. No microservicios (por ahora).

**Impacto**:
- Escalabilidad limitada a vertical (más CPU/memoria)
- Deployment es "all-or-nothing" (no canary deploys por servicio)
- Cambios grandes requieren coordinación mayor

---

### **Restricción T3: Frontend SPA Pura**

**Descripción**: No server-side rendering. Aplicación JavaScript / TypeScript en navegador.

**Impacto**:
- Tokens viven en memoria (no en cookies httpOnly)
- SEO limitado (landing página es estática)
- Offline capability limitada

---

## 4. Limitaciones Funcionales

### **Limitación F1: Sin Autenticación Multi-Factor (2FA)**

**Estado**: No implementado.

**Por qué**: Bajo ROI en MVP; usuarios tech-savvy esperan TOTP, no SMS.

**Roadmap**: Q3 2026 (T-093)

---

### **Limitación F2: Sin SAML 2.0**

**Estado**: Solo OAuth2/OIDC.

**Por qué**: Empresas grandes requieren SAML; requiere biblioteca compleja (Keycloak?).

**Roadmap**: Q4 2026 (T-101)

---

### **Limitación F3: Sin Webhook para Eventos**

**Estado**: No existen webhooks (account.user.created, subscription.renewed, etc.).

**Por qué**: Integración SaaS requiere webhooks; implementación futura.

**Roadmap**: Q2 2026 (T-080)

---

### **Limitación F4: Sin Audit Trail Persistente**

**Estado**: Logs en ELK; no hay tabla audit_events queryable.

**Por qué**: Compliance requiere audit trail inmutable.

**Roadmap**: Q3 2026 (T-076)

---

## 5. Limitaciones de Performance

### **Limitación P1: Dashboard ~2000ms de latencia**

**Causa**: ~25 queries a BD sin caché.

**Solución**: T-074 (caché dashboard TTL 60s) → ~500ms estimado.

---

### **Limitación P2: Sin caché en catálogo de planes**

**Causa**: Cada `GET /billing/catalog` golpea BD.

**Solución**: T-099 (caché) → CDN edge caching.

---

## 6. Limitaciones de Observabilidad

### **Limitación O1: Sin métricas Prometheus**

**Estado**: Health check ✅; métricas ❌.

**Roadmap**: Q2 2026 (T-073)

---

### **Limitación O2: Logging no es JSON**

**Estado**: Plaintext logs.

**Roadmap**: Q2 2026 (refactor logging)

---

### **Limitación O3: Sin distributed tracing**

**Estado**: Request ID sí; tracing distribuido no.

**Roadmap**: Futuro (T-XXX)

---

## 7. Impacto en Decisiones de Diseño

### **Decisión 1: Bearer Token en Memoria**

**Constraint**: "Tokens viven en memoria; la UI no persiste secretos en storage"

**Impacto**: 
- ✅ Seguro contra XSS
- ❌ Logout en refresh de página
- ❌ Offline capability limitada

---

### **Decisión 2: Monolito en lugar de Microservicios**

**Constraint**: "Stack fijo, monolito por ahora"

**Impacto**:
- ✅ Simplicidad inicial
- ❌ Escalabilidad limitada (no separar Auth de Billing)
- ❌ Deployment acoplado

---

### **Decisión 3: OAuth2/OIDC Solo (Sin SAML)**

**Constraint**: "MVP usa OAuth2 solamente"

**Impacto**:
- ✅ Moderno, estándar web
- ❌ Empresas legacy requieren SAML
- ❌ Mercado limitado

---

## 📋 Resumen Ejecutivo

| Categoría | Count | Impacto | Horizonte |
|-----------|-------|--------|-----------|
| **Dolores de Desarrollo** | 4 | Alto | Corto (documentación) |
| **Dolores de Producto** | 3 | Alto | Mediano/Largo (features) |
| **Restricciones Técnicas** | 3 | Medio | Fijo (no cambiar) |
| **Limitaciones Funcionales** | 4 | Medio | Mediano/Largo |
| **Limitaciones de Performance** | 2 | Bajo | Corto |
| **Limitaciones de Observabilidad** | 3 | Bajo/Medio | Mediano |

---

**Última actualización**: 2026-04-19  
**Dueño**: Product + Engineering  
**Revisión**: Trimestral
