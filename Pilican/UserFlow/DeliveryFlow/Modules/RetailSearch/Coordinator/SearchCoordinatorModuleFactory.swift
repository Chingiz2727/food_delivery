final class SearchCoordinatorFactory {
    private let container: DependencyContainer

    init(container: DependencyContainer) {
        self.container = container
    }

    func showSearchModule() -> RetailSearchModule {
        return RetailSearchViewController()
    }
    
    func showSearchItemModule() -> ItemSearchModule {
        let serivce = container.resolve(ApiService.self)!
        let viewModel = ItemSearchViewMoodel(apiService: serivce)
        let dishList = container.resolve(DishList.self)!
        return ItemSearchViewController(viewModel: viewModel, dishList: dishList)
    }
    
    func deliveryProduct(retail: DeliveryRetail) -> DeliveryRetailProductsModule {
        let apiSevice = container.resolve(ApiService.self)!
        let dishList = container.resolve(DishList.self)!
        let viewModel = DeliveryRetailProductViewModel(apiService: apiSevice, retailInfo: retail, dishList: dishList)
        let controller = DeliveryRetailProductsViewController(viewModel: viewModel, favouriteManager: container.resolve(FavouritesManager.self)!, workCalendar: container.resolve(WorkCalendar.self)!)
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
}
