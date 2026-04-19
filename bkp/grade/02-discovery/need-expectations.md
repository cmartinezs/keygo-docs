# Necesidades y Expectativas del Sistema

---
## Contenido
* [Necesidades funcionales clave](#necesidades-funcionales-clave)
* [Expectativas operativas y de largo plazo](#expectativas-operativas-y-de-largo-plazo)
* [Cómo usar esta tabla](#cómo-usar-esta-tabla)
* [Supuestos & Dependencias](#supuestos--dependencias)
* [Riesgos & Mitigaciones](#riesgos--mitigaciones)
* [Criterios de aceptación de alto nivel](#criterios-de-aceptación-de-alto-nivel)
---
## Necesidades funcionales clave
La siguiente matriz identifica **qué debe hacer GRADE para cumplir su promesa de valor** y a qué objetivos estratégicos contribuye cada necesidad.  Sirve como puente entre la visión de alto nivel y el backlog de desarrollo: toda funcionalidad que ingrese al producto debe mapearse a una fila de esta tabla, garantizando foco y evitando “scope creep”.

| Nº | Necesidad | Descripción resumida | Objetivos estratégicos relacionados |
|----|-----------|----------------------|-------------------------------------|
| N1 | **Centralización integral del ciclo** | GRADE debe ser el único punto para crear, publicar, aplicar y registrar evaluaciones, garantizando trazabilidad y evitando herramientas aisladas. | 1, 6 |
| N2 | **Banco de preguntas versionado y trazable** | Repositorio único de ítems autocorregibles (VF, selección múltiple, etc.) con metadatos pedagógicos y control de versiones. | 2, 6 |
| N3 | **Motor de calificación automática configurable** | Procesa respuestas vía OCR/web, calcula puntajes y convierte a nota según umbrales editables por asignatura, registrando evidencias. | 3, 6 |
| N4 | **Configuración flexible de criterios de calificación** | Umbrales, ponderaciones y curvas editables aplicados de forma consistente a todas las evaluaciones. | 3, 8 |
| N5 | **Seguridad e integridad académica** | Cifrado end-to-end, roles granulares y bitácora inmutable para prevenir fraudes y filtraciones. | 4 |
| N6 | **Interoperabilidad con APIs estandarizadas** | Endpoints REST / GraphQL y webhooks, autenticación OAuth 2 / JWT, adaptadores para LMS / analytics. | 5 |
| N7 | **Escalabilidad y rendimiento elástico** | Arquitectura modular capaz de soportar picos de uso sin degradar la experiencia. | 6 |
| N8 | **Eficiencia operativa y mantenimiento sencillo** | Automatización (CI/CD, auto-tests), paneles de monitoreo y ajustes sin intervención de desarrollo. | 6, 7 |
| N9 | **Experiencia de usuario orientada al rol** | Interfaces intuitivas, paso a paso para docentes y reportes inmediatos; accesibilidad WCAG 2.1 AA. | 8, 7 |

> _Nota_: los números de objetivos estratégicos (1–8) corresponden a la sección anterior.

---

## Expectativas operativas y de largo plazo
Más allá de las funciones concretas, GRADE debe regirse por **principios que aseguren sostenibilidad, calidad y adopción a futuro**.  Esta segunda tabla resume esos principios —coherencia académica, seguridad, rendimiento, accesibilidad, etc.— y muestra cómo refuerzan las necesidades funcionales.  Actúa como guía de arquitectura, DevOps y gobernanza para que el sistema mantenga su integridad mientras evoluciona.

| Eje | Expectativa | Cómo se alinea con las necesidades |
|-----|-------------|------------------------------------|
| **Coherencia académica** | Los criterios, rúbricas y ponderaciones deben aplicarse idénticamente en todos los cursos. | Refuerza N2, N4 |
| **Evolutividad y mantenimiento** | Arquitectura modular, versionado de evaluaciones y pipelines CI/CD para cambios seguros. | N3, N7, N8 |
| **Onboarding ágil** | Plantillas parametrizables y asistente guiado para nuevos cursos o docentes sin intervención TI. | N1, N2, N9 |
| **Política de integración y validación** | Aplicaciones externas deben registrarse, pasar sandbox y usar credenciales con scopes. | N5, N6 |
| **Registro y auditoría** | Bitácora inmutable y reportes de compliance exportables; alertas ante eventos anómalos. | N5, N3 |
| **Protección de datos y privacidad** | Encriptación en reposo y tránsito, segmentación de acceso, políticas de retención/anonimización. | N5 |
| **Rendimiento bajo picos** | Escalado horizontal, caché inteligente y monitoreo proactivo (CPU, latencia, throughput). | N7 |
| **Experiencia & accesibilidad** | Interfaces responsivas, flujos claros, WCAG 2.1 AA. | N9 |

### Cómo usar esta tabla

* **Priorización** — Los desarrolladores y product owners pueden revisar qué necesidad impacta más objetivos y priorizar funcionalidad.
* **Trazabilidad** — Cualquier historia de usuario debe enlazar con la necesidad correspondiente y, por extensión, con su objetivo estratégico.
* **Revisión futura** — Nuevas necesidades o expectativas deberán agregarse solo si respaldan objetivos o abren uno nuevo acordado por el equipo.
---

## Supuestos & Dependencias

Esta tabla registra los **factores externos o condicionantes** que deben mantenerse válidos para que las necesidades y expectativas de GRADE se cumplan.  Al monitorear estos supuestos de forma proactiva, el equipo puede anticipar ajustes de alcance o planes de contingencia antes de que un riesgo se materialice.

| Nº | Supuesto / Dependencia | Impacto si no se cumple | Acción de monitoreo / Plan de contingencia |
|----|------------------------|-------------------------|-------------------------------------------|
| S1 | **Precisión OCR ≥ 95 %** con la plantilla PDF definida. | Incremento de errores al calificar → docentes pierden confianza → baja adopción. | - Métrica automática de precisión en ambiente QA.<br>- Si desciende < 90 %: ofrecer formulario web alternativo y/o contratar motor OCR comercial. |
| S2 | **Pasarela de pagos (Stripe)** soporta micro-suscripciones en los países objetivo. | Retraso en lanzamiento del plan pago; ingresos < lo proyectado. | - Verificación legal / fiscal antes de mes M-2.<br>- Alternativa: PayPal o MercadoPago. |
| S3 | **Infraestructura cloud** con auto-scaling y SLA ≥ 99,9 % durante picos. | Latencia alta o caídas en semanas de exámenes → impacto en NPS y KPI de tiempo de calificación. | - Pruebas de carga trimestrales.<br>- Contingencia: cold standby en otro proveedor. |
| S4 | **Apps académicas** adoptarán OAuth 2 / JWT para integrarse. | Integraciones retrasadas o inseguras; dificulta KPI de adopción y centralización. | - Documento “Guía de integración” entregado en T-4 semanas.<br>- Sandbox + soporte técnico dedicado. |
| S5 | **Normativas de protección de datos (Ley 19 628, GDPR)** permanecen sin cambios disruptivos. | Re-ingeniería si surgen nuevas obligaciones → costos y retrasos. | - Revisión legal semestral.<br>- Diseñar la base con principios “privacy-by-design” para facilitar ajustes. |
| S6 | **Disponibilidad de docentes para pruebas piloto** (min. 15 docentes independientes). | Difícil validar UX y KPIs iniciales; riesgos en lanzamiento. | - Convenio con programa de formación docente.<br>- Incentivo: plan pago gratis por 6 meses a los participantes. |
---
## Riesgos & Mitigaciones

Esta matriz identifica los **principales riesgos** que podrían impedir el logro de las necesidades y objetivos estratégicos de GRADE, junto con la estrategia de mitigación y el responsable primario.  Sirve como guía de vigilancia continua y referencia rápida durante las retrospectivas de proyecto.

| Nº | Riesgo | Necesidades / Objetivos afectados | Prob. | Impacto | Mitigación / Acción preventiva | Responsable |
|----|--------|-----------------------------------|-------|---------|--------------------------------|-------------|
| R1 | **Adopción docente menor a la prevista** | N1, N3, N9 · Obj 4, 7, 8 | Media | Alto | - Programa de onboarding guiado + videotutoriales.<br>- Incentivo “primer mes plan básico gratis”.<br>- Encuestas tempranas para ajustar UX. | Product Owner |
| R2 | **Sobrecarga de infraestructura en semanas pico** | N7, N8 · Obj 3, 6 | Media | Alto | - Auto-scaling con límites de coste.<br>- Pruebas de carga trimestrales ≥ 2× tráfico estimado.<br>- Alertas prometh. / Grafana con umbral 70 % CPU. | Tech Lead |
| R3 | **Fallo de precisión OCR < 90 %** | N3 · Obj 3 | Baja | Alto | - Modelo fallback comercial (Google Vision, AWS Textract).<br>- Mecanismo manual de revisión rápida.<br>- Métrica de precisión monitoreada en QA / Prod. | ML / Dev Lead |
| R4 | **Brecha de seguridad (datos filtrados)** | N5 · Obj 4 | Baja | Crítico | - Auditorías pentest semestrales.<br>- Cifrado AES-256 + rotación de claves.<br>- Seguro de ciber-responsabilidad. | Security Lead |
| R5 | **Cambios regulatorios abruptos (protección de datos)** | N5 · Obj 4 | Baja | Medio | - Seguimiento legal trimestral.<br>- Arquitectura “privacy-by-design” para anonimizar datos. | Legal Advisor |
| R6 | **Integraciones LMS se retrasan / fallan** | N6 · Obj 5 | Media | Medio | - API bien documentada + SDK.<br>- Ambiente sandbox para pruebas.<br>- Consultor técnico asignado a cada partner. | Integration PM |
| R7 | **Coste infra por prueba > 0,05 USD** | N8 · Obj 6, 7 | Media | Medio | - Optimización de consultas + caché.<br>- Revisión mensual de facturación cloud.<br>- Compresión / eliminación de archivos temporales. | DevOps |
| R8 | **Experiencia de usuario poco intuitiva (NPS < +40)** | N9 · Obj 8 | Media | Alto | - Test de usabilidad con docentes cada sprint.<br>- Mejora continua UI/UX basada en feedback.<br>- Design system accesible (WCAG 2.1 AA). | UX Lead |
---
## Criterios de aceptación de alto nivel

Los criterios siguientes definen **cómo demostraremos** que cada necesidad funcional clave se ha cumplido en producción.  Actúan como puente entre el discovery y los planes de QA: antes de cerrar una épica o una iteración, el equipo debe presentar la evidencia correspondiente.

| Necesidad | Criterio(s) de aceptación — Evidencia requerida | KPI / Métrica asociada |
|-----------|-----------------------------------------------|------------------------|
| **N1** Centralización integral | - El 80 %+ de las evaluaciones creadas por docentes piloto residen en GRADE.<br>- Todas las notas oficiales se generan a partir del servicio (ver bitácora). | KPI1 – ≥ 80 % pruebas en GRADE |
| **N2** Banco de preguntas versionado | - Cada ítem tiene metadatos completos y al menos una versión previa accesible.<br>- Historial de cambios reconstruye la “foto” usada en una evaluación pasada. | KPI2 – 70 % reutilización preguntas |
| **N3** Motor de calificación automática | - Tiempo medio técnico ≤ 5 min por prueba en pruebas de carga (pico X).<br>- Evidencia de OCR/CSV procesado y nota convertida según umbral. | KPI2a/b – Procesamiento rápido |
| **N4** Configuración de criterios | - Docente/Coordinador puede actualizar umbral y la conversión se refleja en menos de 60 s.<br>- Reporte muestra nueva distribución de notas. | KPI3 – Notas ≤ 24 h |
| **N5** Seguridad e integridad | - Resultado satisfactorio en pentest externo (0 hallazgos críticos).<br>- Bitácora inmutable verifica acción “crear/editar/calificar”. | KPI4 – 0 incidentes graves |
| **N6** Interoperabilidad API | - Al menos 1 LMS integrado en sandbox: crea evaluación y recupera resultados sin error 4xx/5xx.<br>- Documentación OpenAPI validada y publicada. | KPI5 – 3 integraciones certificadas |
| **N7** Escalabilidad & rendimiento | - Prueba de carga: 2× tráfico estimado → SLA ≥ 99,9 %.<br>- Uso de CPU < 70 % promedio en picos. | KPI6 – Costo infra < 0,05 USD/prueba |
| **N8** Eficiencia operativa | - Pipeline CI/CD con auto-tests verdes; despliegue a staging < 15 min.<br>- Panel DevOps muestra métricas en tiempo real. | KPI6 – Costo / pruebas |
| **N9** Experiencia orientada al rol | - 10 docentes independientes completan flujo “crear → aplicar → calificar” sin asistencia externa.<br>- Encuesta de usabilidad (SUS) ≥ 80/100. | KPI8 – NPS ≥ +40 |

> **Nota** Estos criterios son de alto nivel; cada historia de usuario deberá detallar pruebas funcionales y casos límite concretos (por ejemplo, diferentes resoluciones de OCR, tamaños de banco, accesibilidad con lector de pantalla).

[< Anterior](actors.md) | [Inicio](README.md) | [Siguiente >](next-steps.md)