import UIKit

class RetailCollectionViewCell: UICollectionViewCell {
    
    private let companyImageView: UIImageView = {
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

    private let adressLabel: UILabel = {
        let label = UILabel()
        label.font = .description2
        label.numberOfLines = 1
        label.textColor = .pilicanLightGray
        return label
    }()

    private let companyTypeLabel: UILabel = {
        let label = UILabel()
        label.font = .description3
        label.numberOfLines = 1
        label.textColor = .primary
        return label
    }()

    private let workStatusView = LabelBackgroundView()

    private let discountView = LabelBackgroundView()

    private lazy var companyInfoVerticalStack = UIStackView(
        views: [companyNameLabel, adressLabel, companyTypeLabel],
        axis: .vertical,
        spacing: 6
    )

    private lazy var priceVerticalStack = UIStackView(
        views: [discountView, UIView(), workStatusView],
        axis: .vertical,
        spacing: 15)

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
        super.layoutSubviews()
        layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setRetail(retail: Retail) {
        companyNameLabel.text = retail.name
        adressLabel.text = retail.address
        discountView.setTitle(title: "\(retail.cashBack) %")
        discountView.configureView(backColor: .primary, textColor: .pilicanWhite)
        companyTypeLabel.text = retail.name
        setupWorkStatusView(retail: retail)
        guard let imgUrl = retail.imgLogo else { return }
        companyImageView.kf.setImage(with: URL(string: imgUrl))
    }

    private func setupWorkStatusView(retail: Retail) {
        if let status = WorkStatus(rawValue: retail.payIsWork) {
        workStatusView.setTitle(title: status.title)
        workStatusView.configureView(backColor: status.backColor, textColor: status.textColor)
        }
    }

    private func setupInitialLayout() {
        addSubview(horizontalStackView)
        addSubview(companyImageView)
        companyImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
        }

        horizontalStackView.snp.makeConstraints { make in
            make.leading.equalTo(companyImageView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
        }
        companyImageView.snp.makeConstraints { $0.size.equalTo(54) }
        let primaryGradient: CAGradientLayer = .primaryGradient
        primaryGradient.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        discountView.layer.insertSublayer(primaryGradient, at: 0)
    }

    private func configureView() {
        backgroundColor = .pilicanWhite
    }
}
