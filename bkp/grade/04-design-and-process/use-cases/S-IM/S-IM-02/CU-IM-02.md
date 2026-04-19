# CU-IM-02 — Capturar hoja de respuestas

- [Revisión](review.md)
- [Volver](../../README.md#3-ingesta-móvil)

## Escenario origen: S-IM-02 | Capturar hoja de respuestas (guías de encuadre)

### RF relacionados: RF4, RF8

**Actor principal:** Docente / Asistente de aula  
**Actores secundarios:** Sistema GRADE (Ingesta móvil), Pipeline de procesamiento

---

### Objetivo
Permitir que el Docente o Asistente capture las hojas de respuesta de los estudiantes utilizando guías visuales de encuadre que aseguren la calidad para el procesamiento OCR posterior, registrando cada captura como página escaneada asociada al lote de ingesta activo.

### Precondiciones
- La evaluación está vinculada en la app mediante **CU-IM-01** con un lote de ingesta en estado **Abierto**.
- El dispositivo móvil está registrado y activo en el sistema.
- El usuario está autenticado con permisos de captura sobre el curso.
- La cámara del dispositivo está disponible y funcional.
- Hay suficiente espacio de almacenamiento local.

### Postcondiciones
- Cada hoja capturada se registra como página escaneada con estado **En Cola**.
- Las imágenes quedan almacenadas localmente con hash de integridad.
- Se crean trabajos de procesamiento automáticamente para iniciar el pipeline.
- Los metadatos de captura quedan registrados para trazabilidad completa.
- Las capturas están listas para el procesamiento automático (CU-IM-03).

### Flujo principal (éxito)
1. El usuario abre la opción **"Capturar hojas de respuesta"** en la app.
2. La app verifica que existe un lote de ingesta activo en estado **Abierto**.
3. La app activa la cámara y muestra **guías de encuadre** optimizadas para hojas de respuesta:
   - Bordes de detección automática
   - Indicadores de calidad en tiempo real
   - Marcas de orientación y escala
4. El usuario posiciona la hoja dentro de las guías visuales.
5. La app ejecuta **validaciones de calidad pre-captura**:
   - Detección de bordes de la hoja
   - Verificación de iluminación adecuada
   - Control de estabilidad (anti-movimiento)
   - Validación de resolución mínima
6. Al cumplir criterios, la app **habilita el botón de captura** o toma automáticamente.
7. **Post-captura**, la app ejecuta validaciones adicionales:
   - Cálculo de hash de integridad de la imagen
   - Verificación de duplicados por hash
   - Análisis básico de calidad (nitidez, contraste)
8. Si la validación es exitosa, la app:
   - Guarda la imagen localmente con nombre único
   - Registra la página escaneada en la base de datos local
   - Crea trabajo de procesamiento inicial para etapa de decodificación
9. La app muestra **confirmación visual** con preview de la captura.
10. El usuario puede **continuar capturando** más hojas o **finalizar sesión**.

### Flujos alternativos / Excepciones
- **A1 — Validación de calidad fallida:** La app muestra feedback específico:
  - "Mejorar iluminación": ajustar posición o encender flash
  - "Estabilizar dispositivo": reducir movimiento
  - "Enfocar hoja": centrar dentro de las guías
  - "Verificar orientación": rotar hoja según indicadores
- **A2 — Imagen duplicada (hash existente):** La app detecta duplicado y ofrece opciones:
  - Descartar nueva captura
  - Reemplazar captura anterior
  - Mantener ambas con nota de duplicado
- **A3 — Error de almacenamiento:** La app maneja diferentes tipos:
  - **Espacio insuficiente**: alerta y sugiere liberar espacio
  - **Error de escritura**: reintenta y notifica si persiste
  - **Corrupción de archivo**: descarta y solicita recaptura
- **A4 — Sin conexión a BD local:** La app:
  - Continúa capturando y almacena en cola local
  - Sincroniza automáticamente al restaurar conexión
  - Mantiene integridad de secuencia de capturas
- **A5 — Lote cerrado/inválido:** La app detecta que el lote cambió de estado y:
  - Notifica la situación al usuario
  - Ofrece crear nuevo lote o contactar supervisor
- **A6 — Cancelación del usuario:** La sesión se puede detener manteniendo:
  - Todas las capturas exitosas ya registradas
  - Estado del lote como **Abierto** para continuar después

### Reglas de negocio
- **RN-1:** Solo pueden capturarse hojas cuando existe un lote de ingesta en estado **Abierto**.
- **RN-2:** Cada imagen debe tener hash de integridad único dentro del sistema.
- **RN-3:** Las capturas deben cumplir estándares mínimos de calidad antes de ser aceptadas.
- **RN-4:** Cada página escaneada debe asociarse exactamente a un lote y un dispositivo.
- **RN-5:** Las imágenes se almacenan localmente hasta confirmación de sincronización exitosa.
- **RN-6:** Se debe crear automáticamente un trabajo de procesamiento por cada captura exitosa.

### Datos principales
- **Página Escaneada** (identificador, lote, dispositivo, URI imagen, hash imagen, fecha captura, ancho, alto, DPI, estado, razón fallo)
- **Trabajo de Procesamiento** (identificador, página, etapa, fecha inicio, estado)
- **Captura Local** (datos temporales: ruta local, metadatos temporales, estado sincronización, métricas calidad)

### Consideraciones de seguridad/permiso
- **Autenticación:** Usuario debe mantener sesión válida durante captura.
- **Autorización:** Verificación continua de permisos sobre el curso asociado.
- **Integridad:** Hash SHA-256 garantiza detección de modificaciones o corrupciones.
- **Privacidad:** Imágenes cifradas en almacenamiento local hasta sincronización.
- **Auditoría:** Registro detallado de cada intento de captura (exitoso o fallido).

### No funcionales
- **Rendimiento:** 
  - Captura y validación < 3s p95 por página
  - Cálculo de hash y almacenamiento local < 1s p95
- **Usabilidad:** 
  - Guías visuales claras con feedback en tiempo real
  - Indicadores de progreso durante validaciones
  - Preview inmediato de capturas exitosas
- **Disponibilidad:** 
  - Modo offline: capturas locales con sincronización diferida
  - Recuperación automática de sesiones interrumpidas
- **Calidad:** 
  - Detección automática de problemas de iluminación y enfoque
  - Prevención de duplicados por hash de imagen

### Criterios de aceptación (QA)
- **CA-1:** Con lote abierto, al capturar hoja con calidad adecuada, se crea `scanned_page` con hash único y estado **Queued**.
- **CA-2:** Si la imagen no cumple criterios de calidad, se rechaza con feedback específico y opción de reintentar.
- **CA-3:** El sistema previene duplicados detectando imágenes con hash SHA-256 idéntico.
- **CA-4:** En modo offline, las capturas se almacenan localmente y sincronizan automáticamente al reconectarse.
- **CA-5:** Cada captura exitosa genera automáticamente un `processing_job` para etapa **Decode**.
- **CA-6:** Si el lote se cierra durante captura, se notifica al usuario con opciones de resolución.
- **CA-7:** Las métricas de calidad (resolución, iluminación, estabilidad) quedan registradas para auditoría.

---

## Anexo Técnico (para desarrollo)

> Esta sección contiene los detalles técnicos de implementación según el modelo de datos del sistema de Ingesta Móvil.

### Resumen del modelo de datos

#### Entidades principales involucradas
- **`scanned_pages`**: Registro de cada imagen/página capturada con metadatos técnicos y hash de integridad.
- **`ingest_batches`**: Lotes de ingesta en estado "Open" que pueden recibir nuevas páginas escaneadas.
- **`ingest_devices`**: Dispositivos móviles activos que realizan las capturas.
- **`processing_jobs`**: Trabajos del pipeline de procesamiento que se crean automáticamente por cada captura.
- **`processing_logs`**: Logs detallados del proceso de captura y validaciones.

#### Relaciones clave
- Cada **página escaneada** pertenece a un **lote de ingesta** específico (`ingest_batch_fk`) y fue capturada por un **dispositivo** (`device_fk`).
- La **unicidad global** se garantiza por `image_sha256` (UNIQUE constraint).
- Cada captura exitosa dispara la creación de un **trabajo de procesamiento** inicial en etapa 'Decode'.
- El flujo de procesamiento es: `scanned_pages → processing_jobs → page_qrs → page_detections → bubble_detections`.

#### Campos críticos para este caso de uso
**En `scanned_pages`:**
- `ingest_batch_fk`, `device_fk` (obligatorios, definen contexto de captura)
- `image_uri` (ruta/URL del archivo), `image_sha256` (hash único para idempotencia)
- `captured_at` (timestamp automático), `width_px`, `height_px` (dimensiones)
- `dpi` (opcional), `status` (siempre 'Queued' en creación)
- `failure_reason` (null hasta que ocurra un error)

**En `processing_jobs`:**
- `scanned_page_fk` (página asociada), `stage` (siempre 'Decode' para captura inicial)
- `started_at` (timestamp automático), `status` (siempre 'Running' en creación)
- `finished_at`, `error` (null hasta completar procesamiento)

#### Auditoría en Ingesta Móvil
Las páginas escaneadas usan **timestamps específicos del pipeline** (`captured_at`) que permiten trazabilidad completa del flujo de procesamiento desde la captura hasta la consolidación final.

### Validaciones implementadas en base de datos

**Verificar lote activo:**
```sql
SELECT ib.ingest_batch_id, ib.evaluation_fk, ib.started_at
FROM ingest_batches ib
WHERE ib.ingest_batch_id = :batch_id
AND ib.state = 'Open';
```

**Verificar duplicado por hash:**
```sql
SELECT scanned_page_id, captured_at, ingest_batch_fk
FROM scanned_pages
WHERE image_sha256 = :calculated_hash;
```

**Verificar dispositivo activo:**
```sql
SELECT device_id, name, active
FROM ingest_devices
WHERE device_id = :device_id
AND active = true;
```

### Ejemplo de implementación (paso 8 del flujo principal)

```sql
-- 1. Insertar página escaneada con validaciones
INSERT INTO scanned_pages (
    ingest_batch_fk, device_fk, image_uri, image_sha256,
    captured_at, width_px, height_px, dpi, status
) VALUES (
    :batch_id, :device_id, :image_path, :calculated_hash,
    NOW(), :width, :height, :dpi, 'Queued'
) 
ON CONFLICT (image_sha256) DO NOTHING
RETURNING scanned_page_id, captured_at;

-- 2. Crear trabajo de procesamiento automático
INSERT INTO processing_jobs (
    scanned_page_fk, stage, started_at, status
) VALUES (
    :new_page_id, 'Decode', NOW(), 'Running'
) RETURNING processing_job_id;

-- 3. Log inicial del procesamiento
INSERT INTO processing_logs (
    processing_job_fk, ts, level, message, data
) VALUES (
    :job_id, NOW(), 'INFO', 'Page captured and queued for processing',
    jsonb_build_object(
        'batch_id', :batch_id,
        'device_id', :device_id,
        'image_dimensions', jsonb_build_object('width', :width, 'height', :height),
        'dpi', :dpi
    )
);
```

### Manejo de captura offline

**Datos almacenados localmente:**
```json
{
  "pendingPages": [
    {
      "localPath": "/app/cache/page_001.jpg",
      "sha256": "abc123...",
      "capturedAt": "2024-10-08T14:35:22Z",
      "dimensions": {"width": 2480, "height": 3508},
      "dpi": 300,
      "batchId": "12345",
      "deviceId": "device_001",
      "qualityMetrics": {
        "sharpness": 0.85,
        "brightness": 0.72,
        "contrast": 0.68
      }
    }
  ]
}
```

**Proceso de sincronización:**
```sql
-- Sincronizar páginas capturadas offline
WITH batch_check AS (
    SELECT ingest_batch_id FROM ingest_batches 
    WHERE ingest_batch_id = :batch_id AND state = 'Open'
)
INSERT INTO scanned_pages (
    ingest_batch_fk, device_fk, image_uri, image_sha256,
    captured_at, width_px, height_px, dpi, status
)
SELECT 
    :batch_id, :device_id, :synced_image_uri, :hash,
    :original_timestamp, :width, :height, :dpi, 'Queued'
FROM batch_check
ON CONFLICT (image_sha256) DO NOTHING
RETURNING scanned_page_id;
```

### Validación de calidad pre-captura

**Métricas calculadas en la app:**
```javascript
// Validaciones en tiempo real
const qualityChecks = {
    sharpness: calculateLaplacianVariance(imageData),     // > 100
    brightness: calculateMeanBrightness(imageData),       // 0.3 - 0.8
    contrast: calculateRMSContrast(imageData),            // > 0.4
    edges: detectDocumentEdges(imageData),                // 4 corners detectados
    stability: measureDeviceMovement(sensorData)          // < 0.1 rad/s
};

const isQualityAcceptable = 
    qualityChecks.sharpness > 100 &&
    qualityChecks.brightness >= 0.3 && qualityChecks.brightness <= 0.8 &&
    qualityChecks.contrast > 0.4 &&
    qualityChecks.edges.length === 4 &&
    qualityChecks.stability < 0.1;
```

### Índices recomendados
- `CREATE UNIQUE INDEX idx_scanned_pages_sha256 ON scanned_pages (image_sha256);`
- `CREATE INDEX idx_scanned_pages_batch_captured ON scanned_pages (ingest_batch_fk, captured_at);`
- `CREATE INDEX idx_scanned_pages_device_status ON scanned_pages (device_fk, status);`
- `CREATE INDEX idx_processing_jobs_page_stage ON processing_jobs (scanned_page_fk, stage);`

### Referencias al modelo completo
Para más detalles sobre la estructura completa, restricciones, tipos de datos y triggers:
- [Modelo Entidad-Relación completo](../../../../06-data-model/mobile-ingest/mer.md)
- [Script DDL de creación](../../../../06-data-model/mobile-ingest/DDL.sql)
- [Triggers y funciones](../../../../06-data-model/mobile-ingest/TRIGGERS.sql)

---

[Subir](#cu-im-02--capturar-hoja-de-respuestas)
