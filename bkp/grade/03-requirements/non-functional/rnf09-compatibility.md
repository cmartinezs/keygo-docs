# RNF9 — Compatibilidad

**Descripción (alto nivel)**  
GRADE debe garantizar la **compatibilidad técnica** con los entornos de uso más comunes, asegurando que docentes y administradores puedan operar el sistema sin restricciones por plataforma o navegador.

**Alcance incluye**
- **Soporte para navegadores modernos** (últimas 2 versiones de Chrome, Firefox, Edge).
- Funcionamiento correcto en **Sistemas Operativos comunes** (Windows, macOS, Linux).
- **Compatibilidad con dispositivos móviles** (tablets/smartphones) en vistas básicas de consulta.
- Despliegue alineado a la **infraestructura estándar de Wanku** (ej. contenedores Docker, Kubernetes).
- Consistencia de la **UI/UX** en todos los entornos soportados.

**No incluye (MVP)**
- Compatibilidad con navegadores obsoletos (ej. Internet Explorer).
- Aplicaciones móviles nativas dedicadas (más allá de la versión web responsive).
- Certificación formal en todos los dispositivos móviles (se limita a pruebas básicas).

**Dependencias**
- RNF8 (Usabilidad) → la experiencia debe ser consistente en navegadores soportados.
- RF11 (Notificaciones) → en móvil puede haber limitaciones (sin push en MVP).

**Criterios de aceptación (CA)**
1. El sistema funciona correctamente en las **últimas dos versiones** de los navegadores soportados.
2. La interfaz se adapta a pantallas de **≥10 pulgadas** sin pérdida de funcionalidad.
3. En móviles pequeños (≥5 pulgadas), se pueden consultar resultados y estadísticas básicas.
4. El sistema puede desplegarse en **infraestructura Docker/Kubernetes estándar** sin cambios mayores.
5. La apariencia y navegación son consistentes entre entornos (desktop y móvil).

**Riesgos/mitigaciones**
- Problemas en móviles → limitar alcance a funciones de consulta en MVP.
- Dependencia de versiones de navegador → pruebas periódicas de compatibilidad.
- Despliegues heterogéneos → usar contenedores como estándar para reducir diferencias.
