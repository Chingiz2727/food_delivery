import UIKit

final class RegisterView: UIView {

    let loginContainer = TextFieldContainer<PhoneNumberTextField>()
    let userNameContainer = TextFieldContainer<TextField>()
    let promoCodeContainer = TextFieldContainer<QrCodeTextField>()
    let smsContainer = TextFieldContainer<SmsCodeTextField>()
    let cityContainer = TextFieldContainer<TextField>()

    let registerButton = PrimaryButton()
    let sendSmsButton = PrimaryButton()

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semibold24
        label.textColor = .pilicanGray
        return label
    }()

    private let welcomeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.book14
        label.textColor = .pilicanLightGray
        return label
    }()

    private lazy var welcomeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [welcomeLabel, welcomeDescriptionLabel])
        stack.spacing = 4
        stack.axis = .vertical
        return stack
    }()

    private lazy var textFieldContainerStack = UIStackView(
        views: [loginContainer, userNameContainer, cityContainer, promoCodeContainer],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 20)

    private lazy var buttonContainerStack = UIStackView(
        views: [registerButton, sendSmsButton],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 20)

    private let promoDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.book10
        label.text = "Сканируй QR код друга и получи 500 бонусов"
        label.textColor = .pilicanLightGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }
    

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setViewStatus(status: RegistrationStatus) {
        switch status {
        case .getSMS:
            smsContainer.isHidden = true
            sendSmsButton.isHidden = false
            registerButton.isHidden = true
        case .register:
            smsContainer.isHidden = false
            sendSmsButton.isHidden = true
            registerButton.isHidden = false
        }
    }

    private func setupInitialLayout() {
        let scrollView = UIScrollView()
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.leading.trailing.width.equalTo(self)
            $0.bottom.equalToSuperview().inset(100)
        }
        
        scrollView.addSubview(welcomeStackView)
        scrollView.addSubview(textFieldContainerStack)
        scrollView.addSubview(buttonContainerStack)
        scrollView.addSubview(promoDescription)
        scrollView.addSubview(smsContainer)
        promoDescription.snp.makeConstraints { make in
            make.leading.trailing.equalTo(promoCodeContainer)
            make.top.equalTo(promoCodeContainer.snp.bottom).offset(3)
        }
        
        welcomeStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(30)
            make.top.equalToSuperview().inset(30)
        }

        textFieldContainerStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(30)
            make.top.equalTo(welcomeStackView.snp.bottom).offset(50)
        }

        smsContainer.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(30)
            make.top.equalTo(textFieldContainerStack.snp.bottom).offset(30)
            make.height.equalTo(40)
        }
        
        buttonContainerStack.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(30)
            make.top.equalTo(smsContainer.snp.bottom).offset(30)
        }

        
        buttonContainerStack.arrangedSubviews.forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(44)
            }
        }

        textFieldContainerStack.arrangedSubviews.forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(40)
            }
        }
        
    }

    private func configureView() {
        loginContainer.title = " Номер телефона "
        userNameContainer.title = " Имя "
        cityContainer.title = " Город "
        promoCodeContainer.title = " Промо код (не обязательно) "
        smsContainer.title = " Смс Код "
        welcomeLabel.text = "Cоздать учетную запись"
        welcomeDescriptionLabel.text = "Зарегистрируйтесь, чтобы начать"
        registerButton.setTitle("Регистрация", for: .normal)
        sendSmsButton.setTitle("Получить смс", for: .normal)
        registerButton.isHidden = true
        smsContainer.isHidden = true
        sendSmsButton.isEnabled = false
        backgroundColor = .background
    }
}
