//
//  Struct.swift
//  URLManager
//
//  Created by Miguel Carlos Elizondo Martinez on 27/04/25.
//

import Foundation

public struct URLRequestManager: RequestProtocol {
    
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
    
    
    public func get<D: Decodable>(as type: D.Type) async throws -> D {
        var requestCopy = self
        requestCopy.method = .get
        return try await requestCopy.performRequest(as: type)
    }
    
    public func post<D: Decodable>(as type: D.Type) async throws -> D {
        var requestCopy = self
        requestCopy.method = .post
        return try await requestCopy.performRequest(as: type)
    }
    
    public func put<D: Decodable>(as type: D.Type) async throws -> D {
        var requestCopy = self
        requestCopy.method = .put
        return try await requestCopy.performRequest(as: type)
    }
    
    public func delete<D: Decodable>(as type: D.Type) async throws -> D {
        var requestCopy = self
        requestCopy.method = .delete
        return try await requestCopy.performRequest(as: type)
    }
    
    private func performRequest<D: Decodable>(as type: D.Type) async throws -> D {
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
                throw URLManagerError.serverError(statusCode: httpResponse.statusCode)
            }
            
            do {
                return try JSONDecoder().decode(D.self, from: data)
            } catch {
                throw URLManagerError.decodingError
            }
        } catch {
            throw URLManagerError.networkError(error)
        }
    }
}
