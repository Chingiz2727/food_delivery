import UIKit

protocol SearchCoordinatorOutput: DeliveryTabBarItemCoordinator { }

final class SearchCoordinator: BaseCoordinator, SearchCoordinatorOutput {
    var onTabBarItemNeedsToBeChanged: ((DeliveryTabBarItem) -> Void)?
    
    private let moduleFactory: SearchCoordinatorFactory
    
    override init(router: Router, container: DependencyContainer) {
        moduleFactory = SearchCoordinatorFactory(container: container)
        super.init(router: router, container: container)
    }
    
    override func start() {
        showSearchItem()
    }
    
    private func showSearch() {
        let module = moduleFactory.showSearchModule()
        module.addSearch { [weak self] in
            self?.showSearchItem()
        }
        router.setRootModule(module)
    }
    
    private func showSearchItem() {
        var module = moduleFactory.showSearchItemModule()
        module.onDeliveryRetailCompanyDidSelect = { [weak self] retail in
            self?.showDeliveryProduct(retail: retail)
        }
        router.setRootModule(module)
    }
    
    private func showDeliveryProduct(retail: DeliveryRetail) {
        let coordinator = OrderingCoordinator(router: router, container: container)
        coordinator.retail = retail
        addDependency(coordinator)
        coordinator.start()
    }
}
