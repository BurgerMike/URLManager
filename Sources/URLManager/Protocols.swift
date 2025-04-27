//
//  Protocols.swift
//  URLManager
//
//  Created by Miguel Carlos Elizondo Martinez on 26/04/25.
//

import Foundation

public protocol URLManagerProtocol {
    var url: URL { get }
    var method: HTTPMethod { get }
    var headers: [String: String] { get }
    var body: Data? { get }
}

public protocol Request: URLManagerProtocol {
    func send<D: Decodable>(as type: D.Type) async throws -> D

}
