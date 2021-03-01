import Swinject

final class HomeCoordinator: BaseCoordinator, HomeTabBarCoordinatorOutput {
    func goToHomeWithDeeplink(action: DeepLinkAction) {
    }

    private let coordinatorFactory: HomeTabBarCoordinatorFactory
    private var tabRootContainers: [TabableRootControllerAndCoordinatorContainer] = []
    private var tabBarController: HomeTabBarModule

    override init(router: Router, container: DependencyContainer) {
        coordinatorFactory = HomeTabBarCoordinatorFactory(container: container, router: router)
        tabBarController = HomeTabBarViewController()
        super.init(router: router, container: container)
    }

    override func start() {
        makeTabBar()

        tabBarController.qrCodeTap = { [weak self] in
            self?.showCamera()
        }

        tabBarController.accountTap = { [weak self] in
            self?.showProfileMenu()
        }

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

    private func showCamera() {
        let module = container.resolve(CameraModule.self)!
        router.push(module)
    }
    
    private func showProfileMenu() {
        let coordinator = coordinatorFactory.makeProfileMenu()
        coordinator.start()
        addDependency(coordinator)
    }
}
