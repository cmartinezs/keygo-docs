[← Índice](../README.md) | [< Anterior](rnf03-privacidad-datos.md) | [Siguiente >](rnf05-rendimiento.md)

---

# RNF04 — Disponibilidad y resiliencia

**Descripción**
El sistema debe operar con alta disponibilidad y recuperarse ante fallos parciales sin interrumpir el servicio a los usuarios y aplicaciones cliente, dado que una interrupción del servicio de autenticación bloquea el acceso a todas las aplicaciones que dependen de él.

**Alcance incluye**
- Operación continua del servicio de autenticación como función crítica de la plataforma.
- Capacidad de recuperación automática ante fallos de componentes no críticos sin interrupción del flujo de autenticación.
- Mantenimiento de la disponibilidad del servicio durante operaciones de actualización o mantenimiento planificado.
- Degradación controlada: ante fallos parciales, las funciones críticas (autenticación, verificación de credenciales) se mantienen aunque otras funciones estén limitadas.
- Disponibilidad del punto de verificación pública de credenciales como función de alta prioridad.

**No incluye (MVP)**
- SLA formal con garantía contractual de disponibilidad en el MVP.
- Redundancia geográfica activa-activa en el MVP inicial.

**Dependencias**
- RNF05 (Rendimiento).
- RNF08 (Observabilidad).

**Criterios de aceptación**
1. El flujo de autenticación de usuarios está disponible como función de máxima prioridad del sistema.
2. Un fallo en el subsistema de facturación o auditoría no interrumpe el flujo de autenticación.
3. Las operaciones de mantenimiento planificado pueden ejecutarse con interrupción mínima o nula del servicio de autenticación.
4. El sistema detecta y reporta su propio estado de salud para facilitar la respuesta ante incidentes.
5. Ante una degradación parcial, el sistema informa de su estado de forma observable.

**Riesgos y mitigaciones**
- Fallo en cascada que afecte la autenticación → diseño con separación de componentes; los fallos en subsistemas no críticos se contienen sin propagarse al núcleo de autenticación.
- Ausencia de señales de fallo → el sistema genera indicadores de salud continuos y alertas ante degradación (RNF08).

---

[← Índice](../README.md) | [< Anterior](rnf03-privacidad-datos.md) | [Siguiente >](rnf05-rendimiento.md)
