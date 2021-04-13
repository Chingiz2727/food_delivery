import UIKit
protocol RetailListMapCoordinatorOutput: DeliveryTabBarItemCoordinator { }

final class RetailListMapCoordinator: BaseCoordinator, RetailListMapCoordinatorOutput {
    var onTabBarItemNeedsToBeChanged: ((DeliveryTabBarItem) -> Void)?
    
    let moduleFactory: RetailListMapModuleFactory
    
    override init(router: Router, container: DependencyContainer) {
        moduleFactory = RetailListMapModuleFactory(container: container)
        super.init(router: router, container: container)
    }
    
    override func start() {
        showRetailMapList()
    }
    
    private func showRetailMapList() {
        let module  = moduleFactory.makeMapModule()
        router.setRootModule(module)
    }
}
