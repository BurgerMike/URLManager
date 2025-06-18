//
//  Struct.swift
//  URLManager
//
//  Created by Miguel Carlos Elizondo Martinez on 27/04/25.
//

import Foundation

public struct RequestManager: RequestProtocol {
    public func ActionArchivo() async throws -> Data {
        let (data, _) = try await ActionResponse()
        return data
    }

    public func ActionTexto() async throws -> String {
        let data = try await ActionArchivo()
        guard let texto = String(data: data, encoding: .utf8) else {
            throw URLManagerError.invalidResponse
        }
        return texto
    }
    
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

        let (data, _) = try await ActionResponse()
        return try JSONDecoder().decode(D.self, from: data)
    }

    public func ActionRaw() async throws -> Data {
        let (data, _) = try await ActionResponse()
        return data
    }

    public func ActionResponse() async throws -> (Data, HTTPURLResponse) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLManagerError.invalidResponse
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            throw URLManagerError.serverError(statusCode: httpResponse.statusCode, data: data)
        }

        return (data, httpResponse)
    }

    public func subirObjeto<T: Encodable>(_ objeto: T) async throws -> RespuestaWeb {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.allHTTPHeaderFields = headers
        request.httpBody = try JSONEncoder().encode(objeto)

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLManagerError.invalidResponse
        }

        if http.mimeType?.contains("json") == true {
            let json = try JSONSerialization.jsonObject(with: data)
            return .json(json)
        } else if let texto = String(data: data, encoding: .utf8) {
            return .texto(texto)
        } else {
            return .archivo(data, mime: http.mimeType, sugeridoNombre: nil)
        }
    }

    public func subirArchivoYDatos<T: Encodable>(
        archivo: Data,
        nombreArchivo: String,
        mimeType: String,
        campoArchivo: String,
        objeto: T,
        campoObjeto: String
    ) async throws -> RespuestaWeb {
        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        // 1. JSON payload
        let jsonData = try JSONEncoder().encode(objeto)
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(campoObjeto)\"\r\n")
        body.append("Content-Type: application/json\r\n\r\n")
        body.append(jsonData)
        body.append("\r\n")

        // 2. Archivo
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(campoArchivo)\"; filename=\"\(nombreArchivo)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(archivo)
        body.append("\r\n")

        body.append("--\(boundary)--\r\n")

        request.httpBody = body

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLManagerError.invalidResponse
        }

        return .archivo(data, mime: http.mimeType, sugeridoNombre: nombreArchivo)
    }

    public func ejecutar<T: Decodable>(_ tipo: T.Type) async throws -> T {
        let (datos, respuesta) = try await ActionResponse()
        guard (200..<300).contains(respuesta.statusCode) else {
            throw URLManagerError.serverError(statusCode: respuesta.statusCode, data: datos)
        }
        return try JSONDecoder().decode(T.self, from: datos)
    }

    public func ejecutarArchivo() async throws -> RespuestaWeb {
        let (datos, respuesta) = try await ActionResponse()
        let mime = respuesta.mimeType
        let sugerido = respuesta.value(forHTTPHeaderField: "Content-Disposition")?
            .components(separatedBy: "filename=").last?
            .replacingOccurrences(of: "\"", with: "")
        if mime?.contains("json") == true {
            let json = try JSONSerialization.jsonObject(with: datos)
            return .json(json)
        } else if mime?.contains("text") == true, let texto = String(data: datos, encoding: .utf8) {
            return .texto(texto)
        } else {
            return .archivo(datos, mime: mime, sugeridoNombre: sugerido)
        }
    }

    public func subirArchivo(data: Data, nombre: String, mimeType: String) async throws -> RespuestaWeb {
        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(nombre)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.append("\r\n--\(boundary)--\r\n")

        request.httpBody = body

        let (datos, respuesta) = try await URLSession.shared.data(for: request)
        guard let http = respuesta as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLManagerError.invalidResponse
        }

        return .archivo(datos, mime: http.mimeType, sugeridoNombre: nombre)
    }

    public func guardarArchivo(_ data: Data, nombre: String) throws -> URL {
        let directorio = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destino = directorio.appendingPathComponent(nombre)
        try data.write(to: destino)
        return destino
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

