[← Índice](./README.md) | [< Anterior](./unit-tests.md) | [Siguiente >](./integration-tests.md)

---

# Unit Test Coverage

Metas de cobertura, configuración de herramientas y umbrales de calidad para backend y frontend.

## Contenido

- [Metas Backend](#metas-backend)
- [Metas Frontend](#metas-frontend)
- [Configuración JaCoCo](#configuración-jacoco)
- [Configuración Vitest](#configuración-vitest)
- [Comandos](#comandos)
- [Reglas de Calidad](#reglas-de-calidad)

---

## Metas Backend

| Capa | Mínimo | Objetivo |
|------|--------|----------|
| **Domain (VO, Entities, Services)** | 85% | 95% |
| **Use Cases** | 75% | 90% |
| **Adapters (Controllers, Repos)** | 70% | 85% |
| **Overall** | 75% | 85% |

La capa de dominio tiene el umbral más alto porque concentra las reglas de negocio críticas y es completamente testeable con unit tests puros sin infraestructura.

[↑ Volver al inicio](#unit-test-coverage)

---

## Metas Frontend

| Capa | Mínimo | Objetivo |
|------|--------|----------|
| **Lógica de negocio (hooks, utils)** | 80% | 90% |
| **Componentes UI** | 70% | 85% |
| **Overall** | 80% | 85% |

[↑ Volver al inicio](#unit-test-coverage)

---

## Configuración JaCoCo

```xml
<plugin>
  <groupId>org.jacoco</groupId>
  <artifactId>jacoco-maven-plugin</artifactId>
  <executions>
    <execution>
      <id>check</id>
      <goals><goal>check</goal></goals>
      <configuration>
        <excludes>
          <exclude>**/entity/**</exclude>
          <exclude>**/config/**</exclude>
          <exclude>**/dto/**</exclude>
        </excludes>
        <rules>
          <rule>
            <element>BUNDLE</element>
            <limits>
              <limit>
                <counter>LINE</counter>
                <value>COVEREDRATIO</value>
                <minimum>0.75</minimum>
              </limit>
            </limits>
          </rule>
        </rules>
      </configuration>
    </execution>
  </executions>
</plugin>
```

[↑ Volver al inicio](#unit-test-coverage)

---

## Configuración Vitest

```typescript
// vitest.config.ts
import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    coverage: {
      provider: 'v8',
      reporter: ['text', 'html', 'lcov'],
      thresholds: {
        lines: 80,
        functions: 80,
        branches: 75,
        statements: 80,
      },
      exclude: [
        '**/*.stories.*',
        '**/index.ts',
        'src/main.tsx',
      ],
    },
  },
});
```

[↑ Volver al inicio](#unit-test-coverage)

---

## Comandos

### Backend

```bash
# Ejecutar tests y generar reporte HTML
./mvnw clean verify jacoco:report
# → target/site/jacoco/index.html

# Solo verificar umbrales (falla si no se cumplen)
./mvnw jacoco:check

# Por módulo
./mvnw -pl keygo-domain clean verify jacoco:report
```

### Frontend

```bash
# Cobertura en consola
npm run test -- --coverage

# Reporte HTML
npm run test -- --coverage --reporter=html
# → coverage/index.html

# En CI (sin watch, falla si no cumple umbrales)
npm run test -- --coverage --run
```

[↑ Volver al inicio](#unit-test-coverage)

---

## Reglas de Calidad

- El build **falla en CI** si la cobertura cae por debajo del mínimo — tanto en backend como en frontend
- La cobertura se mide **solo en código de producción** — excluir entidades JPA, DTOs de infraestructura, stories de Storybook, archivos de configuración
- **No agregar tests vacíos** para inflar cobertura — cada test debe verificar comportamiento real
- Las exclusiones deben ser explícitas y justificadas en la configuración

[↑ Volver al inicio](#unit-test-coverage)

---

[← Índice](./README.md) | [< Anterior](./unit-tests.md) | [Siguiente >](./integration-tests.md)
