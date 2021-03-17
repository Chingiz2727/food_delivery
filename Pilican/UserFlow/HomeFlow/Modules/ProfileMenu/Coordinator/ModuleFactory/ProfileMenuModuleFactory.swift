final class ProfileMenuModuleFactory {
    private let container: DependencyContainer

    init(container: DependencyContainer) {
        self.container = container
    }

    func makeMenu() -> ProfileMenuModule {
        return ProfileMenuViewController()
    }
    
    func makeAbout() -> AboutModule {
        return AboutViewController()
    }

    func makeAcceptPermission() -> AcceptPermissionModule {
        let viewController = AcceptPermissionViewController()
        return viewController
    }

    func makeAccount() -> AccountModule {
        return AccountViewController()
    }

    func makeEditAccount() -> EditAccountModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = EditAccountViewModel(apiService: apiService)
        let dateFormatter = container.resolve(PropertyFormatter.self)!
        let viewController = EditAccountViewController(viewModel: viewModel, dateFormatter: dateFormatter)
        return viewController
    }
    
    func makeBonus() -> BonusModule {
        return BonusViewController()
    }
}
