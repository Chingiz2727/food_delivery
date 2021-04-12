import CoreLocation

final class RetailListMapModuleFactory {

    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func makeMapModule() -> RetailListMapModule {
        let locationManager = container.resolve(CLLocationManager.self)!
        let apiService = container.resolve(ApiService.self)!
        let viewModel = RetailListMapViewModel(apiService: apiService)
        return RetailListMapViewController(mapManager: container.resolve(MapManager.self)!, locationManager: locationManager, viewModel: viewModel)
    }
}
