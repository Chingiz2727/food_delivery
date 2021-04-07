import UIKit

protocol DeliveryCoordinatorOutput: DeliveryTabBarItemCoordinator { }

final class DeliveryCoordinator: BaseCoordinator, DeliveryCoordinatorOutput {
    var onTabBarItemNeedsToBeChanged: ((DeliveryTabBarItem) -> Void)?
    
    private let coordinatorFactory: DeliveryCoordinatorModuleFactory
    
    override init(router: Router, container: DependencyContainer) {
        coordinatorFactory = DeliveryCoordinatorModuleFactory(container: container)
        super.init(router: router, container: container)
    }
    
    override func start() {
        showDeliveryRetailList()
    }
    
    private func showDeliveryRetailList() {
        let module = coordinatorFactory.delivery()
        router.setRootModule(module)
    }
}
