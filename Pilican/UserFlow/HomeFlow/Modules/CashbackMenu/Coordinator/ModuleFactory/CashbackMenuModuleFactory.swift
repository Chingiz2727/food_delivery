//
//  CashbackMenuModuleFactory.swift
//  Pilican
//
//  Created by kairzhan on 3/2/21.
//

import Foundation

final class CashbackMenuModuleFactory {
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func makeMenu() -> CashbackMenuModule {
        return CashbackMenuViewController()
    }
    
    func makeMyCards() -> MyCardsModule {
        let apiService = container.resolve(ApiService.self)!
        let myCardViewModel = MyCardsViewModel(apiService: apiService)
        return MyCardsViewController(viewModel: myCardViewModel)
    }
    
    func makeBalance() -> BalanceModule {
        return BalanceViewController()
    }
    
    func makePayHistory() -> PayHistoryModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = PayHistoryViewModel(apiService: apiService)
        let controller = PayHistoryViewController(viewModel: viewModel)
        return controller
    }
    
    func makePayDetail(payments: Payments) -> PayDetailModule {
        return PayDetailViewController(payments: payments)
    }
    
    func makeAddCard() -> AddCardModule {
        let apiService = container.resolve(ApiService.self)!
        let cardService = AddCardApiServiceImpl(apiService: apiService)
        let viewModel = AddCardViewModel(addCardApiService: cardService, sessionStorage: container.resolve(UserSessionStorage.self)!)
        let controller = AddCardViewController(viewModel: viewModel)
        return controller
    }
    
    func make3dsWeb(cardModel: BindCardModel, htmlString: String) -> Post3dsWebViewModule {
        let controller = Post3dsWebViewController(bindCardModel: cardModel, htmlString: htmlString, sessionStorage: container.resolve(UserSessionStorage.self)!)
        return controller
    }
}
