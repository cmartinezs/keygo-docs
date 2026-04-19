# Catálogo de Requerimientos — Keygo (Versión Endgame)

## 1. Objetivo

Definir un catálogo de Requerimientos Funcionales (RF) y No Funcionales (RNF) a nivel **ingeniería**, alineado con la arquitectura de un sistema IAM SaaS multi-tenant.

Este catálogo:
- Evita ambigüedades de alto nivel
- Separa dominios funcionales reales
- Sirve como base para diseño, modelado y construcción
- Permite posteriormente definir alcance de MVP y roadmap evolutivo

---

## 2. Principio Arquitectónico Base

> **Una identidad única por tenant, con membresías por aplicación**

Esto implica:
- Usuario pertenece a un Tenant
- Aplicaciones pertenecen a un Tenant
- Relación usuario–aplicación se modela mediante **Membership**
- Autorización se define por roles por aplicación

---

## 3. Requerimientos Funcionales (RF)

### 3.1 Dominio: Tenant (Organización)

#### RF01 — Gestión de Tenants
El sistema debe permitir:
- Crear, editar y eliminar tenants
- Activar o suspender tenants
- Gestionar identificadores únicos (slug/subdominio)

---

#### RF02 — Configuración del Tenant
El sistema debe permitir:
- Configurar parámetros del tenant
- Definir políticas básicas de autenticación
- Configurar elementos de branding (opcional MVP)

---

### 3.2 Dominio: Identidad

#### RF03 — Gestión de Usuarios
El sistema debe permitir:
- Crear, editar y desactivar usuarios
- Gestionar atributos básicos (email, username, estado)
- Invitar usuarios al tenant

---

#### RF04 — Autenticación de Usuarios
El sistema debe permitir:
- Autenticación mediante credenciales (username/email + password)
- Manejo de sesiones autenticadas
- Integración con flujos OAuth2/OIDC

---

#### RF05 — Gestión de Credenciales
El sistema debe permitir:
- Cambio de contraseña
- Recuperación de contraseña (reset)
- Validación de credenciales

---

### 3.3 Dominio: Aplicaciones (OAuth / OIDC)

#### RF06 — Registro de Aplicaciones Cliente
El sistema debe permitir:
- Registrar aplicaciones dentro de un tenant
- Generar `client_id`
- Generar y rotar `client_secret` (para confidential clients)

---

#### RF07 — Configuración OAuth2/OIDC
El sistema debe permitir:
- Definir redirect URIs
- Configurar grant types (Authorization Code, PKCE, Client Credentials)
- Definir scopes permitidos

---

### 3.4 Dominio: Membership (Relación Usuario-App)

#### RF08 — Gestión de Membresías
El sistema debe permitir:
- Asignar usuarios a aplicaciones
- Revocar acceso de usuarios a aplicaciones
- Mantener estado de la membresía (activa, suspendida, invitada)

---

#### RF09 — Roles por Aplicación
El sistema debe permitir:
- Definir roles por aplicación
- Asignar roles a usuarios dentro de una aplicación
- Gestionar jerarquía básica de roles (opcional MVP)

---

### 3.5 Dominio: Autorización

#### RF10 — Control de Acceso Basado en Roles (RBAC)
El sistema debe permitir:
- Evaluar permisos en base a roles
- Aplicar autorización a nivel de aplicación
- Incluir roles en tokens emitidos

---

### 3.6 Dominio: Tokens & Seguridad OAuth

#### RF11 — Emisión de Tokens
El sistema debe:
- Emitir access tokens (JWT)
- Emitir refresh tokens
- Incluir claims relevantes (tenant, usuario, roles, app)

---

#### RF12 — Validación de Tokens
El sistema debe:
- Validar tokens emitidos
- Permitir a aplicaciones validar tokens sin dependencia directa (JWT)

---

#### RF13 — Publicación de Claves (JWKS)
El sistema debe:
- Exponer endpoint JWKS
- Permitir validación externa de firmas
- Gestionar rotación de claves

---

#### RF14 — Gestión de Sesiones
El sistema debe:
- Mantener sesiones activas
- Permitir revocación de sesiones
- Manejar expiración de tokens

---

### 3.7 Dominio: Facturación (Billing)

#### RF15 — Gestión de Suscripciones
El sistema debe:
- Asociar un plan a cada tenant
- Gestionar estado de suscripción

---

#### RF16 — Medición de Uso
El sistema debe:
- Medir uso por tenant (usuarios, apps, requests, etc.)
- Permitir aplicar límites según plan

---

#### RF17 — Integración de Pagos (Futuro)
El sistema debe:
- Integrarse con proveedores de pago externos
- Gestionar estados de pago

---

### 3.8 Dominio: Auditoría

#### RF18 — Registro de Eventos
El sistema debe:
- Registrar eventos relevantes (login, cambios, accesos)
- Persistir logs auditables

---

#### RF19 — Trazabilidad
El sistema debe:
- Permitir seguimiento de acciones por usuario
- Proveer historial de eventos

---

### 3.9 Dominio: Plataforma (Keygo Ops)

#### RF20 — Administración Global
El sistema debe permitir:
- Gestionar tenants a nivel plataforma
- Suspender o bloquear tenants

---

#### RF21 — Operación de Plataforma
El sistema debe permitir:
- Acceso a herramientas de soporte
- Monitoreo global del sistema

---

## 4. Requerimientos No Funcionales (RNF)

### RNF01 — Seguridad
El sistema debe:
- Proteger credenciales y datos sensibles
- Implementar cifrado en tránsito y reposo
- Prevenir ataques comunes (OWASP)

---

### RNF02 — Aislamiento Multi-Tenant
El sistema debe:
- Garantizar aislamiento lógico entre tenants
- Evitar acceso cruzado de datos

---

### RNF03 — Privacidad de Datos
El sistema debe:
- Proteger datos personales
- Permitir cumplimiento de normativas de privacidad

---

### RNF04 — Disponibilidad y Resiliencia
El sistema debe:
- Mantener alta disponibilidad
- Soportar fallos parciales

---

### RNF05 — Rendimiento
El sistema debe:
- Mantener tiempos de respuesta bajos en autenticación
- Optimizar validación de tokens

---

### RNF06 — Escalabilidad
El sistema debe:
- Escalar horizontalmente
- Soportar crecimiento de tenants y usuarios

---

### RNF07 — Mantenibilidad
El sistema debe:
- Tener código modular
- Permitir evolución sin afectar estabilidad

---

### RNF08 — Observabilidad
El sistema debe:
- Exponer métricas
- Permitir logging estructurado
- Integrarse con sistemas de monitoreo

---

### RNF09 — Usabilidad
El sistema debe:
- Proveer interfaces claras para usuarios y administradores
- Minimizar fricción en autenticación

---

### RNF10 — Compatibilidad con Estándares IAM
El sistema debe:
- Cumplir con OAuth2
- Cumplir con OpenID Connect
- Utilizar JWT

---

### RNF11 — Cumplimiento y Gobernanza
El sistema debe:
- Permitir auditoría
- Facilitar cumplimiento normativo

---

### RNF12 — Gestión de Claves Criptográficas
El sistema debe:
- Permitir rotación de claves
- Gestionar ciclo de vida de llaves

---

### RNF13 — Consistencia de Tokens
El sistema debe:
- Manejar expiración correctamente
- Considerar tolerancia de reloj (clock skew)

---

### RNF14 — Latencia de Autenticación
El sistema debe:
- Definir SLA de autenticación (ej: < 200ms en condiciones normales)

---

## 5. Notas Finales

- Este catálogo representa el **estado objetivo (endgame)** del sistema.
- El alcance de MVP será definido posteriormente a partir de este catálogo.
- Cada RF podrá descomponerse en:
  - Historias de usuario
  - Casos de uso
  - Especificaciones técnicas

---