//
//  Struct.swift
//  URLManager
//
//  Created by Miguel Carlos Elizondo Martinez on 27/04/25.
//

import Foundation

public struct RequestManager: RequestProtocol {
    public var url: URL
    public var method: HTTPMethod
    public var headers: [String: String]
    public var body: Data?

    public init(url: URL, method: HTTPMethod = .get, headers: [String: String] = [:], body: Data? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
    }

    public func Action<D: Decodable>(as type: D.Type) async throws -> D {
        guard url.scheme != nil && url.host != nil else {
            throw URLManagerError.invalidURL
        }

        print("🌍 Request to \(url.absoluteString)")
        print("🔹 Method: \(method.description)")
        print("📝 Headers: \(headers)")
        if let body = body, let bodyString = String(data: body, encoding: .utf8) {
            print("📦 Body: \(bodyString)")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLManagerError.invalidResponse
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                throw URLManagerError.serverError(statusCode: httpResponse.statusCode, data: data)
            }

            return try JSONDecoder().decode(D.self, from: data)
        } catch let decodingError as DecodingError {
            throw URLManagerError.decodingError(decodingError)
        } catch let urlError as URLError {
            throw URLManagerError.networkError(urlError)
        } catch {
            throw URLManagerError.custom(message: "Error inesperado: \(error.localizedDescription)")
        }
    }
}
