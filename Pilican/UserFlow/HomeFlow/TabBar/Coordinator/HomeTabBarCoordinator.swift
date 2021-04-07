import UIKit
import Foundation

struct TabableRootControllerAndCoordinatorContainer {
    var viewController: UIViewController
    var coordinator: TababbleCoordinator
}

public protocol HomeTabBarCoordinatorOutput: BaseCoordinator {
    func goToHomeWithDeeplink(action: DeepLinkAction)
    var onDeliveryTab: Callback? { get set }
}

final class HomeTabBarCoordinator: BaseCoordinator, HomeTabBarCoordinatorOutput, TababbleCoordinator {
    var onTabBarItemNeedsToBeChanged: ((DeliveryTabBarItem) -> Void)?
    

    private let moduleFactory: HomeCoordinatorModuleFactory
    var onDeliveryTab: Callback?
    
    override init(router: Router, container: DependencyContainer) {
        moduleFactory = HomeCoordinatorModuleFactory(container: container, router: router)
        super.init(router: router, container: container)
    }

    func goToHomeWithDeeplink(action: DeepLinkAction) {
    }

    override func start() {
        showHome()
    }

    private func showHome() {
        var module = moduleFactory.makeHome()
        module.selectRetail = { [weak self] retail in
            self?.startRetailDetailCoordinator(retail: retail)
        }

        module.selectMenu = { [weak self] category in
            print("selected category", category)
            switch category {
            case .cashBack:
                self?.showCashBackList()
            case .delivery:
                self?.showDelivery()
            case .bus:
                self?.showCamera()
            default:
                break
            }
        }
        router.setRootModule(module)
    }

    private func startRetailDetailCoordinator(retail: Retail) {
        let coordinator = moduleFactory.makeRetailDetailCoordinator(retail: retail)
        coordinator.onFlowDidFinish = { [weak self] in
            self?.removeDependency(coordinator)
            self?.router.popModule()
        }
        coordinator.start()
        addDependency(coordinator)
    }

    private func showCashBackList() {
        var module = moduleFactory.makeCashbackList()

        module.onSelectRetail = { [weak self] retail in
            self?.startRetailDetailCoordinator(retail: retail)
        }

        router.push(module)
    }
    
    private func showDelivery() {
        onDeliveryTab?()
    }
    
    private func showCamera() {
        let module = container.resolve(CameraModule.self)!
        router.push(module)
    }
}
