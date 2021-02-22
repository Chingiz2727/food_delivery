import Swinject

final class HomeCoordinator: BaseCoordinator, HomeTabBarCoordinatorOutput {
    func goToHomeWithDeeplink(action: DeepLinkAction) {
    }

    private let coordinatorFactory: HomeTabBarCoordinatorFactory
    private var tabRootContainers: [TabableRootControllerAndCoordinatorContainer] = []
    private let tabBarController: HomeTabBarViewController

    override init(router: Router, container: DependencyContainer) {
        coordinatorFactory = HomeTabBarCoordinatorFactory(container: container)
        tabBarController = HomeTabBarViewController()
        super.init(router: router, container: container)
    }

    override func start() {
        makeTabBar()
        let viewControllers = tabRootContainers.map { $0.viewController }
        tabBarController.setViewControllers(viewControllers)
        router.setRootModule(tabBarController, isNavigationBarHidden: true)
    }

    private func makeTabBar() {
        let (homeCoordinator, rootController) = coordinatorFactory.makeHome()
        homeCoordinator.start()
        addDependency(homeCoordinator)
        guard let controller = rootController.toPresent() else { return }
        tabRootContainers.append(.init(viewController: controller, coordinator: homeCoordinator))
    }
}
