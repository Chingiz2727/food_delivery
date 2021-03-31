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
        let viewModel = HomeViewModel(apiService: apiService)
        return HomeViewController(viewModel: viewModel)
    }

    func makeRetailDetailCoordinator(retail: Retail) -> RetailDetailCoordinatorOutput {
        return RetailDetailCoordinator(router: router, container: container, retail: retail)
    }

    func makeCashbackList() -> CashBackListModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = CashBackListViewModel(apiService: apiService)
        return CashBackListViewController(viewModel: viewModel)
    }

    func delivery() -> DeliveryRetailListModule {
        let apiSevice = container.resolve(ApiService.self)!
        let viewModel = DeliveryRetailListViewModel(apiService: apiSevice)
        let controller = DeliveryRetailListViewController(viewModel: viewModel)
        return controller
    }
    
    func makeDeliveryProductList(retail: DeliveryRetail) -> DeliveryRetailProductsModule {
        let apiSerivce = container.resolve(ApiService.self)!
        let viewModel = DeliveryRetailProductViewModel(apiService: apiSerivce, retailInfo: retail)
        return DeliveryRetailProductsViewController(viewModel: viewModel)
    }
}
