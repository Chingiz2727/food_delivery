final class OrderingCoordinator: BaseCoordinator {
    
    private let coordinatorFactory: OrderingModuleFactory
    var retail: DeliveryRetail!
    
    override init(router: Router, container: DependencyContainer) {
        coordinatorFactory = OrderingModuleFactory(container: container)
        super.init(router: router, container: container)
    }
    
    override func start() {
        showDeliveryProduct(retail: retail)
    }
    
    private func showDeliveryProduct(retail: DeliveryRetail) {
        var module = coordinatorFactory.deliveryProduct(retail: retail)
        module.onMakeOrdedDidTap = { [weak self] in
            self?.showBasket()
        }
        module.alcohol = { [weak self] in
            self?.showAlcohol()
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
        var module = coordinatorFactory.makeAlcohol()
        module.acceptButtonTapped = { [weak self] in
            self?.router.dismissModule()
        }
        router.presentCard(module, isDraggable: true, isDismissOnDimEnabled: true, isCloseable: true)
    }

    private func showOrderError() {
        var module = coordinatorFactory.makeOrderError()
        module.repeatMakeOrder = { [weak self] in
            self?.router.popModule()
        }
        router.push(module)
    }

    private func showOrderSuccess(orderId: Int) {
        var module = coordinatorFactory.makeOrderSuccess(orderId: orderId)
        module.toMain = { [weak self] in
            self?.router.popToRootModule()
        }
        module.toOrderStatus =  { [weak self] orderId in
            self?.showOrderStatus(orderId: orderId)
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

    private func showOrderStatus(orderId: Int) {
        var module = coordinatorFactory.makeOrderStatus(orderId: orderId)
        module.orderSend = { [weak self] order in
            self?.showRateDelivery(order: order)
        }
        router.push(module)
    }

    private func showRateDelivery(order: DeliveryOrderResponse) {
        var module = coordinatorFactory.makeRateDelivery(order: order)
        module.rateDeliveryTapped = { [weak self] order in
            self?.router.dismissModule()
            self?.showRateMeal(order: order)
        }
        router.present(module)
    }

    private func showRateMeal(order: DeliveryOrderResponse) {
        var module = coordinatorFactory.makeRateMeal(order: order)
        module.rateMealTapped = { [weak self] in
            self?.router.dismissModule()
            self?.router.popToRootModule()
        }
        router.present(module)
    }
}
