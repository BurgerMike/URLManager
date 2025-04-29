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
    
    func get<D: Decodable>(as type: D.Type) async throws -> D
    func post<D: Decodable>(as type: D.Type) async throws -> D
    func put<D: Decodable>(as type: D.Type) async throws -> D
    func delete<D: Decodable>(as type: D.Type) async throws -> D
    func execute<D: Decodable>(as type: D.Type) async throws -> D
}
