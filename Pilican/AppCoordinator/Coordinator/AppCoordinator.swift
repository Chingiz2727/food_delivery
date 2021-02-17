import Swinject
import RxSwift

final class AppCoordinator: BaseCoordinator {
    private let appCoordinatorFactory: AppCoordinatorFactory
    private var authCoordinator: AuthCoordinator?
    private let authService: AuthenticationService
    private let disposeBag = DisposeBag()

    override init(router: Router, container: DependencyContainer) {
        appCoordinatorFactory = AppCoordinatorFactory(container: container, router: router)
        let authService = container.resolve(AuthenticationService.self)!
        self.authService = authService
        super.init(router: router, container: container)
    }

    override func start() {
        checkAuth()
    }

    private func checkAuth() {
        authService.authenticated
            .subscribe(onNext: { [weak self] authed in
                if authed {
                    
                } else {
                    self?.startAuthFlow()
                }
            }).disposed(by: disposeBag)
    }

    private func startAuthFlow() {
        let coordinator = AuthCoordinator(container: container, router: router)
        authCoordinator = coordinator
        coordinator.start()
        addDependency(coordinator)
    }
}
