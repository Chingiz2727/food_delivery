enum RetailListMapTarget: ApiTarget {
    case getNearRetail(lat: Double, long: Double)

    var version: ApiVersion {
        return .custom("")
    }

    var path: String {
        return "a/cb/retail/find/nearby"
    }

    var servicePath: String {
        return ""
    }

    var method: HTTPMethod {
        return .get
    }

    var parameters: [String: Any]? {
        switch self {
        case let.getNearRetail(lat, long):
            return [ "latitude": lat, "longitude": long]
        }
    }

    var stubData: Any {
        return [:]
    }
}
