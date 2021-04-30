public final class DeliveryLogoutStateObserver {
    private weak var coordinator: BaseCoordinator?
    
    public func forceLogout() {
        configureApplicationCoordinator()
    }

    public func setCoordinator(_ coordinator: BaseCoordinator?) {
        self.coordinator = coordinator
    }

    private func configureApplicationCoordinator() {
        coordinator?.clearChildCoordinators()
        coordinator?.router.dismissModule()
        coordinator?.start()
    }
}
