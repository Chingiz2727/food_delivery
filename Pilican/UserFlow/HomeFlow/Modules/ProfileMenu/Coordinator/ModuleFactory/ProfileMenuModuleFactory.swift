final class ProfileMenuModuleFactory {
    private let container: DependencyContainer

    init(container: DependencyContainer) {
        self.container = container
    }

    func makeMenu() -> ProfileMenuModule {
        return ProfileMenuViewController()
    }

    func makeChangePin() -> ChangePinModule {
        return ChangePinViewController()
    }
}
