public protocol AuthCoordinatorOutput {
    typealias OnFlowDidFinish = () -> Void

    var onFlowDidFinish: OnFlowDidFinish? { get set }
}

final class AuthCoordinator: BaseCoordinator, AuthCoordinatorOutput {
    var onFlowDidFinish: OnFlowDidFinish?

    private let moduleFactory: AuthModuleFactory
    private let container: DependencyContainer

    init(container: DependencyContainer, router: AppRouter) {
        self.moduleFactory = AuthModuleFactory(container: container)
        self.container = container
        super.init(assembler: container, router: router)
    }

    override func start() {
//        showAuth()
        showRegistration()
    }

    private func showAuth() {
        var module = moduleFactory.makeAuthUserName()
        module.authButtonTapped = { [weak self] in
            self?.showRegistration()
        }
        router.setRootModule(module)
    }

    private func showRegistration() {
        var module = moduleFactory.makeRegistration()
        module.qrScanTapped = { [weak self] in
            print("scanme")
        }
        router.setRootModule(module)
//        router.push(module.withBackDismissButton())
    }

    private func showCamera() {
        var module = container.resolve(CameraModule.self)!
        module.cameraActionType = .readPromoCode
        router.push(module)
    }
}
