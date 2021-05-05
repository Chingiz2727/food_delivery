import CoreLocation
final class RetailDetailModuleFactory {
    private let container: DependencyContainer

    init(container: DependencyContainer) {
        self.container = container
    }
    
    func makeRetailDetail(retail: Retail, workCalendar: WorkCalendar, dishList: DishList) -> RetailDetailModule {
        return RetailDetailViewController(retail: retail, workCalendar: workCalendar, dishList: dishList)
    }
    
    func makeProblemVC(retail: Retail) -> ProblemModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = ProblemViewModel(apiService: apiService, retailId: retail.id ?? 1)
        let viewController = ProblemViewController(viewModel: viewModel)
        return viewController
    }
    
    func makePayPartner(viewModel: QRPaymentViewModel, userInfo: UserInfoStorage) -> QRPaymentModule {
        return QRPaymentViewController(viewModel: viewModel, userInfo: userInfo)
    }
    
    func makeSuccessPayment(retail: Retail, price: Int, cashback: Int) -> SuccessPaymentModule {
        return SuccessPaymentViewController(retail: retail, price: price, cashback: cashback)
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
    
    func makeRetailMap(retail: Retail) -> RetailMapModule {
        return RetailMapViewController(mapManager: container.resolve(MapManager.self)!, retail: retail)
    }
}
