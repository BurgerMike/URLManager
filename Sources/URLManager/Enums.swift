import Foundation

/// HTTP request methods, as defined by RFC 7231.
public enum HTTPMethod: String {
    /// Request to retrieve data from the server (read-only).
    case get = "GET"
    
    /// Request to submit data to be processed (e.g., form submission).
    case post = "POST"
    
    /// Request to replace the target resource with new data.
    case put = "PUT"
    
    /// Request to delete the specified resource.
    case delete = "DELETE"
    
    /// Request to apply partial modifications to a resource.
    case patch = "PATCH"
    
    /// Request to retrieve the headers for a resource (no body).
    case head = "HEAD"
    
    /// Request to describe the communication options for the target resource.
    case options = "OPTIONS"
    
    /// Request used for diagnostics, returns the request as received.
    case trace = "TRACE"
    
    /// Request used to establish a tunnel to the server (typically for HTTPS).
    case connect = "CONNECT"
    
    /// A human-readable name for each HTTP method.
    var description: String {
        switch self {
        case .get: return "GET (Retrieve data)"
        case .post: return "POST (Submit new data)"
        case .put: return "PUT (Replace resource)"
        case .delete: return "DELETE (Remove resource)"
        case .patch: return "PATCH (Modify resource)"
        case .head: return "HEAD (Headers only)"
        case .options: return "OPTIONS (Available methods)"
        case .trace: return "TRACE (Diagnostic echo)"
        case .connect: return "CONNECT (Tunnel)"
        }
    }
}

public enum URLManagerError: LocalizedError {
    /// La URL proporcionada no es válida o no tiene formato adecuado.
    case invalidURL

    /// La respuesta del servidor no fue del tipo esperado (por ejemplo, sin headers HTTP).
    case invalidResponse

    /// El servidor respondió con un error (código de estado fuera del rango 2xx).
    case serverError(statusCode: Int, data: Data?)

    /// Ocurrió un error al intentar decodificar los datos recibidos.
    case decodingError(DecodingError)

    /// Error de red (como pérdida de conexión, timeout, etc.).
    case networkError(Error)

    /// Error personalizado con un mensaje legible.
    case custom(message: String)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "❌ La URL proporcionada no es válida."
        case .invalidResponse:
            return "❌ La respuesta del servidor no es válida o está malformada."
        case .serverError(let code, let data):
            let details = data.flatMap { String(data: $0, encoding: .utf8) } ?? "Sin detalles."
            return "❌ Error del servidor (código \(code)). Detalles: \(details)"
        case .decodingError(let error):
            return "❌ Falló la decodificación de datos: \(error.localizedDescription)"
        case .networkError(let error):
            return "❌ Error de red: \(error.localizedDescription)"
        case .custom(let message):
            return "❌ Error personalizado: \(message)"
        }
    }
}
