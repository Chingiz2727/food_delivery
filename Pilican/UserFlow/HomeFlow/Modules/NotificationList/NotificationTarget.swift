import Foundation

enum NotificationTarget: ApiTarget {
    
    case notificationMessage(pageNumber: Int)
    case notificationCashback(pageNumber: Int)
    
    var servicePath: String { "" }
    
    var version: ApiVersion {
        .number(1)
    }
    
    var path: String {
        switch self {
        case .notificationMessage:
            return "notification/system"
        case .notificationCashback:
            return "notification/cashback"
        }
    }
    
    var method: HTTPMethod { .post }
    
    var parameters: [String : Any]? {
        switch self {
        case let .notificationMessage(pageNumber):
            return ["pageNumber": pageNumber]
        case let .notificationCashback(pageNumber):
            return ["pageNumber": pageNumber]
        }
    }
    
    var stubData: Any { return [:] }
}
