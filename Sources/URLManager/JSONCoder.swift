import Foundation

public enum JSONCoder {
    // Computadas para evitar "global shared mutable state" (seguras para concurrencia)
    public static var decoder: JSONDecoder {
        let x = JSONDecoder()
        x.keyDecodingStrategy = .convertFromSnakeCase
        x.dateDecodingStrategy = .iso8601
        return x
    }

    public static var encoder: JSONEncoder {
        let x = JSONEncoder()
        x.keyEncodingStrategy = .convertToSnakeCase
        x.dateEncodingStrategy = .iso8601
        return x
    }
}

// No se puede extender `Any`. Convertimos la extensión en función libre.
@usableFromInline
func asAnyHashableJSON(_ value: Any) -> AnyHashableJSON {
    if let s = value as? String { return .string(s) }
    if let b = value as? Bool { return .bool(b) }
    if let n = value as? NSNumber { return .number(n.doubleValue) }
    if let arr = value as? [Any] { return .array(arr.map { asAnyHashableJSON($0) }) }
    if let dict = value as? [String: Any] {
        var out: [String: AnyHashableJSON] = [:]
        for (k, v) in dict { out[k] = asAnyHashableJSON(v) }
        return .object(out)
    }
    return .null
}
