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
        let controller = OrderTypeViewController()
        return controller
    }
}
