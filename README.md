# 📦 URLManager

`URLManager` es un paquete Swift moderno que simplifica solicitudes HTTP usando `async/await`, soportando múltiples métodos (`GET`, `POST`, etc.), codificación `Codable`, manejo robusto de errores, subida y descarga de archivos, y respuestas dinámicas como JSON, texto o binarios.

---

## ✅ Características

- Soporte completo para métodos HTTP (`GET`, `POST`, `PUT`, `DELETE`, etc.)
- Decodificación automática con `Codable`
- Subida de archivos con `multipart/form-data`
- Envío de objetos JSON (`Encodable`)
- Descarga de archivos (`PDF`, imágenes, videos, etc.)
- Respuestas dinámicas: `.json`, `.texto`, `.archivo`
- Guardado automático de archivos con detección de MIME
- Headers dinámicos para autenticación y tokens
- Logs automáticos para depuración
- Manejo de errores detallado con `URLManagerError`

---

## 🚀 Uso

### 1. Enviar un objeto JSON

```swift
struct Usuario: Codable {
    let nombre: String
    let correo: String
}

let nuevo = Usuario(nombre: "Miguel", correo: "miguel@mail.com")

let gestor = RequestManager(
    url: URL(string: "https://api.tuapp.com/usuarios")!,
    method: .post,
    headers: ["Authorization": "Bearer TOKEN"]
)

Task {
    do {
        let respuesta = try await gestor.subirObjeto(nuevo)
        print(respuesta)
    } catch {
        print("❌ Error:", error)
    }
}
```

---

### 2. Subir archivo + datos

```swift
let imagen = try Data(contentsOf: URL(fileURLWithPath: "foto.jpg"))
let usuario = Usuario(nombre: "Carlos", correo: "carlos@mail.com")

let gestor = RequestManager(url: URL(string: "https://api.tuapp.com/perfil")!, method: .post)

Task {
    let resultado = try await gestor.subirArchivoYDatos(
        archivo: imagen,
        nombreArchivo: "foto.jpg",
        mimeType: "image/jpeg",
        campoArchivo: "foto",
        objeto: usuario,
        campoObjeto: "datos"
    )
    print(resultado)
}
```

---

### 3. Descargar y guardar archivo

```swift
let gestor = RequestManager(url: URL(string: "https://tuapp.com/manual.pdf")!)

Task {
    let respuesta = try await gestor.ejecutarArchivo()
    if case let .archivo(datos, mime, nombre) = respuesta {
        let url = try gestor.guardarArchivo(datos, nombre: nombre, mime: mime)
        print("Guardado en:", url.path)
    }
}
```

---

### 4. Obtener texto plano

```swift
let gestor = RequestManager(url: URL(string: "https://tuapp.com/info.txt")!)

Task {
    let texto = try await gestor.ActionTexto()
    print("Texto recibido:", texto)
}
```

---

## ⚠️ Manejo de Errores

Errores posibles a través del enum `URLManagerError`:

- `invalidURL`: URL inválida
- `invalidResponse`: respuesta inesperada del servidor
- `serverError(statusCode:data)`: error HTTP con datos
- `decodingError`: fallo al parsear JSON
- `networkError`: problemas de red
- `custom(message)`: errores definidos manualmente

---

## 📚 Requisitos

- Swift 5.7+
- iOS 14+ / macOS 11+

---

## 👨‍💻 Autor

**Miguel Carlos Elizondo Martínez**  
GitHub: [BurgerMike](https://github.com/BurgerMike)

---

## 🔮 Futuras mejoras

- [x] Soporte para archivos y multipart
- [x] Guardado automático con extensión
- [ ] Query parameters dinámicos
- [ ] Retry automático
- [ ] Carga de múltiples archivos

---

## 🤝 Contribuciones

¡Bienvenidas! Haz fork y envía un PR.

