
public final class AuthStateObserver {
    private let userSession: UserInfoStorage
    private let appSession: UserSessionStorage
    private weak var coordinator: BaseCoordinator?

    public init(userSession: UserInfoStorage, appSession: UserSessionStorage) {
        self.userSession = userSession
        self.appSession = appSession
    }

    public func tokenDidExpire() {
        forceLogout()
    }

    public func forceLogout() {
        configureUserSession()
        configureApplicationCoordinator()
        configureUserRepository()
    }

    public func setCoordinator(_ coordinator: BaseCoordinator?) {
        self.coordinator = coordinator
    }

    private func configureUserSession() {
        appSession.clearAll()
    }
    
    private func configureUserRepository() {
        userSession.clearAll()
    }

    private func configureApplicationCoordinator() {
        coordinator?.clearChildCoordinators()
        coordinator?.router.dismissModule()
        coordinator?.start()
    }
}
