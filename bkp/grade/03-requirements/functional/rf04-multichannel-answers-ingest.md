# RF4 — Ingesta de respuestas multicanal

**Descripción (alto nivel)**  
GRADE debe permitir la **carga de respuestas de los estudiantes** por diferentes canales, vinculándolas a la evaluación y su identificador único, de manera confiable y trazable.

**Alcance incluye**
- **Escaneo OCR** de hojas de respuestas impresas.
- **Captura por fotografía** desde dispositivos móviles.
- **Carga digital** en formato CSV o mediante formularios web.
- Asociación automática de las respuestas con la **evaluación correspondiente** (usando identificador único).
- Validaciones de integridad (ej. formato correcto, cantidad de preguntas, coincidencia de identificadores).
- Registro de cada carga en el **historial de auditoría**.

**No incluye (MVP)**
- Corrección manual de OCR avanzado (excepto validaciones básicas).
- Edición manual de respuestas dentro del sistema (se registran tal cual llegan).
- Integraciones directas con plataformas externas de terceros para ingesta.

**Dependencias**
- RF1 (Ciclo de evaluación centralizado).
- RF3 (Gestión de evaluaciones y entregables).
- RF5 (Calificación automática).
- RF8 (Auditoría).

**Criterios de aceptación (CA)**
1. El sistema permite **cargar respuestas** mediante escaneo OCR.
2. Es posible **subir una foto** desde un dispositivo móvil y asociarla a la evaluación correcta.
3. Se puede **importar un archivo CSV** con respuestas y validarlo.
4. Cada carga se **asocia automáticamente** con la evaluación y su identificador único.
5. El sistema valida integridad de datos (ej. número de respuestas coincide con número de ítems).
6. Si la carga contiene errores, el sistema los **informa claramente** al usuario y rechaza el proceso.
7. Todas las cargas quedan **registradas en la auditoría** (quién/cuándo/cómo).

**Riesgos/mitigaciones**
- Errores de OCR → validaciones de integridad + mensajes de error claros.
- Archivos corruptos → controles de formato y rechazo seguro.
- Asociación incorrecta de respuestas → uso de identificadores únicos en cada entregable.

---

[< Anterior](rf03-evaluations-and-deliverables-management.md) | [Inicio](../README.md#requerimientos-funcionales) | [Siguiente >](rf05-objective-items-automatic-grading.md)