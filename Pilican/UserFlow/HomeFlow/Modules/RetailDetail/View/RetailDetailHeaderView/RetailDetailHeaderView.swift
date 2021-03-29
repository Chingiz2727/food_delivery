import Cosmos
import UIKit

final class RetailDetailHeaderView: UIView {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 27
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()

    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = .heading2
        label.textColor = .pilicanBlack
        label.numberOfLines = 1
        return label
    }()

    private let companyAdressLabel: UILabel = {
        let label = UILabel()
        label.font = .description2
        label.numberOfLines = 1
        label.textColor = .pilicanLightGray
        return label
    }()

    private let ratingView: CosmosView = {
        let ratingView = CosmosView()
        ratingView.settings.totalStars = 5
        ratingView.settings.updateOnTouch = false
        ratingView.settings.emptyImage = Images.emptyStar.image
        ratingView.settings.filledImage = Images.filledStar.image
        return ratingView
    }()

    private let workStatusView = LabelBackgroundView()

    private let discountView = LabelBackgroundView()

    private lazy var companyInfoVerticalStack = UIStackView(
        views: [companyNameLabel, companyAdressLabel, ratingView],
        axis: .vertical,
        spacing: 6
    )

    private lazy var priceVerticalStack = UIStackView(
        views: [discountView, UIView(), workStatusView],
        axis: .vertical,
        spacing: 10)

    private lazy var horizontalStackView = UIStackView(
        views: [companyInfoVerticalStack, UIView(), priceVerticalStack],
        axis: .horizontal,
        spacing: 8)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }

    override func layoutSubviews() {
        layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setRetail(retail: Retail) {
        companyNameLabel.text = retail.name
        companyAdressLabel.text = retail.address
        discountView.setTitle(title: "\(retail.cashBack) %")
        discountView.configureView(backColor: .primary, textColor: .pilicanWhite)
        setupWorkStatusView(retail: retail)
        guard let imgUrl = retail.imgLogo else { return }
        logoImageView.kf.setImage(with: URL(string: imgUrl))
        ratingView.rating = retail.rating
    }

    private func setupWorkStatusView(retail: Retail) {
        if let status = WorkStatus(rawValue: retail.payIsWork) {
        workStatusView.setTitle(title: status.title)
        workStatusView.configureView(backColor: status.backColor, textColor: status.textColor)
        }
    }

    private func setupInitialLayout() {
        addSubview(horizontalStackView)
        addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
        }

        horizontalStackView.snp.makeConstraints { make in
            make.leading.equalTo(logoImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
        }
        logoImageView.snp.makeConstraints { $0.size.equalTo(54) }
        let primaryGradient: CAGradientLayer = .primaryGradient
        primaryGradient.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        discountView.layer.insertSublayer(primaryGradient, at: 0)
    }

    private func configureView() {
        backgroundColor = .pilicanWhite
    }
}
