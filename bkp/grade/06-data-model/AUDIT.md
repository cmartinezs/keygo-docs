# Guía de Auditoría Soft - Sistema GRADE

[Volver al índice](README.md)

<!-- TOC -->
* [Guía de Auditoría Soft - Sistema GRADE](#guía-de-auditoría-soft---sistema-grade)
  * [Introducción](#introducción)
  * [Alcance](#alcance)
  * [Campos de Auditoría Estándar](#campos-de-auditoría-estándar)
    * [Interpretación de los valores](#interpretación-de-los-valores)
  * [Excepciones a la Regla](#excepciones-a-la-regla)
    * [Tablas sin auditoría completa](#tablas-sin-auditoría-completa)
      * [Tabla raíz de usuarios](#tabla-raíz-de-usuarios)
    * [Casos especiales](#casos-especiales)
  * [Operaciones y Auditoría](#operaciones-y-auditoría)
    * [1. Creación (INSERT)](#1-creación-insert)
    * [2. Modificación (UPDATE)](#2-modificación-update)
    * [3. Eliminación Lógica (Soft Delete)](#3-eliminación-lógica-soft-delete)
    * [4. Recuperación (Undelete)](#4-recuperación-undelete)
  * [Consultas con Auditoría](#consultas-con-auditoría)
    * [Obtener solo registros activos (patrón estándar)](#obtener-solo-registros-activos-patrón-estándar)
    * [Obtener registros eliminados](#obtener-registros-eliminados)
    * [Historial de cambios de un registro](#historial-de-cambios-de-un-registro)
    * [Registros modificados recientemente](#registros-modificados-recientemente)
  * [Triggers Automáticos (Recomendado)](#triggers-automáticos-recomendado)
    * [Función genérica reutilizable](#función-genérica-reutilizable)
    * [Aplicar a cada tabla con auditoría](#aplicar-a-cada-tabla-con-auditoría)
  * [Configuración a Nivel de Aplicación](#configuración-a-nivel-de-aplicación)
    * [Establecer el usuario actual en cada transacción](#establecer-el-usuario-actual-en-cada-transacción)
  * [Vistas Recomendadas](#vistas-recomendadas)
  * [Índices para Rendimiento](#índices-para-rendimiento)
    * [Patrón estándar de índices](#patrón-estándar-de-índices)
    * [Ejemplos concretos](#ejemplos-concretos)
  * [Políticas de Retención](#políticas-de-retención)
    * [Limpieza de registros eliminados (opcional)](#limpieza-de-registros-eliminados-opcional)
  * [Buenas Prácticas](#buenas-prácticas)
    * [✅ DO (Hacer)](#-do-hacer)
    * [❌ DON'T (No hacer)](#-dont-no-hacer)
  * [Diferencias con Auditoría Centralizada](#diferencias-con-auditoría-centralizada)
  * [Roadmap de Auditoría](#roadmap-de-auditoría)
    * [✅ Fase 1: Auditoría Soft (Actual)](#-fase-1-auditoría-soft-actual)
    * [🔜 Fase 2: Auditoría Centralizada (Futuro)](#-fase-2-auditoría-centralizada-futuro)
    * [🔮 Fase 3: Event Sourcing (Largo plazo)](#-fase-3-event-sourcing-largo-plazo)
  * [Documentos Relacionados](#documentos-relacionados)
  * [Resumen Ejecutivo](#resumen-ejecutivo)
<!-- TOC -->

---

## Introducción

El **Sistema GRADE** implementa un sistema de **auditoría soft (soft audit)** transversal a todos sus módulos que registra automáticamente quién y cuándo realizó cada operación sobre los datos, sin necesidad de una tabla de auditoría centralizada.

Este enfoque permite:
- ✅ **Trazabilidad completa** de todas las operaciones
- ✅ **Soft delete** (eliminación lógica) en lugar de eliminación física
- ✅ **Recuperación de datos** eliminados accidentalmente
- ✅ **Cumplimiento normativo** con registros de auditoría embebidos
- ✅ **Rendimiento óptimo** sin consultas adicionales a tablas de log
- ✅ **Consistencia** entre todos los módulos del sistema

---

## Alcance

Este sistema de auditoría aplica a **todos los módulos** de GRADE:

- ✅ **Banco de Preguntas** (Question Bank)
- ✅ **Gestión de Evaluaciones** (Grading Management)
- ✅ **Ingesta Móvil** (Mobile Ingest)
- ✅ Futuros módulos del sistema

---

## Campos de Auditoría Estándar

**Todas las tablas principales** de todos los módulos deben incluir estos campos:

| Campo        | Tipo        | Propósito                                        | Valor por Defecto | Restricciones |
|--------------|-------------|--------------------------------------------------|-------------------|---------------|
| `created_at` | TIMESTAMPTZ | Fecha/hora de creación del registro              | `now()`           | NOT NULL      |
| `created_by` | BIGINT      | Usuario que creó el registro (FK → users)        | -                 | NOT NULL      |
| `updated_at` | TIMESTAMPTZ | Fecha/hora de última modificación                | NULL              | NULL          |
| `updated_by` | BIGINT      | Usuario que modificó el registro (FK → users)    | NULL              | NULL, FK      |
| `deleted_at` | TIMESTAMPTZ | Fecha/hora de eliminación lógica                 | NULL              | NULL          |
| `deleted_by` | BIGINT      | Usuario que eliminó el registro (FK → users)     | NULL              | NULL, FK      |

### Interpretación de los valores

- **`created_at` / `created_by`**: Siempre tienen valor (NOT NULL) y **nunca cambian** después de la creación.
- **`updated_at` / `updated_by`**: Son NULL si el registro nunca ha sido modificado. Se actualizan cada vez que se modifica el registro.
- **`deleted_at` / `deleted_by`**: Son NULL si el registro está activo. Cuando se "eliminan", se marcan con timestamp y usuario.

---

## Excepciones a la Regla

### Tablas sin auditoría completa

**No requieren campos de auditoría:**

1. **Catálogos estáticos** (datos de configuración que rara vez cambian):
   - `question_types`
   - `difficulties`
   - Otros catálogos de configuración inicial

2. **Tablas de detalle** (heredan trazabilidad del padre):
   - Banco de Preguntas: `question_options` (hereda de `questions`)
   - Gestión de Evaluaciones: `evaluation_questions`, `evaluation_options`, `student_answers`, `student_answer_options` (heredan de su padre funcional)
   - Otras tablas de detalle 1:N

3. **Tablas de relación muchos-a-muchos puras**:
   - Tablas de unión sin atributos propios

4. **Tablas de log/procesamiento técnico (inmutables o históricas)**:
   - Ingesta Móvil: `scanned_pages`, `page_qrs`, `page_detections`, `bubble_detections`, `recognition_mappings`, `processing_jobs`, `processing_logs`
   - Justificación: actúan como registros de proceso y evidencia técnica; no aplican `soft delete` ni `created_by/updated_by` (la trazabilidad reside en campos propios como `registered_at`, `captured_at`, `decoded_at`, `started_at/finished_at`, etc.).

#### Tabla raíz de usuarios

- `users`: no requiere `created_by` por ser tabla raíz del sistema. Sí aplica `updated_at/updated_by` y `deleted_at/deleted_by`. 

### Casos especiales

**Tablas con campos equivalentes** (mantener nombres originales si ya existen):
- `questions.user_fk` equivale a `created_by` (autor de la versión)
- `evaluations.user_fk` equivale a `created_by` (creador/owner de la evaluación)
- Otros casos similares donde ya existe un campo con propósito equivalente

---

## Operaciones y Auditoría

### 1. Creación (INSERT)

```sql
-- Ejemplo genérico para cualquier tabla
INSERT INTO <tabla> (
    <campos_negocio>,
    created_by  -- Usuario actual
) VALUES (
    <valores>,
    :current_user_id
);

-- created_at se llena automáticamente con now()
-- Los demás campos de auditoría quedan en NULL
```

**Resultado:**
```
<primary_key>: 1
<campos_negocio>: <valores>
created_at: 2025-10-06 10:30:00
created_by: 123
updated_at: NULL
updated_by: NULL
deleted_at: NULL
deleted_by: NULL
```

### 2. Modificación (UPDATE)

```sql
-- Ejemplo genérico para cualquier tabla
UPDATE <tabla>
SET 
    <campo> = <nuevo_valor>,
    updated_at = now(),
    updated_by = :current_user_id
WHERE <primary_key> = <id>;
```

**Resultado:**
```
<primary_key>: 1
<campos_negocio>: <valores_actualizados>
created_at: 2025-10-06 10:30:00  -- NO CAMBIA
created_by: 123                   -- NO CAMBIA
updated_at: 2025-10-06 14:45:00   -- ACTUALIZADO
updated_by: 456                   -- ACTUALIZADO
deleted_at: NULL
deleted_by: NULL
```

### 3. Eliminación Lógica (Soft Delete)

```sql
-- En lugar de DELETE, se marca como eliminado
UPDATE <tabla>
SET 
    deleted_at = now(),
    deleted_by = :current_user_id
WHERE <primary_key> = <id>;
```

**Importante:** 
- ❌ **Nunca usar** `DELETE FROM <tabla>`
- ✅ **Siempre usar** `UPDATE` con `deleted_at` y `deleted_by`

### 4. Recuperación (Undelete)

```sql
-- Para "recuperar" un registro eliminado
UPDATE <tabla>
SET 
    deleted_at = NULL,
    deleted_by = NULL,
    updated_at = now(),
    updated_by = :current_user_id
WHERE <primary_key> = <id>;
```

---

## Consultas con Auditoría

### Obtener solo registros activos (patrón estándar)

```sql
-- Consulta estándar para cualquier tabla: solo registros NO eliminados
SELECT *
FROM <tabla>
WHERE deleted_at IS NULL;
```

### Obtener registros eliminados

```sql
-- Ver qué fue eliminado y por quién
SELECT 
    t.*,
    u.name as deleted_by_user
FROM <tabla> t
JOIN users u ON t.deleted_by = u.user_id
WHERE t.deleted_at IS NOT NULL
ORDER BY t.deleted_at DESC;
```

### Historial de cambios de un registro

```sql
-- Ver quién creó, quién modificó y quién eliminó
SELECT 
    t.*,
    creator.name as created_by_user,
    t.created_at,
    updater.name as updated_by_user,
    t.updated_at,
    deleter.name as deleted_by_user,
    t.deleted_at,
    CASE 
        WHEN t.deleted_at IS NOT NULL THEN 'DELETED'
        WHEN t.updated_at IS NOT NULL THEN 'MODIFIED'
        ELSE 'ORIGINAL'
    END as status
FROM <tabla> t
JOIN users creator ON t.created_by = creator.user_id
LEFT JOIN users updater ON t.updated_by = updater.user_id
LEFT JOIN users deleter ON t.deleted_by = deleter.user_id
WHERE t.<primary_key> = :<id>;
```

### Registros modificados recientemente

```sql
SELECT 
    t.*,
    u.name as last_modifier
FROM <tabla> t
LEFT JOIN users u ON t.updated_by = u.user_id
WHERE t.updated_at >= now() - interval '24 hours'
  AND t.deleted_at IS NULL
ORDER BY t.updated_at DESC;
```

---

## Triggers Automáticos (Recomendado)

Para automatizar el llenado de campos de auditoría y evitar errores humanos:

### Función genérica reutilizable

```sql
-- Función genérica para actualizar campos de auditoría
-- Esta función se puede usar para TODAS las tablas del sistema
CREATE OR REPLACE FUNCTION update_audit_fields()
RETURNS TRIGGER AS $$
BEGIN
    -- Solo actualizar si hay cambios reales en los datos
    IF NEW IS DISTINCT FROM OLD THEN
        NEW.updated_at = now();
        -- Obtener el usuario actual desde configuración de sesión
        BEGIN
            NEW.updated_by = current_setting('app.current_user_id')::BIGINT;
        EXCEPTION WHEN OTHERS THEN
            -- Si no está configurado, dejar NULL (o forzar error según política)
            NEW.updated_by = NULL;
        END;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Comentario de la función
COMMENT ON FUNCTION update_audit_fields() IS 
'Función genérica para auditoría soft. Actualiza updated_at y updated_by automáticamente en cada UPDATE.';
```

### Aplicar a cada tabla con auditoría

```sql
-- Banco de Preguntas
CREATE TRIGGER trg_subjects_audit
    BEFORE UPDATE ON subjects
    FOR EACH ROW
    EXECUTE FUNCTION update_audit_fields();

CREATE TRIGGER trg_units_audit
    BEFORE UPDATE ON units
    FOR EACH ROW
    EXECUTE FUNCTION update_audit_fields();

CREATE TRIGGER trg_topics_audit
    BEFORE UPDATE ON topics
    FOR EACH ROW
    EXECUTE FUNCTION update_audit_fields();

CREATE TRIGGER trg_outcomes_audit
    BEFORE UPDATE ON outcomes
    FOR EACH ROW
    EXECUTE FUNCTION update_audit_fields();

CREATE TRIGGER trg_questions_audit
    BEFORE UPDATE ON questions
    FOR EACH ROW
    EXECUTE FUNCTION update_audit_fields();

CREATE TRIGGER trg_users_audit
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_audit_fields();

-- Gestión de Evaluaciones
CREATE TRIGGER trg_evaluations_audit
    BEFORE UPDATE ON evaluations
    FOR EACH ROW
    EXECUTE FUNCTION update_audit_fields();

CREATE TRIGGER trg_evaluation_cycles_audit
    BEFORE UPDATE ON evaluation_cycles
    FOR EACH ROW
    EXECUTE FUNCTION update_audit_fields();

-- Ingesta Móvil
CREATE TRIGGER trg_submissions_audit
    BEFORE UPDATE ON submissions
    FOR EACH ROW
    EXECUTE FUNCTION update_audit_fields();

-- Agregar más según se implementen nuevas tablas...
```

---

## Configuración a Nivel de Aplicación

### Establecer el usuario actual en cada transacción

**Node.js con PostgreSQL:**
```javascript
async function executeWithUser(userId, callback) {
    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        await client.query(`SET LOCAL app.current_user_id = '${userId}'`);
        const result = await callback(client);
        await client.query('COMMIT');
        return result;
    } catch (error) {
        await client.query('ROLLBACK');
        throw error;
    } finally {
        client.release();
    }
}

// Uso
await executeWithUser(req.user.id, async (client) => {
    await client.query(`
        UPDATE subjects 
        SET name = $1 
        WHERE subject_id = $2
    `, ['New Name', subjectId]);
});
```

**Python con SQLAlchemy:**
```python
from sqlalchemy import event
from flask import g

@event.listens_for(Session, 'before_flush')
def receive_before_flush(session, flush_context, instances):
    if hasattr(g, 'current_user_id'):
        session.execute(
            text(f"SET LOCAL app.current_user_id = '{g.current_user_id}'")
        )
```

**Java con Spring:**
```java
@Component
@Aspect
public class AuditAspect {
    
    @Around("@annotation(Transactional)")
    public Object setCurrentUser(ProceedingJoinPoint joinPoint) throws Throwable {
        Long userId = SecurityContextHolder.getContext()
            .getAuthentication()
            .getPrincipal()
            .getId();
        
        jdbcTemplate.execute(
            "SET LOCAL app.current_user_id = " + userId
        );
        
        return joinPoint.proceed();
    }
}
```

---

## Vistas Recomendadas

Para simplificar consultas, crear vistas que filtren automáticamente registros eliminados:

```sql
-- Patrón estándar para cualquier tabla
CREATE VIEW active_<tabla> AS
SELECT *
FROM <tabla>
WHERE deleted_at IS NULL;

-- Ejemplos concretos:
CREATE VIEW active_subjects AS
SELECT * FROM subjects WHERE deleted_at IS NULL;

CREATE VIEW active_units AS
SELECT * FROM units WHERE deleted_at IS NULL;

CREATE VIEW active_topics AS
SELECT * FROM topics WHERE deleted_at IS NULL;

CREATE VIEW active_questions AS
SELECT * FROM questions WHERE deleted_at IS NULL;

CREATE VIEW active_evaluations AS
SELECT * FROM evaluations WHERE deleted_at IS NULL;

CREATE VIEW active_submissions AS
SELECT * FROM submissions WHERE deleted_at IS NULL;
```

**Ventaja**: El código de aplicación puede usar las vistas y olvidarse de filtrar `deleted_at IS NULL`.

---

## Índices para Rendimiento

### Patrón estándar de índices

```sql
-- Para cada tabla con auditoría, crear estos índices:

-- 1. Índice parcial para registros eliminados
CREATE INDEX idx_<tabla>_deleted 
    ON <tabla> (deleted_at) 
    WHERE deleted_at IS NOT NULL;

-- 2. Índice para consultas de auditoría (registros modificados)
CREATE INDEX idx_<tabla>_updated 
    ON <tabla> (updated_at) 
    WHERE updated_at IS NOT NULL;

-- 3. Índice compuesto para filtrado común (activos + otro criterio)
CREATE INDEX idx_<tabla>_active_<campo>
    ON <tabla> (<campo>)
    WHERE deleted_at IS NULL;
```

### Ejemplos concretos

```sql
-- Banco de Preguntas
CREATE INDEX idx_subjects_deleted ON subjects (deleted_at) WHERE deleted_at IS NOT NULL;
CREATE INDEX idx_subjects_updated ON subjects (updated_at) WHERE updated_at IS NOT NULL;

CREATE INDEX idx_units_deleted ON units (deleted_at) WHERE deleted_at IS NOT NULL;
CREATE INDEX idx_units_updated ON units (updated_at) WHERE updated_at IS NOT NULL;

CREATE INDEX idx_topics_deleted ON topics (deleted_at) WHERE deleted_at IS NOT NULL;
CREATE INDEX idx_topics_updated ON topics (updated_at) WHERE updated_at IS NOT NULL;

CREATE INDEX idx_questions_deleted ON questions (deleted_at) WHERE deleted_at IS NOT NULL;
CREATE INDEX idx_questions_updated ON questions (updated_at) WHERE updated_at IS NOT NULL;
CREATE INDEX idx_questions_active_topic ON questions (topic_fk) WHERE deleted_at IS NULL;

-- Gestión de Evaluaciones
CREATE INDEX idx_evaluations_deleted ON evaluations (deleted_at) WHERE deleted_at IS NOT NULL;
CREATE INDEX idx_evaluations_updated ON evaluations (updated_at) WHERE updated_at IS NOT NULL;

-- Ingesta Móvil
CREATE INDEX idx_submissions_deleted ON submissions (deleted_at) WHERE deleted_at IS NOT NULL;
CREATE INDEX idx_submissions_updated ON submissions (updated_at) WHERE updated_at IS NOT NULL;
```

---

## Políticas de Retención

### Limpieza de registros eliminados (opcional)

Si se acumula demasiada data eliminada, se puede implementar un proceso de limpieza:

```sql
-- Archivar registros eliminados hace más de 1 año
-- (Requiere tabla de archivo)
INSERT INTO <tabla>_archive
SELECT * FROM <tabla>
WHERE deleted_at < now() - interval '1 year';

-- Luego eliminar físicamente (PRECAUCIÓN)
DELETE FROM <tabla>
WHERE deleted_at < now() - interval '1 year';
```

**Recomendación**: No eliminar físicamente a menos que sea estrictamente necesario por espacio.

---

## Buenas Prácticas

### ✅ DO (Hacer)

1. **Siempre usar soft delete** en lugar de DELETE físico
2. **Filtrar `deleted_at IS NULL`** en todas las consultas normales
3. **Usar las vistas `active_*`** para simplificar el código
4. **Establecer el usuario actual** al inicio de cada transacción
5. **Implementar los triggers** para automatizar auditoría
6. **Agregar campos de auditoría** a todas las tablas nuevas desde el inicio

### ❌ DON'T (No hacer)

1. **No usar DELETE físico** excepto en casos muy específicos
2. **No olvidar filtrar registros eliminados** en consultas
3. **No modificar `created_at` o `created_by`** después de la creación
4. **No eliminar físicamente** sin archivar primero
5. **No implementar auditoría "a medias"** en algunas tablas sí y otras no
6. **No exponer registros eliminados** al usuario final sin filtrar

---

## Diferencias con Auditoría Centralizada

| Aspecto | Auditoría Soft (Implementado) | Auditoría Centralizada (Futuro) |
|---------|-------------------------------|----------------------------------|
| **Complejidad** | ✅ Baja | ⚠️ Media-Alta |
| **Rendimiento** | ✅ Óptimo | ⚠️ Impacto por escrituras extra |
| **Espacio** | ✅ Eficiente | ⚠️ Crece rápidamente |
| **Detalle** | ⚠️ Solo última modificación | ✅ Historial completo de cambios |
| **Valores anteriores** | ❌ No registra | ✅ Registra antes/después |
| **Reconstrucción** | ❌ No posible | ✅ Time-travel queries |
| **Consultas** | ✅ Simples | ⚠️ Requiere JOINs adicionales |

---

## Roadmap de Auditoría

### ✅ Fase 1: Auditoría Soft (Actual)

- Campos de auditoría en todas las tablas principales
- Soft delete transversal
- Triggers automáticos
- Vistas de registros activos

### 🔜 Fase 2: Auditoría Centralizada (Futuro)

```sql
CREATE TABLE audit_log (
    audit_id BIGSERIAL PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    record_id BIGINT NOT NULL,
    action VARCHAR(20) NOT NULL,  -- 'CREATE', 'UPDATE', 'DELETE'
    user_fk BIGINT NOT NULL REFERENCES users(user_id),
    timestamp TIMESTAMPTZ NOT NULL DEFAULT now(),
    old_values JSONB,
    new_values JSONB,
    changed_fields TEXT[],
    ip_address INET,
    user_agent TEXT
);

CREATE INDEX idx_audit_log_table_record ON audit_log (table_name, record_id);
CREATE INDEX idx_audit_log_user ON audit_log (user_fk);
CREATE INDEX idx_audit_log_timestamp ON audit_log (timestamp DESC);
```

### 🔮 Fase 3: Event Sourcing (Largo plazo)

Registrar todos los eventos como stream inmutable:
- `QuestionCreated`
- `QuestionUpdated`
- `QuestionDeleted`
- `QuestionVersioned`
- `EvaluationPublished`
- `SubmissionReceived`

Permite reconstruir el estado completo en cualquier punto del tiempo.

---

## Documentos Relacionados

- [Modelo de Datos General](README.md)
- [Banco de Preguntas - MER](question-bank/mer.md)
- [Gestión de Evaluaciones - MER](grading-management/mer.md)
- [Ingesta Móvil - MER](mobile-ingest/mer.md)

---

## Resumen Ejecutivo

| Concepto | Estado | Prioridad |
|----------|--------|-----------|
| **Campos de auditoría en tablas principales** | ✅ Definido | ALTA |
| **Soft delete obligatorio** | ✅ Definido | ALTA |
| **Triggers automáticos** | 🔜 Pendiente | ALTA |
| **Vistas active_*** | 🔜 Pendiente | MEDIA |
| **Índices de rendimiento** | 🔜 Pendiente | MEDIA |
| **Configuración en aplicación** | 🔜 Pendiente | ALTA |
| **Auditoría centralizada** | 🔮 Futuro | BAJA |

---

[Volver al índice](README.md)

