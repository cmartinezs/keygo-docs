[← Índice](../README.md) | [< Anterior](rnf04-disponibilidad-resiliencia.md) | [Siguiente >](rnf06-escalabilidad.md)

---

# RNF05 — Rendimiento

**Descripción**
El sistema debe responder a las operaciones críticas de autenticación y verificación de credenciales dentro de tiempos de respuesta que no degraden la experiencia de los usuarios ni el rendimiento de las aplicaciones cliente.

**Alcance incluye**
- Respuesta de las operaciones de autenticación dentro de un tiempo máximo aceptable en condiciones normales de carga.
- Respuesta de la verificación de credenciales de sesión dentro de tiempos compatibles con su uso en cada solicitud de las aplicaciones cliente.
- Disponibilidad del punto de verificación pública de credenciales con latencia baja, dado su uso frecuente.
- Optimización de los flujos críticos frente a los de administración, que tienen menor frecuencia de uso.

**No incluye (MVP)**
- SLA de latencia con compromisos contractuales en el MVP.
- Optimización de rendimiento para volúmenes de escala enterprise en el MVP inicial.

**Dependencias**
- RNF04 (Disponibilidad y resiliencia).
- RNF06 (Escalabilidad).

**Criterios de aceptación**
1. El flujo de autenticación completo responde en un tiempo máximo definido bajo carga normal.
2. La verificación de credenciales de sesión responde en un tiempo compatible con su uso como control en cada solicitud de aplicación.
3. El rendimiento no se degrada significativamente al aumentar el número de organizaciones o usuarios dentro de los límites del MVP.
4. Los tiempos de respuesta de las operaciones administrativas son secundarios respecto a los de autenticación y verificación.
5. Los valores de referencia de rendimiento se miden y documentan antes del lanzamiento del MVP como línea base.

**Riesgos y mitigaciones**
- Latencia elevada en autenticación que genere fricción → las operaciones del flujo crítico se optimizan de forma preferente; las de administración no compiten por los mismos recursos.
- Degradación ante carga creciente → el diseño debe permitir escalar horizontalmente los componentes críticos (RNF06) sin cambios arquitectónicos.

---

[← Índice](../README.md) | [< Anterior](rnf04-disponibilidad-resiliencia.md) | [Siguiente >](rnf06-escalabilidad.md)
