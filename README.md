# 📦 URLManager

`URLManager` es un paquete Swift moderno que simplifica solicitudes HTTP usando `async/await`, soportando múltiples métodos (`GET`, `POST`, etc.), codificación `Codable`, manejo robusto de errores y compatibilidad con respuestas JSON o crudas (`Data`).

---

## ✅ Características

- Soporte completo para métodos HTTP (`GET`, `POST`, `PUT`, `DELETE`, etc.)
- Decodificación automática con `Codable`
- Manejo de errores robusto con `URLManagerError`
- Peticiones genéricas con un solo método `Action(as:)`
- Validaciones internas para prevenir crasheos
- Preparado para respuestas `Data` y archivos
- Logs automáticos para depuración

---

## 🚀 Uso Básico

### 1. Modelo

```swift
struct Usuario: Decodable {
    let id: Int
    let nombre: String
}
```

### 2. Crear y ejecutar solicitud

```swift
var request = RequestManager(
    url: URL(string: "https://api.ejemplo.com/usuarios")!,
    method: .get
)

do {
    let usuarios: [Usuario] = try await request.Action(as: [Usuario].self)
    print("Usuarios:", usuarios)
} catch {
    print("Error:", error.localizedDescription)
}
```

---

## ✍️ Enviar Body y Headers

```swift
let usuarioNuevo = Usuario(id: 0, nombre: "Carlos")
let jsonData = try JSONEncoder().encode(usuarioNuevo)

var request = RequestManager(
    url: URL(string: "https://api.ejemplo.com/usuarios")!,
    method: .post,
    headers: ["Content-Type": "application/json"],
    body: jsonData
)

let usuarioCreado: Usuario = try await request.Action(as: Usuario.self)
```

---

## ⚠️ Manejo de Errores

Errores posibles a través del enum `URLManagerError`:

- `invalidURL`: URL inválida
- `invalidResponse`: respuesta inesperada del servidor
- `serverError(statusCode:data)`: código de error HTTP
- `decodingError`: fallo al parsear JSON
- `networkError`: problemas de red
- `custom(message)`: errores definidos manualmente

### Ejemplo:

```swift
do {
    let usuario: Usuario = try await request.Action(as: Usuario.self)
} catch let error as URLManagerError {
    switch error {
    case .invalidURL:
        print("URL no válida")
    case .serverError(let code, let data):
        print("Error del servidor (\(code)): \(String(data: data ?? Data(), encoding: .utf8) ?? "")")
    default:
        print("Error:", error.localizedDescription)
    }
}
```

---

## 📥 Descargar datos como `Data`

```swift
let request = RequestManager(url: URL(string: "https://ejemplo.com/archivo.pdf")!)
let data: Data = try await request.Action(as: Data.self)
```

---

## 📚 Requisitos

- Swift 5.7+
- iOS 14+ / macOS 11+

---

## 👨‍💻 Autor

**Miguel Carlos Elizondo Martínez**  
GitHub: [BurgerMike](https://github.com/BurgerMike)

---

## 🚧 Futuras mejoras

- [ ] Query parameters dinámicos
- [ ] Soporte para `multipart/form-data`
- [ ] Modo silencioso para producción
- [ ] Retry automático en errores de red

---

## 🤝 Contribuciones

¡Bienvenidas! Haz fork y envía un PR.
