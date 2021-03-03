import Swinject

protocol AuthCheckCoordinator: BaseCoordinator {}

extension AuthCheckCoordinator {
    func checkAuth(onAuth: (() -> Void)?) {
        let authservice = container.resolve(AuthenticationService.self)!
        authservice.updateToken(with: nil)
        guard authservice.token == nil else {
            onAuth?()
            return
        }
        let authCoordinator = AuthCoordinator(container: container, router: router)
        authCoordinator.onCompletion = { [weak self, weak authCoordinator] auth in
            if auth {
                self?.removeDependency(authCoordinator)
                onAuth?()
            }
        }
        addDependency(authCoordinator)
        authCoordinator.start()
    }
}
