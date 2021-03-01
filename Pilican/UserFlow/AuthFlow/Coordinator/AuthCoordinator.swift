import Swinject

public protocol AuthCoordinatorOutput {
    typealias AuthCompletion = (Bool) -> Void

    var onCompletion: AuthCompletion? { get set }
}

final class AuthCoordinator: BaseCoordinator, AuthCoordinatorOutput {

    var onCompletion: AuthCompletion?
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

        module.authButtonTapped = { [weak self] in
            self?.onCompletion?(true)
        }
        router.setRootModule(module)
    }

    private func showAuthBySms() {
        var module = moduleFactory.makeAuthBySms()
        module.onAuthDidFinish = { [weak self] in
            self?.onCompletion?(true)
        }
        router.push(module)
    }

    private func showRegistration() {
        var module = moduleFactory.makeRegistration()
        module.qrScanTapped = { [weak self] in
            self?.showCamera(qrScanned: { promoCode in
                module.putPromoCodeToText?(promoCode)
            })
        }

        module.registerTapped = { [weak self] in
            self?.onCompletion?(true)
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
