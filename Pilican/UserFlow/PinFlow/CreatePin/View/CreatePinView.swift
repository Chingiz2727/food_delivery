import SVPinView
import UIKit

final class CreatePinView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .semibold24
        label.text = "Создать PIN код"
        label.textAlignment = .center
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .medium14
        label.textAlignment = .center
        label.text = "Вы будете использовать этоn пин код для входа"
        return label
    }()

    private let repeatitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .medium14
        label.textAlignment = .center
        label.text = "Повторите пин код"
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
        codeView.shouldDismissKeyboardOnEmptyFirstField = true
        codeView.pinInputAccessoryView = UIView()
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
    
    let repeatCodeView: SVPinView = {
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
        
        codeView.keyboardAppearance = .light
        codeView.secureCharacter = "\u{25CF}"
        codeView.textColor = .white
        return codeView
    }()

    let sendButton = PrimaryButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitilLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupInitilLayout() {
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(sendButton)
        addSubview(passCodeView)
        addSubview(repeatCodeView)
        addSubview(repeatitleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(23)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(23)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        passCodeView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(245)
            make.height.equalTo(52)
        }

        repeatitleLabel.snp.makeConstraints { make in
            make.top.equalTo(passCodeView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        repeatCodeView.snp.makeConstraints { make in
            make.top.equalTo(repeatitleLabel.snp.bottom).offset(11)
            make.width.equalTo(245)
            make.centerX.equalToSuperview()
            make.height.equalTo(52)
        }

        sendButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
        }
    }

    private func configureView() {
        backgroundColor = .white
        sendButton.setTitle("Создать PIN", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        titleLabel.text = "Создайте пин код"
    }
}
