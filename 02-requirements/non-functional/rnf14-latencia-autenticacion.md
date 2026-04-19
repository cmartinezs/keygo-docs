[← Índice](../README.md) | [< Anterior](rnf13-consistencia-credenciales-sesion.md)

---

# RNF14 — Latencia de autenticación

**Descripción**
El sistema debe definir y cumplir objetivos de latencia específicos para los flujos de autenticación, de forma que el tiempo de respuesta sea predecible y aceptable para los usuarios y las aplicaciones cliente.

**Alcance incluye**
- Definición de objetivos de latencia para el flujo de autenticación completo bajo condiciones normales de carga.
- Definición de objetivos de latencia para la verificación de credenciales de sesión.
- Medición de los tiempos de respuesta reales antes del lanzamiento del MVP como línea base.
- Diferenciación entre latencia en el percentil representativo (P95) y latencia máxima aceptable.
- Los objetivos de latencia se aplican a los flujos de alta frecuencia; los flujos administrativos tienen requisitos más laxos.

**No incluye (MVP)**
- Compromisos contractuales de SLA de latencia en el MVP.
- Optimización de latencia para condiciones de carga extrema en el MVP inicial.

**Dependencias**
- RNF05 (Rendimiento).
- RNF04 (Disponibilidad y resiliencia).

**Criterios de aceptación**
1. Los objetivos de latencia para el flujo de autenticación y para la verificación de credenciales están definidos y documentados antes del lanzamiento del MVP.
2. Los tiempos de respuesta reales se miden en un entorno representativo antes del lanzamiento.
3. El sistema cumple los objetivos de latencia definidos bajo la carga esperada del MVP.
4. Los tiempos de respuesta del percentil P95 están dentro del objetivo; los valores extremos ocasionales no superan el límite máximo definido.
5. Cuando el sistema se aproxima o supera los objetivos de latencia, se generan señales observables para el equipo técnico.

**Riesgos y mitigaciones**
- Objetivos de latencia no medidos hasta producción → los objetivos se validan en un entorno de prueba representativo antes del lanzamiento.
- Degradación de latencia que no se detecta hasta impactar usuarios → los indicadores de latencia forman parte del conjunto de métricas operativas monitorizadas continuamente (RNF08).

---

[← Índice](../README.md) | [< Anterior](rnf13-consistencia-credenciales-sesion.md)
