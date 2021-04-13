import Swinject

protocol AuthCheckCoordinator: BaseCoordinator {}

extension AuthCheckCoordinator {
    func checkAuth(onAuth: (() -> Void)?) {
        let authservice = container.resolve(AuthenticationService.self)!
        let session = container.resolve(UserSessionStorage.self)!
        guard session.accessToken == nil else {
            onAuth?()
            print("My token", authservice.token)
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
