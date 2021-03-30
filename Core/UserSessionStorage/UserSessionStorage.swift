public final class UserSessionStorage {
    @KeychainEntry("accessToken")
    public var accessToken: String?

    @KeychainEntry("refreshToken")
    public var refreshToken: String?

    @KeychainEntry("pin")
    public var pin: String?

    @KeychainEntry("otpId")
    public var otpId: String?

    @UserDefaultsEntry("isBiometricAuthBeingUsed", defaultValue: false)
    public var isBiometricAuthBeingUsed: Bool
    
    @UserDefaultsEntry("numberOfUnreadNotificationsMessages", defaultValue: 0)
    public var numberOfUnreadNotificationsMessages: Int
    
    // TODO: - Возможно стоит создать еще один storage и хранить такие вещи как numberOfUnreadNotificationsMessages, isLoginAfterRegistration там ?
    @UserDefaultsEntry("isLoginAfterRegistration", defaultValue: false)
    public var isLoginAfterRegistration: Bool

    public init() {}

    public func clearAll() {
        accessToken = nil
        refreshToken = nil
        pin = nil
        otpId = nil
        isBiometricAuthBeingUsed = false
    }
}

extension UserSessionStorage {
    public func save(accessToken: String?, refreshToken: String?) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
