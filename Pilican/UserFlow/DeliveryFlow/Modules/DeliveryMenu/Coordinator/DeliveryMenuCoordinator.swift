//
//  DeliveryMenuCoordinator.swift
//  Pilican
//
//  Created by kairzhan on 4/16/21.
//

import Foundation

protocol DeliveryMenuCoordinator: BaseCoordinator {}

final class DeliveryMenuCoordinatorImpl: BaseCoordinator, DeliveryMenuCoordinator {
    private let moduleFactory: DeliveryMenuModuleFactory
    
    override init(router: Router, container: DependencyContainer) {
        moduleFactory = DeliveryMenuModuleFactory(container: container)
        super.init(router: router, container: container)
    }
    
    override func start() {
        presentMenu()
    }
    
    private func presentMenu() {
        var module = moduleFactory.makeDeliveryMenu()
        module.deliveryMenuDidSelect = { [weak self] menu in
            switch menu {
            case .orderHistory:
                self?.showOrderHistory()
            case .favorites:
                self?.showFavorites()
            case .myCards:
                self?.showMyCards()
            }
            self?.router.dismissModule()
        }
        router.presentActionSheet(module, interactive: true)
    }
    
    private func showOrderHistory() {
        let module = moduleFactory.makeOrderHistory()
        router.push(module)
    }

    private func showFavorites() {
        let module = moduleFactory.makeFavorites()
        router.push(module)
    }
    
    private func showMyCards() {
        let module = moduleFactory.makeMyCards()
        router.push(module)
    }
}
