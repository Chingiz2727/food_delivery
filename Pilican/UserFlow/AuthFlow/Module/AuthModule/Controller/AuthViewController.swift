import RxSwift
import UIKit

final class AuthViewController: ViewController, AuthModule, ViewHolder {

    typealias RootViewType = AuthView

    var authButtonTapped: AuthButtonTapped?
    var authBySms: AuthBySms?
    var registerButtonTapped: RegisterButtonTapped?

    private let viewModel: AuthViewModel
    private let disposeBag = DisposeBag()
    private let sessionStorage: UserSessionStorage
    
    init(viewModel: AuthViewModel, sessionStorage: UserSessionStorage) {
        self.viewModel = viewModel
        self.sessionStorage = sessionStorage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func loadView() {
        view = AuthView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        print(AppEnviroment.appVersion)
    }

    private func bindViewModel() {
        let output = viewModel.transform(
            input: .init(
                signInTapped: rootView.signInButton.rx.tap.asObservable(),
                userPhone: rootView.phoneContainer.textField.phoneText.asObservable(),
                userPassword: rootView.passwordContainer.textField.rx.text.asObservable())
        )

        rootView.authBySmsButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.authBySms?()
            })
            .disposed(by: disposeBag)

        rootView.registerButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.registerButtonTapped?()
            })
            .disposed(by: disposeBag)

        let result = output.isLogged.publish()

        result.element
            .subscribe(onNext: { [unowned self] result in
                self.sessionStorage.accessToken = result.token.accessToken
                self.sessionStorage.refreshToken = result.token.refreshToken
                self.authButtonTapped?()
            })
            .disposed(by: disposeBag)

        result.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        result.connect()
            .disposed(by: disposeBag)

        result.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)
    }
}
