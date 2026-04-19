# Escenarios de usuario para Ingesta Móvil

> A continuación se detallan los escenarios de usuario específicos para el dominio de Ingesta Móvil dentro del sistema GRADE. Estos escenarios describen las interacciones típicas que los usuarios tendrán con la aplicación móvil para capturar y enviar respuestas de evaluaciones.

[Volver](README.md#-ingesta-móvil)

## Contenido

- [S-IM-01 | Vincular captura con evaluación (leer QR/ID)](#s-im-01--vincular-captura-con-evaluación-leer-qrid)
- [S-IM-02 | Capturar hoja de respuestas (guías de encuadre)](#s-im-02--capturar-hoja-de-respuestas-guías-de-encuadre)
- [S-IM-03 | Validar calidad y repetir captura](#s-im-03--validar-calidad-y-repetir-captura)
- [S-IM-04 | Enviar lote y confirmar recepción](#s-im-04--enviar-lote-y-confirmar-recepción)
- [S-IM-05 | Modo sin conexión y reintentos](#s-im-05--modo-sin-conexión-y-reintentos)
- [S-IM-06 | Estado de procesamiento y notificación](#s-im-06--estado-de-procesamiento-y-notificación)

## S-IM-01 | Vincular captura con evaluación (leer QR/ID)

**Título:** Identificar la evaluación antes de capturar hojas de respuesta

**Contexto:**  
Rodrigo, profesor de biología, acaba de aplicar una evaluación en formato físico y quiere usar la aplicación de Ingesta móvil para digitalizar las respuestas.  
Antes de capturar las hojas, necesita asegurarse de que las fotos se asocien a la evaluación correcta.

**Actor principal:**  
Docente (o Asistente de aula)

**Precondiciones:**
- La evaluación está en estado **Aplicada** (**S-GE-06 | Aplicar evaluación y registrar aplicación**).
- El entregable contiene un **QR o ID único** generado en el sistema (**S-GE-04 | Generar entregable con ID/QR**).

**Necesidad / objetivo:**  
Rodrigo necesita **vincular la captura de respuestas con la evaluación correspondiente**, escaneando el QR o ingresando manualmente el ID.

**Motivación / valor:**
- Evitar errores al asociar respuestas a evaluaciones equivocadas.
- Simplificar la identificación mediante QR.
- Mantener la trazabilidad entre examen físico y respuestas digitalizadas.

**Escenario narrativo:**  
Rodrigo abre la aplicación de Ingesta móvil y selecciona “Nueva captura de respuestas”.  
La app solicita escanear el **QR de la evaluación** o ingresar el **ID único**.  
Una vez validado, la aplicación confirma el vínculo mostrando el nombre de la evaluación y el curso asociado.  
A partir de ese momento, todas las capturas se relacionan con esa evaluación.

**Resultado esperado:**  
La aplicación móvil establece el vínculo con la evaluación correcta, garantizando que las respuestas capturadas se almacenen y procesen en el contexto adecuado.  

[Volver al índice](#contenido)

---

## S-IM-02 | Capturar hoja de respuestas (guías de encuadre)

**Título:** Tomar fotos de las hojas de respuestas con asistencia visual

**Contexto:**  
María Fernanda, profesora de historia, terminó de aplicar una evaluación y quiere usar la app de Ingesta móvil para digitalizar rápidamente las respuestas de sus estudiantes.  
Necesita asegurarse de que las fotos queden legibles para el procesamiento posterior.

**Actor principal:**  
Docente (o Asistente de aula)

**Precondiciones:**
- La evaluación ya está vinculada en la app mediante QR/ID (**S-IM-01 | Vincular captura con evaluación**).
- La evaluación se encuentra en estado **Aplicada** (**S-GE-06 | Aplicar evaluación y registrar aplicación**).

**Necesidad / objetivo:**  
María Fernanda necesita **capturar las hojas de respuesta de los estudiantes** utilizando guías visuales (bordes y marcas de encuadre) para asegurar la correcta lectura posterior por OCR.

**Motivación / valor:**
- Evitar errores por fotos mal tomadas.
- Asegurar legibilidad para minimizar correcciones posteriores.
- Hacer más eficiente el proceso de digitalización en el aula.

**Escenario narrativo:**  
María Fernanda abre la cámara dentro de la app y comienza a fotografiar las hojas de respuesta.  
La aplicación muestra **guías de encuadre** en pantalla (bordes, márgenes y marcas de orientación).  
Cuando una foto cumple con los requisitos de encuadre, la app confirma visualmente que la captura es válida y la guarda en un lote temporal.  
El proceso se repite hasta capturar todas las hojas de respuesta.

**Resultado esperado:**  
Las hojas de respuesta son capturadas con buena calidad y almacenadas en un lote listo para validación y envío al sistema central.

[Volver al índice](#contenido)

---

## S-IM-03 | Validar calidad y repetir captura

**Título:** Verificar la calidad de la foto y repetir si es necesario

**Contexto:**  
Carlitos, asistente de aula, está ayudando a digitalizar las hojas de respuestas con la app de Ingesta móvil.  
Algunas fotos pueden salir movidas, borrosas o mal encuadradas, lo que afectaría la correcta lectura posterior.

**Actor principal:**  
Docente (o Asistente de aula)

**Precondiciones:**
- La evaluación está vinculada en la app mediante QR/ID (**S-IM-01 | Vincular captura con evaluación**).
- El usuario ha comenzado la captura de hojas de respuesta (**S-IM-02 | Capturar hoja de respuestas**).

**Necesidad / objetivo:**  
Carlitos necesita que la app **verifique automáticamente la calidad de la foto** (enfoque, brillo, encuadre) y, en caso de falla, le ofrezca repetir la captura.

**Motivación / valor:**
- Evitar que el procesamiento posterior falle por imágenes de baja calidad.
- Dar feedback inmediato para no perder tiempo en correcciones más adelante.
- Asegurar consistencia en la digitalización.

**Escenario narrativo:**  
Carlitos toma una foto de una hoja de respuestas.  
La app evalúa automáticamente la captura:
- Si la foto está nítida y correctamente encuadrada, la guarda en el lote.
- Si detecta problemas (movimiento, falta de luz, corte de márgenes), muestra un aviso y solicita repetir la foto.  
  Carlitos vuelve a tomar la foto hasta que la app la valida como correcta.

**Resultado esperado:**  
Cada foto de hoja de respuesta queda validada con la calidad suficiente para su lectura automática, garantizando un proceso de ingesta confiable.

[Volver al índice](#contenido)

---

## S-IM-04 | Enviar lote y confirmar recepción

**Título:** Subir capturas de hojas de respuesta al sistema central

**Contexto:**  
Ernesto, profesor de matemáticas, terminó de capturar todas las hojas de respuesta de sus estudiantes con la app de Ingesta móvil.  
Ahora necesita enviarlas al sistema para que queden registradas y listas para el proceso de calificación.

**Actor principal:**  
Docente (o Asistente de aula)

**Precondiciones:**
- La evaluación está vinculada en la app mediante QR/ID (**S-IM-01 | Vincular captura con evaluación**).
- Todas las fotos fueron tomadas y validadas (**S-IM-02 | Capturar hoja de respuestas**, **S-IM-03 | Validar calidad y repetir captura**).
- La evaluación está en estado **Aplicada** (**S-GE-06 | Aplicar evaluación y registrar aplicación**).

**Necesidad / objetivo:**  
Ernesto necesita **enviar el lote de capturas al sistema central** y confirmar que fueron recibidas correctamente.

**Motivación / valor:**
- Garantizar que la información no se pierda.
- Dar tranquilidad al docente al confirmar que el envío fue exitoso.
- Permitir que el sistema central procese los datos sin intervención adicional.

**Escenario narrativo:**  
Ernesto selecciona “Enviar lote” en la app.  
La aplicación empaqueta las capturas y las envía al servidor de GRADE junto con el identificador de la evaluación.  
El sistema central confirma la recepción y la app muestra un mensaje de éxito.  
Si ocurre un error de conexión, la app guarda el lote localmente y ofrece reintentar el envío más tarde.

**Resultado esperado:**  
Las capturas de hojas de respuesta quedan enviadas y confirmadas en el sistema central, listas para ser procesadas y asociadas a la evaluación correspondiente.

[Volver al índice](#contenido)

---

## S-IM-05 | Modo sin conexión y reintentos

**Título:** Capturar y almacenar respuestas sin conexión, con reenvío automático

**Contexto:**  
María Fernanda, profesora de historia, aplica una evaluación en una sala con mala conexión a internet.  
Aun así, necesita digitalizar las hojas de respuestas con la app de Ingesta móvil y asegurarse de que se envíen al sistema cuando vuelva la señal.

**Actor principal:**  
Docente (o Asistente de aula)

**Precondiciones:**
- La evaluación está vinculada en la app mediante QR/ID (**S-IM-01 | Vincular captura con evaluación**).
- La captura de hojas se realiza normalmente (**S-IM-02 | Capturar hoja de respuestas**, **S-IM-03 | Validar calidad**).

**Necesidad / objetivo:**  
María Fernanda necesita que la app **almacene temporalmente las capturas cuando no hay conexión** y que **reanude el envío automáticamente** cuando se restablezca la red.

**Motivación / valor:**
- Asegurar la continuidad del proceso incluso en lugares sin cobertura.
- Evitar pérdida de datos en entornos con conectividad limitada.
- Simplificar la experiencia docente al no tener que preocuparse por el estado de la red.

**Escenario narrativo:**  
María Fernanda captura varias hojas de respuesta mientras está sin conexión.  
La app detecta la falta de internet y guarda el lote en su memoria local.  
Más tarde, cuando detecta señal, la app intenta reenviar automáticamente los lotes pendientes.  
Si el reenvío falla, la app muestra un aviso y permite reintentar manualmente.

**Resultado esperado:**  
Las capturas de hojas de respuesta quedan seguras en la app y se envían al sistema central en cuanto haya conexión, sin pérdida de información.

[Volver al índice](#contenido)

---

## S-IM-06 | Estado de procesamiento y notificación

**Título:** Consultar el estado del procesamiento de las capturas enviadas

**Contexto:**  
Carlitos, asistente de aula, ya envió con la app de Ingesta móvil todas las capturas de hojas de respuesta de una evaluación.  
Quiere asegurarse de que el sistema central procesó correctamente esas capturas y detectar si hubo errores.

**Actor principal:**  
Docente (o Asistente de aula)

**Precondiciones:**
- Las capturas ya fueron enviadas al sistema central (**S-IM-04 | Enviar lote y confirmar recepción**).
- La evaluación está en estado **Aplicada** (**S-GE-06 | Aplicar evaluación y registrar aplicación**).

**Necesidad / objetivo:**  
Carlitos necesita **ver el estado de procesamiento de los lotes enviados**, incluyendo si hubo errores en la lectura o validación de las respuestas.

**Motivación / valor:**
- Dar certeza al usuario de que las capturas fueron procesadas correctamente.
- Permitir actuar rápidamente si un lote tuvo fallas.
- Mejorar la confianza en la digitalización móvil.

**Escenario narrativo:**  
Carlitos accede a la sección “Historial de envíos” en la app.  
El sistema muestra cada lote con su estado: **Procesado correctamente**, **Procesando** o **Con errores**.  
En caso de errores, la app detalla el problema (ej. “respuestas ilegibles en 2 hojas”) y ofrece opciones para corregirlas (reintentar captura, subir un CSV).

**Resultado esperado:**  
El usuario puede consultar de manera clara el estado de cada lote enviado, confirmando su correcto procesamiento o identificando errores que requieren acción.

[Volver al índice](#contenido)

