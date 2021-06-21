//
//  DeliveryMenuCoordinator.swift
//  Pilican
//
//  Created by kairzhan on 4/16/21.
//
import CoreLocation
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
        module.remakeOrder = { [weak self] type, location in
            self?.showMakeOrder(orderType: type, userLocation: location)
        }
        
        module.selectedOrderHistory = { [weak self] retail, type in
            if type == .delivery && retail.isWork == 1 {
                self?.showDeliveryProduct(retail: retail)
            }
        }
        
        module.onSelectOrderHistory = { [weak self] retail, type in
            self?.showOrderStatus(orderId: retail.id!)
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
        module.onDeliveryChoose = { [weak self] orderType, userLocation in
            self?.showMakeOrder(orderType: orderType, userLocation: userLocation)
        }
        router.push(module)
    }

    private func showMakeOrder(orderType: OrderType, userLocation: CLLocationCoordinate2D) {
        var module = moduleFactory.makeMakeOrder(orderType: orderType, userLocation: userLocation)
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
