# 📦 URLManager (README actualizado)

> Estado del paquete: **estable** para requests JSON con `Codable`, con _middlewares_ y _retry_. **Aún no** incluye utilidades de `multipart/form-data` ni helpers de descarga/guardado de archivos (estaban mencionadas antes, pero no existen en el código actual).

## Requisitos

- **Swift**: 6.1
- **Plataformas**: iOS 16+, macOS 13+, watchOS 10+, tvOS 16+ (según `Package.swift`)
- **Concurrencia**: usa `actor` y APIs `async/await`

## Instalación (Swift Package Manager)

1. En Xcode: **File > Add Packages...**
2. Pega la URL del repositorio de `URLManager`
3. Selecciona la última versión y agrega el producto **URLManager**

O en tu `Package.swift`:

```swift
.package(url: "https://github.com/<tu-usuario>/URLManager.git", from: "0.1.0")
```

y en `targets`:

```swift
.target(
    name: "TuApp",
    dependencies: [
        .product(name: "URLManager", package: "URLManager")
    ]
)
```

---

## Qué incluye hoy

- **`RequestManager` (actor)**: ejecuta requests con `URLSession`, decodifica `Codable`, aplica _middlewares_ y política de reintentos con _exponential backoff_.
- **`Endpoint<Response>`**: describe un endpoint tipado (ruta, método, query, headers y cuerpo).
- **`URLBuilder`**: compone URLs agregando `path` y `query` de forma segura.
- **Middlewares**:
  - `RequestMiddleware` (protocolo)
  - `LoggingMiddleware` (básico, imprime salida)
  - `BearerAuthMiddleware` + `TokenStore` (inyección de token tipo *Bearer* con opción de refresco).
- **Errores**:
  - `URLManagerError` (invalidURL, invalidResponse, serverError, decodingError, networkError, cancelled, custom)
  - `APIProblem` + `mapServerError` para mapear respuestas Problem+JSON del servidor.
- **`JSONCoder`**: `JSONDecoder/JSONEncoder` con estrategias ISO‑8601 y `snake_case`/`camelCase` convenientes.

> **No implementado (aún):**
> - Utilidades `multipart/form-data`
> - Helpers de descarga/guardado de archivos
> - Respuestas dinámicas tipo `.archivo` (existe el enum `RespuestaWeb`, pero `RequestManager` no lo usa actualmente)

---

## Uso básico

### 1) Definir un modelo y un `Endpoint`

```swift
import URLManager

struct User: Codable {
    let id: Int
    let name: String
}

let getUser = Endpoint<User>(
    path: "/v1/users/42",
    method: .get
    // query, headers, body son opcionales
)
```

### 2) Ejecutar con `RequestManager`

```swift
let base = URL(string: "https://api.ejemplo.com")!
let manager = RequestManager(url: base, middlewares: [LoggingMiddleware()])

Task {
    do {
        // Ejecuta el endpoint construyendo la URL final con path + query
        let user = try await manager.run(base: base, getUser)
        print(user)
    } catch {
        print("❌ Error:", error)
    }
}
```

### 3) POST con JSON (`Encodable`)

```swift
struct CreateUser: Encodable { let name: String }
struct CreatedUser: Decodable { let id: Int; let name: String }

let bodyData = try JSONCoder.encoder.encode(CreateUser(name: "Ada"))

let create = Endpoint<CreatedUser>(
    path: "/v1/users",
    method: .post,
    headers: ["Content-Type": "application/json"],
    body: bodyData
)

let created = try await manager.run(base: base, create)
```

### 4) Uso de *Bearer token* con refresco opcional

```swift
let store = TokenStore(initial: "<token-inicial>") {
    // Bloque opcional para refrescar token
    // Llama a tu endpoint de refresh y devuelve el nuevo token
    return "<token-refrescado>"
}
let auth = BearerAuthMiddleware(provider: store)
let managerAuth = RequestManager(url: base, middlewares: [auth, LoggingMiddleware()])

// A partir de aquí, `Authorization: Bearer <token>` se añade automáticamente.
// Si el servidor devuelve 401 y definiste refresh, el manager intentará refrescar y reintentar.
```

### 5) Reintentos automáticos

`RetryPolicy` (por defecto `maxRetries=2`, `baseDelay=0.5s`, reintenta 429/5xx) aplica **exponential backoff**.

```swift
let policy = RetryPolicy(maxRetries: 3, baseDelay: 0.4)
let managerRetry = RequestManager(url: base, retry: policy)
```

### 6) Construir URLs manualmente

```swift
let u = try URLBuilder(base: base)
    .adding(path: "/v1/search")
    .adding(query: [
        URLQueryItem(name: "q", value: "metal"),
        URLQueryItem(name: "page", value: "1")
    ])
    .build()
```

### 7) Obtener datos crudos (Data + HTTPURLResponse)

Si prefieres manejar tú el parseo:

```swift
let mgr = RequestManager(url: u, method: .get)
let (data, response) = try await mgr.ActionResponse()
```

---

## Referencia rápida de tipos

- **`RequestManager`**
  - Props públicas: `url`, `method`, `headers`, `body`
  - Métodos:
    - `ejecutar<T: Decodable>(_:)` → `T`
    - `ActionResponse()` → `(Data, HTTPURLResponse)`
    - `run(base:_:)` (en extensión) → ejecuta un `Endpoint<Response>`
- **`Endpoint<Response: Decodable>`**: `path`, `method`, `query`, `headers`, `body`
- **`URLBuilder`**: `adding(path:)`, `adding(query:)`, `build()`
- **`RequestMiddleware`**:
  - `prepare(_:)` para mutar el `URLRequest` antes de enviar
  - `didReceive(data:response:)` para observar la respuesta
- **`RetryPolicy`**: `maxRetries`, `baseDelay`, `retryableStatus`, `backoff(for:)`
- **`BearerAuthMiddleware` / `TokenStore`**: inyección de `Authorization: Bearer`
- **`URLManagerError`** y `mapServerError(_:_: )` para mapear errores del backend
- **`JSONCoder`**: `encoder`/`decoder` con estrategias útiles

---

## Tests

Incluye un test de ejemplo para `URLBuilder`:

```swift
let u = try URLBuilder(base: URL(string: "https://api.com")!)
    .adding(path: "/v1").build()
XCTAssertEqual(u.absoluteString, "https://api.com/v1")
```

---

## Roadmap (sugerido)

- [ ] Utilidades `multipart/form-data` (1 o varios archivos + campos)
- [ ] Helpers de descarga y guardado de archivos (deduciendo extensión por MIME)
- [ ] `RespuestaWeb` integrado en `RequestManager` (para JSON/texto/archivo)
- [ ] `QueryBuilder` y atajos para `URLQueryItem`
- [ ] Jitter en backoff y cancelación estructurada
- [ ] Mocks y protocolo de `Transport` para tests unitarios

---

## Licencia

MIT (ver `LICENSE`)
