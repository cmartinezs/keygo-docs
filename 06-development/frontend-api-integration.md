# Frontend: Integración API y Manejo de Errores

**Fase:** 06-development | **Audiencia:** Equipo frontend, especialistas en integración | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Introducción](#introducción)
2. [Contrato Base: BaseResponse<T>](#contrato-base-baseresponset)
3. [Arquitectura de Capas API](#arquitectura-de-capas-api)
4. [Axios Client Setup](#axios-client-setup)
5. [TanStack Query Patterns](#tanstack-query-patterns)
6. [Normalización de Errores](#normalización-de-errores)
7. [Estrategia de Retry](#estrategia-de-retry)
8. [Casos Especiales por Dominio](#casos-especiales-por-dominio)
9. [Ejemplos de Código](#ejemplos-de-código)
10. [Testing y MSW](#testing-y-msw)

---

## Introducción

La integración API en KeyGo frontend sigue un patrón de **3 capas**:

1. **Axios Client** (`client.ts`): Configuración base, interceptores, headers
2. **Response Helpers** (`response.ts`): Unwrap `BaseResponse<T>` → datos tipados
3. **Error Normalizer** (`errorNormalizer.ts`): Traducción de errores backend → form usable

**Principios:**

- Todos los endpoints responden `BaseResponse<T>` (envoltura estándar)
- La UI nunca ve `BaseResponse`; helpers extraen `data` automáticamente
- Errores se normalizan a un formato común (código, mensaje, field-level details)
- TanStack Query gestiona cache y refetching; Zustand solo para sesión
- Timeouts explícitos por endpoint crítico
- Retry automático solo para GET; POST/PUT/DELETE requieren idempotencia

---

## Contrato Base: BaseResponse<T>

Todos los endpoints backend responden con este envelope:

### Success (2xx)

```json
{
  "statusCode": 200,
  "message": "Operation successful",
  "data": {
    "id": "tenant-uuid",
    "name": "Acme Corp",
    "created_at": "2025-01-15T10:30:00Z"
  },
  "timestamp": "2025-01-15T10:30:00.123Z"
}
```

### Error (4xx/5xx)

```json
{
  "statusCode": 400,
  "message": "Validation failed",
  "errors": [
    {
      "field": "email",
      "message": "Invalid email format"
    },
    {
      "field": "name",
      "message": "Name is required"
    }
  ],
  "details": {
    "hint": "Check required fields",
    "code": "VALIDATION_ERROR"
  },
  "timestamp": "2025-01-15T10:30:00.123Z"
}
```

### Frontend Unwrapping

```typescript
// client.ts response interceptor
apiClient.interceptors.response.use(
  response => {
    // Todos los 2xx llegan aquí como {statusCode, message, data, timestamp}
    // Extrae solo `data` para los handlers
    return response.data?.data  // Retorna el payload, no el envelope
  },
  error => {
    // 4xx/5xx caen aquí; normaliza antes de propagar
    const normalized = normalizeError(error.response?.data)
    return Promise.reject(normalized)
  }
)
```

---

## Arquitectura de Capas API

```
src/lib/api/
├── client.ts              # Axios instance + interceptores
├── response.ts            # Helpers para unwrap BaseResponse<T>
├── errorNormalizer.ts     # Traducción de errores
├── config.ts              # Constantes (timeouts, endpoints)
└── hooks/
    ├── useAccount.ts      # Account queries (platform & tenant scoped)
    ├── useTenants.ts      # Tenant queries
    ├── useUsers.ts        # User/membership queries
    ├── useBilling.ts      # Billing & subscriptions
    ├── useApps.ts         # OAuth apps
    └── ... (por dominio)

src/features/*/api/
├── {feature}.queries.ts   # useQuery hooks para esta feature
├── {feature}.mutations.ts # useMutation hooks
└── {feature}.types.ts     # DTOs y tipos tipados
```

### Módulos por Dominio

| Dominio | Query Hook | Mutation Hook | DTOs | Notas |
|---------|-----------|---------------|------|-------|
| **Account** | `useAccountProfile()` | `useUpdateProfile()` | `AccountDTO` | Platform vs Tenant scope |
| **Tenants** | `useTenants()`, `useTenantDetail()` | `useCreateTenant()`, `useUpdateTenant()` | `TenantDTO` | Tenant-scoped después de seleccionar |
| **Users** | `useTenantUsers()` | `useInviteUser()`, `useRemoveUser()` | `UserDTO` | Tenant-scoped |
| **Roles** | `usePlatformRoles()`, `useTenantRoles()` | `useAssignRole()` | `RoleDTO` | Catálogos desde backend |
| **Apps** | `useApps()`, `useAppDetail()` | `useCreateApp()`, `useDeleteApp()` | `AppDTO` | OAuth apps para tenants |
| **Billing** | `useSubscriptions()`, `useCatalog()` | `useUpdateSubscription()` | `SubscriptionDTO` | Stripe integration |
| **Auth** | N/A (backend-driven) | `useLogin()`, `useRegister()` | `LoginDTO` | PKCE flow |

---

## Axios Client Setup

### client.ts: Base Configuration

```typescript
import axios from 'axios'
import { tokenStore } from '@/lib/auth/tokenStore'
import { normalizeError } from './errorNormalizer'

const apiClient = axios.create({
  baseURL: `${import.meta.env.VITE_API_URL}/api/v1`,
  timeout: 30000,  // default; puede ser overridden por request
  headers: {
    'Content-Type': 'application/json'
  }
})

// Interceptor: Inyecta access token + tenant slug
apiClient.interceptors.request.use(config => {
  const { accessToken, tenantSlug } = tokenStore.getState()
  
  // Auth header
  if (accessToken) {
    config.headers.Authorization = `Bearer ${accessToken}`
  }
  
  // Tenant scope (para endpoints /api/v1/tenants/*)
  if (tenantSlug && !config.url?.includes('/platform/')) {
    config.url = `/tenants/${tenantSlug}${config.url}`
  }
  
  // Request ID para trazabilidad (backend incluye en logs)
  config.headers['X-Request-ID'] = generateUUID()
  
  return config
})

// Interceptor: Maneja respuestas y errores
apiClient.interceptors.response.use(
  response => {
    // Extrae payload del envelope BaseResponse<T>
    return response.data?.data ?? response.data
  },
  error => {
    const normalized = normalizeError(error)
    
    // 401: token expirado o revocado
    if (error.response?.status === 401) {
      tokenStore.clearSession()
      window.location.href = '/login'
    }
    
    // 403: sin permisos (no redirige; UI maneja estado)
    if (error.response?.status === 403) {
      // UI muestra "Access Denied" en contexto
    }
    
    return Promise.reject(normalized)
  }
)

export default apiClient
```

### Timeouts Explícitos por Request Crítico

```typescript
// hooks/useCreateTenant.ts
export function useCreateTenant() {
  return useMutation({
    mutationFn: async (data: CreateTenantInput) => {
      return apiClient.post('/tenants', data, {
        timeout: 5000  // override default 30s para creación
      })
    },
    onError: (error) => {
      // maneja error
    }
  })
}

// Valor típico por tipo:
// - GET (list, detail): 30s
// - POST/PUT (create, update): 10-15s
// - DELETE: 5s
// - File upload: 60s
```

---

## TanStack Query Patterns

### 1. Queries Simples (Fetch & Cache)

```typescript
// hooks/useAccountProfile.ts
export function useAccountProfile() {
  const { tenantSlug } = tokenStore()
  
  return useQuery({
    queryKey: ['account', 'profile', tenantSlug],  // tenantSlug parte de la clave
    queryFn: async () => {
      const endpoint = tenantSlug
        ? `/tenants/${tenantSlug}/account/profile`
        : `/platform/account/profile`
      return apiClient.get(endpoint)
    },
    staleTime: 5 * 60 * 1000,  // 5 minutos
    gcTime: 10 * 60 * 1000,     // 10 minutos
    retry: true,                 // GET es idempotente, retry OK
    retryDelay: (attemptIndex) => Math.min(1000 * 2 ** attemptIndex, 30000)
  })
}

// En componente
function ProfilePage() {
  const { data: profile, isLoading, error } = useAccountProfile()
  
  if (isLoading) return <Skeleton />
  if (error) return <ErrorAlert error={error} />
  
  return <ProfileForm initialData={profile} />
}
```

### 2. Queries con Parámetros (Paginación, Filtros)

```typescript
// hooks/useTenantUsers.ts
interface UseUserListOptions {
  page?: number
  limit?: number
  role?: string
  sort?: string
}

export function useTenantUsers(options: UseUserListOptions = {}) {
  const { tenantSlug } = tokenStore()
  const { page = 1, limit = 20, role, sort } = options
  
  return useQuery({
    queryKey: ['users', tenantSlug, { page, limit, role, sort }],
    queryFn: async () => {
      const params = new URLSearchParams({
        page: String(page),
        limit: String(limit),
        ...(role && { role }),
        ...(sort && { sort })
      })
      return apiClient.get(`/users?${params}`)
    },
    staleTime: 2 * 60 * 1000
  })
}

// Uso con cambio de página
function UsersList() {
  const [page, setPage] = useState(1)
  const { data, isLoading } = useTenantUsers({ page })
  
  return (
    <div>
      <UserTable users={data?.users} />
      <Pagination 
        current={page} 
        total={data?.total}
        onChange={setPage}
      />
    </div>
  )
}
```

### 3. Mutations (POST/PUT/DELETE)

```typescript
// hooks/useInviteUser.ts
interface InviteUserInput {
  email: string
  role: string
}

export function useInviteUser() {
  const queryClient = useQueryClient()
  
  return useMutation({
    mutationFn: (data: InviteUserInput) => 
      apiClient.post('/users/invite', data),
    
    onSuccess: (newUser) => {
      // Invalida cache de usuarios para refetch automático
      queryClient.invalidateQueries({ queryKey: ['users'] })
      
      // O actualiza optimista:
      queryClient.setQueryData(
        ['users', newUser.tenant_slug],
        (old) => ({
          ...old,
          users: [...(old?.users || []), newUser]
        })
      )
    },
    
    onError: (error) => {
      // Error normalizado (ver errorNormalizer)
      console.error('Failed to invite user:', error)
    }
  })
}

// Uso
function InviteUserForm() {
  const { mutate, isPending, error } = useInviteUser()
  
  return (
    <form onSubmit={(e) => {
      e.preventDefault()
      mutate({ email, role })
    }}>
      {error && <ErrorAlert error={error} />}
      <input name="email" />
      <select name="role">
        {/* ver useRoleCatalog() */}
      </select>
      <button disabled={isPending}>
        {isPending ? 'Inviting...' : 'Invite'}
      </button>
    </form>
  )
}
```

### 4. Computed Queries (Derived Data)

```typescript
// hooks/useCanManageTenant.ts
export function useCanManageTenant() {
  const { data: profile } = useAccountProfile()
  const { tenantSlug } = tokenStore()
  
  // Solo ejecuta si profile disponible
  return {
    canCreate: profile?.roles?.includes('keygo_admin'),
    canDelete: profile?.roles?.includes('keygo_admin'),
    canEdit: tenantSlug !== undefined,  // tenant-scoped users pueden editar su tenant
    canView: !!profile
  }
}
```

---

## Normalización de Errores

### errorNormalizer.ts

```typescript
export interface NormalizedError {
  code: string
  message: string
  statusCode: number
  fieldErrors?: Record<string, string>  // field → message
  hint?: string
  original?: any
}

export function normalizeError(error: any): NormalizedError {
  const statusCode = error.response?.status ?? error.status ?? 500
  const data = error.response?.data
  
  // Backend devuelve un AxiosError con BaseResponse envelope
  if (data?.errors && Array.isArray(data.errors)) {
    // Validation errors: convierte array a Record
    const fieldErrors = data.errors.reduce((acc, err) => ({
      ...acc,
      [err.field]: err.message
    }), {})
    
    return {
      code: data.details?.code || 'VALIDATION_ERROR',
      message: data.message || 'Validation failed',
      statusCode,
      fieldErrors,
      hint: data.details?.hint,
      original: data
    }
  }
  
  // Error genérico o sin estructura esperada
  return {
    code: error.code || 'UNKNOWN_ERROR',
    message: error.response?.data?.message || error.message || 'An error occurred',
    statusCode,
    original: error.response?.data || error
  }
}

// Uso en componentes
function FormPage() {
  const { mutate, error } = useSomeAction()
  
  return (
    <>
      {error && (
        <div>
          {/* Errores globales */}
          <Alert>{error.message}</Alert>
          
          {/* Errores por campo */}
          {error.fieldErrors && (
            <div>
              {Object.entries(error.fieldErrors).map(([field, msg]) => (
                <FieldError key={field} field={field} message={msg} />
              ))}
            </div>
          )}
        </div>
      )}
    </>
  )
}
```

---

## Estrategia de Retry

### Regla General

| HTTP Status | Retryable? | Razón |
|------------|-----------|-------|
| 2xx | ✅ No | Éxito; no retry necesario |
| 400 Bad Request | ❌ No | Error del cliente; retry no ayuda |
| 401 Unauthorized | ❌ No (custom) | Sesión expirada; redirect a login |
| 403 Forbidden | ❌ No | Sin autorización; retry no ayuda |
| 404 Not Found | ❌ No | Recurso no existe |
| 429 Too Many Requests | ✅ Sí | Rate limit; wait + retry |
| 500 Server Error | ✅ Sí | Transient; exponential backoff |
| 502/503 | ✅ Sí | Backend down; exponential backoff |
| Timeout | ✅ Sí | Network issue; retry con jitter |

### Configuración por Tipo de Request

```typescript
// GET (safe, idempotent)
useQuery({
  queryKey: [...],
  queryFn: () => apiClient.get(...),
  retry: 3,  // Máximo 3 reintentos
  retryDelay: (attemptIndex) => {
    const delay = Math.min(1000 * Math.pow(2, attemptIndex), 30000)
    const jitter = Math.random() * 1000
    return delay + jitter
  }
})

// POST (no idempotente sin Idempotency-Key)
useMutation({
  mutationFn: (data) => apiClient.post('/resource', data, {
    headers: {
      'Idempotency-Key': generateUUID()  // Backend usa esto para deduplicar
    }
  }),
  retry: false  // Sin retry automático; manual si falla
})

// POST con Idempotency-Key (seguro para retry)
useMutation({
  mutationFn: (data) => {
    const idempotencyKey = data.idempotencyKey || generateUUID()
    return apiClient.post('/resource', data, {
      headers: { 'Idempotency-Key': idempotencyKey }
    })
  },
  retry: 1  // OK para reintentar si el backend soporta deduplicación
})
```

---

## Casos Especiales por Dominio

### Account: Platform vs Tenant Scope

```typescript
// El endpoint cambia según scope
// Platform user: GET /api/v1/platform/account/profile
// Tenant user: GET /api/v1/tenants/{slug}/account/profile

export function useAccountProfile() {
  const { tenantSlug } = tokenStore()
  
  return useQuery({
    queryKey: ['account', 'profile', tenantSlug],
    queryFn: () => {
      if (tenantSlug) {
        return apiClient.get(`/tenants/${tenantSlug}/account/profile`)
      } else {
        return apiClient.get('/platform/account/profile')
      }
    }
  })
}
```

### Catálogos Administrativos (Roles, etc.)

**Regla:** No hardcodees opciones. Siempre fetch del backend.

```typescript
// hooks/useRoleCatalog.ts
export function usePlatformRoleCatalog() {
  return useQuery({
    queryKey: ['roles', 'platform'],
    queryFn: () => apiClient.get('/platform/roles'),
    staleTime: 60 * 60 * 1000,  // 1 hora
    gcTime: 2 * 60 * 60 * 1000   // 2 horas
  })
}

// Componente: Select de roles
function RoleSelect() {
  const { data: roles } = usePlatformRoleCatalog()
  
  return (
    <Select>
      {roles?.map(role => (
        <option key={role.code} value={role.code}>
          {role.display_name}
        </option>
      ))}
    </Select>
  )
}
```

### Acciones Críticas: Validación POST antes de DELETE

```typescript
// useDeleteTenant.ts
export function useDeleteTenant() {
  return useMutation({
    mutationFn: async (tenantId: string) => {
      // Primero valida que operación es posible
      const can = await apiClient.get(`/tenants/${tenantId}/can-delete`)
      if (!can?.allowed) {
        throw new Error(can?.reason || 'Cannot delete this tenant')
      }
      
      // Luego DELETE
      return apiClient.delete(`/tenants/${tenantId}`)
    }
  })
}
```

### 403 FORBIDDEN: Anti-Enumeration

Backend responde siempre 200 OK para ciertas operaciones (e.g., forgot-password) aunque no exista el recurso. Frontend debe asumir que fue procesado, no redirigir a "not found".

```typescript
// useCheckEmailAvailability.ts
export function useCheckEmailAvailability(email: string) {
  return useQuery({
    queryKey: ['email', 'available', email],
    queryFn: () => apiClient.get(`/platform/account/check-email?email=${email}`),
    enabled: !!email && isValidEmail(email),
    retry: false
  })
}

// Interpretación de status
// 200: Email found (usuario existe)
// 404: Email available (libre para registro)
// 401: Session invalid (reauth necesaria)
// => UI nunca enumera usuarios basado en response; siempre muestra "Check your email"
```

---

## Ejemplos de Código

### 1. Lista con Paginación y Filtro

```typescript
// hooks/useTenantUsers.ts
interface UserListFilters {
  page: number
  limit: number
  role?: string
  search?: string
}

export function useTenantUsers(filters: UserListFilters) {
  return useQuery({
    queryKey: ['users', filters],
    queryFn: async () => {
      const params = new URLSearchParams()
      params.set('page', String(filters.page))
      params.set('limit', String(filters.limit))
      if (filters.role) params.set('role', filters.role)
      if (filters.search) params.set('search', filters.search)
      
      return apiClient.get(`/users?${params}`)
    }
  })
}

// Componente
function UsersList() {
  const [filters, setFilters] = useState<UserListFilters>({
    page: 1,
    limit: 20
  })
  
  const { data, isLoading } = useTenantUsers(filters)
  
  const handlePageChange = (newPage: number) => {
    setFilters(prev => ({ ...prev, page: newPage }))
    // TanStack Query refetch automático
  }
  
  const handleFilterChange = (role: string) => {
    setFilters(prev => ({ ...prev, page: 1, role }))
  }
  
  return (
    <div>
      <UserFilters onChange={handleFilterChange} />
      <UserTable users={data?.users} loading={isLoading} />
      <Pagination 
        current={filters.page}
        total={data?.pagination?.total}
        onChange={handlePageChange}
      />
    </div>
  )
}
```

### 2. Optimistic Update + Rollback

```typescript
// hooks/useUpdateUserRole.ts
export function useUpdateUserRole() {
  const queryClient = useQueryClient()
  
  return useMutation({
    mutationFn: (payload: { userId: string, newRole: string }) =>
      apiClient.patch(`/users/${payload.userId}/role`, { role: newRole }),
    
    onMutate: async (payload) => {
      // Cancela queries en vuelo
      await queryClient.cancelQueries({ queryKey: ['users'] })
      
      // Guarda estado previo para rollback
      const previousUsers = queryClient.getQueryData(['users'])
      
      // Update optimista
      queryClient.setQueryData(['users'], (old: any) => ({
        ...old,
        users: old.users.map(user =>
          user.id === payload.userId
            ? { ...user, role: payload.newRole }
            : user
        )
      }))
      
      return { previousUsers }
    },
    
    onError: (error, variables, context) => {
      // Rollback
      queryClient.setQueryData(['users'], context?.previousUsers)
    },
    
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] })
    }
  })
}
```

### 3. Form Submission con Field Errors

```typescript
// Componente con form
function InviteUserForm() {
  const [form, setForm] = useState({ email: '', role: '' })
  const { mutate, error, isPending } = useInviteUser()
  
  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    mutate(form)
  }
  
  // error.fieldErrors = { email: "Invalid format", role: "Required" }
  const emailError = error?.fieldErrors?.email
  const roleError = error?.fieldErrors?.role
  
  return (
    <form onSubmit={handleSubmit}>
      {error?.message && !error.fieldErrors && (
        <Alert type="error">{error.message}</Alert>
      )}
      
      <div>
        <label>Email</label>
        <input
          name="email"
          value={form.email}
          onChange={(e) => setForm({ ...form, email: e.target.value })}
          aria-invalid={!!emailError}
        />
        {emailError && <span className="error">{emailError}</span>}
      </div>
      
      <div>
        <label>Role</label>
        <select
          name="role"
          value={form.role}
          onChange={(e) => setForm({ ...form, role: e.target.value })}
          aria-invalid={!!roleError}
        >
          <option value="">Select...</option>
          <option value="admin">Admin</option>
          <option value="user">User</option>
        </select>
        {roleError && <span className="error">{roleError}</span>}
      </div>
      
      <button type="submit" disabled={isPending}>
        {isPending ? 'Inviting...' : 'Invite'}
      </button>
    </form>
  )
}
```

---

## Testing y MSW

### Mock Service Worker Setup

```typescript
// src/mocks/handlers.ts
import { http, HttpResponse } from 'msw'

export const handlers = [
  // GET /api/v1/tenants
  http.get(`${API_BASE}/tenants`, () => {
    return HttpResponse.json({
      statusCode: 200,
      data: [
        { id: '1', name: 'Acme Corp', slug: 'acme' },
        { id: '2', name: 'TechCorp', slug: 'techcorp' }
      ]
    })
  }),
  
  // POST /api/v1/tenants
  http.post(`${API_BASE}/tenants`, async ({ request }) => {
    const body = await request.json()
    
    if (!body.name) {
      return HttpResponse.json(
        {
          statusCode: 400,
          message: 'Validation failed',
          errors: [{ field: 'name', message: 'Name is required' }]
        },
        { status: 400 }
      )
    }
    
    return HttpResponse.json(
      {
        statusCode: 201,
        data: { id: 'new-1', name: body.name, slug: slugify(body.name) }
      },
      { status: 201 }
    )
  }),
  
  // GET /api/v1/users
  http.get(`${API_BASE}/users`, ({ request }) => {
    const url = new URL(request.url)
    const page = url.searchParams.get('page') || '1'
    const limit = url.searchParams.get('limit') || '20'
    
    return HttpResponse.json({
      statusCode: 200,
      data: {
        users: [
          { id: '1', email: 'alice@acme.local', role: 'admin' },
          { id: '2', email: 'bob@acme.local', role: 'user' }
        ],
        pagination: { page: parseInt(page), total: 2, limit: parseInt(limit) }
      }
    })
  })
]

// src/mocks/server.ts
import { setupServer } from 'msw/node'
export const server = setupServer(...handlers)
```

### Test con TanStack Query + MSW

```typescript
// src/features/tenants/useCreateTenant.test.ts
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { server } from '@/mocks/server'

beforeAll(() => server.listen())
afterEach(() => server.resetHandlers())
afterAll(() => server.close())

test('creates a tenant', async () => {
  const queryClient = new QueryClient()
  
  render(
    <QueryClientProvider client={queryClient}>
      <CreateTenantForm />
    </QueryClientProvider>
  )
  
  const input = screen.getByLabelText('Tenant Name')
  await userEvent.type(input, 'NewCorp')
  
  const button = screen.getByRole('button', { name: /create/i })
  await userEvent.click(button)
  
  await waitFor(() => {
    expect(screen.getByText('NewCorp')).toBeInTheDocument()
  })
})
```

---

## Véase También

- **frontend-auth-implementation.md** — Cómo gestionar tokens y sesión
- **frontend-architecture.md** — Stack y decisiones de diseño
- **frontend-project-structure.md** — Dónde poner hooks, DTOs, queries
- **api-endpoints-comprehensive.md** — Especificación de endpoints backend
- **authorization-patterns.md** — Roles, scopes, y verificación de permisos

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Equipo Frontend | **Licencia:** Keygo Docs
