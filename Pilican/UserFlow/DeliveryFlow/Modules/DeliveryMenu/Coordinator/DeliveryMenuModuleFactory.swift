//
//  DeliveryMenuModuleFactory.swift
//  Pilican
//
//  Created by kairzhan on 4/16/21.
//

import Foundation

final class DeliveryMenuModuleFactory {
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func makeDeliveryMenu() -> DeliveryMenuModule {
        return DeliveryMenuViewController()
    }
    
    func makeFavorites() -> FavoritesModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = FavoritesViewModel(apiService: apiService)
        return FavoritesViewController(viewModel: viewModel)
    }
    
    func makeMyCards() -> MyCardsModule {
        return MyCardsViewController()
    }
    
    func makeOrderHistory() -> OrderHistoryModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = OrderHistoryViewModel(apiService: apiService)
        return OrderHistoryViewController(viewModel: viewModel)
    }
}
