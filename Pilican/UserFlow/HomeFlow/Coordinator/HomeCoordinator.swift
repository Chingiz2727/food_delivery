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
            self?.showCamera()
        }

        tabBarController.accountTap = { [weak self] in
            self?.showProfileMenu()
        }


        tabBarController.bonusTap = { [weak self] in
            self?.showCashbackMenu()
        }

        tabBarController.notifyMenuTap = { [weak self] in
            self?.showNotificationList()
        }
        
        tabBarController.backTap = { [weak self] in
            self?.router.popModule()
        }
        
        let logoutFlow = container.resolve(DeliveryLogoutStateObserver.self)!
        logoutFlow.setCoordinator(self)
        let viewControllers = tabRootContainers.map { $0.viewController }
        tabBarController.setViewControllers(viewControllers)
        router.setRootModule(tabBarController, isNavigationBarHidden: true)
        NotificationCenter.default.addObserver(self, selector: #selector(showNotificationList), name: NSNotification.Name(NotificationsString.openNotifications.rawValue), object: nil)
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
            self?.showCamera()
        }
        homeCoordinator.onDeliveryTab = { [weak self] in
            self?.startDeliveryFlow()
        }

        tabRootContainers.append(.init(viewController: controller, coordinator: homeCoordinator))
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
        module.retailTapped = { [weak self] retail in
            self?.showPaymentPartner(info: .init(orderId: 0, fullName: "", type: 0, retail: retail))
        }
        module.retailIdTapped = { [weak self] retail in
            self?.showPaymentPartner(info: .init(orderId: 0, fullName: "", type: 0, retail: retail))
        }
        router.push(module)
    }

    private func showHowItWork() {
        let module = coordinatorFactory.makeHowItWork()
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

    private func showPaymentPartner(info: ScanRetailResponse) {
        let apiService = container.resolve(ApiService.self)!
        let userSessionStorage = container.resolve(UserSessionStorage.self)!

        let viewModel = QRPaymentViewModel(apiService: apiService, info: info, userSessionStorage: userSessionStorage)
        var module = coordinatorFactory.makePayPartner(viewModel: viewModel)
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

    @objc private func showNotificationList() {
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
