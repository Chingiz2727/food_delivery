//
//  AccountModuleFactory.swift
//  Pilican
//
//  Created by kairzhan on 3/1/21.
//

import Foundation

final class AccountModuleFactory {
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func makeAccount() -> AccountModule {
        return AccountViewController()
    }
}
