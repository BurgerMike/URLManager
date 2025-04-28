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

let headers = [
    "Authorization": "Bearer tu_token",
    "Content-Type": "application/json"
]

do {
    let response: Usuario = try await manager.post(body: nuevo, headers: headers)
    print("Usuario creado: \(response.nombre)")
} catch {
    print("Error al crear usuario: \(error.localizedDescription)")
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

## 🔧 Personalización Avanzada

Si necesitas configurar una solicitud manualmente, puedes ajustar los parámetros del `URLManager`:

```swift
var manager = URLManager(url: URL(string: "https://api.ejemplo.com/usuarios/10")!)
manager.headers = ["Authorization": "Bearer token_personalizado"]
manager.body = try? JSONEncoder().encode(["campo": "valor"])

do {
    let usuario: Usuario = try await manager.put(body: manager.body, headers: manager.headers)
    print("Usuario actualizado: \(usuario.nombre)")
} catch {
    print("Error en la actualización: \(error.localizedDescription)")
}
```

---

## 🛠 Ejemplo Completo de Uso

```swift
struct Usuario: Codable {
    let id: Int
    let nombre: String
}

let url = URL(string: "https://api.ejemplo.com/usuarios")!
let nuevoUsuario = Usuario(id: 20, nombre: "Carlos")

let headers = ["Authorization": "Bearer abc123"]

let manager = URLManager(url: url, headers: headers, body: try? JSONEncoder().encode(nuevoUsuario))

Task {
    do {
        let creado: Usuario = try await manager.post(as: Usuario.self)
        print("Usuario creado: \(creado.nombre)")
    } catch {
        print("Error: \(error.localizedDescription)")
    }
}
```

---

## 🚧 Futuras Mejoras

- [ ] Soporte para **Query Parameters** dinámicos.
- [ ] Configuración de **Timeouts** personalizados.
- [ ] Logs automáticos en modo Debug.
- [ ] Soporte para multipart/form-data (subida de archivos).
- [ ] Mejoras en el manejo de respuestas vacías (`Void`).

---

## ❓ FAQ

**¿Puedo enviar parámetros en la URL?**  
Sí, pero debes construirlos manualmente por ahora. Próximamente se añadirá soporte nativo para query parameters.

---

**¿Cómo manejo respuestas vacías?**  
Si el servidor responde con éxito pero sin datos, puedes crear un modelo vacío o ajustar la lógica de decodificación.

---

## 🙌 Contribuciones

¡Las contribuciones son bienvenidas! Si deseas mejorar `URLManager`, realiza un fork del repositorio y envía un Pull Request con tus cambios.

---

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.
