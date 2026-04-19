# Apreciación CU-BP-14 — Importar ítems desde planilla CSV

- [Volver](../../README.md#1-banco-de-preguntas)

### Qué cubre
- Proceso de cargar múltiples ítems al Banco de preguntas desde un archivo CSV.
- Valida estructura y formato de datos contra una plantilla estandarizada.
- Registra preguntas en estado *Borrador* y genera reporte con resultados y errores.

### Escenario lo justifica
- En S-BP-07, Carlitos necesita importar decenas de preguntas previamente validadas.
- El sistema permite subir el archivo, valida las filas y crea los ítems en el Banco.
- Responde directamente a la necesidad de **ahorrar tiempo** y **facilitar migraciones** desde otros sistemas.

### ¿Es suficiente como CU separado?
✅ Sí. La importación en bloque es un proceso específico, distinto de la creación manual (CU-BP-01) y requiere reglas de negocio propias.

### ¿Harían falta CUs adicionales?
- **No en este escenario.**
    - Extensiones como **importación en otros formatos (XLSX, JSON)**, **programar importaciones automáticas** o **integración con sistemas externos** pueden considerarse evolutivas, pero no forman parte de este alcance.

### Apreciación final
El CU-BP-14 está bien definido y suficiente para cubrir el escenario de **importación de ítems desde planillas**.  
No se requieren CUs adicionales en este punto.  
