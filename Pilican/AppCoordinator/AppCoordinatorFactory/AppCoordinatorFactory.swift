import Swinject

final class AppCoordinatorFactory {
    private let container: DependencyContainer
    private let router: Router

    init(container: DependencyContainer, router: Router) {
        self.container = container
        self.router = router
    }

    func makeAuthCoordinator() -> Coordinator {
        AuthCoordinator(container: container, router: router)
    }
}
