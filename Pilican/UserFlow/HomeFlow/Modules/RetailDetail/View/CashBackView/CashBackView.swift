import UIKit

final class CashBackView: UIView {
    private let backView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.gradRectangle.image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanWhite
        label.font = .description1
        label.text = "5000 тг\ncредний чек:"
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()

    private let cashBackLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanWhite
        label.font = .description1
        label.text = "1000 тг\nкэшбэк"
        label.numberOfLines = 2
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let firstArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.ArrowCashBack.image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let secondArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.ArrowCashBack.image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let silverLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Images.silverLogo.image
        return imageView
    }()

    private lazy var stackView = UIStackView(
        views: [costLabel, firstArrow, silverLogoImageView, secondArrow, cashBackLabel],
        axis: .horizontal,
        distribution: .equalSpacing,
        spacing: 15
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func layoutSubviews() {
        layer.cornerRadius = 10
    }

    private func setupInitialLayout() {
        addSubview(backView)
        backView.addSubview(stackView)
        backView.snp.makeConstraints { $0.edges.equalToSuperview() }
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }

    func setData(retail: Retail) {
        costLabel.text = "\(retail.avgAmount ?? "1") тг\ncредний чек"
        cashBackLabel.text = "\(calculateCashback(cashback: retail.cashBack, avgAmount: retail.avgAmount ?? "1")) тг\nкэшбэк"
    }

    private func calculateCashback(cashback: Int, avgAmount: String) -> Int {
        let div = Double(cashback) / 100.0
        let averageAmount = avgAmount == "" ? "1" : avgAmount
        let cash = Int(div * (Double(averageAmount) ?? 1))
        return cash
    }
}
