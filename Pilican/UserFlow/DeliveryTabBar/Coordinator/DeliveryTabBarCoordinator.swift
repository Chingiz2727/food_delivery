import UIKit

struct TabableDeliveryControllerAndCoordinatorContainer {
    var viewController: UIViewController
    var coordinator: DeliveryTabBarItemCoordinator
}

final class DeliveryTabBarCoordinator: BaseCoordinator {
    
    private var tabRootContainers: [TabableDeliveryControllerAndCoordinatorContainer] = []
    private let tabBarController: DeliveryTabBarController
    private let coordinatorFactory: DeliveryTabBarCoordinatorFactory
    
    override init(router: Router, container: DependencyContainer) {
        
        let viewmModel = DeliveryTabBarViewModel(apiService: container.resolve(ApiService.self)!)
        tabBarController = DeliveryTabBarController(viewModel: viewmModel)
        coordinatorFactory = DeliveryTabBarCoordinatorFactory(container: container)
        super.init(router: router, container: container)
    }

    override func start() {
        setupAllFlows()
        let viewController = tabRootContainers.map { $0.viewController }
        tabBarController.setViewControllers(viewController)
        tabBarController.selectRetail = { [weak self] retail in
            if let retail = retail {
                self?.showStatus(response: retail)
            }
        }
        router.setRootModule(tabBarController, isNavigationBarHidden: true)
    }
    
    private func setupAllFlows() {
        setupDeliveryFlow()
        setupBasketFlow()
        setupSearchFlow()
        setupMapFlow()
        setupLogoutFLow()
    }

    private func setupBasketFlow() {
        let (coordinator, rootController) = coordinatorFactory.makeBasket()
        coordinator.start()
        addDependency(coordinator)
        guard let controller = rootController.toPresent() else { return }
        tabRootContainers.append(.init(viewController: controller, coordinator: coordinator))
    }

    private func setupDeliveryFlow() {
        let (coordinator, rooController) = coordinatorFactory.makeDeliveryCoordinator()
        coordinator.start()
        addDependency(coordinator)
        guard let controller = rooController.toPresent() else { return }
        tabRootContainers.append(.init(viewController: controller, coordinator: coordinator))
    }
    
    private func setupSearchFlow() {
        let (coordinator, rooController) = coordinatorFactory.makeSearchCoordinator()
        coordinator.start()
        addDependency(coordinator)
        guard let controller = rooController.toPresent() else { return }
        tabRootContainers.append(.init(viewController: controller, coordinator: coordinator))
    }

    private func setupMapFlow() {
        let (coordinator, rootController) = coordinatorFactory.makeMap()
        coordinator.start()
        addDependency(coordinator)
        guard let controller = rootController.toPresent() else {
            return
        }
        tabRootContainers.append(.init(viewController: controller, coordinator: coordinator))
    }
    
    private func setupLogoutFLow() {
        let (coordinator, rootController) = coordinatorFactory.makeLogout()
        coordinator.start()
        addDependency(coordinator)
        guard let controller = rootController.toPresent() else {
            return
        }
        tabRootContainers.append(.init(viewController: controller, coordinator: coordinator))
    }
    
    private func showStatus(response: DeliveryOrderResponse) {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = OrderStatusViewModel(apiService: apiService, orderResponse: response)
        let status = OrderStatusViewController(viewModel: viewModel)
        router.push(status)
    }
}
