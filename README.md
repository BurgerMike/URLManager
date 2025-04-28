# 🌐 URLManager

**URLManager** es un paquete ligero y moderno en Swift diseñado para simplificar las solicitudes HTTP usando `async/await` y `Codable`. Ofrece una manera flexible y limpia de interactuar con APIs, permitiendo decodificación automática, manejo de datos crudos y peticiones sin respuesta esperada.

---

## 🚀 Características
- ✅ Soporte para métodos HTTP: GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS.
- ✅ Decodificación automática con `Codable`.
- ✅ Obtención de datos crudos (`Data`).
- ✅ Peticiones sin respuesta (`sendWithoutResponse`).
- ✅ Manejo de errores claro con `URLManagerError`.
- ✅ 100% Swift puro, sin dependencias externas.

---

## ⚡ Instalación

Agrega el paquete vía **Swift Package Manager**:

```
https://github.com/TuUsuario/URLManager.git
```

---

## 🎨 Ejemplos de Uso

### 🔹 1. Decodificar respuesta JSON

```swift
let manager = URLManager(url: URL(string: "https://api.example.com/user/1")!, method: .get)

struct User: Codable {
    let id: Int
    let name: String
}

let user: User = try await manager.send(as: User.self)
```

---

### 🔹 2. Obtener datos crudos

```swift
let data = try await manager.sendRaw()
// Procesar Data manualmente
```

---

### 🔹 3. Enviar sin esperar respuesta

```swift
try await manager.sendWithoutResponse()
```

---

## ⚙️ Manejo de Errores

```swift
do {
    let user: User = try await manager.send(as: User.self)
} catch let error as URLManagerError {
    print(error.localizedDescription)
}
```

---

## 📄 Licencia
Este proyecto está bajo la Licencia MIT.

