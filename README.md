
# URLManager 🚀

**URLManager** es un paquete ligero, moderno y flexible en Swift que simplifica la creación y ejecución de solicitudes HTTP utilizando `async/await`. Diseñado para ser fácil de usar, pero lo suficientemente potente para proyectos profesionales.

## 📌 Características
- ✅ Soporte para métodos HTTP: `GET`, `POST`, `PUT`, `DELETE`.
- ✅ Basado en protocolos para mayor flexibilidad.
- ✅ Manejo profesional de errores personalizados.
- ✅ Decodificación automática con `Codable`.
- ✅ Compatible con Swift 6 y Swift Concurrency (`async/await`).
- ✅ Sin dependencias externas.
- ✅ Soporte multiplataforma: iOS, macOS, watchOS, tvOS.

## 🚀 Instalación

**Swift Package Manager (SPM)**

Agrega este repositorio en Xcode:

1. Ve a `File > Add Packages...`
2. Ingresa la URL del repositorio:

```
https://github.com/TU-USUARIO/URLManager.git
```

3. Selecciona la versión que desees y añade el package a tu proyecto.

## ⚡️ Uso Rápido

```swift
import URLManager

struct User: Decodable {
    let id: Int
    let name: String
}

let manager = URLManager(
    url: URL(string: "https://jsonplaceholder.typicode.com/users/1")!,
    method: .get
)

Task {
    do {
        let user: User = try await manager.send(as: User.self)
        print("Nombre del usuario: \(user.name)")
    } catch {
        print("Ocurrió un error: \(error)")
    }
}
```

## 🔧 Configuración Avanzada

### ➤ Agregar Headers Personalizados

```swift
let manager = URLManager(
    url: URL(string: "https://api.example.com/data")!,
    method: .get,
    headers: ["Authorization": "Bearer YOUR_TOKEN"]
)
```

### ➤ Enviar Datos con POST o PUT

```swift
struct NewUser: Encodable {
    let name: String
    let email: String
}

let newUser = NewUser(name: "Miguel", email: "miguel@example.com")
let jsonData = try JSONEncoder().encode(newUser)

let manager = URLManager(
    url: URL(string: "https://api.example.com/users")!,
    method: .post,
    headers: ["Authorization": "Bearer YOUR_TOKEN"],
    body: jsonData
)

Task {
    do {
        let response: User = try await manager.send(as: User.self)
        print(response)
    } catch {
        print("Error en la solicitud: \(error)")
    }
}
```

## ⚠️ Manejo de Errores

`URLManager` utiliza un enum de errores personalizados para identificar mejor los problemas:

```swift
enum URLManagerError: Error {
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError
}
```

Ejemplo de manejo:

```swift
do {
    let data: User = try await manager.send(as: User.self)
} catch URLManagerError.serverError(let statusCode) {
    print("Error del servidor: \(statusCode)")
} catch {
    print("Otro error: \(error)")
}
```

## 📱 Plataformas Soportadas
- iOS 15+
- macOS 12+
- watchOS 8+
- tvOS 15+

## 🚧 Roadmap / Futuras Mejoras
- [ ] Soporte para parámetros en URLs (`Query Parameters`).
- [ ] Multipart/Form-Data para subida de archivos.
- [ ] Retries automáticos en caso de fallo.
- [ ] Logs más detallados en modo debug.
- [ ] Compatibilidad con OAuth 2.0.

## 🤝 Contribuciones
¡Las contribuciones son bienvenidas! Si deseas mejorar este paquete, siéntete libre de hacer un fork y enviar un pull request.

## 📄 Licencia
Este proyecto está bajo la licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.

## ✨ Autor
Desarrollado por **Miguel Carlos Elizondo Martinez**.  
Si te gusta este paquete, no dudes en darle ⭐ en GitHub.
