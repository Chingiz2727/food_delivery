import RxSwift
import UIKit

class AuthBySmsViewController: ViewController, AuthBySmsModule, ViewHolder {
    typealias RootViewType = AuthBySmsView

    var onAuthDidFinish: Callback?

    private let viewModel: AuthBySmsViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: AuthBySmsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
            .subscribe(onNext: { [unowned self] _ in
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
}
