[← Índice](./README.md) | [< Anterior](./frontend-architecture.md) | [Siguiente >](./frontend-auth-implementation.md)

---

# Frontend Project Structure

Organización del proyecto KeyGo UI — feature-first architecture con capas app, features, y shared.

**Principio:** Lógica de negocio vive en `features/`; código transversal en `shared/`; infraestructura en `app/`.

## Contenido

- [Estructura Principal](#estructura-principal)
- [Capas & Responsabilidades](#capas--responsabilidades)
- [Reglas de Organización](#reglas-de-organización)
- [Ejemplos de Submódulos](#ejemplos-de-submódulos)
- [Anti-Patterns](#anti-patterns)

---

## Estructura Principal

```
src/
├── main.tsx                  # Bootstrap: i18n, QueryClient, Router, MSW
├── App.tsx                   # Routes, guards, layouts, global overlays
├── vite-env.d.ts             # Vite type definitions
├── README.md                 # Frontend setup & conventions
│
├── app/
│   ├── guards/               # Route guards (AuthGuard, RoleGuard)
│   └── layouts/              # Shared layouts (AdminLayout, PublicLayout)
│
├── features/                 # Feature-first modules by business domain
│   ├── account/              # User account area
│   ├── auth/                 # Authentication (login, register, recovery)
│   ├── console/              # Tenant operations (apps, users, billing)
│   ├── ops/                  # Platform operations (admin, tenants, stats)
│   └── public/               # Public pages (landing, docs)
│
├── shared/                   # Transversal code (reusable)
│   ├── api/                  # HTTP client, helpers
│   ├── hooks/                # Reusable hooks (theme, user, etc)
│   ├── lib/                  # Infrastructure (auth, config, i18n, network, tracing)
│   ├── mocks/                # MSW setup & handlers
│   ├── types/                # Shared types & DTOs
│   └── ui/                   # Reusable UI components (overlays, dropdowns, paginator, cards)
│
└── styles/
    └── index.css             # Global Tailwind styles
```

---

## Capas & Responsabilidades

### src/main.tsx — Bootstrap

```typescript
import React from 'react';
import ReactDOM from 'react-dom/client';
import { QueryClientProvider } from '@tanstack/react-query';
import { BrowserRouter } from 'react-router-dom';
import i18n from 'i18next';

import App from './App';
import { queryClient } from './shared/api/queryClient';
import { initializeAuth } from './shared/lib/auth/initialize';
import { setupMSW } from './shared/mocks/setup';

// i18n setup
i18n.init({ /* ... */ });

// MSW (Mock Service Worker) for dev/test
if (import.meta.env.DEV) {
  setupMSW();
}

// Restore session from server
await initializeAuth();

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <QueryClientProvider client={queryClient}>
      <BrowserRouter>
        <App />
      </BrowserRouter>
    </QueryClientProvider>
  </React.StrictMode>
);
```

### src/App.tsx — Routing & Layout

```typescript
import { Routes, Route, Navigate } from 'react-router-dom';
import { AuthGuard, RoleGuard } from './app/guards';
import { AdminLayout, PublicLayout } from './app/layouts';
import { DevConsole, GlobalErrorBoundary, Toaster } from './shared/ui';

export default function App() {
  return (
    <GlobalErrorBoundary>
      <Routes>
        {/* Public routes */}
        <Route element={<PublicLayout />}>
          <Route path="/" element={<Landing />} />
          <Route path="/docs/*" element={<PublicDocs />} />
        </Route>

        {/* Auth routes (login, register, recovery) */}
        <Route path="/auth/*" element={<AuthLayout />} />

        {/* Protected routes: requires authentication */}
        <Route element={<AuthGuard />}>
          {/* User account (role-agnostic) */}
          <Route path="/account/*" element={<AccountPages />} />
          
          {/* Tenant console: requires ADMIN_ORG or higher */}
          <Route element={<RoleGuard requiredRoles={['ADMIN_ORG']} />}>
            <Route path="/console/*" element={<AdminLayout />} />
          </Route>
          
          {/* Platform admin: requires keygo_admin */}
          <Route element={<RoleGuard requiredRoles={['keygo_admin']} />}>
            <Route path="/ops/*" element={<AdminLayout />} />
          </Route>
        </Route>

        {/* 404 fallback */}
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>

      <Toaster />
      <DevConsole />
    </GlobalErrorBoundary>
  );
}
```

### src/app/ — Infrastructure

#### guards/roleGuard.tsx

```typescript
import { Navigate, Outlet } from 'react-router-dom';
import { useSession } from '../../../shared/lib/auth/sessionStore';

export const AuthGuard = () => {
  const { session, isLoading } = useSession();
  
  if (isLoading) return <LoadingScreen />;
  if (!session) return <Navigate to="/auth/login" replace />;
  
  return <Outlet />;
};

export const RoleGuard = ({ requiredRoles }: { requiredRoles: string[] }) => {
  const { session } = useSession();
  
  if (!session) return <Navigate to="/auth/login" replace />;
  
  const hasRole = requiredRoles.some(role => session.roles.includes(role));
  
  if (!hasRole) {
    return <Navigate to="/unauthorized" replace />;
  }
  
  return <Outlet />;
};
```

#### layouts/AdminLayout.tsx

```typescript
export const AdminLayout = () => {
  const { session } = useSession();
  
  // Session contains JWT claims including roles and tenant_slug
  const displayName = session?.user?.email || session?.sub;
  
  return (
    <div className="flex h-screen">
      <Sidebar userName={displayName} />
      <main className="flex-1 overflow-auto">
        <Header />
        <Outlet />
      </main>
    </div>
  );
};
```

### src/features/ — Business Logic by Domain

**Estructura:** Cada feature es autónomo (own API, state, UI).

```
src/features/auth/
├── api.ts                    # Typed API methods: loginUser, registerUser, etc.
├── login/
│   ├── LoginForm.tsx         # Presenter component
│   ├── loginStore.ts         # Local state (temp form data)
│   └── useLoginFlow.ts       # Container hook: orchestrate mutation + navigation
├── register/
│   ├── RegisterForm.tsx
│   └── useRegisterFlow.ts
└── recovery/
    └── ...

src/features/console/
├── apps/
│   ├── api.ts                # createApp, deleteApp, listApps
│   ├── AppList.tsx           # Container: useQuery
│   ├── AppCard.tsx           # Presenter
│   └── CreateAppDialog.tsx   # Form + useMutation
├── users/
│   ├── api.ts
│   ├── UserList.tsx
│   └── ...
└── dashboard/
    └── Dashboard.tsx

src/features/account/
├── api.ts                    # Fetch profile, update settings, etc.
├── profile/
│   ├── ProfilePage.tsx       # Container
│   ├── ProfileForm.tsx       # Presenter
│   └── useUpdateProfile.ts   # useMutation hook
├── settings/
│   └── ...
└── security/
    ├── ChangePassword.tsx
    └── SessionsList.tsx
```

### src/shared/ — Transversal Code

#### shared/api/httpClient.ts

```typescript
import axios from 'axios';

export const httpClient = axios.create({
  baseURL: import.meta.env.VITE_API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Add auth header on every request
httpClient.interceptors.request.use((config) => {
  const token = getAccessToken();
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Handle 401 → refresh token
httpClient.interceptors.response.use(
  (res) => res,
  async (error) => {
    if (error.response?.status === 401) {
      const refreshed = await refreshAccessToken();
      if (refreshed) {
        return httpClient(error.config);
      }
      // Refresh failed → logout
      handleLogout();
    }
    throw error;
  }
);
```

#### shared/lib/auth/sessionStore.ts

```typescript
import { create } from 'zustand';

export interface Session {
  sub: string;
  email: string;
  roles: string[];
  tenant_slug?: string;
}

interface SessionStore {
  session: Session | null;
  isLoading: boolean;
  setSession: (session: Session | null) => void;
  logout: () => void;
}

export const useSession = create<SessionStore>((set) => ({
  session: null,
  isLoading: true,
  setSession: (session) => set({ session, isLoading: false }),
  logout: () => set({ session: null }),
}));
```

#### shared/types/index.ts

```typescript
// Shared DTOs and types used across features
export interface LoginRequest {
  email: string;
  password: string;
}

export interface LoginResponse {
  access_token: string;
  token_type: 'Bearer';
  expires_in: number;
}

export interface CreateAppRequest {
  name: string;
  redirectUris: string[];
}

export interface AppResponse {
  id: string;
  name: string;
  status: 'DRAFT' | 'ACTIVE';
}

// ... more types
```

#### shared/ui/ — Reusable Components

```
src/shared/ui/
├── Button.tsx              # Styled button (shadcn)
├── Dialog.tsx              # Modal (shadcn)
├── Dropdown.tsx            # Dropdown menu (custom)
├── Paginator.tsx           # Pagination (custom)
├── PlanCard.tsx            # Billing plan card
├── Toaster.tsx             # Toast notifications
├── AppErrorBoundary.tsx    # Error boundary
└── icons/                  # Icon components
```

**Regla:** Un componente aquí si es reutilizado en 2+ features. Sino, queda dentro de la feature.

---

## Reglas de Organización

### ✅ BIEN

1. **Lógica de negocio en features**
   ```typescript
   src/features/console/apps/api.ts
   src/features/console/apps/CreateAppDialog.tsx
   ```

2. **API methods tipadas por feature**
   ```typescript
   src/features/auth/api.ts           // loginUser, registerUser
   src/features/console/apps/api.ts   // createApp, listApps
   ```

3. **Hooks reutilizables en shared**
   ```typescript
   src/shared/hooks/useTheme.ts
   src/shared/hooks/usePagination.ts
   ```

4. **Tipos compartidos centralizados**
   ```typescript
   src/shared/types/index.ts  // LoginResponse, AppResponse
   ```

5. **Guards en app/guards**
   ```typescript
   src/app/guards/roleGuard.tsx
   src/app/guards/authGuard.tsx
   ```

### ❌ NO HACER

1. ❌ Fetch directo en presenters
   ```typescript
   // MAL
   const UserList = () => {
     const [users, setUsers] = useState([]);
     useEffect(() => {
       fetch('/api/users').then(res => setUsers(res.json()));
     }, []);
   };
   ```

2. ❌ Tipos de API duplicados
   ```typescript
   // MAL: tipos en cada feature
   src/features/auth/types.ts
   src/features/console/types.ts
   // BIEN: compartidos
   src/shared/types/index.ts
   ```

3. ❌ Lógica de ruteo en features
   ```typescript
   // MAL
   src/features/console/Navigation.tsx
   // BIEN
   src/app/layouts/Navigation.tsx
   ```

4. ❌ UI local reutilizado en `shared/ui`
   ```typescript
   // MAL: componentes específicos de auth aquí
   src/shared/ui/LoginForm.tsx
   // BIEN: en su feature
   src/features/auth/login/LoginForm.tsx
   ```

5. ❌ Estado global en Zustand para datos del servidor
   ```typescript
   // MAL
   const useUsers = create(() => ({
     users: [],
     fetchUsers: () => { /* fetch */ }
   }));
   
   // BIEN: usa TanStack Query
   const { data: users } = useQuery({
     queryKey: ['users'],
     queryFn: fetchUsers,
   });
   ```

---

## Ejemplos de Submódulos

### Ejemplo 1: Feature Completa (console/apps)

```
src/features/console/apps/
├── api.ts                      # Contracts: createApp, updateApp, deleteApp, listApps
│
├── list/
│   ├── AppListPage.tsx         # Container: useQuery(['apps'])
│   ├── AppCard.tsx             # Presenter: props-only
│   └── AppListFilter.tsx       # Local filter state
│
├── create/
│   ├── CreateAppDialog.tsx     # Container: useMutation + useQueryClient
│   ├── CreateAppForm.tsx       # Presenter: form UI
│   └── redirectUriField.tsx    # Specialized field component
│
└── detail/
    ├── AppDetailPage.tsx       # Container: useQuery(['apps', appId])
    ├── AppSettings.tsx         # Presenter + local mutations
    └── revokeAppDialog.tsx     # Confirmation dialog
```

### Ejemplo 2: API Methods (features/console/apps/api.ts)

```typescript
import { httpClient } from '@/shared/api/httpClient';
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';

export interface AppResponse {
  id: string;
  name: string;
  status: 'DRAFT' | 'ACTIVE';
}

export const createApp = async (
  tenantSlug: string,
  data: { name: string; redirectUris: string[] }
): Promise<AppResponse> => {
  const response = await httpClient.post(
    `/api/v1/tenants/${tenantSlug}/apps`,
    data
  );
  return response.data;
};

export const listApps = async (tenantSlug: string): Promise<AppResponse[]> => {
  const response = await httpClient.get(`/api/v1/tenants/${tenantSlug}/apps`);
  return response.data;
};

// Hook: useCreateApp
export const useCreateApp = (tenantSlug: string) => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data) => createApp(tenantSlug, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['apps', tenantSlug] });
    },
  });
};

// Hook: useApps
export const useApps = (tenantSlug: string) => {
  return useQuery({
    queryKey: ['apps', tenantSlug],
    queryFn: () => listApps(tenantSlug),
  });
};
```

### Ejemplo 3: Container Component

```typescript
// src/features/console/apps/list/AppListPage.tsx
import { useState } from 'react';
import { useApps } from '../api';
import { AppCard } from './AppCard';
import { AppListFilter } from './AppListFilter';

export const AppListPage = () => {
  const { tenantSlug } = useParams();
  const [filter, setFilter] = useState('');
  
  const { data: apps, isLoading, error } = useApps(tenantSlug);
  
  const filtered = apps?.filter(app =>
    app.name.toLowerCase().includes(filter.toLowerCase())
  );
  
  if (isLoading) return <Spinner />;
  if (error) return <ErrorBanner error={error} />;
  
  return (
    <div>
      <AppListFilter value={filter} onChange={setFilter} />
      <div className="grid gap-4">
        {filtered?.map(app => (
          <AppCard key={app.id} app={app} />
        ))}
      </div>
    </div>
  );
};
```

### Ejemplo 4: Presenter Component (props-only)

```typescript
// src/features/console/apps/list/AppCard.tsx
interface AppCardProps {
  app: AppResponse;
  onEdit?: (appId: string) => void;
  onDelete?: (appId: string) => void;
}

export const AppCard = ({ app, onEdit, onDelete }: AppCardProps) => {
  return (
    <Card>
      <CardHeader>
        <h2 className="text-lg font-bold">{app.name}</h2>
        <Badge variant={app.status === 'ACTIVE' ? 'success' : 'warning'}>
          {app.status}
        </Badge>
      </CardHeader>
      <CardFooter className="gap-2">
        <Button variant="outline" onClick={() => onEdit?.(app.id)}>
          Edit
        </Button>
        <Button variant="destructive" onClick={() => onDelete?.(app.id)}>
          Delete
        </Button>
      </CardFooter>
    </Card>
  );
};
```

---

## Anti-Patterns

### ❌ Deep Feature Nesting

```typescript
// MAL: Too deep
src/features/console/apps/create/components/form/inputs/RedirectUriField.tsx

// BIEN: Flatten where sensible
src/features/console/apps/create/RedirectUriField.tsx
src/features/console/apps/create/CreateAppDialog.tsx
```

### ❌ Mixed Container/Presenter Logic

```typescript
// MAL
const AppList = () => {
  const [apps, setApps] = useState([]);
  useEffect(() => { /* fetch */ }, []);  // ← Container logic
  
  return (
    <div>
      {apps.map(app => (          // ← Presenter rendering
        <h1>{app.name}</h1>
      ))}
    </div>
  );
};

// BIEN: Separate concerns
// Container (list/AppListPage.tsx)
const AppListPage = () => {
  const { data: apps } = useApps();
  return <AppListPresenter apps={apps} />;
};

// Presenter (list/AppListPresenter.tsx)
const AppListPresenter = ({ apps }) => (
  <div>
    {apps.map(app => <AppCard key={app.id} app={app} />)}
  </div>
);
```

### ❌ Global Zustand for Server State

```typescript
// MAL
const useUsers = create(() => ({
  users: [],
  isLoading: false,
  fetch: async () => { /* ... */ },
}));

// BIEN: Use TanStack Query
const { data: users, isLoading } = useQuery({
  queryKey: ['users'],
  queryFn: fetchUsers,
});
```

---

## Referencias

- [Frontend Architecture](./frontend-architecture.md) — Stack, principios, data flow
- [Auth Implementation](./frontend-auth-implementation.md) — Session recovery, token refresh
- [API Integration](./frontend-api-integration.md) — TanStack Query hooks, axios config

---

[← Índice](./README.md) | [< Anterior](./frontend-architecture.md) | [Siguiente >](./frontend-auth-implementation.md)
