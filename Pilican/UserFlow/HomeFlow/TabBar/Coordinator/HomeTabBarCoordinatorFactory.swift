final class HomeTabBarCoordinatorFactory {
    private let container: DependencyContainer
    private let router: Router

    init(container: DependencyContainer, router: Router) {
        self.container = container
        self.router = router
    }

    func makeHome() -> (coordinator: HomeTabBarCoordinatorOutput & TababbleCoordinator, module: Presentable) {
        let rootController = CoordinatorNavigationController(backBarButtonImage: Images.alarm.image, closeBarButtonImage: Images.back_black.image)
        let coordinator = HomeTabBarCoordinator(router: Router(rootController: rootController), container: container)
        return (coordinator, rootController)
    }

    func makeProfileMenu() -> ProfileMenuCoordinator {
        return ProfileMenuCoordinatorImpl(router: router, container: container)
    }

    func makeCashbbackMenu() -> CashbackMenuCoordinator {
        return CashbackMenuCoordinatorImpl(router: router, container: container)
    }

    func makePayPartner(viewModel: QRPaymentViewModel) -> QRPaymentModule {
        let userInfo = container.resolve(UserInfoStorage.self)!
        return QRPaymentViewController(viewModel: viewModel, userInfo: userInfo)
    }

    func makeSuccessPayment(retail: Retail, price: Int, cashback: Int) -> SuccessPaymentModule {
        return SuccessPaymentViewController(retail: retail, price: price, cashback: cashback)
    }

    func makeDeliveryTabBar() -> Coordinator {
        return DeliveryTabBarCoordinator(router: router, container: container)
    }

    func makeNotificationList() -> NotificationListModule {
        return NotificationListController()
    }
    
    func pillikanInfoNotifications() -> PillikanInfoModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = PillikanInfoViewModel(apiService: apiService)
        return PillikanInfoNotificationsViewController(viewModel: viewModel)
    }
    
    func pillikanPayNotifications() -> PillikanPayModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = PillikanPayViewModel(apiService: apiService)
        return PillikanPayViewController(viewModel: viewModel)
    }
    
    func makeHowItWork() -> HowItWorkModule {
        return  HowItWorkViewController()
    }
}
