[← Índice](./README.md) | [< Anterior](./system-scope.md) | [Siguiente >](./needs-expectations.md)

---

# Actores

## Contenido

- [Descripción general](#descripción-general)
- [Tabla de Actores del Sistema Keygo](#tabla-de-actores-del-sistema-keygo)
  - [Actores explícitamente excluidos en esta fase](#actores-explícitamente-excluidos-en-esta-fase)
- [Jerarquía de actores](#jerarquía-de-actores)
- [Notas](#notas)
- [Comentarios de los Revisores](#comentarios-de-los-revisores)

---

## Descripción general

Keygo está concebido como el eje central de autenticación, autorización y gestión de identidad para ecosistemas SaaS multi-organización. Su propósito es ofrecer una estructura clara para que múltiples organizaciones gestionen de forma autónoma sus usuarios, roles y aplicaciones, mientras la plataforma garantiza que cada organización opere en un espacio completamente aislado.

Para ello, se han identificado los actores que interactúan con la plataforma, cada uno con responsabilidades específicas y restricciones definidas. La distinción entre actores es fundamental para garantizar que el control sobre los recursos de cada organización permanezca donde corresponde, sin exponer ni mezclar información entre organizaciones.

[↑ Volver al inicio](#actores)

---

## Tabla de Actores del Sistema Keygo

| Actor | Responsabilidades principales | Alcances y restricciones |
|-------|-------------------------------|--------------------------|
| **Administrador de la plataforma** | - Registra y da de baja organizaciones en la plataforma.<br>- Gestiona los planes de servicio disponibles para las organizaciones.<br>- Monitorea el estado general de la plataforma y las suscripciones activas.<br>- Define políticas globales de operación y retención de datos.<br>- Atiende situaciones excepcionales que escalen desde las organizaciones. | - Tiene visibilidad sobre la existencia de las organizaciones y el estado de sus suscripciones, pero no sobre sus usuarios ni sus datos internos.<br>- No puede acceder a los recursos (usuarios, roles, sesiones) de ninguna organización individual. |
| **Administrador de organización** | - Gestiona el ciclo de vida de su organización: configuración, usuarios, roles y aplicaciones registradas.<br>- Crea, modifica, suspende y elimina usuarios dentro de su organización.<br>- Define y asigna roles y permisos a los usuarios de su organización.<br>- Registra y administra las aplicaciones cliente que tendrán acceso a su organización.<br>- Gestiona la suscripción y la facturación de su organización.<br>- Consulta el historial de eventos de seguridad de su organización. | - Su ámbito es exclusivamente su propia organización. No puede ver ni afectar usuarios, roles ni sesiones de otras organizaciones.<br>- No administra configuraciones globales de la plataforma. |
| **Usuario final** | - Se autentica en las aplicaciones del ecosistema a través de Keygo.<br>- Gestiona sus propias credenciales: cambio de contraseña, cierre de sesión, revocación de acceso desde dispositivos.<br>- Consulta y actualiza su perfil de identidad dentro de la organización a la que pertenece. | - Opera siempre en el contexto de una organización específica. No puede interactuar con recursos de otras organizaciones.<br>- No tiene acceso a la gestión de roles, aplicaciones ni configuración de la organización, salvo que el administrador le asigne un rol que lo permita. |
| **Aplicación cliente** | - Se integra con Keygo para delegar la autenticación y verificación de identidad de sus usuarios.<br>- Consume los contratos de integración de Keygo para determinar qué puede hacer cada usuario dentro de la aplicación.<br>- Recibe notificaciones de eventos relevantes de identidad (usuario creado, acceso revocado, etc.) para mantenerse sincronizada. | - Opera exclusivamente sobre los usuarios y roles de la organización para la que fue registrada.<br>- No gestiona su propia lógica de autenticación; delega esa responsabilidad completamente en Keygo.<br>- Sus permisos de acceso están acotados al ámbito que el administrador de la organización le haya asignado. |
| **Equipo operativo de Keygo** | - Mantiene la disponibilidad y el rendimiento de la plataforma.<br>- Responde ante incidentes que afecten la operación del servicio.<br>- Ejecuta procedimientos de mantenimiento planificado.<br>- Accede a logs y métricas operativas para diagnóstico, sin acceso a datos de usuarios de las organizaciones. | - No accede a datos de usuarios, roles ni sesiones de ninguna organización, salvo en circunstancias de incidente grave y con trazabilidad del acceso.<br>- Sus acciones sobre el sistema quedan registradas en el audit trail de la plataforma. |

[↑ Volver al inicio](#actores)

---

### Actores explícitamente excluidos en esta fase

- **Sistemas externos de directorio corporativo**: no provisionan ni sincronizan usuarios con Keygo directamente en esta fase; la gestión de usuarios es manual por parte del administrador de la organización.
- **Proveedores de identidad externos**: el inicio de sesión mediante cuentas de terceros (redes sociales, directorios empresariales, etc.) queda fuera del alcance del MVP.
- **Usuarios anónimos**: Keygo no gestiona flujos de acceso sin autenticación; toda interacción requiere identidad verificada.
- **Sistemas de auditoría o SIEM externos**: la integración con plataformas externas de análisis de seguridad no está contemplada en esta fase.

[↑ Volver al inicio](#actores)

---

## Jerarquía de actores

```
Administrador de la plataforma
│
├── Administrador de organización (por cada organización registrada)
│   ├── Usuario final (por cada usuario de la organización)
│   └── Aplicación cliente (por cada app registrada en la organización)
│
└── Equipo operativo de Keygo
```

El administrador de la plataforma opera a nivel global pero sin acceso a los recursos internos de cada organización. El administrador de organización tiene control total sobre su espacio, pero no puede cruzar los límites hacia otras organizaciones. Los usuarios finales y las aplicaciones cliente operan siempre dentro del contexto de una organización específica.

[↑ Volver al inicio](#actores)

---

## Notas

> Los actores descritos en este documento son actores de negocio, no roles técnicos de implementación. La definición de cómo se modelan estos actores en el sistema —permisos granulares, jerarquías de roles configurables, roles personalizados por organización— es parte de la fase de Requerimientos y Diseño.

> Las integraciones con sistemas externos (directorios corporativos, proveedores de identidad federada, plataformas de auditoría) no constituyen actores en esta fase. Su incorporación futura dependerá de contratos de integración definidos por Keygo y habilitados por el administrador de la organización correspondiente.

[↑ Volver al inicio](#actores)

---

## Comentarios de los Revisores

A continuación se presentan los comentarios de los revisores sobre los actores del sistema.

| Revisor | Tipo | Contenido |
| ------- | ---- | --------- |
| — | — | Pendiente de revisión |

[↑ Volver al inicio](#actores)

---

[← Índice](./README.md) | [< Anterior](./system-scope.md) | [Siguiente >](./needs-expectations.md)
