import Foundation

enum MakeOrderTarget: ApiTarget {
    case deliveryDistance(km: Double)

    var version: ApiVersion {
        return .custom("")
    }
    
    var servicePath: String {
        switch self {
        case .deliveryDistance:
            return "/api/rates/delivery"
        }
    }
    
    var path: String {
        return ""
    }
    
    var method: HTTPMethod {
        switch self {
        case .deliveryDistance:
            return .get
        }
    }
    
    var parameters: [String : Any]? {
        switch self {
        case let.deliveryDistance(km):
            return ["kms": km]
        }
    }
    
    var stubData: Any {
        return [:]
    }
    
    
    
}
