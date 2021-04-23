import UIKit
import RxSwift
import InputMask

final class CardNumberTextField: TextField {
    
    let scanButton: UIButton = {
        let button = UIButton()
        //    button.setImage(Images.eyeOn.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(Images.scanIcon.image, for: .normal)
        button.isHidden = true
        return button
    }()
    public var cardText: Observable<String> {
        textSubject
    }

    public var isFilled: Observable<Bool> {
        isFilledSubject
    }

    private let listener = MaskedTextFieldDelegate(primaryFormat: "[0000] [0000] [0000] [0000]")
    private let textSubject = PublishSubject<String>()
    private let isFilledSubject = PublishSubject<Bool>()

    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        delegate = listener
        listener.onMaskedTextChangedCallback = { [weak self] field, _, isFilled in
            guard let text = field.text else {
                return
            }
            self?.textSubject.onNext(
                text.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespaces)
            )
            self?.isFilledSubject.onNext(isFilled)
        }
        keyboardType = .numberPad
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setValue(text: String) {
        listener.put(text: text, into: self)
    }
    
    private func setupInitialLayout() {
        addSubview(scanButton)
        scanButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
        if #available(iOS 13.0,*) {
            scanButton.isHidden = false
        }
    }
}
