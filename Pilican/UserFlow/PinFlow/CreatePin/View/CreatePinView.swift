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
        label.text = "Вы будете использовать это код для входа"
        return label
    }()

    let passCodeView: DPOTPView = {
        let codeView = DPOTPView()
        codeView.count = 4
        codeView.spacing = 10
        codeView.fontTextField = .semibold24
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
    
    let repeatCodeView: DPOTPView = {
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

        repeatCodeView.snp.makeConstraints { make in
            make.top.equalTo(passCodeView.snp.bottom).offset(11)
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
        subTitleLabel.text = "Пин код"
    }
}
