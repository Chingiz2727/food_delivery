//
//  OrderTypeCoordinatorModuleFactory.swift
//  Pilican
//
//  Created by kairzhan on 4/7/21.
//

import Foundation

final class OrderTypeCoordinatorModuleFactory {
    
    private let container: DependencyContainer
    private let router: Router

    init(container: DependencyContainer, router: Router) {
        self.container = container
        self.router = router
    }

    func makeBasket() -> OrderTypeModule {
        let dishList = container.resolve(DishList.self)!
        let controller = OrderTypeViewController(dishList: dishList)
        return controller
    }
    
    func makeMakeOrder() -> MakeOrderModule {
        let dishList = container.resolve(DishList.self)!
        let userInfo = container.resolve(UserInfoStorage.self)!
        let viewModel = MakeOrderViewModel(dishList: dishList, userInfo: userInfo)
        let controller = MakeOrderViewController(viewModel: viewModel)
        return controller
    }
}
