import Foundation

public protocol PushNotificationEngine: class {
    func registerForPushNotifications()
    func subscribeToTopic(_ topic: PushNotificationTopic)
    func unsubscribeToTopic(_ topic: PushNotificationTopic)
    func setCoordinator(_ coordinator: BaseCoordinator?)
    func requestNotificationAuth(notificationAcceptanceCompletionHandler: Callback?)
}
