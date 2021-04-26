import UIKit

protocol LogoutCoordinatorOutput: DeliveryTabBarItemCoordinator {
    var logoutAction: Callback? { get set }
}

final class LogoutCoordinator: BaseCoordinator, LogoutCoordinatorOutput {
    var onTabBarItemNeedsToBeChanged: ((DeliveryTabBarItem) -> Void)?
    var logoutAction: Callback?

    override func start() {
        let logout = makeLogout()
        router.setRootModule(logout)
    }
    
    func makeLogout() -> DeliveryLogoutModule {
        let deliveryLogout = container.resolve(DeliveryLogoutStateObserver.self)!
        let controller = DeliveryLogoutViewController(deliveryLogout: deliveryLogout)
        return controller
    }
}
