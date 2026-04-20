# Design: Component Patterns & Frontend Conventions

**Fase:** 06-development | **Audiencia:** Frontend developers | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Component Hierarchy](#component-hierarchy)
2. [Presentational vs Container](#presentational-vs-container)
3. [Compound Components](#compound-components)
4. [Hooks Patterns](#hooks-patterns)

---

## Component Hierarchy

### Layer Structure

```
App (Routing)
├── AuthLayout (wrapper for /login, /register)
│   ├── LoginPage (container)
│   │   └── LoginForm (presentational)
│   │       ├── EmailInput (atom)
│   │       ├── PasswordInput (atom)
│   │       └── SubmitButton (atom)
│   
├── DashboardLayout (wrapper for authenticated pages)
│   ├── Sidebar (navigational)
│   ├── Header (informational)
│   ├── MainContent
│   │   ├── UsersPage (container)
│   │   │   ├── UsersTable (presentational)
│   │   │   │   └── UserRow (atom)
│   │   │   └── UserModal (presentational)
```

### Naming Convention

| Layer | Naming | Example | Location |
|-------|--------|---------|----------|
| **Page** | `<Page>Page` | `UsersPage.tsx` | `app/features/users/pages/` |
| **Container** | `<Feature>Container` | `UserFormContainer.tsx` | `app/features/users/containers/` |
| **Presentational** | `<Component>` | `UserForm.tsx` | `app/features/users/components/` |
| **Atom** | `<Element>` | `TextField.tsx` | `app/shared/components/atoms/` |
| **Composition** | `<Compound>.*` | `Modal.Header`, `Modal.Body` | `app/shared/components/compound/` |

---

## Presentational vs Container

### Pattern

**Container Component:** Handles logic, data fetching, state management
**Presentational Component:** Receives props, renders UI, emits events

### Example

```typescript
// ❌ ANTI-PATTERN: Logic mixed in presentational
function UserList() {
  const [users, setUsers] = useState([]);
  
  useEffect(() => {
    fetch('/api/users').then(r => r.json()).then(setUsers);
  }, []);
  
  return (
    <table>
      {users.map(u => <tr key={u.id}><td>{u.name}</td></tr>)}
    </table>
  );
}

// ✅ GOOD: Separated concerns

// Container (handles logic)
function UserListContainer() {
  const { data: users, isLoading, error } = useQuery(
    ['users'],
    () => fetch('/api/users').then(r => r.json())
  );
  
  if (isLoading) return <Loading />;
  if (error) return <Error error={error} />;
  
  return <UserList users={users} />;
}

// Presentational (receives props, renders)
interface UserListProps {
  users: User[];
}

function UserList({ users }: UserListProps) {
  return (
    <table>
      <tbody>
        {users.map(u => (
          <tr key={u.id}>
            <td>{u.name}</td>
            <td>{u.email}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}
```

---

## Compound Components

For related UI elements that share state (Tabs, Modals, Forms):

```typescript
// ❌ ANTI-PATTERN: Props drilling
<Modal 
  title="Invite User"
  isOpen={isOpen}
  onClose={onClose}
  body={<UserInviteForm />}
  footer={<button onClick={onSave}>Save</button>}
/>

// ✅ GOOD: Compound components
<Modal isOpen={isOpen} onClose={onClose}>
  <Modal.Header>Invite User</Modal.Header>
  <Modal.Body>
    <UserInviteForm />
  </Modal.Body>
  <Modal.Footer>
    <button onClick={onSave}>Save</button>
  </Modal.Footer>
</Modal>
```

### Implementation

```typescript
interface ModalContextType {
  isOpen: boolean;
  onClose: () => void;
}

const ModalContext = createContext<ModalContextType | null>(null);

export function Modal({ 
  isOpen, 
  onClose, 
  children 
}: { 
  isOpen: boolean; 
  onClose: () => void; 
  children: ReactNode;
}) {
  return (
    <ModalContext.Provider value={{ isOpen, onClose }}>
      {isOpen && <div className="modal-backdrop">{children}</div>}
    </ModalContext.Provider>
  );
}

Modal.Header = function Header({ children }: { children: ReactNode }) {
  const { onClose } = useContext(ModalContext)!;
  return (
    <div className="modal-header">
      {children}
      <button onClick={onClose}>✕</button>
    </div>
  );
};

Modal.Body = function Body({ children }: { children: ReactNode }) {
  return <div className="modal-body">{children}</div>;
};

Modal.Footer = function Footer({ children }: { children: ReactNode }) {
  return <div className="modal-footer">{children}</div>;
};
```

---

## Hooks Patterns

### Custom Hooks for Logic Reuse

```typescript
// ❌ ANTI-PATTERN: Duplicated logic in multiple components
function UsersList() {
  const [users, setUsers] = useState([]);
  useEffect(() => {
    fetch('/api/users').then(r => r.json()).then(setUsers);
  }, []);
  return <div>{users.length} users</div>;
}

function TenantsAdmin() {
  const [users, setUsers] = useState([]);
  useEffect(() => {
    fetch('/api/users').then(r => r.json()).then(setUsers);
  }, []);
  return <table>{...}</table>;
}

// ✅ GOOD: Extract to custom hook
function useUsers() {
  const { data: users = [] } = useQuery(
    ['users'],
    () => fetch('/api/users').then(r => r.json())
  );
  return users;
}

function UsersList() {
  const users = useUsers();
  return <div>{users.length} users</div>;
}

function TenantsAdmin() {
  const users = useUsers();
  return <table>{...}</table>;
}
```

### Context for Global State

```typescript
// Create context for authentication
const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  
  useEffect(() => {
    // Restore session on mount
    authService.getProfile()
      .then(setUser)
      .catch(() => setUser(null))
      .finally(() => setLoading(false));
  }, []);
  
  return (
    <AuthContext.Provider value={{ user, loading }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth must be within AuthProvider');
  return context;
}

// Usage
function Dashboard() {
  const { user } = useAuth();
  return <h1>Welcome, {user?.name}</h1>;
}
```

---

## Anti-Patterns

### 1. Props Drilling

```typescript
// ❌ BAD: Theme passed through 5 levels
<App theme={theme}>
  <Layout theme={theme}>
    <Sidebar theme={theme}>
      <Nav theme={theme}>
        <Link theme={theme} />
      </Nav>
    </Sidebar>
  </Layout>
</App>

// ✅ GOOD: Use context
const ThemeContext = createContext<Theme>(defaultTheme);

<ThemeProvider value={theme}>
  <App>
    <Layout>
      <Sidebar>
        <Nav>
          <Link />  {/* useContext(ThemeContext) */}
        </Nav>
      </Sidebar>
    </Layout>
  </App>
</ThemeProvider>
```

### 2. State Management in Wrong Layer

```typescript
// ❌ BAD: Component state for shared data
function UserForm() {
  const [user, setUser] = useState(initialUser);
  return <form>{...}</form>;
}

// Later in different component:
function UserProfile() {
  const [user, setUser] = useState(initialUser);  // Duplicated!
  return <div>{...}</div>;
}

// ✅ GOOD: Use query or global state
function UserForm() {
  const { data: user, mutate } = useSWR('/api/user', fetch);
  return <form>{...}</form>;
}

function UserProfile() {
  const { data: user } = useSWR('/api/user', fetch);  // Same cache
  return <div>{...}</div>;
}
```

### 3. Render Functions vs Components

```typescript
// ❌ BAD: Render function loses identity (re-renders every time)
<UserTable renderRow={(user) => <tr><td>{user.name}</td></tr>} />

// ✅ GOOD: Dedicated component preserves identity
function UserRow({ user }: { user: User }) {
  return <tr><td>{user.name}</td></tr>;
}

<UserTable rows={users.map(u => <UserRow key={u.id} user={u} />)} />
```

---

## Véase También

- **frontend-architecture.md** — Stack and overall structure
- **frontend-project-structure.md** — File organization
- **frontend-auth-implementation.md** — Auth component patterns

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Frontend | **Licencia:** Keygo Docs
