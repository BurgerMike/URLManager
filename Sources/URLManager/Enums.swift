//
//  Enums.swift
//  URLManager
//
//  Created by Miguel Carlos Elizondo Martinez on 26/04/25.
//
import Foundation

public enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum URLManagerError: Error {
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError
}
