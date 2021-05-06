import UIKit
import SVPinView

final class PinCheckView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .semibold24
        label.text = "Введите PIN"
        label.textAlignment = .center
        return label
    }()

    let passCodeView: SVPinView = {
        let codeView = SVPinView()
        codeView.pinLength = 4
        codeView.interSpace = 20
        codeView.font = .semibold20
        codeView.shouldSecureText = true
        codeView.allowsWhitespaces = false
        codeView.borderLineThickness = 0
        codeView.fieldCornerRadius = 16
        codeView.shouldDismissKeyboardOnEmptyFirstField = false
        codeView.fieldBackgroundColor = .primary
        codeView.activeFieldBackgroundColor = .white
        codeView.deleteButtonAction = .deleteCurrentAndMoveToPrevious
        codeView.activeFieldCornerRadius = 16
        codeView.activeBorderLineColor = .primary
        codeView.becomeFirstResponderAtIndex = 0
        codeView.keyboardAppearance = .light
        codeView.secureCharacter = "\u{25CF}"
        codeView.textColor = .white
        return codeView
    }()

    let resetButton: UIButton = {
        let button = UIButton()
        button.setTitle("Восстановить пин", for: .normal)
        button.setTitleColor(.primary, for: .normal)
        return button
    }()

    let sendButton = PrimaryButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupInitialLayout() {
        addSubview(titleLabel)
        addSubview(passCodeView)
        addSubview(sendButton)
        addSubview(resetButton)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        passCodeView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(50)
            make.height.equalTo(50)
        }

        resetButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passCodeView.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        sendButton.snp.makeConstraints  { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(40)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }

    private func configureView() {
        backgroundColor = .background
        titleLabel.text = "Введите пин"
        sendButton.setTitle("Войти", for: .normal)
    }
}
