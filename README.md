
# URLManager

`URLManager` es un paquete ligero y moderno en Swift diseñado para simplificar las solicitudes HTTP usando `async/await`. Soporta operaciones GET, POST, PUT, DELETE, con manejo de headers personalizados y decodificación automática con `Codable`.

---

## 🚀 Instalación

Agrega el paquete a tu proyecto Swift mediante Swift Package Manager:

```
https://github.com/BurgerMike/URLManager.git
```

---

## 📦 Uso Básico

### 1. Importar el paquete
```swift
import URLManager
```

### 2. Realizar una petición GET

```swift
let manager = URLManager(url: URL(string: "https://api.ejemplo.com/usuario")!)

struct Usuario: Codable {
    let id: Int
    let nombre: String
}

do {
    let usuario: Usuario = try await manager.get()
    print(usuario.nombre)
} catch {
    print("Error en la solicitud: \(error)")
}
```

---

## ✍️ Enviar Encabezados Personalizados

Puedes incluir headers como tokens de autorización o content-type en cualquier solicitud:

```swift
let headers = [
    "Authorization": "Bearer tu_token",
    "Content-Type": "application/json"
]

do {
    let usuario: Usuario = try await manager.get(headers: headers)
    print(usuario)
} catch {
    print("Error: \(error)")
}
```

---

## 📤 Ejemplo de POST

```swift
struct NuevoUsuario: Codable {
    let nombre: String
    let correo: String
}

let nuevo = NuevoUsuario(nombre: "Miguel", correo: "miguel@ejemplo.com")

do {
    let response: Usuario = try await manager.post(body: nuevo)
    print("Usuario creado: \(response.nombre)")
} catch {
    print("Error al crear usuario: \(error)")
}
```

---

## ⚠️ Manejo de Errores

`URLManager` lanza errores descriptivos que puedes capturar fácilmente:

```swift
do {
    let data: Usuario = try await manager.get()
} catch URLManagerError.invalidURL {
    print("La URL no es válida.")
} catch URLManagerError.serverError(let statusCode) {
    print("Error del servidor: \(statusCode)")
} catch {
    print("Otro error: \(error.localizedDescription)")
}
```

---

## ✅ Métodos Soportados

- `get(headers:)`
- `post(body:headers:)`
- `put(body:headers:)`
- `delete(headers:)`

Todos usando `async/await` y compatibles con cualquier modelo que conforme a `Codable`.

---

## 📚 Requisitos

- Swift 5.7+
- iOS 14+ / macOS 11+

---

## 👨‍💻 Autor

**Miguel Carlos Elizondo Martinez**  
GitHub: [BurgerMike](https://github.com/BurgerMike)

---

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.
