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
    
    func makeBalance() -> BalanceModule {
        return BalanceViewController()
    }
}
