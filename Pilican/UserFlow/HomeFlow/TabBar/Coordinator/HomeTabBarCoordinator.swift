import UIKit
import RxSwift

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
            switch category {
            case .cashBack:
                self?.showCashBackList()
            case .delivery:
                self?.showDelivery()
            case .bus:
                self?.showCamera()
            case .volunteer:
                self?.showAlert()
            }
        }
        router.setRootModule(module)
    }

    private func showAlert() {
        // swiftlint:disable line_length
        let alert = UIAlertController(title: "Пристегивайтесь!", message: "Наш новый сервис Pillikan Taxi почти готов к запуску. Следите за нами в Instagram и вы все узнаете первыми!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
        router.present(alert)
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
        self.onDeliveryTab?()
    }

    private func showCamera() {
        let module = container.resolve(CameraModule.self)!
        router.push(module)
    }
}
