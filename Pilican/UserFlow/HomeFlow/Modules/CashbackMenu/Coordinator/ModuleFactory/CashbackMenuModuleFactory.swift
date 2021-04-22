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
        return MyCardsViewController()
    }

    func makeBalance(viewModel: BalanceViewModel, userInfoStorage: UserInfoStorage) -> BalanceModule {
        return BalanceViewController(viewModel: viewModel, userInfoStorage: userInfoStorage)
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
}
