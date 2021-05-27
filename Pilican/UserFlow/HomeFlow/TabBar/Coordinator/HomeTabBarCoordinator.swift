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
    var onBusCameraTap: Callback? { get set }
}

final class HomeTabBarCoordinator: BaseCoordinator, HomeTabBarCoordinatorOutput, TababbleCoordinator {
    var onTabBarItemNeedsToBeChanged: ((DeliveryTabBarItem) -> Void)?

    private let moduleFactory: HomeCoordinatorModuleFactory
    var onBusCameraTap: Callback?
    var onDeliveryTab: Callback?
    var onPopTap: Callback?
    
    override init(router: Router, container: DependencyContainer) {
        moduleFactory = HomeCoordinatorModuleFactory(container: container, router: router)
        super.init(router: router, container: container)
    }

    func goToHomeWithDeeplink(action: DeepLinkAction) {
    }

    override func start() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(NotificationsString.openNotifications.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showListNotify), name: NSNotification.Name(NotificationsString.openNotifications.rawValue), object: nil)
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
                self?.onBusCameraTap?()
            case .volunteer:
                self?.showAlert()
            }
        }
        
        module.showMyQr = { [weak self] in
            self?.showMyQr()
        }
        
        router.setRootModule(module, isNavigationBarHidden: false)
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

    private func showBusCamera() {
        var module = container.resolve(CameraModule.self)!
        module.cameraActionType = .makePayment
        module.paymentMaked = { [weak self] info, price in
            self?.showPaymentPartner(info: info, price: price)
        }
        module.closeButton = { [weak self] in
            self?.router.popModule()
        }
        module.howItWorkTapped = { [weak self] in
            self?.showHowItWork()
        }
        module.retailTapped = { [weak self] retail in
            self?.showPaymentPartner(info: .init(orderId: 0, fullName: "", type: 0, retail: retail), price: nil)
        }
        module.retailIdTapped = { [weak self] retail in
            self?.showPaymentPartner(info: .init(orderId: 0, fullName: "", type: 0, retail: retail), price: nil)
        }
        router.push(module)
    }
    
    private func showCamera() {
        var module = container.resolve(CameraModule.self)!
        module.cameraActionType = .makePayment
        module.paymentMaked = { [weak self] info, price in
            self?.showPaymentPartner(info: info, price: price)
        }
        module.closeButton = { [weak self] in
            self?.router.popModule()
        }
        module.howItWorkTapped = { [weak self] in
            self?.showHowItWork()
        }
        router.push(module)
    }

    private func showPaymentPartner(info: ScanRetailResponse, price: String?) {
        let apiService = container.resolve(ApiService.self)!
        let userSessionStorage = container.resolve(UserSessionStorage.self)!

        let viewModel = QRPaymentViewModel(apiService: apiService, info: info, userSessionStorage: userSessionStorage)
        var module = moduleFactory.makePayPartner(viewModel: viewModel, price: price)
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
        let module = moduleFactory.makeHowItWork(workType: .pay)
        router.presentCard(module)
    }
    
    private func showMyQr() {
        let module = moduleFactory.makeMyQR()
        router.push(module)
    }
    
    @objc func showListNotify() {
        showNotificationList()
    }
    
    private func showNotificationList() {
        var module = moduleFactory.makeNotificationList()
        module.notificationsListDidSelect = { [weak self] item in
            switch item {
            case .pillikanInfo: self?.showNotificationPillikanInfo()
            case .pillikanPay: self?.showNotificationPillikanPay()
            }
        }
        module.closeButton = { [weak self] in
            self?.router.popModule()
        }
        router.push(module)
    }

    private func showNotificationPillikanInfo() {
        var module = moduleFactory.pillikanInfoNotifications()
        module.closeButton = { [weak self] in
            self?.router.popModule()
        }
        router.push(module)
    }

    private func showNotificationPillikanPay() {
        var module = moduleFactory.pillikanPayNotifications()
        module.closeButton = { [weak self] in
            self?.router.popModule()
        }
        router.push(module)
    }
}
