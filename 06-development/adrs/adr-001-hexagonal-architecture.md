[← Índice](./README.md) | [Siguiente >](./adr-002-multi-tenant-model.md)

---

# ADR-001: Arquitectura Hexagonal con Puertos y Adaptadores

## Estado

**Aceptado** | Fecha: 2026-04-10

## Contexto

KeyGo requiere una arquitectura que permita:
- Testabilidad del dominio sin dependencias de framework
- Intercambiar la implementación de persistencia
- Mantener el dominio limpio y enfocado en reglas de negocio
- Evolucionar la infraestructura sin impactar el dominio

## Decisión

Adoptar **Arquitectura Hexagonal (Ports & Adapters)** con la siguiente estructura:

```
keygo-domain     → Entidades, Value Objects, Excepciones (puro)
keygo-app        → Use Cases, Puertos OUT (interfaces)
keygo-api        → Controllers, DTOs (REST)
keygo-infra      → JWT, JWKS, adaptadores técnicos
keygo-supabase   → JPA, Repositories, Entity
keygo-run        → Spring Boot main, wiring
```

### Reglas de Dependencia

- `keygo-domain` no depende de ningún otro módulo
- Las dependencias van siempre hacia el dominio
- Los puertos (interfaces) viven en `keygo-app`
- Los adaptadores (implementaciones) viven en módulos de infraestructura

## Consecuencias

### Positivas

- ✅ Dominio testeable sin Spring ni BD
- ✅ Persistencia intercambiable (JPA → Document → etc)
- ✅ Use cases reutilizables en diferentes contextos (CLI, API, eventos)
- ✅ Equipos pueden trabajar en paralelo dominio/infraestructura
- ✅ Claridad en contratos mediante puertos

### Negativas

- ⚠️ Curva de aprendizaje inicial
- ⚠️ Más archivos/estructura que arquitectura monolítica
- ⚠️ Requiere disciplina para mantener reglas de dependencia

## Alternativas Consideradas

| Alternativa | Por qué fue descartada |
|-------------|----------------------|
| Arquitectura tradicional (layers) | Acoplamiento con Spring, testabilidad limitada |
| Domain-Driven Design puro | Necesitábamos estructura de módulos práctica |
| Microkernel / Plugin | Sobre-ingeniería para el tamaño actual |

## Referencias

- [Arquitectura Hexagonal](architecture.md)
- [Patrones](patterns.md)

[↑ Volver al inicio](#adr-001-arquitectura-hexagonal-con-puertos-y-adaptadores)

---

[← Índice](./README.md) | [Siguiente >](./adr-002-multi-tenant-model.md)
