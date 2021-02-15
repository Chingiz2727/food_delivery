import UIKit

final class RegisterView: UIView {

    let loginContainer = TextFieldContainer<PhoneNumberTextField>()
    let userNameContainer = TextFieldContainer<TextField>()
    let promoCodeContainer = TextFieldContainer<QrCodeTextField>()
    let smsContainer = TextFieldContainer<TextField>()
    let cityContainer = TextFieldContainer<TextField>()

    let registerButton = PrimaryButton()

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

    private lazy var textFielContainerStack = UIStackView(
        views: [loginContainer, userNameContainer, cityContainer, promoCodeContainer, smsContainer],
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

    private func setupInitialLayout() {
        addSubview(welcomeStackView)
        addSubview(textFielContainerStack)
        addSubview(registerButton)

        welcomeStackView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(30)
        }

        textFielContainerStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.centerY.equalToSuperview()
        }

        registerButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(44)
            make.bottom.equalToSuperview().inset(30)
        }

        textFielContainerStack.arrangedSubviews.forEach {
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
        backgroundColor = .background
    }
}
