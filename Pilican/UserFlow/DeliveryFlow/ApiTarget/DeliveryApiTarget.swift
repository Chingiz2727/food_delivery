enum DeliveryApiTarget: ApiTarget {
    case deliveryRetailListByType(page: Int, size: Int, type: Int)
    case deliveryRetailProductsList(retailId: Int)

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
        case .deliveryRetailProductsList:
            return "retail/find"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .deliveryRetailListByType, .deliveryRetailProductsList:
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
        case let .deliveryRetailProductsList(retailId):
            return ["id": retailId]
        }
    }

    var stubData: Any {
        return [:]
    }
}
