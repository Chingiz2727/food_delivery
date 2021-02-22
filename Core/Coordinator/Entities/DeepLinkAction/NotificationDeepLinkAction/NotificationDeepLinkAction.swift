import Foundation

public struct NotificationDeepLinkAction: DeepLinkAction {
    public let type: NotificationDeepLinkActionType
    
    public init(type: NotificationDeepLinkActionType) {
        self.type = type
    }
}
