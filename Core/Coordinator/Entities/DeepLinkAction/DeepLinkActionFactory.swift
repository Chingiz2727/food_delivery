import Foundation

final public class DeepLinkActionFactory {
    public init() {}
    
    public func getNotificationDeepLinkAction(from notificationInfo: [AnyHashable: Any]) -> NotificationDeepLinkAction? {
        let decoder = JSONDecoder()
        do {
            let data = try JSONSerialization.data(withJSONObject: notificationInfo, options: .prettyPrinted)
            let actionModel = try decoder.decode(NotificationDeepLinkActionModel.self, from: data)
            return NotificationDeepLinkAction(type: actionModel.actionType)
        } catch {
            return nil
        }
    }
}
