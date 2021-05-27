import Swinject

final class HomeCoordinatorModuleFactory {
    private let container: DependencyContainer
    private let router: Router

    init(container: DependencyContainer, router: Router) {
        self.container = container
        self.router = router
    }

    func makeHome() -> HomeModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = HomeViewModel(apiService: apiService, appSession: container.resolve(AppSessionManager.self)!)
        return HomeViewController(viewModel: viewModel)
    }

    func makeRetailDetailCoordinator(retail: Retail) -> RetailDetailCoordinatorOutput {
        return RetailDetailCoordinator(router: router, container: container, retail: retail)
    }

    func makeCashbackList() -> CashBackListModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = CashBackListViewModel(apiService: apiService)
        return CashBackListViewController(viewModel: viewModel, favouriteManager: container.resolve(FavouritesManager.self)!)
    }
    
    func makeHowItWork(workType: WorkType) -> HowItWorkModule {
        return HowItWorkViewController(workType: workType)
    }
    
    func makePayPartner(viewModel: QRPaymentViewModel, price: String?) -> QRPaymentModule {
        let userInfo = container.resolve(UserInfoStorage.self)!
        return QRPaymentViewController(viewModel: viewModel, userInfo: userInfo, textPrice: price)
    }

    func makeSuccessPayment(retail: Retail, price: Int, cashback: Int) -> SuccessPaymentModule {
        return SuccessPaymentViewController(retail: retail, price: price, cashback: cashback)
    }
    
    func makeMyQR() -> BonusModule {
        let userInfo = container.resolve(UserInfoStorage.self)!
        return BonusViewController(userInfo: userInfo)
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
}
