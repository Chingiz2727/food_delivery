enum HomeApiTarget: ApiTarget {

    case slider
    case retailList
    case fetchBalance(limit: Int)
    case fullPaginatedRetailList(pageNumber: Int, cityId: Int?, size: Int, categoryId: Int?, name: String)

    var version: ApiVersion {
        .custom("")
    }

    var servicePath: String { return "" }

    var path: String {
        switch self {
        case .fetchBalance:
            return "v1/ads/download"
        case .retailList, .fullPaginatedRetailList:
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
        case .retailList:
            return [:]
        case let.fullPaginatedRetailList(pageNumber, cityId, size, categoryId, name):
            let filter = [
                "cityId": cityId,
                "categoryId": categoryId,
                "name": name
            ] as [String: Any]
            return [
                "filter": filter,
                "pageNumber": pageNumber,
                "size": size
            ]
        }
    }

    var stubData: Any {
        return [:]
    }
}
