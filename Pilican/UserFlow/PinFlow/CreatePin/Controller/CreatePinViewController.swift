import RxSwift
import LocalAuthentication
import UIKit

class CreatePinViewController: ViewController, CreatePinModule, ViewHolder {
    var closeButton: CloseButton?
    
    typealias RootViewType = CreatePinView
    var onCodeValidate: Callback?
    private let disposeeBag = DisposeBag()
    private let userSession: UserSessionStorage
    private let pushManager: PushNotificationManager
    private let firstPassSubject: PublishSubject<String> = .init()
    private let secondPassSubject: PublishSubject<String> = .init()

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
                self.checkCode()
            }).disposed(by: disposeeBag)
        
        rootView.passCodeView.didFinishCallback = { [unowned self] pin in
                self.rootView.repeatCodeView.layoutIfNeeded()
                self.rootView.repeatCodeView.layoutSubviews()
                self.rootView.repeatCodeView.refreshView()
                self.rootView.repeatCodeView.becomeFirstResponderAtIndex = 0
        }
        
        rootView.passCodeView.didChangeCallback = { [unowned self] passCall in
            self.firstPassSubject.onNext(passCall)
            print(passCall)
        }
        
        rootView.repeatCodeView.didChangeCallback = { [unowned self] passCall in
            self.secondPassSubject.onNext(passCall)
            print(passCall)
        }
        
        Observable.combineLatest(firstPassSubject,secondPassSubject)
            .subscribe(onNext: { [unowned self] firstPin, secondPin in
                if firstPin.count == 4 && secondPin.count == 4 {
                    self.checkCode()
                }
            })
            .disposed(by: disposeeBag)
    }

    private func checkCode() {
        let isEqual = self.rootView.passCodeView.getPin() == self.rootView.repeatCodeView.getPin()
        let isValid = self.rootView.passCodeView.getPin().count == 4 || self.rootView.passCodeView.getPin().count == 4
        if isEqual == false {
            self.showErrorAlert(error: .notEqual)
        }
        else if isValid == false {
            self.showErrorAlert(error: .notValid)
        } else {
            self.userSession.pin = self.rootView.passCodeView.getPin()
            self.userSession.isBiometricAuthBeingUsed = true
            self.showSuccessAlert {
                self.onCodeValidate?()
            }
        }
    }
    
    private func showErrorAlert(error: PinCodeError) {
        showSimpleAlert(title: "Ошибка", message: error.rawValue)
        rootView.passCodeView.clearPin()
        rootView.repeatCodeView.clearPin()
    }
    
    override func customBackButtonDidTap() {
        closeButton?()
    }
}

private enum PinCodeError: String {
    case notValid = "Введите корректный пин"
    case notEqual = "Пин не совпадают"
}
