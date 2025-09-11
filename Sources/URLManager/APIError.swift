
import Foundation
public struct APIProblem: Decodable,Sendable,Equatable {
    public let type:String?,title:String?,status:Int?,detail:String?
    public let errors:[String:[String]]?
}
public func mapServerError(_ status:Int,_ data:Data?)->URLManagerError{
    guard let d=data, let p=try? JSONDecoder().decode(APIProblem.self,from:d)
    else{return .serverError(statusCode:status,data:data)}
    let msg=[p.title,p.detail].compactMap{$0}.joined(separator:" — ")
    return .custom(message:"HTTP \(status): \(msg)")
}
