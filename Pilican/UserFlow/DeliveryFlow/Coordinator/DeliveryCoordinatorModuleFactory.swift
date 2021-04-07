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
}
