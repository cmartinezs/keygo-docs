# RF3 — Gestión de evaluaciones y generación de entregables

**Descripción (alto nivel)**  
GRADE debe permitir la **creación de evaluaciones** a partir de ítems del banco de preguntas y la **generación de entregables aplicables** (ej. PDF u otros formatos), con identificadores únicos para asegurar trazabilidad y control.

**Alcance incluye**
- Creación de evaluaciones a partir de **ítems seleccionados del banco** (RF2).
- Configuración de parámetros básicos: nombre, fecha de aplicación, duración, escala de calificación, etc.
- Generación de **documentos listos para aplicar** (ej. PDF con formato uniforme).
- Inclusión de un **identificador único** (código, marca de agua o QR) en cada entregable para rastreo.
- Almacenamiento del entregable generado en el repositorio del sistema.
- Historial de versiones de una evaluación (ej. borradores, ajustes previos a publicación).

**No incluye (MVP)**
- Personalización avanzada de formato de impresión (plantillas gráficas complejas).
- Generación automática de ítems mediante IA.
- Exportaciones a plataformas externas (fuera de la API estándar).

**Dependencias**
- RF1 (Ciclo de evaluación centralizado).
- RF2 (Banco de preguntas).
- RF7 (Roles/permisos).
- RF8 (Auditoría).

**Criterios de aceptación (CA)**
1. Es posible **crear una evaluación** seleccionando ítems del banco.
2. Cada evaluación tiene un **identificador único** y un estado inicial (*borrador*).
3. El sistema permite **configurar parámetros básicos** de la evaluación.
4. Se genera un **PDF de aplicación** con formato uniforme e identificador único.
5. El entregable queda **almacenado en el sistema** y asociado a la evaluación correspondiente.
6. Cada modificación relevante genera un **nuevo historial de versión** de la evaluación.
7. Los roles limitan acciones: p.ej., un docente solo gestiona sus evaluaciones, un coordinador diseña pruebas estandarizadas.

**Riesgos/mitigaciones**
- Falta de trazabilidad → uso obligatorio de identificador único en cada entregable.
- Alteraciones manuales del PDF → uso de marcas de agua/códigos de control.
- Errores en cambios de evaluaciones → historial de versiones para control.

---

[< Anterior](rf02-questions-centralized-bank.md) | [Inicio](../README.md#requerimientos-funcionales) | [Siguiente >](rf04-multichannel-answers-ingest.md)