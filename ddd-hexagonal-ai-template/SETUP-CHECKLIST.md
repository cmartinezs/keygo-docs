# Setup Checklist: Adapt Template to Your Project

Sigue estos pasos para adaptar la plantilla a tu proyecto en 30-45 minutos.

---

## Paso 1: Información Básica (5 min)

- [ ] **Product Name**: ¿Cómo se llama tu producto?
  - Actualiza en:
    - `README.md` (first line)
    - `MACRO-PLAN.md` (title)
    - `00-GUIDE-AND-INSTRUCTIONS/README.md` (if mentioning example)

- [ ] **Product Problem**: ¿Qué problema resuelve? (2-3 oraciones)
  - Guarda en `01-discovery/` como referencia para IA

- [ ] **Target Users**: ¿Quién lo usa?
  - Ejemplo: "Startups de 5-15 personas"
  - Guarda como referencia

- [ ] **Stack Técnico**: Backend, Frontend, DB, Infra (para Fase 6+)
  - Guarda para después

---

## Paso 2: Estructura de Carpetas (10 min)

- [ ] **Renombra TEMPLATE-*.md**:
  ```bash
  # En cada carpeta (01-discovery, 02-requirements, etc.):
  # Busca archivos llamados TEMPLATE-*.md
  # Renombra a nombres reales:
  
  TEMPLATE-context-motivation.md → context-motivation.md
  TEMPLATE-system-vision.md → system-vision.md
  # ... etc (ve el README de cada carpeta)
  ```

  **Script rápido** (si tienes bash):
  ```bash
  find . -name "TEMPLATE-*.md" -type f | while read f; do
    newname=$(echo "$f" | sed 's/TEMPLATE-//')
    mv "$f" "$newname"
  done
  ```

- [ ] **Verifica que no hay TEMPLATE-*.md** (excepto en guías)
  ```bash
  find . -name "TEMPLATE-*.md" -type f
  # No debe mostrar nada en 01-discovery/, 02-requirements/, etc.
  ```

---

## Paso 3: README de Cada Fase (10 min)

- [ ] Para cada carpeta (01-discovery, 02-requirements, etc.):
  - Abre `README.md`
  - Actualiza descripción de la fase si es necesario
  - Verifica que los links en "Contenido" apunten a documentos sin TEMPLATE-

---

## Paso 4: MACRO-PLAN (5 min)

- [ ] Abre `MACRO-PLAN.md`
- [ ] Actualiza:
  - Título: `[PRODUCT NAME]`
  - Visión: [TU DESCRIPCIÓN 3-4 ORACIONES]
  - "Creado por": [Tu nombre/equipo]
  - "Última actualización": [Hoy]

---

## Paso 5: Índice de Guías (5 min)

- [ ] Verifica que `00-GUIDE-AND-INSTRUCTIONS/README.md` tiene links válidos a:
  - `TEMPLATE-USAGE-GUIDE.md`
  - `INSTRUCTIONS-FOR-AI.md`
  - `TEMPLATE-ARCHITECTURE.md`
  - `FAQ.md`

---

## Paso 6: Primeros Documentos (15-20 min con IA)

- [ ] Abre `00-GUIDE-AND-INSTRUCTIONS/INSTRUCTIONS-FOR-AI.md`
- [ ] Sigue el "Prompt 1.1: Context & Motivation"
- [ ] Proporciona a IA:
  - Información de tu producto
  - Template de `01-discovery/TEMPLATE-context-motivation.md`
  - Instrucciones del prompt
- [ ] IA genera primer documento
- [ ] Tú validas y ajustas

---

## Paso 7: Git Commit (2 min)

- [ ] `git add .`
- [ ] `git commit -m "feat: initialize DDD+Hexagonal documentation template"`
- [ ] `git branch`: crea rama para documentación
  - Ej: `git checkout -b docs/initialize-template`

---

## Verificación Final

Antes de comenzar generación en serio:

- [ ] ¿No hay archivos TEMPLATE-*.md en carpetas de fase? (excepto ejemplos)
- [ ] ¿Todos los README.md están actualizados?
- [ ] ¿MACRO-PLAN.md tiene tu información?
- [ ] ¿El README en raíz (`../README.md`) describe bien la plantilla?
- [ ] ¿Puedes navegar entre documentos (links)?

---

## ¡Listo!

Una vez completado:

1. Continúa con `00-GUIDE-AND-INSTRUCTIONS/TEMPLATE-USAGE-GUIDE.md` → "Paso 3: Generación de contenido con IA"
2. Genera fase por fase
3. Valida coherencia entre fases

---

**Tiempo total**: 45 min  
**Resultado**: Plantilla lista para generar documentación con IA
