import UIKit

final class DeliveryCoordinatorModuleFactory {
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func delivery() -> DeliveryRetailListModule {
        let apiSevice = container.resolve(ApiService.self)!
        let viewModel = DeliveryRetailListViewModel(apiService: apiSevice)
        let controller = DeliveryRetailListViewController(viewModel: viewModel)
        return controller
    }
    
    func deliveryProduct(retail: DeliveryRetail) -> DeliveryRetailProductsModule {
        let apiSevice = container.resolve(ApiService.self)!
        let dishList = container.resolve(DishList.self)!
        let viewModel = DeliveryRetailProductViewModel(apiService: apiSevice, retailInfo: retail, dishList: dishList)
        let controller = DeliveryRetailProductsViewController(viewModel: viewModel)
        return controller
    }
    
}
