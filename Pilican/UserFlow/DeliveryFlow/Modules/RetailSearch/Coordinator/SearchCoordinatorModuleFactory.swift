final class SearchCoordinatorFactory {
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func showSearchModule() -> RetailSearchModule {
        return RetailSearchViewController()
    }
    
    func showSearchItemModule() -> ItemSearchModule {
        let serivce = container.resolve(ApiService.self)!
        let viewModel = ItemSearchViewMoodel(apiService: serivce)
        return ItemSearchViewController(viewModel: viewModel)
    }
    
    func deliveryProduct(retail: DeliveryRetail) -> DeliveryRetailProductsModule {
        let apiSevice = container.resolve(ApiService.self)!
        let dishList = container.resolve(DishList.self)!
        let viewModel = DeliveryRetailProductViewModel(apiService: apiSevice, retailInfo: retail, dishList: dishList)
        let controller = DeliveryRetailProductsViewController(viewModel: viewModel)
        return controller
    }
}
