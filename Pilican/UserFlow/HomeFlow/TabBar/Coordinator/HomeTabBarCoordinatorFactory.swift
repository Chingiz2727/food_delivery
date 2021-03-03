final class HomeTabBarCoordinatorFactory {
    private let container: DependencyContainer
    private let router: Router

    init(container: DependencyContainer, router: Router) {
        self.container = container
        self.router = router
    }

    func makeHome() -> (coordinator: HomeTabBarCoordinatorOutput & TababbleCoordinator, module: Presentable) {
        let rootController = CoordinatorNavigationController(backBarButtonImage: Images.close.image)
        let coordinator = HomeTabBarCoordinator(router: Router(rootController: rootController), container: container)
        return (coordinator, rootController)
    }

    func makeProfileMenu() -> ProfileMenuCoordinator {
        return ProfileMenuCoordinatorImpl(router: router, container: container)
    }
    
    func makeCashbbackMenu() -> CashbackMenuCoordinator {
        return CashbackMenuCoordinatorImpl(router: router, container: container)
    }
}
