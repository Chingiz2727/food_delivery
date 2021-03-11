protocol ProfileMenuCoordinator: BaseCoordinator {}
import UIKit
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
            case .guide:
                self?.showGuide()
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
    
    private func showGuide() {
        let url = URL(string: "https://pillikan.kz/users-faq")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
