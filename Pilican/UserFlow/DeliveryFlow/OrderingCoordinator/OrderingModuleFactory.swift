final class OrderingModuleFactory {
    
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func deliveryProduct(retail: DeliveryRetail) -> DeliveryRetailProductsModule {
        let apiSevice = container.resolve(ApiService.self)!
        let dishList = container.resolve(DishList.self)!
        let viewModel = DeliveryRetailProductViewModel(apiService: apiSevice, retailInfo: retail, dishList: dishList)
        let controller = DeliveryRetailProductsViewController(viewModel: viewModel)
        return controller
    }

    func makeBasket() -> OrderTypeModule {
        let dishList = container.resolve(DishList.self)!
        let controller = OrderTypeViewController(dishList: dishList, mapManager: container.resolve(MapManager.self)!)
        return controller
    }

    func makeMakeOrder(orderType: OrderType) -> MakeOrderModule {
        let dishList = container.resolve(DishList.self)!
        let userInfo = container.resolve(UserInfoStorage.self)!
        let viewModel = MakeOrderViewModel(dishList: dishList, userInfo: userInfo, mapManager: container.resolve(MapManager.self)!, apiService: container.resolve(ApiService.self)!)
        let controller = MakeOrderViewController(viewModel: viewModel)
        controller.orderType = orderType
        return controller
    }

    func makeOrderSuccess(orderId: Int) -> OrderSuccessModule {
        let updater = container.resolve(UserInfoUpdater.self)!
        return OrderSuccessViewController(orderId: orderId, updater: updater)
    }

    func makeOrderError() -> OrderErrorModule {
        return OrderErrorViewController()
    }

    func makeAlcohol() -> AlcoholModule {
        return AlcoholViewController()
    }

    func makeOrderStatus(orderId: Int) -> OrderStatusModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = OrderStatusViewModel(apiService: apiService, orderId: orderId)
        return OrderStatusViewController(viewModel: viewModel)
    }

    func makeRateDelivery(order: DeliveryOrderResponse) -> RateDeliveryModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = CreateOrderRatingsViewModel(apiService: apiService, order: order)
        return RateDeliveryViewController(order: order, viewModel: viewModel)
    }

    func makeRateMeal(order: DeliveryOrderResponse) -> RateMealModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = RateMealViewModel(apiService: apiService, order: order)
        return RateMealViewController(order: order, viewModel: viewModel)
    }
}
