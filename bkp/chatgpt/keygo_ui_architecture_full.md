# Propuesta de arquitectura frontend para KeyGo UI

## Objetivo

Pasar desde un frontend "con pantallas y flujos funcionando" a un
frontend:

-   organizado por **dominio/feature**
-   con separación clara entre:
    -   presentación
    -   lógica de UI
    -   acceso a API
    -   modelos/contratos
-   fácil de mantener
-   fácil de escalar
-   fácil de alinear con backend y DDD

------------------------------------------------------------------------

# 1. Principio rector

La UI no debe organizarse por "tipo técnico" únicamente, sino
principalmente por **feature de negocio**.

En vez de esto:

src/ components/ pages/ hooks/ services/ forms/

moverse hacia esto:

src/ app/ shared/ features/ modules/

Donde:

-   app → bootstrap, router, providers globales
-   shared → piezas reutilizables cross-feature
-   features → capacidades acotadas de negocio
-   modules → agrupadores de alto nivel

------------------------------------------------------------------------

# 2. Mapa de dominio de KeyGo llevado al frontend

## Dominios principales

-   auth
-   tenant
-   users
-   applications
-   memberships
-   roles-permissions
-   plans-billing
-   audit
-   platform-admin

------------------------------------------------------------------------

# 3. Estructura recomendada

src/ app/ shared/ modules/

------------------------------------------------------------------------

# 4. Estructura interna de una feature

features/users/ api/ components/ hooks/ model/ pages/ state/ utils/

------------------------------------------------------------------------

# 5. Qué va en cada capa

pages: composición\
components: UI\
hooks: lógica\
api: llamadas\
model: tipos\
state: UI state

------------------------------------------------------------------------

# 6. Separación de modelos

UserDto\
UserListItem\
UserFormValues

------------------------------------------------------------------------

# 7. Rutas

/auth/login\
/console/users\
/platform/tenants

------------------------------------------------------------------------

# 8. Guards

AuthGuard\
TenantGuard\
PermissionGuard

------------------------------------------------------------------------

# 9. Estado global

Sí: auth, tenant, permisos\
No: UI local

------------------------------------------------------------------------

# 10. Estado

React Query\
React Hook Form\
Context/Zustand

------------------------------------------------------------------------

# 11. Patrones

Container/Presentational\
Custom Hooks\
Compound Components

------------------------------------------------------------------------

# 12. Naming

kebab-case archivos\
PascalCase componentes

------------------------------------------------------------------------

# 13. Refactor

Fase 1 → estructura\
Fase 2 → feature piloto\
Fase 3 → replicar\
Fase 4 → permisos

------------------------------------------------------------------------

# 14. Errores

-   shared gigante\
-   lógica en UI\
-   acoplamiento backend

------------------------------------------------------------------------

# 15. Skill personalizada

.claude/skills/keygo-ui-feature-architecture/SKILL.md

------------------------------------------------------------------------

# 16. Uso

/keygo-ui-feature-architecture

------------------------------------------------------------------------

# 17. Recomendación

Refactor incremental por features
