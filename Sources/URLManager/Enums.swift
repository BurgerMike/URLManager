import Foundation

public enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
    case patch   = "PATCH"   // Actualización parcial.
    case head    = "HEAD"    // Solo obtener encabezados.
    case options = "OPTIONS" // Consultar capacidades del servidor.
    case trace   = "TRACE"   // Diagnóstico de la ruta de la solicitud.
    case connect = "CONNECT" // Establecer un túnel (usado en proxies).
}

public enum URLManagerError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int, data: Data?)
    case decodingError(Error)
    case networkError(Error)
    case custom(message: String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "❌ URL no válida."
        case .invalidResponse:
            return "❌ Respuesta inválida del servidor."
        case .serverError(let code, let data):
            let message = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Sin detalles."
            return "❌ Error del servidor. Código: \(code). Respuesta: \(message)"
        case .decodingError(let error):
            return "❌ Error al decodificar datos: \(error.localizedDescription)"
        case .networkError(let error):
            return "❌ Error de red: \(error.localizedDescription)"
        case .custom(let message):
            return "❌ \(message)"
        }
    }
}
