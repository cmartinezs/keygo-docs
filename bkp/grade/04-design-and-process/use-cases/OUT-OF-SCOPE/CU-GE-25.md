# CU-GE-25 — Gestionar credenciales de integración

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-16 | Integración con sistemas externos (básica)

### RF relacionados: RF12

**Actor principal:** Administrador técnico / Integrador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que un Administrador técnico genere, administre y revoque credenciales seguras (API Key / Token OAuth2) para habilitar la comunicación entre GRADE y sistemas externos.

### Precondiciones
- Usuario autenticado con rol de Administrador técnico.
- Módulo de integración habilitado en el sistema.

### Postcondiciones
- La credencial queda registrada, con fecha de creación y expiración.
- Toda acción de gestión de credenciales queda registrada en auditoría.

### Flujo principal (éxito)
1. El Administrador accede al módulo de Integraciones.
2. Selecciona la opción **“Generar credencial”**.
3. El Sistema solicita parámetros (tipo: API Key o OAuth2, fecha de expiración, permisos asociados).
4. El Administrador confirma la acción.
5. El Sistema genera la credencial y la muestra una sola vez al Administrador.
6. El Sistema registra la acción en auditoría.

### Flujos alternativos / Excepciones
- **A1 — Permisos inválidos:** El Sistema bloquea la acción.
- **A2 — Límite de credenciales por usuario alcanzado:** El Sistema informa y rechaza la operación.
- **A3 — Revocación de credencial:** El Administrador selecciona credencial existente y el Sistema la invalida.

### Reglas de negocio
- **RN-1:** Cada credencial debe estar asociada a un usuario/rol técnico.
- **RN-2:** Las credenciales deben tener fecha de expiración definida.
- **RN-3:** Ninguna credencial puede mostrarse nuevamente tras su creación (solo al momento inicial).

### Datos principales
- **Credencial**(ID, tipo, permisos, fecha creación, expiración, estado).
- **Auditoría**(acción, usuario, fecha/hora, credencial afectada).

### Consideraciones de seguridad/permiso
- Acceso exclusivo a Administradores técnicos.
- Almacenamiento seguro de credenciales (cifrado).

### No funcionales
- **Seguridad:** cumplimiento de estándares OAuth2 / API Key seguras.
- **Disponibilidad:** credenciales activas deben ser válidas en todo momento hasta expiración o revocación.

### Criterios de aceptación (QA)
- **CA-1:** El administrador puede generar y revocar credenciales.
- **CA-2:** El sistema solo muestra la credencial una vez.
- **CA-3:** Toda acción queda registrada en auditoría.  