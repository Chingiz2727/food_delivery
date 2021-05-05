final class ProfileMenuModuleFactory {
    private let container: DependencyContainer

    init(container: DependencyContainer) {
        self.container = container
    }

    func makeMenu() -> ProfileMenuModule {
        return ProfileMenuViewController()
    }
    
    func makeMyCards() -> MyCardsModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = MyCardsViewModel(apiService: apiService)
        return MyCardsViewController(viewModel: viewModel)
    }

    func makeMyQR() -> MyQRModule {
        return MyQRViewController()
    }

    func makeChangePassword() -> ChangePasswordModule {
        let apiService = container.resolve(ApiService.self)!
        let userInfoStorage = container.resolve(UserInfoStorage.self)!
        let viewModel = ChangePasswordViewModel(apiService: apiService)
        let viewController = ChangePasswordViewController(viewModel: viewModel, userInfoStorage: userInfoStorage)
        return viewController
    }

    func makeChangePin() -> CreatePinModule {
        let userSession = container.resolve(UserSessionStorage.self)!
        let pushManager = container.resolve(PushNotificationManager.self)!
        return CreatePinViewController(userSession: userSession, pushManager: pushManager)
    }

    func makeAbout() -> AboutModule {
        return AboutViewController()
    }

    func makeAcceptPermission() -> AcceptPermissionModule {
        let viewController = AcceptPermissionViewController()
        return viewController
    }

    func makeAccount() -> AccountModule {
        let userInfoStorage = container.resolve(UserInfoStorage.self)!
        return AccountViewController(userInfoStorage: userInfoStorage)
    }

    func makeEditAccount() -> EditAccountModule {
        let apiService = container.resolve(ApiService.self)!
        let userInfoStorage = container.resolve(UserInfoStorage.self)!
        let viewModel = EditAccountViewModel(apiService: apiService, userInfoStorage: userInfoStorage)
        let dateFormatter = container.resolve(PropertyFormatter.self)!
        let viewController = EditAccountViewController(viewModel: viewModel, dateFormatter: dateFormatter, userInfoStorage: userInfoStorage)
        return viewController
    }

    func makeBonus() -> BonusModule {
        return BonusViewController()
    }
}
