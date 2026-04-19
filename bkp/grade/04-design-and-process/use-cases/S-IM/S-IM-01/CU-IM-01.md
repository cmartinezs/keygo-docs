# CU-IM-01 — Vincular captura con evaluación

- [Revisión](review.md)
- [Volver](../../README.md#3-ingesta-móvil)

## Escenario origen: S-IM-01 | Vincular captura con evaluación (leer QR/ID)

### RF relacionados: RF4, RF3

**Actor principal:** Docente / Asistente de aula  
**Actores secundarios:** Sistema GRADE (Gestión de Evaluación), Sistema Mobile Ingest

---

### Objetivo
Permitir que el Docente o Asistente vincule la sesión de captura de respuestas con una evaluación específica mediante escaneo de QR o ingreso manual de ID, creando un batch de ingesta que agrupa todas las capturas posteriores de la sesión.

### Precondiciones
- Usuario autenticado con permisos para la evaluación y curso.
- La evaluación está en estado **Aplicada**.
- El dispositivo móvil está registrado y activo en el sistema.
- La evaluación tiene un QR o ID único generado previamente.
- El curso de la evaluación coincide con los permisos del usuario.

### Postcondiciones
- Se crea un nuevo lote de ingesta vinculado a la evaluación y dispositivo.
- La aplicación móvil queda configurada para asociar todas las capturas posteriores a este lote.
- El lote queda en estado **Abierto** listo para recibir páginas escaneadas.
- Se registra el inicio de sesión de captura con auditoría completa.

### Flujo principal (éxito)
1. El usuario abre la opción **"Nueva captura de respuestas"** en la app móvil.
2. La app verifica que el dispositivo esté registrado y activo.
3. La app solicita **escanear el QR** o **ingresar el ID único** de la evaluación.
4. El usuario realiza la acción y la app envía el identificador al sistema.
5. El Sistema valida:
   - La evaluación existe y está en estado **Aplicada**
   - El usuario tiene permisos sobre el curso asociado
   - No hay otro lote **Abierto** para esta evaluación en el mismo dispositivo
6. El Sistema crea un nuevo lote de ingesta con:
   - Vinculación a la evaluación seleccionada
   - Asociación al curso correspondiente
   - Registro del dispositivo móvil
   - Estado inicial **Abierto**
   - Timestamp de inicio
7. El Sistema devuelve los metadatos de la evaluación y el identificador del lote.
8. La app muestra confirmación con datos de la evaluación (nombre, curso, fecha, cantidad de preguntas).
9. El usuario confirma y la app establece la vinculación local.
10. La sesión queda lista para **captura de hojas de respuestas (S-IM-02)**.

### Flujos alternativos / Excepciones
- **A1 — QR ilegible / ID inválido:** La app muestra error específico y permite reintentar escaneo o cambiar a ingreso manual.
- **A2 — Evaluación no aplicada:** El sistema rechaza con mensaje claro del estado actual (Borrador/Publicada/Calificada/Archivada).
- **A3 — Permisos insuficientes:** El sistema rechaza indicando que el usuario no tiene acceso al curso de esta evaluación.
- **A4 — Lote ya abierto:** El sistema detecta lote abierto existente y ofrece opciones:
  - Continuar con el lote existente
  - Cerrar el anterior y crear uno nuevo
- **A5 — Dispositivo no registrado:** La app redirige al proceso de registro de dispositivo antes de continuar.
- **A6 — Sin conexión:** La app guarda el vínculo como **pendiente** y permite continuar en modo offline; se sincroniza al reconectarse.
- **A7 — Inconsistencia de curso:** El sistema detecta que la evaluación no pertenece al curso donde el usuario tiene permisos y rechaza la operación.

### Reglas de negocio
- **RN-1:** Solo puede existir un lote en estado **Abierto** por evaluación y dispositivo simultáneamente.
- **RN-2:** El curso del lote debe coincidir exactamente con el curso de la evaluación.
- **RN-3:** Solo evaluaciones en estado **Aplicada** pueden recibir capturas móviles.
- **RN-4:** El dispositivo debe estar activo para crear nuevos lotes.
- **RN-5:** Cada lote debe tener al menos una página asociada antes de poder cerrarse.

### Datos principales
- **Lote de Ingesta** (identificador, evaluación, curso, dispositivo, fecha inicio, fecha cierre, estado, notas)
- **Dispositivo de Ingesta** (identificador, nombre, plataforma, versión OS, versión app, registrado por, activo)
- **Vinculación Local** (datos temporales en la app: ID lote, metadatos evaluación, configuración sesión)

### Consideraciones de seguridad/permiso
- **Autenticación:** Usuario debe tener rol Docente o Asistente asignado al curso específico.
- **Autorización:** Validación de permisos a nivel de curso antes de crear el batch.
- **Registro de dispositivos:** Solo dispositivos previamente registrados y activos pueden crear batches.
- **Auditoría completa:** Todos los intentos de vinculación (exitosos y fallidos) quedan registrados.
- **Validación cruzada:** El sistema verifica coherencia entre evaluation_fk y course_fk.

### No funcionales
- **Rendimiento:** 
  - Validación del QR/ID < 2s p95 con conexión estable
  - Creación de batch < 1s después de validaciones exitosas
- **Usabilidad:** 
  - Confirmación visual clara del vínculo (nombre evaluación, curso, fecha, cantidad de preguntas)
  - Indicadores de progreso durante validaciones
- **Disponibilidad:** 
  - Modo offline: la app permite capturas con batch pendiente de crear
  - Sincronización automática al recuperar conexión
- **Escalabilidad:** Soporte para múltiples dispositivos capturando simultáneamente la misma evaluación

### Criterios de aceptación (QA)
- **CA-1:** Al escanear un QR válido de evaluación **Applied**, se crea correctamente el `ingest_batch` y la app muestra confirmación con metadatos.
- **CA-2:** Si el QR/ID es inválido o la evaluación no está **Applied**, la vinculación se rechaza con mensaje específico.
- **CA-3:** El sistema previene múltiples batches **Open** para la misma evaluación/dispositivo, ofreciendo opciones de resolución.
- **CA-4:** En modo offline, la app guarda vinculación **pendiente** y sincroniza automáticamente al reconectarse.
- **CA-5:** Solo usuarios con permisos sobre el curso pueden crear batches para sus evaluaciones.
- **CA-6:** La coherencia entre `evaluation_fk` y `course_fk` se valida antes de crear el batch.
- **CA-7:** Todo intento de vinculación queda registrado en auditoría con detalles del dispositivo, usuario y resultado.

---

## Anexo Técnico (para desarrollo)

> Esta sección contiene los detalles técnicos de implementación según el modelo de datos del sistema de Ingesta Móvil.

### Resumen del modelo de datos

#### Entidades principales involucradas
- **`ingest_devices`**: Dispositivos móviles registrados que realizan capturas (teléfonos, tablets).
- **`ingest_batches`**: Sesiones/lotes de captura que agrupan todas las páginas de una evaluación específica en un bloque temporal.
- **`evaluations`**: Evaluaciones existentes en estado "Applied" que pueden recibir capturas móviles.
- **`courses`**: Cursos asociados a las evaluaciones, necesarios para validación de permisos.
- **`users`**: Registro de usuarios (docentes/asistentes) para autenticación y autorización.

#### Relaciones clave
- Un **lote de ingesta** se vincula a una **evaluación** específica (`evaluation_fk`) y debe coincidir con su curso (`course_fk`).
- Cada **lote** es iniciado por un **dispositivo** registrado (`device_fk`) y tiene validación de coherencia curso-evaluación.
- La jerarquía de procesamiento es: `ingest_batches → scanned_pages → page_qrs → page_detections → bubble_detections → recognition_mappings → ingest_results`.
- Solo puede existir **un lote abierto** por evaluación y dispositivo simultáneamente.

#### Campos críticos para este caso de uso
**En `ingest_batches`:**
- `evaluation_fk`, `course_fk` (obligatorios, con validación de coherencia)
- `device_fk` (dispositivo que inicia el lote), `state` (siempre 'Open' en creación)
- `started_at` (timestamp automático), `closed_at` (null hasta cierre manual)
- `notes` (opcional para observaciones del operador)

**En `ingest_devices`:**
- `name`, `platform` (ios/android/other), `active` (debe ser true para crear lotes)
- `registered_by_fk` (usuario que registró), `registered_at` (auditoría)
- `os_version`, `app_version` (metadatos técnicos)

#### Auditoría en Ingesta Móvil
El sistema de Ingesta Móvil usa **auditoría específica del pipeline** con timestamps de procesamiento (`registered_at`, `started_at`, `closed_at`, `decoded_at`, `processed_at`) en lugar del sistema estándar de soft delete. Esto permite:
- ✅ Trazabilidad completa del flujo de procesamiento
- ✅ Identificación de cuellos de botella en el pipeline
- ✅ Recuperación de estados intermedios para debugging

### Validaciones implementadas en base de datos

**Verificar estado de evaluación:**
```sql
SELECT e.evaluation_id, e.title, e.course_fk, e.state, c.name as course_name
FROM evaluations e
JOIN courses c ON e.course_fk = c.course_id
WHERE e.evaluation_id = :evaluation_id
AND e.state = 'Applied';
```

**Verificar permisos de usuario:**
```sql
-- Verificar que el usuario tiene acceso al curso de la evaluación
SELECT 1 FROM courses c
JOIN evaluations e ON c.course_id = e.course_fk
WHERE e.evaluation_id = :evaluation_id
AND c.user_fk = :user_id; -- o validación más compleja según modelo de permisos
```

**Verificar batch existente:**
```sql
SELECT ingest_batch_id, started_at
FROM ingest_batches
WHERE evaluation_fk = :evaluation_id
AND device_fk = :device_id
AND state = 'Open';
```

### Ejemplo de implementación (paso 6 del flujo principal)

```sql
-- 1. Validar estado de evaluación y permisos
WITH eval_check AS (
    SELECT e.evaluation_id, e.course_fk, c.name as course_name
    FROM evaluations e
    JOIN courses c ON e.course_fk = c.course_id
    WHERE e.evaluation_id = :evaluation_id
    AND e.state = 'Applied'
    -- Agregar validación de permisos según modelo de autorización
)
-- 2. Crear nuevo batch si no existe conflicto
INSERT INTO ingest_batches (
    evaluation_fk, course_fk, device_fk, 
    started_at, state, notes
) 
SELECT 
    :evaluation_id, 
    ec.course_fk, 
    :device_id,
    NOW(), 
    'Open', 
    :notes
FROM eval_check ec
WHERE NOT EXISTS (
    SELECT 1 FROM ingest_batches ib
    WHERE ib.evaluation_fk = :evaluation_id
    AND ib.device_fk = :device_id
    AND ib.state = 'Open'
)
RETURNING ingest_batch_id, started_at;
```

### Manejo de sincronización offline

**Datos guardados localmente:**
```json
{
  "pendingBatch": {
    "evaluationId": "12345",
    "deviceId": "device_001",
    "qrData": "encrypted_qr_payload",
    "timestamp": "2024-10-08T14:30:00Z",
    "notes": "Evaluación Matemáticas - Sala 201"
  },
  "evaluationMetadata": {
    "title": "Evaluación Matemáticas I",
    "courseName": "MAT101-2024-1",
    "questionCount": 25,
    "duration": 90
  }
}
```

**Proceso de sincronización:**
```sql
-- Al reconectarse, crear el batch pendiente
INSERT INTO ingest_batches (
    evaluation_fk, course_fk, device_fk, 
    started_at, state, notes
) VALUES (
    :evaluation_id, :course_id, :device_id,
    :original_timestamp, 'Open', :notes
) RETURNING ingest_batch_id;

-- Actualizar páginas capturadas offline
UPDATE scanned_pages 
SET ingest_batch_fk = :new_batch_id,
    status = 'Queued'
WHERE device_fk = :device_id 
AND ingest_batch_fk IS NULL
AND captured_at >= :session_start;
```

### Validación de coherencia curso-evaluación

Trigger que asegura que el curso del lote coincida con el curso de la evaluación:

```sql
CREATE OR REPLACE FUNCTION validate_batch_course_consistency()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM evaluations e
        WHERE e.evaluation_id = NEW.evaluation_fk
        AND e.course_fk = NEW.course_fk
    ) THEN
        RAISE EXCEPTION 'Course FK % does not match evaluation % course', 
            NEW.course_fk, NEW.evaluation_fk;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

### Índices recomendados
- `CREATE INDEX idx_ingest_batches_eval_device_state ON ingest_batches (evaluation_fk, device_fk, state);`
- `CREATE INDEX idx_ingest_batches_course_state ON ingest_batches (course_fk, state);`
- `CREATE INDEX idx_ingest_devices_active ON ingest_devices (active, registered_at);`

### Referencias al modelo completo
Para más detalles sobre la estructura completa, restricciones, tipos de datos y triggers:
- [Modelo Entidad-Relación completo](../../../../06-data-model/mobile-ingest/mer.md)
- [Script DDL de creación](../../../../06-data-model/mobile-ingest/DDL.sql)
- [Triggers y funciones](../../../../06-data-model/mobile-ingest/TRIGGERS.sql)

---

[Subir](#cu-im-01--vincular-captura-con-evaluación)
