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
    private let pinType: ChangePinType
    
    init(userSession: UserSessionStorage, pushManager: PushNotificationManager, pinType: ChangePinType = .setPin) {
        self.userSession = userSession
        self.pushManager = pushManager
        self.pinType = pinType
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
        if pinType == .setPin {
            self.rootView.passCodeView.becomeFirstResponderAtIndex = 0
        }
        pushManager.requestNotificationAuth()
        bindView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        HomeTabBarViewController.qrScanButton.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        HomeTabBarViewController.qrScanButton.isHidden = false
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
            self.firstPassSubject.onNext("")
            self.secondPassSubject.onNext("")
        }
        else if isValid == false {
            self.showErrorAlert(error: .notValid)
            self.firstPassSubject.onNext("")
            self.secondPassSubject.onNext("")
        } else {
            self.userSession.pin = self.rootView.passCodeView.getPin()
            self.userSession.isBiometricAuthBeingUsed = true
            self.showSuccessMessageAlert(message: "Пин код успешно сохранен") { [unowned self] in
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
    case notEqual = "Пин код не совпадают"
}

enum ChangePinType {
    case changePin
    case setPin
}
