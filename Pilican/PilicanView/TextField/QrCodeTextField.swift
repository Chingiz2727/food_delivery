import UIKit
import RxSwift

final class QrCodeTextField: TextField {

    let qrButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.qrCode.image, for: .normal)
        return button
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        addSubview(qrButton)
        qrButton.snp.makeConstraints { make in
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

    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        return CGRect(
            x: superRect.origin.x,
            y: 0,
            width: superRect.width - qrButton.frame.width,
            height: superRect.height
        )
    }

    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.editingRect(forBounds: bounds)
        return CGRect(
            x: superRect.origin.x,
            y: 0,
            width: superRect.width - qrButton.frame.width,
            height: superRect.height
        )
    }
}
