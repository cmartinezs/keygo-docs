[← HOME](../README.md)

---

# Testing

Fase de documentación de estrategias, tipos de prueba y criterios de calidad, con énfasis en testing de agregados, value objects y eventos de dominio en cada Bounded Context.

---

## Contenido

- [test-strategy.md](./test-strategy.md) — Estrategia general, pirámide, distribución, filosofía
- [test-plans.md](./test-plans.md) — Planes específicos por Bounded Context: Identity, Access Control, Organization, etc.
- [unit-tests.md](./unit-tests.md) — Unit tests agnósticos al framework
- [unit-test-coverage.md](./unit-test-coverage.md) — Metas de cobertura y configuración JaCoCo
- [integration-tests.md](./integration-tests.md) — Tests con BD real y MockMvc
- [regression-tests.md](./regression-tests.md) — Prevención de regresiones
- [smoke-tests.md](./smoke-tests.md) — Verificación post-deploy
- [uat.md](./uat.md) — User Acceptance Testing
- [security-testing.md](./security-testing.md) — OWASP, compliance, PII
- [security-testing-plan.md](./security-testing-plan.md) — Plan ejecutable OWASP Top 10, SOC2, GDPR, escaneo automatizado
- [accessibility-standards.md](./accessibility-standards.md) — WCAG 2.1 AA, navegación por teclado, screen readers, contraste de color

---

## Cómo Navegar

1. **Primero**: Lee [test-strategy.md](./test-strategy.md) para entender la pirámide de testing y la distribución
2. **Por contexto**: Consulta [test-plans.md](./test-plans.md) para ver qué se debe testear en cada Bounded Context
3. **Implementación**: Usa [unit-tests.md](./unit-tests.md) y [integration-tests.md](./integration-tests.md) como referencia
4. **Cobertura**: Revisa umbrales mínimos en [unit-test-coverage.md](./unit-test-coverage.md)
5. **Seguridad**: Aplica patrones de [security-testing.md](./security-testing.md)

---

[← HOME](../README.md) | [Siguiente >](./test-strategy.md)
