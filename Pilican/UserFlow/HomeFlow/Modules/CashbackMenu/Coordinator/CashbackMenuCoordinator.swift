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
            self?.router.dismissModule()
        }
        router.presentActionSheet(module, interactive: true)
    }
}
