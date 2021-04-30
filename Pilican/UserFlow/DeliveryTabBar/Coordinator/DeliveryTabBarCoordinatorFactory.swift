import UIKit

final class DeliveryTabBarCoordinatorFactory {

    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func makeDeliveryCoordinator() -> (coordinator: DeliveryCoordinatorOutput, module: Presentable) {
        let rootController = CoordinatorNavigationController(backBarButtonImage: nil)
        rootController.navigationBar.isHidden = false
        rootController.tabBarItem.image = Images.homeDelivery.image?.withRenderingMode(.alwaysOriginal)
        rootController.tabBarItem.selectedImage = Images.homeDeliverySelected.image?.withRenderingMode(.alwaysOriginal)
        let coordinator = DeliveryCoordinator(router: Router(rootController: rootController), container: container)
        return (coordinator, rootController)
    }
    
    func makeSearchCoordinator() -> (coordinator: SearchCoordinatorOutput, module: Presentable) {
        let rootController = CoordinatorNavigationController(backBarButtonImage: nil)
        rootController.navigationBar.isHidden = true
        rootController.tabBarItem.image = Images.searchDelivery.image?.withRenderingMode(.alwaysOriginal)
        rootController.tabBarItem.selectedImage = Images.SearchSelected.image?.withRenderingMode(.alwaysOriginal)
        let coordinator = SearchCoordinator(router: Router(rootController: rootController), container: container)
        return (coordinator, rootController)
    }

    func makeBasket() -> (coordinator: DeliveryTabBarItemCoordinator, module: Presentable) {
        let rootController = CoordinatorNavigationController(backBarButtonImage: nil)
        rootController.tabBarItem.image = Images.basket.image?.withRenderingMode(.alwaysOriginal)
        rootController.tabBarItem.selectedImage = Images.basketSelected.image?.withRenderingMode(.alwaysOriginal)
        let coordinator = OrderTypeCoordinator(router: Router(rootController: rootController), container: container)
        return (coordinator, rootController)
    }
    
    func makeMap() -> (coordinator: RetailListMapCoordinator, module: Presentable) {
        let rootController = CoordinatorNavigationController(backBarButtonImage: nil)
        rootController.tabBarItem.image = Images.Location.image?.withRenderingMode(.alwaysOriginal)
        rootController.tabBarItem.selectedImage = Images.LocationSelected.image?.withRenderingMode(.alwaysOriginal)
        let coordinator = RetailListMapCoordinator(router: Router(rootController: rootController), container: container)
        return (coordinator, rootController)
    }

    func makeLogout() -> (coordinator: LogoutCoordinatorOutput, module: Presentable) {
        let rootController = CoordinatorNavigationController(backBarButtonImage: nil)
        rootController.tabBarItem.image = Images.HomePillikanSelected.image?.withRenderingMode(.alwaysOriginal)
        rootController.tabBarItem.selectedImage = Images.HomePillikanSelected.image?.withRenderingMode(.alwaysOriginal)
        let coordinator = LogoutCoordinator(router: Router(rootController: rootController), container: container)
        return (coordinator, rootController)
    }
}
