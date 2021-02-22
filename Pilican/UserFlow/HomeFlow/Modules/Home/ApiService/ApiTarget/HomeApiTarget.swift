enum HomeApiTarget: ApiTarget {

    case slider
    case newCompanies
    case fetchBalance(limit: Int)

    var version: ApiVersion {
        .custom("")
    }

    var servicePath: String { return "" }

    var path: String {
        switch self {
        case .fetchBalance:
            return "v1/ads/download"
        case .newCompanies:
            return "a/cb/retail/find/all"
        case .slider:
            return "a/slider/list"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .slider:
            return .get
        default:
            return .post
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .slider:
            return ["type": 0]
        case let.fetchBalance(limit):
            return ["limit": limit]
        case .newCompanies:
            return [:]
        }
    }

    var stubData: Any {
        return [:]
    }
}
