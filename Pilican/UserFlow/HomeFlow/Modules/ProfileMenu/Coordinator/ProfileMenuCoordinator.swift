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
            case .bonuses:
                self?.showBonus()
            default:
                return
            }
            self?.router.dismissModule()
        }
        router.presentActionSheet(module, interactive: true)
    }

    private func showAccount() {
        let module = moduleFactory.makeAccount()
        router.push(module)
    }

    private func showBonus() {
        let module = moduleFactory.makeBonus()
        router.push(module)
    }
}
