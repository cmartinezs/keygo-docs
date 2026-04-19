# 01-PRODUCT - Visión, Requisitos y Definiciones

**Única fuente de verdad** para especificaciones del producto KeyGo. Agnóstico de tecnología.

---

## 📚 Contenido

### [vision.md](vision.md) — Visión del Producto
Qué estamos construyendo en términos simples.
- **What**: Plataforma OAuth2/OIDC para gestión de identidad multi-tenant
- **For whom**: Desarrolladores, administradores, usuarios finales
- **Key principles**: Un login, roles diferenciados, seguridad en memoria, fuente única de verdad
- **Core features**: Acceso público, operación plataforma, gestión tenant, autoservicio

**Lee esto si**: Necesitas explicación de KeyGo en 5 minutos.

---

### [glossary.md](glossary.md) — Diccionario Unificado ⭐ **SINGLE SOURCE OF TRUTH**
100+ términos canonicalizados para alineación de vocabulario.
- **Cobertura**: Auth, Tenants, Billing, Account, Arquitectura, Roles
- **Formato**: Alfabético con contexto, tabla asociada (si aplica), ejemplos
- **Roles definidos**: ADMIN, ADMIN_TENANT, USER_TENANT con responsabilidades claras

**Lee esto si**: Necesitas aclaración sobre cualquier término usado en KeyGo.

---

### [requirements.md](requirements.md) — Requisitos Funcionales y No-Funcionales
Especificaciones detalladas de qué debe hacer KeyGo.
- **Requisitos funcionales**: RF-A (Auth), RF-B (Tenants), RF-C (Billing), RF-D (Account)
- **Requisitos no-funcionales**: RNF-SEC, RNF-PERF, RNF-OBS, RNF-DATA, RNF-I18N, RNF-COMPAT
- **Status**: ✅ Completado / 🟡 Parcial / 🔲 Pendiente
- **Cobertura**: 85% funcional, 70% no-funcional

**Lee esto si**: Necesitas saber qué debe hacer KeyGo (especificaciones).

---

### [constraints-limitations.md](constraints-limitations.md) — Restricciones y Pain Points
Limitaciones conocidas y problemas identificados.
- **Pain points**: Conocimiento disperso, desalineación roadmap-código, inconsistencias docs, falta diagramas
- **Dolores de producto**: Sin gateway real, sin multi-moneda, sin SCIM
- **Restricciones técnicas**: Stack fijo (Java+Spring+PostgreSQL), monolito, SPA frontend
- **Gaps funcionales**: Payment, rate limiting, SCIM, 2FA, SAML, audit trail

**Lee esto si**: Necesitas entender restricciones que afectan decisiones de diseño.

---

### [diagrams/](diagrams/) — Visuales de Flujos
Diagramas agnósticos (no específicos de tecnología).
- `use-cases.md` - Casos de uso
- `authentication-flow.md` - Flujo OAuth2/OIDC
- `billing-flow-contractor.md` - Modelo de billing contractor
- `account-flow.md` - Ciclo vida de cuenta
- `tenant-management-flow.md` - Ciclo vida de tenant

**Lee esto si**: Prefieres visuales que texto.

---

## 🎯 Por Qué Existe Esta Sección

✅ **Single Source of Truth**: Una sola definición de cada concepto  
✅ **Agnóstico**: Sin detalles de implementación (backend/frontend)  
✅ **Accesible**: Glosario para alineación rápida  
✅ **Actualizado**: Refleja estado actual de requirements y constraints  

---

## 🚀 Cómo Usar Esta Sección

### Nuevo en KeyGo?
1. Lee [vision.md](vision.md) (5 min)
2. Lee [glossary.md](glossary.md) - al menos roles y conceptos clave (10-15 min)
3. Explora [diagrams/](diagrams/) para entender flows (10 min)
4. Lee [requirements.md](requirements.md) para tu área de trabajo (20-30 min)

### Necesitas aclaración sobre un término?
→ Busca en [glossary.md](glossary.md)

### Quieres saber si algo está implementado?
→ Busca en [requirements.md](requirements.md) (status ✅/🟡/🔲)

### Necesitas entender restricciones técnicas?
→ Lee [constraints-limitations.md](constraints-limitations.md)

### Necesitas crear documentación específica de backend/frontend?
→ Referencia [vision.md](vision.md) + [glossary.md](glossary.md) + [requirements.md](requirements.md)  
→ Luego agrega detalles de implementación en secciones específicas (02-functional, 03-architecture, etc.)

---

## 📖 Navega a

- **[← README raíz](../README.md)** - Índice general del repo
- **[→ Functional](../02-functional/)** - Guías de features por dominio
- **[→ Architecture](../03-architecture/)** - Patrones y decisiones técnicas
- **[→ Decisions](../04-decisions/)** - RFCs y ADRs

---

## 📌 Notas Importantes

### Estatus de Documentación
- ✅ vision.md: Actualizado 2026-04-19
- ✅ glossary.md: Actualizado 2026-04-19 (expandido con roles)
- ✅ requirements.md: Actualizado 2026-04-19 (consolidado)
- ✅ constraints-limitations.md: Actualizado 2026-04-19
- ✅ diagrams/: En place (desde backend)

### Próximas Actualizaciones
- [ ] Expandir requisitos para Tenants, Billing, Account (actualmente solo Auth detallado)
- [ ] Agregar más diagramas (state machines, sequences)
- [ ] Crear matriz de cobertura con roadmap

---

**Última actualización**: 2026-04-19  
**Responsable**: Documentación unificada  
**Validez**: Actual vs. código (verificar si requisitos divergen)
