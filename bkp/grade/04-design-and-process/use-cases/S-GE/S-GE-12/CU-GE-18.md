# CU-GE-18 — Exportar resultados en CSV o PDF

- [Revisión](review.md)
- [Volver](../../README.md#2-gestión-de-evaluación)

## Escenario origen: S-GE-12 | Exportar resultados (CSV/PDF)

### RF relacionados: RF6, RF10

**Actor principal:** Docente  
**Actores secundarios:** Coordinador, Sistema GRADE

---

### Objetivo
Permitir que un Docente (o un Coordinador en vistas agregadas) exporte los resultados de una evaluación publicada en formatos CSV o PDF, para compartirlos o almacenarlos fuera de GRADE.

### Precondiciones
- Evaluación en estado **Publicado** (CU-GE-16).
- Usuario autenticado con rol de Docente o Coordinador autorizado.

### Postcondiciones
- El archivo CSV o PDF queda generado y disponible para descarga.
- La acción queda registrada en el historial de auditoría.

### Flujo principal (éxito)
1. El Usuario accede a la sección de resultados de una evaluación publicada.
2. Selecciona la opción **“Exportar resultados”**.
3. El Sistema ofrece dos formatos de exportación: CSV o PDF.
4. El Usuario elige el formato deseado.
5. El Sistema genera el archivo:
    - **CSV:** resultados tabulares por alumno (ID, nombre, puntaje, nota).
    - **PDF:** reporte visual con estadísticas, distribuciones y detalle por alumno.
6. El Sistema registra la acción en auditoría.
7. El Sistema notifica que la exportación fue exitosa y habilita la descarga.

### Flujos alternativos / Excepciones
- **A1 — Error en generación del archivo:** El Sistema informa del fallo y permite reintentar.
- **A2 — Falla de red al descargar:** El Sistema ofrece volver a intentar la descarga sin regenerar el archivo.
- **A3 — Usuario sin permisos:** El Sistema bloquea la acción y muestra mensaje de acceso restringido.

### Reglas de negocio
- **RN-1:** Solo evaluaciones en estado **Publicado** pueden exportarse.
- **RN-2:** Los Docentes exportan resultados individuales y agregados; los Coordinadores solo resultados agregados.
- **RN-3:** Todo archivo exportado debe tener marca institucional y metadatos de identificación (nombre de evaluación, fecha, curso).

### Datos principales
- **Resultados**(ID alumno, nombre, puntaje, nota, desglose).
- **Estadísticas**(promedio, mediana, distribución de notas, desempeño por ítem).
- **Archivo exportado**(tipo, tamaño, fecha, estado).
- **Auditoría**(usuario, acción, fecha/hora).

### Consideraciones de seguridad/permiso
- Control de acceso según rol (Docente vs Coordinador).
- Archivos deben proteger datos sensibles mediante cifrado opcional (si requerido).

### No funcionales
- **Rendimiento:** generación de archivo con 200 alumnos < 10s p95.
- **Compatibilidad:** CSV estándar UTF-8, PDF con formato institucional.
- **Usabilidad:** interfaz clara para elegir formato y descargar archivo.

### Criterios de aceptación (QA)
- **CA-1:** Al exportar, el archivo generado contiene los resultados correctos.
- **CA-2:** Los formatos disponibles son exclusivamente CSV y PDF.
- **CA-3:** La acción queda registrada en auditoría.
- **CA-4:** En caso de error, el sistema informa claramente y permite reintentar.  
