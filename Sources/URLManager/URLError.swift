//
//  Untitled.swift
//  URLManager
//
//  Created by Miguel Carlos Elizondo Martinez on 15/04/25.
//

// MARK: - URLErrorType.swift
import Foundation

/// Errores personalizados del sistema de red.
public enum URLErrorType: Error, LocalizedError {
    case invalidResponse
    case decoding(Error)
    case encoding(Error)
    case noData
    case custom(message: String)

    public var errorDescription: String? {
        let message: String
        switch self {
        case .invalidResponse:
            message = "❌ La respuesta del servidor no fue válida."
        case .decoding(let error):
            message = "❌ Error al decodificar la respuesta: \(error.localizedDescription)"
        case .encoding(let error):
            message = "❌ Error al codificar los datos: \(error.localizedDescription)"
        case .noData:
            message = "❌ No se recibió ningún dato del servidor."
        case .custom(let msg):
            message = "❌ Error: \(msg)"
        }
        print("🧨 Error capturado por URLErrorType: \(message)")
        return message
    }
}
