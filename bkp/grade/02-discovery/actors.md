# Actores

# Contenido
* [Descripción general](#descripción-general)
* [Tabla de Actores del Sistema GRADE](#tabla-de-actores-del-sistema-grade)
  * [Actores explícitamente excluidos (en fase actual)](#actores-explícitamente-excluidos-en-fase-actual)
* [Notas](#notas)
* [Comentarios de los Revisores](#comentarios-de-los-revisores)
  * [Maximiliano Toledo](#maximiliano-toledo)
  * [Rodrigo Ulloa](#rodrigo-ulloa)
  * [Paolo Vilches](#paolo-vilches)

## Descripción general

El sistema está concebido como el eje central para la creación, publicación y calificación de evaluaciones dentro del ecosistema educativo de Wanku. Su propósito es ofrecer una estructura clara y eficiente para gestionar bancos de preguntas, generar exámenes y registrar resultados, garantizando procesos seguros, coherentes y estandarizados.

## Tabla de Actores del Sistema GRADE
Para ello, se han identificado distintos actores que interactúan con la plataforma, cada uno con responsabilidades específicas y restricciones definidas. La siguiente tabla resume estos actores y delimita claramente sus funciones y límites dentro del sistema:

| Actor | Responsabilidades principales | Alcances y restricciones |
|-------|-------------------------------|---------------------------|
| **Administrador del Sistema** | - Mantiene y administra el banco centralizado de preguntas (alta, baja, versiones).<br>- Configura criterios globales de calificación y umbrales de aprobación.<br>- Gestiona usuarios y roles (asigna roles de Docente o Coordinador, revoca accesos).<br>- Monitorea rendimiento, integraciones técnicas y auditoría del sistema.<br>- Define políticas de retención de datos y respaldo. | - Tiene control total sobre todas las evaluaciones, parámetros y usuarios.<br>- Único rol que administra ítems globales del banco de preguntas. |
| **Coordinadores de ciclo/asignatura** | - Diseñan y publican evaluaciones para asegurar coherencia curricular entre cursos o secciones.<br>- Gestionan plantillas: crean, clonan y comparten modelos estandarizados de evaluación. | - No pueden cargar respuestas ni acceder a resultados individuales de estudiantes (su rol es exclusivamente diseño y publicación).<br>- Mantienen trazabilidad completa al ajustar evaluaciones existentes. |
| **Docentes** | - Generan pruebas completas (selección de preguntas desde banco, asignación de puntajes, emisión de PDF/digital).<br>- Aplican y califican: cargan formularios respondidos (escaneo OCR, foto, CSV), el sistema calcula puntajes y convierte a notas.<br>- Revisan resultados individuales o por curso/cohorte mediante reportes básicos de desempeño. | - Solo modifican evaluaciones creadas por ellos mismos.<br>- No administran directamente ítems globales del banco ni parámetros globales del sistema. |
| **Aplicaciones Académicas Integradas** | - Consumen APIs del sistema para crear evaluaciones desde flujos externos (p. ej., plataformas LMS o planificación de clases).<br>- Consultan resultados para alimentar dashboards, analítica institucional o reportes externos. | - Delegan totalmente al sistema la lógica de generación y calificación.<br>- No gestionan bancos propios de preguntas ni criterios de evaluación internos. |

### **Actores explícitamente excluidos (en fase actual):**
- **Estudiantes**: no interactúan directamente con GRADE; su acceso es mediado exclusivamente por el docente o la plataforma integrada.
- **Apoderados**: fuera del alcance directo.
- **Otros roles institucionales** (administrativos o de gestión académica): no tienen acceso directo al sistema en esta iteración.

## Notas
> :information_source: **Nota sobre integraciones futuras**
> 
> Integraciones avanzadas (servicios externos como plataformas LMS, proctoring avanzado o análisis basado en IA) no constituyen actores del sistema; su incorporación futura dependerá exclusivamente de APIs estandarizadas y protocolos técnicos definidos por GRADE.

## Comentarios de los Revisores
### Maximiliano Toledo
| Tipo de comentario  | Contenido |
| ------------------- | --------- |
| Ideas Valiosas      | - Identificación clara de los límites de cada actor en base a su rol.<br>- Un administrador con control total para mantener seguridad.<br>- La inclusión de dashboard o herramientas para análisis.<br>- Ideas novedosas para integraciones a futuro que pueden mejorar aún más el servicio. |
| Mejoras             | Se podría incluir un mapa de jerarquía de los actores para entenderlo quizás de una forma más visual o gráfica. |
| Descartar           | Nada que descartar, todo parece valioso en esta página. |
| Dudas               | - ¿Los docentes al modificar sus pruebas pueden agregar preguntas que no estén en el banco de preguntas?<br>- Si el coordinador no podrá tener acceso a respuestas individuales, ¿podrá tener acceso a datos o análisis de desempeño de un curso? |
| Incongruencias      | No se especifica si el coordinador tendrá acceso a desempeño de un curso para tener coherencia en el diseño y publicación de una evaluación. |

### Rodrigo Ulloa
| Tipo de comentario | Contenido |
| ------------------ | --------- |
| Ideas Valiosas    | La distinción clara entre Docentes, Coordinadores y Administradores evita conflictos de permisos y asegura gobernanza en la definición de roles y responsables. |
| Mejoras           | Falta un rol para Soporte Técnico, ej: asistencia a docentes con errores en carga de PDFs o corrección automática. |
| Descartar         | Nada que descartar. |
| Dudas             | No tengo dudas en esta etapa. |
| Incongruencias    | Se dice que los Coordinadores “no acceden a resultados individuales”, pero su rol exige “mantener coherencia curricular”. ¿Cómo medirán el impacto de las pruebas sin datos? |

### Paolo Vilches
| Tipo de comentario | Contenido |
| ------------------ | --------- |
| Ideas Valiosas    | - Las aplicaciones académicas consumen resultados sin tener que gestionar la lógica, lo que facilita integración.<br>- El uso de roles bien separados reduce riesgos de seguridad y trazabilidad.<br>- La posibilidad de clonar y ajustar pruebas existentes es eficiente y genera consistencia curricular. |
| Mejoras           | - Sería útil saber si habrá niveles jerárquicos dentro del rol de docente.<br>- Podría considerarse permitir que coordinadores accedan a estadísticas agregadas sin ver datos individuales. |
| Descartar         | Sin contenido que descartar. |
| Dudas             | - ¿Qué ocurre si un docente y un coordinador trabajan sobre la misma evaluación (control de versiones o conflictos de edición)?<br>- En un futuro, ¿las aplicaciones externas tendrán permisos diferenciados o solo un tipo de integración? |
| Incongruencias    | No se aclara si los coordinadores pueden acceder a estadísticas agregadas. Aunque no vean resultados individuales, sería lógico que tengan acceso a datos consolidados para cumplir su rol. |


[< Anterior](scope.md) | [Inicio](README.md) | [Siguiente >](need-expectations.md)