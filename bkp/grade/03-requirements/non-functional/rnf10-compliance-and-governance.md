# RNF10 — Cumplimiento y gobernanza

**Descripción (alto nivel)**  
GRADE debe contar con **políticas claras de gestión, cumplimiento y gobernanza**, que aseguren transparencia en la operación del sistema, trazabilidad de decisiones y alineación con estándares internos o regulatorios.

**Alcance incluye**
- **Políticas documentadas** de:
    - Gestión del banco de preguntas.
    - Administración de roles y permisos.
    - Uso de APIs e integraciones externas.
- **Revisión periódica** de permisos, accesos y auditorías.
- Registro y disponibilidad de **decisiones de diseño/arquitectura** (ej. ADRs).
- Cumplimiento con **reglamentos institucionales** y normativas básicas aplicables (ej. protección de datos, estándares académicos internos).
- Disponibilidad de información de **gobernanza del sistema** para administradores (ej. responsables de mantenimiento, responsables de datos).

**No incluye (MVP)**
- Certificaciones formales de cumplimiento (ej. ISO, GDPR completo).
- Auditorías externas periódicas por entidades certificadoras (queda para fases posteriores).

**Dependencias**
- RF7 (Roles y permisos).
- RF8 (Auditoría y trazabilidad).
- RNF2 (Privacidad y tratamiento de datos).

**Criterios de aceptación (CA)**
1. Existen **documentos de políticas** que describen gestión de banco, roles y APIs.
2. Se realiza una **revisión periódica** de accesos y permisos al menos cada 6 meses.
3. Toda decisión de arquitectura clave queda registrada en **ADRs**.
4. El sistema tiene un **responsable identificado** de operación y de datos sensibles.
5. Las políticas de gobernanza se encuentran **accesibles a administradores** en el sistema o repositorio asociado.

**Riesgos/mitigaciones**
- Falta de claridad en responsabilidades → definir y publicar gobernanza.
- Incumplimiento regulatorio → revisiones periódicas y asesoría legal.
- Pérdida de trazabilidad → mantener ADRs y registro histórico de decisiones.
