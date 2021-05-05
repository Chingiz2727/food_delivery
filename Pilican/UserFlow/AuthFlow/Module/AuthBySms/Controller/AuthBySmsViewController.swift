import RxSwift
import UIKit

class AuthBySmsViewController: ViewController, AuthBySmsModule, ViewHolder {
    typealias RootViewType = AuthBySmsView

    var onAuthDidFinish: Callback?
    var registerButtonTapped: RegisterButtonTapped?

    private let viewModel: AuthBySmsViewModel
    private let disposeBag = DisposeBag()
    let sessionStorage: UserSessionStorage
    
    init(viewModel: AuthBySmsViewModel, sessionStorage: UserSessionStorage) {
        self.viewModel = viewModel
        self.sessionStorage = sessionStorage
        super.init(nibName: nil, bundle: nil)
    }

    override func customBackButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func loadView() {
        view = AuthBySmsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindView()
    }

    private func bindViewModel() {
        let output = viewModel.transform(
            input: .init(
                getSmsTapped: rootView.getSmsButton.rx.tap.asObservable(),
                authTapped: rootView.signInButton.rx.tap.asObservable(),
                userLogin: rootView.phoneContainer.textField.phoneText,
                userSmsCode: rootView.passwordContainer.textField.rx.text.unwrap()))

        let result = output.getSmsTapped.publish()

        result.element
            .subscribe(onNext: {  [unowned self] _ in
                self.rootView.showPasswordContainer()
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

        let signInResult = output.loginTapped.publish()

        signInResult.element
            .subscribe(onNext: { [unowned self] result in
                self.sessionStorage.accessToken = result.token.accessToken
                self.sessionStorage.refreshToken = result.token.refreshToken
                self.onAuthDidFinish?()
            })
            .disposed(by: disposeBag)

        signInResult.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        signInResult.connect()
            .disposed(by: disposeBag)

        signInResult.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)
    }

    private func bindView() {
        rootView.registerButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.registerButtonTapped?()
            })
            .disposed(by: disposeBag)
    }
}
