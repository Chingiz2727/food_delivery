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
        let module = moduleFactory.makeBasket()
        router.setRootModule(module)
    }
}
