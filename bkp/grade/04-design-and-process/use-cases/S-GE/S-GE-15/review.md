# Apreciación CU-GE-23 — Configurar parámetros globales

- [Volver](../../README.md#2-gestión-de-evaluación)

### Qué cubre
- Administración de parámetros centrales del sistema (escala de calificación, límites de ítems, tiempos máximos).
- Validación de valores para asegurar consistencia institucional.
- Aplicación inmediata de cambios a evaluaciones futuras.
- Registro de todas las modificaciones en auditoría.

### Escenario lo justifica
- En S-GE-15, Ernesto como Administrador requiere mantener GRADE alineado a políticas institucionales.
- Configurar escalas de notas o parámetros globales directamente en la plataforma evita depender de desarrollo técnico.

### ¿Es suficiente como CU separado?
✅ Sí. Configurar parámetros globales es una funcionalidad distinta de la gestión de usuarios, con reglas y alcances propios.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Posibles evolutivos: parametrización avanzada (curvas de notas, reglas automáticas de vigencia de ítems), pero no forman parte del alcance inicial.

### Apreciación final
El CU-GE-23 está correctamente definido y suficiente para cubrir la **configuración de parámetros globales** en S-GE-15.

---

# Apreciación CU-GE-24 — Gestionar usuarios y roles

### Qué cubre
- Creación, edición y desactivación de usuarios en GRADE.
- Asignación y cambio de roles (Docente, Coordinador, Administrador).
- Validación de unicidad de identificadores (correo electrónico).
- Registro completo en auditoría de todas las operaciones sobre usuarios.

### Escenario lo justifica
- En S-GE-15, Ernesto necesita gestionar el acceso al sistema mediante control de usuarios y roles.
- Esto asegura que solo personas autorizadas accedan y en el nivel de permisos correcto.

### ¿Es suficiente como CU separado?
✅ Sí. La gestión de usuarios es un proceso distinto de la configuración global, con flujos propios y un impacto directo en la seguridad del sistema.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Evolutivos posibles: gestión de contraseñas, autenticación multifactor, integración con directorios institucionales (LDAP/SSO).

### Apreciación final
El CU-GE-24 está correctamente definido y suficiente para cubrir la **gestión de usuarios y roles** en S-GE-15.  
