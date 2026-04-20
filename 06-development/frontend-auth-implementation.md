# Frontend: Autenticación e Implementación de Sesión

**Fase:** 06-development | **Audiencia:** Equipo frontend, especialistas en seguridad | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Introducción](#introducción)
2. [Flujos de Autenticación Soportados](#flujos-de-autenticación-soportados)
3. [Módulos Principales](#módulos-principales)
4. [Gestión de Tokens](#gestión-de-tokens)
5. [Recuperación de Sesión](#recuperación-de-sesión)
6. [Protección de Rutas y Roles](#protección-de-rutas-y-roles)
7. [Acciones Críticas y Confirmación](#acciones-críticas-y-confirmación)
8. [Manejo de Estados Especiales](#manejo-de-estados-especiales)
9. [Ejemplos de Código](#ejemplos-de-código)
10. [Troubleshooting](#troubleshooting)

---

## Introducción

La autenticación en KeyGo UI es **stateless en el cliente**, con tokens almacenados **únicamente en memoria**. Esta arquitectura:

- **Previene XSS:** Los tokens nunca son accesibles a scripts; no existen en `localStorage` o `sessionStorage`
- **Garantiza seguridad sin refreshes:** Los refresh tokens se transportan via HttpOnly cookies (servidor controla completamente)
- **Permite recuperación elegante:** Si el usuario refresca el navegador, la sesión puede recuperarse sin perder el token
- **Soporta multi-tenant:** La misma SPA autentica contra `/platform/...` y `/tenants/{slug}/...` simultáneamente

### Principios Clave

- **Tokens en memoria, refresh en cookie:** Solo almacenamos `accessToken` y `idToken` en una variable global de memoria durante el ciclo de vida
- **PKCE obligatorio:** Todos los flujos de login interactivo usan PKCE (Proof Key for Code Exchange)
- **Roles normalizados:** Los roles JWT se normalizan a minúsculas (`keygo_admin`, no `KEYGO_ADMIN`) para comparaciones consistentes
- **Renovación silenciosa:** Al 80% del TTL, se renueva automáticamente sin intervención del usuario
- **Logout = revocación:** Hacer logout borra tokens locales y notifica al backend para revocar refresh tokens

---

## Flujos de Autenticación Soportados

### 1. **Flujo PKCE (Primary: Platform & Tenant Login)**

Usado para login interactivo en el dashboard de plataforma (`keygo-ui`) y como hosted login para apps de tenant.

```
Usuario → Click "Login"
       → Frontend genera code_verifier + code_challenge + state
       → Redirige a backend: GET /oauth2/authorize?client_id=...&code_challenge=...&state=...
       → Backend → Usuario ingresa credenciales
       → Backend redirige back: GET /callback?code=...&state=...
       → Frontend intercambia code: POST /oauth2/token (code, code_verifier, client_id)
       → Backend responde: {access_token, refresh_token (via HttpOnly), id_token, expires_in}
       → Frontend almacena access_token + id_token en memoria
       → Zustand sessionStore actualizado
       → Usuario dentro
```

**Contexto:** Platform (Identity BC) y Tenant Auth (Access Control BC) son contextos independientes; cada uno devuelve sus propios tokens con distintos claims y TTL.

### 2. **Flujo Direct-Login (Reautenticación de Acciones Críticas)**

Para acciones administrativas de alto riesgo (crear tenant, cambiar permisos globales) sin cerrar la sesión actual.

```
Usuario en dashboard principal (con sesión activa)
       → Acción crítica requiere reautenticación
       → Frontend abre modal o flow: "Ingresa contraseña"
       → POST /api/v1/platform/account/direct-login {username, password}
       → Backend valida, responde {access_token_temp, id_token_temp} (no refresh)
       → Frontend verifica token temp, ejecuta acción crítica
       → Token temporal descartado tras acción
       → Sesión principal intacta
```

**Contexto:** Proporciona una barrera de fricción consciente (reingreso de credenciales) sin perder el contexto de sesión.

### 3. **Recuperación de Sesión (Browser Refresh)**

Cuando el usuario refresca (`F5`, cierra tab y reabre), la SPA recupera automáticamente el estado.

```
SPA monta → tokenStore está vacío (memoria perdida en refresh)
        → Pero refresh_token sigue en HttpOnly cookie (servidor la mantuvo)
        → Frontend detecta ruta protegida necesaria
        → Realiza GET /api/v1/platform/account/profile (cookie auto-enviada)
        → Backend valida cookie, emite nuevo access_token
        → Frontend reconstruye en memoria, Zustand actualizado
        → Experiencia transparente para usuario
```

**Contexto:** El estado de sesión (Identity BC) se resuelve server-side; el cliente recupera el estado necesario.

---

## Módulos Principales

| Módulo | Ubicación | Responsabilidad |
|--------|-----------|-----------------|
| **pkce.ts** | `src/lib/auth/` | Genera `code_verifier`, `code_challenge` (SHA256), `state` (uuid). Almacena `code_verifier` en sessionStorage **temporalmente** para el callback. |
| **tokenStore.ts** | `src/lib/auth/` | Zustand store con `accessToken`, `idToken`, `roles`, `expiresAt`, etc. Interfaz única para acceder/actualizar tokens en memoria. |
| **jwksVerify.ts** | `src/lib/auth/` | Descarga JWKS público del backend, valida signatures RS256 de ID tokens (defensa contra token forjados). Cachea JWKS por 1h. |
| **refresh.ts** | `src/lib/auth/` | Renueva automáticamente al 80% del TTL. Si falla (401 Unauthorized), limpia sesión y redirige a login. |
| **roleGuard.tsx** | `src/features/auth/guards/` | Componente HOC protegiendo rutas. Valida autenticación + roles requeridos. Renderiza fallback si no autorizado. |
| **logout.ts** | `src/lib/auth/` | Limpia memoria (tokenStore reset), invoca `POST /api/v1/account/logout` para revocar refresh token en backend. |
| **CriticalActionConfirmationModal.tsx** | `src/features/auth/modals/` | Modal reutilizable para confirmaciones de alto riesgo: frase consciente, reingreso de contraseña, callback final. |

### Estructura de tokenStore (Zustand)

```typescript
interface AuthSession {
  // Identidad
  accessToken: string | null
  idToken: string | null
  refreshToken: null  // nunca en memoria; vive en cookie
  
  // Contexto
  scope: 'platform' | 'tenant'  // platform vs tenant login
  tenantSlug?: string            // si scope === 'tenant'
  
  // Roles (normalizados)
  roles: string[]  // e.g. ['keygo_admin', 'keygo_user']
  primaryRole: string | null
  
  // Metadata
  userId: string
  userEmail: string
  expiresAt: number  // timestamp en ms
  
  // Acciones
  setSession: (tokens, roles, expiresAt) => void
  clearSession: () => void
  hasRole: (role: string) => boolean
  isExpired: () => boolean
}
```

---

## Gestión de Tokens

### Almacenamiento: In-Memory, Seguro

**Por qué solo memoria:**

1. **XSS Protection:** Incluso si un XSS inyecta código, no puede acceder a variables en memoria (solo a localStorage/sessionStorage)
2. **No persiste localStorage:** Tokens se pierden al cerrar tab o refresco (por diseño; refresh token en cookie permite recuperación elegante)
3. **Scope de proceso:** Cada tab/ventana tiene su propia memoria; no compartida entre dominios

**Flujo de recuperación tras refresh:**

```
Browser refresh → window reloads → tokenStore initialized empty
              → Zustand monta, lee del constructor
              → useEffect() en App.tsx detecta sesión vacía pero user está en /dashboard
              → useQuery(...async {GET /account/profile}) se ejecuta
              → Backend valida HttpOnly refresh_token cookie, responde usuario + permisos
              → Frontend hidrata tokenStore con nuevo access_token
              → useQuery cache se rellena
              → Página navegable
```

### Ciclo de Vida del Access Token

```
Token emitido (expires_in: 900s)
    ↓
En 720s (80% del TTL) → refresh.ts dispara renovación automática
    ↓
Si éxito: nuevo access_token en memoria, expiresAt actualizado
Si falla (401): sesión expirada o revocada → clearSession() → redirige /login
    ↓
En 900s → token muere, próxima request autom. falla 401
    ↓
Interceptor axios ve 401 → intenta renovar si refresh_token válido
Si refresh_token no existe → logout forzado → /login
```

### ID Token: Verificación y Claims

El `idToken` (JWT RS256) contiene:

```json
{
  "iss": "https://keygo.local/oauth2",
  "sub": "user-uuid-123",
  "aud": "keygo-ui",
  "exp": 1700000000,
  "iat": 1699999100,
  "auth_time": 1699999100,
  "roles": ["KEYGO_ADMIN", "KEYGO_USER"],
  "email": "admin@keygo.local",
  "tenant_slug": null
}
```

**Validaciones:**

1. Signature: jwksVerify.ts descarga JWKS público, verifica RS256
2. Issuer (`iss`): debe coincidir con endpoint de autorización (previene token de otro servidor)
3. Audience (`aud`): debe ser `keygo-ui` (previene reutilización en otra app)
4. Expiration (`exp`): no debe estar en el pasado
5. Issued At (`iat`): no debe ser futuro (clock skew tolerado: ±30s)

**Anti-pattern:** No confíes en `roles` del JWT para borrar datos u ocultar UI crítica. El JWT se puede inspeccionar en DevTools. Siempre valida en backend antes de ejecutar acciones sensibles.

---

## Recuperación de Sesión

### Escenario 1: User Refresh durante sesión válida

```typescript
// App.tsx (o layout raíz)
useEffect(() => {
  const { accessToken, isExpired } = tokenStore.getState()
  
  if (!accessToken || isExpired()) {
    // Intenta recuperar desde backend
    // GET /account/profile con HttpOnly refresh cookie
    useQuery(['account', 'profile'], fetchProfile, {
      retry: false,
      onSuccess: (profile) => {
        // Backend ya roló nuevo access_token en header Authorization
        tokenStore.setSession(newToken, roles, expiresAt)
      },
      onError: (err) => {
        // 401 o 403: sesión inválida
        tokenStore.clearSession()
        navigate('/login')
      }
    })
  }
}, [])
```

### Escenario 2: Close & Reopen Tab

```
Tab 1: usuario en /dashboard con sesión activa (tokens en memoria)
     → Usuario cierra tab
     → Memoria borrada

Minutos después, usuario abre nuevo tab → GET /dashboard
     → tokenStore vacío pero usuario debería estar autenticado
     → App.tsx useEffect() intenta GET /account/profile
     → Si refresh_token cookie aún válida (TTL 30 días):
        - Backend emite nuevo access_token
        - Frontend hidrata sesión
        - Redirige a /dashboard
     → Si refresh_token expiró o fue revocado:
        - Backend 401 Unauthorized
        - Frontend limpia, redirige a /login
```

### Contrata Especial: NewContractPage (Resume Workflow)

En el flujo de registro (`/register?resume=1&contract_id=X`), si el usuario navega lejos y vuelve:

```typescript
// NewContractPage.tsx
useEffect(() => {
  const contractId = searchParams.get('contract_id')
  if (contractId && !formData.contractId) {
    // Pre-llenar y dejar solo lectura
    setFormData(prev => ({ ...prev, contractId, contractIdReadonly: true }))
  }
}, [])

// En ResumeLookupStep: input contractId tiene disabled={contractIdReadonly}
// Previene que el link reanude un contrato distinto
```

---

## Protección de Rutas y Roles

### RoleGuard HOC

```typescript
interface RoleGuardProps {
  requiredRoles?: string[]  // ['keygo_admin'] | undefined (solo autenticado)
  requirementMode?: 'any' | 'all'  // any: tiene AL MENOS uno; all: tiene TODOS
  fallback?: React.ReactNode
  children: React.ReactNode
}

export function RoleGuard({ requiredRoles, requirementMode = 'any', fallback, children }: RoleGuardProps) {
  const { accessToken, roles } = tokenStore()
  const navigate = useNavigate()
  
  // No autenticado
  if (!accessToken) {
    navigate('/login', { replace: true })
    return fallback || <Unauthorized />
  }
  
  // Autenticado pero sin roles requeridos
  if (requiredRoles?.length) {
    const hasRequired = requirementMode === 'any'
      ? requiredRoles.some(r => roles.includes(normalizeRole(r)))
      : requiredRoles.every(r => roles.includes(normalizeRole(r)))
    
    if (!hasRequired) {
      return fallback || <Forbidden />
    }
  }
  
  return <>{children}</>
}

// Uso
<RoleGuard requiredRoles={['keygo_admin']}>
  <AdminDashboard />
</RoleGuard>
```

### Dashboard Tenant: Owner vs Admin

En `/dashboard/tenants`:

- **`keygo_admin`**: Ve directorio global de **todos** los tenants, puede crear nuevos
- **`keygo_account_admin`**: Ve solo tenants donde `owner_email` coincide con su email

Tras seleccionar tenant:

```typescript
const selectTenant = (tenant) => {
  // Zustand: actualiza managedTenantSlug
  // Próximas queries incluyen tenantSlug en su queryKey
  // API calls ahora usan /api/v1/tenants/{slug}/...
}
```

---

## Acciones Críticas y Confirmación

### Escala de Fricción

| Acción | Tipo | Confirmación | Reauth |
|--------|------|--------------|--------|
| Cambiar nombre de tenant | Moderada | Modal simple | No |
| Añadir usuario a tenant | Moderada | Confirmación nombrada | No |
| Cambiar rol de usuario (admin → user) | Alta | Confirmación + phrase consciente | Sí |
| Eliminar tenant | Crítica | Frase obligatoria + reauth | Sí |
| Cambiar email de plataforma | Crítica | Frase + contraseña | Sí |

### CriticalActionConfirmationModal

```typescript
interface CriticalActionConfig {
  title: string
  description: string
  actionLabel: string
  consciousphraseRequired?: string  // e.g. "delete my org"
  requirePassword?: boolean
  onConfirm: () => Promise<void>
  onCancel?: () => void
}

// Uso
const [isOpen, setIsOpen] = useState(false)

<CriticalActionConfirmationModal
  isOpen={isOpen}
  title="Eliminar Tenant"
  description="Esta acción es irreversible. Todos los datos se perderán."
  actionLabel="Eliminar"
  consciousphraseRequired="delete my organization"
  requirePassword={true}
  onConfirm={async () => {
    await deleteOrganization()
    setIsOpen(false)
  }}
  onCancel={() => setIsOpen(false)}
/>

<button onClick={() => setIsOpen(true)}>Delete</button>
```

### Validaciones Internas

```typescript
// CriticalActionConfirmationModal.tsx
const [phrase, setPhrase] = useState('')
const [password, setPassword] = useState('')
const [canConfirm, setCanConfirm] = useState(false)

useEffect(() => {
  const phraseOk = !config.consciousphraseRequired || phrase === config.consciousphraseRequired
  const passwordOk = !config.requirePassword || password.length > 0
  setCanConfirm(phraseOk && passwordOk)
}, [phrase, password])

// Sólo si requirePassword, valida contraseña antes de ejecutar:
if (config.requirePassword) {
  const validated = await validatePassword(password)  // POST /account/validate-password
  if (!validated) {
    showError('Contraseña incorrecta')
    return
  }
}

// Luego sí: onConfirm()
```

---

## Manejo de Estados Especiales

### Cuenta Suspendida

Si el JWT o `GET /account/profile` responde `account_status: SUSPENDED`:

```typescript
// AccountDetailPage.tsx
if (account.status === 'SUSPENDED') {
  return (
    <SuspendedAccountView
      account={account}
      onlyShowReactivateButton={true}
      allInputsDisabled={true}
      disableAllNavLinks={true}
    />
  )
}
```

**Regla:** No renderices CTAs, links interactivos, ni formularios editable. Solo show read-only info + "Reactivate" button.

### Cambio de Tenant (Multi-Tenant Switching)

```typescript
const switchTenant = async (newTenantSlug) => {
  // Zustand: tokenStore.setTenantSlug(newTenantSlug)
  // TanStack Query: invalidate queries with tenantSlug en queryKey
  // Redirige a /dashboard (o /dashboard/tenants/{newSlug}/overview)
  
  // Próximas requests incluyen /api/v1/tenants/{newTenantSlug}/...
}
```

### Re-login después de logout

```typescript
const logout = async () => {
  // POST /api/v1/account/logout (revoca refresh token en backend)
  await apiClient.post('/account/logout')
  
  // Limpia memoria
  tokenStore.clearSession()
  
  // Redirige
  navigate('/login', { replace: true })
}
```

---

## Ejemplos de Código

### 1. Setup PKCE + Redirect a Authorize

```typescript
// login.ts
export async function initiateLogin(platform: 'platform' | 'tenant', tenantSlug?: string) {
  const { codeVerifier, codeChallenge, state } = generatePKCE()
  
  // Almacena verifier temporalmente (sessionStorage, borrado tras callback)
  sessionStorage.setItem('pkce_verifier', codeVerifier)
  sessionStorage.setItem('pkce_state', state)
  
  const authorizeUrl = `${BACKEND_URL}/oauth2/authorize?` +
    `client_id=${CLIENT_ID}` +
    `&response_type=code` +
    `&redirect_uri=${FRONTEND_CALLBACK_URL}` +
    `&code_challenge=${codeChallenge}` +
    `&code_challenge_method=S256` +
    `&state=${state}` +
    `&scope=openid%20profile%20email`
  
  if (platform === 'tenant' && tenantSlug) {
    authorizeUrl += `&tenant_slug=${tenantSlug}`
  }
  
  window.location.href = authorizeUrl
}
```

### 2. Callback y Token Exchange

```typescript
// callbackPage.tsx (GET /callback?code=...&state=...)
useEffect(async () => {
  const urlParams = new URLSearchParams(window.location.search)
  const code = urlParams.get('code')
  const state = urlParams.get('state')
  
  // Valida state (CSRF protection)
  const savedState = sessionStorage.getItem('pkce_state')
  if (state !== savedState) {
    showError('Invalid state parameter (CSRF)')
    return
  }
  
  const codeVerifier = sessionStorage.getItem('pkce_verifier')
  
  // Exchange code por token
  const response = await fetch(`${BACKEND_URL}/oauth2/token`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    credentials: 'include',  // include HttpOnly cookies
    body: JSON.stringify({
      grant_type: 'authorization_code',
      code,
      code_verifier: codeVerifier,
      client_id: CLIENT_ID,
      client_secret: CLIENT_SECRET  // si confidential client; else omit
    })
  })
  
  const { access_token, id_token, expires_in, refresh_token } = await response.json()
  
  // NO guardes refresh_token (está en HttpOnly cookie ya)
  // Guarda access_token e id_token en memoria
  tokenStore.setSession(access_token, id_token, expiresIn)
  
  // Valida id_token signature
  const decoded = await jwksVerify.verify(id_token)
  tokenStore.setRoles(decoded.roles, decoded.sub)
  
  // Limpia sessionStorage
  sessionStorage.removeItem('pkce_verifier')
  sessionStorage.removeItem('pkce_state')
  
  // Redirige
  navigate('/dashboard', { replace: true })
}, [])
```

### 3. Refresh Automático

```typescript
// useAuthRefresh.ts (custom hook)
export function useAuthRefresh() {
  useEffect(() => {
    const { accessToken, expiresAt } = tokenStore.getState()
    
    if (!accessToken) return
    
    // Calcula cuándo renovar (80% del TTL)
    const now = Date.now()
    const timeLeft = expiresAt - now
    const renewAt = timeLeft * 0.8
    
    const timer = setTimeout(async () => {
      try {
        // GET /account/profile (backend valida refresh token en cookie)
        const response = await fetch(`${BACKEND_URL}/account/profile`, {
          credentials: 'include'
        })
        
        if (response.ok) {
          const data = await response.json()
          // Backend envía Authorization header con nuevo token
          const newToken = response.headers.get('X-Access-Token') || extractFromAuth(response)
          tokenStore.setSession(newToken, data.idToken, data.expiresIn)
        } else if (response.status === 401) {
          tokenStore.clearSession()
          // usuario será redirigido al intentar acceder a ruta protegida
        }
      } catch (error) {
        console.error('Token refresh failed', error)
      }
    }, renewAt)
    
    return () => clearTimeout(timer)
  }, [])
}
```

### 4. Axios Interceptor para Token Injection

```typescript
// client.ts (axios setup)
const apiClient = axios.create({
  baseURL: `${BACKEND_URL}/api/v1`,
  timeout: 10000
})

apiClient.interceptors.request.use(config => {
  const { accessToken } = tokenStore.getState()
  if (accessToken) {
    config.headers.Authorization = `Bearer ${accessToken}`
  }
  
  // Incluye tenant slug si está en store
  const { tenantSlug } = tokenStore.getState()
  if (tenantSlug && !config.url?.includes('/platform/')) {
    config.url = `/tenants/${tenantSlug}${config.url}`
  }
  
  return config
})

// Response: captura 401, redirige a login
apiClient.interceptors.response.use(
  response => response,
  error => {
    if (error.response?.status === 401) {
      tokenStore.clearSession()
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
)
```

---

## Troubleshooting

### Problema: Usuario vuelve a pedir login constantemente

**Causas posibles:**
- Refresh token expirado o revocado en backend
- JWKS cache corrupto; nuevas claves signing aún no descargadas
- Diferencia de reloj entre cliente/servidor

**Soluciones:**
1. Verifica que backend no revocó sesión (check refresh_token table si disponible)
2. Limpia JWKS cache: `jwksVerify.clearCache()`
3. Sincroniza reloj del cliente: `ntpd` o `ntpdate`

### Problema: Token renovación no dispara

**Causas posibles:**
- `useAuthRefresh()` hook no montado en la ruta correcta
- `expiresAt` mal calculado (en segundos vs ms)
- Timer fue limpiado antes de completarse

**Soluciones:**
1. Asegúrate que `useAuthRefresh()` está en un layout raíz (App.tsx o root layout)
2. Verifica unidad temporal: `expiresAt = Date.now() + (expires_in * 1000)`
3. Usa `console.log()` para rastrear el timer:
   ```typescript
   console.log('Renew at:', renewAt, 'ms from now')
   console.log('Expires at:', expiresAt, 'ms from epoch')
   ```

### Problema: Acciones críticas no funcionan con reauth

**Causas posibles:**
- Modal no valida la contraseña contra backend
- `validatePassword()` endpoint no implementado
- Token temporal no se envía en headers

**Soluciones:**
1. Verifica que `validatePassword()` hace POST a backend (no validación local)
2. Revisa logs del backend para errores de autenticación
3. Asegúrate que CriticalActionConfirmationModal envía token temporal si está configurado:
   ```typescript
   if (config.requirePassword) {
     const { tempToken } = await validatePassword(password)
     // Envía tempToken en header para acción crítica
   }
   ```

### Problema: JWKS verification falla ("Invalid signature")

**Causas posibles:**
- JWKS cache desincronizado (backend rotó claves, cliente no lo sabe)
- ID token corrupto o alterado en tránsito
- Algoritmo signing cambió en backend (RS256 → RS512)

**Soluciones:**
1. Fuerza descarga de JWKS fresco:
   ```typescript
   await jwksVerify.clearCache()
   const decoded = await jwksVerify.verify(idToken)
   ```
2. Verifica logs del backend: ¿se rotaron claves recientemente?
3. Imprime el header del token: `atob(idToken.split('.')[0])` y valida `alg`

---

## Véase También

- **frontend-project-structure.md** — Cómo organizar módulos de auth en `src/features/auth/`
- **frontend-api-integration.md** — Cómo integrar TanStack Query con interceptores de auth
- **frontend-architecture.md** — Stack general y decisiones de diseño
- **oauth2-oidc-contract.md** — Especificación del protocolo OAuth2/OIDC en backend
- **authorization-patterns.md** — Cómo funcionan los roles y scopes en los contextos

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Equipo Frontend | **Licencia:** Keygo Docs
