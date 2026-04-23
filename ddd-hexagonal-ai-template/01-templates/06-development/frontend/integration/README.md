[← Index](./README.md) | [< Anterior](../state/README.md)

---

# API Integration

## Description

Communication between frontend and backend.

## HTTP Client Setup

| Component | Purpose |
|-----------|---------|
| **Request Interceptor** | Add auth token |
| **Response Interceptor** | Handle errors |
| **Retry Logic** | Transient failures |

---

## Data Fetching Patterns

| Pattern | When to Use |
|---------|-------------|
| **Query** | Read data, caching |
| **Mutation** | Write data |
| **Subscription** | Real-time |

---

## Authentication

| Flow | Description |
|------|-------------|
| **Bearer Token** | Access token in header |
| **Cookie** | HttpOnly cookie |
| **Refresh** | Automatic token refresh |

---

## Error Handling

| Error Type | Handling |
|------------|----------|
| **4xx** | Show user message |
| **5xx** | Retry or show error |
| **Network** | Show offline message |

---

## Files in this folder

- `README.md` — This file

---

[← Index](./README.md) | [< Anterior](../state/README.md)