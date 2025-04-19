// MARK: - URLManager.swift
import Foundation

public actor URLManager {
    public static let shared = URLManager()
    private init() { }

    public func request<T: Decodable>(_ request: URLRequest, responseType: T.Type) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            let error = URLErrorType.invalidResponse
            print(error.localizedDescription)
            throw error
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let error = URLErrorType.custom(message: "Código HTTP inválido: \(httpResponse.statusCode)")
            print(error.localizedDescription)
            throw error
        }

        guard !data.isEmpty else {
            let error = URLErrorType.noData
            print(error.localizedDescription)
            throw error
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            let error = URLErrorType.decoding(error)
            print(error.localizedDescription)
            throw error
        }
    }
}
