import UIKit

protocol LogoutCoordinatorOutput: DeliveryTabBarItemCoordinator {
    var logoutAction: Callback? { get set }
}

final class LogoutCoordinator: BaseCoordinator, LogoutCoordinatorOutput {
    var onTabBarItemNeedsToBeChanged: ((DeliveryTabBarItem) -> Void)?
    var logoutAction: Callback?
    private let analyticManager = assembler.resolver.resolve(PillicanAnalyticManager.self)!
    override func start() {
        let logout = makeLogout()
        router.setRootModule(logout)
    }
    
    func makeLogout() -> DeliveryLogoutModule {
        let deliveryLogout = container.resolve(DeliveryLogoutStateObserver.self)!
        let controller = DeliveryLogoutViewController(deliveryLogout: deliveryLogout)
        analyticManager.log(.maintabbar)
        return controller
    }
}
