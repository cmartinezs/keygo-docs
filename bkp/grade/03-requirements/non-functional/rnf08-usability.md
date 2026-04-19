# RNF8 — Usabilidad

**Descripción (alto nivel)**  
GRADE debe ofrecer una **experiencia de usuario intuitiva y consistente**, reduciendo la carga cognitiva de docentes y administradores, y facilitando la adopción del sistema sin necesidad de capacitaciones extensas.

**Alcance incluye**
- **Interfaz consistente** en todos los módulos (banco, evaluaciones, resultados).
- **Navegación clara** con flujos guiados paso a paso en las tareas críticas (ej. crear evaluación, cargar respuestas).
- **Mensajes de error comprensibles**, indicando qué ocurrió y cómo resolverlo.
- **Minimización de pasos manuales**, evitando acciones redundantes.
- **Compatibilidad con estándares de accesibilidad básica** (ej. contraste, navegación por teclado).
- Manuales o ayudas contextuales integradas en la aplicación (tooltips, guías rápidas).

**No incluye (MVP)**
- Pruebas formales de UX con usuarios externos a la institución.
- Accesibilidad avanzada (WCAG nivel AA completo).

**Dependencias**
- RF1–RF6 (Ciclo de evaluación) → la usabilidad debe cubrir los flujos principales.
- RNF9 (Compatibilidad) → garantizar la experiencia en navegadores soportados.

**Criterios de aceptación (CA)**
1. Las funciones principales pueden completarse en **≤3 clics** desde el menú principal.
2. Los mensajes de error ofrecen siempre **una acción sugerida** al usuario.
3. Los usuarios pueden navegar todo el sistema con una interfaz uniforme (mismos estilos, patrones).
4. El sistema cumple con **accesibilidad mínima** (contraste, navegación básica con teclado).
5. Se dispone de **ayuda contextual** en las pantallas clave (ej. creación de evaluación).
6. La curva de aprendizaje de un docente nuevo es **<30 minutos** para tareas básicas.

**Riesgos/mitigaciones**
- Interfaz inconsistente → definición de **design system** y librería de componentes.
- Sobrecarga de usuarios nuevos → tutoriales y tooltips iniciales.
- Problemas de accesibilidad → revisión de estándares y guías de diseño inclusivo.
