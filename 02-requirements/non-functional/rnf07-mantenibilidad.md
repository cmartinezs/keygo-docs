[← Índice](../README.md) | [< Anterior](rnf06-escalabilidad.md) | [Siguiente >](rnf08-observabilidad.md)

---

# RNF07 — Mantenibilidad

**Descripción**
El sistema debe estar diseñado de forma que su mantenimiento, evolución y corrección de defectos sean viables sin riesgo de introducir regresiones o bloquear el desarrollo futuro del producto.

**Alcance incluye**
- Separación clara de responsabilidades entre los dominios funcionales del sistema.
- Capacidad de modificar o extender un dominio funcional sin impactar los demás.
- Cobertura de pruebas automatizadas sobre las funciones críticas de autenticación y autorización.
- Documentación mínima de las decisiones de diseño relevantes para el mantenimiento futuro.
- Capacidad de actualizar componentes del sistema de forma independiente.

**No incluye (MVP)**
- Cobertura de pruebas al 100% en el MVP inicial.
- Herramientas automáticas de análisis de deuda técnica en el MVP.

**Dependencias**
- RNF08 (Observabilidad).

**Criterios de aceptación**
1. Cada dominio funcional puede modificarse y desplegarse de forma independiente sin requerir cambios coordinados en todos los demás.
2. Los flujos críticos de autenticación, verificación y emisión de credenciales tienen cobertura de pruebas automatizadas.
3. Las decisiones de diseño con impacto en la evolución del sistema están documentadas.
4. Un nuevo miembro del equipo técnico puede entender la estructura general del sistema y hacer su primera contribución en un tiempo razonable.

**Riesgos y mitigaciones**
- Acoplamiento fuerte entre dominios que bloquee la evolución → las interfaces entre dominios se definen explícitamente; los cambios internos no se propagan al exterior.
- Deuda técnica acumulada que ralentice el desarrollo → las decisiones de diseño que generen deuda conocida se documentan con su justificación y plan de resolución.

---

[← Índice](../README.md) | [< Anterior](rnf06-escalabilidad.md) | [Siguiente >](rnf08-observabilidad.md)
