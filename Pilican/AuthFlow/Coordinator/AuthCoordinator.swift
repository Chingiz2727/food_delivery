import Swinject

final class AuthCoordinator: BaseCoordinator {

    private let moduleFactory: AuthModuleFactory
    init(container: DependencyContainer, router: Router) {
        self.moduleFactory = AuthModuleFactory(container: container)
        super.init(router: router, container: container)
    }

    override func start() {
        showAuth()
    }

    private func showAuth() {
        var module = moduleFactory.makeAuthUserName()
        module.registerButtonTapped = { [weak self] in
            self?.showRegistration()
        }

        module.authBySms = { [weak self] in
            self?.showAuthBySms()
        }
        router.setRootModule(module)
    }

    private func showAuthBySms() {
        let module = moduleFactory.makeAuthBySms()
        router.push(module)
    }

    private func showRegistration() {
        var module = moduleFactory.makeRegistration()
        module.qrScanTapped = { [weak self] in
            self?.showCamera(qrScanned: { promoCode in
                module.putPromoCodeToText?(promoCode)
            })
        }
        router.push(module)
    }

    private func showCamera(qrScanned: @escaping((String) -> Void)) {
        var module = container.resolve(CameraModule.self)!
        module.cameraActionType = .readPromoCode
        module.promoCodeScanned = { [weak self] promoCode in
            self?.router.popModule()
            qrScanned(promoCode)
        }
        router.push(module)
    }
}
