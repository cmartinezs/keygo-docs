# Alcance del MVP

> El siguiente cuadro resume los requerimientos funcionales (RF) definidos para GRADE, indicando cuáles están incluidos en el **MVP** y cuáles se planifican para fases futuras. También se detallan las dependencias entre RF, los roles impactados y la criticidad de cada uno.

| Categoría                  | RF   | Nombre resumido                                | Dependiente de…      | Rol impactado              | Criticidad |
|-----------------------------|------|-----------------------------------------------|----------------------|----------------------------|------------|
| **Ciclo de evaluación**    | RF1  | Ciclo de evaluación centralizado              | —                    | Docente, Coordinador       | MVP        |
|                             | RF3  | Gestión de evaluaciones y entregables         | RF1, RF2             | Docente, Coordinador       | MVP        |
|                             | RF4  | Ingesta de respuestas multicanal              | RF1, RF3             | Docente                    | MVP        |
|                             | RF5  | Calificación automática de ítems objetivos    | RF1, RF3, RF4        | Docente                    | MVP        |
|                             | RF6  | Publicación y consulta de resultados          | RF1, RF5             | Docente, Coordinador       | MVP        |
| **Contenido y gestión**     | RF2  | Banco centralizado de preguntas               | —                    | Administrador, Coordinador | MVP        |
|                             | RF10 | Reportes pedagógicos básicos                  | RF5, RF6             | Docente, Coordinador       | Futuro     |
|                             | RF14 | Preguntas abiertas y rúbricas                 | RF2, RF3, RF6        | Docente                    | Futuro     |
| **Seguridad y gobernanza**  | RF7  | Roles y permisos                              | RF1                  | Administrador              | MVP        |
|                             | RF8  | Auditoría y trazabilidad                      | RF1–RF7              | Administrador              | MVP        |
|                             | RF15 | Proctoring y antifraude                       | RF3, RF4, RF8        | Administrador, Coordinador | Futuro     |
| **Administración y operación** | RF9  | Paneles operativos y métricas                 | RF1, RF4, RF5, RF8   | Administrador              | Futuro     |
|                             | RF11 | Notificaciones de hitos                       | RF1, RF4, RF5, RF6   | Docente, Administrador     | Futuro     |
|                             | RF13 | Administración del sistema                    | RF7, RF8             | Administrador              | Futuro     |
| **Integraciones y expansión** | RF12 | Integración con sistemas externos             | RF1, RF4, RF6, RF8   | Administrador, Integrador  | Futuro     |
|                             | RF16 | Integraciones institucionales avanzadas       | RF7, RF12            | Administrador, Integrador  | Futuro     |

## Gantt referencial

> **Importante** Las fechas son solo referenciales y no representan lo que realmente se hará en el proyecto. Es solo graficar las dependencias y el orden de implementación sugerido.

```mermaid
gantt
    title Plan de implementación por RF (orden y dependencias)
    dateFormat  YYYY-MM-DD
    axisFormat  %d-%b
%% Punto de partida del plan
%% Hoy: 2025-08-31. Inicio plan: 2025-09-01

    section MVP
        RF1 - Ciclo centralizado               :active, rf1, 2025-09-01, 14d
        RF2 - Banco de preguntas               :active, rf2, 2025-09-01, 14d
        RF7 - Roles y permisos (transversal)   :active, rf7, 2025-09-01, 7d
        RF3 - Gestión y entregables            :rf3,  after rf1 rf2, 14d
        RF4 - Ingesta multicanal               :rf4,  after rf3, 14d
        RF5 - Calificación automática          :rf5,  after rf4, 14d
        RF6 - Publicación y consulta           :rf6,  after rf5, 7d
        RF8 - Auditoría y trazabilidad         :rf8,  after rf1 rf2 rf3 rf4 rf5 rf6 rf7, 14d

    section Fase futura
        RF9  - Paneles operativos              :rf9,  after rf8 rf5, 7d
        RF10 - Reportes pedagógicos            :rf10, after rf6 rf5, 7d
        RF11 - Notificaciones de hitos         :rf11, after rf6 rf5 rf4, 7d
        RF12 - Integración con externos        :rf12, after rf6 rf8, 14d
        RF13 - Administración del sistema      :rf13, after rf7 rf8, 7d
        RF14 - Abiertas + rúbricas             :rf14, after rf2 rf3 rf6, 14d
        RF15 - Proctoring y antifraude         :rf15, after rf3 rf4 rf8, 14d
        RF16 - Integraciones institucionales   :rf16, after rf12 rf7, 14d

```

## Vista de dependencias

La siguiente gráfica ilustra las dependencias entre los requerimientos funcionales (RF) de GRADE, agrupados por categorías. La flecha A → B indica que B depende de A (B va después de A).

```mermaid
graph TD
%% ===== NODOS =====
    RF1["RF1 · Ciclo centralizado"]
    RF2["RF2 · Banco de preguntas"]
    RF3["RF3 · Gestión & entregables"]
    RF4["RF4 · Ingesta multicanal"]
    RF5["RF5 · Calificación automática"]
    RF6["RF6 · Publicación & consulta"]
    RF7["RF7 · Roles & permisos (transversal)"]
    RF8["RF8 · Auditoría & trazabilidad"]
    RF9["RF9 · Paneles operativos"]
    RF10["RF10 · Reportes pedagógicos"]
    RF11["RF11 · Notificaciones"]
    RF12["RF12 · Integración con externos"]
    RF13["RF13 · Administración del sistema"]
    RF14["RF14 · Abiertas + rúbricas"]
    RF15["RF15 · Proctoring/antifraude"]
    RF16["RF16 · Integraciones institucionales"]

%% ===== AGRUPACIÓN POR CATEGORÍAS =====
    subgraph C1["Ciclo de evaluación"]
        RF1
        RF3
        RF4
        RF5
        RF6
    end

    subgraph C2["Contenido y gestión académica"]
        RF2
        RF10
        RF14
    end

    subgraph C3["Seguridad, control y gobernanza"]
        RF7
        RF8
        RF15
    end

    subgraph C4["Administración y operación"]
        RF9
        RF11
        RF13
    end

    subgraph C5["Integraciones y expansión"]
        RF12
        RF16
    end

%% ===== DEPENDENCIAS (flujo: A --> B significa 'B va después de A') =====
    RF1 --> RF3
    RF2 --> RF3

    RF1 --> RF4
    RF3 --> RF4

    RF1 --> RF5
    RF3 --> RF5
    RF4 --> RF5

    RF1 --> RF6
    RF5 --> RF6

%% RF7 es transversal: NO depende de RF1 ni RF1 de RF7
%% Conecta donde aporta gobernanza
    RF7 --> RF8
    RF7 --> RF13
    RF7 --> RF16

%% RF8 depende de múltiples bases (incluye RF7 de forma transversal)
    RF1 --> RF8
    RF2 --> RF8
    RF3 --> RF8
    RF4 --> RF8
    RF5 --> RF8
    RF6 --> RF8

    RF5 --> RF10
    RF6 --> RF10

    RF2 --> RF14
    RF3 --> RF14
    RF6 --> RF14

    RF3 --> RF15
    RF4 --> RF15
    RF8 --> RF15

    RF1 --> RF9
    RF4 --> RF9
    RF5 --> RF9
    RF8 --> RF9

    RF1 --> RF11
    RF4 --> RF11
    RF5 --> RF11
    RF6 --> RF11

    RF8 --> RF13

    RF1 --> RF12
    RF4 --> RF12
    RF6 --> RF12
    RF8 --> RF12

    RF12 --> RF16

%% ===== ESTILO (MVP vs Futuro) =====
    classDef mvp fill:#e7f7ec,stroke:#2e7d32,color:#1b5e20;
    classDef futuro fill:#f3e8ff,stroke:#6a1b9a,color:#4a148c;

    class RF1,RF2,RF3,RF4,RF5,RF6,RF7,RF8 mvp;
    class RF9,RF10,RF11,RF12,RF13,RF14,RF15,RF16 futuro;
```

---

[Inicio](../README.md#alcance-del-mvp)