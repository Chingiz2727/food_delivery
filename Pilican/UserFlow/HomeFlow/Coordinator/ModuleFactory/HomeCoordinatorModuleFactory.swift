import Swinject

final class HomeCoordinatorModuleFactory {
    private let container: DependencyContainer

    init(container: DependencyContainer) {
        self.container = container
    }

    func makeHome() -> HomeModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = HomeViewModel(apiService: apiService)
        return HomeViewController(viewModel: viewModel)
    }
}
