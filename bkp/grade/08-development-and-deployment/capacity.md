# Propuesta de capacidad y asignación (GRADE)

Propuesta de **capacidad y asignación** para 5 personas (3 web/core, 2 móvil/OCR), del **22-Sep-2025 al 23-Nov-2025**, manteniendo los **UAT de 3 días por fase** y **maximizando paralelización**. Incluye: matriz semanal por persona, carga estimada (persona-días) y buffers.

> Supuestos operativos:
> - Jornada estándar 5×8h (L–V). **Sáb/Dom se reservan para UAT/soporte** cuando aplique (sin sobrecargar a desarrollo).
> - Cada CU incluye pruebas básicas (unitarias/integración) dentro del esfuerzo de dev.
> - UAT = validación funcional con fixing asistido por el squad (hasta 30% del tiempo de al menos 1 dev del frente afectado).

---

## 1) Plan semanal por persona (qué hace cada uno)

**Personas:**
- **Web/Core:** W1, W2, W3
- **Mobile/OCR:** M1, M2

> Leyenda UAT: `UAT-F1`, `UAT-F2`, etc.  
> (F1=Fundamentos, F2=Evaluaciones, F3=Ingesta, F4=Calificación, F5=Resultados/Auditoría)

### Semana 1 — 22 Sep–28 Sep
| Persona | Asignación |
|---|---|
| W1 | CU-GE-01..03 (Cursos) |
| W2 | CU-GE-04..06 (Alumnos) |
| W3 | CU-BP-01 (Crear ítem) + arranque RF7 |
| M1 | Diseño flujo CU-IM-01..04 (prototipos, libs cámara/QR) |
| M2 | Setup ms-OCR (esqueleto, colas, storage) |

### Semana 2 — 29 Sep–05 Oct
| Persona | Asignación |
|---|---|
| W1 | CU-BP-02..04 (Editar/Versionar/Clonar) |
| W2 | CU-BP-05..06 (Retirar/Reactivar) |
| W3 | CU-BP-11..13 (Taxonomías) + RF7 |
| M1 | CU-IM-01 (Escanear QR) |
| M2 | ms-OCR PoC (detección hoja, pipeline) |

**UAT-F1 (3 días):** Vie–Dom (soporte: W1 o W2 de guardia para fixes menores)

---

### Semana 3 — 06 Oct–12 Oct
| Persona | Asignación |
|---|---|
| W1 | CU-GE-07 (Crear evaluación borrador) |
| W2 | CU-GE-08 (Seleccionar ítems: query/filters) |
| W3 | CU-GE-09 (Generar PDF con QR) |
| M1 | CU-IM-02 (Capturar hoja) |
| M2 | Integración OCR ↔ API (endpoints stub) |

### Semana 4 — 13 Oct–19 Oct
| Persona | Asignación |
|---|---|
| W1 | CU-GE-10 (Asociar evaluación a curso) |
| W2 | CU-GE-11 (Aplicar evaluación) |
| W3 | Endurecer CU-GE-09 (lotes, numeración) |
| M1 | CU-IM-03 (Validar captura) |
| M2 | ms-OCR: ajustes de pre-procesado (umbral, deskew) |

**UAT-F2 (3 días):** Vie–Dom (soporte: W1 para ajustes de GE-07..11)

---

### Semana 5 — 20 Oct–26 Oct
| Persona | Asignación |
|---|---|
| W1 | CU-GE-12 (Ingesta CSV) |
| W2 | CU-GE-15 (Manejo errores OCR/CSV) – base |
| W3 | CU-BP-07..08 (Buscar/Seleccionar ítems – catálogos) |
| M1 | CU-IM-04 (Enviar lote) |
| M2 | ms-OCR: API de lote + colas (retry/backoff) |

### Semana 6 — 27 Oct–02 Nov
| Persona | Asignación |
|---|---|
| W1 | CU-GE-15 (completar paths y UI de errores) |
| W2 | Hardening GE-12 (validaciones CSV, plantillas) |
| W3 | Soporte integración GE-13 + logging/trazas |
| M1 | CU-GE-13 (lotes desde app móvil, lado app) |
| M2 | CU-GE-13 (lotes, lado backend OCR/core) |

**UAT-F3 (3 días):** Vie–Dom (soporte: M1+M2 y W1 para GE-12/15)

---

### Semana 7 — 03 Nov–09 Nov
| Persona | Asignación |
|---|---|
| W1 | CU-GE-14 (Calificación automática) – motor |
| W2 | CU-GE-14 – reglas/escala de notas |
| W3 | CU-GE-14 – persistencia/report hooks |
| M1 | Soporte QA en móvil (telemetría, errores) |
| M2 | Soporte OCR (umbrales, muestras difíciles) |

**UAT-F4 (3 días):** Vie–Dom (soporte: W1/W2/W3)

---

### Semana 8 — 10 Nov–16 Nov
| Persona | Asignación |
|---|---|
| W1 | CU-GE-16 (Publicar resultados) |
| W2 | CU-GE-17 (Consultar resultados y métricas básicas) |
| W3 | CU-GE-18 (Exportar CSV/PDF) |
| M1 | CU-BP-09 (Trazabilidad ítem – UI consulta) |
| M2 | CU-BP-10 (Reporte trazabilidad ítem – exportables) |

---

### Semana 9 — 17 Nov–23 Nov
| Persona | Asignación |
|---|---|
| W1 | CU-GE-21 (Consultar auditoría) |
| W2 | CU-GE-22 (Exportar auditoría) |
| W3 | Hardening + performance (queries clave) |
| M1 | UAT-F5 (End-to-End) soporte móvil |
| M2 | UAT-F5 (End-to-End) soporte OCR |

**UAT-F5 (3 días):** Vie–Dom final (cierre E2E, criterios de salida)

---

## 2) Capacidad: persona-días y buffers

> Capacidad nominal semanal: **5 personas × 5 días = 25 persona-días**  
> (UAT en fin de semana disminuye impacto en capacidad de dev; durante UAT el equipo da **soporte ≤30%** el viernes)

| Semana | Rango | Capacidad nominal | Dedicado Dev | Soporte UAT/Fixing | Buffer/Riesgo | Comentarios clave |
|---|---|---:|---:|---:|---:|---|
| 1 | 22–28 Sep | 25 | 25 | 0 | 0 | Arranque Fundamentos paralelo (GE + BP + RF7) |
| 2 | 29 Sep–05 Oct | 25 | 22 | 3 | 0 | UAT-F1 Vie–Dom (soporte leve) |
| 3 | 06–12 Oct | 25 | 25 | 0 | 0 | Eval: GE-07/08/09 en paralelo |
| 4 | 13–19 Oct | 25 | 22 | 3 | 0 | UAT-F2 Vie–Dom |
| 5 | 20–26 Oct | 25 | 25 | 0 | 0 | Ingesta: split CSV/Errores vs App/OCR |
| 6 | 27 Oct–02 Nov | 25 | 22 | 3 | 0 | UAT-F3 Vie–Dom |
| 7 | 03–09 Nov | 25 | 22 | 3 | 0 | Calificación + soporte móvil/OCR |
| 8 | 10–16 Nov | 25 | 25 | 0 | 0 | Resultados + Trazabilidad |
| 9 | 17–23 Nov | 25 | 20 | 5 | 0 | Auditoría + UAT-F5 E2E (cierre) |

**Notas de riesgo y mitigación**
- **OCR variable** (calidad de imagen, skew): reservar muestras reales temprano (S2–S3); toggle de parámetros por ambiente.
- **PDF con QR**: fijar librería estable (evitar cambios de tipografía que rompan QR).
- **Escala de notas/curvas**: congelar reglas en S7, pruebas con datasets sintéticos y reales.
- **Consultas pesadas (resultados/trazabilidad)**: índices y paginación previstos en S8; test de performance en S9.

---

## 3) Mapa de dependencias (resumen práctico)

- **F1 → F2:** GE-07/08/09 requieren BP + cursos/alumnos listos.
- **F2 → F3:** GE-12/13/15 requieren evaluación aplicada (GE-10/11) y PDF/QR.
- **F3 → F4:** GE-14 requiere respuestas ingresadas.
- **F4 → F5:** GE-16/17/18 requieren calificación terminada; BP-09/10 y GE-21/22 dependen de eventos previos logueados.

---

## 4) Reglas de paralelización (para mantenerla en la ejecución)

- **Nunca** bloquear un frente: si un CU tiene dependencia blanda (solo lectura), **dividir en subtareas**: modelo/DAO primero, UI después del endpoint.
- **UAT en fin de semana** (Vie–Dom) con **1 dev de guardia por frente** para fixes puntuales; evitar features nuevas esos días.
- **Picos OCR**: cuando M2 cargue, M1 toma UI de trazabilidad (S8) adelantando vistas.
