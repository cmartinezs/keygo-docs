# Casos de Uso Fuera de Alcance del MER Actual

Esta carpeta contiene casos de uso de Ingesta Móvil (CU-IM) que fueron identificados como **fuera del alcance** del Modelo Entidad-Relación (MER) actual del sistema de Ingesta Móvil.

## Criterios de exclusión

Los casos de uso fueron movidos aquí porque:

1. **No están alineados con las entidades del MER actual** - Requieren estructuras de datos no contempladas
2. **Funcionalidades no implementadas** - Dependen de características que no existen en el modelo actual
3. **Complejidad fuera del MVP** - Representan funcionalidades avanzadas para futuras iteraciones
4. **Dependencias externas no definidas** - Requieren integraciones o sistemas no especificados

## MER de referencia

El MER actual de Ingesta Móvil contempla las siguientes entidades principales:
- `ingest_devices` - Dispositivos móviles registrados
- `ingest_batches` - Lotes/sesiones de captura
- `scanned_pages` - Páginas/imágenes capturadas
- `page_qrs` - Decodificación de QR/códigos
- `page_detections` - Normalización geométrica
- `bubble_detections` - Detección de burbujas
- `recognition_mappings` - Mapeo a opciones de evaluación
- `ingest_results` - Consolidación semántica
- `processing_jobs` y `processing_logs` - Pipeline y auditoría

## Casos de uso movidos

Los siguientes casos de uso fueron movidos a esta carpeta:

### Funcionalidades avanzadas de sincronización
- **S-IM-05**: Operación offline y sincronización automática
  - *Razón*: Requiere arquitectura de sincronización avanzada no definida en el MER actual

### Gestión avanzada de dispositivos
- **S-IM-07**: Gestión de dispositivos móviles
  - *Razón*: El MER actual solo contempla registro básico de dispositivos, no gestión avanzada

### Validación y control de calidad avanzado
- **S-IM-08**: Validación de calidad y control de anomalías
  - *Razón*: Requiere algoritmos de ML y estructuras de datos no contempladas

### Revisión manual y corrección
- **S-IM-09**: Revisión manual de capturas dudosas
  - *Razón*: Requiere interfaces de revisión y flujos de aprobación no definidos

### Monitoreo y dashboards
- **S-IM-10**: Monitoreo y métricas de ingesta
  - *Razón*: Requiere sistema de métricas y dashboards fuera del alcance actual

### Análisis y reporting
- **S-IM-11**: Análisis de rendimiento del proceso
  - *Razón*: Requiere capacidades de analytics no contempladas en el MER

## Revisión futura

Estos casos de uso serán revisados y potencialmente reintegrados en futuras iteraciones cuando:

1. El MER se expanda para soportar las funcionalidades requeridas
2. Se definan las dependencias externas necesarias
3. Se implementen los sistemas de soporte correspondientes
4. Se priorice su desarrollo en el roadmap del producto

## Referencia

- [MER Ingesta Móvil actual](../../06-data-model/mobile-ingest/mer.md)
- [Casos de uso activos](../S-IM/README.md)

---

*Fecha de revisión: Octubre 2025*
*Revisado por: GitHub Copilot (análisis automatizado)*
