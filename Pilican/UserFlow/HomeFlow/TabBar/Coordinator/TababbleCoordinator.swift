protocol TababbleCoordinator: BaseCoordinator {
    var onTabBarItemNeedsToBeChanged: ((_ toTabBarItem: DeliveryTabBarItem) -> Void)? { get set }
}
