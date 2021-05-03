import Firebase
import FirebaseMessaging
import UIKit
import UserNotifications

private enum Constants {
    static let notificationPresentationOptions: UNNotificationPresentationOptions = [.alert, .badge, .sound]
    static let notificationAuthOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
}

final class FirebasePushNotificationEngine: NSObject, PushNotificationEngine, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    private let appSession: AppSessionManager
    private let userNotificationCenter: UNUserNotificationCenter
    private let application: UIApplication
    private var coordinator: BaseCoordinator?
    private let deepLinkActionFactory: DeepLinkActionFactory
        
    init(appSession: AppSessionManager,
         userNotificationCenter: UNUserNotificationCenter,
         application: UIApplication,
         deepLinkActionFactory: DeepLinkActionFactory) {
        self.appSession = appSession
        self.userNotificationCenter = userNotificationCenter
        self.application = application
        self.deepLinkActionFactory = deepLinkActionFactory
    }
    
    func setCoordinator(_ coordinator: BaseCoordinator?) {
            self.coordinator = coordinator
    }
    
    func registerForPushNotifications() {
        userNotificationCenter.delegate = self
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        application.registerForRemoteNotifications()
    }
    
    func requestNotificationAuth(notificationAcceptanceCompletionHandler: Callback?) {
        userNotificationCenter.requestAuthorization(options: Constants.notificationAuthOptions) { [weak self] value, _ in
            guard let self = self else { return }
            self.appSession.isPushNotificationsEnabled = value
            DispatchQueue.main.async {
                notificationAcceptanceCompletionHandler?()
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard fcmToken != appSession.pushNotificationToken else { return }
        appSession.pushNotificationToken = fcmToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        guard appSession.isPushNotificationsEnabled else { return }
        completionHandler(Constants.notificationPresentationOptions)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let pushNotificationInfo = response.notification.request.content.userInfo
        guard let pushAction = deepLinkActionFactory.getNotificationDeepLinkAction(from: pushNotificationInfo) else { return }
        coordinator?.performDeepLinkActionAfterStart(pushAction)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func subscribeToTopic(_ topic: PushNotificationTopic) {
        Messaging.messaging().subscribe(toTopic: topic.rawValue)
    }
    
    func unsubscribeToTopic(_ topic: PushNotificationTopic) {
        Messaging.messaging().unsubscribe(fromTopic: topic.rawValue)
    }
}
