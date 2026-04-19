[← Índice](../README.md) | [< Anterior](rnf12-gestion-ciclo-vida-claves.md) | [Siguiente >](rnf14-latencia-autenticacion.md)

---

# RNF13 — Consistencia de credenciales de sesión

**Descripción**
El sistema debe manejar la expiración, renovación y revocación de credenciales de sesión de forma consistente en todas las instancias, evitando situaciones en las que credenciales inválidas sean aceptadas o credenciales válidas sean rechazadas.

**Alcance incluye**
- Expiración de credenciales de acceso en el tiempo exacto declarado en la credencial, sin tolerancias implícitas.
- Manejo explícito de la diferencia de reloj entre componentes del sistema al evaluar la vigencia de una credencial.
- Consistencia del estado de revocación entre instancias: una credencial revocada es rechazada por todas las instancias dentro de una ventana de tiempo acotada.
- Unicidad de uso de las credenciales de renovación: una vez utilizadas, no pueden reutilizarse.
- Detección de reutilización de credenciales de renovación como señal de posible compromiso.

**No incluye (MVP)**
- Revocación instantánea en todas las instancias sin ninguna ventana de propagación; una ventana acotada y documentada es aceptable.

**Dependencias**
- RF11 (Emisión de credenciales de sesión).
- RF12 (Verificación de credenciales de sesión).
- RF14 (Gestión de sesiones).

**Criterios de aceptación**
1. Una credencial de acceso expirada es rechazada, incluyendo la tolerancia de reloj máxima definida en el sistema.
2. Una credencial de renovación reutilizada es rechazada y desencadena la revocación de la sesión asociada.
3. Una credencial revocada es rechazada por todas las instancias del sistema dentro de la ventana de propagación definida.
4. El comportamiento ante expiración y revocación es uniforme: el mismo par de credenciales produce el mismo resultado en cualquier instancia.
5. La ventana máxima de inconsistencia entre instancias para el estado de revocación está definida y documentada.

**Riesgos y mitigaciones**
- Credenciales de renovación robadas y reutilizadas → la detección de reutilización invalida la sesión completa; el usuario debe reautenticarse.
- Inconsistencia prolongada entre instancias → la ventana de propagación del estado de revocación está acotada y monitorizada; si se supera, se genera una alerta operativa.

---

[← Índice](../README.md) | [< Anterior](rnf12-gestion-ciclo-vida-claves.md) | [Siguiente >](rnf14-latencia-autenticacion.md)
