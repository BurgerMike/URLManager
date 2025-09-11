
import Foundation
public protocol RequestMiddleware: Sendable {
    func prepare(_ request: URLRequest) async throws -> URLRequest
    func didReceive(data: Data, response: HTTPURLResponse) async throws
}
public struct RetryPolicy: Sendable {
    public var maxRetries: Int; public var baseDelay: TimeInterval
    public var retryableStatus: Set<Int>
    public init(maxRetries: Int=2, baseDelay: TimeInterval=0.5,
                retryableStatus: Set<Int>=[429,500,502,503,504]) {
        self.maxRetries=maxRetries; self.baseDelay=baseDelay
        self.retryableStatus=retryableStatus
    }
    public func backoff(for attempt: Int) -> UInt64 {
        UInt64(baseDelay*pow(2,Double(attempt))*1_000_000_000)
    }
}
public struct LoggingMiddleware: RequestMiddleware {
    public init(){}
    public func prepare(_ req: URLRequest) async throws -> URLRequest { print("➡️",req); return req }
    public func didReceive(data: Data, response: HTTPURLResponse) async throws { print("⬅️",response.statusCode) }
}
