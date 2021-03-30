enum DeliveryApiTarget: ApiTarget {
    case deliveryRetailListByType(page: Int, size: Int, type: Int)

    var version: ApiVersion {
        .custom("")
    }
    
    var servicePath: String {
        return "a/cb"
    }
    
    var path: String {
        switch self {
        case .deliveryRetailListByType:
            return "retail/find/by-type"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .deliveryRetailListByType:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .deliveryRetailListByType(page, size, type):
            return [
                "page": page,
                "size": size,
                "type": type,
            ]
        }
    }

    var stubData: Any {
        return [:]
    }
}
