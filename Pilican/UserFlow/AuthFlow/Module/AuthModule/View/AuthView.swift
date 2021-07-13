import SnapKit
import UltraDrawerView
import UIKit

final class AuthView: UIView {

    let authBySmsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вход по смс", for: .normal)
        return button
    }()

    let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        return button
    }()

    let registerButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSMutableAttributedString(
            string: "Я новый пользователь,",
            attributes: [
                NSAttributedString.Key.font: UIFont.book14,
                NSAttributedString.Key.foregroundColor: UIColor.pilicanBlack
            ]
        )

        attributedTitle.append(
            NSAttributedString(
                string: " зарегистрироваться",
                attributes: [
                    NSAttributedString.Key.font: UIFont.book14,
                    NSAttributedString.Key.foregroundColor: UIColor.primary]
            )
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()

    let phoneContainer = TextFieldContainer<PhoneNumberTextField>()
    let passwordContainer = TextFieldContainer<PasswordTextField>()

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

    private lazy var smsAuthStackView = UIStackView(arrangedSubviews: [UIView(), authBySmsButton])
    private lazy var authStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [phoneContainer, passwordContainer, smsAuthStackView, signInButton])
        stack.spacing = 30
        stack.axis = .vertical
        return stack
    }()

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
        addSubview(authStackView)
        addSubview(registerButton)

        welcomeStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(10)
            make.leading.trailing.equalToSuperview().inset(30)
        }

        authStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(30)
        }

        registerButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(40)
            $0.height.equalTo(44)
        }

        phoneContainer.snp.makeConstraints { $0.height.equalTo(43) }
        passwordContainer.snp.makeConstraints { $0.height.equalTo(43) }
        signInButton.snp.makeConstraints { $0.height.equalTo(40) }
    }

    private func configureView() {
        backgroundColor = .background
        phoneContainer.title = " Номер телефона "
        passwordContainer.title = " Пароль "
        signInButton.backgroundColor = .primary
        authBySmsButton.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        signInButton.layer.cornerRadius = 20
        signInButton.titleLabel?.font = UIFont.medium16
        authBySmsButton.setTitleColor(.pilicanLightGray, for: .normal)
        authBySmsButton.titleLabel?.font = UIFont.medium12
        authStackView.setCustomSpacing(15, after: passwordContainer)
        registerButton.setTitleColor(.primary, for: .normal)
        welcomeLabel.text = "Добро пожаловать!"
        welcomeLabel.font = UIFont.semibold24
        welcomeLabel.textColor = .pilicanGray
        welcomeDescriptionLabel.text = "Войдите чтобы продолжить"
        welcomeDescriptionLabel.font = UIFont.book14
        welcomeDescriptionLabel.textColor = .pilicanLightGray
    }
}
