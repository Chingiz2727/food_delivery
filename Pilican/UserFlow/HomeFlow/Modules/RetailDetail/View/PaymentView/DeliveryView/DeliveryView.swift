import UIKit

final class DeliveryView: UIControl {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanBlack
        label.font = .description2
        label.text = "Здесь есть онлайн"
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .left
        return label
    }()

    private let discountTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanBlack
        label.font = .description3
        label.textAlignment = .left
        label.text = "Доставка"
        return label
    }()

    private let discountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanWhite
        label.font = .description2
        label.textAlignment = .center
        label.text = "15%"
        return label
    }()

    private let cashbackLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanWhite
        label.font = .description3
        label.textAlignment = .center
        label.text = "кэшбек"
        return label
    }()

    private lazy var stackView = UIStackView(
        views: [titleLabel, discountTitleLabel],
        axis: .vertical,
        spacing: 2)

    private lazy var cashBackStackView = UIStackView(
        views: [discountLabel, cashbackLabel],
        axis: .vertical,
        spacing: 2)

    private let imageBackView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = Images.deliveryBakcground.image
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        backgroundColor = .pilicanWhite
    }

    override func layoutSubviews() {
        layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setData(retail: Retail) {
        discountLabel.text = "\(retail.dlvCashBack)"
    }

    private func setupInitialLayout() {
        addSubview(stackView)
        addSubview(imageBackView)
        imageBackView.addSubview(cashBackStackView)

        imageBackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(60)
        }

        cashBackStackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(5) }

        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview().inset(10)
            make.trailing.equalTo(cashBackStackView.snp.leading).offset(-10)
        }
    }
}
