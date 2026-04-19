# Revisión del escenario

- [Volver](../../README.md#1-banco-de-preguntas)

## El escenario plantea tres caminos claros:
- Editar directamente un ítem (en borrador o con permisos extendidos).
- Versionar el ítem, creando una nueva versión con historial.
- Clonar el ítem para crear una variante independiente.

### Resultado esperado
> Conservar trazabilidad y mantener ítems disponibles para uso futuro.

## ¿Son suficientes los CUs definidos?

> Sí, los tres CUs cubren fielmente las opciones narradas en el escenario.

## ¿Habría espacio para CUs adicionales?
1. Consultar historial de versiones
   - No aparece en este escenario, aunque está relacionado con versionar.
   - Su lugar natural no es aquí, sino en S-BP-05 (Ver trazabilidad de uso del ítem), ya listado en tu índice.
   - Recomendación: No añadirlo aquí para evitar solapamientos.

2. Comparar versiones
   - Podría ser útil (ej.: comparar v1 con v2 para ver qué cambió).
   - No está mencionado en el escenario, ni en el índice actual, por lo que podría reservarse como evolución futura.
   - Recomendación: No incluirlo en S-BP-02, pero lo dejaría como potencial en un backlog de mejoras.

3. Revertir a una versión anterior
   - En algunos bancos de ítems es habitual poder “volver” a una versión pasada.
   - No se menciona en el escenario ni en el alcance de MVP.
   - Recomendación: No lo agregaría en este punto. Podría ser parte de trazabilidad avanzada (futuro).

4. Eliminar borrador de versión o clon no publicado
   - Casos donde el usuario inicia un versionado o clonado y nunca lo completa.
   - Ya lo tenemos cubierto como flujo alternativo en los CUs actuales (cancelación antes de guardar).
   - Recomendación: No separar como CU.

--- 

# Apreciación CU-BP-02 — Versionar ítem

### Qué cubre
- Creación de una nueva versión (*vN+1*) de un ítem existente.
- Mantiene la trazabilidad con versiones anteriores.
- Garantiza que evaluaciones ya creadas sigan usando la versión original, mientras la nueva queda disponible para usos futuros.

### Escenario lo justifica
- El narrativo de S-BP-02 ofrece explícitamente la opción de **“Versionar”**.
- Caso ejemplar: Ernesto corrige la redacción de una pregunta creando una nueva versión.
- El valor está en proteger la trazabilidad y asegurar que los cambios no alteren evaluaciones ya aplicadas.

### ¿Es suficiente como CU separado?
✅ Sí. Se diferencia de forma clara de:
- **Editar** (modificación directa).
- **Clonar** (crear un ítem independiente).
- **Versionar** conserva continuidad histórica dentro del mismo ítem.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Consultar historial → se cubre en **S-BP-05**.
    - Comparar o revertir versiones → mejoras futuras, no descritas aquí.
    - Eliminar borradores → ya contemplado como flujo alternativo.

### Apreciación final
El CU-BP-02 está correctamente definido y es suficiente para cubrir S-BP-02.  
No requiere CUs adicionales aquí, ya que lo extra se gestiona en otros escenarios del índice.

---

# Apreciación CU-BP-03 — Clonar ítem

### Qué cubre
- Generación de un nuevo ítem con **ID distinto** a partir de uno existente.
- El clon hereda contenido, pero es independiente del original.
- Permite crear variantes sin afectar historial ni trazabilidad del ítem de origen.

### Escenario lo justifica
- En S-BP-02, “Clonar” aparece como opción explícita.
- Útil cuando el objetivo no es continuidad histórica, sino crear **otra pregunta** basada en la anterior.

### ¿Es suficiente como CU separado?
✅ Sí.
- *Versionar* mantiene la línea de vida del ítem.
- *Clonar* abre una nueva rama independiente.

### ¿Harían falta CUs adicionales?
- **No.**
    - Eliminación de clones no publicados ya está cubierta como flujo alternativo.
    - Comparación con el original → corresponde a trazabilidad (S-BP-05).
    - Clonado masivo podría ser un CU futuro, pero no en el MVP.

### Apreciación final
El CU-BP-03 está bien definido, refleja lo narrado en el escenario y no necesita CUs adicionales en este punto.

---

# Apreciación CU-BP-04 — Editar ítem

### Qué cubre
- Modificación directa de un ítem existente.
- Permitido para ítems en estado *Borrador* o, en casos especiales, para Coordinadores con permisos extendidos.

### Escenario lo justifica
- En S-BP-02, “Editar” es la primera opción ofrecida por el sistema.
- Se diferencia de *versionar*, ya que no siempre es necesario generar una nueva versión (ej.: mientras el ítem sigue en construcción).

### ¿Es suficiente como CU separado?
✅ Sí.
- *Editar* aplica a ítems en construcción o bajo permisos especiales.
- *Versionar* se aplica cuando se debe mantener historial.

### ¿Harían falta CUs adicionales?
- **No.**
    - Intentos de editar publicados sin permiso ya se cubren como flujo alternativo.
    - Revertir cambios o consultar historial corresponden a otros escenarios (ej.: S-BP-05).

### Apreciación final
El CU-BP-04 está completo y cumple lo que plantea el escenario.  
No requiere más CUs en este punto.  

---

## ✅ Conclusión global para S-BP-02:

> Los tres CUs (CU-BP-02, CU-BP-03 y CU-BP-04) son suficientes.
> 
> No recomiendo añadir más en este escenario: los extras que uno podría pensar (historial, comparaciones, revertir) pertenecen a S-BP-05 u otros escenarios de tu índice.