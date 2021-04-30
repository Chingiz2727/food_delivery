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
        module.onSelectOrderHistory = { [weak self] response, tag in
            // swiftlint:disable line_length
            let retail = DeliveryRetail(id: response.retailId ?? 0, cashBack: 0, isWork: 0, longitude: response.longitude ?? 0, latitude: response.latitude ?? 0, dlvCashBack: 0, pillikanDelivery: 0, logo: response.retailLogo ?? "", address: response.address ?? "", workDays: [], payIsWork: 0, name: response.retailName ?? "", status: response.status ?? 0, rating: response.retailRating ?? 0)
            if tag != 2 {
                self?.showDeliveryProduct(retail: retail)
            } else {
                self?.showOrderStatus(orderId: response.id ?? 0)
            }
        }
        router.push(module)
    }

    private func showOrderStatus(orderId: Int) {
        var module = moduleFactory.makeOrderStatus(orderId: orderId)
        module.orderSend = { [weak self] order in
            self?.showRateDelivery(order: order)
        }
        router.push(module)
    }
    
    private func showRateDelivery(order: DeliveryOrderResponse) {
        var module = moduleFactory.makeRateDelivery(order: order)
        module.rateDeliveryTapped = { [weak self] order in
            self?.router.dismissModule()
            self?.showRateMeal(order: order)
        }
        router.present(module)
    }

    private func showRateMeal(order: DeliveryOrderResponse) {
        var module = moduleFactory.makeRateMeal(order: order)
        module.rateMealTapped = { [weak self] in
            self?.router.dismissModule()
            self?.router.popToRootModule()
        }
        router.present(module)
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
        let coordinator = MyCardCoordinator(router: router, container: container)
        coordinator.start()
        addDependency(coordinator)
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
        module.orderSuccess = { [weak self] orderId in
            self?.showOrderSuccess(orderId: orderId)
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

    private func showOrderSuccess(orderId: Int) {
        var module = moduleFactory.makeOrderSuccess(orderId: orderId)
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
