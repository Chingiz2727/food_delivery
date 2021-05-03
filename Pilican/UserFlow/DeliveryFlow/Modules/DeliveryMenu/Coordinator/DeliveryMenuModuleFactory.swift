//
//  DeliveryMenuModuleFactory.swift
//  Pilican
//
//  Created by kairzhan on 4/16/21.
//

import Foundation

final class DeliveryMenuModuleFactory {
    private let container: DependencyContainer
    private let router: Router
    
    init(container: DependencyContainer, router: Router) {
        self.container = container
        self.router = router
    }
    
    func makedDeliveryMenu() -> DeliveryMenuModule {
        return DeliveryMenuViewController()
    }
    
    func makeFavorites() -> FavoritesModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = FavoritesViewModel(apiService: apiService)
        return FavoritesViewController(viewModel: viewModel)
    }
    
    func makeMyCards() -> MyCardsModule {
        let apiService = container.resolve(ApiService.self)!
        let myCardViewModel = MyCardsViewModel(apiService: apiService)
        return MyCardsViewController(viewModel: myCardViewModel)
    }
    
    func makeOrderHistory() -> OrderHistoryModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = OrderHistoryViewModel(apiService: apiService)
        return OrderHistoryViewController(viewModel: viewModel, dishList: container.resolve(DishList.self)!)
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
