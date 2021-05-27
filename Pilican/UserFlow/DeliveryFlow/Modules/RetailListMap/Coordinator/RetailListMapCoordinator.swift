import UIKit
protocol RetailListMapCoordinatorOutput: DeliveryTabBarItemCoordinator { }

final class RetailListMapCoordinator: BaseCoordinator, RetailListMapCoordinatorOutput {
    var onTabBarItemNeedsToBeChanged: ((DeliveryTabBarItem) -> Void)?
    
    let moduleFactory: RetailListMapModuleFactory

    override init(router: Router, container: DependencyContainer) {
        moduleFactory = RetailListMapModuleFactory(container: container, router: router)
        super.init(router: router, container: container)
    }
    
    override func start() {
        showRetailMapList()
    }
    
    private func showRetailMapList() {
        var module = moduleFactory.makeMapModule()
        module.onDeliveryRetailSelect = { [weak self] retail in
            self?.showDeliveryProduct(retail: retail)
        }
        router.setRootModule(module, isNavigationBarHidden: false)
    }
    
    private func showDeliveryRetailList() {
        var module = moduleFactory.delivery()
        module.onRetailDidSelect = { [weak self] retail in
            self?.showDeliveryProduct(retail: retail)
        }
        module.deliveryMenuDidSelect = { [weak self] in
            self?.showDeliveryMenu()
        }
        router.setRootModule(module)
    }
    
    private func showDeliveryProduct(retail: DeliveryRetail) {
        let coordinator = OrderingCoordinator(router: router, container: container)
        coordinator.retail = retail
        addDependency(coordinator)
        coordinator.start()
    }

    private func showDeliveryMenu() {
        let coordinator = moduleFactory.makeDeliveryMenu()
        coordinator.start()
        addDependency(coordinator)
    }
}
