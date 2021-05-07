import UIKit
import RxSwift

struct TabableRootControllerAndCoordinatorContainer {
    var viewController: UIViewController
    var coordinator: TababbleCoordinator
}

public protocol HomeTabBarCoordinatorOutput: BaseCoordinator {
    func goToHomeWithDeeplink(action: DeepLinkAction)
    var onDeliveryTab: Callback? { get set }
    var onPopTap: Callback? { get set }
}

final class HomeTabBarCoordinator: BaseCoordinator, HomeTabBarCoordinatorOutput, TababbleCoordinator {
    var onTabBarItemNeedsToBeChanged: ((DeliveryTabBarItem) -> Void)?

    private let moduleFactory: HomeCoordinatorModuleFactory
    var onDeliveryTab: Callback?
    var onPopTap: Callback?
    
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
            self?.router.popToRootModule()
        }
        
        onPopTap =  {
            coordinator.onFlowDidFinish?()
        }
        onPopTap = {
            coordinator.router.popToRootModule()
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
        var module = container.resolve(CameraModule.self)!
        module.cameraActionType = .makePayment
        module.paymentMaked = { [weak self] info in
            self?.showPaymentPartner(info: info)
        }
        module.closeButton = { [weak self] in
            self?.router.popModule()
        }
        module.howItWorkTapped = { [weak self] in
            self?.showHowItWork()
        }
        router.push(module)
    }

    private func showPaymentPartner(info: ScanRetailResponse) {
        let apiService = container.resolve(ApiService.self)!
        let userSessionStorage = container.resolve(UserSessionStorage.self)!

        let viewModel = QRPaymentViewModel(apiService: apiService, info: info, userSessionStorage: userSessionStorage)
        var module = moduleFactory.makePayPartner(viewModel: viewModel)
        module.openSuccessPayment = { [weak self] retail, price, cashback in
            self?.showSuccessPayment(retail: retail, price: price, cashback: cashback)
        }
        module.closeButton = { [weak self] in
            self?.router.popModule()
        }
        router.push(module)
    }
    
    private func showSuccessPayment(retail: Retail, price: Int, cashback: Int) {
        var module = moduleFactory.makeSuccessPayment(retail: retail, price: price, cashback: cashback)
        module.nextTapped = { [weak self] in
            self?.router.popToRootModule()
        }
        router.push(module)
    }

    private func showHowItWork() {
        let module = moduleFactory.makeHowItWork()
        router.presentCard(module)
    }
}
