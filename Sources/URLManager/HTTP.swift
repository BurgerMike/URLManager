
import Foundation

public enum HTTPMethod: String, Sendable {
    case get = "GET", post = "POST", put = "PUT", delete = "DELETE",
         patch = "PATCH", head = "HEAD", options = "OPTIONS",
         trace = "TRACE", connect = "CONNECT"
}

public enum URLManagerError: LocalizedError, Sendable, Equatable {
    case invalidURL, invalidResponse
    case serverError(statusCode: Int, data: Data?)
    case decodingError(String), networkError(String)
    case cancelled, custom(message: String)
}

public enum RespuestaWeb: Sendable, Equatable {
    case json(AnyHashableJSON), texto(String)
    case archivo(Data, mime: String?, sugeridoNombre: String?)
}

public enum AnyHashableJSON: Hashable, Sendable {
    case null, bool(Bool), number(Double), string(String)
    case array([AnyHashableJSON])
    case object([String: AnyHashableJSON])
}
