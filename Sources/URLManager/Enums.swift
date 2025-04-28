import Foundation

/// Métodos HTTP soportados por URLManager.
public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case head = "HEAD"
    case options = "OPTIONS"
}

/// Errores posibles durante las solicitudes HTTP en URLManager.
public enum URLManagerError: Error {
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError
    case custom(message: String)
}

extension URLManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "La respuesta del servidor no es válida."
        case .serverError(let statusCode):
            return "Error del servidor con código \(statusCode)."
        case .decodingError:
            return "No se pudo decodificar la respuesta."
        case .custom(let message):
            return message
        }
    }
}
