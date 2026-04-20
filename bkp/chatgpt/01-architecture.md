# Arquitectura Frontend — KeyGo UI

## Estado del documento
- Versión: 1.0
- Estado: Activo
- Tipo: Arquitectura
- Alcance: Frontend (React + Vite)

---

## Tabla de contenidos

1. Objetivo  
2. Principio rector  
3. Mapa de dominio  
4. Estructura general  
5. Estructura interna de features  
6. Capas y responsabilidades  
7. Modelos  
8. Rutas  
9. Guards y control de acceso  
10. Estado  
11. Patrones  
12. Convenciones  
13. Estrategia de refactor  
14. Errores comunes  
15. Skill de apoyo  
16. Uso  
17. Plan de ejecución  

---

## 1. Objetivo

Pasar desde un frontend “con pantallas y flujos funcionando” a un frontend:

- organizado por **dominio/feature**
- con separación clara entre:
  - presentación
  - lógica de UI
  - acceso a API
  - modelos/contratos
- fácil de mantener
- fácil de escalar
- alineado con backend y DDD

---

## 2. Principio rector

Organizar por **feature de negocio**, no por tipo técnico.

### ❌ Estructura tradicional

src/
  components/
  pages/
  hooks/
  services/

### ✅ Estructura recomendada

src/
  app/
  shared/
  modules/

---

## 3. Mapa de dominio

- auth  
- tenant  
- users  
- applications  
- memberships  
- roles-permissions  
- billing  
- audit  
- platform-admin  

---

## 4. Estructura general

src/
  app/
    router/
    providers/
    layouts/
    store/
    bootstrap/

  shared/
    api/
    components/
    hooks/
    lib/
    types/
    constants/
    styles/

  modules/
    auth/
    tenant-console/
    platform-console/

---

## 5. Estructura interna de features

features/users/
  api/
  components/
  hooks/
  model/
  pages/
  state/
  utils/

---

## 6. Capas y responsabilidades

- pages → composición  
- components → UI  
- hooks → lógica  
- api → llamadas HTTP  
- model → tipos, mappers  
- state → estado UI  

---

## 7. Modelos

Separar:

- DTO (backend)
- ViewModel (UI)
- FormValues (formularios)

---

## 8. Rutas

/auth/login  
/console/users  
/console/apps  
/platform/tenants  

---

## 9. Guards y control de acceso

- AuthGuard  
- TenantGuard  
- PermissionGuard  

Ejemplo:

<PermissionGuard permissions={['users.read']}>
  <UsersPage />
</PermissionGuard>

---

## 10. Estado

- React Query → server state  
- React Hook Form → formularios  
- Context/Zustand → UI global mínima  

---

## 11. Patrones

- Container / Presentational  
- Custom Hooks  
- Compound Components  

---

## 12. Convenciones

- Archivos → kebab-case  
- Componentes → PascalCase  
- Hooks → useX  

---

## 13. Estrategia de refactor

Fase 1 → estructura  
Fase 2 → feature piloto  
Fase 3 → replicar  
Fase 4 → permisos  

---

## 14. Errores comunes

- shared gigante  
- lógica en UI  
- acoplamiento backend  

---

## 15. Skill de apoyo

.claude/skills/keygo-ui-feature-architecture/SKILL.md

---

## 16. Uso

/keygo-ui-feature-architecture

---

## 17. Plan de ejecución

1. Seleccionar feature piloto  
2. Refactor incremental  
3. Replicar patrón  
4. Consolidar arquitectura  

---

## Notas finales

Este documento define la base para escalar KeyGo UI de forma sostenible.
