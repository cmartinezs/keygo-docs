# Contexto y motivación

## Contenido
* [Presentación](#presentación)
* [Puntos críticos](#puntos-críticos)
  * [Diseño y conceptualización](#diseño-y-conceptualización)
  * [Centralización inicial como fundamento estratégico](#centralización-inicial-como-fundamento-estratégico)
  * [Simplicidad, modularidad y escalabilidad](#simplicidad-modularidad-y-escalabilidad)
  * [Enfoque en la seguridad y la consistencia](#enfoque-en-la-seguridad-y-la-consistencia)
  * [Iteración y evolución continua](#iteración-y-evolución-continua)
  * [Orientación a la experiencia del usuario](#orientación-a-la-experiencia-del-usuario)
* [Observaciones](#observaciones)
* [Comentarios de los Revisores](#comentarios-de-los-revisores)

## Presentación
En esta fase temprana, Wanku está delineando las primeras piezas de un portafolio de soluciones que llegará directamente al mercado. La experiencia y el conocimiento acumulado en el equipo han puesto de manifiesto la necesidad de establecer, desde el inicio, un **sistema de generación, distribución y corrección automatizada de evaluaciones**. Aunque aún no se han desplegado aplicaciones operativas, esta iniciativa surge como respuesta a la oportunidad de definir un producto comercial robusto que, desde su concepción, unifique y estandarice la creación, distribución y corrección de pruebas. Esta solución no solo facilitará la coherencia pedagógica y la trazabilidad de los resultados en las aplicaciones emergentes, sino que también sentará las bases para la evolución de nuevos servicios educativos, permitiendo un crecimiento consistente y escalable a medida que se amplíe el ecosistema de Wanku.

Esta propuesta se fundamenta en la experiencia acumulada del equipo y en una visión compartida para el futuro de Wanku; se concibe, además, como un nuevo producto que se integrará al ecosistema de servicios enfocados en la educación. No obstante, resulta esencial detallar ciertos puntos críticos que delimitan el alcance y las posibles restricciones de la solución, con el fin de ajustar expectativas y garantizar una comprensión realista.

## Puntos críticos

### Diseño y conceptualización
Los conceptos definidos para esta solución se apoyan en los principios ya consolidados por los demás servicios educativos de Wanku y actuarán como cimiento para la incorporación de funcionalidades futuras. La propuesta establece las directrices que orientarán el desarrollo y su integración dentro del ecosistema, sin implicar todavía una implementación operativa completa.

### Centralización inicial como fundamento estratégico
Se propone un sistema unificado para la generación, distribución y corrección de evaluaciones que, desde su concepción, se integra como producto comercial dentro del ecosistema de servicios educativos de Wanku. Su alcance inicial se orienta a consolidar los procesos de creación de pruebas, gestión de bancos de preguntas y calificación automatizada, alineándose con las directrices y estándares ya vigentes en los demás servicios de la plataforma. De este modo, las aplicaciones educativas actuales y futuras podrán incorporarlo de forma coherente y escalable, garantizando consistencia pedagógica y operativa.

### Simplicidad, modularidad y escalabilidad
La solución se diseña como un componente ligero y desacoplado dentro del ecosistema educativo de Wanku, de modo que se integre sin fricciones con los servicios ya disponibles (portales de contenidos, seguimiento académico, analíticas). Su arquitectura por módulos —banco de preguntas, generador de PDFs, motor de calificación, entre otros— permite añadir o sustituir funcionalidades sin impactar el núcleo. Además, está preparada para escalar horizontalmente, manteniendo un rendimiento consistente a medida que crece el número de docentes, alumnos y evaluaciones procesadas, todo ello sin comprometer la seguridad ni la experiencia de usuario.

### Enfoque en la seguridad y la consistencia
Un pilar central de la propuesta es disponer de un flujo único y controlado para la generación, distribución y corrección de evaluaciones. Al evitar la dispersión de mecanismos y herramientas ad-hoc se minimizan los riesgos de filtración de contenidos, fraude académico o pérdida de trazabilidad; al mismo tiempo, todas las aplicaciones educativas de Wanku comparten políticas y procesos de validación uniformes—desde la versión oficial de cada prueba hasta la verificación automática de respuestas—lo que se traduce en mayor integridad, control y confianza en los resultados.

### Iteración y evolución continua
Conscientes de que las demandas pedagógicas y el entorno tecnológico cambian con rapidez, este servicio de generación y registro de evaluaciones se concibe como un proyecto vivo dentro del ecosistema educativo de Wanku. Un roadmap incremental—nutrido por la retroalimentación de docentes, estudiantes y equipos de análisis—permitirá ajustar y ampliar funcionalidades (nuevos tipos de preguntas, analíticas avanzadas, integraciones adicionales) conforme se descubran necesidades emergentes, garantizando así que la plataforma se mantenga adaptable, pertinente y alineada con el resto de los servicios de la suite.

### Orientación a la experiencia del usuario
La unificación de la creación, distribución y corrección de evaluaciones está concebida para simplificar el trabajo de docentes y estudiantes. Al eliminar la multiplicidad de herramientas y pasos dispersos —desde la configuración del banco de preguntas hasta el traspaso de calificaciones— se optimiza la usabilidad y la eficiencia operativa. El resultado es un flujo único, intuitivo y seguro que reduce fricciones, libera tiempo para la enseñanza y garantiza una interacción coherente con el resto de los servicios educativos de Wanku.

## Observaciones
Es importante destacar que, aunque esta propuesta establece un marco conceptual y funcional sólido, no se trata de un producto desarrollado ni implementado. La solución se encuentra en una fase inicial de conceptualización y diseño, y su implementación efectiva requerirá un desarrollo posterior que contemple las especificaciones técnicas, la integración con los sistemas existentes y las pruebas necesarias para garantizar su operatividad.

## Comentarios de los Revisores
A continuación se presentan los comentarios de los revisores sobre el contexto y motivación del sistema
### Maximiliano Toledo
| Tipo de comentario | Contenido |
| ------------------ | --------- |
| Ideas Valiosas | La idea de unificar el proceso de evaluación y eliminación de multiplicidad de herramientas.<br>Permitir evolución y mejora continua basada en retroalimentaciones.<br>Seguridad y consistencia clara teniendo control de cada prueba para mayor integridad.<br>Supervisión activa para la identificaciones de nuevas necesidad u oportunidades. |
| Mejoras | No se identificaron mejoras sustanciales. |
| Descartar | No se ha identificado contenido que se podría descartar. |
| Dudas | Al entregar un contexto se crean dudas que se resolverán en las siguientes páginas. |
| Incongruencias | No encuentro incongruencias. |

### Rodrigo Ulloa
| Tipo de comentario | Contenido |
| ------------------ | --------- |
| Ideas Valiosas    | El énfasis en seguridad, trazabilidad y experiencia de usuario aborda problemas críticos en evaluaciones educativas. |
| Mejoras           | Sería útil incluir ejemplos concretos de cómo funcionaría el flujo. |
| Descartar         | Nada que descartar. La propuesta está bien fundamentada en la experiencia del equipo y la visión de Wanku. |
| Dudas             | No tengo dudas en esta etapa. |
| Incongruencias    | No encuentro incongruencias. |

### Paolo Vilches
| Tipo de comentario | Contenido |
| ------------------ | --------- |
| Ideas Valiosas    | - Diseño modular útil para cambiar funciones sin afectar el todo<br>- Escalable horizontalmente sin perder rendimiento/calidad<br>- Se alinea a estándares pedagógicos ya usados en Wanku |
| Mejoras           | - Especificar y profundizar en cómo será la aplicación, como la interoperabilidad con sistemas externos o temas de retroalimentación para el usuario<br>- Quizás simplificar la reiteración de "ecosistema educativo de Wanku", que se menciona muchas veces |
| Descartar         | Sin contenido que descartar |
| Dudas             | - Cómo se valida la calidad de la generación de pruebas<br>- Qué grado de personalización tendrá la generación de pruebas |
| Incongruencias    | - Se dice que el sistema es **ligero y modular**, pero también que todo estará **centralizado y controlado desde un único flujo**. Esto puede ser contradictorio, porque si es muy centralizado suele ser menos flexible. Sería bueno aclarar si la centralización aplica solo a ciertos procesos (como seguridad), mientras que el resto sigue siendo modular y adaptable. |

[< Anterior](README.md) | [Inicio](README.md) | [Siguiente >](vision.md)