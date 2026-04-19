# Alcance del Sistema

## Contenido
A continuación se detalla el contenido del documento de alcance del sistema GRADE:
* [Propósito](#propósito)
* [Alcance funcional](#alcance-funcional)
  * [Trazabilidad entre Objetivos Estratégicos y Alcance Funcional](#trazabilidad-entre-objetivos-estratégicos-y-alcance-funcional)
  * [Alcance del MVP](#alcance-del-mvp)
* [Fuera de alcance en esta fase](#fuera-de-alcance-en-esta-fase)
* [Otras consideraciones](#otras-consideraciones)
  * [Límites operativos iniciales](#límites-operativos-iniciales)
  * [Dependencias y supuestos](#dependencias-y-supuestos)
* [Comentarios de los Revisores](#comentarios-de-los-revisores)
  * [Maximiliano Toledo](#maximiliano-toledo)
  * [Rodrigo Ulloa](#rodrigo-ulloa)
  * [Paolo Vilches](#paolo-vilches)

## Propósito

El sistema se establece como el punto central para la generación, distribución y calificación automatizada de evaluaciones, dentro del ecosistema de servicios educativos de Wanku, proporcionando una solución única para la creación de pruebas, la gestión del banco de preguntas y la calificación automatizada de las respuestas. Su objetivo es eliminar la duplicidad de herramientas y procesos en cada aplicación académica, estableciendo un marco pedagógico coherente y administrable desde una única plataforma, ofreciendo un flujo homogéneo, seguro y eficiente que simplifique la administración, el monitoreo y la escalabilidad de todo el proceso de evaluación docente.

---
## Alcance funcional
Esta sección detalla las **capacidades clave** que GRADE incorporará a lo largo de su roadmap, más allá de la primera entrega (MVP). Cada capability describe “lo que el sistema debe poder hacer” sin entrar todavía en historias de usuario ni soluciones técnicas de bajo nivel.  
El objetivo es ofrecer una vista holística que permita:

1. **Trazar** cómo cada funcionalidad contribuye a los objetivos estratégicos y sus KPI.
2. **Guiar la priorización** de epics e iteraciones futuras, mostrando qué piezas son fundamentales y cuáles pueden añadirse gradualmente.
3. **Dar visibilidad** a todos los actores sobre el alcance total del proyecto, evitando malentendidos sobre lo que sí y lo que no estará cubierto a mediano plazo.

La tabla siguiente resume estas capacidades, su descripción de alto nivel y el valor estratégico que aportan.

| # | Capability | Descripción detallada | Valor estratégico |
|---|------------|-----------------------|-------------------|
| **1** | **Banco centralizado de preguntas** | - Ítems autocorregibles (VF, selección múltiple) + metadatos: unidad, dificultad, resultado de aprendizaje, puntaje.<br>- Control de versiones y unicidad de preguntas dentro del ecosistema.<br>- Historial de uso por evaluación para análisis longitudinal. | Evita duplicidad, asegura coherencia curricular y alimenta futuras analíticas. |
| **2** | **Generación y publicación de evaluaciones** | - Selección de preguntas, definición de puntajes y rúbricas.<br>- Emisión oficial en PDF (descarga / impresión) y formato digital seguro.<br>- Número de versión incrustado en el PDF para trazabilidad. | Flujo homogéneo y controlado que reduce errores y facilita auditoría. |
| **3** | **Calificación automática y registro de resultados** | - Ingesta de respuestas mediante: escaneo OCR del PDF, foto (móvil) o carga CSV/Web.<br>- Cálculo de respuestas correctas/incorrectas, puntaje total y nota (1-7 u otro rango).<br>- Registro inmutable de resultados + evidencias (archivo escaneado, JSON de cálculo). | Ahorra tiempo docente y genera trazabilidad completa para revisiones o apelaciones. |
| **4** | **Configuración de criterios de calificación** | - Umbrales de aprobación y curvas de conversión editables por asignatura/sección.<br>- Ponderaciones y niveles de exigencia configurables (p.ej. 60 % = nota 4).<br>- Aplicación consistente de la política en todas las evaluaciones generadas. | Flexibilidad pedagógica sin sacrificar estandarización. |
| **5** | **Integración regulada vía API** | - Registro/aprobación de aplicaciones externas (token OAuth2 + scopes).<br>- Endpoints REST/GraphQL para crear evaluaciones, enviar respuestas y consultar resultados.<br>- Webhooks de eventos (evaluación publicada, nota disponible). | Amplía el ecosistema manteniendo control y seguridad. |
| **6** | **Escalabilidad y adaptabilidad** | - Arquitectura modular/microservicios; auto-scaling horizontal en picos de examen.<br>- Soporte futuro para nuevos tipos de pregunta (numéricas, código, matching).<br>- Roadmap para mejorar OCR y añadir analítica avanzada/IA generativa. | Garantiza crecimiento sostenido y permite innovar sin reescrituras. |
| **7** | **Auditoría y seguridad de datos** | - Roles granulares (docente, coordinador, auditor).<br>- Bitácora inmutable de acciones críticas (creación, edición, calificación).<br>- Cifrado en tránsito y reposo; pruebas de seguridad periódicas. | Protege reputación institucional y cumple normativas de protección de datos. |
| **8** | **Paneles de monitoreo y administración** | - Dashboard de uso (nº evaluaciones, tiempo medio de calificación, errores OCR).<br>- Configuración de límites (X eval/mes, tamaño Y MB).<br>- Alertas proactivas ante picos o fallos. | Reduce carga de soporte y facilita la toma de decisiones operativas. |

### Trazabilidad entre Objetivos Estratégicos y Alcance Funcional
El siguiente mapa muestra cómo cada capability del alcance funcional contribuye (directa o principalmente) al logro de los ocho objetivos estratégicos definidos para GRADE. Esto asegura que las funcionalidades no se desarrollen en el vacío, sino alineadas a los resultados de negocio, experiencia y operación que necesitamos medir con los KPI.

| # | Capability (alcance)                              | 1<br>Centralizar ciclo | 2<br>Banco reutilizable | 3<br>Calificación rápida | 4<br>Seguridad / Integridad | 5<br>Integración & SLA | 6<br>Eficiencia operativa | 7<br>Adopción &<br>Ingresos | 8<br>Experiencia NPS |
|---|---------------------------------------------------|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| **1** | Banco centralizado de preguntas                 | :green_circle: | :green_circle: | :yellow_circle: | :yellow_circle: | :yellow_circle: | :yellow_circle: | :green_circle: | :green_circle: |
| **2** | Generación & publicación de evaluaciones        | :green_circle: | :green_circle: | :yellow_circle: | :yellow_circle: | :yellow_circle: | :yellow_circle: | :green_circle: | :green_circle: |
| **3** | Calificación automática & registro              | :green_circle: | :yellow_circle: | :green_circle: | :yellow_circle: | :yellow_circle: | :green_circle: | :green_circle: | :green_circle: |
| **4** | Configuración de criterios de calificación      | :green_circle: | :yellow_circle: | :green_circle: | :yellow_circle: | :yellow_circle: | :yellow_circle: | :yellow_circle: | :green_circle: |
| **5** | Integración regulada vía API                    | :green_circle: | :yellow_circle: | :green_circle: | :green_circle: | :green_circle: | :green_circle: | :green_circle: | :green_circle: |
| **6** | Escalabilidad & adaptabilidad                   | :green_circle: | :green_circle: | :green_circle: | :green_circle: | :green_circle: | :green_circle: | :green_circle: | :green_circle: |
| **7** | Auditoría & seguridad de datos                  | :green_circle: | :yellow_circle: | :yellow_circle: | :green_circle: | :yellow_circle: | :yellow_circle: | :yellow_circle: | :yellow_circle: |
| **8** | Paneles de monitoreo & administración           | :green_circle: | :yellow_circle: | :green_circle: | :green_circle: | :green_circle: | :green_circle: | :yellow_circle: | :green_circle: |

> :information_source: **Claves**
>
> :green_circle: = contribución principal (la capability habilita o impacta directamente el objetivo).
> 
> :yellow_circle: = contribución secundaria (refuerza o soporta el objetivo, pero no es su motor principal).
> 
> **Cómo leer la tabla**
> 
> Ejemplo: la capability “Calificación automática” (fila 3) está marcada como crítica (:green_circle:) para los objetivos 1, 3, 6, 7 y 8 — porque sin ella no podríamos centralizar el proceso, cumplir la meta de “≤ 5 min de procesamiento”, sostener un costo < 0,05 USD/prueba, ni ofrecer la experiencia rápida que impulsa el NPS y la conversión a pago.
>
> Cobertura: cada objetivo estratégico tiene al menos una capability marcada :green_circle:, lo que confirma que el alcance funcional respalda todos los resultados deseados.
>
> Priorización: las capabilities con más :green_circle: (por ejemplo, 6. Escalabilidad & adaptabilidad) son pilares arquitectónicos; retrasarlas afectaría varios objetivos y KPI a la vez.

### Alcance del MVP
El **MVP** (Minimum Viable Product) de GRADE define el conjunto mínimo de funcionalidades necesarias para validar la propuesta de valor con docentes independientes y recoger aprendizaje temprano sin sobredimensionar el proyecto. El objetivo es entregar una herramienta funcional ―aunque aún limitada― que permita cubrir el ciclo completo de una evaluación (desde la generación de preguntas hasta la publicación de resultados) y, al mismo tiempo, sentar las bases técnicas sobre las que evolucionará la plataforma.

En esta fase no se busca reemplazar soluciones institucionales de gran escala, sino demostrar que un flujo centralizado, seguro y fácil de usar puede ahorrar tiempo al profesorado, ofrecer métricas básicas de desempeño y generar suficiente tracción de mercado para justificar las siguientes iteraciones.

> _Nota_: Los detalles operativos (fechas, métricas de límite y precios) se ajustarán en la fase comercial. La descripción que sigue establece una **línea base** que podrá refinarse cuando se publique el documento de alcance detallado.

- **Destinatarios**: docentes (particulares, titulares, adjuntos, freelance) que actúan de forma independiente.
- **Funcionalidades cubiertas**:
    1. Generación de bancos de preguntas **con calificación automática**.
    2. Creación de evaluaciones con exportación a PDF o otro formato digital, incluye impresión física.
    3. Calificación automática y conversión a nota (1 – 7 u otro rango configurable).
    4. Reportes básicos de desempeño, que incluyen:
        - **Promedio por evaluación** y tasa de aprobación.
        - **Distribución de notas** (histograma) para detectar sesgos o dispersión.
        - **Índice de dificultad** por ítem (% de respuestas correctas).
        - **Cobertura de resultados de aprendizaje** (qué competencias se evaluaron y cómo se desempeñó la cohorte).

> **Nota sobre la primera iteración (MVP)**  
> El detalle funcional del MVP se documenta en el **[Product Charter](product-charter.md)**.  
> Aquí solo se establece que esta primera versión permitirá a un docente generar, aplicar y calificar sus evaluaciones de forma automática.

---
## Fuera de alcance en esta fase

- Integraciones institucionales complejas (SIS, pagos masivos, SSO).
- Flujos directos para estudiantes, apoderados o administradores de campus.
- Corrección de preguntas abiertas, ensayos extensos o rúbricas complejas.
- Módulos de proctoring, control de copia o supervisión remota.
- Analítica avanzada e IA generativa (planeados para iteraciones futuras).
- Gestión de historiales académicos completos o datos personales ajenos a la evaluación.

---

## Otras consideraciones

### Límites operativos iniciales

| Concepto                         | Límite                | Notas                                      |
|----------------------------------|-----------------------|--------------------------------------------|
| Evaluaciones creadas (Free tier) | **X** por docente/mes | Placeholder; se definirá comercialmente.   |
| Tamaño máximo de PDF             | **Y MB**              | Para evitar sobrecostos de almacenamiento. |
| Retención de resultados          | **Z** años            | Cumple políticas de protección de datos.   |

### Dependencias y supuestos
* **Pasarela de pagos** compatible con micro-suscripciones en los países objetivo.
* Docentes cuentan con conexión a internet para cargar evaluaciones digitalizadas.

---

## Comentarios de los Revisores
### Maximiliano Toledo
| Tipo de comentario | Contenido |
| ------------------ | --------- |
| Ideas Valiosas    | - La definición clara de lo que está adentro y fuera del alcance para evitar expectativas equivocadas.<br>- Solidez del banco de preguntas evitando la duplicidad de estas.<br>- Dejar claro que la función del sistema se limita al ciclo de vida de una evaluación.<br>- Dejar claros los límites de la seguridad propia y externa. |
| Mejoras           | Incluir supuestos basados en la flexibilidad en la que podría evolucionar el sistema en el contexto del ciclo de vida de una evaluación. |
| Descartar         | Nada que descartar. Todo el contenido es preciso para comprender el sistema GRADE. |
| Dudas             | ¿Cómo se comunicarán los resultados de las evaluaciones?<br>¿Se puede adaptar el banco de preguntas según lo requiera la institución? |
| Incongruencias    | No se han encontrado incongruencias, ya que no se han analizado aún los recursos que se utilizarán para el sistema. |

### Rodrigo Ulloa
| Tipo de comentario | Contenido |
| ------------------ | --------- |
| Ideas Valiosas    | - Integración regulada:<br>  Las APIs para aplicaciones académicas registradas aseguran que las soluciones externas se alineen con los estándares de Wanku sin sacrificar seguridad. |
| Mejoras           | Falta detallar cómo se gestionará el crecimiento del banco de preguntas. |
| Descartar         | Nada que descartar. |
| Dudas             | - ¿Quién será responsable de garantizar que los metadatos (dificultad, rúbricas) sean correctos?<br>- ¿Habrá un equipo de revisión? |
| Incongruencias    | El sistema excluye corrección de preguntas abiertas, pero no aclara si habrá mecanismos híbridos. |

### Paolo Vilches
| Tipo de comentario | Contenido |
| ------------------ | --------- |
| Ideas Valiosas    | - Configuración flexible de criterios de calificación, que permiten adaptar el sistema a diversas instituciones<br>- Escalabilidad que permite anticipar crecimiento sin rediseñar desde cero<br>- Registro de resultados con fines de auditoría y análisis |
| Mejoras           | - Especificar si el sistema permitirá importar preguntas ya existentes desde otras plataformas<br>- Especificar si las versiones PDF tienen alguna validación digital, como códigos únicos o marcas de agua (por seguridad y trazabilidad principalmente) |
| Descartar         | Sin contenido que descartar |
| Dudas             | - ¿Habrán herramientas de búsqueda o filtros avanzados dentro del banco de ítems?<br>- En el registro para análisis y auditoría, ¿qué datos exactos se almacenan y por cuánto tiempo? |
| Incongruencias    | Sin incongruencias que considerar |
---

[< Anterior](vision.md) | [Inicio](README.md) | [Siguiente >](actors.md)