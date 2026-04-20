[← Índice](./README.md) | [Siguiente >](./wireframes.md)

---

# Sistema de Diseño

## Contenido

- [Principios de diseño](#principios-de-diseño)
- [Dos contextos visuales](#dos-contextos-visuales)
- [Lenguaje de componentes](#lenguaje-de-componentes)
- [Patrones de interacción](#patrones-de-interacción)
- [Accesibilidad y consistencia](#accesibilidad-y-consistencia)
- [Comentarios de los Revisores](#comentarios-de-los-revisores)

---

## Principios de diseño

El sistema de diseño de Keygo parte de tres principios que deben mantenerse coherentes en toda la interfaz:

| Principio | Descripción |
|-----------|-------------|
| **Claridad sobre densidad** | El usuario debe entender en un vistazo qué puede hacer y qué efecto tendrá su acción. Keygo gestiona accesos y credenciales — la ambigüedad tiene consecuencias reales de seguridad. |
| **Confianza a través de la consistencia** | Los patrones de interacción deben ser predecibles. Si un botón destructivo requiere confirmación en un lugar, debe hacerlo en todos. |
| **Contexto visible** | El usuario siempre sabe en qué organización está, con qué rol opera y qué sección está viendo. No debe haber duda sobre el alcance de sus acciones. |

[↑ Volver al inicio](#sistema-de-diseño)

---

## Dos contextos visuales

Keygo tiene dos portales con propósitos distintos. Su diseño visual diferencia claramente en cuál está el usuario en cada momento.

### Consola de Organización

Orientada a gestión operativa diaria. El usuario administra usuarios de su organización, aplicaciones, roles y suscripción. El diseño prioriza listas, formularios y flujos de acción directa (alta, suspensión, asignación de rol).

- Identidad visual centrada en la organización activa (nombre y logo del tenant visible en todo momento).
- Secciones principales accesibles desde navegación lateral persistente.
- Acciones destructivas (suspender, eliminar) siempre requieren confirmación explícita.

### Consola de Plataforma

Orientada a visibilidad operativa y soporte. El usuario (`KEYGO_ADMIN`) observa el sistema globalmente y ejecuta acciones de soporte puntuales. El diseño prioriza tablas de estado, alertas y acciones que requieren trazabilidad.

- Identidad visual diferenciada para que ningún `KEYGO_ADMIN` confunda este portal con la consola de un tenant.
- Todas las acciones de soporte muestran explícitamente que quedarán registradas antes de ejecutarlas.

[↑ Volver al inicio](#sistema-de-diseño)

---

## Lenguaje de componentes

Los componentes se organizan por su función en la interfaz, no por su tipo técnico. A continuación, las categorías relevantes para el dominio de Keygo:

### Componentes de estructura

| Componente | Propósito |
|------------|-----------|
| Encabezado de página | Título de la sección, breadcrumb de navegación y acciones principales de la vista. |
| Navegación lateral | Acceso a las secciones principales del portal activo. Refleja el modelo de dominio: Usuarios, Aplicaciones, Roles, Facturación. |
| Barra de contexto | Muestra la organización activa y el rol del usuario. Siempre visible. |

### Componentes de datos

| Componente | Propósito |
|------------|-----------|
| Tabla con acciones | Listado de entidades (usuarios, apps, roles) con acciones inline por fila. Soporta paginación y filtros. |
| Panel de detalle | Vista expandida de una entidad: atributos, historial de estado y acciones disponibles. |
| Indicador de estado | Muestra el estado actual de una entidad (activo, suspendido, eliminado) con distinción visual clara. |

### Componentes de acción

| Componente | Propósito |
|------------|-----------|
| Formulario de alta | Recoge los datos necesarios para crear una nueva entidad. Valida antes de enviar. |
| Diálogo de confirmación | Requerido para acciones destructivas o de alto impacto. Siempre describe el efecto antes de pedir confirmación. |
| Notificación de resultado | Comunica el resultado de una acción (éxito, error, advertencia) sin interrumpir el flujo de trabajo. |

### Componentes de acceso controlado

| Componente | Propósito |
|------------|-----------|
| Vista bloqueada | Mostrada cuando el usuario accede a una sección para la que no tiene permiso. Explica por qué y qué necesita para obtenerlo. |
| Acción deshabilitada | Un control que existe en la interfaz pero no es accionable por el usuario actual. Siempre explica el motivo al pasar sobre él. |

[↑ Volver al inicio](#sistema-de-diseño)

---

## Patrones de interacción

### Ciclo de vida de entidades

Las entidades del dominio (usuarios, aplicaciones, membresías) tienen estados bien definidos. La interfaz refleja cada transición con un patrón consistente:

```
Ver lista → Ver detalle → Ejecutar acción → Confirmar (si destructiva) → Ver resultado
```

El usuario nunca ejecuta una acción sin ver primero el estado actual de la entidad.

### Flujo de autenticación

El flujo de autenticación es iniciado siempre por la aplicación cliente. Keygo lo procesa y redirige. El usuario solo ve las pantallas de Keygo cuando debe ingresar sus credenciales o cuando hay un error. El flujo es breve por diseño.

### Incorporación a una aplicación

La interfaz del flujo de incorporación (invitación, solicitud de acceso, autoregistro) varía según la política configurada en la aplicación. En todos los casos, el usuario debe saber:
- A qué aplicación está solicitando acceso.
- Qué datos se comparten con esa aplicación.
- Cuál es el siguiente paso (esperando aprobación, acceso inmediato, etc.).

[↑ Volver al inicio](#sistema-de-diseño)

---

## Accesibilidad y consistencia

- Las acciones destructivas (suspender usuario, revocar acceso, eliminar aplicación) se distinguen visualmente de las acciones neutras o de creación.
- Los mensajes de error incluyen la causa y, cuando es posible, la acción que el usuario puede tomar para resolverla.
- Los estados de carga son visibles: el usuario sabe cuándo el sistema está procesando su acción.
- El lenguaje de la interfaz usa los términos del dominio tal como están definidos en el [Lenguaje Ubicuo](../ubiquitous-language.md). No se usan términos técnicos en mensajes visibles al usuario.

[↑ Volver al inicio](#sistema-de-diseño)

---

## Comentarios de los Revisores

| Revisor | Tipo | Contenido |
|---------|------|-----------|
| — | — | Pendiente de revisión |

[↑ Volver al inicio](#sistema-de-diseño)

---

[← Índice](./README.md) | [Siguiente >](./wireframes.md)
