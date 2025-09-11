import Foundation

public struct Endpoint<Response: Decodable>: Sendable {
    public var path: String
    public var method: HTTPMethod
    public var query: [URLQueryItem]
    public var headers: [String: String]
    public var body: Data?

    public init(
        path: String,
        method: HTTPMethod = .get,
        query: [URLQueryItem] = [],
        headers: [String: String] = [:],
        body: Data? = nil
    ) {
        self.path = path
        self.method = method
        self.query = query
        self.headers = headers
        self.body = body
    }
}

public extension RequestManager {
    func run<Response: Decodable>(base: URL, _ ep: Endpoint<Response>) async throws -> Response {
        let url = try URLBuilder(base: base)
            .adding(path: ep.path)
            .adding(query: ep.query)
            .build()

        // Como es método del actor, podemos mutar el estado con seguridad.
        self.url = url
        self.method = ep.method
        self.headers = self.headers.merging(ep.headers) { _, b in b }
        self.body = ep.body

        return try await ejecutar(Response.self)
    }
}
