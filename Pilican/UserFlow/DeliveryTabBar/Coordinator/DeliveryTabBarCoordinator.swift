import UIKit

struct TabableDeliveryControllerAndCoordinatorContainer {
    var viewController: UIViewController
    var coordinator: DeliveryTabBarItemCoordinator
}

final class DeliveryTabBarCoordinator: BaseCoordinator {
    private var tabRootContainers: [TabableDeliveryControllerAndCoordinatorContainer] = []
    private let tabBarController: DeliveryTabBarController
    private let coordinatorFactory: DeliveryTabBarCoordinatorFactory
    
    override init(router: Router, container: DependencyContainer) {
        tabBarController = DeliveryTabBarController()
        coordinatorFactory = DeliveryTabBarCoordinatorFactory(container: container)
        super.init(router: router, container: container)
    }
    
    override func start() {
        setupDeliveryFlow()
        let viewController = tabRootContainers.map { $0.viewController }
        tabBarController.setViewControllers(viewController)
        router.setRootModule(tabBarController, isNavigationBarHidden: false)
    }
    
    private func setupDeliveryFlow() {
        let (coordinator, rooController) = coordinatorFactory.makeDeliveryCoordinator()
        coordinator.start()
        addDependency(coordinator)
        guard let controller = rooController.toPresent() else { return }
        tabRootContainers.append(.init(viewController: controller, coordinator: coordinator))
    }
}
