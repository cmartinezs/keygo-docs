[← Índice](./README.md) | [Siguiente >](./frontend-project-structure.md)

---

# Frontend Architecture

Stack tecnológico, principios de diseño y flujo de datos de KeyGo UI — SPA React/TypeScript montada sobre Vite.

## Contenido

- [Stack Tecnológico](#stack-tecnológico)
- [Principios de Diseño](#principios-de-diseño)
- [Flujo de Datos](#flujo-de-datos)
- [Estado Global](#estado-global)
- [Data Fetching](#data-fetching)
- [Principios de Seguridad](#principios-de-seguridad)
- [Developer Experience](#developer-experience)

---

## Stack Tecnológico

| Capa | Herramienta | Versión | Propósito |
|------|-------------|---------|----------|
| **Bundler** | Vite | Latest | Build rápido, dev server con HMR |
| **UI Framework** | React | 18+ | Component-based UI |
| **Lenguaje** | TypeScript | Strict | Type-safe code, better IDE support |
| **Routing** | React Router | v6+ | Client-side SPA routing |
| **Estado Global** | Zustand | - | Session, preferences (lightweight) |
| **Data Fetching** | TanStack Query | v4+ | Server state management, caching |
| **HTTP Client** | Axios | - | Typed HTTP requests, interceptors |
| **Formularios** | React Hook Form | v7+ | Performant form handling |
| **Validación** | Zod | - | Schema validation (type-safe) |
| **JWT Decode** | jose | - | JWT parsing en cliente |
| **Estilos** | Tailwind CSS | v3+ | Utility-first CSS |
| **Componentes** | shadcn/ui | - | Composable, accessible components |
| **Testing** | Vitest | - | Unit tests (Vite-native) |
| **Testing UI** | Testing Library | - | Component testing best practices |
| **API Mocking** | MSW | - | Mock Service Worker for dev/test |
| **Internacionalización** | i18next | - | Multi-language support |

---

## Principios de Diseño

### 1. Tokens en Memoria (Nunca LocalStorage)

**Por qué:** Previene XSS attacks. Refresh tokens almacenados en HttpOnly cookies del servidor.

```typescript
// ✅ BIEN: En memoria durante sesión
let accessToken: string | null = null;

// ❌ MAL: Never store in localStorage
localStorage.setItem('token', token);
```

Consecuencia: Sesión se pierde al refresh del browser (por diseño) — uso `Session Recovery` para restaurar.

### 2. Requests Tipadas y Desacopladas de la UI

Separación clara entre **API layer** (contracts) y **UI layer** (presentación).

```typescript
// src/features/auth/api.ts (API layer - tipo-safe)
export const loginUser = async (email: string, password: string) => {
  const response = await httpClient.post<LoginResponse>('/api/v1/platform/account/login', {
    email,
    password,
  });
  return response.data;
};

// src/features/auth/login/LoginForm.tsx (UI layer)
export const LoginForm = () => {
  const mutation = useMutation({ mutationFn: loginUser });
  
  return (
    <form onSubmit={(e) => {
      e.preventDefault();
      mutation.mutate({ email, password });
    }}>
      {/* UI */}
    </form>
  );
};
```

**Ventaja:** API puede ser reutilizada desde CLI, tests, scripts sin UI.

### 3. Guards por Autenticación y Rol en Routing

Protección en la **capa de routing** (no en componentes).

```typescript
// src/app/guards/roleGuard.tsx
export const RoleGuard = ({ requiredRoles }: { requiredRoles: string[] }) => {
  const { session } = useSession();
  
  if (!session?.user) return <Navigate to="/login" />;
  if (!requiredRoles.some(role => session.roles.includes(role))) {
    return <Navigate to="/unauthorized" />;
  }
  
  return <Outlet />;
};

// src/App.tsx (routing tree)
<Routes>
  <Route path="/auth/*" element={<PublicLayout />} />
  <Route element={<RoleGuard requiredRoles={['ADMIN_ORG']} />}>
    <Route path="/console/*" element={<AdminLayout />} />
  </Route>
</Routes>
```

### 4. Loader Global Solo para Bootstrap Crítico

La mayoría de cargas son **locales al componente** (via TanStack Query).

```typescript
// ✅ BIEN: Solo para bootstrap
const bootstrapLoader = async () => {
  const session = await restoreSession();
  const tenants = await fetchTenants();
  return { session, tenants };
};

// ❌ MAL: Global loader para cada página
const pageLoader = async () => {
  const [users, apps, billing] = await Promise.all([...]);
  // → Lento, bloquea navegación
};
```

---

## Flujo de Datos

```
┌──────────────────────────────────────────────────────┐
│ Backend API (REST)                                   │
└─────────────────────┬────────────────────────────────┘
                      │
        ┌─────────────▼──────────────┐
        │ Axios (HTTP Client)        │
        │ - Interceptors             │
        │ - Error handling           │
        └─────────────┬──────────────┘
                      │
        ┌─────────────▼────────────────────┐
        │ TanStack Query                   │
        │ - Request deduplication          │
        │ - Automatic refetch on visibility│
        │ - Stale data management          │
        └─────────────┬────────────────────┘
                      │
        ┌─────────────▼─────────────────────────┐
        │ Container Component                   │
        │ - useQuery + useMutation              │
        │ - Business logic orchestration        │
        └─────────────┬─────────────────────────┘
                      │
        ┌─────────────▼──────────────────┐
        │ Presenter Component            │
        │ - Props-only (pure rendering)  │
        │ - Accessible, no fetch logic   │
        └────────────────────────────────┘
```

**Regla:** Nunca hace fetch directo desde presenters. Usar hooks y queries.

---

## Estado Global

### Zustand: Session & Preferences (Lightweight)

```typescript
// src/shared/lib/auth/sessionStore.ts
import { create } from 'zustand';

interface SessionStore {
  session: Session | null;
  setSession: (session: Session | null) => void;
  logout: () => void;
}

export const useSession = create<SessionStore>((set) => ({
  session: null,
  setSession: (session) => set({ session }),
  logout: () => set({ session: null }),
}));
```

**Uso:**
```typescript
const { session, setSession } = useSession();
```

**Limitación:** Solo para valores que persisten en **memoria durante la sesión**. NO usar para:
- Datos del servidor (usa TanStack Query)
- Preferencias persistentes (usa localStorage + Zustand combo)

### TanStack Query: Server State (Recomendado)

```typescript
// Container component
const UserListPage = () => {
  const { data: users, isLoading, error } = useQuery({
    queryKey: ['users', tenantId],
    queryFn: () => fetchUsers(tenantId),
    staleTime: 5 * 60 * 1000, // 5 min
  });
  
  return <UserListPresenter users={users} isLoading={isLoading} />;
};
```

**Ventajas:**
- Automatic cache invalidation
- Retry logic builtin
- Deduplicates in-flight requests
- Refetch on window focus

---

## Data Fetching

### API Client Setup (src/shared/api/httpClient.ts)

```typescript
import axios from 'axios';

export const httpClient = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:8080',
  headers: {
    'Content-Type': 'application/json',
  },
});

// Interceptor: Add authorization header
httpClient.interceptors.request.use((config) => {
  const token = getAccessToken(); // From memory
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Interceptor: Handle 401 → refresh token
httpClient.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401) {
      // Attempt refresh (server sends new token)
      await refreshToken();
      // Retry original request
      return httpClient(error.config);
    }
    throw error;
  }
);
```

### Typed API Methods (src/features/*/api.ts)

```typescript
// src/features/console/api.ts
export interface CreateAppRequest {
  name: string;
  redirectUris: string[];
}

export interface AppResponse {
  id: string;
  name: string;
  status: 'DRAFT' | 'ACTIVE' | 'SUSPENDED';
}

export const createApp = async (
  tenantSlug: string,
  request: CreateAppRequest
): Promise<AppResponse> => {
  const response = await httpClient.post<AppResponse>(
    `/api/v1/tenants/${tenantSlug}/apps`,
    request
  );
  return response.data;
};

export const useCreateApp = (tenantSlug: string) => {
  const queryClient = useQueryClient();
  
  return useMutation({
    mutationFn: (request: CreateAppRequest) => createApp(tenantSlug, request),
    onSuccess: () => {
      queryClient.invalidateQueries({
        queryKey: ['apps', tenantSlug],
      });
    },
  });
};
```

### Error Handling

```typescript
// src/shared/api/errorHandler.ts
export const handleApiError = (error: unknown): ApiError => {
  if (axios.isAxiosError(error)) {
    return {
      code: error.response?.data?.code || 'UNKNOWN_ERROR',
      message: error.response?.data?.message || 'An error occurred',
      status: error.response?.status,
    };
  }
  return {
    code: 'UNKNOWN_ERROR',
    message: String(error),
  };
};

// Usage in component
const { mutate, error } = useMutation({
  mutationFn: loginUser,
  onError: (err) => {
    const apiError = handleApiError(err);
    toast.error(apiError.message);
  },
});
```

---

## Principios de Seguridad

### 1. No Guardar Tokens en LocalStorage

```typescript
// ❌ NO
localStorage.setItem('token', jwtToken);

// ✅ SÍ: En memoria (se pierde en refresh)
let accessToken = jwtToken;
```

### 2. Refresh Token en HttpOnly Cookie

Server establece refresh token en **HttpOnly, Secure, SameSite=Strict** cookie:

```
Set-Cookie: refresh_token=...; HttpOnly; Secure; SameSite=Strict; Path=/
```

Cliente no puede acceder (`document.cookie` no lo ve) → protección contra XSS.

### 3. CORS & Origin Validation

Server rechaza requests de origins no autorizados. Frontend siempre hace requests desde origin autorizado.

### 4. Role-Based Guards

Guards en routing previenen navegación a rutas no autorizadas:

```typescript
<Route element={<RoleGuard requiredRoles={['ADMIN_ORG']} />}>
  <Route path="/settings" element={<SettingsPage />} />
</Route>
```

**Nota:** Guards no son suficientes — backend debe también validar autorización.

---

## Developer Experience

### Hot Module Replacement (HMR)

Vite hot-reloads componentes sin perder estado durante desarrollo:

```bash
npm run dev
# → Servidor en http://localhost:5173
```

Cambias un archivo `.tsx` → navegador actualiza al instante.

### TypeScript Strict Mode

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true
  }
}
```

Requiere que todo sea explícitamente tipado. Evita bugs comunes en runtime.

### Testing Setup

```bash
npm run test            # Vitest watch mode
npm run test:coverage   # Code coverage report
```

Componentes testeados con Testing Library (enfocado en behavior, no implementación).

### Environment Variables

```
.env                    # Default (committed)
.env.local              # Local overrides (gitignored)
.env.production         # Production-specific
```

Acceder en código: `import.meta.env.VITE_API_URL`

---

## Referencias

- [Project Structure](./frontend-project-structure.md) — Carpetas y responsabilidades
- [Auth Implementation](./frontend-auth-implementation.md) — Sesiones, tokens, refresh
- [API Integration](./frontend-api-integration.md) — TanStack Query, axios config
- [Authorization Patterns](./authorization-patterns.md) — JWT claims, role validation
- [OAuth2/OIDC Contract](./oauth2-oidc-contract.md) — Backend auth flows

---

[← Índice](./README.md) | [Siguiente >](./frontend-project-structure.md)
