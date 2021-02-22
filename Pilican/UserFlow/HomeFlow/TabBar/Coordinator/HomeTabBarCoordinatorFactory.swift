final class HomeTabBarCoordinatorFactory {
    private let container: DependencyContainer

    init(container: DependencyContainer) {
        self.container = container
    }

    func makeHome() -> (coordinator: HomeTabBarCoordinatorOutput & TababbleCoordinator, module: Presentable) {
        let rootController = CoordinatorNavigationController(backBarButtonImage: Images.close.image)
        let coordinator = HomeTabBarCoordinator(router: Router(rootController: rootController), container: container)
        return (coordinator, rootController)
    }
}
