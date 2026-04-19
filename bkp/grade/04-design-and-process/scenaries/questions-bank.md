# Escenarios de usuario para Banco de Preguntas
> A continuación se presentan varios escenarios de usuario que ilustran cómo diferentes roles interactúan con el banco de preguntas en GRADE. Estos escenarios ayudan a entender las funcionalidades clave y los flujos de trabajo asociados.

[Volver](README.md#-banco-de-preguntas)

## Contenido

- [S-BP-01 | Crear ítem nuevo](#s-bp-01--crear-ítem-nuevo)
- [S-BP-02 | Editar / versionar / clonar ítem](#s-bp-02--editar--versionar--clonar-ítem)
- [S-BP-03 | Retirar / reactivar ítem](#s-bp-03--retirar--reactivar-ítem)
- [S-BP-04 | Buscar y seleccionar ítems](#s-bp-04--buscar-y-seleccionar-ítems)
- [S-BP-05 | Ver trazabilidad de uso del ítem](#s-bp-05--ver-trazabilidad-de-uso-del-ítem)
- [S-BP-06 | Gestionar taxonomías curriculares (asignaturas, unidades, temas)](#s-bp-06--gestionar-taxonomías-curriculares-asignaturas-unidades-temas)
- [S-BP-07 | Importar ítems desde planillas](#s-bp-07--importar-ítems-desde-planillas)
- [S-BP-08 | Analítica básica de ítems](#s-bp-08--analítica-básica-de-ítems)

---

## S-BP-01 | Crear ítem nuevo

**Título:** Crear ítem nuevo en el Banco de preguntas

**Contexto:**  
María Fernanda, profesora de matemáticas en una institución de enseñanza media, necesita preparar evaluaciones periódicas para sus cursos. Actualmente, parte de las preguntas que usa en sus pruebas están en documentos personales, pero la institución busca centralizar y estandarizar el material en un único sistema.

**Actor principal:**  
Docente (o Coordinador)

**Necesidad / objetivo:**  
María Fernanda quiere **crear una nueva pregunta** directamente en el sistema GRADE, agregándole metadatos (tema, dificultad, unidad, resultado de aprendizaje). Con esto podrá **reutilizarla en futuras evaluaciones** y otros docentes también podrán acceder a ella.

**Motivación / valor:**
- Ahorrar tiempo en la preparación de pruebas.
- Evitar duplicidad de preguntas.
- Asegurar que el banco crezca de forma organizada y trazable.

**Escenario narrativo:**  
María Fernanda inicia sesión en GRADE y accede al módulo de Banco de preguntas. Desde ahí selecciona la opción “Nueva pregunta”.  
El sistema le muestra un formulario sencillo donde puede ingresar el enunciado, las alternativas de respuesta y la opción correcta.  
También debe etiquetar la pregunta con tema, dificultad y unidad curricular.  
Una vez que completa el formulario, guarda la pregunta, y GRADE confirma que fue registrada con un identificador único.  
Desde ese momento, la pregunta queda disponible para ella y para otros docentes autorizados, quienes podrán usarla al crear nuevas evaluaciones.

**Resultado esperado:**  
La nueva pregunta queda registrada en el banco, con metadatos completos, disponible para búsquedas y trazabilidad futura.  

[Volver al índice](#contenido)

---

## S-BP-02 | Editar / versionar / clonar ítem

**Título:** Editar, versionar o clonar un ítem del Banco de preguntas

**Contexto:**  
Ernesto, coordinador académico, revisa periódicamente las preguntas del banco para mantener su calidad y vigencia.  
Durante esta revisión detecta que una de las preguntas de matemáticas requiere un ajuste en su redacción para evitar ambigüedades.

**Actor principal:**  
Coordinador (también aplicable a Docente con permisos extendidos)

**Necesidad / objetivo:**  
Ernesto quiere **modificar una pregunta existente** para mejorar su claridad, o bien **crear una nueva versión/clon** manteniendo la original disponible como referencia histórica.

**Motivación / valor:**
- Asegurar la calidad pedagógica de las preguntas.
- Mantener la trazabilidad de cambios en los ítems.
- Evitar pérdida de historial al modificar directamente una pregunta.

**Escenario narrativo:**  
Ernesto accede al Banco de preguntas y selecciona un ítem existente.  
El sistema le ofrece tres opciones:
1. **Editar**: modificar el enunciado o metadatos directamente.
2. **Versionar**: crear una nueva versión del ítem, manteniendo la anterior registrada como histórica.
3. **Clonar**: generar una copia editable del ítem para usarla como base en otra variante.

Ernesto elige crear una nueva versión.  
El sistema le muestra el formulario con el contenido original, donde ajusta la redacción y guarda.  
GRADE asigna un nuevo identificador de versión y conserva la trazabilidad del ítem.

**Resultado esperado:**  
El Banco de preguntas registra el ítem con su nueva versión, manteniendo historial de cambios, y lo deja disponible para ser usado en futuras evaluaciones.

[Volver al índice](#contenido)

---

## S-BP-03 | Retirar / reactivar ítem

**Título:** Retirar o reactivar un ítem del Banco de preguntas

**Contexto:**  
Rodrigo, coordinador académico, se da cuenta de que una pregunta de ciencias está desactualizada porque hace referencia a un contenido curricular que ya no se utiliza en el plan de estudios vigente.

**Actor principal:**  
Coordinador (o Administrador en casos especiales)

**Necesidad / objetivo:**  
Rodrigo necesita **retirar temporalmente una pregunta** para que no pueda ser utilizada en nuevas evaluaciones. Más adelante, si corresponde, quiere tener la opción de **reactivarla**.

**Motivación / valor:**
- Evitar que se utilicen ítems obsoletos o incorrectos.
- Mantener el banco limpio y alineado al currículo.
- Permitir la recuperación de ítems cuando vuelvan a ser pertinentes.

**Escenario narrativo:**  
Rodrigo accede al Banco de preguntas y localiza la pregunta obsoleta.  
Selecciona la opción “Retirar”. El sistema solicita confirmación y luego cambia el estado del ítem a **Inactivo**.  
Desde ese momento, la pregunta ya no aparece en las búsquedas para componer evaluaciones, pero queda registrada en el historial.  
Meses después, otro coordinador encuentra que la pregunta vuelve a ser válida. Ingresa al ítem y selecciona “Reactivar”. El sistema actualiza el estado a **Activo**, dejándola nuevamente disponible.

**Resultado esperado:**  
El ítem queda con estado **Activo** o **Inactivo** según corresponda, manteniendo su historial y trazabilidad, y evitando su uso indebido.

[Volver al índice](#contenido)

---

## S-BP-04 | Buscar y seleccionar ítems

**Título:** Buscar y seleccionar ítems del Banco de preguntas

**Contexto:**  
María Fernanda, profesora de historia, está preparando una nueva evaluación para su curso.  
Necesita encontrar preguntas específicas en el Banco de preguntas relacionadas con la unidad sobre la independencia de Chile.

**Actor principal:**  
Docente (o Coordinador)

**Necesidad / objetivo:**  
María Fernanda quiere **buscar preguntas** en el banco aplicando filtros (tema, dificultad, unidad, etiquetas) y **seleccionarlas** para conformar la evaluación que está diseñando. La búsqueda además está orientada a localizar ítems sobre los que se puedan realizar acciones posteriores: ver, editar, versionar, clonar, retirar/reactivar o seleccionar para su inclusión en una evaluación o para exportar/descargar.  

La jerarquía curricular utilizada será: **Asignatura > Unidad > Tema**; al seleccionar un tema, la unidad y la asignatura quedan implícitas para la clasificación y búsqueda de ítems.

**Motivación / valor:**
- Ahorrar tiempo en la creación de pruebas.
- Reutilizar preguntas validadas previamente.
- Asegurar coherencia curricular en las evaluaciones.

**Escenario narrativo:**  
María Fernanda ingresa al Banco de preguntas y accede a la opción de búsqueda avanzada.  
Introduce el filtro “Independencia de Chile” y selecciona “Dificultad: Media”.  
El sistema le muestra una lista de preguntas relevantes con sus metadatos (tema, dificultad, uso histórico).  
Ella revisa los ítems y, sobre cada resultado, puede ejecutar acciones contextuales (ver, editar, versionar, clonar, retirar/reactivar) o seleccionar varias preguntas para una carpeta temporal de trabajo.  
Una vez seleccionadas, puede: (a) descargarlas/exportarlas en formato JSON o CSV para usarlas en otras herramientas (por ejemplo, Gestión de Evaluaciones), o (b) si en el futuro se habilita, persistir la carpeta como workspace compartido.

**Resultado esperado:**  
El sistema presenta resultados de búsqueda precisos y permite a la docente seleccionar fácilmente los ítems deseados para integrarlos en una nueva evaluación o exportarlos; la opción de persistir workspaces queda catalogada como mejora futura (ver anexo técnico en CU-BP-08).

[Volver al índice](#contenido)

---

## S-BP-05 | Ver trazabilidad de uso del ítem

**Título:** Consultar la trazabilidad de un ítem del Banco de preguntas

**Contexto:**  
Maxi, coordinador académico, está evaluando la calidad de las preguntas en el Banco de preguntas.  
Quiere asegurarse de que algunas preguntas de matemáticas no se estén repitiendo demasiado en las evaluaciones recientes.

**Actor principal:**  
Coordinador (o Administrador)

**Necesidad / objetivo:**  
Maxi necesita **consultar el historial de uso de una pregunta**, verificando en qué evaluaciones fue utilizada y cuál fue el desempeño de los estudiantes frente a ella.

**Motivación / valor:**
- Detectar preguntas sobreexplotadas que puedan perder validez pedagógica.
- Evaluar la calidad de un ítem a partir de su tasa de acierto y discriminación.
- Tomar decisiones informadas para mantener o retirar preguntas.

**Escenario narrativo:**  
Maxi accede al Banco de preguntas y selecciona una pregunta específica.  
El sistema le muestra la **trazabilidad del ítem**, incluyendo:
- Lista de evaluaciones donde fue utilizado.
- Cantidad de estudiantes que respondieron.
- Tasa de acierto promedio.
- Fecha de última utilización.

Con esta información, Maxi detecta que la pregunta fue usada en tres evaluaciones consecutivas en el mismo nivel. Decide recomendar su retiro temporal para evitar sobreexposición.

**Resultado esperado:**  
El sistema muestra la trazabilidad completa de cada pregunta, permitiendo análisis pedagógicos y decisiones de gestión basadas en evidencia.

[Volver al índice](#contenido)  

---

## S-BP-06 | Gestionar taxonomías curriculares (asignaturas, unidades, temas)

**Título:** Administrar la jerarquía curricular del Banco de preguntas

**Contexto:**  
Carlos M., administrador del sistema, debe garantizar que todas las preguntas del Banco de preguntas estén clasificadas según una jerarquía curricular consistente.  
La jerarquía utilizada es: **Asignatura > Unidad > Tema**, donde cada nivel puede crearse de forma independiente y expandirse gradualmente según las necesidades curriculares.

**Actor principal:**  
Administrador

**Necesidad / objetivo:**  
Carlos M. necesita **crear, editar o eliminar elementos de la taxonomía curricular** (asignaturas, unidades y temas) para asegurar que los docentes y coordinadores usen una clasificación estandarizada al catalogar preguntas. Cada componente puede agregarse independientemente - no es necesario crear la taxonomía completa de una vez.

**Motivación / valor:**
- Garantizar consistencia en la clasificación curricular de preguntas.
- Facilitar búsquedas y filtrados jerárquicos confiables en el banco.
- Alinear el repositorio de preguntas con el currículo oficial.
- Permitir crecimiento orgánico de la taxonomía según se definan contenidos.

**Escenario narrativo:**  
Carlos M. accede al módulo de administración de taxonomías curriculares dentro del Banco de preguntas.  

**Fase 1 - Creación inicial:**
Comienza creando una nueva asignatura "Matemáticas" con código "MAT-101".  
Más tarde, cuando el equipo docente define las unidades, agrega "Álgebra Lineal" y "Cálculo Diferencial" como unidades dentro de Matemáticas.  
Posteriormente, conforme se planifican los contenidos específicos, añade temas como "Sistemas de Ecuaciones" y "Matrices" dentro de la unidad Álgebra Lineal.

**Fase 2 - Expansión gradual:**
A medida que avanza el semestre, otros docentes solicitan agregar más temas. Carlos M. puede añadir "Determinantes" a Álgebra Lineal sin afectar la estructura existente.  
También puede crear nuevas unidades como "Geometría Analítica" bajo Matemáticas cuando sea necesario.

**Fase 3 - Uso en clasificación:**
Cuando un docente crea una nueva pregunta sobre matrices, selecciona el tema "Matrices", lo que automáticamente la clasifica dentro de Álgebra Lineal > Matemáticas.  
El sistema mantiene la jerarquía completa para búsquedas y reportes.

**Resultado esperado:**  
El sistema mantiene una jerarquía curricular (Asignatura > Unidad > Tema) actualizada, consistente y expandible, que sirve como base para organizar y filtrar el Banco de preguntas de forma granular.

[Volver al índice](#contenido)

---

## S-BP-07 | Importar ítems desde planillas

**Título:** Importar preguntas al Banco desde una planilla CSV

**Contexto:**  
Carlitos, coordinador académico, quiere acelerar la creación del Banco de preguntas al inicio del semestre.  
Cuenta con una planilla en formato CSV que contiene decenas de preguntas previamente validadas por el equipo docente. Las preguntas deben clasificarse según la jerarquía curricular **Asignatura > Unidad > Tema** establecida en el sistema.

**Actor principal:**  
Coordinador

**Necesidad / objetivo:**  
Carlitos necesita **importar en bloque múltiples preguntas** desde una planilla, evitando tener que crearlas una a una manualmente en la plataforma. Cada pregunta debe quedar correctamente clasificada en la taxonomía curricular y con todos sus metadatos asociados.

**Motivación / valor:**
- Ahorrar tiempo en la creación inicial del banco.
- Facilitar la migración de preguntas desde otros formatos o sistemas.
- Garantizar consistencia al usar una plantilla estandarizada.
- Mantener la integridad de la clasificación curricular.

**Escenario narrativo:**  
Carlitos accede al módulo de Banco de preguntas y selecciona la opción "Importar desde CSV".  

**Preparación de datos:**
El sistema le muestra un ejemplo de plantilla con las columnas requeridas:
- Enunciado de la pregunta
- Tipo de pregunta (Verdadero/Falso, Selección Única, Selección Múltiple)
- Alternativas de respuesta (separadas por delimitadores)
- Respuesta(s) correcta(s)
- Tema (debe existir previamente en el sistema)
- Nivel de dificultad
- Resultado de aprendizaje (opcional)

**Proceso de importación:**
Carlitos sube su archivo CSV y el sistema valida tanto la estructura como el contenido:
- **Validación estructural:** Verifica que existan las columnas obligatorias
- **Validación de contenido:** Confirma que los temas, dificultades y tipos de pregunta existan en el sistema
- **Validación de integridad:** Asegura que cada pregunta tenga al menos una respuesta correcta

**Procesamiento:**
Si todo está correcto, el sistema:
1. Registra cada pregunta con su clasificación automática en la jerarquía (Asignatura > Unidad > Tema)
2. Crea las opciones de respuesta asociadas
3. Asigna los metadatos correspondientes
4. Genera un reporte detallado de la importación

Si detecta errores (tema inexistente, formato inválido, respuesta correcta faltante), genera un reporte detallado indicando la línea y el problema específico para corregir y reintentar.

**Resultado esperado:**  
Las preguntas de la planilla quedan registradas en el Banco de preguntas con su clasificación completa en la jerarquía curricular (Asignatura > Unidad > Tema), listas para ser reutilizadas en evaluaciones. El coordinador puede verificar la importación y realizar ajustes si es necesario.

[Volver al índice](#contenido)

---

## S-BP-08 | Analítica básica de ítems

**Título:** Consultar estadísticas de desempeño de las preguntas

**Contexto:**  
Ernesto, coordinador académico, quiere mejorar la calidad del Banco de preguntas revisando cómo han funcionado los ítems en evaluaciones anteriores.  
Necesita identificar preguntas problemáticas: demasiado fáciles, demasiado difíciles, poco discriminativas o con distractores ineficaces. También requiere información sobre el uso y rendimiento por clasificación curricular (**Asignatura > Unidad > Tema**).

**Actor principal:**  
Coordinador (o Administrador)

**Necesidad / objetivo:**  
Ernesto necesita **acceder a métricas pedagógicas específicas y accionables** de los ítems para tomar decisiones fundamentadas sobre mantener, ajustar, reformular o retirar preguntas del banco.

**Motivación / valor:**
- Mejorar la calidad pedagógica de las evaluaciones mediante datos objetivos.
- Identificar ítems que no cumplen estándares psicométricos básicos.
- Optimizar el uso del banco de preguntas basado en evidencia.
- Detectar patrones de rendimiento por área curricular.
- Apoyar la renovación constante y mejora continua del banco.

**Escenario narrativo:**  
Ernesto entra al Banco de preguntas y selecciona la opción "Analítica de Ítems".

**Panel de métricas generales:**
El sistema le presenta un dashboard con indicadores clave por ítem:
- **Índice de Dificultad (P):** % de estudiantes que respondieron correctamente
- **Índice de Discriminación:** Diferencia de rendimiento entre grupos alto y bajo desempeño
- **Índice de Confiabilidad:** Consistencia estadística del ítem
- **Efectividad de Distractores:** % de selección por cada opción incorrecta
- **Frecuencia de Uso:** Cantidad de evaluaciones donde ha sido utilizado
- **Tendencia Temporal:** Evolución del rendimiento a lo largo del tiempo

**Análisis específico:**
Ernesto filtra por "Matemáticas > Álgebra Lineal" y encuentra:
1. Una pregunta sobre determinantes con **P = 0.95** (demasiado fácil) y discriminación baja
2. Un ítem sobre matrices con **P = 0.12** (excesivamente difícil) que requiere revisión
3. Una pregunta donde el 40% eligió un distractor específico, indicando error conceptual común

**Acciones derivadas:**
- Marca la primera pregunta para **reformulación** (aumentar complejidad)
- Programa **revisión pedagógica** de la segunda (posible error en enunciado)
- Identifica **oportunidad didáctica** en la tercera (reforzar concepto específico)
- Exporta reporte para **reunión docente** con recomendaciones específicas

**Análisis por taxonomía:**
El sistema también muestra métricas agregadas:
- **Por Asignatura:** Rendimiento promedio en Matemáticas vs otras materias
- **Por Unidad:** Identificación de temas con mayor/menor dominio estudiantil
- **Por Tema:** Detección de áreas curriculares que requieren refuerzo

**Resultado esperado:**  
Ernesto obtiene información objetiva y accionable que le permite: (1) tomar decisiones específicas sobre cada ítem, (2) identificar patrones curriculares para intervención pedagógica, y (3) generar reportes fundamentados para el equipo docente. El banco de preguntas mejora continuamente su calidad mediante este análisis basado en evidencia.

[Volver al índice](#contenido)
