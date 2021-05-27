import Swinject

final class HomeCoordinator: BaseCoordinator {

    func goToHomeWithDeeplink(action: DeepLinkAction) {
    }

    private let coordinatorFactory: HomeTabBarCoordinatorFactory
    private var tabRootContainers: [TabableRootControllerAndCoordinatorContainer] = []
    private var tabBarController: HomeTabBarModule
    var tapPop: Callback?
    var cameraCalllBack: Callback?
    
    override init(router: Router, container: DependencyContainer) {
        coordinatorFactory = HomeTabBarCoordinatorFactory(container: container, router: router)
        let userInfoStorage = container.resolve(UserInfoStorage.self)!
        let controller = HomeTabBarViewController(userInfoStorage: userInfoStorage)
        tabBarController = controller
        super.init(router: router, container: container)
    }

    override func start() {
        makeTabBar()

        tabBarController.qrCodeTap = { [weak self] in
            self?.showCamera(workType: .pay)
        }

        tabBarController.accountTap = { [weak self] in
            self?.showProfileMenu()
        }


        tabBarController.bonusTap = { [weak self] in
            self?.showCashbackMenu()
        }

        tabBarController.notifyMenuTap = { [weak self] in
//            self?.showNotificationList()
        }
        
        tabBarController.backTap = { [weak self] in
            self?.router.popModule()
        }
        
        let logoutFlow = container.resolve(DeliveryLogoutStateObserver.self)!
        logoutFlow.setCoordinator(self)
        let viewControllers = tabRootContainers.map { $0.viewController }
        tabBarController.setViewControllers(viewControllers)
        router.setRootModule(tabBarController, isNavigationBarHidden: true)
    }

    
    private func makeTabBar() {
        let (homeCoordinator, rootController) = coordinatorFactory.makeHome()
        homeCoordinator.start()
        addDependency(homeCoordinator)
        guard let controller = rootController.toPresent() else { return }
        
        tapPop = {
            homeCoordinator.onPopTap?()
        }
        
        tapPop = { [weak self] in
            homeCoordinator.router.popToRootModule()
        }
        
        homeCoordinator.onBusCameraTap = { [weak self] in
            self?.showCamera(workType: .bus)
        }
        homeCoordinator.onDeliveryTab = { [weak self] in
            self?.startDeliveryFlow()
        }

        tabRootContainers.append(.init(viewController: controller, coordinator: homeCoordinator))
    }

    private func showCamera(workType: WorkType) {
        var module = container.resolve(CameraModule.self)!
        module.cameraActionType = .makePayment
        module.paymentMaked = { [weak self] info, price in
            self?.showPaymentPartner(info: info, price: price)
        }
        module.closeButton = { [weak self] in
            self?.router.popModule()
        }
        module.howItWorkTapped = { [weak self] in
            self?.showHowItWork(workType: workType)
        }
        module.retailTapped = { [weak self] retail in
            self?.showPaymentPartner(info: .init(orderId: 0, fullName: "", type: 0, retail: retail), price: nil)
        }
        module.retailIdTapped = { [weak self] retail in
            self?.showPaymentPartner(info: .init(orderId: 0, fullName: "", type: 0, retail: retail), price: nil)
        }
        router.push(module)
    }

    private func showHowItWork(workType: WorkType) {
        let module = coordinatorFactory.makeHowItWork(workType: workType)
        router.presentCard(module)
    }

    private func showProfileMenu() {
        let coordinator = coordinatorFactory.makeProfileMenu()
        coordinator.onLogoutDidTap = { [weak self] in
            self?.tapPop?()
        }
        coordinator.start()
        addDependency(coordinator)
    }

    private func showCashbackMenu() {
        let coordinator = coordinatorFactory.makeCashbbackMenu()
        coordinator.start()
        addDependency(coordinator)
    }

    private func showPaymentPartner(info: ScanRetailResponse, price: String?) {
        let apiService = container.resolve(ApiService.self)!
        let userSessionStorage = container.resolve(UserSessionStorage.self)!

        let viewModel = QRPaymentViewModel(apiService: apiService, info: info, userSessionStorage: userSessionStorage)
        var module = coordinatorFactory.makePayPartner(viewModel: viewModel, price: price)
        module.openSuccessPayment = { [weak self] retail, price, cashback in
            self?.showSuccessPayment(retail: retail, price: price, cashback: cashback)
        }
        module.closeButton = { [weak self] in
            self?.router.popModule()
        }
        router.push(module)
    }

    private func showSuccessPayment(retail: Retail, price: Int, cashback: Int) {
        var module = coordinatorFactory.makeSuccessPayment(retail: retail, price: price, cashback: cashback)
        module.nextTapped = { [weak self] in
            self?.router.popToRootModule()
        }
        router.push(module)
    }

    private func startDeliveryFlow() {
        let coordinator = coordinatorFactory.makeDeliveryTabBar()
        coordinator.start()
        addDependency(coordinator)
    }

    @objc func showListNotify() {
        showNotificationList()
    }
    
    private func showNotificationList() {
        var module = coordinatorFactory.makeNotificationList()
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
        var module = coordinatorFactory.pillikanInfoNotifications()
        module.closeButton = { [weak self] in
            self?.router.popModule()
        }
        router.push(module)
    }

    private func showNotificationPillikanPay() {
        var module = coordinatorFactory.pillikanPayNotifications()
        module.closeButton = { [weak self] in
            self?.router.popModule()
        }
        router.push(module)
    }
}
