# Apreciación CU-IM-03 — Validar calidad y repetir captura

- [Volver](../../README.md#3-ingesta-móvil)

### Qué cubre
- Verificación automática de calidad de cada foto (enfoque, iluminación, encuadre).
- Feedback inmediato al usuario para repetir capturas deficientes.
- Garantiza que solo se almacenen imágenes con calidad mínima aceptable.
- Registro del estado de validación y motivos de rechazo.

### Escenario lo justifica
- En S-IM-03, Carlitos como Asistente de aula necesita evitar que se almacenen fotos borrosas o mal encuadradas.
- La validación temprana evita reprocesos posteriores y asegura confiabilidad en la lectura OCR.
- Es un paso natural tras la captura inicial (CU-IM-02) y previo al envío de lotes (CU-IM-04).

### ¿Es suficiente como CU separado?
✅ Sí. La validación de calidad introduce reglas de negocio y procesos distintos de la simple captura.
- Justifica un CU independiente, ya que involucra criterios técnicos, retroalimentación al usuario y decisiones de aceptación/rechazo.

### ¿Harían falta CUs adicionales?
- **No en este escenario directo.**
    - Evolutivos posibles:
        - **CU-IM-XX** para “Validación avanzada con IA” (detección de escritura ilegible, sombras o marcas adicionales).
        - **CU-IM-XX** para “Corrección automática de imágenes” (ajustes de brillo, recorte automático).
        - **CU-IM-XX** para “Gestión manual de excepciones” (permitir guardar capturas con baja calidad bajo responsabilidad del docente).

### Apreciación final
El CU-IM-03 está correctamente definido y suficiente para cubrir el **control de calidad de las capturas** dentro del flujo de Ingesta móvil.  
Su alcance es claro y complementa los CUs anteriores, asegurando un proceso robusto antes de almacenar y enviar datos al sistema central.  
