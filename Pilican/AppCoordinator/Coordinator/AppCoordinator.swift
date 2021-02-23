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
                    self?.startHomeFlow()
                } else {
                    self?.startAuthFlow()
                }
            }).disposed(by: disposeBag)
    }

    private func startAuthFlow() {
        var coordinator = appCoordinatorFactory.makeAuthCoordinator()

        coordinator.onFlowDidFinish = { [weak self] in
            self?.removeDependency(coordinator)
            self?.startHomeFlow()
        }

        coordinator.start()
        addDependency(coordinator)
    }

    private func startHomeFlow() {
        let coordinator = appCoordinatorFactory.homeCoordinator()
        coordinator.start()
        addDependency(coordinator)
    }
}
