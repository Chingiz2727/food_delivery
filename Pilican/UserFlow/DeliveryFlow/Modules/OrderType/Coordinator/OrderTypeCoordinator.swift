//
//  OrderTypeCoordinator.swift
//  Pilican
//
//  Created by kairzhan on 4/7/21.
//

import Foundation

final class OrderTypeCoordinator: BaseCoordinator, DeliveryTabBarItemCoordinator {
    var onTabBarItemNeedsToBeChanged: ((DeliveryTabBarItem) -> Void)?
    
    private let moduleFactory: OrderTypeCoordinatorModuleFactory
    
    override init(router: Router, container: DependencyContainer) {
        moduleFactory = OrderTypeCoordinatorModuleFactory(container: container, router: router)
        super.init(router: router, container: container)
    }
    
    override func start() {
        showBasket()
    }
    
    private func showBasket() {
        var module = moduleFactory.makeBasket()
        module.onDeliveryChoose = { [weak self] in
            self?.showMakeOrder()
        }
        router.setRootModule(module)
    }
    
    private func showMakeOrder() {
        let module = moduleFactory.makeMakeOrder()
        router.push(module)
    }
}
