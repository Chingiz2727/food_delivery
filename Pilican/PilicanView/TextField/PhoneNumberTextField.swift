import UIKit
import RxSwift
import InputMask

final class PhoneNumberTextField: TextField {

    public var phoneText: Observable<String> {
        phoneTextSubject
    }

    public var isFilled: Observable<Bool> {
        isFilledSubject
    }

    private let listener = MaskedTextFieldDelegate(primaryFormat: "+7 [000] [000] [00] [00]")
    private let phoneTextSubject = PublishSubject<String>()
    private let isFilledSubject = PublishSubject<Bool>()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        delegate = listener
        listener.onMaskedTextChangedCallback = { [weak self] field, _, isFilled in
            guard let text = field.text else {
                return
            }
            self?.phoneTextSubject.onNext(
                text.replacingOccurrences(of: " ", with: "")
                    .replacingOccurrences(of: "+", with: "")
            )
            self?.isFilledSubject.onNext(isFilled)
        }
        keyboardType = .numberPad
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setValue(phone: String) {
        listener.put(text: phone, into: self)
    }
}
