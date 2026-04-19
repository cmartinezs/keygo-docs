# Convenciones de Navegación

Todo documento en este repositorio debe permitir al lector moverse libremente sin depender del filesystem o del buscador. La navegación es parte del contrato de calidad de la documentación.

---

## Reglas Obligatorias

### 1. Encabezado de documento

Todo archivo `.md` (excepto README de carpeta) debe comenzar con:

```markdown
[← Índice](./README.md) | [< Anterior](./archivo-anterior.md) | [Siguiente >](./archivo-siguiente.md)

---
```

- **Índice** apunta siempre al `README.md` de la misma carpeta
- **Anterior / Siguiente** siguen el orden definido en el `README.md` de la carpeta
- Si no hay anterior (primer documento), omitir ese link
- Si no hay siguiente (último documento), omitir ese link

---

### 2. Pie de documento

Todo archivo `.md` debe terminar con:

```markdown
---

[← Índice](./README.md) | [< Anterior](./archivo-anterior.md) | [Siguiente >](./archivo-siguiente.md)
```

Mismo criterio que el encabezado para anterior/siguiente.

---

### 3. Retorno al inicio en cada sección

Cada sección de nivel 2 (`##`) debe incluir al final, antes del separador `---`, un link de retorno:

```markdown
[↑ Volver al inicio](#nombre-del-documento)
```

El ancla `#nombre-del-documento` apunta al título principal (`#`) del archivo.

Ejemplo completo de sección:

```markdown
## Contexto

Contenido de la sección...

[↑ Volver al inicio](#contexto-y-motivación)

---
```

---

### 4. README de carpeta

El `README.md` de cada carpeta debe incluir:

```markdown
[← HOME](../README.md)
```

Y al final:

```markdown
---

[← HOME](../README.md)
```

No requiere Anterior/Siguiente ya que es el índice de la carpeta.

---

## Plantilla base de documento

```markdown
[← Índice](./README.md) | [< Anterior](./archivo-anterior.md) | [Siguiente >](./archivo-siguiente.md)

---

# Título del Documento

Introducción breve del documento.

---

## Sección 1

Contenido...

[↑ Volver al inicio](#título-del-documento)

---

## Sección 2

Contenido...

[↑ Volver al inicio](#título-del-documento)

---

[← Índice](./README.md) | [< Anterior](./archivo-anterior.md) | [Siguiente >](./archivo-siguiente.md)
```

---

## Plantilla base de README de carpeta

```markdown
[← HOME](../README.md)

---

# Nombre de la Fase

Descripción de la fase y su propósito.

## Contenido

* [Documento 1](./doc-1.md)
* [Documento 2](./doc-2.md)
* [Documento 3](./doc-3.md)

---

[← HOME](../README.md) | [Siguiente >](./doc-1.md)
```

---

## Notas

- Los anclas en Markdown se generan del título en minúsculas, espacios reemplazados por `-`, sin tildes ni caracteres especiales (depende del renderer; GitHub los soporta con tildes)
- Mantener el orden de Anterior/Siguiente consistente con el listado del README
- Al agregar un documento nuevo a una carpeta, actualizar los links de Anterior/Siguiente en los documentos adyacentes y en el README
