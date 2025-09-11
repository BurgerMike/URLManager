import Foundation

public actor RequestManager {
    public var url: URL
    public var method: HTTPMethod
    public var headers: [String: String]
    public var body: Data?

    private let session: URLSession
    private let retry: RetryPolicy
    private let middlewares: [RequestMiddleware]

    public init(
        url: URL,
        method: HTTPMethod = .get,
        headers: [String: String] = [:],
        body: Data? = nil,
        config: URLSessionConfiguration = .default,
        retry: RetryPolicy = .init(),
        middlewares: [RequestMiddleware] = [LoggingMiddleware()]
    ) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
        self.session = URLSession(configuration: config)
        self.retry = retry
        self.middlewares = middlewares
    }

    public func ejecutar<T: Decodable>(_ tipo: T.Type) async throws -> T {
        let (d, _) = try await ActionResponse()
        return try JSONCoder.decoder.decode(T.self, from: d)
    }

    public func ActionResponse() async throws -> (Data, HTTPURLResponse) {
        var req = URLRequest(url: url)
        req.httpMethod = method.rawValue
        req.allHTTPHeaderFields = headers
        req.httpBody = body

        for m in middlewares {
            req = try await m.prepare(req)
        }

        var attempt = 0
        var lastError: Error?

        while attempt <= retry.maxRetries {
            do {
                let (d, r) = try await session.data(for: req)
                guard let http = r as? HTTPURLResponse else { throw URLManagerError.invalidResponse }

                if !(200..<300).contains(http.statusCode) {
                    if http.statusCode == 401 {
                        if let auth = middlewares.compactMap({ $0 as? BearerAuthMiddleware }).first {
                            if try await auth.provider.refreshTokenIfNeeded(http, data: d) {
                                continue
                            }
                        }
                    }
                    if retry.retryableStatus.contains(http.statusCode), attempt < retry.maxRetries {
                        attempt += 1
                        try await Task.sleep(nanoseconds: retry.backoff(for: attempt))
                        continue
                    }
                    throw mapServerError(http.statusCode, d)
                }

                for m in middlewares {
                    try await m.didReceive(data: d, response: http)
                }
                return (d, http)
            } catch {
                lastError = error
                if attempt < retry.maxRetries {
                    attempt += 1
                    try await Task.sleep(nanoseconds: retry.backoff(for: attempt))
                    continue
                }
                throw URLManagerError.networkError(error.localizedDescription)
            }
        }

        throw URLManagerError.custom(message: "Exceso de reintentos: \(String(describing: lastError))")
    }
}
