# CU-BP-08 — Seleccionar Ítems

- [Revisión](reviews.md)
- [Volver](../../README.md#1-banco-de-preguntas)

## Escenario origen: S-BP-04 | Buscar y seleccionar ítems

### RF relacionados: RF2, RF8

**Actor principal:** Docente / Coordinador  
**Actores secundarios:** Sistema GRADE

---

### Objetivo
Permitir que el usuario seleccione ítems desde los resultados de búsqueda y los organice en una carpeta o espacio temporal de trabajo para componer una evaluación o para realizar otras acciones posteriores (guardar, compartir, exportar al Composer de Evaluaciones).

### Precondiciones
- El usuario ha realizado una búsqueda válida.
- Existen ítems disponibles en el resultado.

### Postcondiciones
- Los ítems seleccionados quedan almacenados en una carpeta temporal de trabajo asociada al usuario (en sesión o persistente según la configuración).
- El usuario puede exportar la selección al módulo de Gestión de Evaluaciones o abrir el Composer para componer una evaluación con los ítems seleccionados.

### Flujo principal (éxito)
1. El Docente revisa los resultados de búsqueda.
2. El Docente selecciona uno o más ítems.
3. El Sistema resalta los ítems seleccionados.
4. El Docente confirma la acción de “Añadir a carpeta de trabajo”.
5. El Sistema almacena los ítems seleccionados en la carpeta temporal asociada.
6. El Sistema confirma que la selección se realizó correctamente.
7. (Opciones de salida) El usuario elige una de las opciones:
   - "Descargar selección" — el sistema genera un archivo (JSON o CSV) con los datos de los ítems seleccionados y ofrece la descarga al usuario. Este archivo puede usarse como respaldo, compartirse o importarse en otro sistema (p. ej. Gestión de Evaluaciones).
   - "Exportar selección" — (opcional) enviar los ítems al Composer de Evaluaciones mediante API si la integración está disponible.

### Flujos alternativos / Excepciones
- **A1 — Selección vacía:** El Sistema bloquea la acción de añadir si no hay ítems seleccionados.
- **A2 — Error en almacenamiento temporal:** El Sistema muestra mensaje y permite reintentar.
- **A3 — Permisos insuficientes al exportar:** Si el usuario no tiene permisos en el módulo de Evaluaciones para crear/editar, el sistema informa y ofrece la opción de descargar la selección (formato JSON/CSV) o solicitar permisos.

### Reglas de negocio
- **RN-1:** Un ítem no puede duplicarse dentro de la misma carpeta temporal.
- **RN-2:** La carpeta temporal está asociada a cada usuario y expira según reglas de sesión o configuración.
- **RN-3:** La exportación o descarga debe respetar permisos y visibilidad de ítems; solo se incluyen ítems accesibles al usuario.

### Datos principales
- **Ítems seleccionados**(ID, estado, metadatos, referencia a carpeta temporal).
- **Carpeta temporal de trabajo**(ID usuario, lista de ítems, timestamp de creación).

### Consideraciones de seguridad/permiso
- Solo el usuario propietario puede acceder a su carpeta de trabajo.
- Ítems seleccionados deben respetar restricciones de visibilidad; al exportar o descargar, validar permisos y excluir ítems no accesibles, notificando al usuario.

### No funcionales
- **Disponibilidad:** la carpeta temporal debe estar accesible durante toda la sesión.
- **Usabilidad:** debe ser sencillo añadir y quitar ítems de la carpeta de trabajo.
- **Escalabilidad de export:** exportar grandes selecciones debe realizarse en background y ofrecer un enlace de descarga cuando esté listo.

### Criterios de aceptación (QA)
- **CA-1:** El usuario puede seleccionar uno o más ítems y añadirlos a la carpeta temporal.
- **CA-2:** Los ítems seleccionados permanecen disponibles durante la sesión o hasta la expiración de la carpeta.
- **CA-3:** No se permite duplicar ítems en la misma carpeta.
- **CA-4:** El usuario puede descargar la selección en JSON o CSV; el archivo contiene los campos mínimos necesarios para su reutilización en otros sistemas.

---

## Anexo Técnico (para desarrollo)

> Mapeo al modelo DDL y notas sobre exportación/descarga de selección.

### Export como archivo (recomendado)
- Formatos soportados: **JSON** (recomendado para interoperabilidad) y **CSV** (útil para hojas de cálculo).
- El archivo debe incluir solo ítems que el usuario pueda ver (validar permisos antes de generar).
- Si la selección es grande, generar el archivo en background y notificar al usuario (email o notificación en UI) con un enlace temporal.

### Esquema mínimo (JSON)
- Estructura: array de objetos `QuestionExport`.
- Campos recomendados por ítem:
  - `question_id` (number)
  - `text` (string)
  - `question_type` (string)
  - `topic` (object: { topic_id, topic_name, unit_id, unit_name, subject_id, subject_name })
  - `difficulty` (string)
  - `options` (array) — si aplica: [{ text, is_correct (boolean), position (int), score (numeric|null) }]
  - `metadata` (object) — campo libre para otros metadatos (tags, usage_count si existe)
  - `created_by` (user id or name), `created_at` (timestamp)

Ejemplo JSON (fragmento):
```text
[
  {
    "question_id": 101,
    "text": "¿Cuál es la capital de Chile?",
    "question_type": "SC",
    "topic": { "topic_id": 12, "topic_name": "Geografía", "unit_id": 3, "unit_name": "América" },
    "difficulty": "Easy",
    "options": [
      { "text": "Santiago", "is_correct": true, "position": 1 },
      { "text": "Lima", "is_correct": false, "position": 2 }
    ],
    "metadata": { "tags": ["capitales"] },
    "created_by": 55,
    "created_at": "2025-10-06T10:30:00Z"
  }
]
```

### Esquema mínimo (CSV)
- Encabezado sugerido: `question_id,text,question_type,topic_name,unit_name,difficulty,options_json,created_by,created_at`
- `options_json` puede contener un JSON string con las opciones para preservar la estructura.

Ejemplo CSV (línea):
```text
101,"¿Cuál es la capital de Chile?",SC,Geografía,América,Easy,"[{""text"":""Santiago"",""is_correct"":true,...}]",55,2025-10-06T10:30:00Z
```

### Endpoint/implementación sugerida
- Endpoint sugerido para descarga:
  - `GET /workspaces/:workspace_id/export?format=json|csv` — devuelve 202 si es asíncrono o 200 con archivo en línea si es inmediato.
- Recomendaciones:
  - Validar permisos del usuario y filtrar sólo ítems accesibles.
  - Para sets grandes, generar archivo en background (job queue) y devolver 202 + job id; ofrecer `GET /exports/:job_id` para descarga cuando esté listo.
  - Establecer headers: `Content-Disposition: attachment; filename="workspace_<id>_YYYYMMDDHHMM.<ext>"` y `Content-Type: application/json` o `text/csv`.

### Consideraciones de integrabilidad con Gestión de Evaluaciones
- El Composer de Evaluaciones puede aceptar el JSON exportado como input: una función que reciba array de `QuestionExport` e importe/cree una evaluación.
- Sugerencia: documentar un endpoint de import en Gestión de Evaluaciones (por ejemplo `POST /evaluation-composer/import` que acepte el archivo JSON) o permitir subir el archivo desde la UI del Composer.
- Si hay ítems en el archivo que no existen en el destino o no son accesibles, el importer debe devolver un reporte (IDs aceptados/rechazados + razones).

### Seguridad y privacidad
- Solo incluir metadatos que el usuario tenga derecho a ver (no exponer borradores privados o datos sensibles).
- Ilimitados downloads pueden exponer datos; aplicar rate limiting y auditoría de exportaciones.

### Ejemplo de flujo técnico para export asíncrono
1. Usuario solicita `GET /workspaces/123/export?format=json`.
2. API crea job en queue, guarda job record y responde 202 con `job_id`.
3. Worker procesa job, genera archivo en object storage, marca job como ready y notifica al usuario.
4. Usuario descarga desde `GET /exports/:job_id`.

---

[Subir](#cu-bp-08--seleccionar-ítems)