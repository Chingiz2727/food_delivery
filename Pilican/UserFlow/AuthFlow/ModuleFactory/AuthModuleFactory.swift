import Swinject

final class AuthModuleFactory {
    private let container: DependencyContainer

    init(container: DependencyContainer) {
        self.container = container
    }

    func makeAuthUserName() -> AuthModule {
        let authService = container.resolve(AuthenticationService.self)!
        let viewModel = AuthViewModel(authService: authService)
        let viewController = AuthViewController(viewModel: viewModel, sessionStorage: container.resolve(UserSessionStorage.self)!)
        return viewController
    }

    func makeAuthBySms() -> AuthBySmsModule {
        let authService = container.resolve(AuthenticationService.self)!

        let viewModel = AuthBySmsViewModel(authService: authService)
        let viewController = AuthBySmsViewController(viewModel: viewModel, sessionStorage: container.resolve(UserSessionStorage.self)!)
        return viewController
    }

    func makeRegistration() -> RegisterModule {
        let authService = container.resolve(AuthenticationService.self)!
        let viewModel = RegistrationViewModel(authService: authService)
        let viewControllerr = RegisterViewController(viewModel: viewModel, sessionStorage: container.resolve(UserSessionStorage.self)!)
        return viewControllerr
    }

    func makeAcceptPermission() -> AcceptPermissionModule {
        let viewController = AcceptPermissionViewController()
        return viewController
    }
    
    func makeHowItWork() -> HowItWorkModule {
        return HowItWorkViewController()
    }
}
