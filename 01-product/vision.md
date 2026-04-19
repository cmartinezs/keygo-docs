# Product Vision — KeyGo

**Última actualización:** 2026-04-19

---

## What

KeyGo es una plataforma de autenticación, autorización y gestión de acceso para organizaciones multi-tenant. Proporciona OAuth2/OIDC como servicio, permitiendo a empresas delegar la identidad de usuarios en una solución centralizada.

## For Whom

- **Desarrolladores**: Que necesitan OAuth2/OIDC en aplicaciones multi-tenant sin construirlo desde cero
- **Administradores**: Que gestionan identidad de usuarios en múltiples organizaciones
- **Usuarios Finales**: Que necesitan login seguro, autoservicio de cuenta y gestión de sesiones

## Key Principles

1. **Un punto de login único**
   - OAuth2/PKCE como estándar de autenticación
   - Eliminamos la necesidad de passwords directos en aplicaciones cliente
   - Cumplimiento con OpenID Connect (OIDC)

2. **Experiencia diferenciada por rol**
   - Dashboard varía según rol: ADMIN (operación global), ADMIN_TENANT (gestión tenant), USER_TENANT (autoservicio)
   - Navegación y permisos contextuales al rol

3. **Seguridad en memoria**
   - Tokens viven en memoria; la UI no persiste secretos en storage
   - Protección contra XSS y CSRF mediante patrones seguros

4. **Fuente de verdad única**
   - Documentación, código, diagramas consistentes
   - Glossario unificado de términos
   - Requisitos claros y actualizados

## Core Features

### Acceso Público
- Landing, login, registro
- Recuperación de acceso (forgot password)
- Contratación de planes (B2C)

### Operación de Plataforma
- Dashboard global (ADMIN solo)
- Gestión de tenants (crear, suspender, ver estadísticas)
- Usuarios de plataforma
- Estado del servicio

### Gestión Tenant
- Aplicaciones cliente (OAuth2 apps)
- Usuarios del tenant
- Memberships (asignación usuario → app + roles)
- Sesiones (tracking, revocación)
- Billing del tenant (facturación, planes)

### Autoservicio
- Perfil de usuario
- Configuración y preferencias
- Gestión de sesiones activas
- Cambio de password

---

## Success Criteria

- ✅ OAuth2/OIDC implementado y certificado
- ✅ Multi-tenant con aislamiento completo de datos
- ✅ Onboarding de developer < 2 horas
- ✅ 99.9% uptime en producción
- ✅ Performance: token generation < 100ms

---

**Próximas secciones**: Ver [glossary.md](glossary.md) para términos, [requirements.md](requirements.md) para especificaciones detalladas.
