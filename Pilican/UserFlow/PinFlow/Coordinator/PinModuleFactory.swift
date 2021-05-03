import UIKit

final class PinModuleFactory {
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func makeCreatePin() -> CreatePinModule {
        let userSession = container.resolve(UserSessionStorage.self)!
        let pushManager = container.resolve(PushNotificationManager.self)!
        return CreatePinViewController(userSession: userSession, pushManager: pushManager)
    }
    
    func makePinCheck() -> PinCheckModule {
        let userSession = container.resolve(UserSessionStorage.self)!
        let biometricAuthService = container.resolve(BiometricAuthService.self)!
        let pinCheck = PinCheckViewController(userSession: userSession, biometricAuthService: biometricAuthService)
        return pinCheck
    }
}
