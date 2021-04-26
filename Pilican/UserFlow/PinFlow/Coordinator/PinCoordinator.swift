protocol PinCoordinatorOutput: BaseCoordinator {
    typealias PinCompletion = (Bool) -> Void
    var onCompletion: PinCompletion? { get set }
}

final class PinCoordinator: BaseCoordinator, PinCoordinatorOutput {
    var onCompletion: PinCompletion?
    
    private let moduleFactory: PinModuleFactory
    private let authState: AuthStateObserver
    override init(router: Router, container: DependencyContainer) {
        moduleFactory = PinModuleFactory(container: container)
        authState = container.resolve(AuthStateObserver.self)!
        super.init(router: router, container: container)
    }
    
    override func start() {
        checkPinRequired()
    }
    
    private func checkPinRequired() {
        let userSession = container.resolve(UserSessionStorage.self)!
        if userSession.pin != nil {
            showPinCheck()
        } else {
            showPinCreate()
        }
    }
    
    private func showPinCheck() {
        var module = moduleFactory.makePinCheck()
        module.onPinSatisfy = { [weak self] in
            self?.onCompletion?(true)
        }
        module.onResetTapp = { [weak self] in
            self?.authState.forceLogout()
        }
        router.push(module)
    }

    private func showPinCreate() {
        var module = moduleFactory.makeCreatePin()
        module.onCodeValidate = { [weak self] in
            self?.router.dismissModule()
            self?.onCompletion?(true)
        }
        router.push(module)
    }
}
