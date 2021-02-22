import RxSwift

final class AuthBySmsViewModel: ViewModel {
    struct Input {
        let getSmsTapped: Observable<Void>
        let authTapped: Observable<Void>
        let userLogin: Observable<String>
        let userSmsCode: Observable<String>
    }

    struct Output {
        let getSmsTapped: Observable<LoadingSequence<ResponseStatus>>
        let loginTapped: Observable<LoadingSequence<UserAuthResponse>>
    }

    private let authService: AuthenticationService

    init(authService: AuthenticationService) {
        self.authService = authService
    }

    func transform(input: Input) -> Output {
        let getSms = input.getSmsTapped
            .withLatestFrom(input.userLogin)
            .flatMap { [unowned self] phone in
                return authService.getAuthSmsCode(phone)
            }

        let login = input.authTapped
            .withLatestFrom(Observable.combineLatest(input.userLogin, input.userSmsCode))
            .flatMap { [unowned self] phone, code in
                return authService.verifySmsCode(phone, code: code)
            }
        return .init(getSmsTapped: getSms, loginTapped: login)
    }
}
