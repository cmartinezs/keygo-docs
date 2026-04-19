# RNF2 — Privacidad y tratamiento de datos

**Descripción (alto nivel)**  
GRADE debe garantizar la **privacidad de la información** y el correcto tratamiento de los datos personales y académicos, cumpliendo con principios de protección, minimización y propósito.

**Alcance incluye**
- **Principio de minimización**: solo recolectar y almacenar la información estrictamente necesaria.
- **Finalidad definida**: los datos se utilizan únicamente para los fines académicos del sistema.
- **Políticas de retención**: definir períodos de almacenamiento y eliminación segura de datos (ej. respuestas estudiantiles).
- **Anonimización o seudonimización** de datos en reportes cuando corresponda (ej. estadísticas agregadas).
- **Cumplimiento normativo** con leyes locales de protección de datos (ej. Ley 19.628 en Chile, GDPR si aplica).
- **Control de acceso restringido** a información sensible (ej. respuestas individuales).
- Registro en **auditoría (RF8)** de accesos a datos sensibles.

**No incluye (MVP)**
- Certificaciones formales de cumplimiento (ej. ISO 27001, GDPR completo) → planificadas a largo plazo.
- Consentimiento granular por estudiante en portales externos (no incluidos en MVP).

**Dependencias**
- RF6 (Publicación y consulta de resultados).
- RF8 (Auditoría y trazabilidad).
- RNF1 (Seguridad y control de acceso).

**Criterios de aceptación (CA)**
1. El sistema almacena solo los datos estrictamente necesarios para cada función.
2. Los resultados de evaluaciones pueden ser consultados de forma **anonimizada o agregada** por roles no autorizados a ver datos individuales.
3. Los datos eliminados del sistema quedan **irrecuperables** (borrado seguro).
4. Todas las consultas a información sensible quedan **registradas en auditoría**.
5. Existe documentación de **políticas de retención y propósito** de los datos.

**Riesgos/mitigaciones**
- Exposición indebida de información → controles de acceso por rol + anonimización.
- Acumulación de datos innecesarios → políticas de retención con eliminación programada.
- Incumplimiento normativo → documentación de políticas y revisiones periódicas.
