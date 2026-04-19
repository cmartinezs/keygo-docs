# Apreciación CU-GE-25 — Gestionar credenciales de integración

- [Volver](../../README.md#2-gestión-de-evaluación)

### Qué cubre
- Generación, administración y revocación de credenciales seguras (API Key / OAuth2).
- Definición de permisos y fechas de expiración para cada credencial.
- Registro de todas las acciones en auditoría con trazabilidad completa.

### Escenario lo justifica
- En S-GE-16, Maxi como Administrador técnico necesita habilitar la integración de GRADE con otros sistemas académicos.
- La gestión de credenciales es el punto de partida para garantizar seguridad en la interoperabilidad.

### ¿Es suficiente como CU separado?
✅ Sí. La gestión de credenciales es un proceso administrativo específico, diferente del consumo de APIs, y requiere reglas de seguridad propias.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Evolutivos posibles: rotación automática de credenciales, integración con gestores de identidades (SSO, LDAP), métricas de uso por credencial.

### Apreciación final
El CU-GE-25 está correctamente definido y suficiente para cubrir la **gestión de credenciales de integración** en S-GE-16.

---

# Apreciación CU-GE-26 — Consumir API externa de GRADE

### Qué cubre
- Consumo seguro de las APIs de GRADE por parte de sistemas externos.
- Validación de credenciales y permisos asociados.
- Registro de todas las operaciones en auditoría.
- Manejo de errores estandarizado (401, 403, 400, 500).

### Escenario lo justifica
- En S-GE-16, Maxi necesita que otros sistemas académicos creen evaluaciones, envíen respuestas o consulten resultados vía API.
- El sistema asegura interoperabilidad y reducción de duplicidad de datos entre plataformas.

### ¿Es suficiente como CU separado?
✅ Sí. El consumo de API es un proceso operativo independiente de la gestión de credenciales, con flujos propios y responsabilidad técnica en los integradores.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Evolutivos posibles: suscripción a eventos vía **webhooks**, APIs de analítica avanzada, integraciones preconfiguradas con LMS o BI.

### Apreciación final
El CU-GE-26 está correctamente definido y suficiente para cubrir el **consumo seguro de APIs externas** en S-GE-16.  
