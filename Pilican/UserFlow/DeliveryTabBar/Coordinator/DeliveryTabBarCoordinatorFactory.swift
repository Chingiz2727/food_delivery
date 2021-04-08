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
    
    func makeSearchCoordinator() -> (coordinator: SearchCoordinatorOutput, module: Presentable) {
        let rootController = CoordinatorNavigationController(backBarButtonImage: nil)
        rootController.navigationBar.isHidden = true
        rootController.tabBarItem.image = Images.searchDelivery.image?.withRenderingMode(.alwaysOriginal)
        rootController.tabBarItem.selectedImage = Images.SearchSelected.image?.withRenderingMode(.alwaysOriginal)
        let coordinator = SearchCoordinator(router: Router(rootController: rootController), container: container)
    }
    
    func makeBasket() -> (coordinator: DeliveryTabBarItemCoordinator, module: Presentable) {
        let rootController = CoordinatorNavigationController(backBarButtonImage: nil)
        rootController.tabBarItem.image = Images.basket.image?.withRenderingMode(.alwaysOriginal)
        rootController.tabBarItem.selectedImage = Images.basketSelected.image?.withRenderingMode(.alwaysOriginal)
        let coordinator = OrderTypeCoordinator(router: Router(rootController: rootController), container: container)
        return (coordinator, rootController)
    }
}
