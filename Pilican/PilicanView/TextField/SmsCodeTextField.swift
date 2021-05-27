import UIKit
import InputMask
import RxSwift

final class SmsCodeTextField: TextField {

    public var codeText: Observable<String> {
        codeTextSubject
    }

    public var isFilled: Observable<Bool> {
        isFilledSubject
    }

    private let listener = MaskedTextFieldDelegate(primaryFormat: "[000000]")
    private let codeTextSubject = PublishSubject<String>()
    private let isFilledSubject = PublishSubject<Bool>()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        delegate = listener
        listener.onMaskedTextChangedCallback = { [weak self] field, _, isFilled in
            guard let text = field.text else {
                return
            }
            self?.codeTextSubject.onNext(text)
            self?.isFilledSubject.onNext(isFilled)
        }
        textContentType = .password
        isSecureTextEntry = true
        placeholder = "******"
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public var isSecureTextEntry: Bool {
        didSet {
            //      let image = isSecureTextEntry ? Images.eyeOff.image : Images.eyeOn.image
            //      secureButton.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
}
