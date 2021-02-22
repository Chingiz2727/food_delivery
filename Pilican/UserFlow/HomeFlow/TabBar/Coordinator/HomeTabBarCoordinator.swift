import UIKit
import Foundation

struct TabableRootControllerAndCoordinatorContainer {
    var viewController: UIViewController
    var coordinator: TababbleCoordinator
}

public protocol HomeTabBarCoordinatorOutput: BaseCoordinator {
    func goToHomeWithDeeplink(action: DeepLinkAction)
}

final class HomeTabBarCoordinator: BaseCoordinator, HomeTabBarCoordinatorOutput, TababbleCoordinator {

    private let moduleFactory: HomeCoordinatorModuleFactory

    override init(router: Router, container: DependencyContainer) {
        moduleFactory = HomeCoordinatorModuleFactory(container: container)
        super.init(router: router, container: container)
    }

    func goToHomeWithDeeplink(action: DeepLinkAction) {
    }

    override func start() {
        showHome()
    }

    private func showHome() {
        let module = moduleFactory.makeHome()
        router.setRootModule(module)
    }
}
