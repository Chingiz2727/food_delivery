final class HomeTabBarCoordinatorFactory {
    private let container: DependencyContainer
    private let router: Router

    init(container: DependencyContainer, router: Router) {
        self.container = container
        self.router = router
    }

    func makeHome() -> (coordinator: HomeTabBarCoordinatorOutput & TababbleCoordinator, module: Presentable) {
        let rootController = CoordinatorNavigationController(backBarButtonImage: Images.alarm.image)
        let coordinator = HomeTabBarCoordinator(router: Router(rootController: rootController), container: container)
        return (coordinator, rootController)
    }

    func makeProfileMenu() -> ProfileMenuCoordinator {
        return ProfileMenuCoordinatorImpl(router: router, container: container)
    }

    func makeCashbbackMenu() -> CashbackMenuCoordinator {
        return CashbackMenuCoordinatorImpl(router: router, container: container)
    }

    func makePayPartner(viewModel: QRPaymentViewModel) -> QRPaymentModule {
        return QRPaymentViewController(viewModel: viewModel)
    }

    func makeSuccessPayment(retail: Retail, price: Int, cashback: Int) -> SuccessPaymentModule {
        return SuccessPaymentViewController(retail: retail, price: price, cashback: cashback)
    }
    
    func makeDeliveryTabBar() -> Coordinator {
        return DeliveryTabBarCoordinator(router: router, container: container)
    }
}
