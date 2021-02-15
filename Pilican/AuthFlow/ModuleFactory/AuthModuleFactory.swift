final class AuthModuleFactory {
    private let container: DependencyContainer

    init(container: DependencyContainer) {
        self.container = container
    }

    func makeAuthUserName() -> AuthModule {
        let apiService = container.resolve(ApiService.self)!
        let configService = container.resolve(ConfigService.self)!
        let tokenService = container.resolve(AuthTokenService.self)!
        let authService = AuthenticationServiceImpl(
            apiService: apiService,
            configService: configService,
            authTokenService: tokenService
        )
        let viewModel = AuthViewModel(authService: authService)
        let viewController = AuthViewController(viewModel: viewModel)
        return viewController
    }

    func makeRegistration() -> RegisterModule {
        let apiService = container.resolve(ApiService.self)!
        let configService = container.resolve(ConfigService.self)!
        let tokenService = container.resolve(AuthTokenService.self)!
        let authService = AuthenticationServiceImpl(
            apiService: apiService,
            configService: configService,
            authTokenService: tokenService
        )
        let viewModel = RegistrationViewModel(authService: authService)
        let viewControllerr = RegisterViewController(viewModel: viewModel)
        return viewControllerr
    }
}
