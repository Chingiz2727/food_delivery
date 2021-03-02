protocol ProfileMenuCoordinator: BaseCoordinator {}

final class ProfileMenuCoordinatorImpl: BaseCoordinator, ProfileMenuCoordinator {
    
    private let moduleFactory: ProfileMenuModuleFactory
    private let accountModuleFactory: AccountModuleFactory

    override init(router: Router, container: DependencyContainer) {
        moduleFactory = ProfileMenuModuleFactory(container: container)
        accountModuleFactory = AccountModuleFactory(container: container)
        super.init(router: router, container: container)
    }

    override func start() {
        presentMenu()
    }

    private func presentMenu() {
        var module = moduleFactory.makeMenu()
        module.menuDidSelect = { [weak self] menu in
            switch menu {
            case .account:
                self?.showAccount()
            default:
                return
            }
            self?.router.dismissModule()
        }
        router.presentActionSheet(module, interactive: true)
    }
    
    private func showAccount() {
        let module = accountModuleFactory.makeAccount()
        router.push(module)
    }
}
