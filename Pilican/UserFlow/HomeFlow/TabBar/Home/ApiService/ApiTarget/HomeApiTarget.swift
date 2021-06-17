enum HomeApiTarget: ApiTarget {

    case slider(type: Int)
    case retailList(pageNumber: Int, size: Int)
    case fetchBalance(limit: Int)
    case fullPaginatedRetailList(pageNumber: Int, cityId: Int?, size: Int, categoryId: Int?, name: String)
    case findRetailById(id: Int)
    case fireBaseToken(token: String)
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
        case .findRetailById:
            return "a/cb/retail/find"
        case .fireBaseToken:
            return "user/f-token"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .slider, .findRetailById:
            return .get
        default:
            return .post
        }
    }

    var headers: [String : String]? {
        switch self {
        case .fireBaseToken:
            return ["clientId": "bW9iaWxl"]
        default:
            return [:]
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .slider(let type):
            return ["type": type]
        case .findRetailById(let id):
            return ["id": id]
        case let.fetchBalance(limit):
            return ["limit": limit]
        case let .retailList(pageNumber, size):
            return ["pageNumber": pageNumber, "size": size]
        case let.fullPaginatedRetailList(pageNumber, cityId, size, categoryId, name):
            let filter = [
                "cityId": "176",
                "categoryId": categoryId,
                "name": name
            ] as [String: Any]
            return [
                "filter": filter,
                "pageNumber": pageNumber,
                "size": size
            ]
        case .fireBaseToken(let token):
            return ["fireBaseToken": token]
        }
    }

    var stubData: Any {
        return [:]
    }
}
