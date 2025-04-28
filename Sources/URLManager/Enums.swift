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
    case serverError(statusCode: Int)
    case decodingError
    case networkError(Error)
    case custom(message: String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL proporcionada no es válida."
        case .invalidResponse:
            return "La respuesta del servidor no es válida."
        case .serverError(let statusCode):
            return "El servidor respondió con un error. Código: \(statusCode)."
        case .decodingError:
            return "No se pudo decodificar la respuesta JSON."
        case .networkError(let error):
            return "Error de red: \(error.localizedDescription)"
        case .custom(let message):
            return message
        }
    }
}
