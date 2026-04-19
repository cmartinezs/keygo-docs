# Apreciación CU-BP-05 — Retirar Ítem

- [Volver](../../README.md#1-banco-de-preguntas)

### Qué cubre
- Cambio de estado de un ítem a **Inactivo**.
- Evita que pueda usarse en nuevas evaluaciones.
- Mantiene trazabilidad y no elimina historial.

### Escenario lo justifica
- En S-BP-03, Rodrigo necesita retirar una pregunta obsoleta.
- El sistema cambia el estado a **Inactivo** y evita su uso en composiciones futuras.
- Responde al objetivo de mantener el banco alineado al currículo vigente.

### ¿Es suficiente como CU separado?
✅ Sí. La acción de retirar afecta directamente la vigencia del ítem y es distinta de editar, versionar o clonar.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Programar retiros en el tiempo o hacer retiros masivos podrían ser funcionalidades futuras, pero no están en este escenario ni en el MVP.
    - Consultar trazabilidad de retiros se abordará en **S-BP-05**.

### Apreciación final
El CU-BP-05 está bien delimitado y suficiente para cubrir la acción de **retirar ítems** en S-BP-03. No se necesitan más CUs aquí.

---

# Apreciación CU-BP-06 — Reactivar Ítem

### Qué cubre
- Cambio de estado de un ítem previamente retirado a **Activo**.
- Permite volver a utilizar la pregunta en evaluaciones futuras.
- Registra la acción en historial y auditoría.

### Escenario lo justifica
- En S-BP-03, meses después otro Coordinador encuentra que la pregunta vuelve a ser válida y la **reactiva**.
- El sistema la devuelve a estado **Activo**, disponible para búsquedas.

### ¿Es suficiente como CU separado?
✅ Sí. La reactivación es una acción distinta y complementaria al retiro.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Restricciones adicionales como revisión pedagógica previa a la reactivación podrían definirse como regla de negocio, no como un CU nuevo.

### Apreciación final
El CU-BP-06 está correctamente definido y cubre el ciclo completo de **retirar/reactivar** del escenario.  
No hacen falta más CUs en este punto.  
