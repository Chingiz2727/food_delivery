import CoreLocation

final class RetailListMapModuleFactory {

    private let container: DependencyContainer
    private let router: Router
    
    init(container: DependencyContainer, router: Router) {
        self.container = container
        self.router = router
    }
    
    func makeMapModule() -> RetailListMapModule {
        let locationManager = container.resolve(CLLocationManager.self)!
        let apiService = container.resolve(ApiService.self)!
        let viewModel = RetailListMapViewModel(apiService: apiService)
        return RetailListMapViewController(mapManager: container.resolve(MapManager.self)!, locationManager: locationManager, viewModel: viewModel)
    }
    
    func delivery() -> DeliveryRetailListModule {
        let apiSevice = container.resolve(ApiService.self)!
        let viewModel = DeliveryRetailListViewModel(apiService: apiSevice)
        let dishList = container.resolve(DishList.self)!
        let controller = DeliveryRetailListViewController(viewModel: viewModel, dishList: dishList)
        return controller
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

    func makeDeliveryMenu() -> DeliveryMenuCoordinator {
        return DeliveryMenuCoordinatorImpl(router: router, container: container)
    }
    
    func makeOrderSuccess(order: DeliveryOrderResponse) -> OrderSuccessModule {
        return OrderSuccessViewController(order: order)
    }
    
    func makeOrderError() -> OrderErrorModule {
        return OrderErrorViewController()
    }
}
