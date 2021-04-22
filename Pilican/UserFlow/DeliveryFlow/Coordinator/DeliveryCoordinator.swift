import UIKit

protocol DeliveryCoordinatorOutput: DeliveryTabBarItemCoordinator { }

final class DeliveryCoordinator: BaseCoordinator, DeliveryCoordinatorOutput {
    var onTabBarItemNeedsToBeChanged: ((DeliveryTabBarItem) -> Void)?

    private let coordinatorFactory: DeliveryCoordinatorModuleFactory

    override init(router: Router, container: DependencyContainer) {
        coordinatorFactory = DeliveryCoordinatorModuleFactory(container: container, router: router)
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
        module.deliveryMenuDidSelect = { [weak self] in
            self?.showDeliveryMenu()
        }
        router.setRootModule(module)
    }
    
    private func showDeliveryProduct(retail: DeliveryRetail) {
        var module = coordinatorFactory.deliveryProduct(retail: retail)
        module.onMakeOrdedDidTap = { [weak self] in
            self?.showBasket()
        }
        router.push(module)
    }
    
    private func showBasket() {
        var module = coordinatorFactory.makeBasket()
        module.onDeliveryChoose = { [weak self] orderType in
            self?.showMakeOrder(orderType: orderType)
        }
        router.push(module)
    }
    
    private func showMakeOrder(orderType: OrderType) {
        var module = coordinatorFactory.makeMakeOrder(orderType: orderType)
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
        var module = coordinatorFactory.makeOrderError()
        module.repeatMakeOrder = { [weak self] in
            self?.router.popModule()
        }
        router.push(module)
    }

    private func showOrderSuccess(order: OrderResponse) {
        var module = coordinatorFactory.makeOrderSuccess(order: order)
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
        let coordinator = coordinatorFactory.makeDeliveryMenu()
        coordinator.start()
        addDependency(coordinator)
    }
}
