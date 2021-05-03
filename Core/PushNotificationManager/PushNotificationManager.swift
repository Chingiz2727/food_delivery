import Foundation

public enum PushNotificationTopic: String {
    case base
}

open class PushNotificationManager {
    private var engine: PushNotificationEngine
    
    public init(engine: PushNotificationEngine) {
        self.engine = engine
    }
    
    public func register() {
        engine.registerForPushNotifications()
    }
    
    public func setCoordinatorToEngine(coordinator: BaseCoordinator) {
        engine.setCoordinator(coordinator)
    }
    
    public func subscribeToTopic(_ topic: PushNotificationTopic) {
        engine.subscribeToTopic(topic)
    }
    
    public func unsubscribeToTopic(_ topic: PushNotificationTopic) {
        engine.unsubscribeToTopic(topic)
    }
    
    public func requestNotificationAuth(notificationAcceptanceCompletionHandler: Callback? = nil) {
        engine.requestNotificationAuth(notificationAcceptanceCompletionHandler: notificationAcceptanceCompletionHandler)
    }

}
