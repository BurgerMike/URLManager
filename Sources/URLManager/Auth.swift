
import Foundation
public protocol TokenProvider: Sendable {
    func getAccessToken() async throws -> String?
    func refreshTokenIfNeeded(_ response: HTTPURLResponse, data: Data) async throws -> Bool
}
public struct BearerAuthMiddleware: RequestMiddleware {
    let provider: TokenProvider
    public init(provider: TokenProvider){ self.provider=provider }
    public func prepare(_ req: URLRequest) async throws -> URLRequest {
        var r=req
        if let t=try await provider.getAccessToken(){ r.setValue("Bearer \(t)",forHTTPHeaderField:"Authorization") }
        return r
    }
    public func didReceive(data: Data, response: HTTPURLResponse) async throws {}
}
public actor TokenStore: TokenProvider {
    private var token:String?
    private var refreshBlock:(() async throws->String)?
    public init(initial:String?=nil, refresh:(() async throws->String)?=nil){
        token=initial; refreshBlock=refresh
    }
    public func getAccessToken() async throws->String?{token}
    public func setAccessToken(_ t:String?){token=t}
    public func refreshTokenIfNeeded(_ r:HTTPURLResponse,data:Data) async throws->Bool{
        guard r.statusCode==401, let refresh=refreshBlock else{return false}
        token=try await refresh(); return true
    }
}
