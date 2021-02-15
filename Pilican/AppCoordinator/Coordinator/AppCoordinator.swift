final class AppCoordinator: BaseCoordinator {
    private let appCoordinatorFactory: AppCoordinatorFactory

    init(router: AppRouter, container: DependencyContainer) {
        appCoordinatorFactory = AppCoordinatorFactory(container: container, router: router)
        super.init(assembler: container, router: router)
    }

    override func start() {
        startAuthFlow()
    }

    private func startAuthFlow() {
        let coordinator = appCoordinatorFactory.makeAuthCoordinator()
        addDependency(coordinator)
        coordinator.start()
    }
}
