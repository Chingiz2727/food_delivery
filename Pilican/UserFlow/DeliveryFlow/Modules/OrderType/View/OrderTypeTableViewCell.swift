import UIKit

class OrderTypeTableViewCell: UITableViewCell {
    
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.book18
        return label
    }()

    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.book12
        label.textColor = .pilicanGray
        return label
    }()

    let rightButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.arrow.image, for: .normal)
        return button
    }()
    
    private lazy var textStackView = UIStackView(
        views: [titleLabel, subTitleLabel],
        axis: .vertical,
        spacing: 5
    )
    
    private lazy var stackView = UIStackView(
        views: [itemImageView, textStackView, UIView() ,rightButton],
        axis: .horizontal,
        spacing: 10)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitialLayouts()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }
    
    func setup(orderType: OrderType) {
        titleLabel.text = orderType.title
        subTitleLabel.text = orderType.description
        itemImageView.image = orderType.img
    }
    
    private func setupInitialLayouts() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(22)
            make.top.bottom.equalToSuperview().inset(15)
        }
        itemImageView.snp.makeConstraints { $0.size.equalTo(52) }
    }
    
    private func configureView() {
        selectionStyle = .none
    }

}
