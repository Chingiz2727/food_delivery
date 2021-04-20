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
        router.push(module)
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
