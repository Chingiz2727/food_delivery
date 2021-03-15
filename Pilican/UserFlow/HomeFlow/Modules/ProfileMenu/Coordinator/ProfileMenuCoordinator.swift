protocol ProfileMenuCoordinator: BaseCoordinator {}

final class ProfileMenuCoordinatorImpl: BaseCoordinator, ProfileMenuCoordinator {
    
    private let moduleFactory: ProfileMenuModuleFactory

    override init(router: Router, container: DependencyContainer) {
        moduleFactory = ProfileMenuModuleFactory(container: container)
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
        var module = moduleFactory.makeAccount()
        module.editAccountDidSelect = { [weak self] in
            self?.presentEditAccount()
        }
        router.push(module)
    }

    private func presentEditAccount() {
        let module = moduleFactory.makeEditAccount()
        router.push(module)
    }
}
