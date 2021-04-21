//
//  CashbackMenuCoordinator.swift
//  Pilican
//
//  Created by kairzhan on 3/2/21.
//

import Foundation

protocol CashbackMenuCoordinator: BaseCoordinator {}

final class CashbackMenuCoordinatorImpl: BaseCoordinator, CashbackMenuCoordinator {
    
    private let moduleFactory: CashbackMenuModuleFactory

    override init(router: Router, container: DependencyContainer) {
        moduleFactory = CashbackMenuModuleFactory(container: container)
        super.init(router: router, container: container)
    }
    
    override func start() {
        presentMenu()
    }

    private func presentMenu() {
        var module = moduleFactory.makeMenu()

        module.menuDidSelect = { [weak self] menu in
            switch menu {
            case .myCards:
                self?.showMyCards()
            case .balanceReplishment:
                self?.showBalance()
            case .historyOfPay:
                self?.showPayHistory()
            default:
                break
            }
            self?.router.dismissModule()
        }
        router.presentActionSheet(module, interactive: true)
    }

    private func showMyCards() {
        let module = moduleFactory.makeMyCards()
        router.push(module)
    }

    private func showBalance() {
        let userInfoStorage = container.resolve(UserInfoStorage.self)!
        let apiService = container.resolve(ApiService.self)!
        let userSessionStorage = container.resolve(UserSessionStorage.self)!
        let viewModel = BalanceViewModel(apiService: apiService, userSessionStorage: userSessionStorage)
        var module = moduleFactory.makeBalance(viewModel: viewModel, userInfoStorage: userInfoStorage)
        module.dissmissBalanceModule = { [weak self] in
            self?.router.dismissModule()
        }
        router.push(module)
    }
    
    private func showPayHistory() {
        var module = moduleFactory.makePayHistory()
        module.onSelectPayHistory = { [weak self] payments in
            self?.showPayDetail(payments: payments)
        }
        router.push(module)
    }
    
    private func showPayDetail(payments: Payments) {
        let module = moduleFactory.makePayDetail(payments: payments)
        router.presentCard(module)
    }
}
