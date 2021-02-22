import Foundation

public enum NotificationDeepLinkActionType: String, Decodable {
    case info = "INFO"
    case payment = "PAYMENT"
    case order = "ORDER"
    case communication = "COMMUNICATION"
}

public struct NotificationDeepLinkActionModel: Decodable {
    enum CodingKeys: String, CodingKey {
        case actionType = "click_action"
    }
    let actionType: NotificationDeepLinkActionType
}
