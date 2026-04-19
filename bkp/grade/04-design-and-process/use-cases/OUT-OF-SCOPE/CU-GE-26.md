# CU-GE-26 — Consumir API externa de GRADE

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-16 | Integración con sistemas externos (básica)

### RF relacionados: RF12

**Actor principal:** Sistema externo (SIGA, LMS, BI)  
**Actores secundarios:** Administrador técnico, Sistema GRADE

---

### Objetivo
Permitir que un sistema externo consuma las APIs de GRADE (crear evaluaciones, enviar respuestas, consultar resultados) de forma segura y auditada.

### Precondiciones
- Credenciales válidas generadas previamente (CU-GE-25).
- API documentada y publicada por GRADE.
- Sistema externo autenticado correctamente.

### Postcondiciones
- La operación solicitada por el sistema externo se ejecuta y queda registrada en auditoría.
- Los datos intercambiados quedan disponibles según lo solicitado (ej. ID evaluación, resultados en JSON).

### Flujo principal (éxito)
1. El Sistema externo realiza llamada a la API de GRADE (ej. crear evaluación).
2. El Sistema GRADE valida credenciales.
3. El Sistema procesa la solicitud según permisos asociados.
4. El Sistema responde con confirmación o datos solicitados.
5. El Sistema registra la operación en auditoría.

### Flujos alternativos / Excepciones
- **A1 — Credenciales inválidas/expiradas:** El Sistema rechaza la solicitud con error 401/403.
- **A2 — Permisos insuficientes:** El Sistema rechaza la solicitud con error 403.
- **A3 — Datos inválidos:** El Sistema responde con error 400 y detalle de inconsistencias.
- **A4 — Error interno:** El Sistema responde con error 500 y registra el evento.

### Reglas de negocio
- **RN-1:** Toda operación externa debe estar autenticada y autorizada.
- **RN-2:** Solo APIs documentadas estarán disponibles para integración.
- **RN-3:** Todas las operaciones deben quedar registradas en auditoría.

### Datos principales
- **Solicitud API**(endpoint, parámetros, usuario/credencial, fecha/hora).
- **Respuesta API**(código, payload, fecha/hora).
- **Auditoría**(acción, credencial, resultado).

### Consideraciones de seguridad/permiso
- Autenticación obligatoria con API Key u OAuth2.
- Validación estricta de entrada/salida.
- Protección contra abusos (rate limiting, throttling).

### No funcionales
- **Disponibilidad:** APIs deben estar disponibles al menos 99.5% del tiempo.
- **Rendimiento:** latencia promedio < 1s p95 para llamadas estándar.
- **Escalabilidad:** soporte a múltiples integraciones concurrentes.

### Criterios de aceptación (QA)
- **CA-1:** Un sistema externo puede autenticarse y consumir APIs válidas.
- **CA-2:** GRADE rechaza solicitudes con credenciales inválidas o sin permisos.
- **CA-3:** Todas las operaciones quedan registradas en auditoría.
- **CA-4:** Las respuestas cumplen con el formato documentado (ej. JSON).  