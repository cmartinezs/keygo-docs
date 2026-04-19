# CU-IM-07 — Gestión de dispositivos móviles

- [Revisión](review.md)
- [Volver](../../README.md#3-ingesta-móvil)

## Escenario origen: S-IM-07 | Registro y administración de dispositivos

### RF relacionados: RF4, RF7, RF8

**Actor principal:** Docente / Asistente de aula  
**Actores secundarios:** Administrador, Sistema GRADE (Gestión de dispositivos)

---

### Objetivo
Permitir el registro, activación, gestión y revocación de dispositivos móviles autorizados para realizar ingesta de respuestas, garantizando control de acceso y trazabilidad completa de los dispositivos utilizados en el sistema.

### Precondiciones
- Usuario autenticado con permisos para gestionar dispositivos en su ámbito (curso/institución).
- El dispositivo móvil tiene la aplicación GRADE instalada.
- Conexión a internet disponible para el registro inicial.
- Política de dispositivos configurada a nivel institucional.

### Postcondiciones
- Dispositivo registrado y asociado al usuario en el sistema.
- Permisos de ingesta otorgados según rol y ámbito del usuario.
- Dispositivo aparece en listado de dispositivos activos del usuario/administrador.
- Todas las operaciones del dispositivo quedan trazables en auditoría.
- Token de autenticación del dispositivo generado y válido.

### Flujo principal (éxito)
1. **Solicitud de registro:**
   - Usuario abre la app en dispositivo nuevo
   - Selecciona **"Registrar este dispositivo"**
   - Ingresa credenciales de usuario (email/password)
2. **Autenticación y validación:**
   - Sistema autentica al usuario
   - Verifica permisos para registrar dispositivos
   - Valida políticas institucionales (límite de dispositivos, tipos permitidos)
3. **Captura de información del dispositivo:**
   - App recolecta metadatos del dispositivo:
     - Modelo, sistema operativo, versión
     - Identificador único del dispositivo (IMEI/UUID)
     - Versión de la aplicación GRADE
     - Nombre personalizado (opcional)
4. **Registro en el sistema:**
   - Sistema crea registro de dispositivo de ingesta
   - Asocia dispositivo al usuario y sus cursos/permisos
   - Genera token de autenticación único
   - Establece estado **Activo** por defecto
5. **Confirmación y configuración:**
   - App recibe confirmación de registro exitoso
   - Descarga configuraciones específicas (templates, políticas)
   - Muestra dispositivo como **Registrado y Activo**
   - Usuario puede comenzar a usar funciones de ingesta
6. **Notificación de seguridad:**
   - Sistema envía notificación al usuario sobre nuevo dispositivo registrado
   - Administrador recibe alerta si aplican políticas especiales

### Flujos alternativos / Excepciones
- **A1 — Límite de dispositivos excedido:**
  - Sistema rechaza registro indicando límite alcanzado
  - Ofrece opciones: desactivar dispositivo existente, solicitar aumento de límite
  - Escalación automática a administrador si es necesario
- **A2 — Dispositivo ya registrado:**
  - Sistema detecta dispositivo previamente registrado
  - Ofrece opciones: reactivar, generar nuevo token, cambiar asociación de usuario
- **A3 — Credenciales inválidas:**
  - Sistema rechaza con mensaje de error de autenticación
  - Permite reintentar con opción de recuperación de contraseña
- **A4 — Dispositivo no compatible:**
  - Sistema verifica compatibilidad (OS, versión, capacidades)
  - Rechaza dispositivos que no cumplen requisitos mínimos
  - Proporciona información sobre requisitos técnicos
- **A5 — Sin permisos para registrar:**
  - Usuario no tiene rol que permita registrar dispositivos
  - Sistema rechaza con mensaje explicativo
  - Escalación a administrador para otorgar permisos si procede
- **A6 — Fallo de conectividad:**
  - App mantiene datos de registro en cola local
  - Reintenta automáticamente al recuperar conexión
  - Permite uso limitado (solo offline) hasta completar registro
- **A7 — Revocación de dispositivo:**
  - Usuario o administrador puede desactivar dispositivo desde panel web
  - Dispositivo pierde acceso inmediatamente (token invalidado)
  - Datos locales se marcan para limpieza en próxima conexión

### Reglas de negocio
- **RN-1:** Cada usuario puede registrar máximo 3 dispositivos activos simultáneamente.
- **RN-2:** Solo dispositivos con OS mínimo (iOS 12+, Android 8+) pueden registrarse.
- **RN-3:** Dispositivos inactivos por más de 90 días se desactivan automáticamente.
- **RN-4:** Un dispositivo solo puede estar asociado a un usuario a la vez.
- **RN-5:** La revocación de dispositivo es inmediata y no reversible.
- **RN-6:** Todos los cambios de estado de dispositivo quedan auditados.

### Datos principales
- **Dispositivo de Ingesta** (identificador, nombre, plataforma, OS, versión app, usuario registrador, fecha registro, activo)
- **Token de Dispositivo** (token, dispositivo, fecha emisión, fecha expiración, revocado)
- **Sesión de Dispositivo** (dispositivo, fecha inicio, fecha fin, IP, actividad)
- **Política de Dispositivos** (institución, límite por usuario, OS mínimo, validez token)
- **Auditoría de Dispositivos** (dispositivo, acción, usuario, timestamp, detalles)

### Consideraciones de seguridad/permiso
- **Autenticación fuerte:** Registro requiere credenciales completas del usuario.
- **Tokens seguros:** Tokens de dispositivo con expiración y rotación periódica.
- **Trazabilidad completa:** Todos los eventos de dispositivo quedan registrados.
- **Revocación inmediata:** Capacidad de invalidar acceso instantáneamente.
- **Validación de integridad:** Verificación de que dispositivo no está comprometido.

### No funcionales
- **Rendimiento:** 
  - Registro de dispositivo < 10s p95
  - Validación de token < 100ms p95
- **Seguridad:** 
  - Tokens con rotación cada 30 días
  - Detección de anomalías de uso
- **Usabilidad:** 
  - Proceso de registro intuitivo y autoguiado
  - Gestión centralizada desde panel web
- **Disponibilidad:** 
  - Registro funciona con conectividad intermitente
  - Sincronización de estado al reconectar

### Criterios de aceptación (QA)
- **CA-1:** Usuario con permisos válidos debe poder registrar dispositivo en < 10 segundos.
- **CA-2:** Sistema debe rechazar dispositivo si usuario excede límite configurado.
- **CA-3:** Dispositivo registrado debe poder crear lotes de ingesta inmediatamente.
- **CA-4:** Revocación de dispositivo debe invalidar acceso en < 30 segundos.
- **CA-5:** Información de dispositivos debe ser visible en panel de administración.
- **CA-6:** Cambios de estado deben notificarse al usuario por canal preferido.
- **CA-7:** Dispositivos inactivos > 90 días deben desactivarse automáticamente.

---

## Anexo Técnico (para desarrollo)

> Esta sección contiene los detalles técnicos de implementación del sistema de gestión de dispositivos según el modelo de datos del sistema de Ingesta Móvil.

### Resumen del modelo de datos

#### Entidades principales involucradas
- **`ingest_devices`**: Registro principal de dispositivos con metadatos técnicos y estado.
- **`device_tokens`**: Tokens de autenticación específicos por dispositivo con expiración.
- **`device_sessions`**: Sesiones activas de dispositivos para monitoreo y control.
- **`users`**: Usuarios propietarios de dispositivos con roles y permisos.
- **`device_policies`**: Políticas institucionales que controlan registro y uso.
- **`device_audit_log`**: Auditoría completa de eventos de dispositivos.

#### Relaciones clave
- Cada **dispositivo** pertenece a un **usuario** específico (`registered_by_fk`).
- Los **tokens de dispositivo** se generan y rotan periódicamente para autenticación segura.
- Las **sesiones** rastrean el uso activo y permiten control granular de acceso.
- Las **políticas** definen límites y restricciones a nivel institucional.
- La **auditoría** registra todos los cambios de estado y eventos importantes.

#### Campos críticos para este caso de uso
**En `ingest_devices`:**
- `name` (nombre personalizable), `platform` (ios/android/other), `os_version`
- `registered_by_fk` (usuario propietario), `registered_at`, `active` (estado)
- `device_uuid` (identificador único), `app_version` (versión instalada)

**En `device_tokens`:**
- `device_fk` (dispositivo asociado), `token_hash` (hash del token)
- `issued_at`, `expires_at`, `revoked_at` (gestión de ciclo de vida)

**En `device_sessions`:**
- `device_fk`, `started_at`, `last_activity`, `ip_address`
- `user_agent`, `active` (estado de sesión)

#### Arquitectura de Seguridad
El sistema usa **tokens JWT rotatorios**, **validación por sesión**, y **revocación inmediata** con notificaciones push para dispositivos.

### Validaciones implementadas en base de datos

**Verificar límite de dispositivos por usuario:**
```sql
SELECT COUNT(*) as active_devices
FROM ingest_devices
WHERE registered_by_fk = :user_id
AND active = true;

-- Validar contra política institucional
SELECT dp.max_devices_per_user
FROM device_policies dp
JOIN users u ON dp.institution_fk = u.institution_fk
WHERE u.user_id = :user_id;
```

**Verificar dispositivo existente:**
```sql
SELECT device_id, active, registered_by_fk
FROM ingest_devices
WHERE device_uuid = :device_uuid
OR (name = :device_name AND registered_by_fk = :user_id);
```

**Validar compatibilidad de dispositivo:**
```sql
-- Verificar OS mínimo según política
SELECT 
    CASE 
        WHEN :platform = 'ios' AND 
             CAST(SPLIT_PART(:os_version, '.', 1) AS INTEGER) >= dp.min_ios_version 
        THEN true
        WHEN :platform = 'android' AND 
             CAST(SPLIT_PART(:os_version, '.', 1) AS INTEGER) >= dp.min_android_version 
        THEN true
        ELSE false
    END as is_compatible
FROM device_policies dp
JOIN users u ON dp.institution_fk = u.institution_fk
WHERE u.user_id = :user_id;
```

### Ejemplo de implementación del registro completo

```sql
-- PASO 1: Validar precondiciones
WITH user_check AS (
    SELECT u.user_id, u.institution_fk, dp.max_devices_per_user, dp.min_ios_version
    FROM users u
    JOIN device_policies dp ON u.institution_fk = dp.institution_fk
    WHERE u.user_id = :user_id
),
device_count AS (
    SELECT COUNT(*) as current_devices
    FROM ingest_devices id
    WHERE id.registered_by_fk = :user_id AND id.active = true
)
-- PASO 2: Registrar dispositivo si pasa validaciones
INSERT INTO ingest_devices (
    name, platform, os_version, app_version, device_uuid,
    registered_by_fk, registered_at, active
)
SELECT 
    :device_name, :platform, :os_version, :app_version, :device_uuid,
    :user_id, NOW(), true
FROM user_check uc, device_count dc
WHERE dc.current_devices < uc.max_devices_per_user
AND (:platform != 'ios' OR CAST(SPLIT_PART(:os_version, '.', 1) AS INTEGER) >= uc.min_ios_version)
RETURNING device_id;

-- PASO 3: Generar token de autenticación
INSERT INTO device_tokens (
    device_fk, token_hash, issued_at, expires_at
) VALUES (
    :new_device_id, 
    :token_hash,
    NOW(),
    NOW() + INTERVAL '30 days'
) RETURNING token_hash;

-- PASO 4: Crear sesión inicial
INSERT INTO device_sessions (
    device_fk, started_at, last_activity, ip_address, user_agent, active
) VALUES (
    :new_device_id, NOW(), NOW(), :client_ip, :user_agent, true
);
```

### Gestión de tokens y sesiones

**Rotación automática de tokens:**
```sql
-- Función para rotar token antes de expiración
CREATE OR REPLACE FUNCTION rotate_device_token(device_id BIGINT)
RETURNS TEXT AS $$
DECLARE
    new_token_hash TEXT;
    new_token TEXT;
BEGIN
    -- Generar nuevo token
    new_token := encode(gen_random_bytes(32), 'base64');
    new_token_hash := encode(digest(new_token, 'sha256'), 'hex');
    
    -- Invalidar token actual
    UPDATE device_tokens 
    SET revoked_at = NOW()
    WHERE device_fk = device_id AND revoked_at IS NULL;
    
    -- Insertar nuevo token
    INSERT INTO device_tokens (
        device_fk, token_hash, issued_at, expires_at
    ) VALUES (
        device_id, new_token_hash, NOW(), NOW() + INTERVAL '30 days'
    );
    
    -- Registrar en auditoría
    INSERT INTO device_audit_log (
        device_fk, action, performed_by, timestamp, details
    ) VALUES (
        device_id, 'token_rotated', 'system', NOW(), 
        jsonb_build_object('reason', 'automatic_rotation')
    );
    
    RETURN new_token;
END;
$$ LANGUAGE plpgsql;
```

**Validación y revocación de acceso:**
```sql
-- Validar token y sesión activa
CREATE OR REPLACE FUNCTION validate_device_access(token_value TEXT, client_ip TEXT)
RETURNS TABLE (
    device_id BIGINT,
    user_id BIGINT,
    is_valid BOOLEAN,
    expires_at TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        id.device_id,
        id.registered_by_fk,
        (dt.expires_at > NOW() AND dt.revoked_at IS NULL AND id.active = true) as is_valid,
        dt.expires_at
    FROM device_tokens dt
    JOIN ingest_devices id ON dt.device_fk = id.device_id
    WHERE dt.token_hash = encode(digest(token_value, 'sha256'), 'hex')
    ORDER BY dt.issued_at DESC
    LIMIT 1;
    
    -- Actualizar última actividad si es válido
    UPDATE device_sessions
    SET last_activity = NOW(), ip_address = client_ip
    WHERE device_fk = (
        SELECT id.device_id FROM ingest_devices id
        JOIN device_tokens dt ON id.device_id = dt.device_fk
        WHERE dt.token_hash = encode(digest(token_value, 'sha256'), 'hex')
        AND dt.expires_at > NOW() AND dt.revoked_at IS NULL
    ) AND active = true;
END;
$$ LANGUAGE plpgsql;
```

### Panel de administración de dispositivos

**Vista consolidada para administradores:**
```sql
CREATE VIEW device_management_dashboard AS
SELECT 
    id.device_id,
    id.name as device_name,
    id.platform,
    id.os_version,
    id.app_version,
    u.email as owner_email,
    u.full_name as owner_name,
    id.registered_at,
    id.active,
    ds.last_activity,
    dt.expires_at as token_expires,
    CASE 
        WHEN ds.last_activity > NOW() - INTERVAL '5 minutes' THEN 'online'
        WHEN ds.last_activity > NOW() - INTERVAL '1 hour' THEN 'recent'
        ELSE 'offline'
    END as status,
    (SELECT COUNT(*) FROM ingest_batches ib WHERE ib.device_fk = id.device_id) as total_batches
FROM ingest_devices id
JOIN users u ON id.registered_by_fk = u.user_id
LEFT JOIN device_sessions ds ON id.device_id = ds.device_fk AND ds.active = true
LEFT JOIN device_tokens dt ON id.device_id = dt.device_fk AND dt.revoked_at IS NULL;
```

### Automatización y mantenimiento

**Limpieza automática de dispositivos inactivos:**
```sql
-- Tarea programada para desactivar dispositivos inactivos
CREATE OR REPLACE FUNCTION cleanup_inactive_devices()
RETURNS INTEGER AS $$
DECLARE
    affected_count INTEGER;
BEGIN
    -- Desactivar dispositivos sin actividad por 90+ días
    UPDATE ingest_devices 
    SET active = false
    WHERE active = true
    AND device_id IN (
        SELECT id.device_id
        FROM ingest_devices id
        LEFT JOIN device_sessions ds ON id.device_id = ds.device_fk
        WHERE ds.last_activity < NOW() - INTERVAL '90 days'
        OR ds.last_activity IS NULL
    );
    
    GET DIAGNOSTICS affected_count = ROW_COUNT;
    
    -- Registrar en auditoría
    INSERT INTO device_audit_log (
        device_fk, action, performed_by, timestamp, details
    )
    SELECT 
        device_id, 'auto_deactivated', 'system', NOW(),
        jsonb_build_object('reason', 'inactive_90_days')
    FROM ingest_devices
    WHERE active = false 
    AND device_id IN (
        SELECT device_id FROM ingest_devices 
        WHERE active = false 
        ORDER BY device_id DESC 
        LIMIT affected_count
    );
    
    RETURN affected_count;
END;
$$ LANGUAGE plpgsql;

-- Programar ejecución diaria
SELECT cron.schedule('cleanup-devices', '0 2 * * *', 'SELECT cleanup_inactive_devices();');
```

### API REST para gestión de dispositivos

**Endpoints principales:**
```javascript
// POST /api/devices/register
app.post('/api/devices/register', async (req, res) => {
    const { deviceName, platform, osVersion, deviceUuid } = req.body;
    const userId = req.user.id;
    
    try {
        // Validar límites y compatibilidad
        const validation = await validateDeviceRegistration(userId, platform, osVersion);
        if (!validation.allowed) {
            return res.status(400).json({ error: validation.reason });
        }
        
        // Registrar dispositivo
        const device = await registerDevice({
            name: deviceName,
            platform,
            osVersion,
            deviceUuid,
            registeredBy: userId
        });
        
        // Generar token
        const token = await generateDeviceToken(device.deviceId);
        
        res.json({
            deviceId: device.deviceId,
            token: token,
            expiresAt: device.tokenExpiresAt
        });
        
    } catch (error) {
        res.status(500).json({ error: 'Registration failed' });
    }
});

// DELETE /api/devices/:deviceId/revoke
app.delete('/api/devices/:deviceId/revoke', async (req, res) => {
    const { deviceId } = req.params;
    const userId = req.user.id;
    
    // Validar propiedad del dispositivo
    const device = await getDeviceByIdAndOwner(deviceId, userId);
    if (!device) {
        return res.status(404).json({ error: 'Device not found' });
    }
    
    // Revocar acceso
    await revokeDeviceAccess(deviceId, userId);
    
    res.json({ message: 'Device revoked successfully' });
});
```

### Índices recomendados
- `CREATE UNIQUE INDEX idx_ingest_devices_uuid ON ingest_devices (device_uuid);`
- `CREATE INDEX idx_ingest_devices_user_active ON ingest_devices (registered_by_fk, active);`
- `CREATE INDEX idx_device_tokens_device_active ON device_tokens (device_fk, revoked_at);`
- `CREATE INDEX idx_device_sessions_device_active ON device_sessions (device_fk, active, last_activity);`

### Referencias al modelo completo
Para más detalles sobre la estructura completa, restricciones, tipos de datos y triggers:
- [Modelo Entidad-Relación completo](../../../../06-data-model/mobile-ingest/mer.md)
- [Script DDL de creación](../../../../06-data-model/mobile-ingest/DDL.sql)
- [Triggers y funciones](../../../../06-data-model/mobile-ingest/TRIGGERS.sql)

---

[Subir](#cu-im-07--gestión-de-dispositivos-móviles)
