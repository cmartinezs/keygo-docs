# Escenarios de usuario y flujos

> Este apartado documenta los principales escenarios de usuario y flujos de trabajo dentro del sistema GRADE, proporcionando una visión clara de cómo los diferentes roles interactúan con la plataforma para gestionar evaluaciones y calificaciones. Para ello se tomó la decision de dividir en tres grandes bloques los escenarios de usuario, cada uno asociado a un dominio funcional clave.

[Volver al HOME](../../README.md#contenido-del-wiki)

## Contenido

- [Banco de preguntas](#-banco-de-preguntas)
    - [T1 Banco de preguntas](#t1-banco-de-preguntas)
- [Gestión de evaluación](#-gestión-de-evaluación)
    - [T2 Gestión de evaluación](#t2-gestión-de-evaluación)
- [Ingesta móvil](#-ingesta-móvil)
    - [T3 Ingesta móvil](#t3-ingesta-móvil)

## 📚 Banco de preguntas

Este dominio concentra todo lo relacionado con la gestión del repositorio centralizado de ítems.
Su objetivo es garantizar la calidad, trazabilidad y reutilización de las preguntas que se utilizan en las evaluaciones.
Aquí se cubren actividades como la creación de ítems, su versionado, búsqueda, control de vigencia y mantenimiento de taxonomías.
El Banco de preguntas es la fuente de verdad pedagógica sobre la cual se construyen las evaluaciones.

Para más detalles, ver [Escenarios de usuario para Banco de Preguntas](questions-bank.md).

### T1 Banco de preguntas

| ID       | Nombre                             | Objetivo                                                                 | RF relacionados       | Criticidad |
|----------|------------------------------------|--------------------------------------------------------------------------|-----------------------|------------|
| S-BP-01  | Crear ítem nuevo                   | Registrar una nueva pregunta con metadatos para futuras evaluaciones.    | RF2, RF7, RF8         | MVP        |
| S-BP-02  | Editar / versionar / clonar ítem   | Actualizar o clonar preguntas manteniendo historial de versiones.        | RF2, RF7, RF8         | MVP        |
| S-BP-03  | Retirar / reactivar ítem           | Controlar la vigencia de las preguntas para evitar uso no deseado.       | RF2, RF7, RF8         | MVP        |
| S-BP-04  | Buscar y seleccionar ítems         | Localizar preguntas por filtros (tema, dificultad, unidad).              | RF2, RF8              | MVP        |
| S-BP-05  | Ver trazabilidad de uso del ítem   | Consultar en qué evaluaciones se utilizó una pregunta y su desempeño.    | RF2, RF8, RF10        | MVP        |
| S-BP-06  | Gestionar taxonomías               | Mantener catálogos de temas/unidades/resultados para etiquetar ítems.    | RF2, RF7, RF13        | MVP        |
| S-BP-07  | Importar ítems desde planillas     | Cargar preguntas en lote desde CSV/plantilla.                            | RF2, RF8              | Futuro     |
| S-BP-08  | Analítica básica de ítems          | Consultar estadísticas de desempeño de las preguntas.                    | RF10                  | Futuro     |

---

## 📝 Gestión de evaluación

Este dominio se encarga del ciclo completo de las evaluaciones: desde la composición de pruebas hasta la publicación de resultados.
Es el núcleo que integra las funcionalidades del banco y del procesamiento, permitiendo a los docentes y coordinadores crear, aplicar, calificar y difundir evaluaciones con trazabilidad y control.
Incluye además la administración de entregables (PDF con identificadores únicos), la carga de respuestas tabuladas, la calificación automática y la consulta/exportación de resultados.
La Gestión de evaluación es el orquestador académico que asegura coherencia en todo el proceso.

Para más detalles, ver [Escenarios de usuario para Gestión de Evaluación](grading-management.md).

### T2 Gestión de evaluación

| ID       | Nombre                                  | Objetivo                                                               | RF relacionados                | Criticidad |
|----------|-----------------------------------------|-----------------------------------------------------------------------|--------------------------------|------------|
| S-GE-01  | Gestionar cursos                        | Crear, editar y mantener cursos en el sistema para asociarlos a evaluaciones. | RF1, RF3, RF13                 | MVP        |
| S-GE-02  | Gestionar alumnos                       | Registrar y administrar alumnos, asociándolos a cursos.               | RF1, RF3, RF13                 | MVP        |
| S-GE-03  | Crear evaluación desde el banco         | Componer una evaluación a partir de ítems vigentes.                   | RF1, RF2, RF3, RF7, RF8        | MVP        |
| S-GE-04  | Generar entregable con ID/QR            | Producir PDF con identificador único para trazabilidad.               | RF1, RF3, RF8                  | MVP        |
| S-GE-05  | Asociar evaluación a curso/sección      | Vincular la evaluación con la lista de estudiantes.                   | RF1, RF3, RF6, RF8             | MVP        |
| S-GE-06  | Aplicar evaluación y registrar aplicación | Marcar evaluación como aplicada y habilitar recepción de respuestas. | RF1, RF3, RF4, RF8             | MVP        |
| S-GE-07  | Cargar respuestas por CSV tabulado      | Subir archivo con respuestas ya digitalizadas.                        | RF4, RF5, RF8                  | MVP        |
| S-GE-08  | Recibir lotes desde Ingesta móvil       | Procesar respuestas enviadas por la app móvil.                        | RF4, RF8                       | MVP        |
| S-GE-09  | Calificación automática                 | Calcular puntajes y convertirlos a notas.                             | RF5, RF1, RF3, RF4, RF8        | MVP        |
| S-GE-10  | Manejar errores de ingesta (OCR/CSV)    | Revisar y resolver errores en cargas de respuestas.                   | RF4, RF8                       | MVP        |
| S-GE-11  | Publicar y consultar resultados         | Publicar notas, ver estadísticas básicas y reportes.                  | RF6, RF10, RF7, RF8            | MVP        |
| S-GE-12  | Exportar resultados                     | Descargar resultados en CSV/PDF.                                      | RF6, RF10                      | MVP        |
| S-GE-13  | Notificar hitos                         | Enviar notificaciones sobre hitos clave.                              | RF11                           | Futuro     |
| S-GE-14  | Auditoría y consulta de historial       | Revisar logs de actividades (quién, cuándo, qué).                     | RF8, RF7                       | MVP        |
| S-GE-15  | Administración del sistema              | Configurar escalas, políticas y usuarios globales.                    | RF13, RF7, RF8                 | Futuro     |
| S-GE-16  | Integración con sistemas externos       | Permitir a aplicaciones externas interactuar con evaluaciones.        | RF12                           | Futuro     |

---

## 📱 Ingesta móvil

Este dominio está orientado a la captura y digitalización de las respuestas de los estudiantes mediante dispositivos móviles.
Permite a docentes o asistentes fotografiar hojas de respuestas con ayuda de guías de encuadre, validar su calidad y enviarlas de forma segura al sistema central.
Funciona como un puente entre lo físico y lo digital, facilitando la ingesta rápida de datos desde el aula y garantizando que lleguen a la Gestión de evaluación para ser calificados.
En fases futuras contempla mejoras como el modo sin conexión, reintentos automáticos y notificaciones de estado.

Para más detalles, ver [Escenarios de usuario para Ingesta Móvil](mobile-ingest.md).

### T3 Ingesta móvil

| ID       | Nombre                              | Objetivo                                                               | RF relacionados     | Criticidad |
|----------|-------------------------------------|------------------------------------------------------------------------|---------------------|------------|
| S-IM-01  | Vincular captura con evaluación     | Identificar la evaluación escaneando QR/ID antes de capturar hojas.    | RF4, RF3            | MVP        |
| S-IM-02  | Capturar hoja de respuestas         | Tomar fotos con guías de encuadre para asegurar legibilidad del OCR.   | RF4, RF8            | MVP        |
| S-IM-03  | Validar calidad y repetir captura   | Detectar mala calidad y solicitar nueva foto antes de enviar.          | RF4, RF8            | MVP        |
| S-IM-04  | Enviar lote y confirmar recepción   | Subir imágenes de forma segura y confirmar recepción en servidor.      | RF4, RF8            | MVP        |
| S-IM-05  | Modo sin conexión y reintentos      | Guardar capturas localmente y reenviar al recuperar señal.             | RF4                 | Futuro     |
| S-IM-06  | Estado de procesamiento y notificación | Mostrar al usuario si el lote fue procesado y si hubo errores.       | RF4, RF11           | Futuro     |

---