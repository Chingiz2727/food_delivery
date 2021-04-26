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
        moduleFactory = DeliveryMenuModuleFactory(container: container, router: router)
        super.init(router: router, container: container)
    }
    
    override func start() {
        presentMenu()
    }

    private func presentMenu() {
        var module = moduleFactory.makedDeliveryMenu()
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
        var module = moduleFactory.makeOrderHistory()
        module.onSelectOrderHistory = { [weak self] order in
            self?.showMore()
        }
        router.push(module)
    }
    
    private func showMore() {
        
    }

    private func showFavorites() {
        var module = moduleFactory.makeFavorites()
        module.onRetailDidSelect = { [weak self] retail in
            self?.showDeliveryProduct(retail: retail)
        }
        router.push(module)
    }

    private func showMyCards() {
        let module = moduleFactory.makeMyCards()
        router.push(module)
    }

    private func showDeliveryProduct(retail: DeliveryRetail) {
        var module = moduleFactory.deliveryProduct(retail: retail)
        module.onMakeOrdedDidTap = { [weak self] in
            self?.showBasket()
        }
        module.alcohol = { [weak self] in
            self?.showAlcohol()
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
            self?.makeMapSearch(addressSelected: { address in
                module.putAddress?(address)
            })
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

    private func showAlcohol() {
        var module = moduleFactory.makeAlcohol()
        module.acceptButtonTapped = { [weak self] in
            self?.router.dismissModule()
        }
        router.presentCard(module, isDraggable: true, isDismissOnDimEnabled: true, isCloseable: true)
    }

    private func showOrderError() {
        var module = moduleFactory.makeOrderError()
        module.repeatMakeOrder = { [weak self] in
            self?.router.popModule()
        }
        router.push(module)
    }

    private func showOrderSuccess(order: OrderResponse) {
        var module = moduleFactory.makeOrderSuccess(order: order)
        module.toMain = { [weak self] in
            self?.router.popToRootModule()
        }
        router.push(module)
    }

    func makeMapSearch(addressSelected: @escaping ((DeliveryLocation) -> Void)) {
        var module = container.resolve(DeliveryLocationModule.self)!
        module.onlocationDidSelect = { [weak self] location in
            self?.router.popModule()
            addressSelected(location)
        }
        router.push(module)
    }

    private func showDeliveryMenu() {
        let coordinator = moduleFactory.makeDeliveryMenu()
        coordinator.start()
        addDependency(coordinator)
    }
}
