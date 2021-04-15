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
        label.font = .book16
        label.textColor = .pilicanGray
        label.textAlignment = .center
        return label
    }()
    
    private let containerView = UIView()

    private let payChoiceCashbackLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.book10
        return label
    }()
    
    private let bonusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let choiceSwitch: UISwitch = {
        let choiceSwitch = UISwitch()
        choiceSwitch.isOn = false
        choiceSwitch.onTintColor = .primary
        return choiceSwitch
    }()

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

    private func setupInitialLayouts() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.bottom.right.equalToSuperview().inset(10)
        }

        containerView.addSubview(payChoiceTitleLabel)
        payChoiceTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(15)
        }

        containerView.addSubview(payChoiceCashbackLabel)
        payChoiceCashbackLabel.snp.makeConstraints { (make) in
            make.top.equalTo(payChoiceTitleLabel.snp.bottom).offset(1)
            make.bottom.equalToSuperview().inset(5)
            make.left.equalToSuperview().inset(15)
        }

        containerView.addSubview(choiceSwitch)
        choiceSwitch.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }

    private func configureView() {
        containerView.backgroundColor = .background
        backgroundColor = .white
        containerView.layer.cornerRadius = 8
    }
}
