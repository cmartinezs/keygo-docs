# RF13 — Administración del sistema

**Descripción (alto nivel)**  
GRADE debe permitir a los Administradores la **gestión global de la plataforma**, configurando parámetros, administrando usuarios y controlando políticas generales para garantizar el funcionamiento correcto del sistema.

**Alcance incluye**  
- Configuración de **parámetros globales**:  
  - Escalas de calificación (ej. 1–7, 0–100).  
  - Reglas de conversión puntaje → nota.  
  - Límites de tamaño de archivo o número de ítems por evaluación.  
- **Gestión de usuarios**: creación, edición, activación/desactivación y asignación de roles (RF7).  
- Definición y mantenimiento de **políticas del banco de preguntas** (ej. reglas para versionado, estados vigentes/retirados).  
- Monitoreo del **estado general del sistema** y capacidad de ejecutar acciones de mantenimiento (ej. reinicios de procesos).  
- Registro en auditoría de todas las acciones de administración.  

**No incluye (MVP)**  
- Herramientas avanzadas de configuración multitenant.  
- Gestión de integraciones externas complejas (cubiertas en RNF-INT).  
- Automatización de backups/restauración (se hace fuera del alcance funcional).  

**Dependencias**  
- RF7 (Roles y permisos).  
- RF8 (Auditoría).  
- RF9 (Paneles operativos y métricas).  

**Criterios de aceptación (CA)**  
1. El Administrador puede **configurar escalas y reglas globales de calificación**.  
2. Es posible **crear, editar y desactivar usuarios**, asignándoles roles válidos.  
3. Se definen y aplican **políticas del banco de preguntas** (ej. marcar ítems como retirados).  
4. El sistema aplica límites definidos (ej. rechaza archivos que excedan tamaño máximo).  
5. Todas las acciones administrativas quedan **registradas en la auditoría**.  
6. Los administradores tienen acceso a un **panel de estado general** del sistema.  

**Riesgos/mitigaciones**  
- Configuración incorrecta → validaciones y advertencias al modificar parámetros globales.  
- Abuso de privilegios → auditoría estricta y revisiones periódicas de roles.  
- Pérdida de consistencia → documentación de políticas y reglas obligatorias en el sistema.

---

[< Anterior](rf12-external-systems-integration.md) | [Inicio](../README.md#requerimientos-funcionales) | [Siguiente >](rf14-open-questions-and-grading-with-rubrics.md)