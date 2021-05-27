import UIKit
import RxSwift

final class PasswordTextField: TextField {

    private let secureButton: UIButton = {
        let button = UIButton()
        //    button.setImage(Images.eyeOn.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        return button
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        secureButton.addTarget(self, action: #selector(toggleSecureEntry), for: .touchUpInside)
        textContentType = .password
        isSecureTextEntry = true
        placeholder = "******"
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        addSubview(secureButton)
        secureButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
        }
    }

    @objc private func toggleSecureEntry() {
        isSecureTextEntry.toggle()
        if let textRange = textRange(from: beginningOfDocument, to: endOfDocument) {
            replace(textRange, withText: text!)
        }
    }

    override public var isSecureTextEntry: Bool {
        didSet {
            //      let image = isSecureTextEntry ? Images.eyeOff.image : Images.eyeOn.image
            //      secureButton.setImage(image?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        return CGRect(
            x: superRect.origin.x,
            y: 0,
            width: superRect.width - secureButton.frame.width,
            height: superRect.height
        )
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.editingRect(forBounds: bounds)
        return CGRect(
            x: superRect.origin.x,
            y: 0,
            width: superRect.width - secureButton.frame.width,
            height: superRect.height
        )
    }
}
