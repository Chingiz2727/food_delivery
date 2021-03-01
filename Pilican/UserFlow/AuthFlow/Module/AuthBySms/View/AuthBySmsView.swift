import UIKit

final class AuthBySmsView: UIView {
    let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.medium16
        return button
    }()

    let getSmsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Получить код", for: .normal)
        button.titleLabel?.font = UIFont.medium16
        return button
    }()

    let registerButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSMutableAttributedString(string: "Я новый пользователь,", attributes: [NSAttributedString.Key.font: UIFont.book14!, NSAttributedString.Key.foregroundColor: UIColor.pilicanBlack ])
        
        attributedTitle.append(NSAttributedString(string: " регистрация", attributes: [NSAttributedString.Key.font: UIFont.book14!, NSAttributedString.Key.foregroundColor: UIColor.primary]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()

    let phoneContainer = TextFieldContainer<PhoneNumberTextField>()
    let passwordContainer = TextFieldContainer<PasswordTextField>()

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

    private lazy var authStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [phoneContainer, passwordContainer, getSmsButton, signInButton])
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

    func showPasswordContainer() {
        passwordContainer.isHidden = false
        signInButton.isHidden = false
        getSmsButton.isHidden = true
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
        getSmsButton.snp.makeConstraints { $0.height.equalTo(40) }
    }

    private func configureView() {
        backgroundColor = .background
        phoneContainer.title = " Логин "
        passwordContainer.title = " Код "
        signInButton.backgroundColor = .primary
        signInButton.layer.cornerRadius = 20
        getSmsButton.backgroundColor = .primary
        getSmsButton.layer.cornerRadius = 20
        authStackView.setCustomSpacing(15, after: passwordContainer)
        registerButton.setTitleColor(.primary, for: .normal)
        welcomeLabel.text = "Вход по СМС"
        welcomeDescriptionLabel.text = "Напишите логин чтобы получить смс"
        passwordContainer.isHidden = true
        signInButton.isHidden = true
    }
}
