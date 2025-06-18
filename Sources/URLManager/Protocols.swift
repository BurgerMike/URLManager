//
//  Protocols.swift
//  URLManager
//
//  Created by Miguel Carlos Elizondo Martinez on 26/04/25.
//

import Foundation

public protocol RequestProtocol {
    var url: URL { get set }
    var method: HTTPMethod { get set }
    var headers: [String: String] { get set }
    var body: Data? { get set }

    func Action<D: Decodable>(as type: D.Type) async throws -> D
    func ActionRaw() async throws -> Data
    func ActionResponse() async throws -> (Data, HTTPURLResponse)

    func ActionArchivo() async throws -> Data
    func ActionTexto() async throws -> String

    func ejecutar<T: Decodable>(_ tipo: T.Type) async throws -> T
    func ejecutarArchivo() async throws -> RespuestaWeb
    func subirArchivo(data: Data, nombre: String, mimeType: String) async throws -> RespuestaWeb
    func guardarArchivo(_ data: Data, nombre: String) throws -> URL

    // NUEVOS:
    func subirObjeto<T: Encodable>(_ objeto: T) async throws -> RespuestaWeb
    func subirArchivoYDatos<T: Encodable>(
        archivo: Data,
        nombreArchivo: String,
        mimeType: String,
        campoArchivo: String,
        objeto: T,
        campoObjeto: String
    ) async throws -> RespuestaWeb
}
