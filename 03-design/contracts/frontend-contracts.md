[← Índice](./README.md)

---

# Frontend Contracts

Convenciones y guías para el desarrollo del frontend de KeyGo (migrado desde bkp).

## Contenido

- [Setup](#setup)
- [Authentication](#authentication)
- [API Conventions](#api-conventions)
- [Error Handling](#error-handling)
- [Endpoints](#endpoints)

---

## Setup

### Stack

| Capa | Herramienta |
|------|-------------|
| Bundler | Vite |
| UI | React |
| Lenguaje | TypeScript |
| Estado | Zustand |
| HTTP | Axios |

### Scripts

```bash
npm run dev      # Desarrollo
npm run build   # Producción
npm run lint   # Linting
npm run format # Formateo
npm run test   # Tests
```

### Variables de Entorno

```env
VITE_KEYGO_BASE=http://localhost:8080/keygo-server
VITE_TENANT_SLUG=keygo
VITE_CLIENT_ID=keygo-ui
VITE_REDIRECT_URI=http://localhost:5173/callback
```

 [↑ Volver al inicio](#frontend-contracts)

---

## Authentication

### OAuth2 Flow

```
1.Frontend → /oauth/authorize → Redirect a login
2.User → /account/login → Auth OK
3.Backend → /oauth/token → Access Token
4.Frontend → Almacena token en memoria (no localStorage)
5.Frontend → API calls con Bearer token
```

### Token Storage

**Regla:** Tokens solo en memoria, nunca en localStorage/cookies.

```tsx
// useAuth store (Zustand)
const useAuth = create<AuthState>((set) => ({
  token: null,
  setToken: (token) => set({ token }),
  clearToken: () => set({ token: null }),
}));
```

### Refresh Token

```tsx
// Automatic refresh en interceptor
axios.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401) {
      const newToken = await refreshToken();
      return axios(error.config);
    }
    return Promise.reject(error);
  }
);
```

 [↑ Volver al inicio](#frontend-contracts)

---

## API Conventions

### Request Headers

```tsx
const api = axios.create({
  baseURL: import.meta.env.VITE_KEYGO_BASE,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Interceptor para agregar token
api.interceptors.request.use((config) => {
  const token = useAuth.getState().token;
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});
```

### Response Handling

```tsx
// Tipado de respuesta
interface ApiResponse<T> {
  data: T;
  success?: { code: string; message: string };
  error?: { code: string; message: string };
  pagination?: {
    page: number;
    size: number;
    totalElements: number;
    totalPages: number;
  };
}
```

### URL Structure

| Recurso | Endpoint |
|---------|-----------|
| Platform | `/api/v1/platform/...` |
| Tenant | `/api/v1/tenants/{slug}/...` |
| Auth | `/api/v1/...` |

 [↑ Volver al inicio](#frontend-contracts)

---

## Error Handling

### Error Types

```tsx
type ErrorOrigin = 'CLIENT_REQUEST' | 'BUSINESS_RULE' | 'SERVER_PROCESSING';
type ClientRequestCause = 'USER_INPUT' | 'CLIENT_TECHNICAL';

interface ErrorData {
  code: string;
  origin: ErrorOrigin;
  clientRequestCause?: ClientRequestCause;
  clientMessage: string;
  detail?: string;
}
```

### User Feedback

```tsx
// Mapa de errores a UI
function getErrorMessage(error: ErrorData): string {
  if (error.origin === 'CLIENT_REQUEST') {
    if (error.clientRequestCause === 'USER_INPUT') {
      return error.clientMessage; // Mostrar junto al campo
    }
    return 'Algo salió mal. Por favor intenta de nuevo.';
  }
  if (error.origin === 'BUSINESS_RULE') {
    return error.clientMessage;
  }
  return 'Error Temporal. Intenta más tarde.';
}
```

### Validation Errors

```tsx
// Field errors
interface FieldError {
  field: string;
  message: string;
}

interface ValidationErrorResponse extends ErrorData {
  fieldErrors: FieldError[];
}
```

 [↑ Volver al inicio](#frontend-contracts)

---

## Endpoints

### Account

| Endpoint | Método | Descripción |
|----------|--------|-------------|
| `/account/login` | POST | Login |
| `/account/logout` | POST | Logout |
| `/account/check-email` | POST | Verificar email disponible |
| `/account/forgot-password` | POST | Recuperar contraseña |
| `/account/reset-password` | POST | Resetear contraseña |

### Tenant

| Endpoint | Método | Descripción |
|----------|--------|-------------|
| `/tenants/{slug}` | GET | Ver tenant |
| `/tenants/{slug}/users` | GET, POST | Usuarios |
| `/tenants/{slug}/users/{id}` | GET, PATCH, DELETE | Usuario específico |
| `/tenants/{slug}/roles` | GET | Roles |

### Billing

| Endpoint | Método | Descripción |
|----------|--------|-------------|
| `/tenants/{slug}/subscription` | GET | Suscripción |
| `/tenants/{slug}/subscription/plan` | POST | Cambiar plan |
| `/tenants/{slug}/invoices` | GET | Facturas |

### Admin

| Endpoint | Método | Descripción |
|----------|--------|-------------|
| `/platform/users` | GET | Usuarios plataforma |
| `/platform/stats` | GET | Estadísticas |

 [↑ Volver al inicio](#frontend-contracts)

---

[← Índice](./README.md)