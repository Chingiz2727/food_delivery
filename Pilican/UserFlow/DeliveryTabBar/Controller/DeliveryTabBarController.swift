import UIKit
enum DeliveryTabBarItem: Int {
    case delivery
    case search
    case basket
    case map
    case home
}

protocol DeliveryTabBarItemCoordinator: BaseCoordinator {
    var onTabBarItemNeedsToBeChanged: ((_ toTabBarItem: DeliveryTabBarItem) -> Void)? { get set }
}

protocol DeliveryTabBarPresentable {
    func setViewControllers(_ viewControllers: [UIViewController])
    func changeSelectedTabBarItem(_ tabBarItem: DeliveryTabBarItem, completion: Callback?)
}

final class DeliveryTabBarController: UITabBarController, DeliveryTabBarPresentable {
    func setViewControllers(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }
    
    func changeSelectedTabBarItem(_ tabBarItem: DeliveryTabBarItem, completion: Callback?) {
        guard let viewController = viewControllers?[tabBarItem.rawValue] else { return }
        selectedViewController = viewController
        completion?()
    }
}
