import RxSwift
import LocalAuthentication
import UIKit

class CreatePinViewController: ViewController, CreatePinModule, ViewHolder {
    typealias RootViewType = CreatePinView
    var onCodeValidate: Callback?
    private let disposeeBag = DisposeBag()
    private let userSession: UserSessionStorage
    private let pushManager: PushNotificationManager

    init(userSession: UserSessionStorage, pushManager: PushNotificationManager) {
        self.userSession = userSession
        self.pushManager = pushManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }

    override func loadView() {
        view = CreatePinView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pushManager.requestNotificationAuth()
        bindView()
    }
    
    private func bindView() {
        rootView.sendButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                let isEqual = self.rootView.passCodeView.text == self.rootView.repeatCodeView.text
                let isValid = self.rootView.passCodeView.validate() || self.rootView.passCodeView.validate()
                if isEqual == false {
                    self.showErrorAlert(error: .notEqual)
                }
                else if isValid == false {
                    self.showErrorAlert(error: .notValid)
                } else {
                    self.userSession.pin = self.rootView.passCodeView.text
                    self.userSession.isBiometricAuthBeingUsed = true
                    self.onCodeValidate?()
                }
            }).disposed(by: disposeeBag)
    }
    
    private func showErrorAlert(error: PinCodeError) {
        showSimpleAlert(title: "Ошибка", message: error.rawValue)
        rootView.passCodeView.text = nil
        rootView.repeatCodeView.text = nil
    }
}

private enum PinCodeError: String {
    case notValid = "Введите корректный пин"
    case notEqual = "Пин не совпадают"
}
