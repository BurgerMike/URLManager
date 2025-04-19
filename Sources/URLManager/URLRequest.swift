// MARK: - HTTPRequestBuilder.swift
import Foundation

public enum HTTPMethod: String {
    case GET, POST, PUT, DELETE, PATCH, HEAD, OPTIONS, TRACE, CONNECT
}

public struct HTTPRequestBuilder {

    public static func build<T: Encodable>(
        url: URL,
        method: HTTPMethod,
        headers: [String: String] = [:],
        body: T? = nil
    ) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        if let body = body {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                let error = URLErrorType.encoding(error)
                print(error.localizedDescription)
                throw error
            }
        }

        return request
    }

    public static func build(
        url: URL,
        method: HTTPMethod,
        headers: [String: String] = [:]
    ) throws -> URLRequest {
        try build(url: url, method: method, headers: headers, body: Optional<Data>.none)
    }

    // Métodos rápidos por método HTTP
    public static func get(url: URL, headers: [String: String] = [:]) -> URLRequest {
        try! build(url: url, method: .GET, headers: headers)
    }

    public static func post<T: Encodable>(url: URL, body: T, headers: [String: String] = [:]) -> URLRequest {
        try! build(url: url, method: .POST, headers: headers, body: body)
    }

    public static func put<T: Encodable>(url: URL, body: T, headers: [String: String] = [:]) -> URLRequest {
        try! build(url: url, method: .PUT, headers: headers, body: body)
    }

    public static func delete(url: URL, headers: [String: String] = [:]) -> URLRequest {
        try! build(url: url, method: .DELETE, headers: headers)
    }

    public static func patch<T: Encodable>(url: URL, body: T, headers: [String: String] = [:]) -> URLRequest {
        try! build(url: url, method: .PATCH, headers: headers, body: body)
    }

    public static func head(url: URL, headers: [String: String] = [:]) -> URLRequest {
        try! build(url: url, method: .HEAD, headers: headers)
    }

    public static func options(url: URL, headers: [String: String] = [:]) -> URLRequest {
        try! build(url: url, method: .OPTIONS, headers: headers)
    }

    public static func trace(url: URL, headers: [String: String] = [:]) -> URLRequest {
        try! build(url: url, method: .TRACE, headers: headers)
    }

    public static func connect(url: URL, headers: [String: String] = [:]) -> URLRequest {
        try! build(url: url, method: .CONNECT, headers: headers)
    }
}

