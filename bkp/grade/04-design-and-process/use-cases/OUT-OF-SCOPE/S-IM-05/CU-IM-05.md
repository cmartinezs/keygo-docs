# CU-IM-05 — Operación offline y sincronización automática

- [Revisión](review.md)
- [Volver](../../README.md#3-ingesta-móvil)

## Escenario origen: S-IM-05 | Modo sin conexión y reintentos

### RF relacionados: RF4

**Actor principal:** Sistema GRADE (Gestor de sincronización)  
**Actores secundarios:** Docente/Asistente de aula, Base de datos local, Servicio de conectividad

---

### Objetivo
Garantizar operación continua del sistema de ingesta móvil durante pérdidas de conectividad, manteniendo la integridad de lotes de ingesta, páginas escaneadas y datos asociados en almacenamiento local, con sincronización automática inteligente al restablecer conexión.

### Precondiciones
- La aplicación está instalada con base de datos local configurada.
- Existe un lote de ingesta activo (puede estar sincronizado o pendiente).
- El dispositivo está registrado en el sistema (puede requerir re-validación).
- Hay espacio suficiente para almacenamiento local temporal.

### Postcondiciones
- Todas las operaciones offline quedan registradas en BD local con integridad completa.
- La sincronización automática transfiere exitosamente datos pendientes al servidor.
- Los conflictos de sincronización se resuelven según políticas configuradas.
- El usuario recibe notificación clara del estado de sincronización.
- Los datos locales se limpian apropiadamente después de sincronización exitosa.

### Flujo principal (éxito)
1. **Detección de pérdida de conectividad:**
   - El sistema detecta pérdida de conexión durante operación normal
   - Cambia automáticamente a **modo offline** sin interrumpir la sesión
   - Muestra indicador visual de estado offline al usuario
2. **Operación offline completa:**
   - **Creación de lotes:** Se almacena en BD local con estado **pendiente de crear**
   - **Captura de páginas:** Se registra páginas escaneadas localmente con imágenes en sistema de archivos
   - **Procesamiento local:** Ejecuta validaciones de calidad que no requieren servidor
   - **Metadatos completos:** Mantiene todos los campos del modelo de datos localmente
3. **Monitoreo de conectividad:**
   - Verifica conectividad cada 30 segundos (configurable)
   - Detecta cuando conexión estable está disponible (ping + timeout)
   - Inicia proceso de sincronización automáticamente
4. **Sincronización inteligente por fases:**
   - **Fase 1 - Validación de dispositivo:** Re-autentica dispositivo si es necesario
   - **Fase 2 - Sincronización de lotes:** Crea/actualiza lotes de ingesta pendientes
   - **Fase 3 - Upload de imágenes:** Transfiere archivos con verificación de integridad
   - **Fase 4 - Sincronización de páginas:** Crea/actualiza registros de páginas escaneadas
   - **Fase 5 - Procesamiento remoto:** Inicia trabajos de procesamiento en servidor
5. **Verificación y limpieza:**
   - Valida integridad de todos los datos sincronizados
   - Confirma que procesamiento remoto ha iniciado correctamente
   - Limpia archivos e imágenes locales ya sincronizadas
   - Actualiza estado de elementos locales como **sincronizado**
6. **Notificación de resultados:**
   - Informa al usuario sobre éxito de sincronización con detalles:
     - Cantidad de lotes sincronizados
     - Número de páginas transferidas exitosamente
     - Estado de procesamiento remoto iniciado
   - Retorna a modo online normal

### Flujos alternativos / Excepciones
- **A1 — Fallo de re-autenticación de dispositivo:**
  - Si el dispositivo no puede re-autenticarse, solicita login manual
  - Mantiene datos offline seguros hasta resolver autenticación
  - Permite continuar operación offline mientras se resuelve
- **A2 — Conflicto de lote existente:**
  - Si lote ya existe en servidor, compara timestamps y metadatos
  - Aplica política configurada: merge, sobrescribir, o crear nuevo lote
  - Notifica al usuario si requiere intervención manual
- **A3 — Fallo de transferencia de archivos:**
  - Reintenta upload con backoff exponencial (hasta 3 intentos)
  - Si persiste fallo, marca archivos específicos como pendientes
  - Continúa con otros archivos, reporta fallos al final
- **A4 — Espacio insuficiente en servidor:**
  - Detecta error de espacio durante upload
  - Pausa sincronización y notifica al administrador
  - Mantiene datos locales hasta resolver problema de capacidad
- **A5 — Corrupción de datos locales:**
  - Detecta inconsistencias durante preparación de sincronización
  - Marca elementos corruptos y sincroniza solo elementos válidos
  - Genera reporte de elementos perdidos para investigación
- **A6 — Timeout de sincronización:**
  - Si sincronización toma más tiempo del configurado, divide en lotes más pequeños
  - Mantiene progreso parcial y continúa desde donde quedó
  - Notifica al usuario sobre progreso y tiempo estimado restante

### Reglas de negocio
- **RN-1:** Toda operación realizada offline debe ser replicable en servidor al sincronizar.
- **RN-2:** Los datos locales deben mantener integridad referencial igual que el servidor.
- **RN-3:** La sincronización debe ser idempotente (repetible sin efectos secundarios).
- **RN-4:** Los archivos de imagen deben transferirse con verificación de hash SHA-256.
- **RN-5:** El modo offline no debe degradar significativamente la experiencia de usuario.
- **RN-6:** Los datos locales se conservan hasta confirmación explícita de sincronización exitosa.

### Datos principales
- **BD Local** (replica de estructura servidor: lotes, páginas, dispositivos, trabajos, logs)
- **Archivos de Imagen Local** (almacenamiento cifrado con hash de integridad)
- **Estado de Sincronización** (timestamps, fases completadas, elementos pendientes, errores)
- **Cola de Operaciones** (operaciones pendientes con prioridad y reintentos)
- **Metadatos de Conectividad** (historial de conexiones, calidad de red, configuración sync)

### Consideraciones de seguridad/permiso
- **Cifrado local:** Todos los datos sensibles cifrados en almacenamiento local.
- **Autenticación persistente:** Tokens de sesión con renovación automática.
- **Integridad:** Hash de verificación para todos los archivos transferidos.
- **Limpieza segura:** Borrado seguro de archivos temporales post-sincronización.
- **Auditoría offline:** Logs locales de todas las operaciones para posterior auditoría.

### No funcionales
- **Rendimiento:** 
  - Sincronización de lote típico < 5 minutos p95
  - Detección de conectividad < 3 segundos
- **Confiabilidad:** 
  - Tasa de éxito de sincronización > 99.5%
  - Recuperación automática de fallos transitorios
- **Usabilidad:** 
  - Transición transparente entre modos online/offline
  - Indicadores claros de estado y progreso de sincronización
- **Capacidad:** 
  - Almacenamiento local para hasta 500 páginas escaneadas
  - Compresión inteligente de imágenes para optimizar espacio

### Criterios de aceptación (QA)
- **CA-1:** Al perder conectividad, debe continuar operando sin pérdida de funcionalidad crítica.
- **CA-2:** Lotes creados offline deben sincronizarse correctamente y generar ID válido en servidor.
- **CA-3:** Páginas capturadas offline deben transferirse con integridad SHA-256 verificada.
- **CA-4:** Conflictos de sincronización deben resolverse según políticas sin pérdida de datos.
- **CA-5:** Al completar sincronización exitosa, debe limpiar datos locales redundantes.
- **CA-6:** Errores de sincronización deben reportarse con detalles específicos y acciones sugeridas.
- **CA-7:** El modo offline debe funcionar por al menos 8 horas continuas sin degradación.

---

## Anexo Técnico (para desarrollo)

> Esta sección contiene los detalles técnicos de implementación del sistema offline y sincronización según el modelo de datos del sistema de Ingesta Móvil.

### Resumen del modelo de datos

#### Entidades principales involucradas
**Base de Datos Local (SQLite/similar):**
- **`local_ingest_batches`**: Replica de `ingest_batches` con campos adicionales de estado de sincronización.
- **`local_scanned_pages`**: Replica de `scanned_pages` con rutas locales y metadatos de transferencia.
- **`local_sync_queue`**: Cola de operaciones pendientes de sincronización con prioridades.
- **`local_sync_log`**: Historial de intentos de sincronización con resultados y errores.
- **`local_device_state`**: Estado del dispositivo, tokens de autenticación y configuración.

**Estados de Sincronización:**
- **`pending`**: Creado localmente, no sincronizado
- **`syncing`**: En proceso de sincronización
- **`synced`**: Sincronizado exitosamente
- **`failed`**: Falló sincronización, requiere retry
- **`conflict`**: Conflicto detectado, requiere resolución

#### Relaciones clave
- Los **datos locales** mantienen la misma estructura relacional que el servidor.
- La **cola de sincronización** prioriza operaciones según dependencias (lotes antes que páginas).
- El **log de sincronización** permite rastrear y reintentar operaciones fallidas.
- Los **archivos locales** se enlazan con registros de BD local mediante rutas cifradas.

#### Campos críticos para este caso de uso
**En `local_ingest_batches`:**
- `sync_state` (pending/syncing/synced/failed), `server_id` (null hasta sincronizar)
- `sync_attempts` (contador de reintentos), `last_sync_attempt` (timestamp)
- `conflict_reason` (si hay conflicto), `local_created_at` (timestamp offline)

**En `local_scanned_pages`:**
- `local_image_path` (ruta cifrada), `sync_state`, `upload_progress` (0-100%)
- `server_id` (null hasta sincronizar), `hash_verified` (boolean)

**En `local_sync_queue`:**
- `operation_type` (create_batch/upload_page/etc.), `priority` (1-10)
- `payload` (JSONB con datos), `retry_count`, `next_retry_at`

#### Arquitectura de Sincronización
El sistema usa **sincronización en fases** con **dependencias ordenadas** y **recuperación granular** de errores.

### Validaciones implementadas en base de datos

**Verificar elementos pendientes de sincronización:**
```sql
-- Base de datos local (SQLite)
SELECT lb.local_batch_id, lb.evaluation_fk, lb.sync_state, lb.sync_attempts
FROM local_ingest_batches lb
WHERE lb.sync_state IN ('pending', 'failed')
AND (lb.next_retry_at IS NULL OR lb.next_retry_at <= datetime('now'))
ORDER BY lb.local_created_at;
```

**Verificar integridad antes de sincronización:**
```sql
-- Validar que todas las páginas tienen archivos existentes
SELECT lsp.local_page_id, lsp.local_image_path, lsp.image_sha256
FROM local_scanned_pages lsp
WHERE lsp.sync_state = 'pending'
AND NOT EXISTS (
    SELECT 1 FROM file_system 
    WHERE file_path = lsp.local_image_path
);
```

### Ejemplo de implementación de sincronización por fases

```javascript
// Controlador principal de sincronización
class OfflineSyncManager {
    async performFullSync() {
        try {
            // Fase 1: Validar dispositivo
            await this.validateDeviceAuthentication();
            
            // Fase 2: Sincronizar lotes
            const pendingBatches = await this.getPendingBatches();
            for (const batch of pendingBatches) {
                await this.syncBatch(batch);
            }
            
            // Fase 3: Upload de imágenes
            const pendingImages = await this.getPendingImages();
            await this.uploadImagesInParallel(pendingImages);
            
            // Fase 4: Sincronizar páginas
            const pendingPages = await this.getPendingPages();
            for (const page of pendingPages) {
                await this.syncPage(page);
            }
            
            // Fase 5: Iniciar procesamiento remoto
            await this.triggerRemoteProcessing();
            
            // Fase 6: Limpiar datos locales
            await this.cleanupSyncedData();
            
        } catch (error) {
            await this.handleSyncError(error);
        }
    }
}
```

**Sincronización de lotes con resolución de conflictos:**
```sql
-- En servidor: crear lote desde datos offline
INSERT INTO ingest_batches (
    evaluation_fk, course_fk, device_fk,
    started_at, state, notes
) VALUES (
    :evaluation_fk, :course_fk, :device_fk,
    :original_offline_timestamp, 'Open', 
    CONCAT(:original_notes, ' [Synced from offline]')
)
ON CONFLICT (evaluation_fk, device_fk) 
WHERE state = 'Open'
DO UPDATE SET 
    notes = CONCAT(ingest_batches.notes, ' [Merged with offline data]')
RETURNING ingest_batch_id;
```

### Manejo de archivos y transferencia

**Preparación de archivos para upload:**
```javascript
async function prepareImageForUpload(localImagePath, expectedHash) {
    // 1. Verificar integridad local
    const actualHash = await calculateSHA256(localImagePath);
    if (actualHash !== expectedHash) {
        throw new Error(`Hash mismatch: expected ${expectedHash}, got ${actualHash}`);
    }
    
    // 2. Comprimir si es necesario
    const compressedPath = await compressImageIfLarge(localImagePath);
    
    // 3. Cifrar para transferencia
    const encryptedBuffer = await encryptFile(compressedPath);
    
    return {
        originalPath: localImagePath,
        transferBuffer: encryptedBuffer,
        originalHash: expectedHash,
        compressedSize: encryptedBuffer.length
    };
}
```

**Upload con verificación de integridad:**
```javascript
async function uploadImageWithVerification(imageData, pageRecord) {
    const uploadResult = await fetch('/api/mobile-ingest/upload', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/octet-stream',
            'X-Original-Hash': imageData.originalHash,
            'X-Page-Metadata': JSON.stringify(pageRecord)
        },
        body: imageData.transferBuffer
    });
    
    if (!uploadResult.ok) {
        throw new Error(`Upload failed: ${uploadResult.statusText}`);
    }
    
    const serverResponse = await uploadResult.json();
    
    // Verificar que el servidor confirmó el hash
    if (serverResponse.verified_hash !== imageData.originalHash) {
        throw new Error('Server hash verification failed');
    }
    
    return serverResponse.image_uri;
}
```

### Gestión de conectividad y reintentos

**Monitor de conectividad:**
```javascript
class ConnectivityMonitor {
    constructor() {
        this.isOnline = navigator.onLine;
        this.checkInterval = 30000; // 30 seconds
        this.retryBackoff = [5000, 15000, 60000, 300000]; // exponential backoff
    }
    
    async checkConnectivity() {
        try {
            const response = await fetch('/api/health/ping', {
                method: 'HEAD',
                timeout: 5000
            });
            return response.ok;
        } catch (error) {
            return false;
        }
    }
    
    async waitForConnectivity() {
        while (!await this.checkConnectivity()) {
            await new Promise(resolve => setTimeout(resolve, this.checkInterval));
        }
        return true;
    }
}
```

### Limpieza de datos post-sincronización

**Limpieza segura de archivos:**
```sql
-- Marcar archivos para limpieza
UPDATE local_scanned_pages 
SET cleanup_eligible = true,
    cleanup_scheduled_at = datetime('now', '+1 hour')
WHERE sync_state = 'synced'
AND server_id IS NOT NULL
AND cleanup_eligible = false;

-- Proceso de limpieza (ejecutado por tarea programada)
DELETE FROM local_scanned_pages
WHERE cleanup_eligible = true
AND cleanup_scheduled_at <= datetime('now')
AND sync_state = 'synced';
```

### Índices recomendados para BD local
- `CREATE INDEX idx_local_batches_sync_state ON local_ingest_batches (sync_state, next_retry_at);`
- `CREATE INDEX idx_local_pages_sync_pending ON local_scanned_pages (sync_state, local_created_at);`
- `CREATE INDEX idx_sync_queue_priority ON local_sync_queue (priority DESC, next_retry_at);`

### Referencias al modelo completo
Para más detalles sobre la estructura completa, restricciones, tipos de datos y triggers:
- [Modelo Entidad-Relación completo](../../../../06-data-model/mobile-ingest/mer.md)
- [Script DDL de creación](../../../../06-data-model/mobile-ingest/DDL.sql)
- [Triggers y funciones](../../../../06-data-model/mobile-ingest/TRIGGERS.sql)

---

[Subir](#cu-im-05--operación-offline-y-sincronización-automática)
