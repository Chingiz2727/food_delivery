import UIKit

final class PinCheckView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .semibold24
        label.text = "Введите PIN"
        label.textAlignment = .center
        return label
    }()

    let passCodeView: DPOTPView = {
        let codeView = DPOTPView()
        codeView.count = 4
        codeView.spacing = 10
        codeView.fontTextField = .semibold20
        codeView.dismissOnLastEntry = true
        codeView.isSecureTextEntry = true
        codeView.borderWidthTextField = 0.5
        codeView.cornerRadiusTextField = 16
        codeView.isCursorHidden = true
        codeView.backGroundColorTextField = .primary
        codeView.borderColorTextField = .white
        codeView.selectedBorderColorTextField = .white
        codeView.textColorTextField = .white
        _ = codeView.becomeFirstResponder()
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
