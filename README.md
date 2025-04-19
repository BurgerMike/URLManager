# 🌐 URLManager

URLManager es un paquete Swift ligero y moderno para realizar peticiones HTTP usando `async/await`, `Codable` y un sistema de manejo de errores personalizado. Diseñado para ser claro, reutilizable y compatible con iOS y macOS. También es ideal para proyectos con SwiftUI y arquitectura MVVM.

URLManager is a lightweight and modern Swift package for making HTTP requests using `async/await`, `Codable`, and a custom error handling system. It’s designed to be clean, reusable, and compatible with iOS and macOS. Perfect for SwiftUI and MVVM-based projects.

---

## 🚀 Características / Features

- ✅ Sintaxis limpia con `async/await`  
  Clean and simple `async/await` syntax
- ✅ Compatible con todos los métodos HTTP (`GET`, `POST`, `PUT`, etc.)  
  Supports all HTTP methods
- ✅ Manejo de errores detallado con `URLErrorType`  
  Rich error handling via `URLErrorType`
- ✅ Sin dependencias externas  
  No third-party dependencies
- ✅ Compatible con SwiftUI / SwiftData  
  Works with SwiftUI and SwiftData

---

## 📦 Instalación / Installation

### Swift Package Manager (SPM)

Agrega esto en tu archivo `Package.swift`:

Add this to your `Package.swift`:

```swift
.package(url: "https://github.com/tuusuario/URLManager.git", from: "1.0.0")
```

Y al target:

And in your target:

```swift
.target(
    name: "TuProyecto", // or "YourProject"
    dependencies: ["URLManager"]
)
```

---

## 🛠 Ejemplo de uso / Usage Example

```swift
import URLManager

struct Login: Codable {
    let userName: String
    let password: String
}

let login = Login(userName: "admin", password: "1234")

let request = HTTPRequestBuilder.post(
    url: URL(string: "https://api.miapp.com/login")!, // or your API URL
    body: login
)

Task {
    do {
        let response: UserInfo = try await URLManager.shared.request(request, responseType: UserInfo.self)
        print("✅ Usuario logueado / Logged in:", response.name)
    } catch {
        print("❌ Error:", error.localizedDescription)
    }
}
```

---

## 🧠 ¿Qué es `URLErrorType`?

Un `enum` personalizado que te da errores descriptivos para todos los casos comunes:

A custom `enum` that gives you rich error descriptions for common HTTP cases:

```swift
public enum URLErrorType: Error {
    case invalidResponse
    case decoding(Error)
    case encoding(Error)
    case noData
    case custom(message: String)
}
```

Y todos tienen `localizedDescription` automáticamente.

---

## 📄 Licencia / License

Este paquete está disponible bajo la licencia MIT.  
This package is available under the MIT license.

---

**Hecho con ❤️ por [https://github.com/BurgerMike/URLManager]**  
**Made with ❤️ by [Miguel Elizondo]**
