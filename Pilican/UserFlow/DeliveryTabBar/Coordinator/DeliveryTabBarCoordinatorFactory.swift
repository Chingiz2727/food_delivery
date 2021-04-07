import UIKit

final class DeliveryTabBarCoordinatorFactory {

    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func makeDeliveryCoordinator() -> (coordinator: DeliveryCoordinatorOutput, module: Presentable) {
        let rootController = CoordinatorNavigationController(backBarButtonImage: nil)
        rootController.navigationBar.isHidden = false
        let coordinator = DeliveryCoordinator(router: Router(rootController: rootController), container: container)
        return (coordinator, rootController)
    }
}
