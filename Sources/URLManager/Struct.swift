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
        print("🌐 URL: \(url)")
        print("🔵 Method: \(method.rawValue)")
        print("📋 Headers: \(headers)")
        if let body = body, let bodyString = String(data: body, encoding: .utf8) {
            print("📦 Body: \(bodyString)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                print("📬 Response Code: \(httpResponse.statusCode)")
                print("📋 Response Headers: \(httpResponse.allHeaderFields)")
            }
            print("📦 Raw Response Data:")
            if let rawString = String(data: data, encoding: .utf8) {
                print(rawString)
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLManagerError.invalidResponse
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                throw URLManagerError.serverError(statusCode: httpResponse.statusCode, data: data)
            }
            
            do {
                return try JSONDecoder().decode(D.self, from: data)
            } catch {
                print("❌ Error decoding data: \(error)")
                throw URLManagerError.decodingError(error)
            }
        } catch {
            print("❌ Network error: \(error)")
            throw URLManagerError.networkError(error)
        }
    }
    
    public func execute<D: Decodable>(as type: D.Type) async throws -> D {
        return try await performRequest(as: type)
    }
}
