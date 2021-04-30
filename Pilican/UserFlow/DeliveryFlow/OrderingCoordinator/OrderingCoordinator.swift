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
        module.orderSuccess = { [weak self] order in
            self?.showOrderSuccess(order: order)
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

    private func showOrderSuccess(order: OrderResponse) {
        var module = coordinatorFactory.makeOrderSuccess(order: order)
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
    
    private func showOrderStatus(order: DeliveryOrderResponse) {
        let module = coordinatorFactory.makeOrderStatus(order: order)
        router.push(module)
    }
}
