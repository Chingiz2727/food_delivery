import RxSwift
import UIKit

class PinCheckViewController: ViewController, PinCheckModule, ViewHolder {
    typealias RootViewType = PinCheckView
    
    var onPinSatisfy: OnPinSatisfy?
    var onResetTapp: Callback?
    private let userSession: UserSessionStorage
    private let disposeBag = DisposeBag()
    private let biometricAuthService: BiometricAuthService
    init(userSession: UserSessionStorage, biometricAuthService: BiometricAuthService) {
        self.userSession = userSession
        self.biometricAuthService = biometricAuthService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }

    override func loadView() {
        view = PinCheckView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }
    
    private func bindView() {
        rootView.sendButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                if self.rootView.passCodeView.text == self.userSession.pin {
                    self.onPinSatisfy?()
                } else {
                    self.showSimpleAlert(title: "Ошибка", message: "Неверный пинкод")
                }
            })
            .disposed(by: disposeBag)
        
        if biometricAuthService.canAuthenticate(), userSession.isBiometricAuthBeingUsed {
            biometricAuthService.authenticate(reason: getAuthenticationReason()) { [weak self] (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let auth):
                        if auth {
                            self?.onPinSatisfy?()
                        }
                    case .error(let error):
                        self?.showErrorInAlert(error)
                    }
                }
            }
        }
        rootView.resetButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.onResetTapp?()
            })
            .disposed(by: disposeBag)
    }
    
    private func getAuthenticationReason() -> String {
        switch biometricAuthService.type {
        case .none:
            return ""
        case .touchId:
            return "Touch id"
        case .faceId:
            return "Face id"
        }
    }
}
