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
        router.setRootModule(module)
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
        module.orderSuccess = { [weak self] order in
            self?.showOrderSuccess(order: order)
        }
        module.orderError = { [weak self] in
            self?.showOrderError()
        }
        router.push(module)
    }

    private func showOrderError() {
        var module = moduleFactory.makeOrderError()
        module.repeatMakeOrder = { [weak self] in
            self?.router.popModule()
        }
        router.push(module)
    }

    private func showOrderSuccess(order: DeliveryOrderResponse) {
        var module = moduleFactory.makeOrderSuccess(order: order)
        module.toMain = { [weak self] in
            self?.router.popToRootModule()
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

    private func showDeliveryMenu() {
        let coordinator = moduleFactory.makeDeliveryMenu()
        coordinator.start()
        addDependency(coordinator)
    }
}
