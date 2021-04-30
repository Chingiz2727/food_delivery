enum SearchApiTarget: ApiTarget {
    case searchByTag(tag: String)

    var version: ApiVersion {
        return .custom("")
    }
    
    var servicePath: String {
        return ""
    }
    
    var path: String {
        return "a/cb/retail/find/by-tag"
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .searchByTag(let tag):
            return ["tag": tag]
        @unknown default:
            return [:]
        }
    }

    var stubData: Any {
        return [:]
    }
}
