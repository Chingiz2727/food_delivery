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
        var module = moduleFactory.deliveryProduct(retail: retail)
        module.onMakeOrdedDidTap = { [weak self] in
            self?.showBasket()
        }
        router.push(module)
    }
    
    private func showBasket() {
        var module = moduleFactory.makeBasket()
        module.onDeliveryChoose = { [weak self] orderType in
            self?.showMakeOrder(orderType: orderType)
        }
        router.push(module)
    }

    private func showMakeOrder(orderType: OrderType) {
        var module = moduleFactory.makeMakeOrder(orderType: orderType)
        module.onMapShowDidSelect = { [weak self] in
            self?.makeMapSearch()
        }
        module.emptyDishList = { [weak self] in
            self?.router.popModule()
        }
        router.push(module)
    }

    func makeMapSearch() {
        var module = container.resolve(DeliveryLocationModule.self)!
        module.onlocationDidSelect = { [weak self] location in
            print(location)
            self?.router.popModule()
        }
        router.push(module)
    }
}
