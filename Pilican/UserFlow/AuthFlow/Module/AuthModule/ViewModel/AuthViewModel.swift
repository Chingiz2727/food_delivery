import RxSwift

final class AuthViewModel: ViewModel {

    struct Input {
        let signInTapped: Observable<Void>
        let userPhone: Observable<String>
        let userPassword: Observable<String?>
    }

    struct Output {
        let isLogged: Observable<LoadingSequence<UserAuthResponse>>
    }

    private let authService: AuthenticationService

    init(authService: AuthenticationService) {
        self.authService = authService
    }

    func transform(input: Input) -> Output {
        let loginTap = input.signInTapped
            .withLatestFrom(Observable.combineLatest(input.userPhone, input.userPassword))
            .flatMap { [unowned self] phone, password in
                return authService.login(phone: phone, password: password ?? "")
            }.share()
        return .init(isLogged: loginTap)
    }
}
