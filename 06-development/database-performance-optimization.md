# Development: Database Performance & Optimization

**Fase:** 06-development | **Audiencia:** Backend developers, DBAs | **Estatus:** Completado | **Versión:** 1.0

---

## Tabla de Contenidos

1. [Query Optimization](#query-optimization)
2. [N+1 Query Problem](#n1-query-problem)
3. [Indexing Strategy](#indexing-strategy)
4. [Connection Pooling](#connection-pooling)

---

## Query Optimization

### Use Projections (Only Select Needed Columns)

```java
// ❌ BAD: Fetches entire entity even if only name needed
@Query("SELECT u FROM User u WHERE u.tenantId = :tenantId")
List<User> getUsersByTenant(@Param("tenantId") String tenantId);

// ✅ GOOD: Projection fetches only required columns
@Query("SELECT new com.keygo.user.UserSummary(u.id, u.name, u.email) " +
       "FROM User u WHERE u.tenantId = :tenantId")
List<UserSummary> getUsersByTenant(@Param("tenantId") String tenantId);
```

### Use Pagination for Large Result Sets

```java
// ❌ BAD: Fetches all 10,000 users
@Query("SELECT u FROM User u ORDER BY u.createdAt DESC")
List<User> getAllUsers();

// ✅ GOOD: Paginate, fetch 20 at a time
Page<User> getUsers(Pageable pageable);  // pageable = page=0&size=20
```

### Avoid SELECT * in Complex Queries

```java
// ❌ SLOW: Multiple joins on unindexed columns
@Query("""
  SELECT DISTINCT u.*, r.*, t.name
  FROM users u
  JOIN user_roles r ON u.id = r.user_id
  JOIN tenants t ON u.tenant_id = t.id
  WHERE u.created_at > :date
""")
List<Object[]> getRecentUsersWithRoles(@Param("date") LocalDateTime date);

// ✅ FAST: Indexed columns, specific selections
@Query("""
  SELECT new com.keygo.user.UserWithRoles(u.id, u.email, r.name)
  FROM User u
  LEFT JOIN FETCH u.roles r
  WHERE u.createdAt > :date
""")
List<UserWithRoles> getRecentUsersWithRoles(@Param("date") LocalDateTime date);
```

---

## N+1 Query Problem

### Detect N+1

```bash
# Enable SQL logging
logging.level.org.hibernate.SQL: DEBUG

# Look for patterns like:
# Query 1: SELECT * FROM users WHERE tenant_id = 'abc'
# Query 2-101: SELECT * FROM user_roles WHERE user_id = ?  (x100 for each user!)
```

### Solution 1: FETCH JOIN (Eager Load)

```java
// ❌ PROBLEM: 1 query for users + N queries for roles
@Query("SELECT u FROM User u WHERE u.tenantId = :tenantId")
List<User> getUsersByTenant(@Param("tenantId") String tenantId);

// ✅ SOLUTION: Fetch join loads roles in same query
@Query("""
  SELECT DISTINCT u FROM User u
  LEFT JOIN FETCH u.roles
  WHERE u.tenantId = :tenantId
""")
List<User> getUsersByTenant(@Param("tenantId") String tenantId);
```

### Solution 2: Lazy Load with Batch Fetch

```java
@Entity
public class User {
  @OneToMany
  @BatchSize(size = 20)  // Fetch roles in batches of 20
  private List<Role> roles;
}

// When accessing roles:
List<User> users = repo.findAll();
// First query: SELECT * FROM users
// Second query: SELECT * FROM roles WHERE user_id IN (id1, id2, ..., id20)
// Third query: SELECT * FROM roles WHERE user_id IN (id21, id22, ..., id40)
```

---

## Indexing Strategy

### Multi-Tenant Query Optimization

```sql
-- ✅ Always index tenant_id first for multi-tenant queries
CREATE INDEX idx_users_tenant_id ON users(tenant_id);

-- ✅ Composite index for common filter + tenant
CREATE INDEX idx_users_tenant_status ON users(tenant_id, status);

-- ✅ Composite index for search queries
CREATE INDEX idx_users_tenant_email ON users(tenant_id, email);
```

### Date Range Indexes

```sql
-- For queries like "find users created in last 30 days"
CREATE INDEX idx_users_created_at ON users(created_at DESC);

-- Composite with tenant
CREATE INDEX idx_audit_logs_tenant_created ON audit_logs(tenant_id, created_at DESC);
```

### Check Index Usage

```sql
-- See which queries use which indexes
SELECT * FROM pg_stat_statements 
WHERE query LIKE '%users%'
ORDER BY calls DESC;

-- Unused indexes (candidates for removal)
SELECT * FROM pg_stat_user_indexes 
WHERE idx_scan = 0;
```

---

## Connection Pooling

### HikariCP Configuration

```yaml
spring:
  datasource:
    hikari:
      maximum-pool-size: 20        # Max connections
      minimum-idle: 5              # Min always-open
      connection-timeout: 30000    # 30 sec to get connection
      idle-timeout: 600000         # 10 min before closing idle
      max-lifetime: 1800000        # 30 min max connection age
      auto-commit: true
      
      # Connection test
      connection-test-query: "SELECT 1"
```

### Monitor Pool Usage

```java
@Component
public class PoolMonitor {
  
  @Scheduled(fixedRate = 60000)  // Every 60 sec
  public void logPoolMetrics() {
    HikariDataSource hikari = (HikariDataSource) dataSource;
    
    logger.info("Pool: active={} idle={} waiting={} size={}",
        hikari.getHikariPoolMXBean().getActiveConnections(),
        hikari.getHikariPoolMXBean().getIdleConnections(),
        hikari.getHikariPoolMXBean().getThreadsAwaitingConnection(),
        hikari.getMaximumPoolSize()
    );
    
    if (hikari.getHikariPoolMXBean().getActiveConnections() > 15) {
      logger.warn("Pool usage HIGH! Check for slow queries or connection leaks.");
    }
  }
}
```

---

## Véase También

- **observability.md** — Query metrics and tracing
- **validation-strategy.md** — Input validation prevents bad queries
- **debugging-guide.md** — Query debugging techniques

---

**Última actualización:** 2025-Q1 | **Mantenedor:** Backend/DBA | **Licencia:** Keygo Docs
