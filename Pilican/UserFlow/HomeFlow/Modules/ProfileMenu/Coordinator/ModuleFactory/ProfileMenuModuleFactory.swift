final class ProfileMenuModuleFactory {
    private let container: DependencyContainer

    init(container: DependencyContainer) {
        self.container = container
    }

    func makeMenu() -> ProfileMenuModule {
        return ProfileMenuViewController()
    }

    func makeChangePassword() -> ChangePasswordModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = ChangePasswordViewModel(apiService: apiService)
        let viewController = ChangePasswordViewController(viewModel: viewModel)
        return viewController
    }
}
