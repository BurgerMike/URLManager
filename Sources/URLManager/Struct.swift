//
//  Struct.swift
//  URLManager
//
//  Created by Miguel Carlos Elizondo Martinez on 27/04/25.
//

import Foundation

public struct URLManager: Request {
    public var url: URL
    public var method: HTTPMethod
    public var headers: [String: String]
    public var body: Data?

    public init(url: URL, method: HTTPMethod, headers: [String: String] = [:], body: Data? = nil) {
        self.url = url
        self.method = method
        self.headers = headers
        self.body = body
    }

    public func send<D: Decodable>(as type: D.Type) async throws -> D {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        if method == .post || method == .put {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLManagerError.invalidResponse
        }

        guard 200..<300 ~= httpResponse.statusCode else {
            throw URLManagerError.serverError(statusCode: httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        do {
            return try decoder.decode(D.self, from: data)
        } catch {
            throw URLManagerError.decodingError
        }
    }
}


