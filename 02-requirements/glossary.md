[← Índice](./README.md)

---

# Glosario

Términos del dominio de identidad y acceso utilizados en el catálogo de requerimientos de Keygo.

## Contenido

- [Actores](#actores)
- [Entidades del dominio](#entidades-del-dominio)
- [Conceptos de acceso y autorización](#conceptos-de-acceso-y-autorización)
- [Conceptos de sesión y credenciales](#conceptos-de-sesión-y-credenciales)
- [Conceptos operativos](#conceptos-operativos)
- [Comentarios de los Revisores](#comentarios-de-los-revisores)

---

## Actores

| Término | Definición |
|---------|------------|
| **Administrador de la plataforma** | Actor responsable de gestionar organizaciones y planes a nivel global. No accede a los datos internos de ninguna organización. |
| **Administrador de organización** | Actor con control total sobre su propia organización: usuarios, roles, aplicaciones cliente y suscripción. |
| **Usuario final** | Persona que se autentica en el ecosistema a través de Keygo, siempre en el contexto de una organización específica. |
| **Equipo operativo de Keygo** | Equipo responsable de la disponibilidad y el rendimiento de la plataforma. No accede a datos de usuarios salvo en situaciones de incidente con trazabilidad. |

[↑ Volver al inicio](#glosario)

---

## Entidades del dominio

| Término | Definición |
|---------|------------|
| **Organización** | Unidad aislada dentro de Keygo que agrupa usuarios, roles y aplicaciones cliente. Equivale al concepto de _tenant_ en arquitecturas multi-tenant. Cada organización opera en un espacio completamente separado. |
| **Usuario** | Identidad registrada dentro de una organización. Un usuario pertenece a exactamente una organización. |
| **Aplicación cliente** | Sistema externo registrado dentro de una organización que delega en Keygo la autenticación y verificación de identidad de sus usuarios. |
| **Membresía** | Relación entre un usuario y una aplicación cliente dentro de la misma organización. Define qué usuarios tienen acceso a qué aplicación y bajo qué roles. |
| **Rol** | Agrupación con nombre de permisos asignada a un usuario en el contexto de una aplicación cliente. Los roles son definidos por la organización. |
| **Permiso** | Autorización granular que controla si una identidad puede ejecutar una operación específica. |
| **Plan** | Configuración de límites y capacidades asociada a la suscripción de una organización (ej. cantidad máxima de usuarios o aplicaciones cliente). |
| **Suscripción** | Estado activo de un plan en una organización. Determina qué capacidades están habilitadas y bajo qué condiciones. |

[↑ Volver al inicio](#glosario)

---

## Conceptos de acceso y autorización

| Término | Definición |
|---------|------------|
| **Autenticación** | Proceso de verificar que una identidad es quien dice ser, mediante la validación de sus credenciales. |
| **Autorización** | Proceso de determinar qué operaciones puede ejecutar una identidad autenticada, basado en sus roles y permisos. |
| **Ámbito de acceso** | Conjunto de operaciones o recursos sobre los cuales una aplicación cliente tiene autorización para actuar en nombre de un usuario. Equivale al concepto de _scope_ en protocolos de identidad estándar. |
| **Control de acceso basado en roles** | Mecanismo por el cual los permisos se agrupan en roles, y los roles se asignan a identidades. Toda decisión de autorización se resuelve evaluando los roles activos de la identidad. |
| **Política de autenticación** | Conjunto de reglas que rigen cómo deben autenticarse los usuarios de una organización (ej. requisitos de contraseña, períodos de validez de sesión). |

[↑ Volver al inicio](#glosario)

---

## Conceptos de sesión y credenciales

| Término | Definición |
|---------|------------|
| **Credencial** | Información secreta que permite verificar la identidad de un usuario o aplicación cliente (ej. contraseña, credencial de aplicación). |
| **Credencial de sesión** | Artefacto emitido por Keygo que acredita que una identidad ha sido autenticada. Tiene un período de validez y puede ser verificado por aplicaciones cliente sin consultar directamente a Keygo. |
| **Credencial de renovación** | Artefacto de larga duración que permite obtener nuevas credenciales de sesión sin requerir que el usuario vuelva a autenticarse. |
| **Sesión** | Estado activo asociado a una autenticación exitosa. Tiene un ciclo de vida definido: creación, uso, renovación y cierre o expiración. |
| **Revocación** | Acción de invalidar una sesión o credencial antes de su expiración natural. Puede ser iniciada por el usuario, el administrador de organización o el sistema. |
| **Verificación pública de credenciales** | Mecanismo que permite a cualquier aplicación cliente comprobar la autenticidad de una credencial de sesión usando información pública expuesta por Keygo, sin necesidad de consultar un endpoint privado. |
| **Rotación de claves** | Proceso por el cual las claves criptográficas usadas para firmar credenciales son reemplazadas periódicamente, manteniendo la verificabilidad de credenciales anteriores durante la transición. |

[↑ Volver al inicio](#glosario)

---

## Conceptos operativos

| Término | Definición |
|---------|------------|
| **Evento de seguridad** | Acción relevante para la seguridad o la gobernanza que queda registrada en el sistema (ej. inicio de sesión, cambio de rol, revocación de acceso). |
| **Registro de auditoría** | Colección inmutable de eventos de seguridad ordenados cronológicamente. No puede ser modificado ni eliminado por ningún actor del sistema. |
| **Aislamiento** | Propiedad del sistema por la cual los datos, usuarios, sesiones y roles de una organización no son accesibles desde ninguna otra organización. Es una restricción de diseño, no una configuración. |
| **Aprovisionamiento** | Proceso de dar de alta usuarios o recursos en el sistema, ya sea de forma manual (por el administrador) o automatizada (mediante integración con sistemas externos). En el MVP, el aprovisionamiento es exclusivamente manual. |
| **Identificador único** | Valor que identifica de forma inequívoca una entidad dentro del sistema (organización, usuario, aplicación cliente). No cambia durante el ciclo de vida de la entidad. |

[↑ Volver al inicio](#glosario)

---

## Comentarios de los Revisores

| Revisor | Tipo | Contenido |
| ------- | ---- | --------- |
| — | — | Pendiente de revisión |

[↑ Volver al inicio](#glosario)

---

[← Índice](./README.md)
