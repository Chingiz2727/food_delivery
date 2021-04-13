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
        var module = coordinatorFactory.delivery()
        module.onRetailDidSelect = { [weak self] retail in
            self?.showDeliveryProduct(retail: retail)
        }
        router.setRootModule(module)
    }
    
    private func showDeliveryProduct(retail: DeliveryRetail) {
        let module = coordinatorFactory.deliveryProduct(retail: retail)
        router.push(module)
    }
}
