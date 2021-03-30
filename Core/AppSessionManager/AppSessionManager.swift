import Foundation
import UIKit

private enum Constants {
    static let sessionTimeout: TimeInterval = 900
}

public final class AppSessionManager {
    public var onSessionExpired: Callback?
    
    @KeychainEntry("pushNotificationToken")
    public var pushNotificationToken: String?
    
    @UserDefaultsEntry("isFirstLaunch", defaultValue: true)
    public var isFirstLaunch: Bool
    
    @UserDefaultsEntry("isRoamingTutorialShown", defaultValue: false)
    public var isRoamingTutorialShown: Bool

    @UserDefaultsEntry("isPushNotificationsEnabled", defaultValue: false)
    public var isPushNotificationsEnabled: Bool

    private var backgroundEnterTime: Date?
    private let notificationCenter: NotificationCenter

    public init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
        setupObservers()
    }

    @objc
    private func checkSessionTimeout() {
        let currentTime = Date()
        guard
            let backgroundEnterTime = backgroundEnterTime,
            currentTime.timeIntervalSince(backgroundEnterTime) > Constants.sessionTimeout else { return }
        onSessionExpired?()
    }

    private func setupObservers() {
        notificationCenter.addObserver(self,
                                       selector: #selector(updateBackgroundEnterTime),
                                       name: UIApplication.didEnterBackgroundNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(checkSessionTimeout),
                                       name: UIApplication.willEnterForegroundNotification,
                                       object: nil)
    }

    @objc
    private func updateBackgroundEnterTime() {
        backgroundEnterTime = Date()
    }
}
