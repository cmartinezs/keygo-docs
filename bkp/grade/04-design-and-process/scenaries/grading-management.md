# Escenarios de usuario para Gestión de Evaluación

> A continuación se presentan varios escenarios de usuario que ilustran cómo diferentes actores interactúan con el sistema GRADE para gestionar evaluaciones, desde la creación hasta la publicación de resultados. Cada escenario incluye el objetivo, los pasos principales y los criterios de éxito.

[Volver](README.md#-gestión-de-evaluación)

## Contenido

- [S-GE-01 | Gestionar cursos](#s-ge-01--gestionar-cursos)
- [S-GE-02 | Gestionar alumnos](#s-ge-02--gestionar-alumnos)
- [S-GE-03 | Crear evaluación desde el banco](#s-ge-03--crear-evaluación-desde-el-banco)
- [S-GE-04 | Generar entregable con ID/QR](#s-ge-04--generar-entregable-con-idqr)
- [S-GE-05 | Asociar evaluación a curso/sección (alumnos)](#s-ge-05--asociar-evaluación-a-cursosección-alumnos)
- [S-GE-06 | Aplicar evaluación y registrar aplicación](#s-ge-06--aplicar-evaluación-y-registrar-aplicación)
- [S-GE-07 | Cargar respuestas por CSV tabulado](#s-ge-07--cargar-respuestas-por-csv-tabulado)
- [S-GE-08 | Recibir lotes desde Ingesta móvil](#s-ge-08--recibir-lotes-desde-ingesta-móvil)
- [S-GE-09 | Calificación automática](#s-ge-09--calificación-automática)
- [S-GE-10 | Manejar errores de ingesta (OCR/CSV)](#s-ge-10--manejar-errores-de-ingesta-ocrcsv)
- [S-GE-11 | Publicar y consultar resultados](#s-ge-11--publicar-y-consultar-resultados)
- [S-GE-12 | Exportar resultados (CSV/PDF)](#s-ge-12--exportar-resultados-csvpdf)
- [S-GE-13 | Notificar hitos](#s-ge-13--notificar-hitos)
- [S-GE-14 | Auditoría y consulta de historial](#s-ge-14--auditoría-y-consulta-de-historial)
- [S-GE-15 | Administración del sistema](#s-ge-15--administración-del-sistema)
- [S-GE-16 | Integración con sistemas externos (básica)](#s-ge-16--integración-con-sistemas-externos-básica)

## S-GE-01 | Gestionar cursos

**Título:** Crear y mantener cursos en el sistema

**Contexto:**  
Rodrigo, coordinador académico, necesita que las evaluaciones se vinculen a cursos específicos.  
Para eso debe existir un catálogo de cursos previamente configurado.

**Actor principal:**  
Coordinador / Administrador

**Necesidad / objetivo:**  
Rodrigo debe **crear, editar o dar de baja cursos** en GRADE para que los docentes puedan asociar evaluaciones a ellos.

**Motivación / valor:**
- Garantizar que cada evaluación esté vinculada a un curso válido.
- Evitar inconsistencias en nombres y asignaciones.
- Centralizar la administración de cursos de la institución.

**Resultado esperado:**  
El sistema mantiene un catálogo actualizado de cursos, disponible al momento de crear o asociar evaluaciones.

[Volver al índice](#contenido)

---

## S-GE-02 | Gestionar alumnos

**Título:** Registrar y administrar los alumnos asociados a cursos

**Contexto:**  
María Fernanda, administradora académica, debe asegurar que los resultados de las evaluaciones queden vinculados a cada estudiante correctamente.

**Actor principal:**  
Administrador

**Necesidad / objetivo:**  
María Fernanda necesita **registrar alumnos en el sistema** y asociarlos a cursos, ya sea manualmente o importando desde un archivo CSV.

**Motivación / valor:**
- Asegurar que las notas estén asociadas al estudiante correcto.
- Permitir reportes por alumno y análisis de desempeño individual.
- Facilitar la integración con sistemas de gestión académica.

**Resultado esperado:**  
El sistema mantiene un listado de alumnos asociado a cada curso, disponible para registrar resultados de evaluaciones.

[Volver al índice](#contenido)

---

## S-GE-03 | Crear evaluación desde el banco

**Título:** Componer una evaluación a partir de ítems vigentes

**Contexto:**  
María Fernanda, profesora de historia, debe preparar una prueba para su curso de 3º medio.  
Quiere reutilizar preguntas ya registradas en el Banco de preguntas, en lugar de crear nuevas desde cero.

**Actor principal:**  
Docente (o Coordinador)

**Precondiciones:**
- El curso ya está registrado en el sistema (**S-GE-01 | Gestionar cursos**).
- Los alumnos ya están asociados a ese curso (**S-GE-02 | Gestionar alumnos**).

**Necesidad / objetivo:**  
María Fernanda necesita **seleccionar preguntas del Banco** y **armar una evaluación** completa, definiendo fecha, duración y curso al que será aplicada.

**Motivación / valor:**
- Ahorra tiempo reutilizando preguntas ya validadas.
- Asegura coherencia con el currículo.
- Permite dejar la evaluación lista en estado *Borrador* para revisiones posteriores.

**Escenario narrativo:**  
María Fernanda accede al módulo de Gestión de evaluación y elige “Nueva evaluación”.  
El sistema le solicita ingresar metadatos básicos (nombre, curso, fecha, duración).  
Luego, abre la búsqueda del Banco de preguntas (con filtros de tema, dificultad y unidad).  
María selecciona las preguntas necesarias y guarda la evaluación como **Borrador**.  
GRADE confirma el registro y le asigna un identificador único.

**Resultado esperado:**  
La evaluación queda almacenada en el sistema en estado **Borrador**, con sus ítems asociados y lista para ser revisada, editada o transformada en entregable.

[Volver al índice](#contenido)

---

## S-GE-04 | Generar entregable con ID/QR

**Título:** Generar un entregable de evaluación con identificador único

**Contexto:**  
Rodrigo, profesor de matemáticas, ya tiene una evaluación en estado *Borrador*.  
Necesita producir un documento aplicable que pueda entregar a sus estudiantes, garantizando la trazabilidad de cada copia.

**Actor principal:**  
Docente

**Precondiciones:**
- El curso existe en el sistema (**S-GE-01 | Gestionar cursos**).
- Los alumnos están asociados a ese curso (**S-GE-02 | Gestionar alumnos**).
- La evaluación está registrada en estado *Borrador* (**S-GE-03 | Crear evaluación desde el banco**).

**Necesidad / objetivo:**  
Rodrigo quiere **generar un PDF** de la evaluación con un **identificador único (código/QR/marca de agua)** para cada entregable.

**Motivación / valor:**
- Garantizar la trazabilidad de cada prueba aplicada.
- Asegurar que no existan duplicados sin control.
- Facilitar la vinculación posterior de las respuestas al entregable original.

**Escenario narrativo:**  
Rodrigo accede a su evaluación en estado *Borrador* y selecciona la opción “Generar entregable”.  
El sistema produce un archivo PDF con la evaluación, insertando un **identificador único** en cada copia.  
El estado de la evaluación cambia a **Listo para aplicar**, y GRADE registra el evento en el historial de auditoría.

**Resultado esperado:**  
El entregable queda disponible en formato PDF con identificador único, asociado a la evaluación, y listo para ser aplicado a los estudiantes.

[Volver al índice](#contenido)

---

## S-GE-05 | Asociar evaluación a curso/sección (alumnos)

**Título:** Vincular la evaluación con un curso y sus estudiantes

**Contexto:**  
Maxi, profesor de lenguaje, ya tiene una evaluación creada en estado *Borrador* y necesita vincularla a su curso para que los resultados queden registrados por estudiante.

**Actor principal:**  
Docente

**Precondiciones:**
- El curso ya existe en el catálogo institucional (**S-GE-01 | Gestionar cursos**).
- Los alumnos ya están registrados y asociados a ese curso (**S-GE-02 | Gestionar alumnos**).

**Necesidad / objetivo:**  
Maxi quiere **asociar la evaluación a un curso/sección**, asegurando que cada resultado quede vinculado a un estudiante.

**Motivación / valor:**
- Evitar confusión en la asignación de resultados.
- Permitir reportes por estudiante y estadísticas agregadas.
- Integrar con sistemas institucionales para trazabilidad.

**Escenario narrativo:**  
Maxi ingresa a la evaluación en estado *Borrador* y selecciona “Asociar curso”.  
El sistema le muestra los cursos disponibles y su lista de alumnos ya registrada.  
Maxi confirma la asociación y el sistema vincula automáticamente la evaluación al curso y sus estudiantes.

**Resultado esperado:**  
La evaluación queda asociada a un curso y a su lista de alumnos, permitiendo registrar resultados individualmente y generar reportes consolidados.

[Volver al índice](#contenido)

---

## S-GE-06 | Aplicar evaluación y registrar aplicación

**Título:** Marcar la evaluación como aplicada y habilitar la recepción de respuestas

**Contexto:**  
Carlos M., profesor de física, ya tiene lista su evaluación con los ítems seleccionados, el entregable generado y asociada a su curso.  
El día del examen, aplica la prueba en formato físico a los estudiantes y necesita dejar constancia en el sistema.

**Actor principal:**  
Docente

**Precondiciones:**
- El curso está registrado (**S-GE-01 | Gestionar cursos**).
- Los alumnos están asociados a ese curso (**S-GE-02 | Gestionar alumnos**).
- La evaluación cuenta con un entregable generado (**S-GE-04 | Generar entregable con ID/QR**).

**Necesidad / objetivo:**  
Carlos M. quiere **marcar la evaluación como aplicada** en el sistema para habilitar la recepción de respuestas provenientes de CSV o de la Ingesta móvil.

**Motivación / valor:**
- Registrar de manera oficial el momento de aplicación de la evaluación.
- Permitir que el sistema espere y valide respuestas asociadas al entregable.
- Mantener trazabilidad en el ciclo de vida de la prueba.

**Escenario narrativo:**  
Carlos M. ingresa a la evaluación desde el módulo de Gestión y selecciona la opción “Aplicar evaluación”.  
El sistema solicita confirmación y cambia el estado a **Aplicada**.  
A partir de ese momento, GRADE permite la carga de respuestas (por archivo CSV o desde la app de Ingesta móvil) y registra la fecha/hora del evento en la auditoría.

**Resultado esperado:**  
La evaluación cambia de estado a **Aplicada**, habilitando la recepción de respuestas y dejando trazabilidad del momento en que fue tomada por los estudiantes.

[Volver al índice](#contenido)

---

## S-GE-07 | Cargar respuestas por CSV tabulado

**Título:** Subir respuestas de estudiantes a través de un archivo CSV

**Contexto:**  
Ernesto, profesor de matemáticas, aplicó su evaluación en papel y recolectó las hojas de respuesta.  
La institución cuenta con un proceso que digitaliza las respuestas en una planilla CSV, y ahora Ernesto debe cargarla al sistema.

**Actor principal:**  
Docente

**Necesidad / objetivo:**  
Ernesto quiere **subir un archivo CSV con las respuestas de sus estudiantes**, para que GRADE las registre y procese en la etapa de calificación automática.

**Motivación / valor:**
- Evitar ingreso manual de datos.
- Estandarizar la carga de resultados con plantillas claras.
- Reducir errores y tiempos de trabajo para el docente.

**Escenario narrativo:**  
Ernesto accede a su evaluación en estado **Aplicada** y selecciona la opción “Cargar respuestas (CSV)”.  
El sistema le permite subir el archivo y valida su formato:
- Si es correcto, registra las respuestas y confirma la carga.
- Si hay errores (formato inválido, filas incompletas, alumnos no asociados), muestra un reporte de fallas para que Ernesto corrija y vuelva a intentar.

Una vez aceptado el archivo, las respuestas quedan registradas y la evaluación avanza a la etapa de **Calificación automática**.

**Resultado esperado:**  
Las respuestas de los estudiantes quedan registradas correctamente en GRADE, listas para el proceso de calificación.

[Volver al índice](#contenido)

---

## S-GE-08 | Recibir lotes desde Ingesta móvil

**Título:** Incorporar respuestas capturadas desde la aplicación móvil

**Contexto:**  
Rodrigo, profesor de biología, aplicó su evaluación en formato físico y decidió utilizar la aplicación de Ingesta móvil para capturar las hojas de respuesta de sus estudiantes.  
Ahora el sistema central debe recibir y validar esas capturas.

**Actor principal:**  
Sistema (backend de Gestión de evaluación)

**Necesidad / objetivo:**  
El sistema debe **recibir los lotes de respuestas enviados desde la app móvil**, validarlos y asociarlos automáticamente a la evaluación correspondiente.

**Motivación / valor:**
- Permitir un flujo ágil de captura digital desde el aula.
- Reducir errores humanos en la tabulación manual.
- Asegurar la trazabilidad entre entregable físico y respuestas digitalizadas.

**Escenario narrativo:**  
Rodrigo captura las hojas de respuesta con la aplicación de Ingesta móvil.  
La app envía un lote de imágenes al backend de Gestión de evaluación junto con el identificador de la evaluación (QR/ID).  
El sistema procesa el lote:
- Valida el ID de la evaluación.
- Efectúa OCR en cada imagen para extraer las respuestas.
- Normaliza y almacena las respuestas por alumno.
- Genera un resumen de la carga y lo registra en la auditoría.

**Resultado esperado:**  
Las respuestas enviadas desde la Ingesta móvil quedan registradas y asociadas a la evaluación correspondiente, habilitando la calificación automática.

[Volver al índice](#contenido)

---

## S-GE-09 | Calificación automática

**Título:** Calificar automáticamente las respuestas cargadas

**Contexto:**  
María Fernanda, profesora de historia, ya aplicó su evaluación y tiene las respuestas cargadas en GRADE (ya sea por CSV o por Ingesta móvil).  
Ahora necesita que el sistema realice la corrección automática para obtener las notas de sus estudiantes.

**Actor principal:**  
Sistema (con supervisión del Docente)

**Necesidad / objetivo:**  
El sistema debe **comparar las respuestas de los estudiantes con la clave de corrección** y generar puntajes y notas de manera automática.

**Motivación / valor:**
- Ahorro de tiempo para el docente.
- Estandarización en la corrección.
- Minimizar errores humanos.

**Escenario narrativo:**  
María Fernanda accede a su evaluación en estado **Aplicada** y selecciona “Calificar automáticamente”.  
El sistema procesa las respuestas cargadas:
- Compara cada respuesta con la clave definida en la evaluación.
- Calcula puntaje y nota de cada estudiante.
- Registra los resultados en el sistema.
- Cambia el estado de la evaluación a **Calificada**.
- Genera un log de auditoría con métricas de tiempo y errores detectados.

**Resultado esperado:**  
Los resultados de la evaluación quedan almacenados por estudiante, la evaluación pasa al estado **Calificada** y los docentes tienen acceso inmediato a las notas.

[Volver al índice](#contenido)

---

## S-GE-10 | Manejar errores de ingesta (OCR/CSV)

**Título:** Resolver errores detectados en la carga de respuestas

**Contexto:**  
Carlitos, profesor de química, cargó las respuestas de su evaluación usando un archivo CSV.  
Al procesarlo, el sistema detectó errores en varias filas (alumnos no asociados y columnas incompletas).  
En otro curso, al usar la Ingesta móvil, se presentaron errores de lectura OCR por mala calidad de las fotos.

**Actor principal:**  
Docente

**Necesidad / objetivo:**  
Carlitos necesita **detectar, revisar y resolver los errores** en la carga de respuestas para que estas puedan ser utilizadas en la calificación automática.

**Motivación / valor:**
- Garantizar la integridad de los datos cargados.
- Evitar que respuestas erróneas afecten el cálculo de notas.
- Proveer retroalimentación clara al docente para corregir problemas.

**Escenario narrativo:**  
Carlitos sube un archivo CSV y el sistema valida la información.
- Si encuentra errores, genera un reporte detallado (línea, columna, tipo de error).
- El sistema bloquea la carga hasta que los errores sean corregidos.  
  En el caso de OCR, las imágenes con baja confianza son marcadas y listadas en un reporte, ofreciendo la opción de reintentar el reconocimiento o repetir la captura.  
  Carlitos corrige el CSV y lo sube nuevamente, logrando que el sistema acepte la carga.

**Resultado esperado:**  
El sistema detecta y reporta los errores de ingesta de forma clara, permitiendo que el docente corrija y vuelva a cargar los datos, garantizando así que las respuestas sean válidas para la calificación.

[Volver al índice](#contenido)

---

## S-GE-11 | Publicar y consultar resultados

**Título:** Publicar los resultados de la evaluación y consultarlos

**Contexto:**  
Ernesto, profesor de matemáticas, ya tiene su evaluación en estado **Calificada**.  
Necesita publicar los resultados para sus estudiantes y además revisar estadísticas básicas de desempeño de la prueba.

**Actor principal:**  
Docente (Coordinador accede a vistas agregadas)

**Necesidad / objetivo:**  
Ernesto quiere **publicar los resultados** de la evaluación para que queden disponibles y luego **consultar estadísticas básicas** como promedio, mediana y desempeño por ítem.

**Motivación / valor:**
- Dar retroalimentación rápida a los estudiantes.
- Contar con estadísticas básicas para análisis pedagógico.
- Mantener control sobre qué resultados son visibles y cuándo.

**Escenario narrativo:**  
Ernesto accede a su evaluación en estado **Calificada** y selecciona la opción “Publicar resultados”.  
El sistema solicita confirmación y cambia el estado a **Publicado**.  
Automáticamente se habilitan estadísticas como:
- Promedio y mediana de notas.
- Distribución de calificaciones.
- Porcentaje de acierto por pregunta.

El Coordinador académico, desde su rol, accede a una vista agregada con estadísticas generales, sin acceso a respuestas individuales.

**Resultado esperado:**  
La evaluación pasa a estado **Publicado**, los resultados individuales y agregados quedan disponibles según rol, y el sistema ofrece estadísticas básicas de desempeño.

[Volver al índice](#contenido)

---

## S-GE-12 | Exportar resultados (CSV/PDF)

**Título:** Exportar los resultados de una evaluación en formatos externos

**Contexto:**  
María Fernanda, profesora de historia, publicó los resultados de su última evaluación.  
Ahora necesita compartirlos con su jefatura y conservar una copia para sus propios registros en un formato estándar.

**Actor principal:**  
Docente (Coordinador puede exportar resultados agregados)

**Necesidad / objetivo:**  
María Fernanda quiere **exportar los resultados de la evaluación** en un archivo **CSV o PDF** que pueda compartir o almacenar fuera de GRADE.

**Motivación / valor:**
- Facilitar la comunicación de resultados a autoridades académicas.
- Contar con un respaldo fuera del sistema.
- Posibilidad de trabajar con los datos en hojas de cálculo.

**Escenario narrativo:**  
María Fernanda ingresa a la sección de resultados de la evaluación y selecciona “Exportar resultados”.  
El sistema ofrece dos opciones de exportación:
- **CSV**: archivo tabular con resultados por estudiante.
- **PDF**: reporte visual con estadísticas y detalle por alumno.

El sistema genera el archivo seleccionado y notifica que la exportación fue exitosa.  
En caso de error (ej. falla de red), se muestra un mensaje claro y se permite reintentar.

**Resultado esperado:**  
Los resultados de la evaluación se generan en formato CSV o PDF y quedan disponibles para descarga, asegurando compatibilidad y portabilidad de la información.

[Volver al índice](#contenido)

---

## S-GE-13 | Notificar hitos

**Título:** Enviar notificaciones sobre eventos clave en el ciclo de evaluación

**Contexto:**  
Rodrigo, profesor de biología, aplica varias evaluaciones en un semestre.  
Le resulta difícil estar pendiente de cuándo se completó la calificación automática o si hubo errores en la carga de respuestas.

**Actor principal:**  
Sistema (usuarios destinatarios: Docente, Coordinador, Administrador)

**Necesidad / objetivo:**  
El sistema debe **enviar notificaciones** a los usuarios correspondientes cuando ocurren hitos importantes, como:
- Finalización del proceso de calificación.
- Publicación de resultados.
- Errores detectados en la ingesta de respuestas.

**Motivación / valor:**
- Mantener a los docentes informados sin necesidad de revisar constantemente el sistema.
- Asegurar tiempos de reacción rápidos ante errores.
- Mejorar la experiencia de uso y la eficiencia del proceso.

**Escenario narrativo:**  
Rodrigo sube respuestas desde la Ingesta móvil y el sistema inicia la calificación automática.  
Al terminar, GRADE envía una **notificación in-app** confirmando que los resultados ya están disponibles.  
Si en otro caso ocurre un error en la carga de un CSV, el sistema notifica de inmediato al docente con un mensaje explicativo.  
En fases futuras, estas notificaciones también podrían enviarse por correo electrónico o integrarse a sistemas institucionales.

**Resultado esperado:**  
Los docentes y coordinadores reciben notificaciones oportunas sobre hitos clave, lo que les permite actuar sin tener que monitorear manualmente el estado de cada evaluación.

[Volver al índice](#contenido) 

---

## S-GE-14 | Auditoría y consulta de historial

**Título:** Revisar el historial de acciones realizadas en las evaluaciones

**Contexto:**  
Carlos M., administrador del sistema, debe verificar quién realizó cambios en una evaluación, en qué momento y qué acciones se ejecutaron.  
Esto es necesario para cumplir con los procesos internos de control y para responder a solicitudes de revisión de la dirección académica.

**Actor principal:**  
Administrador

**Necesidad / objetivo:**  
Carlos M. necesita **consultar el historial de acciones** en el sistema, filtrando por usuario, fecha, evaluación o tipo de acción, para obtener evidencia clara de lo ocurrido.

**Motivación / valor:**
- Asegurar la trazabilidad de todas las operaciones en GRADE.
- Respaldar decisiones académicas con evidencia.
- Facilitar auditorías internas o externas.

**Escenario narrativo:**  
Carlos M. accede al módulo de Auditoría dentro de la Gestión de evaluación.  
Allí aplica filtros de búsqueda (por usuario, evaluación y rango de fechas).  
El sistema le muestra un listado de eventos que incluye:
- Usuario responsable.
- Fecha y hora de la acción.
- Tipo de operación realizada (creación, edición, publicación, carga de respuestas, etc.).
- Resultado de la operación (éxito o error).

Carlos M. exporta el resultado de la búsqueda en formato CSV para presentarlo en un informe institucional.

**Resultado esperado:**  
El sistema ofrece un historial completo, filtrable y exportable de las acciones realizadas, garantizando transparencia y trazabilidad en el uso de GRADE.

[Volver al índice](#contenido)

---

## S-GE-15 | Administración del sistema

**Título:** Configurar parámetros globales, usuarios y políticas de uso del sistema

**Contexto:**  
Ernesto, administrador institucional, necesita mantener GRADE alineado con las políticas académicas de la institución.  
Esto incluye configurar escalas de calificación, gestionar usuarios y definir reglas de operación globales.

**Actor principal:**  
Administrador

**Necesidad / objetivo:**  
Ernesto requiere **administrar los parámetros centrales del sistema**, asegurando que su funcionamiento sea consistente con los lineamientos institucionales.

**Motivación / valor:**
- Mantener consistencia en las evaluaciones (ej. escalas de notas homogéneas).
- Controlar el acceso al sistema mediante gestión de usuarios y roles.
- Adaptar el sistema a cambios en políticas académicas sin depender de desarrollo.

**Escenario narrativo:**  
Ernesto accede al módulo de Administración y realiza tareas como:
- Configurar la escala de notas (ej. 1.0 a 7.0 o 0 a 100).
- Crear, editar o desactivar usuarios.
- Asignar roles (Docente, Coordinador, Administrador).
- Definir políticas como cantidad máxima de ítems por evaluación o límites de tiempo.

El sistema registra todas las operaciones en la auditoría, garantizando trazabilidad.

**Resultado esperado:**  
Los parámetros globales y usuarios de GRADE quedan configurados según las políticas institucionales, manteniendo consistencia y control en todo el sistema.

[Volver al índice](#contenido)

---

## S-GE-16 | Integración con sistemas externos (básica)

**Título:** Conectar GRADE con aplicaciones externas mediante APIs

**Contexto:**  
Maxi, administrador técnico de la institución, necesita que GRADE comparta información con otros sistemas académicos, como el sistema de gestión de alumnos (SIGA) y plataformas de reportes.

**Actor principal:**  
Integrador / Administrador

**Necesidad / objetivo:**  
Maxi requiere **integrar GRADE con sistemas externos**, permitiendo que otras aplicaciones puedan crear evaluaciones, enviar respuestas o consultar resultados a través de APIs.

**Motivación / valor:**
- Reducir la duplicidad de datos entre plataformas.
- Facilitar que los resultados de GRADE se reflejen automáticamente en sistemas institucionales.
- Abrir la puerta a ecosistemas más amplios de analítica y seguimiento académico.

**Escenario narrativo:**  
Maxi accede al módulo de integraciones y genera credenciales seguras (API key / token OAuth2).  
Un sistema externo realiza una llamada a la API de GRADE para crear una evaluación con ítems ya definidos en el Banco de preguntas.  
El sistema valida las credenciales, registra la petición en auditoría y devuelve confirmación con el ID de la evaluación creada.  
Más tarde, otra aplicación externa consulta los resultados de un curso, obteniendo un archivo en formato JSON.

**Resultado esperado:**  
GRADE se comunica de forma segura con aplicaciones externas mediante APIs documentadas, registrando todas las interacciones y facilitando la interoperabilidad institucional.

[Volver al índice](#contenido) 
