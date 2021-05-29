import UIKit

final class DeliveryRetailListTableViewCell: UITableViewCell {

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
    
    let dontWorkLabel: UILabel = {
        let label = UILabel()
        label.text = "Временно не работает"
        label.font = .semibold24
        label.textAlignment = .center
        label.backgroundColor = .retailStatus
        label.layer.zPosition = 1
        label.isHidden = true
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        return label
    }()

    let closedLabel: UILabel = {
        let label = UILabel()
        label.text = "Закрыто"
        label.font = .semibold24
        label.layer.zPosition = 1
        label.textAlignment = .center
        label.backgroundColor = .retailStatus
        label.isHidden = true
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        return label
    }()

    private let workStatusView = LabelBackgroundView()

    private let discountView = LabelBackgroundView()

    private lazy var companyInfoVerticalStack = UIStackView(
        views: [UIView(), UIView(), companyNameLabel, adressLabel, UIView()],
        axis: .vertical,
        spacing: 6
    )

    private lazy var priceVerticalStack = UIStackView(
        views: [discountView, UIView(), workStatusView],
        axis: .vertical,
        spacing: 15)

    private lazy var horizontalStackView = UIStackView(
        views: [companyInfoVerticalStack, UIView()],
        axis: .horizontal,
        spacing: 8)

    private let dataView = UIView()

    private let closedView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitialLayout()
        configureView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dataView.layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setRetail(retail: DeliveryRetail) {
        companyNameLabel.text = retail.name
        adressLabel.text = retail.address
        discountView.setTitle(title: "\(retail.dlvCashBack) %")
        discountView.configureView(backColor: .primary, textColor: .pilicanWhite)
        setupWorkStatusView(retail: retail)
        guard let imgUrl = retail.imgLogo else { return }
        companyImageView.kf.setImage(with: URL(string: imgUrl))
        if retail.isWork == 0 {
            closedLabel.isHidden = false
            isUserInteractionEnabled = false
        } else {
            closedLabel.isHidden = true
            isUserInteractionEnabled = true
        }
        if retail.status == 2 {
            dontWorkLabel.isHidden = false
            self.isUserInteractionEnabled = false
        } else {
            dontWorkLabel.isHidden = true
            isUserInteractionEnabled = true
        }
    }

    private func setupWorkStatusView(retail: DeliveryRetail) {
        if let status = WorkStatus(rawValue: retail.isWork) {
        workStatusView.setTitle(title: status.title)
        workStatusView.configureView(backColor: status.backColor, textColor: status.textColor)
        }
    }

    private func setupInitialLayout() {
        dataView.addSubview(dontWorkLabel)
        dontWorkLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        dataView.addSubview(closedLabel)
        closedLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        addSubview(dataView)
        dataView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
        }

        dataView.addSubview(horizontalStackView)
        dataView.addSubview(companyImageView)
        dataView.addSubview(discountView)
        dataView.addSubview(workStatusView)
        
        discountView.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(10)
        }
        
        workStatusView.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview().inset(10)
        }
        
        companyImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
        }

        horizontalStackView.snp.makeConstraints { make in
            make.leading.equalTo(companyImageView.snp.trailing).offset(10)
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalTo(workStatusView.snp.leading).offset(-10)
        }

        companyImageView.snp.makeConstraints { $0.size.equalTo(54) }
    }

    private func configureView() {
        dataView.backgroundColor = .pilicanWhite
        backgroundColor = .background
        selectionStyle = .none
    }
}
