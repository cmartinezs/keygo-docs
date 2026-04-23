[← Index](../README.md) | [< Anterior](../README.md) | [Siguiente >](./graphql/README.md)

---

# REST API

## Description

Representational State Transfer. Resource-based API using HTTP methods semantically.

## When to Use

| Use Case | Recommended |
|---------|-------------|
| Standard CRUD | ✅ |
| Simple read/write operations | ✅ |
| Browser-based clients | ✅ |
| Public APIs | ✅ |
| Complex nested queries | ⚠️ Consider GraphQL |

## Principles

| Principle | Description |
|-----------|-------------|
| **Resources** | Nouns, not verbs |
| **HTTP methods** | GET=read, POST=create, PUT=replace, PATCH=update, DELETE=delete |
| **Status codes** | 200=OK, 201=Created, 400=Bad Request, 401=Unauthorized, 404=Not Found, 500=Error |
| **Versioning** | `/api/v1/` in path |

---

## Files in this folder

- `README.md` — This file
- `TEMPLATE-endpoint.md` — Endpoint template

---

[← Index](../README.md) | [< Anterior](../README.md) | [Siguiente >](./graphql/README.md)