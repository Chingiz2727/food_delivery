import Swinject

final class AppCoordinatorFactory {
    private let container: DependencyContainer
    private let router: Router

    init(container: DependencyContainer, router: Router) {
        self.container = container
        self.router = router
    }

    func makeAuthCoordinator() -> Coordinator & AuthCoordinatorOutput {
        AuthCoordinator(container: container, router: router)
    }

    func homeCoordinator() -> Coordinator {
        HomeCoordinator(router: router, container: container)
    }
}
