# Análisis del escenario

- [Volver](../../README.md#1-banco-de-preguntas)

## Escenario narrativo clave:
- Docente inicia sesión.
- Va al Banco de preguntas → “Nueva pregunta”.
- Completa enunciado + alternativas + metadatos.
- Guarda → Sistema asigna ID y confirma.
- Ítem queda disponible para búsquedas y otros docentes.

Resultado esperado:
> Ítem registrado con metadatos completos, disponible y trazable.

## ¿Dónde podrían emerger CUs adicionales?

### Gestión de taxonomías
- El escenario dice que María Fernanda debe etiquetar con tema, dificultad y unidad.
  Esto depende de que existan catálogos vigentes.
- Si en este flujo el usuario no puede agregar nuevos valores, no hay CU adicional: la acción de etiquetar ya está cubierta.
- Pero si el sistema permite que el docente cree “al vuelo” un nuevo tema/unidad (porque no existe), ahí sí sería otro CU: Gestionar Taxonomías.
- Sin embargo, ese ya aparece en tu índice como S-BP-06, por lo tanto no corresponde duplicarlo aquí.

### Detección de duplicados
- En el flujo incluimos la validación de duplicados como parte del CU-BP-01.
- Solo justificaría un CU separado si quisieras un proceso explícito de “Comparar ítems similares” o “Gestionar duplicados”, algo que no está descrito en S-BP-01.

### Adjuntar recursos
- El escenario no menciona imágenes/audio/tablas, solo “enunciado + alternativas + metadatos”.
- Si más adelante se plantea, sería un CU aparte. Por ahora no aplica en este escenario.

### Publicación / Disponibilidad
- El resultado esperado dice que el ítem queda “disponible para búsquedas y trazabilidad futura”.
- Esto está dentro de CU-BP-01 (postcondiciones).
- Sería un CU separado solo si el flujo incluyera publicación con revisión/aprobación, pero eso corresponde a otro escenario posterior (no a este).

> **Recomendación**
>
> 👉 No hace falta un CU adicional para S-BP-01.
>
> El CU-BP-01 que definimos ya cubre:
> - Creación del ítem.
> - Asignación de metadatos.
> - Validaciones (incluyendo duplicados).
> - Registro, auditoría y disponibilidad.

El resto de posibles temas (gestión de taxonomías, publicación, adjuntos) tienen sus propios escenarios en el índice (S-BP-06, S-BP-04, S-BP-07), por lo que no deben mezclarse aquí.