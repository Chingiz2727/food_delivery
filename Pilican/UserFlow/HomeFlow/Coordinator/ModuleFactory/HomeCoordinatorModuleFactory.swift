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
    
    func makeHowItWork() -> HowItWorkModule {
        return HowItWorkViewController()
    }
    
    func makePayPartner(viewModel: QRPaymentViewModel) -> QRPaymentModule {
        let userInfo = container.resolve(UserInfoStorage.self)!
        return QRPaymentViewController(viewModel: viewModel, userInfo: userInfo)
    }

    func makeSuccessPayment(retail: Retail, price: Int, cashback: Int) -> SuccessPaymentModule {
        return SuccessPaymentViewController(retail: retail, price: price, cashback: cashback)
    }
    
    func makeMyQR() -> MyQRModule {
        let userInfo = container.resolve(UserInfoStorage.self)!
        return MyQRViewController(userInfo: userInfo)
    }
}
