import UIKit

class RetailTableViewCell: UITableViewCell {
    
    private let companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
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
        views: [discountView, workStatusView],
        axis: .vertical,
        spacing: 15)

    private lazy var horizontalStackView = UIStackView(
        views: [companyImageView, companyInfoVerticalStack, priceVerticalStack],
        axis: .horizontal,
        spacing: 8)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitialLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setRetail(retail: Retail) {
        companyNameLabel.text = retail.name
        adressLabel.text = retail.address
        discountView.setTitle(title: "\(retail.cashBack)")
        companyTypeLabel.text = retail.name
        guard let imgUrl = retail.imgLogo else { return }
        companyImageView.kf.setImage(with: URL(string: imgUrl))
    }

    private func setupInitialLayout() {
        addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(12) }
        companyImageView.snp.makeConstraints { $0.size.equalTo(70) }
        selectionStyle = .none
    }
}
