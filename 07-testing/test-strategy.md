[← Índice](./README.md) | [Siguiente >](./unit-tests.md)

---

# Test Strategy

Estrategia de calidad de Keygo: pirámide de testing, tipos de prueba y distribución de cobertura. Aplica a backend (Java) y frontend (TypeScript).

## Contenido

- [Filosofía](#filosofía)
- [Pirámide de Testing](#pirámide-de-testing)
- [Tipos de Prueba](#tipos-de-prueba)
- [Distribución de Cobertura](#distribución-de-cobertura)
- [Comandos Principales](#comandos-principales)
- [Checklist: Nuevo Test](#checklist-nuevo-test)

---

## Filosofía

La calidad es responsabilidad del equipo, no del QA al final. Cada cambio se entrega con los tests que lo validan.

Tres principios no negociables:

1. **Unit tests agnósticos al framework** — sin Spring en backend; sin renderizado real en frontend
2. **Integration tests con infraestructura real** — Testcontainers en backend; componentes reales con React Testing Library en frontend
3. **Un bug corregido = un test de regresión** que previene su reaparición

[↑ Volver al inicio](#test-strategy)

---

## Pirámide de Testing

```
         ┌──────────┐
         │   UAT    │  ← Validación con usuario / negocio
         └────┬─────┘
         ┌────┴──────┐
         │  Smoke    │  ← Post-deploy: sistema vivo
         └────┬──────┘
      ┌───────┴────────┐
      │  Integration   │  ← BD real / componentes reales
      └───────┬────────┘
   ┌──────────┴──────────┐
   │     Unit Tests      │  ← Dominio puro / lógica UI aislada
   └─────────────────────┘
```

**Distribución recomendada:**

| Nivel | Proporción | Velocidad |
|-------|-----------|-----------|
| Unit | 60% | Milisegundos |
| Integration | 30% | Segundos |
| Smoke / UAT | 10% | Minutos |

[↑ Volver al inicio](#test-strategy)

---

## Tipos de Prueba

| Tipo | Doc | Backend | Frontend |
|------|-----|---------|----------|
| [Unit Tests](./unit-tests.md) | Lógica aislada sin framework | JUnit 5 + Mockito + AssertJ | Vitest + Testing Library |
| [Unit Test Coverage](./unit-test-coverage.md) | Umbrales y herramientas | JaCoCo (≥75%) | Vitest coverage (≥80%) |
| [Integration Tests](./integration-tests.md) | Flujos completos con infraestructura | Testcontainers + MockMvc | Component tests + MSW |
| [Regression Tests](./regression-tests.md) | Prevención de regresiones | JUnit 5 | Vitest |
| [Smoke Tests](./smoke-tests.md) | Sistema vivo post-deploy | curl / scripts | curl / scripts |
| [UAT](./uat.md) | Validación de negocio | Manual + scripts | Manual + scripts |
| [Security Testing](./security-testing.md) | OWASP, compliance | SAST + revisión | SAST + revisión |

### Testing de Domain Events

Los eventos de dominio son hechos que sucedieron y deben registrarse. Cada agregado que emite un evento debe testear:

1. **Que el evento se emite con los datos correctos**:
   ```java
   @Test
   void registerIdentity_emitsIdentityCreatedEvent() {
     // Given / When
     Identity identity = identityFactory.createNewIdentity(email, password, role);
     
     // Then
     assertThat(identity.getDomainEvents())
         .hasSize(1)
         .first()
         .isInstanceOf(IdentityCreatedEvent.class)
         .extracting("email", "createdAt")
         .containsExactly(email, now);
   }
   ```

2. **Que los handlers de eventos reaccionan correctamente** (en integration tests):
   ```java
   @Test
   void onIdentityCreatedEvent_createsAuditLog() {
     // Given
     IdentityCreatedEvent event = new IdentityCreatedEvent(...);
     
     // When
     auditEventHandler.handle(event);
     
     // Then
     AuditLog log = auditRepository.findByEventId(event.id());
     assertThat(log).isNotNull().extracting("action").isEqualTo("IDENTITY_CREATED");
   }
   ```

3. **Que eventos cross-context se traducen correctamente**:
   ```java
   @Test
   void identityCreatedEvent_publishesToAuditContext() {
     // Given
     Identity identity = identityFactory.createNewIdentity(...);
     
     // When
     eventPublisher.publish(identity.getDomainEvents());
     
     // Then (en Audit Context)
     AuditLog auditLog = auditRepository.findLatest();
     assertThat(auditLog.getEventType()).isEqualTo("IDENTITY_CREATED");
   }
   ```

[↑ Volver al inicio](#test-strategy)

---

## Distribución de Cobertura

### Principio: Testing de Agregados

En un sistema con Bounded Contexts y agregados (DDD), el testing debe enfocarse en:

1. **Value Objects**: Máxima cobertura (95%+) — son las "reglas vivas" del dominio
2. **Agregados (entidades raíz)**: Cobertura muy alta (90%+) — contienen las invariantes
3. **Domain Services**: Cobertura alta (85%+) — lógica que no cabe en agregado
4. **Use Cases**: Cobertura media-alta (80%+) — orquestación
5. **Controllers / Adapters**: Cobertura media (70%+) — frontera técnica

### Backend (Java)

| Capa | Mínimo | Objetivo | Por qué |
|------|--------|----------|--------|
| **Value Objects** (EmailAddress, Permission, Money) | 95% | 100% | Son reglas; cada rama es un caso de negocio |
| **Agregados** (Identity, Role, Organization) | 90% | 95% | Contienen invariantes; deben probarse exhaustivamente |
| **Domain Services** (PasswordValidator, RoleEvaluator) | 85% | 95% | Lógica de negocio pura |
| **Use Cases** | 80% | 90% | Orquestación de dominio; menos críticos que agregados |
| **Controllers** | 70% | 80% | Traducción HTTP → comando; menos dominio |
| **Adapters / Repositorios** | 70% | 80% | Traducción persistencia ↔ dominio |
| **Overall** | 75% | 85% | Equilibrio entre cobertura y velocidad |

### Frontend (TypeScript)

| Capa | Mínimo | Objetivo | Por qué |
|------|--------|----------|--------|
| **Lógica de negocio / hooks** | 80% | 90% | Hooks que orquestan acciones del usuario |
| **Componentes UI** | 70% | 85% | Renders; menos crítico que lógica |
| **Overall** | 80% | 85% | - |

### Por Bounded Context

Ver [test-plans.md](./test-plans.md) para metas específicas por contexto (Identity, Access Control, etc.).

Ver detalle en [Unit Test Coverage](./unit-test-coverage.md).

[↑ Volver al inicio](#test-strategy)

---

## Comandos Principales

### Backend

```bash
# Unit tests
./mvnw test

# Unit tests + cobertura
./mvnw clean verify jacoco:report

# Integration tests
./mvnw verify

# Por módulo
./mvnw -pl keygo-domain test
./mvnw -pl keygo-supabase verify
```

### Frontend

```bash
# Unit tests
npm run test

# Unit tests con cobertura
npm run test -- --coverage

# Watch mode (desarrollo)
npm run test -- --watch
```

### General

```bash
# Smoke tests
./scripts/test-smoke.sh http://localhost:8080
```

[↑ Volver al inicio](#test-strategy)

---

## Checklist: Nuevo Test

Antes de hacer commit con un test nuevo:

- [ ] ¿Verifica comportamiento, no implementación interna?
- [ ] ¿Es determinístico? (sin timing, sin random, sin datos compartidos mutables)
- [ ] ¿Está aislado? (backend: sin Spring en unit; frontend: sin renderizado de página completa en unit)
- [ ] ¿El nombre describe qué y bajo qué condición?
- [ ] ¿Sigue estructura Given / When / Then (o Arrange / Act / Assert)?
- [ ] ¿La cobertura general subió o se mantuvo?

[↑ Volver al inicio](#test-strategy)

---

[← Índice](./README.md) | [Siguiente >](./unit-tests.md)
