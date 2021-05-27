import UIKit
import RxSwift
import InputMask

final class CVVTextField: TextField {

    public var cardText: Observable<String> {
        textSubject
    }

    public var isFilled: Observable<Bool> {
        isFilledSubject
    }

    private let listener = MaskedTextFieldDelegate(primaryFormat: "[000]")
    private let textSubject = PublishSubject<String>()
    private let isFilledSubject = PublishSubject<Bool>()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        delegate = listener
        listener.onMaskedTextChangedCallback = { [weak self] field, _, isFilled in
            guard let text = field.text else {
                return
            }
            self?.textSubject.onNext(text)
            self?.isFilledSubject.onNext(isFilled)
        }
        placeholder = "***"
        keyboardType = .numberPad
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setValue(text: String) {
        listener.put(text: text, into: self)
    }
}
