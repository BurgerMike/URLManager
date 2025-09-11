import Foundation
public struct URLBuilder: Sendable {
    public var base: URL
    public var path: String = ""
    public var query: [URLQueryItem] = []
    public init(base: URL) { self.base = base }
    public func adding(path: String) -> URLBuilder { var c = self; c.path += path; return c }
    public func adding(query items: [URLQueryItem]) -> URLBuilder { var c = self; c.query += items; return c }
    public func build() throws -> URL {
        guard var comps = URLComponents(url: base, resolvingAgainstBaseURL: false) else {
            throw URLManagerError.invalidURL
        }
        comps.path += path
        var items = comps.queryItems ?? []
        items.append(contentsOf: query)
        comps.queryItems = items
        guard let url = comps.url else { throw URLManagerError.invalidURL }
        return url
    }
}
