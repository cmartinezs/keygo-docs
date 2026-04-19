# Alcance del MVP

El alcance del MVP de GRADE incluye los siguientes requisitos no funcionales (RNF), organizados por categoría, con sus dependencias y criticidad:

| Categoría                 | RNF   | Nombre resumido                   | Dependiente de…           | Criticidad |
|----------------------------|-------|-----------------------------------|---------------------------|------------|
| **Seguridad y privacidad** | RNF1  | Seguridad y control de acceso     | RF7, RF8                  | MVP        |
|                            | RNF2  | Privacidad y tratamiento de datos | RF6, RF8, RNF1            | MVP        |
| **Rendimiento y escalado** | RNF3  | Rendimiento                       | RF4, RF5, RF6, RF10       | MVP        |
|                            | RNF4  | Disponibilidad y resiliencia      | RF4, RF5, RF6, RF8        | MVP        |
|                            | RNF5  | Escalabilidad                     | RF4, RF5, RF6, RNF3, RNF4 | Futuro     |
| **Calidad técnica**        | RNF6  | Mantenibilidad y extensibilidad   | RF2–RF6, RNF3, RNF5, RNF7 | Futuro     |
|                            | RNF7  | Observabilidad                    | RF4, RF5, RF9, RNF4       | Futuro     |
| **Experiencia de uso**     | RNF8  | Usabilidad                        | RF1–RF6, RNF9             | MVP        |
|                            | RNF9  | Compatibilidad                    | RNF8, RF11                | MVP        |
| **Gobernanza**             | RNF10 | Cumplimiento y gobernanza         | RF7, RF8, RNF2            | MVP        |
| **Integraciones**          | RNF11 | Mecanismos de integración segura  | RF12, RF16, RNF1, RNF2, RF8 | Futuro   |


## Vista de dependencias

La siguiente gráfica ilustra las dependencias entre los requerimientos funcionales (RF) de GRADE, agrupados por categorías. La flecha A → B indica que B depende de A (B va después de A).

```mermaid
graph TD
  %% ===== NODOS =====
  RNF1["RNF1 · Seguridad y control de acceso"]
  RNF2["RNF2 · Privacidad y tratamiento de datos"]
  RNF3["RNF3 · Rendimiento"]
  RNF4["RNF4 · Disponibilidad y resiliencia"]
  RNF5["RNF5 · Escalabilidad"]
  RNF6["RNF6 · Mantenibilidad y extensibilidad"]
  RNF7["RNF7 · Observabilidad"]
  RNF8["RNF8 · Usabilidad"]
  RNF9["RNF9 · Compatibilidad"]
  RNF10["RNF10 · Cumplimiento y gobernanza"]
  RNF11["RNF11 · Integración segura"]

  %% ===== AGRUPACIÓN POR CATEGORÍAS =====
  subgraph C1["Seguridad y privacidad"]
    RNF1
    RNF2
  end

  subgraph C2["Rendimiento y escalado"]
    RNF3
    RNF4
    RNF5
  end

  subgraph C3["Calidad técnica"]
    RNF6
    RNF7
  end

  subgraph C4["Experiencia de uso"]
    RNF8
    RNF9
  end

  subgraph C5["Gobernanza"]
    RNF10
  end

  subgraph C6["Integraciones"]
    RNF11
  end

  %% ===== DEPENDENCIAS =====
  RNF1 --> RNF2
  RNF1 --> RNF11
  RNF2 --> RNF10

  RNF3 --> RNF5
  RNF4 --> RNF5
  RNF3 --> RNF6
  RNF5 --> RNF6

  RNF4 --> RNF7
  RNF9 --> RNF8

  %% RNF11 depende de seguridad, privacidad y auditoría (implícito RF8)
  RNF2 --> RNF11

  %% ===== ESTILOS MVP/Futuro =====
  classDef mvp fill:#e7f7ec,stroke:#2e7d32,color:#1b5e20;
  classDef futuro fill:#f3e8ff,stroke:#6a1b9a,color:#4a148c;

  class RNF1,RNF2,RNF3,RNF4,RNF8,RNF9,RNF10 mvp;
  class RNF5,RNF6,RNF7,RNF11 futuro;
```

---

[Inicio](../README.md#alcance-del-mvp)