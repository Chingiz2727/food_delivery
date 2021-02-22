import UIKit

final class RegisterView: UIView {

    let loginContainer = TextFieldContainer<PhoneNumberTextField>()
    let userNameContainer = TextFieldContainer<TextField>()
    let promoCodeContainer = TextFieldContainer<QrCodeTextField>()
    let smsContainer = TextFieldContainer<TextField>()
    let cityContainer = TextFieldContainer<TextField>()

    let registerButton = PrimaryButton()
    let sendSmsButton = PrimaryButton()

    private let welcomeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let welcomeDescriptionLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var welcomeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [welcomeLabel, welcomeDescriptionLabel])
        stack.spacing = 4
        stack.axis = .vertical
        return stack
    }()

    private lazy var textFieldContainerStack = UIStackView(
        views: [loginContainer, userNameContainer, cityContainer, promoCodeContainer, smsContainer],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 20)

    private lazy var buttonContainerStack = UIStackView(
        views: [registerButton, sendSmsButton],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 20)

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
        addSubview(welcomeStackView)
        addSubview(textFieldContainerStack)
        addSubview(buttonContainerStack)

        welcomeStackView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(30)
        }

        textFieldContainerStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.centerY.equalToSuperview()
        }

        buttonContainerStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(30)
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
        loginContainer.title = "Логин"
        userNameContainer.title = "Ф.И.О"
        cityContainer.title = "Город"
        promoCodeContainer.title = "Промо"
        smsContainer.title = "СМС Код"
        welcomeLabel.text = "Cоздать учетную запись"
        welcomeDescriptionLabel.text = "Зарегистрируйтесь, чтобы начать"
        registerButton.setTitle("Регистрация", for: .normal)
        sendSmsButton.setTitle("Получить смс", for: .normal)
        registerButton.isHidden = true
        smsContainer.isHidden = true
        backgroundColor = .background
    }
}
