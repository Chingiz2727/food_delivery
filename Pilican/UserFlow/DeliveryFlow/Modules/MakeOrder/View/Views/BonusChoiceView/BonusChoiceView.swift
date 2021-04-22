import UIKit

class BonusChoiceView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .semibold20
        label.textColor = .black
        label.text = "Потратить бонусы"
        return label
    }()
    
    private let payChoiceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Мои бонусы"
        label.font = .book12
        label.textColor = .pilicanGray
        label.textAlignment = .left
        return label
    }()
    
    private let containerView = UIView()

    private let payChoiceCashbackLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.book16
        label.textAlignment = .left
        return label
    }()
    
    private let bonusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Images.tenge.image
        return imageView
    }()
    
    let choiceSwitch: UISwitch = {
        let choiceSwitch = UISwitch()
        choiceSwitch.isOn = false
        choiceSwitch.onTintColor = .primary
        return choiceSwitch
    }()

    private lazy var textStackView = UIStackView(
        views: [payChoiceTitleLabel, payChoiceCashbackLabel],
        axis: .vertical,
        spacing: 2)

    private lazy var horizontalStackView = UIStackView(
        views: [bonusImageView, UIView(), textStackView, UIView(), UIView(), choiceSwitch],
        axis: .horizontal,
        distribution: .equalSpacing,
        spacing: 10)

    private let bonusDecreaseTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .medium12
        label.text = "Будет списано:"
        return label
    }()

    private let cashTitleView = LabelBackgroundView()

    private let cashTitleDescription: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .medium12
        label.text = "с карты"
        return label
    }()

    let plusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .medium12
        label.text = "+"
        return label
    }()

    let bonusSpendTitleView = LabelBackgroundView()

    let bonusDescription: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .medium12
        label.text = "балл"
        return label
    }()

    private lazy var cashStack = UIStackView(
        views: [cashTitleView, cashTitleDescription],
        axis: .vertical,
        spacing: 3)

    private lazy var bonusStack = UIStackView(
        views: [bonusSpendTitleView, bonusDescription],
        axis: .vertical,
        spacing: 3)

    private lazy var horizontalSpendStack = UIStackView(
        views: [UIView(), UIView(), cashStack, plusLabel, bonusStack, UIView(), UIView()],
        axis: .horizontal,
        distribution: .equalSpacing,
        spacing: 10)

    lazy var fullPayBonusStackView = UIStackView(
        views: [bonusDecreaseTitle, horizontalSpendStack],
        axis: .vertical,
        spacing: 10)

    lazy var mainStackView = UIStackView(
        views: [titleLabel, containerView, fullPayBonusStackView],
        axis: .vertical,
        spacing: 10)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }

    func setData(cashback: String) {
        let attributedText = NSMutableAttributedString(string: "Накоплено", attributes: [NSMutableAttributedString.Key.foregroundColor: UIColor.pilicanBlack])
        // swiftlint:disable line_length
        attributedText.append(NSAttributedString(string: " \(cashback)", attributes: [NSMutableAttributedString.Key.foregroundColor: UIColor.primary, NSMutableAttributedString.Key.font: UIFont.semibold16]))

        attributedText.append(NSAttributedString(string: " Б.", attributes: [NSMutableAttributedString.Key.foregroundColor: UIColor.pilicanBlack]))
        payChoiceCashbackLabel.attributedText = attributedText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupBonus(bonus: Double) {
        bonusSpendTitleView.setTitle(title: "\(bonus)")
    }

    func setupSpendedMoney(money: Double) {
        cashTitleView.setTitle(title: "\(money)")
    }

    private func setupInitialLayouts() {
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.bottom.right.equalToSuperview().inset(10)
        }

        containerView.addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }

    private func configureView() {
        containerView.backgroundColor = .background
        backgroundColor = .white
        containerView.layer.cornerRadius = 8
        bonusSpendTitleView.backgroundColor = .primary
        cashTitleView.backgroundColor = .background
        layer.cornerRadius = 10
    }
}
