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

    func makeBonus() -> BonusModule {
        return BonusViewController()
    }
}

