enum SearchApiTarget: ApiTarget {
    case searchByTag(tag: String)
    case getTags

    var version: ApiVersion {
        return .custom("")
    }
    
    var servicePath: String {
        return ""
    }
    
    var path: String {
        switch self {
        case .searchByTag:
            return "a/cb/retail/find/by-tag"
        case .getTags:
            return "a/cb/retail/tags"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .searchByTag(let tag):
            return ["tag": tag]
        case .getTags:
            return [:]
        }
    }

    var stubData: Any {
        return [:]
    }
}
