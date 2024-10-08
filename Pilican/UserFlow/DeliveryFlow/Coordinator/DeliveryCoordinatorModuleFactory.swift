import UIKit
import CoreLocation

final class DeliveryCoordinatorModuleFactory {
    private let container: DependencyContainer
    private let router: Router

    init(container: DependencyContainer, router: Router) {
        self.container = container
        self.router = router
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
        let controller = DeliveryRetailProductsViewController(viewModel: viewModel, favouriteManager: container.resolve(FavouritesManager.self)!, workCalendar: container.resolve(WorkCalendar.self)!)
        return controller
    }

    func makeBasket() -> OrderTypeModule {
        let dishList = container.resolve(DishList.self)!
        let controller = OrderTypeViewController(dishList: dishList, mapManager: container.resolve(MapManager.self)!)
        return controller
    }

    func makeMakeOrder(orderType: OrderType, userLocation: CLLocationCoordinate2D) -> MakeOrderModule {
        let dishList = container.resolve(DishList.self)!
        let userInfo = container.resolve(UserInfoStorage.self)!
        let viewModel = MakeOrderViewModel(dishList: dishList, userInfo: userInfo, mapManager: container.resolve(MapManager.self)!, apiService: container.resolve(ApiService.self)!)
        let controller = MakeOrderViewController(viewModel: viewModel, userLocation: userLocation)
        controller.orderType = orderType
        return controller
    }

    func makeDeliveryMenu() -> DeliveryMenuCoordinator {
        return DeliveryMenuCoordinatorImpl(router: router, container: container)
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
}
