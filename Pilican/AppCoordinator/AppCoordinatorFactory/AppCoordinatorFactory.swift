final class AppCoordinatorFactory {
    private let container: DependencyContainer
    private let router: AppRouter

    init(container: DependencyContainer, router: AppRouter) {
        self.container = container
        self.router = router
    }

    func makeAuthCoordinator() -> Coordinator & AuthCoordinatorOutput {
        AuthCoordinator(container: container, router: router)
    }
}
