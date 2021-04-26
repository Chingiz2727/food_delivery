import Swinject

protocol AuthCheckCoordinator: BaseCoordinator {}

extension AuthCheckCoordinator {
    func checkAuth(onAuth: (() -> Void)?) {
        let apiservice = container.resolve(AuthenticationService.self)!

        let session = container.resolve(UserSessionStorage.self)!
        guard session.accessToken == nil else {
            startPinCheck(onAuth: onAuth)
            return
        }
        let authCoordinator = AuthCoordinator(container: container, router: router)
        authCoordinator.onCompletion = { [weak self, weak authCoordinator] auth in
            if auth {
                self?.removeDependency(authCoordinator)
                self?.startPinCheck(onAuth: onAuth)
            }
        }
        addDependency(authCoordinator)
        authCoordinator.start()
    }
    
    func startPinCheck(onAuth: (() -> Void)?) {
        let pinCoordinator = PinCoordinator(router: router, container: container)
        pinCoordinator.onCompletion = { [weak self, weak pinCoordinator] auth in
            if auth {
                self?.removeDependency(pinCoordinator)
                onAuth?()
            }
        }
        addDependency(pinCoordinator)
        pinCoordinator.start()
    }
}
