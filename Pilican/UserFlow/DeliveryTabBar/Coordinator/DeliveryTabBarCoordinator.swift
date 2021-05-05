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
                self?.router.push(self?.showStatus(orderId: retail))
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
    
    private func showStatus(orderId: Int) -> OrderStatusModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = OrderStatusViewModel(apiService: apiService, orderId: orderId)
        let status = OrderStatusViewController(viewModel: viewModel)
        status.orderSend = { [weak self] order in
            self?.router.push(self?.makeRateDelivery(order: order))
        }
        return status
    }
    
    func makeRateDelivery(order: DeliveryOrderResponse) -> RateDeliveryModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = CreateOrderRatingsViewModel(apiService: apiService, order: order)
        let controller = RateDeliveryViewController(order: order, viewModel: viewModel)
        controller.rateDeliveryTapped = { [weak self] order in
            self?.router.push(self?.makeRateMeal(order: order))
        }
        return controller
    }

    func makeRateMeal(order: DeliveryOrderResponse) -> RateMealModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = RateMealViewModel(apiService: apiService, order: order)
        let controller = RateMealViewController(order: order, viewModel: viewModel)
        controller.rateMealTapped = { [weak self] in
            self?.router.popToRootModule()
        }
        return controller
    }
}
